-- ============================================================
-- GearAnalyzer Server Sync Logic (VERSION SIMPLE - SIN VALIDACION)
-- ============================================================

local scanTooltip = CreateFrame("GameTooltip", "GA_ScanTooltip", nil, "GameTooltipTemplate")
scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

-- Normalizador básico
local function Normalize(text)
    if not text then return "" end
    text = text:lower()
    local replacements = {["á"]="a", ["é"]="e", ["í"]="i", ["ó"]="o", ["ú"]="u", ["ñ"]="n"}
    for k, v in pairs(replacements) do text = text:gsub(k, v) end
    text = text:gsub("[^a-z0-9]", "")
    return text
end

function GearAnalyzer:BuildManualIdentityMap(profFilter)
    self.manualPatterns = {}
    local total = 0
    if not GA_PROF_ENCHANTS then return 0 end

    -- profFilter puede ser un string solo o una tabla de strings { "ENCANTAMIENTO", "PELETERIA" }
    local filters = {}
    if type(profFilter) == "string" then
        filters[profFilter] = true
    elseif type(profFilter) == "table" then
        for _, v in ipairs(profFilter) do filters[v] = true end
    end

    for profKey, categories in pairs(GA_PROF_ENCHANTS) do
        -- Si hay filtros y esta profesión no está en ellos, saltar
        if not profFilter or filters[profKey] then
            for cat, items in pairs(categories) do
                if type(items) == "table" then
                    for _, item in ipairs(items) do
                        if item.name then
                            local entry = { 
                                name = item.name, 
                                prof = profKey, 
                                pattern = Normalize(item.pattern or item.normalized or item.name)
                            }
                            table.insert(self.manualPatterns, entry)
                            total = total + 1
                        end
                    end
                end
            end
        end
    end

    -- AGREGAR TAMBIÉN LAS GEMAS DE LA BASE DE DATOS MAESTRA
    if self.EnchantMasterDB then
        for id, data in pairs(self.EnchantMasterDB) do
            local isGem = data.color and (data.color == "red" or data.color == "yellow" or data.color == "blue" or 
                          data.color == "orange" or data.color == "purple" or data.color == "green" or 
                          data.color == "prismatic" or data.color == "meta")
            
            if not profFilter or (filters["JOYERIA"] and isGem) then
                -- Patrón por Nombre
                table.insert(self.manualPatterns, { 
                    name = data.name, 
                    prof = "MASTER", 
                    pattern = Normalize(data.name) 
                })
                -- NUEVO: Patrón por Estadísticas (Crucial para gemas equipadas)
                if data.stats then
                    table.insert(self.manualPatterns, {
                        name = data.name,
                        prof = "MASTER_STATS",
                        pattern = Normalize(data.stats)
                    })
                end
                total = total + 1
            end
        end
    end

    if GearAnalyzer.db.profile.settings.devMode then
        print("|cffffff00[GA Loader]:|r Cargados " .. total .. " patrones para " .. (profFilter and (type(profFilter) == "table" and table.concat(profFilter, ", ") or profFilter) or "TODAS")..".")
    end
    return total
end

