-- =========================
-- GearAnalyzer Tab: Encantamientos
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabEncantamientos")

function Tab:Update(page, ignoreForced)
    if page then
        self.page = page
    else
        page = self.page
    end
    GearAnalyzer:AnalyzeEquipment(ignoreForced)
    if not page then return end

    local spec     = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local classLoc = GearAnalyzer:GetLocalizedClassName(ignoreForced)
    local classTag = GearAnalyzer:GetClassToken(ignoreForced)
    local specLabel = GearAnalyzer:GetSpecLabel(spec)

    -- Creación única (PJ window - una sola instancia)
    if not self.scroll then
        local title = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -10)
        GearAnalyzer:ApplyStyle(title, true)
        self.titleString = title

        local scroll = CreateFrame("ScrollFrame", "GAEnchantsScrollPJ", page, "UIPanelScrollFrameTemplate")
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
    for _, r in ipairs(self.rows) do r:Hide() end

    local class      = GearAnalyzer:GetClassToken(ignoreForced)
    local activeSpec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local normSpec   = GearAnalyzer:NormalizeSpecName(activeSpec)
    local classData  = GearAnalyzer.ClassData[class:upper()]
    local specEnchants = classData and classData.Enchants and classData.Enchants[normSpec]

    if not specEnchants then
        if not self.errorMsg then
            self.errorMsg = self.content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.errorMsg:SetPoint("CENTER", 0, 0)
        end
        self.errorMsg:SetText("|cffffb300" .. L["NO_ENCHANT_GUIDE_FOUND"] .. "|r\n|cffffffff" .. class .. "_" .. (activeSpec or "?") .. "|r")
        self.errorMsg:Show()
        return
    elseif self.errorMsg then
        self.errorMsg:Hide()
    end

    local SLOT_LIST = {
        { id = "head", name = L["SLOT_HEAD"] },
        { id = "shoulders", name = L["SLOT_SHOULDERS"] },
        { id = "back", name = L["SLOT_BACK"] },
        { id = "chest", name = L["SLOT_CHEST"] },
        { id = "wrists", name = L["SLOT_WRISTS"] },
        { id = "hands", name = L["SLOT_HANDS"] },
        { id = "legs", name = L["SLOT_LEGS"] },
        { id = "feet", name = L["SLOT_FEET"] },
        { id = "waist", name = L["SLOT_WAIST"] },
        { id = "weapon", name = L["SLOT_WEAPON"] },
        { id = "offhand", name = L["SLOT_OFFHAND"] },
        { id = "ranged", name = L["SLOT_RANGED"] },
    }

    -- Usar el EnchantMapping desde la base de datos
    local EnchantMapping = GearAnalyzer.EnchantMapping

    -- Asegurar que el análisis esté fresco (usando el mismo contexto)
    -- El escaneo ya se hizo en AnalyzeEquipment


    local y = -5
    local i = 1
    for _, slotInfo in ipairs(SLOT_LIST) do
        local rawEnchantID = specEnchants[slotInfo.id]
        
        -- Si es una categoría extra (Runas/Inscripcion), buscamos el primer valor escaneado para esa profesión para mostrar algo
        if slotInfo.isExtra then
            local profKey = slotInfo.id:upper()
            local data = GearAnalyzer.db.global.ServerDatabase and GearAnalyzer.db.global.ServerDatabase.enchantMappings
            if data then
                for id, info in pairs(data) do
                    if info.prof == profKey then
                        rawEnchantID = id
                        break
                    end
                end
            end
        end

        local isValue = false
        if type(rawEnchantID) == "table" then
            if #rawEnchantID > 0 and (tonumber(rawEnchantID[1]) or 0) > 0 then isValue = true end
        elseif type(rawEnchantID) == "number" and rawEnchantID > 0 then
            isValue = true
        end

        local enchantIDs = {}
        if type(rawEnchantID) == "table" then
            enchantIDs = rawEnchantID
        elseif type(rawEnchantID) == "number" and rawEnchantID > 0 then
            enchantIDs = { rawEnchantID }
        end

        for _, displayID in ipairs(enchantIDs) do
            local map = GearAnalyzer:GetEnchantData(displayID)
            local serverID = GearAnalyzer:GetEffectiveEnchantID(displayID, slotInfo.id)
            
            local enchant = {
                id = serverID,        -- ID efectivo para el servidor
                masterID = displayID, -- ID original de la guía
                name = map and map.name or "Encantamiento",
                stats = map and map.stats or "",
                origin = map and map.origin or "",
                spellID = map and map.spell,
                itemID = map and map.item,
                type = map and map.type or "Varios"
            }

            -- Detección de lo que el jugador tiene puesto actualmente
            local currentID = 0
            if GearAnalyzer.scannedEquipment then
                for _, d in ipairs(GearAnalyzer.scannedEquipment) do
                    if GearAnalyzer:GetSlotKey(d.slotName, d.slotID) == slotInfo.id then
                        currentID = tonumber(d.enchant) or 0
                        break
                    end
                end
            end

            -- MODO DEVELOPER: Aplicar Overrides
            local isDev = GearAnalyzer.charDB and GearAnalyzer.charDB.settings and GearAnalyzer.charDB.settings.devMode
            local overrideKey = (normSpec or "NONE") .. "_" .. slotInfo.id
            
            if GearAnalyzer.db.global.customOverrides and GearAnalyzer.db.global.customOverrides.enchants then
                local overrides = GearAnalyzer.db.global.customOverrides.enchants
                local overrideID = overrides[overrideKey]
                if overrideID then
                    enchant.id = overrideID
                    local map = GearAnalyzer:GetEnchantData(overrideID)
                    if map then
                        enchant.name = "|cff3fc7eb(Act.)|r " .. (map.name or enchant.name)
                        enchant.stats = map.stats or enchant.stats
                        enchant.origin = map.origin or enchant.origin
                        enchant.spellID = map.spell or enchant.spellID
                        enchant.itemID = map.item or enchant.itemID
                    end
                end
                
                enchant.manualIconID = overrides[overrideKey .. "_icon"]
                enchant.manualSpellID = overrides[overrideKey .. "_spell"]
            end

            local row = self:GetOrCreateRow(i)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 0, y)
            row:Show()
            
            -- LÓGICA DE DATOS (IDs para tooltips y links)
            row.enchantID = enchant.manualSpellID or enchant.spellID or enchant.itemID or enchant.id
            row.enchantName = enchant.name
            
            -- DETERMINAR NOMBRE PARA MOSTRAR
            local displayName = GearAnalyzer:LocalizeText(enchant.name)
            local statsText = GearAnalyzer:LocalizeText(enchant.stats or "")
            local originText = (enchant.origin ~= "") and (" |cffaaaaaa[" .. GearAnalyzer:LocalizeText(enchant.origin) .. "]|r") or ""
            row.slotText:SetText("|cffffff00" .. slotInfo.name .. ":|r " .. displayName .. (statsText ~= "" and " |cff00ff00(" .. statsText .. ")|r" or "") .. originText)
            GearAnalyzer:ApplyStyle(row.slotText)
            
            local idComparison = string.format("|cff3fc7eb%s|r / |cffffffff%s|r", 
                (tonumber(enchant.id) and enchant.id > 0 and enchant.id or "---"), 
                (currentID > 0 and currentID or "---"))
            
            local devInfo = ""
            if isDev then
                local mID = type(enchant.masterID) == "table" and enchant.masterID[1] or enchant.masterID
                devInfo = string.format(" |cff888888(Guía: %s)|r", tostring(mID))
            end

            row.srcText:SetText("|cffaaaaaaIDs (Server/Eq):|r " .. idComparison .. devInfo)
            GearAnalyzer:ApplyStyle(row.srcText)

            -- DETERMINAR ICONO
            local iconTex = nil
            if enchant.manualIconID and enchant.manualIconID > 0 then
                iconTex = GetItemIcon(enchant.manualIconID) or select(3, GetSpellInfo(enchant.manualIconID))
            end
            if not iconTex then
                if enchant.itemID then iconTex = GetItemIcon(enchant.itemID) end
                if not iconTex and enchant.spellID then iconTex = select(3, GetSpellInfo(enchant.spellID)) end
                if not iconTex then iconTex = GetItemIcon(enchant.id) or select(3, GetSpellInfo(enchant.id)) end
            end
            row.icon:SetTexture(iconTex or "Interface\\Icons\\INV_Misc_QuestionMark")
            
            -- Verificación de estado (¿Lo tiene puesto?)
            local statusIcon = "Interface\\RAIDFRAME\\ReadyCheck-NotReady" -- Cruz roja por defecto
            local statusColor = {1, 0, 0} -- Rojo
            
            -- Buscar este slot en los datos escaneados
            local scanSlot = slotInfo.id
            if scanSlot == "weapon" then scanSlot = "Mano principal"
            elseif scanSlot == "offhand" then scanSlot = "Mano secundaria"
            elseif scanSlot == "head" then scanSlot = "Cabeza"
            elseif scanSlot == "shoulders" then scanSlot = "Hombros"
            elseif scanSlot == "back" then scanSlot = "Espalda"
            elseif scanSlot == "chest" then scanSlot = "Pecho"
            elseif scanSlot == "wrists" then scanSlot = "Muñecas"
            elseif scanSlot == "hands" then scanSlot = "Manos"
            elseif scanSlot == "legs" then scanSlot = "Piernas"
            elseif scanSlot == "feet" then scanSlot = "Pies"
            elseif scanSlot == "waist" then scanSlot = "Cintura"
            end

            local statusKey = (ignoreForced and "" or "guide_") .. "enchStatus"
            for _, d in ipairs(GearAnalyzer.scannedEquipment or {}) do
                local dataSlotKey = GearAnalyzer:GetSlotKey(d.slotName, d.slotID)
                if dataSlotKey == slotInfo.id then
                    local status = d[statusKey]
                    if status == 2 then
                        statusIcon = "Interface\\Buttons\\UI-CheckBox-Check"
                        statusColor = {0, 1, 0}
                    elseif status == 3 then
                        statusIcon = "Interface\\Buttons\\UI-CheckBox-Check"
                        statusColor = {1, 0.65, 0} -- Naranja (Profesión)
                    elseif status == 1 then
                        statusIcon = "Interface\\RAIDFRAME\\ReadyCheck-Waiting"
                        statusColor = {1, 1, 0}
                    end
                    break
                end
            end

            row.statusIcon:SetTexture(statusIcon)
            row.statusIcon:SetVertexColor(unpack(statusColor))
            
            -- LÓGICA MODO DEVELOPER (EDITAR IDs)
            if not row.devEditID then
                -- EditBox 1: Server/Recommendation ID (Blue)
                local edID = CreateFrame("EditBox", nil, row)
                edID:SetSize(40, 18)
                edID:SetPoint("LEFT", 5, 0)
                edID:SetAutoFocus(false)
                edID:SetFontObject("GameFontHighlightSmall")
                edID:SetJustifyH("CENTER")
                edID:EnableMouse(true)
                edID:SetMaxLetters(6)
                local bgt1 = edID:CreateTexture(nil, "BACKGROUND")
                bgt1:SetAllPoints(); bgt1:SetTexture(0, 0, 0.5, 0.8) -- AZUL
                row.devEditID = edID
                
                -- EditBox 2: Icon ID (Green)
                local edIcon = CreateFrame("EditBox", nil, row)
                edIcon:SetSize(40, 18)
                edIcon:SetPoint("LEFT", edID, "RIGHT", 2, 0)
                edIcon:SetAutoFocus(false)
                edIcon:SetFontObject("GameFontHighlightSmall")
                edIcon:SetJustifyH("CENTER")
                edIcon:EnableMouse(true)
                edIcon:SetMaxLetters(6)
                local bgt2 = edIcon:CreateTexture(nil, "BACKGROUND")
                bgt2:SetAllPoints(); bgt2:SetTexture(0, 0.5, 0, 0.8) -- VERDE
                row.devEditIcon = edIcon

                -- EditBox 3: Spell ID / Tooltip / Link (Gold/Orange)
                local edSpell = CreateFrame("EditBox", nil, row)
                edSpell:SetSize(40, 18)
                edSpell:SetPoint("LEFT", edIcon, "RIGHT", 2, 0)
                edSpell:SetAutoFocus(false)
                edSpell:SetFontObject("GameFontHighlightSmall")
                edSpell:SetJustifyH("CENTER")
                edSpell:EnableMouse(true)
                edSpell:SetMaxLetters(6)
                local bgt3 = edSpell:CreateTexture(nil, "BACKGROUND")
                bgt3:SetAllPoints(); bgt3:SetTexture(0.5, 0.3, 0, 0.8) -- DORADO
                row.devEditSpell = edSpell

                local reset = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                reset:SetSize(16, 16)
                reset:SetPoint("LEFT", edSpell, "RIGHT", 3, 0)
                reset:SetText("R")
                row.devReset = reset
                
                -- Tooltips claros (Azul, Verde, Dorado)
                edID:SetScript("OnEnter", function(s) GameTooltip:SetOwner(s, "ANCHOR_TOP"); GameTooltip:SetText("|cff3fc7ebID Servidor (AZUL)|r\nEl ID que el addon busca para dar el OK."); GameTooltip:Show() end)
                edID:SetScript("OnLeave", function() GameTooltip:Hide() end)
                edIcon:SetScript("OnEnter", function(s) GameTooltip:SetOwner(s, "ANCHOR_TOP"); GameTooltip:SetText("|cff00ff00ID Icono (VERDE)|r\nID para el dibujo del icono."); GameTooltip:Show() end)
                edIcon:SetScript("OnLeave", function() GameTooltip:Hide() end)
                edSpell:SetScript("OnEnter", function(s) GameTooltip:SetOwner(s, "ANCHOR_TOP"); GameTooltip:SetText("|cffffd100ID Spell (DORADO)|r\nID para Tooltips y Links."); GameTooltip:Show() end)
                edSpell:SetScript("OnLeave", function() GameTooltip:Hide() end)
            end

            -- LIMPIAR POSICIONES PARA EVITAR SOLAPS
            row.icon:ClearAllPoints()
            
            local isDev = GearAnalyzer.charDB and GearAnalyzer.charDB.settings and GearAnalyzer.charDB.settings.devMode
            
            if isDev then
                -- Modo Dev: Icono a la derecha de los editbox, mostrar IDs técnicos
                row.icon:SetPoint("LEFT", 145, 0) 
                
                local fontSize = GearAnalyzer.db.profile.settings.fontSize or 12
                local vOffset = math.max(8, fontSize * 0.7)
                
                row.slotText:ClearAllPoints()
                row.slotText:SetPoint("LEFT", row.icon, "RIGHT", 10, vOffset)
                row.slotText:SetJustifyH("LEFT")
                row.slotText:SetWidth(450) -- Aumentamos el ancho para evitar saltos de línea innecesarios
                
                row.srcText:ClearAllPoints()
                row.srcText:SetPoint("LEFT", row.icon, "RIGHT", 10, -vOffset)
                row.srcText:SetJustifyH("LEFT")
                row.srcText:SetWidth(450)
                row.srcText:Show()

                -- Mostrar EditBoxes
                row.devEditID:Show()
                row.devEditIcon:Show()
                row.devEditSpell:Show()
                row.devReset:Show()
                
                -- Permitir interacción en toda la fila en modo normal, pero proteger EditBoxes en modo Dev
                row:SetHitRectInsets(145, 0, 0, 0)
                
                -- Lógica de edición (esto ya estaba pero lo agrupamos aquí)
                local overrideKey = (normSpec or "NONE") .. "_" .. slotInfo.id
                local overrides = GearAnalyzer.db.global.customOverrides.enchants
                local currentCheckID = overrides[overrideKey] or enchant.id or 0
                local currentIconID  = overrides[overrideKey .. "_icon"] or enchant.itemID or 0
                local currentSpellID = overrides[overrideKey .. "_spell"] or enchant.spellID or 0
                
                if not row.devEditID:HasFocus() then row.devEditID:SetText(tostring(currentCheckID)) end
                if not row.devEditIcon:HasFocus() then row.devEditIcon:SetText(tostring(currentIconID)) end
                if not row.devEditSpell:HasFocus() then row.devEditSpell:SetText(tostring(currentSpellID)) end
                
                row.devEditID:SetScript("OnEnterPressed", function(s) local val = tonumber(s:GetText()); if val then GearAnalyzer.db.global.customOverrides.enchants[overrideKey] = val; GearAnalyzer:FullReload() end; s:ClearFocus() end)
                row.devEditIcon:SetScript("OnEnterPressed", function(s) local val = tonumber(s:GetText()); if val then GearAnalyzer.db.global.customOverrides.enchants[overrideKey .. "_icon"] = val; GearAnalyzer:FullReload() end; s:ClearFocus() end)
                row.devEditSpell:SetScript("OnEnterPressed", function(s) local val = tonumber(s:GetText()); if val then GearAnalyzer.db.global.customOverrides.enchants[overrideKey .. "_spell"] = val; GearAnalyzer:FullReload() end; s:ClearFocus() end)
                
                row.devEditID:SetScript("OnEscapePressed", function(s) s:SetText(tostring(currentCheckID)); s:ClearFocus() end)
                row.devEditIcon:SetScript("OnEscapePressed", function(s) s:SetText(tostring(currentIconID)); s:ClearFocus() end)
                row.devEditSpell:SetScript("OnEscapePressed", function(s) s:SetText(tostring(currentSpellID)); s:ClearFocus() end)

                row.devReset:SetScript("OnClick", function()
                    local overrides = GearAnalyzer.db.global.customOverrides.enchants
                    overrides[overrideKey] = nil
                    overrides[overrideKey .. "_icon"] = nil
                    overrides[overrideKey .. "_spell"] = nil
                    GearAnalyzer:FullReload()
                end)

                -- Asegurar que al ocultar la fila se pierda el foco
                row:SetScript("OnHide", function()
                    if row.devEditID then row.devEditID:ClearFocus() end
                    if row.devEditIcon then row.devEditIcon:ClearFocus() end
                    if row.devEditSpell then row.devEditSpell:ClearFocus() end
                end)
            else
                -- Modo Normal: Icono a la izquierda, ocultar IDs técnicos
                row.icon:SetPoint("LEFT", 10, 0)
                
                row.slotText:ClearAllPoints()
                row.slotText:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
                row.slotText:SetJustifyH("LEFT")
                row.slotText:SetWidth(610)
                
                row.srcText:Hide()
                
                row.devEditID:Hide()
                row.devEditIcon:Hide()
                row.devEditSpell:Hide()
                row.devReset:Hide()

                row:SetHitRectInsets(0, 0, 0, 0)
            end

            -- AJUSTAR TAMAÑO DE ICONO Y FILA DINÁMICAMENTE
            local fontSize = GearAnalyzer.db.profile.settings.fontSize or 12
            local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
            local rowHeight = math.max(iconSize + 10, fontSize * 2.5 + 10)
            
            row:SetHeight(rowHeight)
            row.icon:SetSize(iconSize, iconSize)
            row.statusIcon:SetSize(iconSize * 0.75, iconSize * 0.75)

            y = y - (rowHeight + 4)
            i = i + 1
        end
    end

    -- Leyenda
    if not self.legend then
        local legend = CreateFrame("Frame", nil, self.content)
        legend:SetSize(self.content:GetWidth(), 40)
        
        local text = legend:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        text:SetPoint("TOPLEFT", 10, 0)
        text:SetJustifyH("LEFT")
        text:SetText(L["ENCHANT_LEGEND_TEXT"])
        self.legend = legend
    end
    self.legend:SetPoint("TOPLEFT", 0, y - 10)
    self.legend:Show()

    self.content:SetHeight(math.abs(y) + 20)
