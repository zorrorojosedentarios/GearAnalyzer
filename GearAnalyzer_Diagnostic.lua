-- ==========================================================
-- GearAnalyzer Diagnostic Tool (VERSION MAESTRA v4)
-- Letra Grande (16px) y Motor de Seguridad (pcall)
-- ==========================================================

local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local AceGUI = LibStub("AceGUI-3.0")

local DEBUG_COLORS = {
    [3621] = "meta", [3624] = "meta", [3628] = "meta", [3623] = "meta", [3625] = "meta", [3620] = "meta", [41376] = "meta", [41398] = "meta",
    [3518] = "red", [3520] = "red", [3519] = "red", [3524] = "red", [3521] = "red", [3525] = "red", [3522] = "red", [3523] = "red", [3732] = "red", [3735] = "red", [3736] = "red", [3742] = "red", [40111] = "red", [40113] = "red",
    [3530] = "yellow", [3533] = "yellow", [3531] = "yellow", [3529] = "yellow", [3527] = "yellow", [3737] = "yellow", [3739] = "yellow", [3740] = "yellow", [40125] = "yellow", [40128] = "yellow", [40126] = "yellow",
    [3526] = "blue", [3528] = "blue", [3738] = "blue", [40119] = "blue", [40120] = "blue",
    [3563] = "orange", [3559] = "orange", [3535] = "orange", [3538] = "orange", [3539] = "orange", [3548] = "orange", 
    [3545] = "purple", [3541] = "purple", [3544] = "purple", [3542] = "purple", [40129] = "purple", [40133] = "purple", [40134] = "purple",
    [40165] = "green", [3532] = "green", [40173] = "green",
    [3511] = "prismatic", [3555] = "prismatic", [3855] = "prismatic", [3626] = "prismatic", [3879] = "prismatic", [49110] = "prismatic"
}

local function SetLargeFont(widget, size)
    if not widget or not widget.label then return end
    local font, _, flags = widget.label:GetFont()
    widget.label:SetFont(font, size or 16, flags)
end

