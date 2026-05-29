-- =========================
-- GearAnalyzer Tab: BiS / Tops
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabBiSTops")

local PLAYER_CLASS = select(2, UnitClass("player"))
local SLOT_INFO = {
    { key = "head",      name = L["SLOT_HEAD"] },
    { key = "neck",      name = L["SLOT_NECK"] },
    { key = "shoulders", name = L["SLOT_SHOULDERS"] },
    { key = "back",      name = L["SLOT_BACK"] },
    { key = "chest",     name = L["SLOT_CHEST"] },
    { key = "wrists",    name = L["SLOT_WRISTS"] },
    { key = "hands",     name = L["SLOT_HANDS"] },
    { key = "waist",     name = L["SLOT_WAIST"] },
    { key = "legs",      name = L["SLOT_LEGS"] },
    { key = "feet",      name = L["SLOT_FEET"] },
    { key = "ring1",     name = L["SLOT_RING"] .. " 1" },
    { key = "ring2",     name = L["SLOT_RING"] .. " 2" },
    { key = "trinket1",  name = L["SLOT_TRINKET"] .. " 1" },
    { key = "trinket2",  name = L["SLOT_TRINKET"] .. " 2" },
    { key = "weapon",    name = L["SLOT_WEAPON"] },
    { key = "offhand",   name = L["SLOT_OFFHAND"] },
    { key = (PLAYER_CLASS == "HUNTER") and "ranged" or "idol", 
      name = (PLAYER_CLASS == "HUNTER") and L["SLOT_RANGED"] or L["SLOT_RELIC"] },
}

