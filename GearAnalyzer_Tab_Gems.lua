-- =========================
-- GearAnalyzer Tab: Gemas
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabGemas")

function Tab:Update(page, ignoreForced)
    if page then
        self.page = page
    else
        page = self.page
    end
    GearAnalyzer:AnalyzeEquipment(ignoreForced)
    if not page then return end

    local class    = GearAnalyzer:GetClassToken(ignoreForced)
    local activeSpec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local spec     = GearAnalyzer:NormalizeSpecName(activeSpec)
    local classLoc = GearAnalyzer:GetLocalizedClassName(ignoreForced)
    local specLabel = GearAnalyzer:GetSpecLabel(spec)

    -- Creación única (PJ window - una sola instancia)
    if not self.scroll then
        local title = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -10)
        GearAnalyzer:ApplyStyle(title, true)
        self.titleString = title

        local scroll = CreateFrame("ScrollFrame", "GAGemsScrollPJ", page, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -9, 10)
        self.scroll = scroll

        local f = CreateFrame("Frame", nil, scroll)
        local w = scroll:GetWidth()
        if not w or w <= 0 then w = 725 end
        f:SetSize(w, 500)
        scroll:SetScrollChild(f)
        self.container = f

        local help = CreateFrame("Frame", nil, f)
        help:SetSize(400, 100)
        self.helpFrame = help
        
        local hText = help:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        hText:SetPoint("TOPLEFT", 0, 0)
        hText:SetJustifyH("LEFT")
        hText:SetWidth(400)
        self.helpText = hText

        self.rows = {}
        self.equippedRows = {}
    end

    self.titleString:SetText(L["RECOMMENDED_GEMS"] .. " - " .. classLoc .. " " .. specLabel)

    local classData = GearAnalyzer.ClassData[class]
    local specData  = classData and classData.Gems and classData.Gems[spec]
    local capsData  = classData and classData.Caps and classData.Caps[spec]

    local helpMsg = L["GEM_PRIORITY_HINT"]
    -- Priorizar la nota dinámica (FASE INICIAL / FASE FINAL) si existe
    local dynamicGemsForNote = GearAnalyzer:GetDynamicGems(class, spec)
    if dynamicGemsForNote and dynamicGemsForNote.note then
        local phase = dynamicGemsForNote.note
        local localizedPhase = L[phase] or phase
        -- Colorear la fase: FASE FINAL en dorado, FASE INICIAL en verde
        local phaseColor = (phase:find("FINAL") or localizedPhase:find("FASE FINAL") or localizedPhase:find("FINAL PHASE")) and "|cffffd100" or "|cff00ff00"
        helpMsg = phaseColor .. L["GUIDE_LABEL"] .. "|r " .. localizedPhase
    elseif specData and specData.note then
        helpMsg = "|cff00ff00" .. L["GUIDE_LABEL"] .. "|r " .. GearAnalyzer:LocalizeText(specData.note)
    end
    if capsData and capsData.priorities then
        local prioStr = "\n|cffffd100" .. L["PRIORITY_LABEL"] .. "|r "
        for i, p in ipairs(capsData.priorities) do
            local localizedLabel = rawget(L, p.label) or p.label
            prioStr = prioStr .. localizedLabel .. (i < #capsData.priorities and " > " or "")
        end
        helpMsg = helpMsg .. prioStr
    end
    self.helpText:SetText(helpMsg)
    GearAnalyzer:ApplyStyle(self.helpText)

    -- Render
    for _, r in ipairs(self.rows) do r:Hide() end

    local gemList = {
        { type = L["GEM_META"], id = 0, color = "|cffffffff" },
        { type = L["GEM_RED"], id = 0, color = "|cffff0000" },
        { type = L["GEM_YELLOW"], id = 0, color = "|cffffff00" },
        { type = L["GEM_BLUE"], id = 0, color = "|cff0000ff" },
    }

    local dynamicGems = GearAnalyzer:GetDynamicGems(class, spec)

    if dynamicGems then
        gemList[1].id = dynamicGems.meta or 0
        gemList[1].reason = dynamicGems.metaReason
        
        gemList[2].id = dynamicGems.red or 0
        gemList[2].reason = dynamicGems.redReason or dynamicGems.redOK
        
        gemList[3].id = dynamicGems.yellow or 0
        gemList[3].reason = dynamicGems.yellowReason or dynamicGems.yellowOK
        
        gemList[4].id = dynamicGems.blue or 0
        gemList[4].reason = dynamicGems.blueReason or dynamicGems.blueOK
        
        -- Si hay gema de joyería, la insertamos como especial
        if dynamicGems.redJC then
            table.insert(gemList, 2, { 
                type = L["PROFESSION_ONLY"], 
                id = dynamicGems.redJC, 
                color = "|cffff00ff", 
                reason = dynamicGems.redJCReason 
            })
        end

        self.capsStatus = dynamicGems.capsStatus
    else
        gemList[1].id = 0; gemList[2].id = 0; gemList[3].id = 0; gemList[4].id = 0
        self.capsStatus = nil
    end

    local y = -35
    for i, gData in ipairs(gemList) do
        local row = self:GetOrCreateRow(i)
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", 10, y)
        row:Show()
        
        -- APLICAR OVERRIDES PERSONALIZADOS
        local overrideKey = gData.type:lower() -- "meta", "roja", etc.
        local globalOverrides = GearAnalyzer.db.global.customOverrides
        local class = GearAnalyzer:GetClassToken(ignoreForced)
        local currentID = globalOverrides.gems[class .. "_" .. spec .. "_" .. overrideKey] or gData.id
        gData.id = currentID

        local name, link, quality, _, _, _, _, _, _, texture = GetItemInfo(gData.id)
        if not name and GearAnalyzer.scanner then
            GearAnalyzer.scanner:SetHyperlink("item:" .. gData.id)
            name, link, quality, _, _, _, _, _, _, texture = GetItemInfo(gData.id)
        end

        row.icon:SetTexture(texture or GetItemIcon(gData.id))
        
        local isDev = GearAnalyzer.charDB and GearAnalyzer.charDB.settings and GearAnalyzer.charDB.settings.devMode
        local reasonText = gData.reason or ""
        row.typeText:SetText(gData.color .. gData.type .. ":|r " .. reasonText)
        GearAnalyzer:ApplyStyle(row.typeText)
        
        local idText = (isDev and gData.id > 0) and (" [ID:" .. gData.id .. "]") or ""
        row.nameText:SetText((link or ("Cargando...")) .. idText)
        GearAnalyzer:ApplyStyle(row.nameText)

        -- Conteo
        local inBags = GetItemCount(gData.id)
        local total = GetItemCount(gData.id, true)
        local inBank = total - inBags

        local cCol = (inBags > 0) and "|cff00ff00" or "|cffff0000"
        row.countText:SetText(L["BAGS"] .. ": " .. cCol .. inBags .. "|r  (" .. L["BANK"] .. ": " .. inBank .. ")")
        GearAnalyzer:ApplyStyle(row.countText)
        
        row.id = gData.id
        row.name = name
        row.link = link

        -- LÓGICA MODO DEVELOPER
        local isDev = GearAnalyzer.charDB and GearAnalyzer.charDB.settings and GearAnalyzer.charDB.settings.devMode
        if isDev then
            if not row.devEdit then
                -- Crear EditBox puro para evitar bloques negros
                local edit = CreateFrame("EditBox", nil, row)
                edit:SetSize(70, 20)
                edit:SetPoint("LEFT", 5, 0)
                edit:SetAutoFocus(false)
                edit:SetFontObject("GameFontHighlightSmall")
                edit:SetJustifyH("CENTER")
                edit:EnableMouse(true)
                row.devEdit = edit
                edit:SetFrameLevel(45)
                
                -- Fondo sólido manual
                local bgt = edit:CreateTexture(nil, "BACKGROUND")
                bgt:SetAllPoints()
                bgt:SetTexture(0, 0, 0.4, 0.8) -- Azul oscuro
                edit.bgt = bgt
                
                local reset = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                reset:SetSize(20, 20)
                reset:SetPoint("LEFT", edit, "RIGHT", 5, 0)
                reset:SetText("R")
                row.devReset = reset
                reset:SetFrameLevel(45)
            end

            -- REAJUSTAR ELEMENTOS PARA DAR ESPACIO (Evita solapamientos)
            row.icon:ClearAllPoints()
            row.icon:SetPoint("LEFT", 110, 0)
            
            row.typeText:ClearAllPoints()
            row.typeText:SetPoint("LEFT", row.icon, "RIGHT", 12, 10)
            
            row.nameText:ClearAllPoints()
            row.nameText:SetPoint("LEFT", row.icon, "RIGHT", 12, -10)
            
            -- Bloquear clics de la fila en la zona del EditBox
            row:SetHitRectInsets(100, 0, 0, 0)

            -- Forzar texto inicial
            if not row.devEdit:HasFocus() then
                row.devEdit:SetText(tostring(gData.id))
            end

            row.devEdit:SetScript("OnEnterPressed", function(self)
                local newID = tonumber(self:GetText())
                if newID then
                    local class = GearAnalyzer:GetClassToken()
                    GearAnalyzer.db.global.customOverrides.gems[class .. "_" .. spec .. "_" .. overrideKey] = newID
                    GearAnalyzer:FullReload()
                end
                self:ClearFocus()
            end)

            row.devEdit:SetScript("OnEscapePressed", function(self)
                self:SetText(tostring(gData.id))
                self:ClearFocus()
            end)
            
            row.devReset:SetScript("OnClick", function()
                local class = GearAnalyzer:GetClassToken()
                GearAnalyzer.db.global.customOverrides.gems[class .. "_" .. spec .. "_" .. overrideKey] = nil
                GearAnalyzer:FullReload()
            end)

            -- Asegurar que al ocultar la fila se pierda el foco
            row:SetScript("OnHide", function()
                if row.devEdit then row.devEdit:ClearFocus() end
            end)

            row.devEdit:Show()
            row.devReset:Show()
        elseif row.devEdit then
            row.devEdit:Hide()
            row.devReset:Hide()
            
            -- Restaurar posiciones originales si no es Dev
            row.icon:ClearAllPoints()
            row.icon:SetPoint("LEFT", 10, 0)
            row.typeText:ClearAllPoints()
            row.typeText:SetPoint("LEFT", row.icon, "RIGHT", 12, 10)
            row.nameText:ClearAllPoints()
            row.nameText:SetPoint("LEFT", row.icon, "RIGHT", 12, -10)
            row:SetHitRectInsets(0, 0, 0, 0)
        end
        
        -- AJUSTAR TAMAÑO DINÁMICO
        local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
        row:SetHeight(iconSize + 20)
        row.icon:SetSize(iconSize, iconSize)
        
        y = y - (iconSize + 24)
    end

    -- Resumen de Caps revisados para gemas
    if self.capsStatus and #self.capsStatus > 0 then
        if not self.capsSummary then
            local f = CreateFrame("Frame", nil, self.container)
            f:SetSize(300, 30)
            self.capsSummary = f
            self.capsText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            self.capsText:SetPoint("LEFT")
        end
        
        local summary = "|cffffd100" .. L["CAPS_STATUS"] .. ":|r "
        for _, cap in ipairs(self.capsStatus) do
            local color = cap.over and "|cffffa500" or (cap.met and "|cff00ff00" or "|cffff0000")
            local status = cap.over and L["EXCESS"] or (cap.met and "OK" or L["MISSING_LABEL"])
            summary = summary .. GearAnalyzer:LocalizeText(cap.label) .. " [" .. color .. status .. "|r]  "
        end
        self.capsText:SetText(summary)
        self.capsSummary:ClearAllPoints()
        self.capsSummary:SetPoint("TOPLEFT", 10, y - 5)
        self.capsSummary:Show()
        y = y - 30
    elseif self.capsSummary then
        self.capsSummary:Hide()
    end

    -- 3. RESUMEN DE GEMAS FALTANTES/A CAMBIAR (Solicitado por el usuario)
    if GearAnalyzer.gemSummary_PJ then
        if not self.missingSummaryFrame then
            local f = CreateFrame("Frame", nil, self.container)
            f:SetSize(400, 200)
            self.missingSummaryFrame = f
            
            local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            title:SetPoint("TOPLEFT", 0, 0)
            title:SetText("|cffffd100" .. L["MISSING_GEMS_TITLE"] .. "|r")
            self.missingSummaryTitle = title
            
            local content = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            content:SetPoint("TOPLEFT", 0, -20)
            content:SetJustifyH("LEFT")
            content:SetWidth(380)
            self.missingSummaryContent = content
        end
        
        local summary = ""
        
        -- Vacías
        if #GearAnalyzer.gemSummary_PJ.missing > 0 then
            summary = summary .. "|cffff0000" .. string.format(L["MISSING_GEMS_COUNT"], #GearAnalyzer.gemSummary_PJ.missing) .. "|r\n"
            for _, entry in ipairs(GearAnalyzer.gemSummary_PJ.missing) do
                summary = summary .. " - |cffffd100" .. (L[entry.slot] or entry.slot or "Slot") .. ":|r " .. (entry.recommended or "?") .. "\n"
            end
        end
        
        -- A cambiar
        if #GearAnalyzer.gemSummary_PJ.toChange > 0 then
            summary = summary .. "\n|cffffff00" .. string.format(L["CHANGE_GEMS_COUNT"], #GearAnalyzer.gemSummary_PJ.toChange) .. "|r\n"
            for _, entry in ipairs(GearAnalyzer.gemSummary_PJ.toChange) do
                summary = summary .. " - |cffffd100" .. (L[entry.slot] or entry.slot or "Slot") .. ":|r " .. (entry.current or "?") .. " -> |cff00ff00" .. (entry.recommended or "?") .. "|r\n"
            end
        end
        if summary ~= "" then
            summary = summary .. "\n"
        end
        -- [SHOPPING-LIST] Total de gemas necesarias
        local totals = {}
        for _, entry in ipairs(GearAnalyzer.gemSummary_PJ.missing) do
            totals[entry.recommended] = (totals[entry.recommended] or 0) + 1
        end
        for _, entry in ipairs(GearAnalyzer.gemSummary_PJ.toChange) do
            totals[entry.recommended] = (totals[entry.recommended] or 0) + 1
        end
        
        if next(totals) then
            summary = summary .. "|cff00ccff" .. L["TOTAL_TO_SHOP"] .. "|r\n"
            for gemName, count in pairs(totals) do
                summary = summary .. " |cffffffff" .. count .. "x|r " .. gemName .. "\n"
            end
        end

        if summary == "" then
            summary = "|cff00ff00" .. L["ALL_GEMS_CORRECT"] .. "|r"
        end
        
        self.missingSummaryContent:SetText(summary)
        self.missingSummaryFrame:ClearAllPoints()
        self.missingSummaryFrame:SetPoint("TOPLEFT", 10, y - 10)
        self.missingSummaryFrame:Show()
        
        local summaryHeight = self.missingSummaryContent:GetStringHeight()
        self.missingSummaryFrame:SetHeight(summaryHeight + 30)
        y = y - (summaryHeight + 40)
    elseif self.missingSummaryFrame then
        self.missingSummaryFrame:Hide()
    end

    -- 4. LISTADO DE TODAS LAS GEMAS EQUIPADAS (Nuevo)
    if self.container then
        if not self.equippedTitle then
            local t = self.container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            t:SetText("|cffffd100" .. L["YOUR_EQUIPPED_GEMS"] .. "|r")
            self.equippedTitle = t
            self.equippedRows = {}
        end
        self.equippedTitle:SetPoint("TOPLEFT", 10, y - 10)
        self.equippedTitle:Show()
        y = y - 30

        -- Limpiar filas anteriores
        for _, r in ipairs(self.equippedRows) do r:Hide() end

        local rowIndex = 1
        if GearAnalyzer.scannedEquipment then
            for _, d in ipairs(GearAnalyzer.scannedEquipment) do
                if d.socketAnalysis and #d.socketAnalysis > 0 then
                    for _, socket in ipairs(d.socketAnalysis) do
                        local row = self:GetOrCreateEquippedRow(rowIndex)
                        row:ClearAllPoints()
                        row:SetPoint("TOPLEFT", 20, y)
                        row:Show()
                        
                        local colorCode = "|cff777777"
                        if socket.color == "red" then colorCode = "|cffff0000"
                        elseif socket.color == "yellow" then colorCode = "|cffffff00"
                        elseif socket.color == "blue" then colorCode = "|cff0000ff"
                        elseif socket.color == "meta" then colorCode = "|cff00ffff"
                        end

                        local matchIcon
                        local gemDisplayName
                        if socket.currentGID and socket.currentGID > 0 then
                            matchIcon = socket.isMatch and "|cff00ff00[OK]|r" or "|cffff0000[X]|r"
                            gemDisplayName = GearAnalyzer:LocalizeText(socket.currentName)
                            row.link = "item:" .. socket.currentGID
                        else
                            matchIcon = "|cffff0000[" .. L["MISSING_TAG"] .. "]|r"
                            gemDisplayName = "|cff888888(" .. L["EMPTY"] .. ")|r"
                            row.link = nil
                        end

                        row.text:SetText(string.format("%s %s %s: |cffffffff%s|r", 
                            matchIcon, colorCode .. (L[socket.color:upper()] or socket.color:upper()) .. "|r", (L[d.slotName] or d.slotName), gemDisplayName))
                        
                        y = y - 18
                        rowIndex = rowIndex + 1
                    end
                end
            end
        end
        
        if rowIndex == 1 then
            local row = self:GetOrCreateEquippedRow(1)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 20, y)
            row.text:SetText("|cff777777" .. L["NO_GEMS_EQUIPPED"] .. "|r")
            row:Show()
            y = y - 20
        end
    end

    -- 5. GUÍA Y PRIORIDADES (Al final)
    if self.helpText then
        self.helpText:SetText(helpMsg)
        GearAnalyzer:ApplyStyle(self.helpText)
        
        local hHeight = self.helpText:GetStringHeight()
        self.helpFrame:SetHeight(hHeight + 20)
        self.helpFrame:ClearAllPoints()
        self.helpFrame:SetPoint("TOPLEFT", 10, y - 20)
        self.helpFrame:Show()
        y = y - (hHeight + 40)
    end

    -- Ajustar la altura del contenedor para el ScrollFrame
    if self.container then
        self.container:SetHeight(math.abs(y) + 50)
    end
end

function Tab:GetOrCreateEquippedRow(i)
    if self.equippedRows[i] then return self.equippedRows[i] end
    
    local row = CreateFrame("Button", nil, self.container)
    row:SetSize(self.container:GetWidth() - 40, 16)
    
    local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("LEFT", 0, 0)
    row.text = text

    -- Se elmina el Tooltip de gemas equipadas por petición del usuario (evita IDs de encantamiento erróneos)
    row:SetScript("OnEnter", nil)
    row:SetScript("OnLeave", nil)
    row:SetScript("OnClick", function()
        if row.link then HandleModifiedItemClick(row.link) end
    end)

    self.equippedRows[i] = row
    return row
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] then return self.rows[i] end
    
    local row = CreateFrame("Frame", nil, self.container)
    row:SetSize(self.container:GetWidth(), 52)
    
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.03)

    -- El botón ahora cubre toda la fila para facilitar tooltips y el Shift+Click
    local clickBtn = CreateFrame("Button", nil, row)
    clickBtn:SetAllPoints()
    row.clickBtn = clickBtn
    
    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(38, 38)
    icon:SetPoint("LEFT", 10, 0)
    row.icon = icon

    clickBtn:SetScript("OnEnter", function()
        if row.link then
            GameTooltip:SetOwner(clickBtn, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(row.link)
            GameTooltip:Show()
        end
    end)
    clickBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    clickBtn:SetScript("OnClick", function()
        if row.link then
            if AuctionFrame and AuctionFrame:IsShown() then
                BrowseName:SetText(row.name or "")
                AuctionFrameBrowse_Search()
            else
                HandleModifiedItemClick(row.link)
            end
        end
    end)

    local typeText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    typeText:SetPoint("LEFT", icon, "RIGHT", 12, 10)
    row.typeText = typeText

    local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    nameText:SetPoint("LEFT", icon, "RIGHT", 12, -10)
    row.nameText = nameText

    local countText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    countText:SetPoint("RIGHT", row, "RIGHT", -20, 0)
    row.countText = countText

    self.rows[i] = row
    return row
end