function GearAnalyzer:ShowGemDiagnosticWindow()
    if self.diagFrame then self.diagFrame:Release() end

    -- Asegurar que el equipo esté escaneado
    self:ScanEquipment()

    local f = AceGUI:Create("Frame")
    f:SetTitle("GEARANALYZER: Diagnóstico Maestro (v4)")
    f:SetLayout("Fill")
    f:SetWidth(800)
    f:SetHeight(700)
    f:SetCallback("OnClose", function(widget) AceGUI:Release(widget); GearAnalyzer.diagFrame = nil end)
    self.diagFrame = f

    local scroll = AceGUI:Create("ScrollFrame")
    scroll:SetLayout("List")
    f:AddChild(scroll)

    local GemsMod = self:GetModule("AnalysisGems", true)
    local EnchMod = self:GetModule("AnalysisEnchants", true)
    local StateMod = self:GetModule("State", true)
    
    local class, spec = "UNKNOWN", "NONE"
    if StateMod then class, spec = StateMod:GetPlayerState() end
    local dynamicGems = nil
    if GemsMod then dynamicGems = GemsMod:GetDynamicGems(class, spec) end

    local usedUniques = {}

    -- 1. Resumen de Conteo
    local counts = { red = 0, yellow = 0, blue = 0 }
    if self.scannedEquipment then
        for _, d in ipairs(self.scannedEquipment) do
            if d.allGemSlots then
                for _, gid in ipairs(d.allGemSlots) do
                    if gid > 0 then
                        local color = DEBUG_COLORS[gid]
                        if color == "red" then counts.red = counts.red + 1
                        elseif color == "yellow" then counts.yellow = counts.yellow + 1
                        elseif color == "blue" then counts.blue = counts.blue + 1
                        elseif color == "orange" then counts.red = counts.red + 1; counts.yellow = counts.yellow + 1
                        elseif color == "purple" then counts.red = counts.red + 1; counts.blue = counts.blue + 1
                        elseif color == "green" then counts.yellow = counts.yellow + 1; counts.blue = counts.blue + 1
                        elseif color == "prismatic" then counts.red = counts.red + 1; counts.yellow = counts.yellow + 1; counts.blue = counts.blue + 1
                        end
                    end
                end
            end
        end
    end

    local header = AceGUI:Create("Label")
    header:SetFullWidth(true)
    local specLabel = GearAnalyzer:GetSpecLabel(spec)
    local classLoc = GearAnalyzer:GetLocalizedClassName()
    header:SetText(string.format("|cffffff00RESUMEN (%s %s):|r ROJAS: |cffff0000%d|r | AMARILLAS: |cffffff00%d|r | AZULES: |cff0000ff%d|r\n%s", 
        classLoc, specLabel, counts.red, counts.yellow, counts.blue, string.rep("=", 100)))
    SetLargeFont(header, 20)
    scroll:AddChild(header)

    -- 2. Listado Detallado con Protección pcall
    if self.scannedEquipment then
        for _, d in ipairs(self.scannedEquipment) do
            local success, err = pcall(function()
                local l = AceGUI:Create("Label")
                l:SetFullWidth(true)
                local itemText = string.format("|cffffff00[%s]|r ", self.SafeL(d.slotName))
                
                if d.itemLink then
                    local name = GetItemInfo(d.itemLink) or "Cargando..."
                    itemText = itemText .. "|cff3fc7eb" .. name .. "|r"
                    
                    local sColors, bonusText, bonusVal, bonusStat = GearAnalyzer:GetItemSocketColors(d.itemLink)
                    
                    -- GEMAS
                    if d.allGemSlots then
                        for i, curGID in ipairs(d.allGemSlots) do
                            local sColor = sColors[i]
                            if curGID > 0 or sColor then
                                local colorKey = DEBUG_COLORS[curGID] or "unknown"
                                local gData = GearAnalyzer:GetEnchantData(curGID)
                                local gName = gData and gData.name or (curGID > 0 and "ID:"..curGID or "|cff777777(Vacia)|r")
                                
                                local recID = 0
                                if dynamicGems then
                                    if sColor == "meta" then recID = dynamicGems.meta
                                    elseif sColor == "yellow" then recID = dynamicGems.yellow
                                    elseif sColor == "blue" then recID = dynamicGems.blue
                                    else recID = dynamicGems.red end
                                    
                                    if tonumber(recID) == 49110 and usedUniques[49110] then recID = dynamicGems.red end
                                    if tonumber(recID) == 49110 then usedUniques[49110] = true end
                                end

                                -- NORMALIZACIÓN DE COMPARACIÓN (Enchant ID vs Item ID)
                                local isSuggested = false
                                if curGID > 0 and recID > 0 then
                                    if tonumber(curGID) == tonumber(recID) then
                                        isSuggested = true
                                    else
                                        local d1 = GearAnalyzer:GetEnchantData(curGID)
                                        local d2 = GearAnalyzer:GetEnchantData(recID)
                                        if d1 and d2 then
                                            -- 1. Comparar por IDs vinculados
                                            if (d1.originalID and d1.originalID == d2.originalID) or 
                                               (d1.item and d1.item == d2.item) or
                                               (d1.item and tonumber(d1.item) == tonumber(recID)) or
                                               (d2.item and tonumber(d2.item) == tonumber(curGID)) then
                                                isSuggested = true
                                            -- 2. Comparar por nombre (Método infalible si los nombres coinciden)
                                            elseif d1.name and d2.name and d1.name == d2.name then
                                                isSuggested = true
                                            end
                                        end
                                        -- 3. Fallback para Joyería
                                        if not isSuggested and GearAnalyzer.JC_UPGRADES and GearAnalyzer.JC_UPGRADES[tonumber(curGID)] == tonumber(recID) then
                                            isSuggested = true
                                        end
                                    end
                                end
                                
                                local matchText = GearAnalyzer:SatisfiesSocket(colorKey, sColor) and "|cff00ff00SI|r" or "|cffff0000NO|r"
                                local suggText = ""
                                
                                local rData = GearAnalyzer:GetEnchantData(recID)
                                local rName = rData and rData.name or "ID:"..recID
                                
                                if isSuggested then
                                    suggText = string.format("|cff00ff00OK|r |cff888888([%d] %s)|r", recID, rName)
                                elseif recID and tonumber(recID) > 0 then
                                    suggText = string.format("|cffffaa00Sugerida: [%d] %s|r", recID, rName)
                                end

                                local slotColorName = sColor == "meta" and "META" or (sColor == "red" and "ROJA" or (sColor == "yellow" and "AMARILLA" or (sColor == "blue" and "AZUL" or "EXTRA")))
                                itemText = itemText .. string.format("\n   |cffaaaaaa- Gema %d (%s):|r [%d] %s [%s] %s", 
                                    i, slotColorName, curGID, gName, matchText, suggText)
                            end
                        end
                    end

                    -- ENCANTAMIENTOS
                    if EnchMod then
                        local eData = GearAnalyzer:GetEnchantData(d.enchant)
                        local eName = eData and eData.name or (tonumber(d.enchant) and tonumber(d.enchant) > 0 and "ID:"..d.enchant or "|cffff0000SIN ENCANTAR|r")
                        itemText = itemText .. string.format("\n   |cffaaaaaa- Encantamiento:|r %s", eName)
                    end
                else
                    itemText = itemText .. "|cff777777(Vacio)|r"
                end
                
                itemText = itemText .. "\n "
                l:SetText(itemText)
                SetLargeFont(l, 16)
                scroll:AddChild(l)
            end)
            
            if not success then
                print("|cffff0000GA Error en slot:|r", d.slotName, err)
            end
        end
    end
