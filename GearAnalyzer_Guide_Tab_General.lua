-- =============================================
-- GearAnalyzer Guide Tab: General (ULTRA-ROBUSTA)
-- =============================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabGeneralGuide")

function Tab:Update(page, isPJ)
    if not page or isPJ then return end
    
    local class = GearAnalyzer.db.profile.settings.forcedClass or "AUTO"
    local spec = GearAnalyzer.db.profile.settings.forcedSpec or "AUTO"
    
    -- Resolución y Normalización de seguridad
    if not class or class == "AUTO" or class == "" then 
        class = select(2, UnitClass("player")):upper() or "MAGE" 
    end
    if not spec or spec == "AUTO" or spec == "" or spec == "None" then 
        spec = GearAnalyzer:GetCurrentSpec(true) or "None"
    end
    
    class = tostring(class):upper()
    spec = GearAnalyzer:NormalizeSpecName(tostring(spec))
    
    if not GearAnalyzer.ClassData[class] then GearAnalyzer:LoadClassData(class) end

    -- Asegurar ScrollFrame
    if not self.scroll or self.scroll:GetParent() ~= page then
        local w = page:GetWidth()
        if not w or w < 100 then w = 760 end

        self.header = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        self.header:SetPoint("TOPLEFT", 10, -10)

        self.scroll = CreateFrame("ScrollFrame", "GAGuideGeneralScroll", page, "UIPanelScrollFrameTemplate")
        self.scroll:SetPoint("TOPLEFT", 10, -40); self.scroll:SetPoint("BOTTOMRIGHT", -9, 10)
        
        self.content = CreateFrame("Frame", nil, self.scroll)
        self.content:SetSize(w - 30, 960)
        self.scroll:SetScrollChild(self.content)

        self.gemsSection = self:CreateSection(self.content, L["RECOMMENDED_GEMS"] or "GEMAS RECOMENDADAS", -20)
        self.glyphsSection = self:CreateSection(self.content, L["RECOMMENDED_GLYPHS"] or "GLIFOS RECOMENDADOS", -330)
        self.capsSection = self:CreateSection(self.content, L["STATS_AND_CAPS"] or "CAPS Y ESTADÍSTICAS", -640)
    end
    
    -- Inicialización crítica de filas si faltan
    if not self.rows then self.rows = { gems = {}, glyphs = {}, caps = {} } end

    -- Título con protección
    local title = string.format(L["GUIDE_TITLE_FMT"] or "Guía de %s - %s", GearAnalyzer.SafeL(class), GearAnalyzer.SafeL(spec))
    if self.header then 
        self.header:SetText(title) 
        GearAnalyzer:ApplyStyle(self.header, true)
    end

    -- Iconos de clase y especialización (helper compartido)
    GearAnalyzer:SetupGuideIcons(page, class, spec)

    local pending1 = false
    local pending2 = false
    pcall(function() pending1 = self:UpdateGems(class, spec) end)
    pcall(function() pending2 = self:UpdateGlyphs(class, spec) end)
    pcall(function() self:UpdateCaps(class, spec) end)

    if pending1 or pending2 then
        if not self.refreshTimer then
            self.refreshTimer = GearAnalyzer:ScheduleRepeatingTimer(function()
                if page:IsShown() then
                    self:Update(page)
                else
                    GearAnalyzer:CancelTimer(self.refreshTimer)
                    self.refreshTimer = nil
                end
            end, 1.5)
        end
    else
        if self.refreshTimer then
            GearAnalyzer:CancelTimer(self.refreshTimer)
            self.refreshTimer = nil
        end
    end
end

function Tab:CreateSection(parent, title, y)
    local f = CreateFrame("Frame", nil, parent)
    f:SetSize(parent:GetWidth() - 20, 250)
    f:SetPoint("TOPLEFT", 10, y - 35)
    f:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    f:SetBackdropColor(0, 0, 0, 0.6)
    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    t:SetPoint("TOPLEFT", 10, 20); t:SetText("|cffffd100" .. title .. "|r")
    return f
end

function Tab:UpdateGems(class, spec)
    local pending = false
    local data = GearAnalyzer:GetDynamicGems(class, spec)
    if not data then return false end
    
    local gemList = {
        {l="Meta", id=data.meta, c="|cff00ffff"},
        {l="Roja", id=data.red, c="|cffff3333"},
        {l="Amarilla", id=data.yellow, c="|cffffff33"},
        {l="Azul", id=data.blue, c="|cff3333ff"}
    }

    -- Ocultar filas previas por si el nuevo perfil tiene menos
    for _, row in pairs(self.rows.gems) do row:Hide() end

    for i, g in ipairs(gemList) do
        if g.id and g.id > 0 then
            local r = self:GetOrCreateRow(i, "gems", self.gemsSection)
            r:ClearAllPoints()
            r:SetPoint("TOPLEFT", 10, -20 - (i-1)*45)
            r.itemID = g.id
            
            r.icon:SetTexture(GetItemIcon(g.id) or "Interface\\Icons\\INV_Misc_QuestionMark")
            local name = GearAnalyzer:GetItemInfoFallback(g.id)
            if name then
                r.text:SetText(g.c..g.l..":|r |cffffffff"..name.."|r")
            else
                pending = true
                r.text:SetText(g.c..g.l..":|r |cff888888Cargando...|r")
                pcall(function() 
                    GetItemInfo(g.id)
                    GetItemInfo("item:"..g.id)
                    GetItemInfo(string.format("|Hitem:%d:0:0:0:0:0:0:0|h[Item]|h", g.id))
                end)
            end
            r:Show()
        end
    end
    return pending
