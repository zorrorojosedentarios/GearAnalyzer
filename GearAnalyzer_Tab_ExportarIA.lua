-- =========================
-- GearAnalyzer Tab: Exportar IA
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabExportarIA")

function Tab:Update(page, ignoreForced)
    self.ignoreForced = ignoreForced

    if not page then return end

    if not self.container then
        local f = CreateFrame("Frame", nil, page)
        f:SetAllPoints()
        self.container = f
        
        local Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        Title:SetPoint("TOP", 0, -10)
        Title:SetText(L["EXPORT_AI_TITLE"])
        GearAnalyzer:ApplyStyle(Title, true)

        local desc = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        desc:SetPoint("TOP", 0, -40)
        desc:SetWidth(page:GetWidth() - 40)
        desc:SetText(L["EXPORT_AI_DESC"])
        desc:SetJustifyH("CENTER")

        local scrollFrame = CreateFrame("ScrollFrame", "GAExportScroll", f, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 20, -90)
        scrollFrame:SetPoint("BOTTOMRIGHT", -40, 40)

        local editBox = CreateFrame("EditBox", nil, scrollFrame)
        editBox:SetMultiLine(true)
        editBox:SetFontObject("ChatFontNormal")
        editBox:SetWidth(page:GetWidth() - 60)
        editBox:SetAutoFocus(false)
        editBox:SetMaxLetters(0)
        editBox:SetTextInsets(5, 5, 5, 5)
        editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        
        f:SetScript("OnHide", function()
            if self.editBox then self.editBox:ClearFocus() end
        end)

        scrollFrame:SetScrollChild(editBox)

        local bg = CreateFrame("Frame", nil, f)
        bg:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", -5, 5)
        bg:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 25, -5)
        bg:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        bg:SetBackdropColor(0, 0, 0, 0.5)
        bg:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

        local generateBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        generateBtn:SetSize(120, 25)
        generateBtn:SetPoint("BOTTOMLEFT", 30, 5)
        generateBtn:SetText(L["GENERATE"] or "Generar")
        generateBtn:SetScript("OnClick", function()
            GearAnalyzer:ScanEquipment()
            GearAnalyzer:AnalyzeEquipment(self.ignoreForced)
            local text = self:GenerateExportText(self.ignoreForced)
            editBox:SetText(text)
            editBox:SetFocus()
            editBox:HighlightText()
        end)

        local copyBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        copyBtn:SetSize(120, 25)
        copyBtn:SetPoint("BOTTOM", 0, 5)
        copyBtn:SetText(L["SELECT_ALL"])
        copyBtn:SetScript("OnClick", function()
            if editBox:GetText() ~= "" then
                editBox:SetFocus()
                editBox:HighlightText()
            end
        end)

        self.editBox = editBox
        self.generateBtn = generateBtn
    end
    
    self.editBox:SetWidth(self.container:GetWidth() - 60)
end

