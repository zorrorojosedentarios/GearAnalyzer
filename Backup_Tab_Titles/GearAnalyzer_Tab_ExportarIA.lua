-- =========================
-- GearAnalyzer Tab: Exportar IA
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabExportarIA")

function Tab:Update(page, ignoreForced)
    self.ignoreForced = ignoreForced  -- Guardar contexto de ventana
    GearAnalyzer:ScanEquipment()
    GearAnalyzer:AnalyzeEquipment(ignoreForced)

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
        editBox:SetWidth(page:GetWidth() - 60) -- Usar el ancho de la página directamente con un margen
        editBox:SetAutoFocus(false)
        editBox:SetMaxLetters(0) -- Sin limite
        editBox:SetTextInsets(5, 5, 5, 5)
        editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
        
        -- Evitar que bloquee las teclas cuando se oculta el tab
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
    end
    
    -- Asegurar que el ancho es correcto por si cambió el tamaño de la ventana
    self.editBox:SetWidth(self.container:GetWidth() - 60)
    
    local text = self:GenerateExportText(self.ignoreForced)
    local oldText = self.editBox:GetText()
    
    if oldText ~= text then
        self.editBox:SetText(text)
        -- Solo resetear scroll si el texto cambió radicalmente (opcional)
        -- GAExportScroll:SetVerticalScroll(0)
    end
end

