-- =========================
-- GearAnalyzer Tab: Info
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabInfo")

function Tab:Update(page, ignoreForced)
    if not page then return end

    if not self.container then
        local f = CreateFrame("Frame", nil, page)
        f:SetAllPoints()
        self.container = f
        
        local Title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        Title:SetPoint("TOP", 0, -10)
        Title:SetText(string.format(L["INFO_TITLE"], GearAnalyzer.version or "v3.5"))
        
        -- Añadir ScrollFrame
        local scroll = CreateFrame("ScrollFrame", "GAInfoScroll", f, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        
        local content = CreateFrame("Frame", nil, scroll)
        content:SetSize(f:GetWidth() - 40, 600)
        scroll:SetScrollChild(content)
        self.content = content
        
        local text = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("TOPLEFT", 10, -10)
        text:SetWidth(content:GetWidth() - 20)
        text:SetJustifyH("LEFT")
        text:SetJustifyV("TOP")
        GearAnalyzer:ApplyStyle(text)
        self.text = text

    end

    local charName = UnitName("player") or "Player"

    local sections = {}
    for i = 1, 10 do
        local title = L["SECTION_" .. i .. "_TITLE"]
        local body = L["SECTION_" .. i .. "_BODY"]
        if title and body and title ~= "SECTION_" .. i .. "_TITLE" then
            table.insert(sections, { title = title, body = body })
        end
    end

    local infoText = string.format(L["INFO_INTRO"], charName, GearAnalyzer.version or "v3.5")
    
    for _, s in ipairs(sections) do
        infoText = infoText .. "|cffffd100" .. s.title .. "|r\n" .. s.body .. "\n\n"
    end

    infoText = infoText .. "|cff888888" .. L["INFO_CREDITS"] .. "|r\n"

    if self.text then
        self.text:SetText(infoText)
    end

    -- Ajustar la altura del contenido para que el scroll funcione
    local contentHeight = self.text:GetStringHeight() + 60
    self.content:SetHeight(math.max(contentHeight, 400))
end
