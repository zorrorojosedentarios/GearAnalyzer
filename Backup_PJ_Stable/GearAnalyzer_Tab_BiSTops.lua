-- =========================
-- GearAnalyzer Tab: BiS / Tops (Scrollable & Fixed Version)
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
    { key = "ranged",    name = L["SLOT_RELIC"] },
}

-- [INTERNAL] Traductores autónomos
local function GetInternalClassToken()
    local _, class = UnitClass("player")
    return class
end

local function GetInternalSpecName()
    local spec = "None"
    local _, class = UnitClass("player")
    local t1 = select(3, GetTalentTabInfo(1)) or 0
    local t2 = select(3, GetTalentTabInfo(2)) or 0
    local t3 = select(3, GetTalentTabInfo(3)) or 0
    
    if class == "DEATHKNIGHT" then
        if t1 > t2 and t1 > t3 then spec = "Blood tank"
        elseif t2 > t1 and t2 > t3 then spec = "Frost"
        elseif t3 > t1 and t3 > t2 then spec = "Unholy"
        end
    elseif class == "MAGE" then
        if t1 > t2 and t1 > t3 then spec = "Arcane"
        elseif t2 > t1 and t2 > t3 then spec = "Fire"
        elseif t3 > t1 and t3 > t2 then spec = "Frost"
        end
    elseif class == "PALADIN" then
        if t1 > t2 and t1 > t3 then spec = "Holy"
        elseif t2 > t1 and t2 > t3 then spec = "Protection"
        elseif t3 > t1 and t3 > t2 then spec = "Retribution"
        end
    end
    if spec == "None" then spec = "Frost" end 
    return spec
end

local function GetInternalSlotKey(slotName)
    if not slotName then return nil end
    local s = slotName:lower()
    if s == "head" then return "head" end
    if s == "neck" then return "neck" end
    if s == "shoulder" or s == "shoulders" then return "shoulders" end
    if s == "back" then return "back" end
    if s == "chest" then return "chest" end
    if s == "wrist" or s == "wrists" then return "wrists" end
    if s == "hands" then return "hands" end
    if s == "waist" then return "waist" end
    if s == "legs" then return "legs" end
    if s == "feet" then return "feet" end
    if s == "finger" then return "ring1" end
    if s == "trinket" then return "trinket1" end
    if s == "weapon" then return "weapon" end
    if s == "off hand" or s == "offhand" then return "offhand" end
    if s == "relic" or s == "idol" or s == "totem" or s == "libram" then return "ranged" end
    return s
end

