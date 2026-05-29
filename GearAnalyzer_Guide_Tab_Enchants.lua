-- ===================================================
-- GearAnalyzer Guide Tab: Encantamientos (Ventana Guía)
-- Módulo independiente - siempre usa ignoreForced=false
-- ===================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabEncantamientosGuide")

function Tab:Update(page, ignoreForced)
    if not page then return end

    local class      = GearAnalyzer:GetClassToken(false)
    local activeSpec = GearAnalyzer:GetCurrentSpecEnhanced(false)
    local normSpec   = GearAnalyzer:NormalizeSpecName(activeSpec)
    local classLoc   = GearAnalyzer:GetLocalizedClassName(false)
    local specLabel  = GearAnalyzer:GetSpecLabel(normSpec)

    if not self.scroll then
        local title = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -10)
        GearAnalyzer:ApplyStyle(title, true)
        self.titleString = title

        local scroll = CreateFrame("ScrollFrame", "GAEnchantsScrollGuide", page, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -9, 10)
        self.scroll = scroll

        local content = CreateFrame("Frame", nil, scroll)
        local w = page:GetWidth()
        if not w or w <= 0 then w = 760 end
        content:SetSize(w - 30, 600)
        scroll:SetScrollChild(content)
        self.content = content

        self.rows = {}
    end

    self.titleString:SetText(L["ENCHANT_GUIDE"] .. " - " .. classLoc .. " " .. specLabel)
    GearAnalyzer:SetupGuideIcons(page, class, normSpec)
    for _, r in ipairs(self.rows) do r:Hide() end

    local classData    = GearAnalyzer.ClassData[class:upper()]
    local specEnchants = classData and classData.Enchants and classData.Enchants[normSpec]
    local isDev        = GearAnalyzer.db.profile.settings.devMode

    if not specEnchants then
        if not self.errorMsg then
            self.errorMsg = self.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.errorMsg:SetPoint("CENTER", 0, 0)
        end
        self.errorMsg:SetText("|cffffb300" .. L["NO_ENCHANT_GUIDE_FOUND"] .. "|r\n|cffffffff" .. class .. "_" .. (normSpec or "?") .. "|r")
        self.errorMsg:Show()
        return
    elseif self.errorMsg then
        self.errorMsg:Hide()
    end

    local SLOT_LIST = {
        { id = "head",      name = L["SLOT_HEAD"] },
        { id = "shoulders", name = L["SLOT_SHOULDERS"] },
        { id = "back",      name = L["SLOT_BACK"] },
        { id = "chest",     name = L["SLOT_CHEST"] },
        { id = "wrists",    name = L["SLOT_WRISTS"] },
        { id = "hands",     name = L["SLOT_HANDS"] },
        { id = "legs",      name = L["SLOT_LEGS"] },
        { id = "feet",      name = L["SLOT_FEET"] },
        { id = "waist",     name = L["SLOT_WAIST"] },
        { id = "weapon",    name = L["SLOT_WEAPON"] },
        { id = "offhand",   name = L["SLOT_OFFHAND"] },
        { id = "ranged",    name = L["SLOT_RANGED"] },
    }

    local EnchantMapping = GearAnalyzer.EnchantMapping
    local y = -5
    local i = 1

    for _, slotInfo in ipairs(SLOT_LIST) do
        local rawEnchantID = specEnchants[slotInfo.id]
        
        -- Verificar si es 0 (no aplica)
        local isZero = (tonumber(rawEnchantID) == 0) or (type(rawEnchantID) == "table" and tonumber(rawEnchantID[1]) == 0)

        if not rawEnchantID or isZero then
            -- skip slots with no data or enchant 0
        else
            local enchantIDs = {}
            if type(rawEnchantID) == "table" then
                enchantIDs = rawEnchantID
            else
                enchantIDs = { rawEnchantID }
            end

            for _, enchantID in ipairs(enchantIDs) do
                local row = self:GetOrCreateRow(i)
                row:ClearAllPoints()
                row:SetPoint("TOPLEFT", self.content, "TOPLEFT", 5, y)
                row:Show()

                local data = GearAnalyzer:GetEnchantData(enchantID)
                local displayName = data and GearAnalyzer:LocalizeText(data.name) or ("|cffaaaaaa[ID:" .. enchantID .. "]|r")
                local statsText = data and GearAnalyzer:LocalizeText(data.stats or "") or ""
                local originText = (data and data.origin and data.origin ~= "") and (" |cffaaaaaa[" .. GearAnalyzer:LocalizeText(data.origin) .. "]|r") or ""

                row.enchantID = data and (data.spell or data.item or data.serverID) or enchantID
                row.enchantName = displayName

                row.slotText:SetText("|cffffd100" .. slotInfo.name .. ":|r " .. displayName .. (statsText ~= "" and " |cff00ff00(" .. statsText .. ")|r" or "") .. originText)
                
                if isDev then
                    row.srcText:SetText("|cffaaaaaaID (Guía):|r " .. enchantID)
                    row.srcText:Show()
                else
                    row.srcText:Hide()
                end
                
                -- Icono
                local iconTex = nil
                if data then
                    if data.item then iconTex = GetItemIcon(data.item) end
                    if not iconTex and data.spell then iconTex = select(3, GetSpellInfo(data.spell)) end
                    if not iconTex then iconTex = GetItemIcon(data.serverID or enchantID) or select(3, GetSpellInfo(data.serverID or enchantID)) end
                end
                row.icon:SetTexture(iconTex or "Interface\\Icons\\INV_Misc_QuestionMark")

                GearAnalyzer:ApplyStyle(row.slotText)
                GearAnalyzer:ApplyStyle(row.srcText)

                y = y - 40
                i = i + 1
            end
        end
    end

    self.content:SetHeight(math.max(200, math.abs(y) + 20))
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] then return self.rows[i] end

    local row = CreateFrame("Frame", nil, self.content)
    row:SetSize(self.content:GetWidth() - 10, 36)
    row:EnableMouse(true)

    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.03)

    local icon = row:CreateTexture(nil, "OVERLAY")
    icon:SetSize(30, 30)
    icon:SetPoint("LEFT", 5, 0)
    row.icon = icon

    local slotText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    slotText:SetPoint("LEFT", icon, "RIGHT", 10, 6)
    slotText:SetJustifyH("LEFT")
    slotText:SetWidth(600)
    row.slotText = slotText

    local srcText = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    srcText:SetPoint("LEFT", icon, "RIGHT", 10, -9)
    srcText:SetJustifyH("LEFT")
    srcText:SetWidth(600)
    row.srcText = srcText

    -- Tooltip logic
    row:SetScript("OnEnter", function(self)
        if self.enchantID and self.enchantID > 0 then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if GetSpellInfo(self.enchantID) then
                GameTooltip:SetHyperlink("spell:" .. self.enchantID)
            elseif GetItemInfo(self.enchantID) then
                GameTooltip:SetHyperlink("item:" .. self.enchantID)
            else
                GameTooltip:SetText(self.enchantName or "Encantamiento", 1, 1, 1)
            end
            GameTooltip:Show()
        end
    end)
    row:SetScript("OnLeave", function() GameTooltip:Hide() end)
    
    -- Shift+Click para linkear
    row:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and IsShiftKeyDown() then
            local link = nil
            if self.enchantID and self.enchantID > 0 then
                if GetSpellInfo(self.enchantID) then
                    link = GetSpellLink(self.enchantID)
                else
                    local _, itemLink = GetItemInfo(self.enchantID)
                    link = itemLink
                end
            end
            if link then
                local activeChat = ChatEdit_GetActiveWindow()
                if activeChat then activeChat:Insert(link) else ChatFrame_OpenChat(link) end
            end
        end
    end)

    self.rows[i] = row
    return row
end
