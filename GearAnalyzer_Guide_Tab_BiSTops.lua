-- ===================================================
-- GearAnalyzer Guide Tab: BiS / Tops (Ventana Guía)
-- Módulo independiente - siempre usa ignoreForced=false
-- ===================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabBiSTopsGuide")

local function GetSlotInfo()
    local class = GearAnalyzer:GetClassToken(false)
    local isRangedClass = (class == "HUNTER" or class == "ROGUE" or class == "WARRIOR")
    
    return {
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
        { key = "ring1",     name = L["SLOT_RING"] },
        { key = "trinket1",  name = L["SLOT_TRINKET"] },
        { key = "weapon",    name = L["SLOT_WEAPON"] },
        { key = "offhand",   name = L["SLOT_OFFHAND"] },
        { key = isRangedClass and "ranged" or "idol", name = L["SLOT_RELIC"] },
    }
end

function Tab:Update(page, ignoreForced)
    if not page then return end

    local db = GearAnalyzer.db.profile
    if not db.guidePhase then
        db.guidePhase = "RS"
    end
    
    local classLoc = GearAnalyzer:GetLocalizedClassName(false)
    local classTag = GearAnalyzer:GetClassToken(false)
    local spec     = GearAnalyzer:GetCurrentSpecEnhanced(false)
    local specLabel = GearAnalyzer:GetSpecLabel(spec)
    
    local bisSpec = GearAnalyzer:GetBiSTooltipSpec(false)
    local className = classTag 

    local manualDataMap = {}
    if className and bisSpec and GA_BiSLists[className] and GA_BiSLists[className][bisSpec] then
        local rawData = GA_BiSLists[className][bisSpec][db.guidePhase or "T10"] or GA_BiSLists[className][bisSpec]["PR"]
        if rawData then
            for _, data in ipairs(rawData) do
                local slotKey = GearAnalyzer:GetSlotKey(data.slot_name)
                if slotKey then 
                    manualDataMap[slotKey] = {
                        data[1], data[2], data[3], data[4], data[5], data[6],
                        enhs = data.enhs
                    }
                end
            end
        end
    end

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

        local dropdown = CreateFrame("Frame", "GA_PhaseTabDropdownGuide", f, "UIDropDownMenuTemplate")
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
                info.text = p.name; info.value = p.val
                info.func = function(s)
                    UIDropDownMenu_SetSelectedValue(dropdown, s.value)
                    db.guidePhase = s.value
                    self:Update(page, false)
                end
                info.checked = (db.guidePhase == p.val)
                UIDropDownMenu_AddButton(info)
            end
        end)
        self.dropdown = dropdown

        -- ScrollFrame
        local scroll = CreateFrame("ScrollFrame", "GABiSTopsScrollGuide", f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -9, 10)
        self.scroll = scroll

        local content = CreateFrame("Frame", nil, scroll)
        local w = f:GetWidth()
        if not w or w <= 0 then w = 760 end
        content:SetSize(w - 40, 800)
        scroll:SetScrollChild(content)
        self.content = content

        -- Header row (T1-T6)
        local headerRow = CreateFrame("Frame", nil, content)
        headerRow:SetSize(content:GetWidth(), 20)
        headerRow:SetPoint("TOPLEFT", 0, -5)
        
        -- Cabecera Mejoras en headerRow
        local hEnh = headerRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        GearAnalyzer:ApplyStyle(hEnh)
        hEnh:SetTextColor(0, 1, 1) -- Cian
        hEnh:SetText(L["ENHANCEMENTS"] or "Mejoras")
        hEnh:SetPoint("LEFT", 85, 4)
        hEnh:SetWidth(136)
        hEnh:SetJustifyH("CENTER")
        self.headerEnh = hEnh

        local hEnhSub = headerRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        GearAnalyzer:ApplyStyle(hEnhSub)
        hEnhSub:SetTextColor(0.7, 0.7, 0.7) -- Gris claro
        hEnhSub:SetText(L["APPLY_TO_BIS"] or "Aplicar en items bis (gemas)")
        hEnhSub:SetPoint("LEFT", 85 - 20, -8)
        hEnhSub:SetWidth(136 + 40)
        hEnhSub:SetJustifyH("CENTER")
        self.headerEnhSub = hEnhSub

        for i = 1, 6 do
            local h = headerRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            h:SetPoint("LEFT", 230 + ((i-1) * 40), 0)
            h:SetWidth(34)
            h:SetJustifyH("CENTER")
            h:SetText("T" .. i)
            h:SetTextColor(1, 0.82, 0)
        end
        
        local hName = headerRow:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hName:SetPoint("LEFT", 230 + (6 * 40) + 10, 0)
        hName:SetText(L["GUIDE"] or "GUIA")
        hName:SetTextColor(0, 1, 1)
        self.headerName = hName

        self.headerRow = headerRow

        self.rows = {}
    end

    self.titleString:SetText(L["TAB_BIS"] .. " - " .. classLoc .. " " .. specLabel)
    GearAnalyzer:SetupGuideIcons(page, classTag, spec)

    if self.dropdown then
        UIDropDownMenu_SetSelectedValue(self.dropdown, db.guidePhase)
        local phases = {
            { name = "Pre-Raid / Heroes", val = "PR" },
            { name = "T9 (TotC)", val = "T9" },
            { name = "T10 (ICC)", val = "T10" },
            { name = "RS (Ruby Sanctum)", val = "RS" },
        }
        local currentName = "RS (Ruby Sanctum)"
        for _, p in ipairs(phases) do
            if p.val == db.guidePhase then
                currentName = p.name
                break
            end
        end
        UIDropDownMenu_SetText(self.dropdown, currentName)
    end

    local y = -30
    local needsRefresh = false
    local slotInfo = GetSlotInfo()

    -- Ocultar filas sobrantes de actualizaciones previas
    for idx = #slotInfo + 1, #self.rows do
        if self.rows[idx] then
            self.rows[idx]:Hide()
        end
    end
    for i, slot in ipairs(slotInfo) do
        local row = self:GetOrCreateRow(i)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 0, y)
        row:Show()

        row.slotText:SetText("|cffcccccc" .. slot.name .. "|r")
        
        local items = manualDataMap[slot.key]
        
        -- Mostrar Mejoras (Encantamiento y Gemas)
        local enhData = items and items.enhs
        
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
            local itemID = items and items[rank]
            local btn = row.icons[rank]
            
            if itemID and itemID > 0 then
                local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
                if not name then
                    needsRefresh = true
                    GearAnalyzer.scanner:SetHyperlink("item:" .. itemID)
                end
                btn.icon:SetTexture(texture or GetItemIcon(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
                btn.itemID = itemID
                btn.itemLink = link
                btn:Show()
            else
                btn:Hide()
            end
        end

        -- Nombre y Fuente del BiS (Top 1)
        local bisID = items and items[1]
        if bisID and bisID > 0 then
            local name, link = GetItemInfo(bisID)
            row.nameText:SetText(link or name or ("Cargando..."))
            row.itemID = bisID
            row.itemLink = link
            
            local inst, boss = "...", "..."
            if GearAnalyzer.GetItemSource then
                inst, boss = GearAnalyzer:GetItemSource(bisID)
            end
            row.sourceText:SetText((inst or "") .. " - |cffffd100" .. (boss or "") .. "|r")
            row.nameText:Show()
            row.sourceText:Show()
        else
            row.itemID = nil
            row.nameText:Hide()
            row.sourceText:Hide()
        end

        y = y - 42
    end
    self.content:SetHeight(math.abs(y) + 40)
    
    if needsRefresh then
        GearAnalyzer:After(1, function() if self.container:IsVisible() then self:Update(page, false) end end)
    end
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] then return self.rows[i] end
    local row = CreateFrame("Frame", nil, self.content)
    row:SetSize(self.content:GetWidth(), 40)
    
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(); bg:SetTexture(1, 1, 1, 0.03)

    local slotText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    slotText:SetPoint("LEFT", 5, 0)
    slotText:SetWidth(70)
    slotText:SetJustifyH("LEFT")
    row.slotText = slotText

    -- Botón de Encantamiento y Gemas
    row.setupBtns = {}
    row.setupIcons = {}

    local enchBtn = CreateFrame("Button", nil, row)
    enchBtn:SetSize(34, 34)
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
        btn:SetSize(34, 34)
        btn:SetPoint("LEFT", 85 + 34 + 2 + (eIdx - 2) * 36, 0)
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
                if link then
                    HandleModifiedItemClick(link)
                end
            end
        end)
    end

    row.icons = {}
    for rank = 1, 6 do
        local btn = CreateFrame("Button", nil, row)
        btn:SetSize(34, 34)
        btn:SetPoint("LEFT", 230 + ((rank-1) * 40), 0)
        
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        btn.icon = icon
        
        btn:SetScript("OnEnter", function(self)
            if self.itemID then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink("item:" .. self.itemID)
                GameTooltip:Show()
            end
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        btn:SetScript("OnClick", function(self)
            if self.itemLink or self.itemID then
                HandleModifiedItemClick(self.itemLink or ("item:"..self.itemID))
            end
        end)
        row.icons[rank] = btn
    end

    local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    nameText:SetPoint("LEFT", 230 + (6 * 40) + 10, 10)
    nameText:SetWidth(190)
    nameText:SetJustifyH("LEFT")
    row.nameText = nameText

    local sourceText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    sourceText:SetPoint("LEFT", 230 + (6 * 40) + 10, -10)
    sourceText:SetWidth(190)
    sourceText:SetJustifyH("LEFT")
    row.sourceText = sourceText

    -- Botón invisible para la interacción de Tooltip y Click sobre el texto del BiS
    local bisInteractive = CreateFrame("Button", nil, row)
    bisInteractive:SetSize(190, 40)
    bisInteractive:SetPoint("LEFT", 230 + (6 * 40) + 10, 0)
    
    bisInteractive:SetScript("OnEnter", function(self)
        local parent = self:GetParent()
        if parent.itemID and parent.itemID > 0 then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. parent.itemID)
            GameTooltip:Show()
        end
    end)
    bisInteractive:SetScript("OnLeave", function() GameTooltip:Hide() end)
    bisInteractive:SetScript("OnClick", function(self)
        local parent = self:GetParent()
        if parent.itemID and parent.itemID > 0 then
            HandleModifiedItemClick(parent.itemLink or ("item:"..parent.itemID))
        end
    end)
    row.bisInteractive = bisInteractive

    self.rows[i] = row
    return row
end