function GearAnalyzer:RunUnifiedScan(startID, endID, profFilter)
    local actualEndID = endID or (profFilter == "JOYERIA" and 45000 or 5000)
    local patternsLoaded = self:BuildManualIdentityMap(profFilter)
    if patternsLoaded == 0 then 
        self:LogScan("|cffff0000GearAnalyzer:|r No hay patrones cargados para este escaneo.")
        return 
    end

    self:ShowScannerWindow()
    self:LogScan("|cff00ff00GearAnalyzer:|r Iniciando escaneo filtrado ("..patternsLoaded.." patrones)...")
    self:LogScan("Rango: " .. (startID or 1) .. " - " .. actualEndID)

    -- Limpieza de basura
    local global = GearAnalyzer.db.global
    if global.ServerDatabase and global.ServerDatabase.enchantMappings then
        local filters = {}
        if type(profFilter) == "string" then filters[profFilter] = true
        elseif type(profFilter) == "table" then for _, v in ipairs(profFilter) do filters[v] = true end end

        for id, info in pairs(global.ServerDatabase.enchantMappings) do
            if info.prof == "RAW_DATA" or filters[info.prof] then
                global.ServerDatabase.enchantMappings[id] = nil
            end
        end
    end

    global.ServerDatabase = global.ServerDatabase or {}
    global.ServerDatabase.enchantMappings = global.ServerDatabase.enchantMappings or {}
    local results = global.ServerDatabase.enchantMappings
    
    local currentID = startID or 1
    if self._scanUpdateFrame then
        self._scanUpdateFrame:SetScript("OnUpdate", nil)
    end
    local f = CreateFrame("Frame")
    self._scanUpdateFrame = f
    self:ShowScannerWindow()
    self:LogScan("|cff00ff00Escaneando IDs del " .. currentID .. " al " .. actualEndID .. "...|r")
    self:LogScan("-- Espera a que termine para una fluidez total --")

    f:SetScript("OnUpdate", function(this, elapsed)
        this.timer = (this.timer or 0) + elapsed
        if this.timer < 0.1 then return end -- Intervalo más humano para evitar lag
        this.timer = 0

        -- MÁXIMO 10 IDs POR FRAME (Evita picos de CPU al llamar a SetHyperlink)
        local limit = math.min(currentID + 10, actualEndID)
        for id = currentID, limit do
            -- Ítems de prueba con ranuras reales
            local testItems = { 51283, 51284 }
            
            local function MatchPatterns(patterns, targetID, isEnchant)
                for _, tid in ipairs(testItems) do
                    scanTooltip:ClearLines()
                    if isEnchant then
                        scanTooltip:SetHyperlink("item:"..tid..":"..targetID)
                    else
                        -- Probar en Ranura 1 (Slot 3) y Ranura 2 (Slot 4)
                        scanTooltip:SetHyperlink("item:"..tid..":0:"..targetID)
                        if scanTooltip:NumLines() <= 1 then
                            scanTooltip:ClearLines()
                            scanTooltip:SetHyperlink("item:"..tid..":0:0:"..targetID)
                        end
                    end

                    if scanTooltip:NumLines() > 1 then
                        for j = 1, scanTooltip:NumLines() do
                            local line = _G["GA_ScanTooltipTextLeft"..j]
                            local text = line and line:GetText()
                            if text and text ~= "" then
                                local normText = Normalize(text)
                                for _, p in ipairs(patterns) do
                                    if normText:find(p.pattern) or normText:find(Normalize(p.name)) then
                                        return p, text
                                    end
                                end
                            end
                        end
                    end
                end
                return nil
            end

            -- 1. Probar como Encantamiento
            local match, foundText = MatchPatterns(self.manualPatterns, id, true)
            
            -- 2. Probar como Gema
            if not match then
                match, foundText = MatchPatterns(self.manualPatterns, id, false)
            end

            if match then
                if not results[id] then
                    self:LogScan("|cff00ffff[GA Match]:|r ID " .. id .. " -> " .. match.name .. " (|cffffffff".. (foundText or "") .."|r)")
                end
                results[id] = { 
                    name = match.name, 
                    prof = match.prof, 
                    text = foundText
                }
            end
        end

        currentID = limit + 1
        
        if currentID > actualEndID then
            self:LogScan("|cff00ff00GearAnalyzer:|r Escaneo TOTAL finalizado.")
            this:SetScript("OnUpdate", nil)
        end
    end)
end

-- Escanea la profesión ACTUALMENTE abierta
function GearAnalyzer:ScanProfessionWindow()
    if not TradeSkillFrame or not TradeSkillFrame:IsShown() then
        self:LogScan("|cffff0000Error:|r Debes tener la ventana de profesión abierta.")
        return
    end

    local profName, profLvl = GetTradeSkillLine()
    self:ShowScannerWindow()
    self:LogScan("|cff00ff00Escaneando Profesión:|r " .. (profName or "Desconocida") .. " (" .. (profLvl or 0) .. ")")
    
    local numRecipes = GetNumTradeSkills()
    local count = 0
    for i = 1, numRecipes do
        local name, type = GetTradeSkillInfo(i)
        if name and type ~= "header" then
            local itemLink = GetTradeSkillItemLink(i)
            local spellLink = GetTradeSkillRecipeLink(i)
            
            if itemLink then
                local id = tonumber(itemLink:match("item:(%d+)"))
                if id then
                    self:LogScan("Encontrado: |cffffffff"..name.."|r (ID: "..id..")")
                    count = count + 1
                end
            elseif spellLink then
                local id = tonumber(spellLink:match("enchant:(%d+)") or spellLink:match("spell:(%d+)"))
                if id then
                    self:LogScan("Encontrado: |cffffffff"..name.."|r (ID: "..id..")")
                    count = count + 1
                end
            end
        end
    end
    self:LogScan("--- Fin de escaneo ("..count.." recetas) ---")
