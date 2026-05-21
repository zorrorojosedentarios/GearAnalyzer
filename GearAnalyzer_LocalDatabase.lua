-- ============================================================
-- GearAnalyzer: LocalDatabase (Módulo de Gestión de Datos)
-- Maneja la persistencia y validación de IDs para NaerZone
-- ============================================================

local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local DB = GearAnalyzer:NewModule("LocalDatabase")

-- Función para Resetear la base de datos sincronizada
-- Esto borra los accommodatedIDs pero MANTIENE los customOverrides manuales
function DB:ResetServerSync()
    local global = GearAnalyzer.db.global
    -- Vaciamos la base de datos de encantamientos
    wipe(global.EnchantDatabase)
    global.EnchantDatabase._version = 0 -- Forzar repoblación en el próximo inicio
    
    -- Limpiar temporales del escáner
    if global.ServerDatabase then
        wipe(global.ServerDatabase.enchantMappings or {})
    end
        
    print("|cff3fc7ebGearAnalyzer:|r Base de datos reiniciada y restaurada desde Master DB.")
    
    -- Reconstruir el mapeo activo
    GearAnalyzer:BuildActiveMapping()
    
    -- FORZAR RELOAD PARA GUARDAR CAMBIOS EN DISCO
    StaticPopupDialogs["GA_RELOAD_REQUIRED"] = {
        text = "Base de datos reiniciada correctamente.\nEs necesario recargar la interfaz para guardar los cambios.",
        button1 = "Recargar Ahora",
        OnAccept = function()
            ReloadUI()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = false,
        preferredIndex = 3,
    }
    StaticPopup_Show("GA_RELOAD_REQUIRED")
end

-- Función para Borrar TODO (Total Reset)
function DB:HardReset()
    local global = GearAnalyzer.db.global
    global.EnchantDatabase = {}
    global.ServerDatabase = {
        enchantMappings = {}
    }
    global.customOverrides = {
        enchants = {},
        gems = {},
        glyphs = {},
        caps = {}
    }
    print("|cffff0000GearAnalyzer:|r RESET TOTAL. Todos los cambios manuales y sincronizaciones borrados.")
    
    GearAnalyzer:BuildActiveMapping()
    GearAnalyzer:FullReload()
end

-- Script de Verificación de Integridad
function DB:VerifyIntegrity()
    print("|cff3fc7ebGearAnalyzer:|r Iniciando verificación de integridad...")
    local issues = 0
    
    -- 1. Verificar registros huérfanos o corruptos
    local global = GearAnalyzer.db.global
    if global.EnchantDatabase then
        for id, data in pairs(global.EnchantDatabase) do
            if id ~= "_version" and (not data.name or data.name == "") then
                print("|cffffa500Aviso:|r Registro corrupto detectado (ID: "..id.."). Eliminando...")
                global.EnchantDatabase[id] = nil
                issues = issues + 1
            end
        end
    end
    
    -- 2. Verificar customOverrides
    if global.customOverrides and global.customOverrides.enchants then
        for key, val in pairs(global.customOverrides.enchants) do
            if not tonumber(val) or tonumber(val) == 0 then
                print("|cffffa500Aviso:|r Override inválido detectado para " .. key .. ". Limpiando...")
                global.customOverrides.enchants[key] = nil
                issues = issues + 1
            end
        end
    end
    
    if issues == 0 then
        print("|cff00ff00Verificación finalizada:|r Base de datos íntegra.")
    else
        print("|cffffff00Verificación finalizada:|r Se corrigieron " .. issues .. " problemas detectados.")
        GearAnalyzer:BuildActiveMapping()
    end
end

-- Hook para asegurar que BuildActiveMapping siempre tenga prioridad
function GearAnalyzer:UpdateLocalDatabase()
    DB:VerifyIntegrity()
    self:BuildActiveMapping()
end