end

-- ==========================================================
-- SCRIPT DE BÚSQUEDA DE GEMAS (FUERZA BRUTA) CON VENTANA COPIABLE
-- ==========================================================
SLASH_GABUSCARGEMAS1 = "/buscargemas"
SlashCmdList["GABUSCARGEMAS"] = function(msg)
    local query = msg:trim()
    if query == "" then
        print("|cffff0000GearAnalyzer Uso:|r /buscargemas <stat> (Ej. /buscargemas +10 Parada)")
        return
    end

    print("|cff00ff00GearAnalyzer:|r Buscando Enchant IDs (3000 a 4500) con el texto: |cffffff00" .. query .. "|r")
    
    if not GA_HiddenTooltip then
        GA_HiddenTooltip = CreateFrame("GameTooltip", "GA_HiddenTooltip", nil, "GameTooltipTemplate")
        GA_HiddenTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end

    local results = {}
    local found = 0
    -- Rango común de Enchant IDs para gemas de WotLK (3000 a 4500)
    for i = 3000, 4500 do
        GA_HiddenTooltip:ClearLines()
        -- 40111 es un Rubí cárdeno, usamos un item base y le inyectamos el enchant ID (i)
        local link = "|cffff8000|Hitem:40111:" .. i .. ":0:0:0:0:0:0:80:0|h[Dummy]|h|r"
        GA_HiddenTooltip:SetHyperlink(link)
        
        for j = 1, GA_HiddenTooltip:NumLines() do
            local left = _G["GA_HiddenTooltipTextLeft"..j]
            if left and left:GetText() then
                local txt = left:GetText()
                -- Buscamos el string ignorando mayúsculas/minúsculas
                if string.find(string.lower(txt), string.lower(query), 1, true) then
                    table.insert(results, string.format("    [%d] = { item = [ItemID], name = \"Gema Encontrada\", stats = \"%s\", color = \"color\" },", i, txt))
                    found = found + 1
                    break
                end
            end
        end
    end

    if found > 0 then
        if GABuscarGemasFrame then
            GABuscarGemasFrame:Hide()
            GABuscarGemasFrame = nil
        end

        local f = CreateFrame("Frame", "GABuscarGemasFrame", UIParent)
        f:SetSize(600, 450)
        f:SetPoint("CENTER", 0, 0)
        f:SetFrameStrata("DIALOG")
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", f.StopMovingOrSizing)
        
        f:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        f:SetBackdropColor(0, 0, 0, 0.95)
        f:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", 0, -15)
        title:SetText("Resultados de Búsqueda: " .. query)
        
        local closeBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        closeBtn:SetSize(120, 25)
        closeBtn:SetPoint("BOTTOM", 0, 15)
        closeBtn:SetText("Cerrar")
        closeBtn:SetScript("OnClick", function() f:Hide() end)

        local scrollFrame = CreateFrame("ScrollFrame", "GABuscarScroll", f, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 20, -50)
        scrollFrame:SetPoint("BOTTOMRIGHT", -40, 50)

        local editBox = CreateFrame("EditBox", nil, scrollFrame)
        editBox:SetMultiLine(true)
        editBox:SetFontObject("ChatFontNormal")
        editBox:SetWidth(520)
        editBox:SetAutoFocus(false)
        editBox:SetMaxLetters(0)
        editBox:SetTextInsets(5, 5, 5, 5)
        editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        
        scrollFrame:SetScrollChild(editBox)
        editBox:SetText(table.concat(results, "\n"))
        
        f:Show()
        print("|cff00ff00GearAnalyzer:|r Búsqueda terminada. Mostrando ventana nativa.")
    else
        print("|cffff0000GearAnalyzer:|r No se encontraron gemas que coincidan.")
    end