function Tab:Update(page, ignoreForced)
    if page then
        self.page = page
    else
        page = self.page
    end
    if not page then return end

    if ignoreForced == nil then ignoreForced = true end
    local db = GearAnalyzer.db.profile
    local classTag = GearAnalyzer:GetClassToken(ignoreForced)
    local spec     = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    
    local classMap = {
        ["DEATHKNIGHT"] = "Death knight", ["DRUID"] = "Druid", ["HUNTER"] = "Hunter",
        ["MAGE"] = "Mage", ["PALADIN"] = "Paladin", ["PRIEST"] = "Priest",
        ["ROGUE"] = "Rogue", ["SHAMAN"] = "Shaman", ["WARRIOR"] = "Warrior", ["WARLOCK"] = "Warlock"
    }
    local bisClassName = classMap[classTag] or classTag

    local rawBiS = _G.Bistooltip_wowtbc_bislists
    local manualDataMap = {}
    local phaseName = db.phase or "T10"
    
    if rawBiS and rawBiS[bisClassName] and rawBiS[bisClassName][spec] then
        local phaseData = rawBiS[bisClassName][spec][phaseName] or rawBiS[bisClassName][spec]["T10"] or rawBiS[bisClassName][spec]["PR"]
        if phaseData then
            for _, data in ipairs(phaseData) do
                local slotKey = GetInternalSlotKey(data.slot_name)
                if slotKey then
                    local items = { data[1], data[2], data[3], data[4], data[5], data[6] }
                    -- Guardar también la tabla de encantamientos/gemas (enhs)
                    manualDataMap[slotKey] = { items = items, enhs = data.enhs }
                    if slotKey == "ring1" then manualDataMap["ring2"] = { items = items, enhs = data.enhs } end
                    if slotKey == "trinket1" then manualDataMap["trinket2"] = { items = items, enhs = data.enhs } end
                end
            end
        end
    end

    -- 1. ESTRUCTURA DE SCROLL
    if not self.container then
        local f = CreateFrame("Frame", nil, page)
        f:SetAllPoints()
        self.container = f
        
        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -5)
        self.titleString = title

        local phaseSelector = LibStub("AceGUI-3.0"):Create("Dropdown")
        phaseSelector:SetLabel("Fase:")
        phaseSelector:SetWidth(150)
        phaseSelector:SetPoint("TOPRIGHT", -10, -5)
        phaseSelector:AddItem("PR", "Pre-Raid")
        phaseSelector:AddItem("T7", "T7 (Naxx)")
        phaseSelector:AddItem("T8", "T8 (Ulduar)")
        phaseSelector:AddItem("T9", "T9 (ToC)")
        phaseSelector:AddItem("T10", "T10 (ICC)")
        phaseSelector:AddItem("RS", "RS (Ruby Sanctum)")
        phaseSelector:SetValue(phaseName)
        phaseSelector:SetCallback("OnValueChanged", function(_, _, value)
            db.phase = value
            Tab:Update(page, ignoreForced)
        end)
        f.phaseSelector = phaseSelector
        
        -- ScrollFrame
        local scrollFrame = CreateFrame("ScrollFrame", "GAScrollFrame", f, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 5, -80)
        scrollFrame:SetPoint("BOTTOMRIGHT", -25, 10)
        
        local content = CreateFrame("Frame", nil, scrollFrame)
        content:SetSize(700, 800) -- Aumentado para soportar filas más altas
        scrollFrame:SetScrollChild(content)
        self.scrollContent = content
        
        -- Soporte para rueda del ratón
        scrollFrame:EnableMouseWheel(true)
        scrollFrame:SetScript("OnMouseWheel", function(s, delta)
            local current = s:GetVerticalScroll()
            local new = current - (delta * 40) -- Scroll un poco más rápido por iconos grandes
            if new < 0 then new = 0 end
            local maxScroll = s:GetVerticalScrollRange()
            if new > maxScroll then new = maxScroll end
            s:SetVerticalScroll(new)
        end)

        local instr = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        instr:SetPoint("TOPLEFT", 10, -35)
        instr:SetText("|cffffff00INSTRUCCIONES:|r Iconos Izq (Mejoras). Check Verde (Equipado). |cff00ff00Alt+Click|r: Fijar BiS Manual.")
        
        -- Botón Reset BiS Manual
        local resetBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        resetBtn:SetSize(70, 22)
        resetBtn:SetPoint("TOPRIGHT", -20, -30)
        resetBtn:SetText("RESET")
        resetBtn:SetScript("OnClick", function()
            local profile = GearAnalyzer.db.profile
            profile.bis = nil 
            profile.custom_bis = nil
            print("|cff00ff00GearAnalyzer:|r Selección BiS restablecida al Top 1.")
            GearAnalyzer:AnalyzeEquipment()
            Tab:Update()
        end)
        resetBtn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Restaurar BiS")
            GameTooltip:AddLine("Limpia tus objetivos fijados manualmente\ny vuelve a los Top 1 por defecto.", 1, 1, 1)
            GameTooltip:Show()
        end)
        resetBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        self.resetBtn = resetBtn

        -- [GA_FEATURE] Encabezados de Top 1 a Top 6
        local enhHeader = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        enhHeader:SetPoint("LEFT", f, "TOPLEFT", 90, -68)
        enhHeader:SetWidth(160)
        enhHeader:SetJustifyH("CENTER")
        enhHeader:SetText("|cff00ffffGemas recomendadas al tener el BiS|r")

        for rank = 1, 6 do
            local topLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            topLabel:SetPoint("LEFT", f, "TOPLEFT", 265 + (rank-1) * 44, -68)
            topLabel:SetWidth(36)
            topLabel:SetJustifyH("CENTER")
            topLabel:SetTextColor(0.7, 0.7, 0.7)
            topLabel:SetText("Top " .. rank)
        end
        
        local tHeader = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        tHeader:SetPoint("LEFT", f, "TOPLEFT", 540, -68)
        tHeader:SetText("|cff00ff00OBJETIVO|r")
        
        self.rows = {}
    end

    self.titleString:SetText("BiS / Tops - " .. (bisClassName or "") .. " " .. (spec or ""))

    -- 2. RENDERIZADO DE FILAS
    for i, info in ipairs(SLOT_INFO) do
        local row = self:GetOrCreateRow(i)
        row:SetPoint("TOPLEFT", 0, -((i-1) * 44)) -- Más separación entre filas
        row.slotLabel:SetText(info.name)
        
        local slotData = manualDataMap[info.key]
        local items = slotData and slotData.items
        local enhData = slotData and slotData.enhs

        -- [GA_LOGIC_SYNC] Lógica exacta de Bistooltip con posiciones fijas
        -- eIdx 1 = Encantamiento (Izquierda).
        local enchEnh = enhData and enhData[1]
        local enchBtn = row.setupBtns[1]
        local enchIcon = row.setupIcons[1]
        if enchEnh and enchEnh.type ~= "none" then
            local id = enchEnh.id
            local tex = (enchEnh.type == "item") and GetItemIcon(id) or select(3, GetSpellInfo(id))
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
                    local tex = (enh.type == "item") and GetItemIcon(id) or select(3, GetSpellInfo(id))
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
            local btn = row.buttons[rank]
            local icon = row.icons[rank]
            
            if itemID and itemID > 0 then
                local itemName, itemLink = GetItemInfo(itemID)
                icon:SetTexture(GetItemIcon(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
                btn.itemID = itemID
                btn.itemLink = itemLink
                btn.slotKey = info.key
                btn.rank = rank
                btn:Show()
                
                local isEquipped = false
                for slot = 1, 18 do
                    if GetInventoryItemID("player", slot) == itemID then
                        isEquipped = true
                        break
                    end
                end
                if isEquipped then row.checks[rank]:Show() else row.checks[rank]:Hide() end
            else
                btn:Hide()
                row.checks[rank]:Hide()
            end
        end

        -- Lógica del Objetivo (Target)
        local profile = GearAnalyzer.db.profile
        local customID = profile.custom_bis and profile.custom_bis[info.key]
        if type(customID) == "table" then customID = customID.itemID end
        
        local targetID = customID
        if not targetID and items then
            if (info.key == "ring2" or info.key == "trinket2") and items[2] then
                targetID = items[2]
            elseif items[1] then
                targetID = items[1]
            end
        end

        if targetID then
            local tBtn = row.targetBtn
            local itemName, tLink, _, _, _, _, _, _, _, tTexture = GetItemInfo(targetID)
            tBtn.icon:SetTexture(tTexture or GetItemIcon(targetID))
            tBtn.itemID = targetID
            tBtn.itemLink = tLink
            tBtn:Show()
            
            row.tName:SetText(tLink or itemName or "...")
            row.tName:Show()

            local isEquipped = false
            for slot = 1, 18 do
                if GetInventoryItemID("player", slot) == targetID then isEquipped = true break end
            end
            if isEquipped then tBtn.check:Show() else tBtn.check:Hide() end
        else
            row.targetBtn:Hide()
            row.tName:Hide()
        end
        row:Show()
    end
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] then return self.rows[i] end
    
    local row = CreateFrame("Frame", nil, self.scrollContent)
    row:SetSize(700, 42) -- Fila más alta para iconos grandes
    
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.03)

    -- Nombre del hueco (Al principio a la izquierda)
    local slotLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    slotLabel:SetPoint("LEFT", 5, 0)
    slotLabel:SetWidth(85)
    slotLabel:SetJustifyH("LEFT")
    row.slotLabel = slotLabel

    -- Icono de Encantamiento (Setup 1: Derecha del texto)
    row.setupBtns = {}
    row.setupIcons = {}
    
    local enchBtn = CreateFrame("Button", nil, row)
    enchBtn:SetSize(36, 36)
    enchBtn:SetPoint("LEFT", 95, 0)
    local enchIcon = enchBtn:CreateTexture(nil, "ARTWORK")
    enchIcon:SetAllPoints()
    row.setupBtns[1] = enchBtn
    row.setupIcons[1] = enchIcon

    enchBtn:SetScript("OnEnter", function(s)
        if s.id then
            GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
            if s.isSpell then GameTooltip:SetHyperlink("spell:" .. s.id)
            else GameTooltip:SetHyperlink("item:" .. s.id) end
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

    -- Iconos de Gemas (Setup 2, 3, 4: Derecha del encantamiento, pegadas)
    for eIdx = 2, 4 do
        local btn = CreateFrame("Button", nil, row)
        btn:SetSize(36, 36)
        btn:SetPoint("LEFT", 135 + (eIdx-2) * 36, 0) -- 36px significa 0 separación (pegadas)
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
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
    
    row.buttons = {}
    row.icons = {}
    row.checks = {}
    for rank = 1, 6 do
        local btn = CreateFrame("Button", nil, row)
        btn:SetSize(36, 36)
        btn:SetPoint("LEFT", 260 + (rank-1) * 44, 0) -- Mayor separación entre items (44px)
        btn:RegisterForClicks("AnyUp")
        
        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints()
        row.buttons[rank] = btn
        row.icons[rank] = icon
        
        local check = btn:CreateTexture(nil, "OVERLAY")
        check:SetSize(28, 28)
        check:SetPoint("CENTER")
        check:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
        check:Hide()
        row.checks[rank] = check
        
        btn:SetScript("OnEnter", function(s)
            if s.itemID then
                GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink("item:" .. s.itemID)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cffffff00Top " .. s.rank .. " para este hueco|r")
                GameTooltip:Show()
            end
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        btn:SetScript("OnClick", function(self)
            if IsAltKeyDown() and self.itemID then
                local profile = GearAnalyzer.db.profile
                profile.custom_bis = profile.custom_bis or {}
                profile.custom_bis[self.slotKey] = { itemID = self.itemID }
                profile.bis = profile.bis or {}
                profile.bis[self.slotKey] = { itemID = self.itemID }
                print("|cff00ff00GearAnalyzer:|r Objetivo GUARDADO para " .. self.slotKey .. ": " .. (self.itemLink or self.itemID))
                GearAnalyzer:AnalyzeEquipment()
                Tab:Update()
            elseif self.itemLink or self.itemID then
                HandleModifiedItemClick(self.itemLink or select(2, GetItemInfo(self.itemID)))
            end
        end)
    end
    
    -- Boton de Objetivo Manual
    local tBtn = CreateFrame("Button", nil, row)
    tBtn:SetSize(36, 36)
    tBtn:SetPoint("LEFT", 535, 0)
    tBtn:RegisterForClicks("AnyUp")
    local tIcon = tBtn:CreateTexture(nil, "ARTWORK")
    tIcon:SetAllPoints()
    tBtn.icon = tIcon
    
    local tCheck = tBtn:CreateTexture(nil, "OVERLAY")
    tCheck:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
    tCheck:SetSize(28, 28)
    tCheck:SetPoint("CENTER")
    tCheck:Hide()
    tBtn.check = tCheck
    
    local tName = row:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    tName:SetPoint("LEFT", tBtn, "RIGHT", 10, 0)
    tName:SetWidth(400)
    tName:SetJustifyH("LEFT")
    tName:SetWordWrap(false)
    row.tName = tName
    
    tBtn:SetScript("OnEnter", function(self)
        if self.itemID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. self.itemID)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff00ff00OBJETIVO ACTUAL|r")
            GameTooltip:AddLine("|cffaaaaaa(Elegido mediante Alt+Click)|r")
            GameTooltip:Show()
        end
    end)
    tBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    tBtn:SetScript("OnClick", function(self)
        if self.itemLink or self.itemID then
            HandleModifiedItemClick(self.itemLink or select(2, GetItemInfo(self.itemID)))
        end
    end)
    row.targetBtn = tBtn

    
    self.rows[i] = row
    return row
end

function Tab:OnEnable() end
