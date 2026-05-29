-- =========================
-- GearAnalyzer Tab: Equipo
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabEquipo")

function Tab:Update(page, ignoreForced)
    GearAnalyzer:ScanEquipment()
    GearAnalyzer:AnalyzeEquipment(ignoreForced)
    
    if not page then return end

    local scroll = _G["GABainScroll_v2"]
    local content = scroll and scroll:GetScrollChild()
    if not scroll or not content then return end
    content:Show()
    scroll:Show()

    self.rows = self.rows or {}
    for _, r in ipairs(self.rows) do r:Hide() end
    wipe(self.rows)

    local data = GearAnalyzer.scannedEquipment
    content:Show()
    if not data or #data == 0 then 
        if not self.noDataText then
            self.noDataText = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.noDataText:SetPoint("CENTER", content, "CENTER", 0, -50)
            self.noDataText:SetText("No se detectó equipo. Intenta mover un objeto o re-equipar algo.")
        end
        self.noDataText:Show()
        return 
    elseif self.noDataText then
        self.noDataText:Hide()
    end

    if not self.titleString then
        self.titleString = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        self.titleString:SetPoint("TOPLEFT", 10, -10)
        GearAnalyzer:ApplyStyle(self.titleString, true)
    end

    local classLoc = GearAnalyzer:GetLocalizedClassName(ignoreForced)
    local curSpec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local specLabel = GearAnalyzer:GetSpecLabel(curSpec)
    self.titleString:SetText("Equipo - " .. classLoc .. " " .. specLabel)

    local scroll = _G["GABainScroll_v2"]
    if scroll then
        scroll:ClearAllPoints()
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -9, 10)
    end

    local y = -5

    -- 1. CABECERA
    local header = self:GetOrCreateRow(0, content)
    local w = 700
    header:SetPoint("TOPLEFT", 10, y)
    header:SetSize(w, 24)
    header.bg:Hide()
    header.icon:Hide()
    header.border:Hide()
    header.data = nil
    
    if not header.hRecomendado then
        header.hRecomendado = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        header.hRecomendado:SetPoint("CENTER", header, "RIGHT", -210, 0)
        header.hRecomendado:SetText(GearAnalyzer:LocalizeText("RECOMENDADO") or "RECOMENDADO")
        header.hRecomendado:SetTextColor(0, 1, 1) -- Cyan

        header.hMejora = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        header.hMejora:SetPoint("CENTER", header, "RIGHT", -110, 0)
        header.hMejora:SetText(L["NEXT_UPGRADE"])
        header.hMejora:SetTextColor(1, 0.82, 0)

        header.hStatus = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        header.hStatus:SetPoint("CENTER", header, "RIGHT", -35, 0)
        header.hStatus:SetText(L["STATUS"])
        header.hStatus:SetTextColor(1, 0.82, 0)
    end
    
    header.hRecomendado:Show()
    header.hMejora:Show()
    header.hStatus:Show()
    
    if header.bBtn then header.bBtn:Hide() end
    header:Show()
    if header.bBtn then header.bBtn:Hide() end
    header:Show()
    
    table.insert(self.rows, header)
    y = y - 35

    -- 2. FILAS DE OBJETOS
    local class = GearAnalyzer:GetClassToken(ignoreForced)
    local curSpec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local normSpec = GearAnalyzer:NormalizeSpecName(curSpec)
    local classData = GearAnalyzer.ClassData[class]
    local specEnchants = classData and classData.Enchants and classData.Enchants[normSpec]

    for i, itemData in ipairs(data) do
        local d = itemData
        local slotKey = GearAnalyzer:GetSlotKey(d.slotName, d.slotID)
        
        -- Ocultar Mano Secundaria si el master dice 0 y está vacía
        local shouldSkip = (slotKey == "offhand" and specEnchants and specEnchants.offhand == 0 and not d.itemLink)
        
        if not shouldSkip then
            local row = self:GetOrCreateRow(i, content)
            row.data = d
            local w = content:GetWidth() or 700
            row:SetPoint("TOPLEFT", 0, y)
            row:SetSize(w, 42)
            row:Show()

            if d.itemLink then
            -- MODO EQUIPADO
            local _, _, quality = GetItemInfo(d.itemLink)
            local r, g, b = GetItemQualityColor(quality or 1)

            row.bg:Show()
            row.icon:Show()
            row.icon:SetTexture(GetItemIcon(d.itemLink))
            row.border:Hide() -- Eliminado borde marcado por petición
            
            if d.isBIS then
                row.bg:SetTexture(0, 1, 0, 0.15)
                row.border:SetVertexColor(0, 1, 0, 1)
            else
                row.bg:SetTexture(1, 1, 1, 0.03)
                row.border:SetVertexColor(r, g, b, 0.8)
            end

            local rankTag = ""
            if d.rank then
                local isGoldRank = d.isBIS
                local rankColor = isGoldRank and "|cffffd100" or "|cff00ccff"
                rankTag = rankColor .. "[Top " .. d.rank .. "]|r "
            end
            
            local localizedSlot = L[d.slotName] or d.slotName
            row.nameText:SetText("|cffaaaaaa" .. localizedSlot .. ":|r " .. rankTag .. d.itemLink)
            GearAnalyzer:ApplyStyle(row.nameText)
            
            local ilvlText = "|cffffffffilvl " .. (d.iLevel or "??") .. "|r"
            row.infoText:SetText(ilvlText .. "  |  ")
            GearAnalyzer:ApplyStyle(row.infoText)
            
            -- Gemas
            local showGems = (d.gemStatus ~= nil)
            if showGems then
                local gCol = (d.gemStatus == 2) and "|cff00ff00" or (d.gemStatus == 1 and "|cffffff00" or "|cffff0000")
                row.gemText:SetText(gCol .. "[G]|r")
                row.gemText:Show()
                row.gemBtn:Show()
            else
                row.gemText:Hide()
                row.gemBtn:Hide()
            end
            
            -- Encantos
            local showEnch = (d.enchStatus ~= nil)
            if showEnch then
                local eCol = "|cffff0000"
                if d.enchStatus == 2 then eCol = "|cff00ff00"
                elseif d.enchStatus == 3 then eCol = "|cffffa500"
                elseif d.enchStatus == 1 then eCol = "|cffffff00"
                end
                row.enchText:SetText(eCol .. "[E]|r")
                row.enchText:Show()
                row.enchBtn:Show()
            else
                row.enchText:Hide()
                row.enchBtn:Hide()
            end

            -- Estado
            local estadoTexto = "|cffaaaaaa" .. L["NO_DATA"] .. "|r"
            if d.isBIS then 
                estadoTexto = "|cff00ff00" .. L["STATUS_BIS"] .. "|r"
            elseif d.isAlternative then 
                estadoTexto = "|cff00ccff" .. L["STATUS_ALMOST_BIS"] .. "|r"
            elseif d.isIncorrect then 
                estadoTexto = "|cffff0000" .. L["STATUS_INCORRECT"] .. "|r"
            elseif d.isTier10Normal then 
                estadoTexto = "|cffffff00" .. L["STATUS_UPGRADABLE"] .. "|r"
            elseif d.isLowLevel then 
                estadoTexto = "|cffffa500" .. L["STATUS_LOW_LVL"] .. "|r"
            elseif d.isCorrect then 
                estadoTexto = "|cffffff00" .. L["STATUS_UPGRADABLE"] .. "|r" 
            end
            row.status:SetText(estadoTexto)
            GearAnalyzer:ApplyStyle(row.status)

            -- Botón Equipar
            if d.betterInBags or d.betterInBank then
                row.bBtn:SetText(d.betterInBags and L["EQUIP"] or L["BANK"])
                if d.betterInBags then 
                    row.bBtn:Enable() 
                else 
                    row.bBtn:Disable() 
                end
                row.bBtn:Show()
                -- Icono de la mejora recomendada
                local _, _, _, _, _, _, _, _, _, betterTexture = GetItemInfo(d.betterItemLink)
                row.betterIcon:SetTexture(betterTexture or GetItemIcon(d.betterItemLink))
                row.betterIcon:Show()
                row.betterIconBtn:Show()
                if row.divider then row.divider:Show() end
            else
                row.bBtn:Hide()
                row.betterIcon:Hide()
                row.betterIconBtn:Hide()
                if row.divider then row.divider:Hide() end
            end
        else
            -- MODO VACÍO
            row.bg:SetTexture(1, 1, 1, 0.03)
            row.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            row.icon:Show()
            row.border:SetVertexColor(1, 1, 1, 0.5)
            row.border:Show()
            
            local localizedSlot = L[d.slotName] or d.slotName
            row.nameText:SetText("|cffaaaaaa" .. localizedSlot .. ":|r |cff888888(" .. L["EMPTY"] .. ")|r")
            row.infoText:SetText("")
            row.gemText:SetText("")
            row.enchText:SetText("")
            row.status:SetText("|cff888888" .. L["EMPTY"] .. "|r")
            row.bBtn:Hide()
        end

        -- SIGUIENTE MEJOR (Para ambos modos)
        if d.nextUpgradeID then
            local _, itemLink, _, _, _, _, _, _, _, texture = GetItemInfo(d.nextUpgradeID)
            row.nextUpgradeLink = itemLink
            row.nextIcon:SetTexture(texture or GetItemIcon(d.nextUpgradeID))
            row.nextIcon:Show()
            row.nextBtn:Show()
        else
            row.nextIcon:Hide()
            row.nextBtn:Hide()
        end

        table.insert(self.rows, row)

        -- AJUSTAR TAMAÑO DINÁMICO
        local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
        row:SetHeight(iconSize + 16)
        row.icon:SetSize(iconSize, iconSize)
        row.iconBtn:SetSize(iconSize, iconSize)
        row.nextIcon:SetSize(iconSize * 0.85, iconSize * 0.85)
        row.nextBtn:SetSize(iconSize * 0.85, iconSize * 0.85)
        row.betterIcon:SetSize(iconSize * 0.85, iconSize * 0.85)
        row.betterIconBtn:SetSize(iconSize * 0.85, iconSize * 0.85)
        
        y = y - (iconSize + 20)
        else
            if self.allRows and self.allRows[i] then self.allRows[i]:Hide() end
        end
    end

    -- 3. LEYENDA
    local legend = self:GetOrCreateLegend(content)
    legend:SetPoint("TOPLEFT", 10, y - 10)
    legend:Show()
    table.insert(self.rows, legend)
    y = y - 80

    content:SetHeight(math.abs(y) + 50)
    if scroll then scroll:UpdateScrollChildRect() end