end

-- ==========================================================
-- SCRIPT DE VERIFICACIÓN MASIVA DE LA BASE DE DATOS DE GEMAS
-- ==========================================================
local function StatsMatch(dbStat, serverStat)
    if not dbStat or not serverStat then return false end
    
    local d = string.lower(dbStat)
    local s = string.lower(serverStat)
    
    local function clean(str)
        str = str:gsub("á", "a"):gsub("é", "e"):gsub("í", "i"):gsub("ó", "o"):gsub("ú", "u")
        str = str:gsub("sp", "hechizo"):gsub("poder con hechizos", "hechizo")
        str = str:gsub("mana cada 5 s", "mp5"):gsub("mana cada 5 seg", "mp5")
        str = str:gsub("critico", "crit"):gsub("golpe critico", "crit")
        return str
    end
    
    d = clean(d)
    s = clean(s)
    
    if d == s or string.find(s, d, 1, true) or string.find(d, s, 1, true) then
        return true
    end
    
    local dbNums = {}
    for num in d:gmatch("%d+") do table.insert(dbNums, num) end
    
    local serverNums = {}
    for num in s:gmatch("%d+") do table.insert(serverNums, num) end
    
    if #dbNums == 0 or #serverNums == 0 then return false end
    for _, dbNum in ipairs(dbNums) do
        local found = false
        for _, sNum in ipairs(serverNums) do
            if dbNum == sNum then
                found = true
                break
            end
        end
        if not found then return false end
    end
    
    local keywords = {
        "fuerza", "agilidad", "aguante", "intelecto", "espiritu", "esquiv", "parada", "defensa", 
        "golpe", "celeridad", "crit", "temple", "pericia", "hechizo", "mana", "mp5", "todas",
        "poder", "ataque", "armadura", "penetracion", "velocidad"
    }
    
    local keywordMatched = false
    for _, word in ipairs(keywords) do
        if string.find(d, word, 1, true) and string.find(s, word, 1, true) then
            keywordMatched = true
            break
        end
    end
    
    return keywordMatched
end

local function IsStatLine(txt)
    if not txt or txt == "" then return false end
    txt = string.lower(txt)
    
    local ignore = {
        "épico", "raro", "común", "gema", "único", "equipado", "requisito", "nivel", 
        "ranura", "engastable", "durabilidad", "vender", "clase", "diseño", "receta"
    }
    for _, word in ipairs(ignore) do
        if string.find(txt, word, 1, true) then
            return false
        end
    end
    
    if not string.find(txt, "%d") then
        return false
    end
    
    local keywords = {
        "fuerza", "agilidad", "aguante", "intelecto", "espíritu", "esquiv", "parada", "defensa", 
        "golpe", "celeridad", "crítico", "critico", "temple", "pericia", "hechizo", "mana", "maná", "mp5", "todas",
        "poder", "ataque", "armadura", "penetracion", "penetración", "velocidad"
    }
    for _, word in ipairs(keywords) do
        if string.find(txt, word, 1, true) then
            return true
        end
    end
    
    return false
end