end

function GearAnalyzer:ShowScannerWindow()
    if not self.scanFrame then
        local f = CreateFrame("Frame", "GAScanFrame", UIParent)
        f:SetSize(600, 450)
        f:SetPoint("CENTER")
        f:SetFrameLevel(60)
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left=8, right=8, top=8, bottom=8 }
        })
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", f.StopMovingOrSizing)
        
        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", 0, -20)
        title:SetText("Resultados del Escaneo de Servidor")
        
        local scroll = CreateFrame("ScrollFrame", "GAScanScroll", f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 20, -50)
        scroll:SetPoint("BOTTOMRIGHT", -35, 60)
        
        local edit = CreateFrame("EditBox", nil, scroll)
        edit:SetSize(scroll:GetWidth(), 500)
        edit:SetMultiLine(true)
        edit:SetAutoFocus(false)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(530)
        scroll:SetScrollChild(edit)
        f.edit = edit
        
        local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        close:SetSize(100, 30)
        close:SetPoint("BOTTOMRIGHT", -20, 20)
        close:SetText("Cerrar")
        close:SetScript("OnClick", function() f:Hide() end)
        
        local clearBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        clearBtn:SetSize(120, 30)
        clearBtn:SetPoint("BOTTOMLEFT", 20, 20)
        clearBtn:SetText("Limpiar")
        clearBtn:SetScript("OnClick", function() 
            f.edit:SetText("") 
            wipe(scanLogBuffer) 
        end)
        
        self.scanFrame = f
    end
    self.scanFrame:Show()
end

local scanLogBuffer = {}
local MAX_SCAN_LINES = 150

function GearAnalyzer:LogScan(msg)
    if not msg then return end
    
    table.insert(scanLogBuffer, msg)
    if #scanLogBuffer > MAX_SCAN_LINES then
        table.remove(scanLogBuffer, 1)
    end
    
    if not self.scanFrame then self:ShowScannerWindow() end
    
    local text = table.concat(scanLogBuffer, "\n")
    self.scanFrame.edit:SetText(text)
    self.scanFrame.edit:SetCursorPosition(string.len(text))
end

function GearAnalyzer:GetExportData(profMode)
    local data = GearAnalyzer.db.global.ServerDatabase and GearAnalyzer.db.global.ServerDatabase.enchantMappings or {}
    local sorted = {}
    for id, info in pairs(data) do table.insert(sorted, {id = id, info = info}) end
    table.sort(sorted, function(a,b) return a.id < b.id end)

    local modes = {}
    if type(profMode) == "table" then
        for _, v in ipairs(profMode) do modes[Normalize(v)] = true end
    else
        modes[Normalize(profMode)] = true
    end

    local output = "-- [[ GearAnalyzer Server Export ]]\n"
    output = output .. "GearAnalyzer.ServerDatabase = {\n"
    output = output .. "    [\"enchantMappings\"] = {\n"
    
    local count = 0
    for _, v in ipairs(sorted) do
        if v.info.prof and modes[Normalize(v.info.prof)] then
            output = output .. "    [" .. v.id .. "] = { id = " .. v.id .. ", name = \"" .. v.info.name .. "\", stats = \"" .. (v.info.text or "") .. "\", prof = \"" .. v.info.prof .. "\" },\n"
            count = count + 1
        end
    end

    if GearAnalyzer.db.profile.settings.devMode then
        print("|cff00ffffGearAnalyzer:|r Exportacion finalizada. " .. count .. " registros para " .. (type(profMode) == "table" and table.concat(profMode, ", ") or profMode) .. ".")
    end
    return output .. "    }\n}"
end