end

function Tab:GetOrCreateRow(i, parent)
    self.allRows = self.allRows or {}
    if self.allRows[i] then return self.allRows[i] end

    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(parent:GetWidth() - 25, 42)
    
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.03)
    row.bg = bg

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(38, 38)
    icon:SetPoint("LEFT", 5, 0)
    row.icon = icon

    local border = row:CreateTexture(nil, "OVERLAY")
    border:SetSize(52, 52)
    border:SetPoint("CENTER", icon, "CENTER")
    border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    border:SetBlendMode("ADD")
    row.border = border

    local highlight = row:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetTexture(1, 1, 1, 0.05)
    highlight:SetBlendMode("ADD")
    row.highlight = highlight

    local iconBtn = CreateFrame("Button", nil, row)
    iconBtn:SetSize(38, 38)
    iconBtn:SetPoint("CENTER", icon, "CENTER")
    iconBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    iconBtn:SetScript("OnEnter", function(self)
        local r = self:GetParent()
        local d = r.data
        if not d or not d.itemLink then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(d.itemLink)
        if d.setInfo then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(d.setInfo)
        end
        GameTooltip:Show()
    end)
    row.iconBtn = iconBtn

    local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    nameText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 12, 2)
    nameText:SetPoint("RIGHT", row, "RIGHT", -270, 6)
    nameText:SetJustifyH("LEFT")
    row.nameText = nameText

    local infoText = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    infoText:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 12, 4)
    row.infoText = infoText

    local gemBtn = CreateFrame("Button", nil, row)
    gemBtn:SetSize(25, 20)
    gemBtn:SetPoint("LEFT", infoText, "RIGHT", 5, 0)
    local gemText = gemBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    gemText:SetAllPoints()
    gemBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    gemBtn:SetScript("OnEnter", function(self)
        local r = self:GetParent()
        local d = r.data
        if not d then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["GEM_ANALYSIS_TITLE"])
        if d.socketBonusText then
            local worth = GearAnalyzer:ShouldFollowSocket(GearAnalyzer:GetClassToken(), GearAnalyzer:GetCurrentSpecEnhanced(), d.socketSlotsAvailable, d.bonusStat, d.bonusVal)
            local worthCol = worth and ("|cff00ff00(" .. L["WORTH_IT"] .. ")|r") or ("|cffff0000(" .. L["IGNORE"] .. ")|r")
            GameTooltip:AddLine(L["BONUS"] .. ": " .. d.socketBonusText .. " " .. worthCol)
            GameTooltip:AddLine(" ")
        end
        if d.socketAnalysis and #d.socketAnalysis > 0 then
            for _, s in ipairs(d.socketAnalysis) do
                local sColor = "|cffaaaaaa"
                if s.color == "red" then sColor = "|cffff3333"
                elseif s.color == "yellow" then sColor = "|cffffff33"
                elseif s.color == "blue" then sColor = "|cff3333ff"
                elseif s.color == "meta" then sColor = "|cff00ffff"
                end
                local statusIcon = s.isMatch and "|cff00ff00[OK]|r" or "|cffff0000[X]|r"
                if s.isEmpty then statusIcon = "|cffffa500[V]|r" end
                GameTooltip:AddDoubleLine(sColor..s.color:upper().."|r: "..s.currentName, statusIcon, 1,1,1)
                if not s.isMatch then
                    GameTooltip:AddLine("   " .. L["SUGGESTED"] .. ": |cff00ff00"..s.recommendedName.."|r")
                end
            end
        else
            GameTooltip:AddLine(d.gemTooltip or L["NO_DATA"], 1, 1, 1)
        end
        if d.slotName == "SLOT_CHEST" or d.slotName:find("Pecho") or d.slotName:find("Chest") then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff3fc7eb" .. L["NOTE"] .. ":|r |cffff00ff" .. L["NIGHTMARE_TEAR_RECOMMENDATION"] .. "|r", 1, 1, 1, true)
        end
        GameTooltip:Show()
    end)
    row.gemBtn = gemBtn
    row.gemText = gemText

    local enchBtn = CreateFrame("Button", nil, row)
    enchBtn:SetSize(25, 20)
    enchBtn:SetPoint("LEFT", gemBtn, "RIGHT", 2, 0)
    local enchText = enchBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    enchText:SetAllPoints()
    enchBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    enchBtn:SetScript("OnEnter", function(self)
        local r = self:GetParent()
        local d = r.data
        if not d then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["ENCHANT_STATUS_TITLE"])
        GameTooltip:AddLine(d.enchTooltip or L["NO_DATA"], 1, 1, 1)
        GameTooltip:Show()
    end)
    row.enchBtn = enchBtn
    row.enchText = enchText

    local nextIcon = row:CreateTexture(nil, "ARTWORK")
    nextIcon:SetSize(32, 32)
    nextIcon:SetPoint("RIGHT", row, "RIGHT", -95, 0)
    local nextBtn = CreateFrame("Button", nil, row)
    nextBtn:SetSize(32, 32)
    nextBtn:SetPoint("CENTER", nextIcon, "CENTER")
    nextBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    nextBtn:SetScript("OnEnter", function(self)
        local r = self:GetParent()
        local d = r.data
        if not d then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(r.nextUpgradeLink or ("item:"..d.nextUpgradeID))
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("|cffffd100" .. L["NEXT_BIG_UPGRADE"] .. "|r")
        GameTooltip:Show()
    end)
    row.nextIcon = nextIcon
    row.nextBtn = nextBtn

    local status = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    status:SetPoint("RIGHT", row, "RIGHT", -15, 0)
    row.status = status

    local bBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    bBtn:SetSize(75, 22)
    bBtn:SetPoint("RIGHT", row, "RIGHT", -185, 0)
    bBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    bBtn:SetScript("OnEnter", function(self)
        local r = self:GetParent()
        local d = r.data
        if not d then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(d.betterItemLink)
        local locationText = d.betterInBags and ("|cff00ff00" .. L["IN_BAGS"] .. "|r") or ("|cffff0000" .. L["IN_BANK"] .. "|r")
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["LOCATION"] .. ": " .. locationText)
        if d.betterInBank then
            GameTooltip:AddLine("|cffff0000" .. L["BANK_WARNING"] .. "|r", 1, 0, 0, true)
        else
            GameTooltip:AddLine("|cff00ff00" .. L["EQUIP_INSTRUCTIONS"] .. "|r")
        end
        GameTooltip:Show()
    end)
    bBtn:SetScript("OnClick", function(self)
        local r = self:GetParent()
        local d = r.data
        if not d then return end
        if d.betterInBags and d.betterItemBag and d.betterItemSlot then
            local invSlot = d.slotID
            if invSlot then
                ClearCursor()
                PickupContainerItem(d.betterItemBag, d.betterItemSlot)
                EquipCursorItem(invSlot)
                ClearCursor()
                print("|cff00ff00GearAnalyzer:|r " .. string.format(L["EQUIPPING_MSG"], d.betterItemLink, (L[d.slotName] or d.slotName)))
            else
                UseContainerItem(d.betterItemBag, d.betterItemSlot)
                print("|cff00ff00GearAnalyzer:|r " .. string.format(L["EQUIPPING_SIMPLE_MSG"], d.betterItemLink))
            end
            GearAnalyzer:After(0.4, function() GearAnalyzer:FullReload() end)
        end
    end)
    row.bBtn = bBtn

    local betterIcon = row:CreateTexture(nil, "ARTWORK")
    betterIcon:SetSize(32, 32)
    betterIcon:SetPoint("RIGHT", bBtn, "LEFT", -5, 0)
    row.betterIcon = betterIcon

    local betterIconBtn = CreateFrame("Button", nil, row)
    betterIconBtn:SetSize(32, 32)
    betterIconBtn:SetPoint("CENTER", betterIcon, "CENTER")
    betterIconBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    betterIconBtn:SetScript("OnEnter", function(self)
        local r = self:GetParent()
        local d = r.data
        if not d then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(d.betterItemLink)
        local locationText = d.betterInBags and ("|cff00ff00" .. L["IN_BAGS"] .. "|r") or ("|cffff0000" .. L["IN_BANK"] .. "|r")
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L["LOCATION"] .. ": " .. locationText)
        if d.betterInBank then
            GameTooltip:AddLine("|cffff0000" .. L["BANK_WARNING"] .. "|r", 1, 0, 0, true)
        else
            GameTooltip:AddLine("|cff00ff00" .. L["EQUIP_INSTRUCTIONS"] .. "|r")
        end
        GameTooltip:Show()
    end)
    row.betterIconBtn = betterIconBtn

    local divider = row:CreateTexture(nil, "OVERLAY")
    divider:SetSize(1.5, 26)
    divider:SetPoint("RIGHT", nextIcon, "LEFT", -31, 0)
    divider:SetTexture(1, 1, 1, 0.1)
    row.divider = divider

    self.allRows[i] = row
    return row
end

function Tab:GetOrCreateLegend(parent)
    if self.legend then return self.legend end
    local legend = CreateFrame("Frame", nil, parent)
    legend:SetSize(parent:GetWidth() - 20, 60)
    local legTitle = legend:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    legTitle:SetPoint("TOPLEFT", 5, 0)
    legTitle:SetText(L["ANALYSIS_LEGEND"] .. ":")
    local legText = legend:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    legText:SetPoint("TOPLEFT", 5, -15)
    legText:SetJustifyH("LEFT")
    legText:SetText(L["LEGEND_TEXT"])
    self.legend = legend
    return legend
end
