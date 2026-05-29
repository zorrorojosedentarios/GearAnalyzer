-- ===================================================
-- GearAnalyzer Guide Tab: Glifos (Ventana Guía)
-- Módulo independiente - siempre usa ignoreForced=false
-- Solo muestra recomendados (sin comparación con equipados)
-- ===================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabGlifosGuide")

function Tab:Update(page, ignoreForced)
    if not page then return end

    local rawSpec  = GearAnalyzer:GetCurrentSpecEnhanced(false)
    local spec     = GearAnalyzer:NormalizeSpecName(rawSpec)
    local classLoc = GearAnalyzer:GetLocalizedClassName(false)
    local specLabel = GearAnalyzer:GetSpecLabel(spec)

    if not self.container then
        local f = CreateFrame("Frame", nil, page)
        f:SetAllPoints()
        self.container = f

        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -10)
        GearAnalyzer:ApplyStyle(title, true)
        self.titleString = title

        local scroll = CreateFrame("ScrollFrame", "GAGlifosScrollGuide", f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -9, 10)
        self.scroll = scroll

        local content = CreateFrame("Frame", nil, scroll)
        local w = f:GetWidth()
        if not w or w <= 0 then w = 760 end
        content:SetWidth(w - 50)
        content:SetHeight(600)
        scroll:SetScrollChild(content)
        self.content = content
        self.content.headers = {}

        self.rows = {}
    end

    self.titleString:SetText(L["GLYPH_MANAGEMENT"] .. " - " .. classLoc .. " " .. specLabel)
    GearAnalyzer:SetupGuideIcons(page, GearAnalyzer:GetClassToken(false), spec)

    -- Limpiar filas
    for _, r in ipairs(self.rows) do r:Hide() end
    for _, h in ipairs(self.content.headers) do h:Hide() end

    local class     = GearAnalyzer:GetClassToken(false)
    local classData = GearAnalyzer.ClassData[class]
    local glyphData = classData and classData.Glyphs and classData.Glyphs[spec]

    if not glyphData then
        if not self.errorMsg then
            self.errorMsg = self.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.errorMsg:SetPoint("CENTER", 0, 0)
        end
        self.errorMsg:SetText("|cffffb300" .. L["NO_GLYPH_GUIDE_FOUND"] .. "|r\n" .. class .. " - " .. spec)
        self.errorMsg:Show()
        return
    elseif self.errorMsg then
        self.errorMsg:Hide()
    end

    local y = -5
    local i = 1

    local categories = {
        { key = "major", label = "|cffffd100" .. L["MAJOR_GLYPHS"] .. "|r" },
        { key = "minor", label = "|cffaaaaaa" .. L["MINOR_GLYPHS"] .. "|r" },
    }

    for _, cat in ipairs(categories) do
        local list = glyphData[cat.key]
        if list and #list > 0 then
            -- Header de categoría
            local hdr = self.content.headers[_] or self.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.content.headers[_] = hdr
            hdr:ClearAllPoints()
            hdr:SetPoint("TOPLEFT", 5, y)
            hdr:SetText(cat.label)
            hdr:Show()
            y = y - 22

            for _, glyphID in ipairs(list) do
                local row = self:GetOrCreateRow(i)
                row:ClearAllPoints()
                row:SetPoint("TOPLEFT", self.content, "TOPLEFT", 10, y)
                row:Show()

                local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(glyphID)
                if not name and GearAnalyzer.scanner and glyphID > 0 then
                    GearAnalyzer.scanner:SetHyperlink("item:" .. glyphID)
                    name, link, _, _, _, _, _, _, _, texture = GetItemInfo(glyphID)
                end

                row.icon:SetTexture(texture)
                row.itemID = glyphID
                row.itemLink = link
                row.nameText:SetText(link or ("[ID:" .. glyphID .. "]"))
                GearAnalyzer:ApplyStyle(row.nameText)

                y = y - 32
                i = i + 1
            end
            y = y - 8
        end
    end

    self.content:SetHeight(math.max(200, math.abs(y) + 20))
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] then return self.rows[i] end

    local row = CreateFrame("Frame", nil, self.content)
    row:SetSize(self.content:GetWidth() - 20, 28)
    row:EnableMouse(true)

    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(); bg:SetTexture(1, 1, 1, 0.03)

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(24, 24); icon:SetPoint("LEFT", 2, 0)
    row.icon = icon

    local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    nameText:SetPoint("LEFT", icon, "RIGHT", 6, 0)
    row.nameText = nameText

    -- Tooltips y Link
    row:SetScript("OnEnter", function(self)
        if self.itemID and self.itemID > 0 then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. self.itemID)
            GameTooltip:Show()
        end
    end)
    row:SetScript("OnLeave", function() GameTooltip:Hide() end)
    row:SetScript("OnMouseUp", function(self, button)
        if self.itemID and self.itemID > 0 then
            HandleModifiedItemClick(self.itemLink or ("item:"..self.itemID))
        end
    end)

    self.rows[i] = row
    return row
end