function Tab:GenerateExportText(ignoreForced)
    local iF = ignoreForced
    local t = {}
    local nt = function(s) t[#t+1] = s end
    
    nt(L["AI_INTRO_PROMPT"] .. "\n\n")
    nt("=== " .. L["PROFILE_LABEL"] .. ": " .. UnitName("player") .. " (" .. (GearAnalyzer:GetLocalizedClassName(iF) or "UNKNOWN") .. ") ===\n")
    nt(L["SPEC_LABEL"] .. ": " .. GearAnalyzer:LocalizeText(GearAnalyzer:GetCurrentSpecEnhanced(iF) or "Ninguna") .. "\n\n")

    -- 1. TALENTOS
    local n1, _, p1 = GetTalentTabInfo(1)
    local n2, _, p2 = GetTalentTabInfo(2)
    local n3, _, p3 = GetTalentTabInfo(3)
    nt("[" .. L["TALENT_DISTRIBUTION"] .. "]\n")
    nt("├─ " .. (GearAnalyzer:LocalizeText(n1) or (L["BRANCH"] .. " 1")) .. ": " .. (p1 or 0) .. "\n")
    nt("├─ " .. (GearAnalyzer:LocalizeText(n2) or (L["BRANCH"] .. " 2")) .. ": " .. (p2 or 0) .. "\n")
    nt("└─ " .. (GearAnalyzer:LocalizeText(n3) or (L["BRANCH"] .. " 3")) .. ": " .. (p3 or 0) .. "\n\n")

    -- 2. GLIFOS ACTIVOS
    nt("[" .. L["ACTIVE_GLYPHS"] .. "]\n")
    local hasGlyphs = false
    for i = 1, 6 do
        local enabled, glyphType, glyphSpellID = GetGlyphSocketInfo(i)
        if enabled and glyphSpellID and glyphSpellID > 0 then
            local gName = GetSpellInfo(glyphSpellID)
            if gName then
                local typeStr = (glyphType == 1) and L["MAJOR"] or L["MINOR"]
                nt("├─ [" .. typeStr .. "] " .. gName .. "\n")
                hasGlyphs = true
            end
        end
    end
    if not hasGlyphs then nt("└─ (" .. L["NO_GLYPHS"] .. ")\n") end
    nt("\n")

    -- 3. ESTADISTICAS REALES
    nt("[" .. L["KEY_STATS"] .. "]\n")
    nt("├─ " .. L["MAX_HEALTH"] .. ": " .. UnitHealthMax("player") .. "\n")
    nt("├─ " .. L["ARMOR"] .. ": " .. select(2, UnitArmor("player")) .. "\n")
    nt("└─ " .. L["ATTACK_POWER"] .. ": " .. select(1, UnitAttackPower("player")) .. " (" .. L["RANGE"] .. ": " .. select(1, UnitRangedAttackPower("player")) .. ")\n\n")

    -- 4. ESTADO DE OBJETIVOS (CAPS)
    nt("[" .. L["CAPS_STATUS_LOGS"] .. "]\n")
    local dynamicGems = GearAnalyzer:GetDynamicGems(GearAnalyzer:GetClassToken(iF), GearAnalyzer:GetCurrentSpecEnhanced(iF))
    if dynamicGems and dynamicGems.capsStatus then
        for _, s in ipairs(dynamicGems.capsStatus) do
            local currentVal = GearAnalyzer:GetPlayerStat(s.stat)
            local targetVal = s.cap or 0
            if (s.stat == "HIT" or s.stat == "HIT_SPELL") and targetVal > 50 then
                targetVal = (s.stat == "HIT") and (targetVal / 32.79) or (targetVal / 26.23)
            elseif s.stat == "EXPERTISE" and targetVal > 100 then
                 targetVal = (targetVal / 8.2)
            end
            local fmt = "%d / %d"
            if s.stat == "HIT" or s.stat == "HIT_SPELL" or s.stat == "EXPERTISE" or s.stat == "CRIT" then
                fmt = "%.1f%% / %.1f%%"
            end
            local statusLabel = s.met and "[OK]" or "[" .. L["PRIORITY_TAG"] .. "]"
            nt("+- " .. (GearAnalyzer:LocalizeText(s.label)) .. ": " .. string.format(fmt, currentVal, 0):gsub(" / 0.0%%", ""):gsub(" / 0", "") .. " / CAP " .. string.format(fmt, 0, targetVal):gsub("0.0%% / ", ""):gsub("0 / ", "") .. " - " .. statusLabel .. "\n")
        end
    end
    nt("\n")

    -- 5. EQUIPAMIENTO DETALLADO
    nt("[" .. L["EQUIPMENT_DETAILS"] .. "]\n")
    local isEnchantable = {
        ["Head"] = true, ["Shoulders"] = true, ["Cloak"] = true, ["Chest"] = true,
        ["Bracers"] = true, ["Gloves"] = true, ["Waist"] = true, ["Legs"] = true,
        ["Boots"] = true, ["Main Hand"] = true, ["Off Hand"] = true,
        ["Two-Hand"] = true, ["One-Hand"] = true,
        ["Cabeza"] = true, ["Hombros"] = true, ["Pecho"] = true,
    }
    if GearAnalyzer.scannedEquipment then
        for _, d in ipairs(GearAnalyzer.scannedEquipment) do
            if d.itemLink then
                local slotName = GearAnalyzer:LocalizeText(d.slotName or "Unknown")
                local cleanLink = d.itemLink:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|Hitem:.-|h", ""):gsub("|h", "")
                nt("+- " .. slotName .. ": " .. cleanLink .. "\n")
                if d.enchant and tonumber(d.enchant) > 0 then
                    local eData = GearAnalyzer:GetEnchantData(tonumber(d.enchant))
                    nt("  + " .. L["ENCHANT_LABEL"] .. ": " .. GearAnalyzer:LocalizeText(eData and eData.name or "Unknown Enchant") .. "\n")
                elseif isEnchantable[slotName] or isEnchantable[d.slotName] then
                    nt("  + " .. L["ENCHANT_LABEL"] .. ": (" .. L["MISSING"] .. ") !!!\n")
                end
                if d.socketAnalysis and #d.socketAnalysis > 0 then
                    for i, socket in ipairs(d.socketAnalysis) do
                        local color = GearAnalyzer:LocalizeText(socket.color:upper())
                        local rawName = (socket.currentGID and socket.currentGID > 0) and socket.currentName or ("(" .. L["EMPTY"] .. ")")
                        local gemName = GearAnalyzer:LocalizeText(rawName):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|Hitem:.-|h", ""):gsub("|h", "")
                        nt("  + " .. L["GEM_LABEL"] .. " " .. i .. " (" .. color .. "): " .. gemName .. "\n")
                    end
                end
                nt("\n")
            else
                nt("+- " .. GearAnalyzer:LocalizeText(d.slotName or "Unknown") .. ": (" .. L["EMPTY"] .. ")\n\n")
            end
        end
    end
    nt("=== " .. L["PROFILE_FINISH"] .. " ===\n")
    nt(L["GENERATED_BY"] .. " for NaerZone")
    return table.concat(t)
end
