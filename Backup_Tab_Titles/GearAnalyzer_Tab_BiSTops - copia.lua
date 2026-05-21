-- =========================
-- GearAnalyzer Tab: BiS / Tops
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabBiSTops")

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
    { key = (select(2, UnitClass("player")) == "HUNTER") and "ranged" or "idol", 
      name = (select(2, UnitClass("player")) == "HUNTER") and L["SLOT_RANGED"] or L["SLOT_RELIC"] },
}

function Tab:Update(page, ignoreForced)
    if not page then return end

    local db = GearAnalyzer.db.profile
    local needsRefresh = false
    
    -- DETECCIÓN DE MODO (AUTOMÁTICO VS MANUAL)
    local classLoc = GearAnalyzer:GetLocalizedClassName(ignoreForced)
    local classTag = GearAnalyzer:GetClassToken(ignoreForced)
    local spec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local specLabel = GearAnalyzer:GetSpecLabel(spec)
    
    local _, playerClass = UnitClass("player")
    local className = classTag -- "WARLOCK", "PRIEST", etc.
    
    local bisSpec = GearAnalyzer:GetBiSTooltipSpec(true)
    
    if className and bisSpec and GA_BiSLists[className] and GA_BiSLists[className][bisSpec] then
        manualData = GA_BiSLists[className][bisSpec]["T10"] or GA_BiSLists[className][bisSpec]["PR"]
    end

    -- 1. CREACIÓN ÚNICA DE ELEMENTOS ESTÁTICOS
    if not self.container then
        local f = CreateFrame("Frame", nil, page)
        f:SetAllPoints()
        self.container = f
        
        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -5)
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
                { name = "|cffffff00" .. L["INTERNAL_GUIDES"] .. "|r", val = "MANUAL" },
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
        scroll:SetPoint("BOTTOMRIGHT", -30, 20)

        local content = CreateFrame("Frame", nil, scroll)
        local w = page:GetWidth()
        if not w or w <= 0 then w = 1060 end
        content:SetWidth(w - 40)
        content:SetHeight(500)
        scroll:SetScrollChild(content)
        self.content = content
        
        -- Column labels (Top 1-6)
        local headerRow = CreateFrame("Frame", nil, content)
        headerRow:SetSize(content:GetWidth(), 20)
        headerRow:SetPoint("TOPLEFT", 0, -5)
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

        -- Nueva columna: BiS GUÍA (Manual)
        local hMan = headerRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
        hMan:SetPoint("LEFT", 80 + (6 * (iconSize + 8)) + 15, 0)
        hMan:SetWidth(iconSize + 4)
        hMan:SetJustifyH("CENTER")
        hMan:SetText(L["GUIDE"])
        GearAnalyzer:ApplyStyle(hMan)
        hMan:SetTextColor(0, 1, 1) -- Cyan
        self.headerManual = hMan
        
        local hObj = headerRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hObj:SetPoint("LEFT", 80 + (7 * (iconSize + 8)) + 30, 0)
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

    -- Mostrar cabeceras
    for i = 1, 6 do
        if self.headerIcons[i] then self.headerIcons[i]:Show() end
    end
    if self.headerTarget then self.headerTarget:Show() end

    -- Hide all rows first
    for _, row in ipairs(self.rows) do row:Hide() end

    local y = -35
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
            local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
            row:SetHeight(iconSize + 10)
            for r = 1, 6 do
                row.icons[r]:SetSize(iconSize, iconSize)
                row.icons[r]:ClearAllPoints()
                row.icons[r]:SetPoint("LEFT", 80 + ((r-1) * (iconSize + 8)), 0)
            end
            
            -- ICONO BiS GUÍA (MANUAL)
            local manualID = self.manualMap and self.manualMap[info.key]
            
            local mBtn = row.manualBtn
            if manualID and manualID > 0 then
                local _, mLink, _, _, _, _, _, _, _, mTex = GetItemInfo(manualID)
                mBtn.icon:SetTexture(mTex or GetItemIcon(manualID) or "Interface\\Icons\\INV_Misc_QuestionMark")
                mBtn.itemID = manualID
                mBtn.itemLink = mLink
                mBtn.slotKey = info.key
                mBtn:SetSize(iconSize, iconSize)
                mBtn:ClearAllPoints()
                mBtn:SetPoint("LEFT", 80 + (6 * (iconSize + 8)) + 15, 0)
                mBtn:Show()
                
                -- Check si lo tiene puesto
                if GearAnalyzer:HasItem(manualID) then
                    mBtn.check:Show()
                else
                    mBtn.check:Hide()
                end
            else
                mBtn:Hide()
            end
            
            row.targetBtn:SetSize(iconSize * 1.1, iconSize * 1.1)
            row.targetBtn:ClearAllPoints()
            row.targetBtn:SetPoint("LEFT", 80 + (7 * (iconSize + 8)) + 30, 0)
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
    y = y - 80 -- Espacio extra para asegurar que se vea al final del scroll

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
    tName:SetWidth(400) -- Más ancho para nombres largos
    tName:SetJustifyH("LEFT")
    row.tName = tName

    local tSource = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    tSource:SetPoint("LEFT", tBtn, "RIGHT", 12, -10)
    tSource:SetWidth(400)
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
