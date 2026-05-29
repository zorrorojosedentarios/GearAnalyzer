-- ===================================================
-- GearAnalyzer Guide Tab: Caps (Ventana Guía)
-- Módulo independiente - siempre usa ignoreForced=false
-- Muestra los caps y prioridades para la clase/spec del dropdown
-- ===================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabCapsGuide")

function Tab:Update(page, ignoreForced)
    -- ignoreForced = false (siempre usa los dropdowns)
    GearAnalyzer:AnalyzeEquipment(false)
    if not page then return end

    -- Asegurar que L tiene las entradas críticas si AceLocale falla
    if not L["HIT_CAP"] then L["HIT_CAP"] = "Cap de Golpe" end
    if not L["EXPERTISE_CAP"] then L["EXPERTISE_CAP"] = "Cap de Pericia" end

    if not self.scroll then
        local scroll = CreateFrame("ScrollFrame", "GACapsScrollGuide", page, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -9, 10)
        self.scroll = scroll

        local content = CreateFrame("Frame", nil, scroll)
        local w = page:GetWidth()
        if not w or w <= 0 then w = 760 end
        content:SetSize(w - 40, 1000)
        scroll:SetScrollChild(content)
        self.content = content

        local title = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -10)
        self.title = title

        self.rows = {}
    end

    for _, row in pairs(self.rows) do row:Hide() end

    local class      = GearAnalyzer:GetClassToken(false)
    local classLoc   = GearAnalyzer:GetLocalizedClassName(false)
    local activeSpec = GearAnalyzer:GetCurrentSpecEnhanced(false)
    local spec       = GearAnalyzer:NormalizeSpecName(activeSpec)
    local specLabel  = GearAnalyzer:GetSpecLabel(spec)
    local classData  = GearAnalyzer.ClassData[class]
    local specData   = classData and classData.Caps and classData.Caps[spec]

    if not specData then
        self.title:SetText(string.format(L["STAT_ERROR_MSG"], class or "?", activeSpec or "?"))
        return
    end

    self.title:SetText(L["STATS_AND_CAPS"] .. " - " .. classLoc .. " " .. specLabel)
    GearAnalyzer:ApplyStyle(self.title, true)
    GearAnalyzer:SetupGuideIcons(page, class, spec)

    local y = -10
    local rowIndex = 0

    -- Helper para formatear valores que pueden ser tablas o números
    local function FormatCapValue(val, defaultUnit)
        if not val then return "---", nil end
        if type(val) == "table" then
            local text = ""
            if val.percent then text = tostring(val.percent) .. "%" end
            if val.skill then text = (text ~= "" and text .. " / " or "") .. tostring(val.skill) end
            if val.rating then 
                if text ~= "" then
                    text = text .. " (" .. tostring(val.rating) .. " rating)" 
                else
                    text = tostring(val.rating) .. " rating"
                end
            end
            return (text == "" and "---" or text), val.note
        end
        return tostring(val) .. (defaultUnit or ""), nil
    end

    -- Helper para crear filas
    local function AddRow(label, value, color, note)
        rowIndex = rowIndex + 1
        local row = self:GetOrCreateRow(rowIndex)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", self.content, "TOPLEFT", 5, y)
        row:Show()

        row.label:SetText(tostring(label or ""))
        row.value:SetText((color or "|cffffff00") .. tostring(value or "---") .. "|r")
        if row.note then row.note:SetText(tostring(note or "")) end

        GearAnalyzer:ApplyStyle(row.label)
        GearAnalyzer:ApplyStyle(row.value)
        y = y - 28
    end

    local function AddSection(title)
        rowIndex = rowIndex + 1
        local row = self:GetOrCreateSectionRow(rowIndex)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", self.content, "TOPLEFT", 0, y)
        row:Show()
        row.label:SetText("|cffffd100" .. title .. "|r")
        y = y - 30
    end

    -- Caps críticos
    if specData.hitCap or specData.expertiseCap then
        AddSection(L["CRITICAL_CAPS"])
        if specData.hitCap then
            local hitCapCopy = {
                percent = specData.hitCap.percent,
                rating = specData.hitCap.rating,
                note = specData.hitCap.note
            }
            if class == "DRUID" and spec == "Balance" then
                local faction = UnitFactionGroup("player")
                if faction == "Horde" then
                    hitCapCopy.percent = 10
                    hitCapCopy.rating = 263
                else
                    local hasDraenei = false
                    local _, race = UnitRace("player")
                    if race == "Draenei" then
                        hasDraenei = true
                    else
                        local numRaid = GetNumRaidMembers() or 0
                        if numRaid > 0 then
                            for i = 1, numRaid do
                                if UnitExists("raid" .. i) and select(2, UnitRace("raid" .. i)) == "Draenei" then
                                    hasDraenei = true
                                    break
                                end
                            end
                        else
                            local numParty = GetNumPartyMembers() or 0
                            if numParty > 0 then
                                for i = 1, numParty do
                                    if UnitExists("party" .. i) and select(2, UnitRace("party" .. i)) == "Draenei" then
                                        hasDraenei = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                    hitCapCopy.percent = hasDraenei and 9 or 10
                    hitCapCopy.rating = hasDraenei and 237 or 263
                end
                hitCapCopy.note = hitCapCopy.percent == 9 and "9% (Con Draenei)" or "10% (Sin Draenei)"
            end
            local text, note = FormatCapValue(hitCapCopy, specData.hitCapUnit or "%")
            AddRow(L["HIT_CAP"], text, "|cff00ff00", note)
        end
        if specData.expertiseCap then
            local text, note = FormatCapValue(specData.expertiseCap, specData.expertiseCapUnit or " expertise")
            AddRow(L["EXPERTISE_CAP"], text, "|cff00ff00", note)
        end
    end

    -- Caps secundarios
    if specData.hasteTarget or specData.armorPenCap or specData.spellPenCap then
        AddSection(L["SECONDARY_CAPS"])
        if specData.hasteTarget then
            local text, note = FormatCapValue(specData.hasteTarget, specData.hasteUnit or "%")
            AddRow(L["HASTE_GOAL"], text, "|cffffff00", note)
        end
        if specData.armorPenCap then
            local text, note = FormatCapValue(specData.armorPenCap, specData.armorPenUnit or "%")
            AddRow(L["ARMOR_PEN_CAP"], text, "|cffffff00", note)
        end
        if specData.spellPenCap then
            local text, note = FormatCapValue(specData.spellPenCap, " rating")
            AddRow(L["SPELL_PEN_CAP"], text, "|cffffff00", note)
        end
    end

    -- Prioridades de stats
    if specData.priorities and #specData.priorities > 0 then
        AddSection(L["STAT_PRIORITY"])
        local prioStr = ""
        for i, p in ipairs(specData.priorities) do
            local lbl = rawget(L, p.label) or p.label
            prioStr = prioStr .. lbl .. (i < #specData.priorities and " > " or "")
        end
        AddRow(L["PRIORITY_ORDER"], prioStr, "|cff3fc7eb",
            specData.priorityNote and GearAnalyzer:LocalizeText(specData.priorityNote) or nil)
    end

    -- Nota general
    if specData.note then
        y = y - 5
        AddSection(L["NOTES"])
        AddRow("", GearAnalyzer:LocalizeText(specData.note), "|cffaaaaaa")
    end

    self.content:SetHeight(math.max(300, math.abs(y) + 20))
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] then return self.rows[i] end

    local row = CreateFrame("Frame", nil, self.content)
    row:SetSize(self.content:GetWidth() - 10, 26)

    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(); bg:SetTexture(1, 1, 1, 0.03)

    local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("LEFT", 10, 0); label:SetWidth(180)
    row.label = label

    local value = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    value:SetPoint("LEFT", label, "RIGHT", 8, 0); value:SetWidth(300)
    row.value = value

    local note = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    note:SetPoint("LEFT", value, "RIGHT", 8, 0); note:SetWidth(250)
    note:SetTextColor(0.7, 0.7, 0.7)
    row.note = note

    self.rows[i] = row
    return row
end

function Tab:GetOrCreateSectionRow(i)
    local key = "s" .. i
    if self.rows[key] then return self.rows[key] end

    local row = CreateFrame("Frame", nil, self.content)
    row:SetSize(self.content:GetWidth(), 28)

    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(); bg:SetTexture(0.2, 0.2, 0.1, 0.8)

    local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("LEFT", 8, 0)
    row.label = label

    self.rows[key] = row
    return row
end