end

function Tab:GetOrCreateRow(i)
    if self.rows[i] then return self.rows[i] end
    
    local row = CreateFrame("Frame", nil, self.content)
    row:SetSize(self.content:GetWidth(), 42)
    
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.03)
    
    row:EnableMouse(true)
    -- El HitRect se ajusta dinámicamente en Update() según el modo

    -- Icono
    local icon = row:CreateTexture(nil, "OVERLAY")
    icon:SetSize(32, 32)
    icon:SetPoint("LEFT", 5, 0)
    row.icon = icon

    local slotText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    slotText:SetPoint("LEFT", icon, "RIGHT", 10, 6)
    slotText:SetJustifyH("LEFT")
    slotText:SetWidth(380)
    row.slotText = slotText

    local srcText = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    srcText:SetPoint("LEFT", icon, "RIGHT", 10, -9)
    srcText:SetJustifyH("LEFT")
    srcText:SetWidth(380)
    row.srcText = srcText

    -- Icono de estado (Check/X)
    local statusIcon = row:CreateTexture(nil, "OVERLAY")
    statusIcon:SetPoint("RIGHT", row, "RIGHT", -10, 0)
    statusIcon:SetSize(24, 24)
    row.statusIcon = statusIcon

    -- Tooltip logic (WotLK 3.3.5 Compatibility)
    row:SetScript("OnEnter", function(self)
        if self.enchantID and self.enchantID > 0 then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            
            local displayID = self.enchantID
            local spellName = GetSpellInfo(displayID)
            local itemName = GetItemInfo(displayID)
            local isDev = GearAnalyzer.charDB and GearAnalyzer.charDB.settings and GearAnalyzer.charDB.settings.devMode
            
            if spellName then
                GameTooltip:SetHyperlink("spell:" .. displayID)
            elseif itemName then
                GameTooltip:SetHyperlink("item:" .. displayID)
            else
                GameTooltip:SetText(self.enchantName or "Encantamiento", 1, 1, 1)
            end

            if isDev then
                GameTooltip:AddLine("ID: " .. displayID, 0.5, 0.5, 1)
            end
            
            GameTooltip:Show()
        end
    end)
    row:SetScript("OnLeave", function() GameTooltip:Hide() end)
    
    -- Shift+Click para linkear en chat
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
            
            -- Insertar link o nombre en el chat activo
            local activeChat = ChatEdit_GetActiveWindow()
            if link then
                if activeChat then activeChat:Insert(link) else ChatFrame_OpenChat(link) end
            else
                local text = "[" .. (self.enchantName or "Encantamiento") .. "]"
                if activeChat then activeChat:Insert(text) else ChatFrame_OpenChat(text) end
            end
        end
    end)


    self.rows[i] = row
    return row
end
