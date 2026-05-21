-- =========================
-- GearAnalyzer Tab: Glifos
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabGlifos")

function Tab:Update(page, ignoreForced)
    if not page then return end

    local rawSpec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local spec = GearAnalyzer:NormalizeSpecName(rawSpec)
    
    -- Generar hash de estado para evitar actualizaciones redundantes
    local glyphHash = spec
    for i = 1, 6 do
        local _, _, id = GetGlyphSocketInfo(i)
        glyphHash = glyphHash .. (id or 0)
    end

    if self.lastHash == glyphHash and self.container and not self.needsUpdate then return end
    self.lastHash = glyphHash
    self.needsUpdate = false

    -- 1. CREACIÓN ÚNICA
    if not self.container then
        local f = CreateFrame("Frame", nil, page)
        f:SetAllPoints()
        self.container = f
        
        local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, 15)
        GearAnalyzer:ApplyStyle(title, true)
        self.titleString = title

        -- Contenedor Izquierdo (Recomendados)
        local leftPanel = CreateFrame("Frame", nil, f)
        leftPanel:SetPoint("TOPLEFT", 0, -40)
        leftPanel:SetPoint("BOTTOMLEFT", 0, 0)
        leftPanel:SetWidth(450)
        self.leftPanel = leftPanel

        local leftTitle = leftPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        leftTitle:SetPoint("TOPLEFT", 15, 0)
        leftTitle:SetText("|cffffd100" .. L["RECOMMENDED_GUIDE"] .. "|r")
        
        local scrollLeft = CreateFrame("ScrollFrame", "GAGlifosScrollLeft", leftPanel, "UIPanelScrollFrameTemplate")
        scrollLeft:SetPoint("TOPLEFT", 10, -25)
        scrollLeft:SetPoint("BOTTOMRIGHT", -30, 20)

        local contentLeft = CreateFrame("Frame", nil, scrollLeft)
        contentLeft:SetWidth(400)
        contentLeft:SetHeight(400)
        scrollLeft:SetScrollChild(contentLeft)
        self.contentLeft = contentLeft
        self.contentLeft.headers = {}

        -- Contenedor Derecho (Equipados)
        local rightPanel = CreateFrame("Frame", nil, f)
        rightPanel:SetPoint("TOPLEFT", leftPanel, "TOPRIGHT", 10, 0)
        rightPanel:SetPoint("BOTTOMRIGHT", 0, 0)
        self.rightPanel = rightPanel

        local rightTitle = rightPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        rightTitle:SetPoint("TOPLEFT", 10, 0)
        rightTitle:SetText("|cff3fc7eb" .. L["CURRENTLY_EQUIPPED"] .. "|r")

        local rightList = CreateFrame("Frame", nil, rightPanel)
        rightList:SetPoint("TOPLEFT", 0, -25)
        rightList:SetPoint("BOTTOMRIGHT", 0, 20)
        self.rightList = rightList
        self.rightList.headers = {}

        self.rows = {}
        self.equippedRows = {}
    end

    local classLoc = GearAnalyzer:GetLocalizedClassName(ignoreForced)
    local specLabel = GearAnalyzer:GetSpecLabel(spec)
    self.titleString:SetText(L["GLYPH_MANAGEMENT"] .. " - " .. classLoc .. " " .. specLabel)

    -- Limpieza de filas antiguas
    for _, r in ipairs(self.rows) do r:Hide() end
    for _, r in ipairs(self.equippedRows) do r:Hide() end
    for _, h in ipairs(self.contentLeft.headers) do h:Hide() end
    for _, h in ipairs(self.rightList.headers) do h:Hide() end

    -- Obtener Glifos Activos
    local activeGlyphSpells = {}
    local activeMajor = {}
    local activeMinor = {}
    for i = 1, 6 do
        local enabled, glyphType, glyphSpellID, icon = GetGlyphSocketInfo(i)
        if enabled and glyphSpellID then
            activeGlyphSpells[glyphSpellID] = true
            local info = { id = glyphSpellID, type = (glyphType == 1 and L["MAJOR"] or L["MINOR"]), icon = icon }
            if glyphType == 1 then table.insert(activeMajor, info) else table.insert(activeMinor, info) end
        end
    end

    local rowIndex = 1
    local headerIndexLeft = 1
    local yLeft = -10

    local function CreateSection(title, glyphIDs)
        local h = self.contentLeft.headers[headerIndexLeft]
        if not h then
            h = self.contentLeft:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.contentLeft.headers[headerIndexLeft] = h
        end
        h:SetPoint("TOPLEFT", 15, yLeft)
        h:SetText("|cffffd100" .. title .. "|r")
        GearAnalyzer:ApplyStyle(h, true)
        h:Show()
        headerIndexLeft = headerIndexLeft + 1
        yLeft = yLeft - 25
        
        for idx, id in ipairs(glyphIDs) do
            local row = self:GetOrCreateRow(rowIndex)
            row:SetPoint("TOPLEFT", 0, yLeft)
            row:Show()
            
            local isMajor = (title == L["MAJOR_GLYPHS"])
            local sectionTag = isMajor and "MAJOR" or "MINOR"
            local overrideKey = (spec or "NONE") .. "_" .. sectionTag .. "_" .. idx
            local currentID = GearAnalyzer.db.global.customOverrides.glyphs[overrideKey] or id
            id = currentID or 0

            local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
            if not name then GearAnalyzer.scanner:SetHyperlink("item:" .. id) end

            local isActive = false
            -- Optimización: En lugar de buscar por nombre, intentamos relacionar el item con el hechizo
            -- En 3.3.5, el SpellID del glifo suele estar relacionado con el ItemID de forma indirecta
            -- pero como fallback robusto usamos el nombre una sola vez por update
            if name then
                local shortName = name:gsub(L["GLYPH_OF"], ""):gsub(L["GLYPH_OF_2"], ""):trim()
                for activeID, _ in pairs(activeGlyphSpells) do
                    local sName = GetSpellInfo(activeID)
                    if sName and sName:find(shortName) then
                        isActive = true; break
                    end
                end
            else
                self.needsUpdate = true -- Marcar para re-actualizar cuando llegue la data
            end

            row.icon:SetTexture(texture or GetItemIcon(id))
            local count = GetItemCount(id) or 0
            row.countText:SetText((count > 0 and "|cff00ff00" or "|cffff0000") .. count .. "|r")
            
            local status = isActive and "|cff00ff00[OK]|r " or "|cffff0000[" .. L["MISSING_TAG"] .. "]|r "
            row.nameText:SetText(status .. (link or L["LOADING"]))
            GearAnalyzer:ApplyStyle(row.nameText)
            
            row.itemLink = link

            local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
            row:SetHeight(iconSize + 8)
            row.icon:SetSize(iconSize, iconSize)

            rowIndex = rowIndex + 1
            yLeft = yLeft - (iconSize + 12)
        end
        yLeft = yLeft - 10
    end

    -- Renderizar Izquierda (Recomendados)
    local class = GearAnalyzer:GetClassToken(ignoreForced)
    local recGlyphs = GearAnalyzer.ClassData[class] and GearAnalyzer.ClassData[class].Glyphs and GearAnalyzer.ClassData[class].Glyphs[spec]
    if recGlyphs then
        CreateSection(L["MAJOR_GLYPHS"], recGlyphs.major or {})
        CreateSection(L["MINOR_GLYPHS"], recGlyphs.minor or {})
    end
    self.contentLeft:SetHeight(math.abs(yLeft) + 20)

    -- Renderizar Derecha (Equipados)
    local yRight = -10
    local equippedIndex = 1
    local headerIndexRight = 1

    local function CreateEquippedSection(title, list, color)
        if #list == 0 then return end
        
        local h = self.rightList.headers[headerIndexRight]
        if not h then
            h = self.rightList:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            self.rightList.headers[headerIndexRight] = h
        end
        h:SetPoint("TOPLEFT", 10, yRight)
        h:SetText(color .. title .. "|r")
        h:Show()
        headerIndexRight = headerIndexRight + 1
        yRight = yRight - 20
        
        for _, g in ipairs(list) do
            local row = self:GetOrCreateEquippedRow(equippedIndex)
            row:SetPoint("TOPLEFT", 5, yRight)
            row:Show()
            
            local name = GetSpellInfo(g.id) or "Glifo"
            row.icon:SetTexture(g.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
            row.nameText:SetText(name)
            
            equippedIndex = equippedIndex + 1
            yRight = yRight - 34
        end
        yRight = yRight - 10
    end

    CreateEquippedSection(L["MAJOR_GLYPHS"], activeMajor, "|cffffd100")
    CreateEquippedSection(L["MINOR_GLYPHS"], activeMinor, "|cff00ff00")
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] and self.rows[i].SetSize then return self.rows[i] end
    local row = CreateFrame("Frame", nil, self.contentLeft)
    row:SetSize(400, 42)
    
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.03)

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(32, 32)
    icon:SetPoint("LEFT", 5, 0)
    row.icon = icon

    local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    nameText:SetPoint("LEFT", icon, "RIGHT", 10, 0)
    nameText:SetWidth(280)
    nameText:SetJustifyH("LEFT")
    row.nameText = nameText

    local countText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    countText:SetPoint("RIGHT", row, "RIGHT", -5, 0)
    row.countText = countText

    local btn = CreateFrame("Button", nil, row)
    btn:SetAllPoints()
    btn:SetScript("OnEnter", function()
        if row.itemLink then
            GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(row.itemLink)
            GameTooltip:Show()
        end
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    btn:SetScript("OnClick", function() if row.itemLink then HandleModifiedItemClick(row.itemLink) end end)

    self.rows[i] = row
    return row
end
function Tab:GetOrCreateEquippedRow(i)
    if self.equippedRows[i] then return self.equippedRows[i] end
    local row = CreateFrame("Frame", nil, self.rightList)
    row:SetSize(300, 38)
    
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.03)

    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(28, 28)
    icon:SetPoint("LEFT", 5, 0)
    row.icon = icon

    local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    nameText:SetPoint("LEFT", icon, "RIGHT", 10, 0)
    row.nameText = nameText

    self.equippedRows[i] = row
    return row
end

function Tab:GetOrCreateText(i)
    if self.rows[i] and self.rows[i].SetText then return self.rows[i] end
    local txt = self.contentLeft:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.rows[i] = txt
    return txt
end