SLASH_GAVERIFICARGEMAS1 = "/verificargemas"
SlashCmdList["GAVERIFICARGEMAS"] = function()
    print("|cff00ff00GearAnalyzer:|r Iniciando verificación masiva de gemas...")
    
    if not GearAnalyzer.EnchantMasterDB then
        print("|cffff0000GearAnalyzer [DEBUG] ERROR:|r GearAnalyzer.EnchantMasterDB es nil!")
        return
    end

    if not GA_HiddenTooltip then
        GA_HiddenTooltip = CreateFrame("GameTooltip", "GA_HiddenTooltip", nil, "GameTooltipTemplate")
        GA_HiddenTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end

    local sortedKeys = {}
    local totalGems = 0
    local keysFound = 0
    for k, v in pairs(GearAnalyzer.EnchantMasterDB) do
        keysFound = keysFound + 1
        if type(v) == "table" and v.color then
            totalGems = totalGems + 1
            if tonumber(k) and tonumber(k) < 20000 then
                table.insert(sortedKeys, tonumber(k))
            end
        end
    end
    
    print("|cff00ff00GearAnalyzer [DEBUG]:|r Claves totales en DB:", keysFound)
    print("|cff00ff00GearAnalyzer [DEBUG]:|r Gemas encontradas (con color):", totalGems)
    print("|cff00ff00GearAnalyzer [DEBUG]:|r Gemas para verificar (ID < 20000):", #sortedKeys)
    
    if #sortedKeys == 0 then
        print("|cffff0000GearAnalyzer [DEBUG] ERROR:|r No se encontraron gemas válidas en master DB!")
        local printed = 0
        for k, v in pairs(GearAnalyzer.EnchantMasterDB) do
            print("Entrada en DB: [", k, "] = type:", type(v), "name:", (type(v)=="table" and v.name or "nil"), "color:", (type(v)=="table" and v.color or "nil"))
            printed = printed + 1
            if printed >= 5 then break end
        end
        return
    end

    table.sort(sortedKeys)

    local results = {}
    local total = 0
    local okCount = 0
    local errCount = 0

    for _, i in ipairs(sortedKeys) do
        local data = GearAnalyzer.EnchantMasterDB[i]
        total = total + 1
        
        GA_HiddenTooltip:ClearLines()
        local link = "|cffff8000|Hitem:40111:" .. i .. ":0:0:0:0:0:0:80:0|h[Dummy]|h|r"
        GA_HiddenTooltip:SetHyperlink(link)
        
        local serverStat = nil
        for j = 1, GA_HiddenTooltip:NumLines() do
            local left = _G["GA_HiddenTooltipTextLeft"..j]
            if left and left:GetText() then
                local txt = left:GetText()
                if IsStatLine(txt) then
                    serverStat = txt
                    break
                end
            end
        end

        if serverStat then
            if StatsMatch(data.stats, serverStat) then
                table.insert(results, string.format("[OK] Enchant ID: %d - %s (%s) => Servidor: %s", i, data.name, data.stats, serverStat))
                okCount = okCount + 1
            else
                table.insert(results, string.format("[DIFERENTE] Enchant ID: %d - %s | DB: %s | Servidor: %s", i, data.name, data.stats, serverStat))
                errCount = errCount + 1
            end
        else
            table.insert(results, string.format("[INEXISTENTE] Enchant ID: %d - %s (%s) => El servidor no devolvió datos.", i, data.name, data.stats))
            errCount = errCount + 1
        end
    end

    table.insert(results, 1, string.format("=== RESUMEN DE VERIFICACIÓN ==="))
    table.insert(results, 2, string.format("Total Gemas en DB: %d", total))
    table.insert(results, 3, string.format("Correctas (OK): %d", okCount))
    table.insert(results, 4, string.format("Errores/Diferentes (ERR): %d", errCount))
    table.insert(results, 5, string.format("===============================\n"))

    -- Crear Ventana Nativa de WoW Coplable (Sin AceGUI para evitar bugs de visualización)
    if GAVerificacionFrame then
        GAVerificacionFrame:Hide()
        GAVerificacionFrame = nil
    end

    local f = CreateFrame("Frame", "GAVerificacionFrame", UIParent)
    f:SetSize(650, 500)
    f:SetPoint("CENTER", 0, 0)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    
    f:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    f:SetBackdropColor(0, 0, 0, 0.95)
    f:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Verificación de Gemas GearAnalyzer")
    
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    closeBtn:SetSize(120, 25)
    closeBtn:SetPoint("BOTTOM", 0, 15)
    closeBtn:SetText("Cerrar")
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    local scrollFrame = CreateFrame("ScrollFrame", "GAVerificacScroll", f, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 20, -50)
    scrollFrame:SetPoint("BOTTOMRIGHT", -40, 50)

    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetWidth(570)
    editBox:SetAutoFocus(false)
    editBox:SetMaxLetters(0)
    editBox:SetTextInsets(5, 5, 5, 5)
    editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    
    scrollFrame:SetScrollChild(editBox)
    editBox:SetText(table.concat(results, "\n"))
    
    f:Show()
    print("|cff00ff00GearAnalyzer:|r Escaneo completado. Mostrando ventana nativa.")
end

SLASH_GAVERIFICARENCANTES1 = "/verificarencantes"
SlashCmdList["GAVERIFICARENCANTES"] = function()
    print("|cff00ff00GearAnalyzer:|r Iniciando verificación de encantamientos...")
    
    if not GearAnalyzer.EnchantMasterDB then
        print("|cffff0000GearAnalyzer [DEBUG] ERROR:|r GearAnalyzer.EnchantMasterDB es nil!")
        return
    end

    if not GA_HiddenTooltip then
        GA_HiddenTooltip = CreateFrame("GameTooltip", "GA_HiddenTooltip", nil, "GameTooltipTemplate")
        GA_HiddenTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end

    local sortedKeys = {}
    local totalEnchants = 0
    for k, v in pairs(GearAnalyzer.EnchantMasterDB) do
        if type(v) == "table" and not v.color then
            totalEnchants = totalEnchants + 1
            if tonumber(k) and tonumber(k) < 20000 then
                table.insert(sortedKeys, tonumber(k))
            end
        end
    end
    
    print("|cff00ff00GearAnalyzer [DEBUG]:|r Encantamientos totales en DB:", totalEnchants)
    print("|cff00ff00GearAnalyzer [DEBUG]:|r Encantamientos para verificar (ID < 20000):", #sortedKeys)
    
    if #sortedKeys == 0 then
        print("|cffff0000GearAnalyzer [DEBUG] ERROR:|r No se encontraron encantamientos válidos en master DB!")
        return
    end

    table.sort(sortedKeys)

    local results = {}
    local total = 0
    local okCount = 0
    local errCount = 0

    local function clean(str)
        str = str:gsub("á", "a"):gsub("é", "e"):gsub("í", "i"):gsub("ó", "o"):gsub("ú", "u")
        str = str:gsub("sp", "hechizo"):gsub("poder con hechizos", "hechizo")
        str = str:gsub("pa", "poder de ataque"):gsub("ap", "poder de ataque")
        str = str:gsub("critico", "crit"):gsub("golpe critico", "crit")
        return str:lower()
    end

    local function EnchantMatch(dbData, serverText)
        if not dbData or not serverText then return false end
        
        local name = clean(dbData.name or "")
        local stats = clean(dbData.stats or "")
        local s = clean(serverText)
        
        -- Fallback de profesión: si el cliente devuelve estadísticas del objeto equipado
        local nameLower = dbData.name and dbData.name:lower() or ""
        local isProf = (dbData.slot == "ring") or 
                       (dbData.origin == "Ingeniería") or
                       (nameLower:find("bordado") ~= nil) or 
                       (nameLower:find("forro") ~= nil) or 
                       (nameLower:find("aceleradores") ~= nil) or 
                       (nameLower:find("pirocohete") ~= nil) or 
                       (nameLower:find("propulsores") ~= nil) or 
                       (nameLower:find("flexible") ~= nil) or 
                       (nameLower:find("plato") ~= nil)
                       
        if isProf and (s:find("equipar") or s:find("mejora") or s:find("crit") or s:find("temple") or s:find("salud")) then
            return true
        end
        
        if string.find(s, name, 1, true) or string.find(name, s, 1, true) then
            return true
        end
        
        if string.find(s, stats, 1, true) or string.find(stats, s, 1, true) then
            return true
        end
        
        local dbNums = {}
        for num in stats:gmatch("%d+") do table.insert(dbNums, num) end
        for num in name:gmatch("%d+") do table.insert(dbNums, num) end
        
        local serverNums = {}
        for num in s:gmatch("%d+") do table.insert(serverNums, num) end
        
        if #dbNums > 0 and #serverNums > 0 then
            local allMatched = true
            for _, dbNum in ipairs(dbNums) do
                local found = false
                for _, sNum in ipairs(serverNums) do
                    if dbNum == sNum then
                        found = true
                        break
                    end
                end
                if not found then
                    allMatched = false
                    break
                end
            end
            if allMatched then return true end
        end
        
        return false
    end

    for _, i in ipairs(sortedKeys) do
        local data = GearAnalyzer.EnchantMasterDB[i]
        total = total + 1
        
        GA_HiddenTooltip:ClearLines()
        local dummyItem = "38"
        local slotMap = {
            head = 1,
            shoulders = 3,
            back = 15,
            chest = 5,
            wrists = 9,
            hands = 10,
            feet = 8,
            ring = 11,
            weapon = 16,
            shield = 17,
            offhand = 17,
            ranged = 18
        }
        local slotId = slotMap[data.slot]
        if slotId then
            local link = GetInventoryItemLink("player", slotId)
            if link then
                local itemId = link:match("item:(%d+):")
                if itemId then
                    dummyItem = itemId
                end
            end
        end
        local link = "|cffff8000|Hitem:" .. dummyItem .. ":" .. i .. ":0:0:0:0:0:0:80:0|h[Dummy]|h|r"
        GA_HiddenTooltip:SetHyperlink(link)
        
        local serverText = nil
        for j = 2, GA_HiddenTooltip:NumLines() do
            local left = _G["GA_HiddenTooltipTextLeft"..j]
            if left and left:GetText() then
                local txt = left:GetText()
                txt = txt:trim()
                if txt ~= "" then
                    local r, g, b = left:GetTextColor()
                    if g > 0.8 and r < 0.4 and b < 0.4 then
                        serverText = txt
                        break
                    end
                end
            end
        end

        if serverText then
            if EnchantMatch(data, serverText) then
                okCount = okCount + 1
                table.insert(results, string.format("[OK] Enchant ID: %d - %s (%s) => Servidor: %s", i, data.name or "S/N", data.stats or "S/S", serverText))
            else
                errCount = errCount + 1
                table.insert(results, string.format("[DIFERENTE] Enchant ID: %d - %s | DB: %s | Servidor: %s", i, data.name or "S/N", data.stats or "S/S", serverText))
            end
        else
            errCount = errCount + 1
            table.insert(results, string.format("[INEXISTENTE] Enchant ID: %d - %s | Servidor no devolvió texto", i, data.name or "S/N"))
        end
    end

    -- Cabecera
    table.insert(results, 1, "===============================")
    table.insert(results, 1, string.format("Errores/Diferentes (ERR): %d", errCount))
    table.insert(results, 1, string.format("Correctas (OK): %d", okCount))
    table.insert(results, 1, string.format("Total Encantos en DB: %d", total))
    table.insert(results, 1, "=== RESUMEN DE ENCHANTMENTS ===")

    -- Crear Ventana Nativa de WoW
    if GAEnchVerificacionFrame then
        GAEnchVerificacionFrame:Hide()
        GAEnchVerificacionFrame = nil
    end

    local f = CreateFrame("Frame", "GAEnchVerificacionFrame", UIParent)
    f:SetSize(650, 500)
    f:SetPoint("CENTER", 0, 0)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    
    f:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    f:SetBackdropColor(0, 0, 0, 0.95)
    f:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Verificación de Enchants GearAnalyzer")
    
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    closeBtn:SetSize(120, 25)
    closeBtn:SetPoint("BOTTOM", 0, 15)
    closeBtn:SetText("Cerrar")
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    local scrollFrame = CreateFrame("ScrollFrame", "GAEnchVerificacScroll", f, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 20, -50)
    scrollFrame:SetPoint("BOTTOMRIGHT", -40, 50)

    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetWidth(570)
    editBox:SetAutoFocus(false)
    editBox:SetMaxLetters(0)
    editBox:SetTextInsets(5, 5, 5, 5)
    editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    
    scrollFrame:SetScrollChild(editBox)
    editBox:SetText(table.concat(results, "\n"))
    
    f:Show()
    print("|cff00ff00GearAnalyzer:|r Escaneo de encantamientos completado. Mostrando ventana nativa.")
end


-- ============================================================
-- VERIFICACIÓN DE GLIFOS
-- ============================================================
SLASH_GAVERIFICARGLIFOS1 = "/verificarglifos"
SlashCmdList["GAVERIFICARGLIFOS"] = function()
    print("|cff00ff00GearAnalyzer:|r Iniciando verificación de glifos...")
    
    if not GA_HiddenTooltip then
        GA_HiddenTooltip = CreateFrame("GameTooltip", "GA_HiddenTooltip", nil, "GameTooltipTemplate")
        GA_HiddenTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end

    local classes = { "DEATHKNIGHT", "DRUID", "HUNTER", "MAGE", "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR" }
    
    -- Asegurar que todos los módulos de clase estén cargados
    for _, classTag in ipairs(classes) do
        GearAnalyzer:LoadClassData(classTag)
    end

    local uniqueGlyphs = {}
    local totalGlyphCount = 0

    for _, classTag in ipairs(classes) do
        local data = GearAnalyzer.ClassData[classTag]
        if data and data.Glyphs then
            for specName, glyphTypes in pairs(data.Glyphs) do
                for gType, ids in pairs(glyphTypes) do
                    for _, id in ipairs(ids) do
                        if tonumber(id) then
                            local key = tonumber(id)
                            if not uniqueGlyphs[key] then
                                uniqueGlyphs[key] = {
                                    id = key,
                                    class = classTag,
                                    specs = {},
                                    kind = gType
                                }
                                totalGlyphCount = totalGlyphCount + 1
                            end
                            table.insert(uniqueGlyphs[key].specs, specName)
                        end
                    end
                end
            end
        end
    end

    print("|cff00ff00GearAnalyzer [DEBUG]:|r Glifos únicos encontrados en DB:", totalGlyphCount)

    if totalGlyphCount == 0 then
        print("|cffff0000GearAnalyzer [DEBUG] ERROR:|r No se encontraron glifos en los módulos de clase!")
        return
    end

    -- Ordenar los IDs
    local sortedKeys = {}
    for k in pairs(uniqueGlyphs) do
        table.insert(sortedKeys, k)
    end
    table.sort(sortedKeys)

    local results = {}
    local okCount = 0
    local errCount = 0

    for _, id in ipairs(sortedKeys) do
        local info = uniqueGlyphs[id]
        
        GA_HiddenTooltip:ClearLines()
        local link = "|cffff8000|Hitem:" .. id .. ":0:0:0:0:0:0:0:80:0|h[Glyph]|h|r"
        GA_HiddenTooltip:SetHyperlink(link)
        
        local serverName = nil
        local firstLine = _G["GA_HiddenTooltipTextLeft1"]
        if firstLine and firstLine:GetText() then
            local text = firstLine:GetText()
            if text ~= "" and text ~= "Glyph" and not text:find("Retrieve") then
                serverName = text
            end
        end

        local specStr = table.concat(info.specs, ", ")
        local typeLabel = info.kind == "major" and "Sublime" or "Menor"
        
        if serverName then
            okCount = okCount + 1
            table.insert(results, string.format("[OK] Glifo ID: %d (%s - %s - %s) => Servidor: %s", id, info.class, specStr, typeLabel, serverName))
        else
            errCount = errCount + 1
            table.insert(results, string.format("[INEXISTENTE] Glifo ID: %d (%s - %s - %s) | Servidor no devolvió texto", id, info.class, specStr, typeLabel))
        end
    end

    -- Cabecera
    table.insert(results, 1, "===============================")
    table.insert(results, 1, string.format("Errores/Inexistentes (ERR): %d", errCount))
    table.insert(results, 1, string.format("Correctos (OK): %d", okCount))
    table.insert(results, 1, string.format("Total Glifos en DB: %d", totalGlyphCount))
    table.insert(results, 1, "=== RESUMEN DE GLIFOS ===")

    -- Crear Ventana Nativa de WoW
    if GAGlyphVerificacionFrame then
        GAGlyphVerificacionFrame:Hide()
        GAGlyphVerificacionFrame = nil
    end

    local f = CreateFrame("Frame", "GAGlyphVerificacionFrame", UIParent)
    f:SetSize(650, 500)
    f:SetPoint("CENTER", 0, 0)
    f:SetFrameStrata("DIALOG")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    
    f:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    f:SetBackdropColor(0, 0, 0, 0.95)
    f:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Verificación de Glifos GearAnalyzer")
    
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    closeBtn:SetSize(120, 25)
    closeBtn:SetPoint("BOTTOM", 0, 15)
    closeBtn:SetText("Cerrar")
    closeBtn:SetScript("OnClick", function() f:Hide() end)

    local scrollFrame = CreateFrame("ScrollFrame", "GAGlyphVerificacScroll", f, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 20, -50)
    scrollFrame:SetPoint("BOTTOMRIGHT", -40, 50)

    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetFontObject("ChatFontNormal")
    editBox:SetWidth(570)
    editBox:SetAutoFocus(false)
    editBox:SetMaxLetters(0)
    editBox:SetTextInsets(5, 5, 5, 5)
    editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    
    scrollFrame:SetScrollChild(editBox)
    editBox:SetText(table.concat(results, "\n"))
    
    f:Show()
    print("|cff00ff00GearAnalyzer:|r Escaneo de glifos completado. Mostrando ventana nativa.")
end