end

function Tab:UpdateGlyphs(class, spec)
    local pending = false
    local classData = GearAnalyzer.ClassData[class]
    local glyphs = classData and classData.Glyphs and classData.Glyphs[spec]
    if not glyphs then return false end

    local list = {}
    for _, id in ipairs(glyphs.major or {}) do table.insert(list, {id=id, t=(L["MAJOR"] or "Sublime")}) end
    for _, id in ipairs(glyphs.minor or {}) do table.insert(list, {id=id, t=(L["MINOR"] or "Menor")}) end

    -- Ocultar filas previas
    for _, row in pairs(self.rows.glyphs) do row:Hide() end

    for i, g in ipairs(list) do
        if i > 6 then break end
        local r = self:GetOrCreateRow(i, "glyphs", self.glyphsSection)
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", 10, -20 - (i-1)*34)
        r.itemID = g.id
        
        local icon = GetItemIcon(g.id)
        r.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        
        local name = GearAnalyzer:GetItemInfoFallback(g.id)
        if name then
            local color = (g.t == "Sublime") and "|cffffd100" or "|cff00ff00"
            r.text:SetText(color.."["..g.t.."]|r |cffffffff"..name.."|r")
        else
            pending = true
            r.text:SetText("|cffaaaaaa["..g.t.."]|r |cff888888Cargando...|r")
            -- Re-intentar forzando la petición al servidor
            pcall(function() 
                GetItemInfo(g.id)
                GetItemInfo("item:"..g.id)
                GetItemInfo(string.format("|Hitem:%d:0:0:0:0:0:0:0|h[Item]|h", g.id))
            end)
        end
        r:Show()
    end
    return pending
end

function Tab:UpdateCaps(class, spec)
    for _, r in ipairs(self.rows.caps) do r:Hide() end
    local classData = GearAnalyzer.ClassData[class]
    local caps = classData and classData.Caps and classData.Caps[spec]
    if not caps then return end
    local list = {}
    
    if caps.hitCap and caps.hitCap.percent then 
        local target = caps.hitCap.percent
        local noteText = caps.hitCap.note
        if class == "DRUID" and spec == "Balance" then
            local faction = UnitFactionGroup("player")
            if faction == "Horde" then
                target = 10
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
                target = hasDraenei and 9 or 10
            end
            noteText = target == 9 and "9% (Con Draenei)" or "10% (Sin Draenei)"
        end
        table.insert(list, {l=GearAnalyzer.StatTrans["HIT"] or "Golpe", v=target.."%", n=noteText}) 
    end
    if caps.expertiseCap and caps.expertiseCap.skill then 
        table.insert(list, {l=GearAnalyzer.StatTrans["EXPERTISE"] or "Pericia", v=caps.expertiseCap.skill, n=caps.expertiseCap.note}) 
    end
    
    if caps.priorities then
        for _, p in ipairs(caps.priorities) do
            if p and p.cap then table.insert(list, {l=p.label or p.stat, v=p.cap, n=p.note}) end
        end
    end

    for i, c in ipairs(list) do
        if i > 6 then break end
        local r = self:GetOrCreateRow(i, "caps", self.capsSection)
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", 10, -20 - (i-1)*32)
        r.icon:SetTexture("Interface\\Icons\\Spell_Holy_WordFortitude")
        local rawLabel = GearAnalyzer.StatTrans[c.l] or c.l
        local locLabel = GearAnalyzer:LocalizeText(rawLabel) or rawLabel
        local locNote = c.n and GearAnalyzer:LocalizeText(c.n) or ""
        r.text:SetText("|cffffff00"..(locLabel or "")..":|r |cffffffff"..(c.v or "").."|r " .. (locNote ~= "" and "|cff888888("..locNote..")|r" or ""))
        r:Show()
    end
end

function Tab:GetOrCreateRow(i, type, parent)
    if self.rows[type][i] then return self.rows[type][i] end

    local r = CreateFrame("Button", nil, parent)
    r:SetSize(400, 30)
    r:RegisterForClicks("AnyUp")
    
    local highlight = r:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    highlight:SetBlendMode("ADD")
    
    local icon = r:CreateTexture(nil, "ARTWORK")
    icon:SetSize(28, 28); icon:SetPoint("LEFT", 5, 0)
    r.icon = icon
    
    local text = r:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("LEFT", icon, "RIGHT", 10, 0); text:SetJustifyH("LEFT")
    r.text = text
    
    r:SetScript("OnEnter", function(self)
        if self.itemID and self.itemID > 0 then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. self.itemID .. ":0:0:0:0:0:0:0")
            GameTooltip:Show()
        end
    end)
    r:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r:SetScript("OnClick", function(self)
        if self.itemID and self.itemID > 0 then
            local _, link = GetItemInfo(self.itemID)
            if link then HandleModifiedItemClick(link) end
        end
    end)
    
    self.rows[type][i] = r
    return r
end