function Tab:Update(page, ignoreForced)
    if page then
        self.page = page
    else
        page = self.page
    end
    if not page then return end

    local db = GearAnalyzer.db.profile
    local needsRefresh = false
    
    -- DETECCIÓN DE MODO (AUTOMÁTICO VS MANUAL)
    local classLoc = GearAnalyzer:GetLocalizedClassName(ignoreForced)
    local classTag = GearAnalyzer:GetClassToken(ignoreForced)
    local spec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local specLabel = GearAnalyzer:GetSpecLabel(spec)
    
    local className = classTag -- "WARLOCK", "PRIEST", etc.
    
    local bisSpec = GearAnalyzer:GetBiSTooltipSpec(true)
    local manualData
    if className and bisSpec and GA_BiSLists[className] and GA_BiSLists[className][bisSpec] then
        manualData = GA_BiSLists[className][bisSpec]["T10"] or GA_BiSLists[className][bisSpec]["PR"]
    end

    -- 1. CREACIÓN ÚNICA DE ELEMENTOS ESTÁTICOS
    if not self.container then
        local f = CreateFrame("Frame", nil, page)
        f:SetAllPoints()
        self.container = f
        
        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -10)
        GearAnalyzer:ApplyStyle(title, true)
        self.titleString = title

        -- Selector de Fase
        local phaseLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        phaseLabel:SetPoint("TOPRIGHT", -185, -5)
        phaseLabel:SetText(L["PHASE"] .. ":")

        local dropdown = CreateFrame("Frame", "GA_PhaseTabDropdown", f, "UIDropDownMenuTemplate")
        dropdown:SetPoint("TOPRIGHT", -0, 2)
        UIDropDownMenu_SetWidth(dropdown, 140)

        UIDropDownMenu_Initialize(dropdown, function()
            local phases = {
                { name = "Pre-Raid / Heroes", val = "PR" },
                { name = "T9 (TotC)", val = "T9" },
                { name = "T10 (ICC)", val = "T10" },
                { name = "RS (Ruby Sanctum)", val = "RS" },
            }
            for _, p in ipairs(phases) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = p.name
                info.value = p.val
                info.func = function(s)
                    UIDropDownMenu_SetSelectedValue(dropdown, s.value)
                    db.phase = s.value
                    if s.value == "MANUAL" then
                        db.top6 = nil -- Forzar recarga desde manualData en Tab:Update()
                    else
                        -- Intentar sincronizar con BiSTooltip
                        GearAnalyzer:SyncWithBiSTooltip(s.value, nil, ignoreForced)
                    end
                    GearAnalyzer:AnalyzeEquipment(ignoreForced)
                    self:Update(page, ignoreForced)
                end
                info.checked = (db.phase == p.val)
                UIDropDownMenu_AddButton(info)
            end
        end)
        self.dropdown = dropdown

        -- Botón Reset BiS Manual
        local resetBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        resetBtn:SetSize(115, 22)
        resetBtn:SetPoint("RIGHT", dropdown, "LEFT", -75, 2) 
        resetBtn:SetText(L["RESET"])
        resetBtn:SetScript("OnClick", function()
            local profile = GearAnalyzer.db.profile
            profile.bis = nil 
            profile.custom_bis = nil -- Limpiar selección manual persistente
            print("|cff00ff00GearAnalyzer:|r " .. L["BIS_RESET_MSG"])
            GearAnalyzer:AnalyzeEquipment()
            self:Update()
        end)
        resetBtn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(L["RESTORE_BIS"])
            GameTooltip:AddLine(L["RESTORE_BIS_DESC"], 1, 1, 1)
            GameTooltip:Show()
        end)
        resetBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        self.resetBtn = resetBtn

        -- ScrollFrame
        local scroll = CreateFrame("ScrollFrame", "GABiSTopsScroll", f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -9, 10)

        local content = CreateFrame("Frame", nil, scroll)
        local w = page:GetWidth()
        if not w or w <= 0 then w = 760 end
        content:SetWidth(w - 40)
        content:SetHeight(500)
        scroll:SetScrollChild(content)
        self.content = content
        
        -- Column labels (Top 1-6)
        local headerRow = CreateFrame("Frame", nil, content)
        headerRow:SetSize(content:GetWidth(), 20)
        headerRow:SetPoint("TOPLEFT", 0, -18)
        self.headerIcons = {}
        for i = 1, 6 do
            local h = headerRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
            h:SetPoint("LEFT", 80 + ((i-1) * (iconSize + 8)), 0)
            h:SetWidth(iconSize + 4)
            h:SetJustifyH("CENTER")
            h:SetText("T" .. i)
            GearAnalyzer:ApplyStyle(h)
            h:SetTextColor(1, 0.82, 0)
            self.headerIcons[i] = h
        end

        -- Nueva columna: BiS GUÍA (Manual) - Eliminada por petición del usuario
        local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
        
        local hObj = headerRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hObj:SetPoint("LEFT", 230 + (6 * (iconSize + 8)) + 20, 0)
        hObj:SetText(L["SELECTED_TARGET"])
        GearAnalyzer:ApplyStyle(hObj)
        hObj:SetTextColor(0, 1, 0)
        self.headerTarget = hObj

        self.rows = {}
    end

    local phase = db.phase or (manualData and "MANUAL" or "T10")
    -- Si la fase guardada es MANUAL pero esta clase no tiene datos manuales, usar T10
    if phase == "MANUAL" and not manualData then
        phase = "T10"
        db.phase = "T10"
    end

    -- Lógica de carga Prioritaria
    local isManual = (phase == "MANUAL")
    
    -- 1. Poblado de manualMap (Siempre, para mostrar el icono GUÍA)
    self.manualMap = self.manualMap or {}
    wipe(self.manualMap)
    if manualData then
        for _, data in ipairs(manualData) do
            local slotKey = GearAnalyzer:GetSlotKey(data.slot_name)
            if slotKey then self.manualMap[slotKey] = data[1] end
        end
    end

    -- 2. Carga inicial si no hay datos o es manual
    if isManual or not db.top6 or not next(db.top6) then
        if manualData then
            db.top6 = db.top6 or {}
            db.bis = db.bis or {}
            for slotKey, firstID in pairs(self.manualMap) do
                -- Buscar el set completo en manualData para el top6
                for _, data in ipairs(manualData) do
                    if GearAnalyzer:GetSlotKey(data.slot_name) == slotKey then
                        db.top6[slotKey] = { data[1], data[2], data[3], data[4], data[5], data[6] }
                        break
                    end
                end
                db.bis[slotKey] = { itemID = firstID }
            end
            isManual = true
            phase = "MANUAL"
            db.phase = "MANUAL"
        elseif not isManual then
            GearAnalyzer:SyncWithBiSTooltip(phase, nil, ignoreForced)
        end
    end

    UIDropDownMenu_SetSelectedValue(self.dropdown, phase)
    UIDropDownMenu_SetText(self.dropdown, (phase == "MANUAL" and ("|cffffff00" .. L["INTERNAL"] .. "|r") or phase))

    local titleSuffix = isManual and (" |cffffff00(" .. L["INTERNAL_DB"] .. ")|r") or ""
    self.titleString:SetText(L["FINAL_BIS_GUIDE"] .. " - " .. classLoc .. " " .. specLabel .. titleSuffix)

    -- Obtener tabla de mejoras (encantamientos y gemas) sugeridas para esta fase/spec
    local slotEnhsMap = {}
    local lookupSpec = bisSpec or spec
    if className and lookupSpec and GA_BiSLists and GA_BiSLists[className] and GA_BiSLists[className][lookupSpec] then
        local listPhase = (phase == "MANUAL") and "T10" or phase
        local phaseData = GA_BiSLists[className][lookupSpec][listPhase] or GA_BiSLists[className][lookupSpec]["T10"] or GA_BiSLists[className][lookupSpec]["PR"]
        if phaseData then
            local is17Slots = (#phaseData >= 17)
            for i, data in ipairs(phaseData) do
                if type(data) == "table" then
                    local slotKey = nil
                    if is17Slots then
                        local map17 = {
                            [1]="head",[2]="neck",[3]="shoulders",[4]="back",[5]="chest",
                            [6]="wrists",[7]="hands",[8]="waist",[9]="legs",[10]="feet",
                            [11]="ring1",[12]="ring2",[13]="trinket1",[14]="trinket2",
                            [15]="weapon",[16]="offhand",[17]=(classTag == "HUNTER") and "ranged" or "idol"
                        }
                        slotKey = map17[i]
                    else
                        local map15 = {
                            [1]="head",[2]="neck",[3]="shoulders",[4]="back",[5]="chest",
                            [6]="wrists",[7]="hands",[8]="waist",[9]="legs",[10]="feet",
                            [11]="ring",[12]="trinket",[13]="weapon",[14]="offhand",
                            [15]=(classTag == "HUNTER") and "ranged" or "idol"
                        }
                        slotKey = map15[i]
                    end
                    
                    if slotKey then
                        if slotKey == "ring" then
                            slotEnhsMap["ring1"] = data.enhs
                            slotEnhsMap["ring2"] = data.enhs
                        elseif slotKey == "trinket" then
                            slotEnhsMap["trinket1"] = data.enhs
                            slotEnhsMap["trinket2"] = data.enhs
                        else
                            slotEnhsMap[slotKey] = data.enhs
                        end
                    end
                end
            end
        end
    end

    -- Mostrar cabeceras y reposicionar dinámicamente
    local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
    
    -- Cabecera Mejoras en headerRow
    local headerRow = self.headerIcons[1]:GetParent()
    if not self.headerEnh then
        local h = headerRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        GearAnalyzer:ApplyStyle(h)
        h:SetTextColor(0, 1, 1) -- Cian
        h:SetText(L["ENHANCEMENTS"] or "Mejoras")
        self.headerEnh = h
    end
    self.headerEnh:ClearAllPoints()
    self.headerEnh:SetPoint("TOPLEFT", headerRow, "TOPLEFT", 85, 2)
    self.headerEnh:SetWidth(4 * iconSize + 6)
    self.headerEnh:SetJustifyH("CENTER")
    self.headerEnh:Show()

    if not self.headerEnhSub then
        local h = headerRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        GearAnalyzer:ApplyStyle(h)
        h:SetTextColor(0.7, 0.7, 0.7) -- Gris claro
        h:SetText(L["APPLY_TO_BIS"] or "Aplicar en items bis (gemas)")
        self.headerEnhSub = h
    end
    self.headerEnhSub:ClearAllPoints()
    self.headerEnhSub:SetPoint("TOPLEFT", headerRow, "TOPLEFT", 85 - 20, -12)
    self.headerEnhSub:SetWidth(4 * iconSize + 46)
    self.headerEnhSub:SetJustifyH("CENTER")
    self.headerEnhSub:Show()

    for i = 1, 6 do
        if self.headerIcons[i] then
            self.headerIcons[i]:ClearAllPoints()
            self.headerIcons[i]:SetPoint("LEFT", 230 + ((i-1) * (iconSize + 8)), 0)
            self.headerIcons[i]:SetWidth(iconSize + 4)
            self.headerIcons[i]:Show()
        end
    end
    if self.headerTarget then
        self.headerTarget:ClearAllPoints()
        self.headerTarget:SetPoint("LEFT", 230 + 6 * (iconSize + 8) + 20, 0)
        self.headerTarget:Show()
    end

    -- Hide all rows first
    for _, row in ipairs(self.rows) do row:Hide() end

    local y = -58
    local rowIdx = 1
    for _, info in ipairs(SLOT_INFO) do
        local items = db.top6 and db.top6[info.key]
        if items and #items > 0 then
            local row = self:GetOrCreateRow(rowIdx)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 0, y)
            row:Show()
            
            row.slotLabel:SetText("|cffcccccc" .. info.name .. "|r")
            GearAnalyzer:ApplyStyle(row.slotLabel)

            -- Mostrar Mejoras (Encantamiento y Gemas)
            local enhData = slotEnhsMap[info.key]
            
            -- eIdx 1 = Encantamiento (Izquierda).
            local enchEnh = enhData and enhData[1]
            local enchBtn = row.setupBtns[1]
            local enchIcon = row.setupIcons[1]
            if enchEnh and enchEnh.type ~= "none" then
                local id = enchEnh.id
                local tex = nil
                if enchEnh.type == "item" then
                    local _, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(id)
                    tex = itemTexture or GetItemIcon(id)
                    if not tex then
                        needsRefresh = true
                        GearAnalyzer.scanner:SetHyperlink("item:" .. id)
                    end
                else
                    local _, _, spellTexture = GetSpellInfo(id)
                    tex = spellTexture
                end
                enchIcon:SetTexture(tex or "Interface\\Icons\\INV_Misc_QuestionMark")
                enchBtn.id = id
                enchBtn.isSpell = (enchEnh.type == "spell")
                enchBtn:Show()
            else
                enchBtn:Hide()
            end

            -- Gemas (Derecha): Condensadas para que salgan pegadas sin huecos
            local gemBtnIdx = 2
            for eIdx = 2, 6 do
                local enh = enhData and enhData[eIdx]
                if enh and enh.type ~= "none" then
                    local btn = row.setupBtns[gemBtnIdx]
                    local icon = row.setupIcons[gemBtnIdx]
                    if btn and icon then
                        local id = enh.id
                        local tex = nil
                        if enh.type == "item" then
                            local _, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(id)
                            tex = itemTexture or GetItemIcon(id)
                            if not tex then
                                needsRefresh = true
                                GearAnalyzer.scanner:SetHyperlink("item:" .. id)
                            end
                        else
                            local _, _, spellTexture = GetSpellInfo(id)
                            tex = spellTexture
                        end
                        icon:SetTexture(tex or "Interface\\Icons\\INV_Misc_QuestionMark")
                        btn.id = id
                        btn.isSpell = (enh.type == "spell")
                        btn:Show()
                        gemBtnIdx = gemBtnIdx + 1
                    end
                end
            end
            -- Ocultar botones de gemas restantes
            for j = gemBtnIdx, 4 do
                if row.setupBtns[j] then row.setupBtns[j]:Hide() end
            end
            
            for rank = 1, 6 do
                local itemID = items[rank]
                local btn = row.icons[rank]
                
                if itemID and itemID > 0 then
                    local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemID)
                    if not itemName then 
                        needsRefresh = true 
                        GearAnalyzer.scanner:SetHyperlink("item:" .. itemID)
                    end
                    
                    btn.icon:SetTexture(itemTexture or GetItemIcon(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
                    btn.itemID = itemID
                    btn.itemLink = itemLink
                    btn.rank = rank
                    btn.slotKey = info.key
                    
                    -- Check if character has item
                    local hasItem = false
                    if GearAnalyzer:HasItem(itemID) then
                        hasItem = true
                    end
                    if hasItem then btn.check:Show() else btn.check:Hide() end
                    
                    -- Resaltar si es el objetivo actual (custom o bis)
                    btn.border:Hide() -- Eliminados bordes verde/blanco por petición
                    btn:Show()
                else
                    btn:Hide()
                end
            end
            
            -- REAJUSTAR POSICIONES DINÁMICAMENTE
            row:SetHeight(iconSize + 10)
            
            -- Posicionar Enchant
            row.setupBtns[1]:SetSize(iconSize, iconSize)
            row.setupBtns[1]:ClearAllPoints()
            row.setupBtns[1]:SetPoint("LEFT", 85, 0)
            
            -- Posicionar Gemas
            for eIdx = 2, 4 do
                local btn = row.setupBtns[eIdx]
                if btn then
                    btn:SetSize(iconSize, iconSize)
                    btn:ClearAllPoints()
                    btn:SetPoint("LEFT", 85 + iconSize + 2 + (eIdx - 2) * (iconSize + 2), 0)
                end
            end
            
            -- Posicionar Ranks
            for r = 1, 6 do
                row.icons[r]:SetSize(iconSize, iconSize)
                row.icons[r]:ClearAllPoints()
                row.icons[r]:SetPoint("LEFT", 230 + ((r-1) * (iconSize + 8)), 0)
            end
            
            -- ICONO BiS GUÍA (MANUAL) - Ocultado por petición del usuario para simplificar el panel de PJ
            local mBtn = row.manualBtn
            if mBtn then mBtn:Hide() end
            
            row.targetBtn:SetSize(iconSize * 1.1, iconSize * 1.1)
            row.targetBtn:ClearAllPoints()
            row.targetBtn:SetPoint("LEFT", 230 + 6 * (iconSize + 8) + 20, 0)
            local targetID = nil
            local cSlot = db.custom_bis and db.custom_bis[info.key]
            local bSlot = db.bis and db.bis[info.key]
            
            if cSlot then
                targetID = (type(cSlot) == "table") and cSlot.itemID or cSlot
            elseif bSlot then
                targetID = (type(bSlot) == "table") and bSlot.itemID or bSlot
            end
            
            if not targetID and items[1] then targetID = items[1] end -- Fallback al top 1
            
            if targetID then
                local tBtn = row.targetBtn
                local itemName, tLink, _, _, _, _, _, _, _, tTexture = GetItemInfo(targetID)
                tBtn.icon:SetTexture(tTexture or GetItemIcon(targetID) or "Interface\\Icons\\INV_Misc_QuestionMark")
                tBtn.itemID = targetID
                tBtn.itemLink = tLink
                tBtn:Show()
                
                -- Mostrar Nombre y Jefe (Usando el nuevo Sistema de Fuentes con Seguridad)
                local inst, boss = L["TOKEN_MISSION"], L["PROFESSION_VENDOR"]
                if GearAnalyzer.GetItemSource then
                    inst, boss = GearAnalyzer:GetItemSource(targetID)
                end
                local sourceText = (inst or L["TOKEN_MISSION"]) .. " - |cffffd100" .. (boss or L["PROFESSION_VENDOR"]) .. "|r"
                
                row.tName:SetText(tLink or itemName or L["LOADING"])
                GearAnalyzer:ApplyStyle(row.tName)
                row.tSource:SetText(sourceText)
                GearAnalyzer:ApplyStyle(row.tSource)
                row.tName:Show()
                row.tSource:Show()
                tBtn.border:Hide() -- Eliminar borde verde del objetivo
                
                if GearAnalyzer:HasItem(targetID) then
                    tBtn.check:Show()
                else
                    tBtn.check:Hide()
                end
            else
                row.targetBtn:Hide()
                row.tName:Hide()
                row.tSource:Hide()
            end
            
            y = y - (iconSize + 16)
            rowIdx = rowIdx + 1
        end
    end

    -- Legend (Instrucciones de uso)
    local legend = self:GetOrCreateLegend(self.content)
    legend:SetPoint("TOPLEFT", 10, y - 10)
    legend:Show()

    self.content:SetHeight(math.abs(y) + 100)

    if needsRefresh then
        if not self.refreshTimer then
            self.refreshTimer = true
            GearAnalyzer:After(1.5, function() 
                self.refreshTimer = false
                if self.container:IsVisible() then self:Update() end
            end)
        end
    end
end

function Tab:GetOrCreateLegend(parent)
    if self.legend then return self.legend end
    local legend = CreateFrame("Frame", nil, parent)
    legend:SetSize(parent:GetWidth() - 20, 70)
    
    local legTitle = legend:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    legTitle:SetPoint("TOPLEFT", 8, 0)
    legTitle:SetText("|cffffd100" .. L["USAGE_INSTRUCTIONS"] .. ":|r")
    
    local legText = legend:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    legText:SetPoint("TOPLEFT", 8, -18)
    legText:SetJustifyH("LEFT")
    legText:SetText(
        "- |cffffff00" .. L["ALT_CLICK"] .. "|r: " .. L["ALT_CLICK_DESC"] .. "\n" ..
        "- |cff00ff00" .. L["GREEN_BORDER"] .. "|r: " .. L["GREEN_BORDER_DESC"] .. "\n" ..
        "- |cffaaaaaa" .. L["SAVE_BETWEEN_SESSIONS"] .. "|r"
    )
    self.legend = legend
    return legend
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] then return self.rows[i] end
    
    local row = CreateFrame("Frame", nil, self.content)
    row:SetSize(self.content:GetWidth(), 42)
    
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetPoint("TOPLEFT", 0, -2)
    bg:SetPoint("BOTTOMRIGHT", 0, 2)
    bg:SetTexture(1, 1, 1, 0.03)

    local slotLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    slotLabel:SetPoint("LEFT", 5, 0)
    slotLabel:SetWidth(70)
    slotLabel:SetJustifyH("LEFT")
    row.slotLabel = slotLabel

    -- Botón de Encantamiento
    row.setupBtns = {}
    row.setupIcons = {}

    local enchBtn = CreateFrame("Button", nil, row)
    enchBtn:SetSize(32, 32)
    enchBtn:SetPoint("LEFT", 85, 0)
    local enchIcon = enchBtn:CreateTexture(nil, "ARTWORK")
    enchIcon:SetAllPoints()
    enchBtn.icon = enchIcon
    row.setupBtns[1] = enchBtn
    row.setupIcons[1] = enchIcon

    enchBtn:SetScript("OnEnter", function(s)
        if s.id then
            GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
            if s.isSpell then
                GameTooltip:SetHyperlink("spell:" .. s.id)
            else
                GameTooltip:SetHyperlink("item:" .. s.id)
            end
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff00ff00Sugerencia de Encantamiento|r")
            GameTooltip:Show()
        end
    end)
    enchBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    enchBtn:SetScript("OnClick", function(s)
        if s.id then
            local link = nil
            if s.isSpell then
                link = GetSpellLink(s.id)
            else
                local _, itemLink = GetItemInfo(s.id)
                link = itemLink or ("item:" .. s.id)
            end
            if link then
                HandleModifiedItemClick(link)
            end
        end
    end)

    -- Botones de Gemas
    for eIdx = 2, 4 do
        local btn = CreateFrame("Button", nil, row)
        btn:SetSize(32, 32)
        btn:SetPoint("LEFT", 85 + 32 + 2 + (eIdx - 2) * 34, 0)
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        btn.icon = icon
        row.setupBtns[eIdx] = btn
        row.setupIcons[eIdx] = icon

        btn:SetScript("OnEnter", function(s)
            if s.id then
                GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink("item:" .. s.id)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cff00ffffSugerencia de Gema|r")
                GameTooltip:Show()
            end
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        btn:SetScript("OnClick", function(s)
            if s.id then
                local _, itemLink = GetItemInfo(s.id)
                local link = itemLink or ("item:" .. s.id)
                HandleModifiedItemClick(link)
            end
        end)
    end
 
    row.icons = {}
    for rank = 1, 6 do
        local btn = CreateFrame("Button", nil, row)
        btn:SetSize(38, 38) -- Tamaño aumentado (antes 32)
        btn:SetPoint("LEFT", 80 + ((rank-1) * 42), 0) -- Espaciado ajustado
        
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        btn.icon = icon
        
        local check = btn:CreateTexture(nil, "OVERLAY")
        check:SetTexture("Interface\\AddOns\\GearAnalyzer\\checkmark-16.tga") -- Path corrected relative to Interface
        check:SetSize(14, 14)
        check:SetPoint("BOTTOMRIGHT", 2, -2)
        btn.check = check
        
        local border = btn:CreateTexture(nil, "OVERLAY")
        border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
        border:SetBlendMode("ADD")
        border:SetAlpha(0.6)
        border:SetPoint("CENTER", 0, 0)
        border:SetSize(48, 48)
        btn.border = border

        btn:SetScript("OnEnter", function(self)
            if self.itemID then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink("item:" .. self.itemID)
                
                local inst, boss = L["TOKEN_MISSION"], L["PROFESSION_VENDOR"]
                if GearAnalyzer.GetItemSource then
                    inst, boss = GearAnalyzer:GetItemSource(self.itemID)
                end
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cffffd100" .. L["SOURCE_COLON"] .. "|r")
                GameTooltip:AddLine("|cff00ccff" .. (inst or L["TOKEN_MISSION"]) .. "|r - |cffffffff" .. (boss or L["PROFESSION_VENDOR"]) .. "|r")
                
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(L["RANKING"] .. ": |cffffffffTop " .. self.rank .. "|r")
                if GearAnalyzer:HasItem(self.itemID) then
                    GameTooltip:AddLine("|cff00ff00" .. L["ALREADY_HAVE_ITEM"] .. "|r")
                end
                
                local isDev = GearAnalyzer.charDB and GearAnalyzer.charDB.settings and GearAnalyzer.charDB.settings.devMode
                if isDev then
                    GameTooltip:AddLine("ID: |cff00ff00" .. self.itemID .. "|r")
                end
                GameTooltip:Show()
            end
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        btn:SetScript("OnClick", function(self)
            if IsAltKeyDown() and self.itemID then
                local profile = GearAnalyzer.db.profile
                profile.custom_bis = profile.custom_bis or {}
                profile.custom_bis[self.slotKey] = { itemID = self.itemID }
                
                -- Actualizar db.bis actual para que Análisis lo vea
                profile.bis = profile.bis or {}
                profile.bis[self.slotKey] = { itemID = self.itemID }
                
                print("|cff00ff00GearAnalyzer:|r " .. string.format(L["TARGET_SAVED_MSG"], self.slotKey, (self.itemLink or self.itemID)))
                GearAnalyzer:AnalyzeEquipment()
                Tab:Update()
            elseif self.itemLink or self.itemID then
                HandleModifiedItemClick(self.itemLink or ("item:"..self.itemID))
            end
        end)
        
        row.icons[rank] = btn
    end

    -- Icono BiS Manual (Guía)
    local mBtn = CreateFrame("Button", nil, row)
    mBtn:SetSize(32, 32)
    mBtn:SetPoint("LEFT", 330, 0)
    local mIcon = mBtn:CreateTexture(nil, "ARTWORK")
    mIcon:SetAllPoints()
    mBtn.icon = mIcon
    local mCheck = mBtn:CreateTexture(nil, "OVERLAY")
    mCheck:SetTexture("Interface\\AddOns\\GearAnalyzer\\checkmark-16.tga")
    mCheck:SetSize(14, 14)
    mCheck:SetPoint("BOTTOMRIGHT", 2, -2)
    mBtn.check = mCheck
    local mBorder = mBtn:CreateTexture(nil, "OVERLAY")
    mBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    mBorder:SetBlendMode("ADD")
    mBorder:SetVertexColor(0, 1, 1) -- Cian
    mBorder:SetPoint("CENTER", 0, 0)
    mBorder:SetSize(48, 48)
    mBorder:SetAlpha(0.6)
    mBtn.border = mBorder
    
    mBtn:SetScript("OnEnter", function(self)
        if self.itemID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. self.itemID)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff00ffff" .. L["GUIDE_RECOMMENDATION"] .. "|r")
            GameTooltip:AddLine("|cffaaaaaa(" .. L["ABSOLUTE_BIS"] .. ")|r")
            GameTooltip:Show()
        end
    end)
    mBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    mBtn:SetScript("OnClick", function(self)
        if IsAltKeyDown() and self.itemID then
            -- Fijar como objetivo
            local profile = GearAnalyzer.db.profile
            profile.custom_bis = profile.custom_bis or {}
            profile.custom_bis[self.slotKey] = { itemID = self.itemID }
            profile.bis = profile.bis or {}
            profile.bis[self.slotKey] = { itemID = self.itemID }
            GearAnalyzer:AnalyzeEquipment()
            Tab:Update()
        elseif self.itemLink or self.itemID then
            HandleModifiedItemClick(self.itemLink or ("item:"..self.itemID))
        end
    end)
    row.manualBtn = mBtn

    -- Icono de Objetivo (Más grande y centrado)
    local tBtn = CreateFrame("Button", nil, row)
    tBtn:SetSize(42, 42) -- Tamaño aumentado (antes 34)
    tBtn:SetPoint("LEFT", 380, 0)
    
    local tIcon = tBtn:CreateTexture(nil, "ARTWORK")
    tIcon:SetAllPoints()
    tBtn.icon = tIcon
    
    local tCheck = tBtn:CreateTexture(nil, "OVERLAY")
    tCheck:SetTexture("Interface\\AddOns\\GearAnalyzer\\checkmark-16.tga")
    tCheck:SetSize(14, 14)
    tCheck:SetPoint("BOTTOMRIGHT", 2, -2)
    tBtn.check = tCheck

    local tBorder = tBtn:CreateTexture(nil, "OVERLAY")
    tBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    tBorder:SetBlendMode("ADD")
    tBorder:SetVertexColor(0, 1, 0)
    tBorder:SetPoint("CENTER", 0, 0)
    tBorder:SetSize(52, 52)
    tBtn.border = tBorder

    local tName = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    tName:SetPoint("LEFT", tBtn, "RIGHT", 12, 10)
    tName:SetWidth(170) -- Más ancho para nombres largos
    tName:SetJustifyH("LEFT")
    row.tName = tName

    local tSource = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    tSource:SetPoint("LEFT", tBtn, "RIGHT", 12, -10)
    tSource:SetWidth(170)
    tSource:SetJustifyH("LEFT")
    row.tSource = tSource
    
    tBtn:SetScript("OnEnter", function(self)
        if self.itemID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. self.itemID)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff00ff00" .. L["CURRENT_TARGET"] .. "|r")
            GameTooltip:AddLine("|cffaaaaaa(" .. L["CHOSEN_VIA_ALT_CLICK"] .. ")|r")
            GameTooltip:Show()
        end
    end)
    tBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    tBtn:SetScript("OnClick", function(self)
        if self.itemLink or self.itemID then
            HandleModifiedItemClick(self.itemLink or ("item:"..self.itemID))
        end
    end)
    row.targetBtn = tBtn

    self.rows[i] = row
    return row
end