function Tab:GenerateExportText(ignoreForced)
    local iF = ignoreForced
    local name = UnitName("player")
    local classTag = GearAnalyzer:GetClassToken(iF)
    local rawSpec = GearAnalyzer:GetCurrentSpecEnhanced(iF) or "Ninguna"
    local currentSpec = GearAnalyzer:LocalizeText(rawSpec)
    
    local text = L["AI_INTRO_PROMPT"] .. "\n\n"
    text = text .. "=== " .. L["PROFILE_LABEL"] .. ": " .. name .. " (" .. (GearAnalyzer:GetLocalizedClassName(iF) or "UNKNOWN") .. ") ===\n"
    text = text .. L["SPEC_LABEL"] .. ": " .. currentSpec .. "\n\n"

    -- 1. TALENTOS
    local n1, _, p1 = GetTalentTabInfo(1)
    local n2, _, p2 = GetTalentTabInfo(2)
    local n3, _, p3 = GetTalentTabInfo(3)
    text = text .. "[" .. L["TALENT_DISTRIBUTION"] .. "]\n"
    text = text .. "├─ " .. (GearAnalyzer:LocalizeText(n1) or (L["BRANCH"] .. " 1")) .. ": " .. (p1 or 0) .. "\n"
    text = text .. "├─ " .. (GearAnalyzer:LocalizeText(n2) or (L["BRANCH"] .. " 2")) .. ": " .. (p2 or 0) .. "\n"
    text = text .. "└─ " .. (GearAnalyzer:LocalizeText(n3) or (L["BRANCH"] .. " 3")) .. ": " .. (p3 or 0) .. "\n\n"

    -- 2. GLIFOS ACTIVOS
    text = text .. "[" .. L["ACTIVE_GLYPHS"] .. "]\n"
    local hasGlyphs = false
    for i = 1, 6 do
        local enabled, glyphType, glyphSpellID = GetGlyphSocketInfo(i)
        if enabled and glyphSpellID and glyphSpellID > 0 then
            local gName = GetSpellInfo(glyphSpellID)
            if gName then
                local typeStr = (glyphType == 1) and L["MAJOR"] or L["MINOR"]
                text = text .. "├─ [" .. typeStr .. "] " .. gName .. "\n"
                hasGlyphs = true
            end
        end
    end
    if not hasGlyphs then text = text .. "└─ (" .. L["NO_GLYPHS"] .. ")\n" end
    text = text .. "\n"

    -- 3. ESTADISTICAS REALES
    text = text .. "[" .. L["KEY_STATS"] .. "]\n"
    text = text .. "├─ " .. L["MAX_HEALTH"] .. ": " .. UnitHealthMax("player") .. "\n"
    text = text .. "├─ " .. L["ARMOR"] .. ": " .. select(2, UnitArmor("player")) .. "\n"
    text = text .. "└─ " .. L["ATTACK_POWER"] .. ": " .. select(1, UnitAttackPower("player")) .. " (" .. L["RANGE"] .. ": " .. select(1, UnitRangedAttackPower("player")) .. ")\n\n"

    -- 4. ESTADO DE OBJETIVOS (CAPS)
    text = text .. "[" .. L["CAPS_STATUS_LOGS"] .. "]\n"
    local dynamicGems = GearAnalyzer:GetDynamicGems(classTag, rawSpec)
    if dynamicGems and dynamicGems.capsStatus then
        for _, s in ipairs(dynamicGems.capsStatus) do
            local currentVal = GearAnalyzer:GetPlayerStat(s.stat)
            local targetVal = s.cap or 0
            
            -- Especial: Convertir targets si son ratings
            if (s.stat == "HIT" or s.stat == "HIT_SPELL") and targetVal > 50 then
                targetVal = (s.stat == "HIT") and (targetVal / 32.79) or (targetVal / 26.23)
            elseif s.stat == "EXPERTISE" and targetVal > 100 then
                 targetVal = (targetVal / 8.2)
            end

            -- Aplicar formato según el tipo de estadística
            local fmt = "%d / %d"
            if s.stat == "HIT" or s.stat == "HIT_SPELL" or s.stat == "EXPERTISE" or s.stat == "CRIT" then
                fmt = "%.1f%% / %.1f%%"
            end
            
            local statusLabel = s.met and "[OK]" or "[" .. L["PRIORITY_TAG"] .. "]"
            local localizedLabel = GearAnalyzer:LocalizeText(s.label)
            text = text .. "+- " .. localizedLabel .. ": " .. string.format(fmt, currentVal, 0):gsub(" / 0.0%%", ""):gsub(" / 0", "") .. " / CAP " .. string.format(fmt, 0, targetVal):gsub("0.0%% / ", ""):gsub("0 / ", "") .. " - " .. statusLabel .. "\n"
        end
    end
    text = text .. "\n"

    -- 5. EQUIPAMIENTO DETALLADO
    text = text .. "[" .. L["EQUIPMENT_DETAILS"] .. "]\n"
    if GearAnalyzer.scannedEquipment then
        for _, d in ipairs(GearAnalyzer.scannedEquipment) do
            if d.itemLink then
                local slotName = GearAnalyzer:LocalizeText(d.slotName or "Unknown")
                local cleanItemLink = d.itemLink:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|Hitem:.-|h", ""):gsub("|h", "")
                text = text .. "+- " .. slotName .. ": " .. cleanItemLink .. "\n"
                
                -- Encantamiento
                local isEnchantable = {
                    ["Head"] = true, ["Shoulders"] = true, ["Cloak"] = true, ["Chest"] = true,
                    ["Bracers"] = true, ["Gloves"] = true, ["Waist"] = true, ["Legs"] = true,
                    ["Boots"] = true, ["Main Hand"] = true, ["Off Hand"] = true,
                    ["Two-Hand"] = true, ["One-Hand"] = true
                }
                -- También probar en español por si el DB local aún no se actualizó
                isEnchantable["Cabeza"] = true; isEnchantable["Hombros"] = true; isEnchantable["Pecho"] = true; 

                if d.enchant and tonumber(d.enchant) > 0 then
                    local eData = GearAnalyzer:GetEnchantData(tonumber(d.enchant))
                    local eName = GearAnalyzer:LocalizeText(eData and eData.name or "Unknown Enchant")
                    text = text .. "  + " .. L["ENCHANT_LABEL"] .. ": " .. eName .. "\n"
                elseif isEnchantable[slotName] or isEnchantable[d.slotName] then
                    text = text .. "  + " .. L["ENCHANT_LABEL"] .. ": (" .. L["MISSING"] .. ") !!!\n"
                end

                -- Gemas
                if d.socketAnalysis and #d.socketAnalysis > 0 then
                    for i, socket in ipairs(d.socketAnalysis) do
                        local color = GearAnalyzer:LocalizeText(socket.color:upper())
                        local rawGemName = (socket.currentGID and socket.currentGID > 0) and socket.currentName or ("(" .. L["EMPTY"] .. ")")
                        local gemName = GearAnalyzer:LocalizeText(rawGemName):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|Hitem:.-|h", ""):gsub("|h", "")
                        text = text .. "  + " .. L["GEM_LABEL"] .. " " .. i .. " (" .. color .. "): " .. gemName .. "\n"
                    end
                end
                text = text .. "\n"
            else
                text = text .. "+- " .. GearAnalyzer:LocalizeText(d.slotName or "Unknown") .. ": (" .. L["EMPTY"] .. ")\n\n"
            end
        end
    end
    text = text .. "=== " .. L["PROFILE_FINISH"] .. " ===\n"
    text = text .. L["GENERATED_BY"] .. " for NaerZone"
    return text
end
