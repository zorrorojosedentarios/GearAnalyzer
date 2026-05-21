-- ============================================================
-- GearAnalyzer Tab: Equipo (Renderizado Gráfico y Sincronizado Premium)
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabEquipo", "AceTimer-3.0")

function Tab:Update(page, ignoreForced)
    if not page then return end
    if ignoreForced == nil then ignoreForced = true end

    -- 1. CREACIÓN ÚNICA DE ELEMENTOS (CONTENEDOR Y SCROLL)
    if not self.container then
        local container = CreateFrame("Frame", nil, page)
        container:SetAllPoints()
        self.container = container

        local scroll = CreateFrame("ScrollFrame", "GAEquipScroll", container, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 5, -5)
        scroll:SetPoint("BOTTOMRIGHT", -25, 5)
        self.scroll = scroll

        local content = CreateFrame("Frame", nil, scroll)
        content:SetSize(1020, 600)
        scroll:SetScrollChild(content)
        self.content = content
        
        self.rows = {}
    end

    local scroll = self.scroll
    local content = self.content

    self.rows = self.rows or {}
    for _, r in ipairs(self.rows) do r:Hide() end
    wipe(self.rows)

    -- Asegurar escaneo fresco e integral
    GearAnalyzer:ScanEquipment(ignoreForced)
    GearAnalyzer:AnalyzeEquipment(ignoreForced, false)

    local data = GearAnalyzer.scannedEquipment
    if not data then return end

    local y = -10

    -- 1. CABECERA
    local header = self:GetOrCreateRow(0, content)
    header:SetPoint("TOPLEFT", 10, y)
    header:SetSize(1010, 24)
    header.bg:Hide()
    header.icon:Hide()
    header.border:Hide()
    
    if not header.hEquip then
        local classLoc = GearAnalyzer:GetLocalizedClassName(ignoreForced)
        local spec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
        local specLabel = GearAnalyzer:GetSpecLabel(spec)
        
        header.hEquip = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        header.hEquip:SetPoint("LEFT", 45, 0)
        header.hEquip:SetText("ANÁLISIS: " .. classLoc .. " " .. specLabel)
        header.hEquip:SetTextColor(1, 0.82, 0)

        header.hMejora = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        header.hMejora:SetPoint("RIGHT", header, "RIGHT", -120, 0)
        header.hMejora:SetText("SIG. MEJORA")
        header.hMejora:SetTextColor(1, 0.82, 0)

        header.hStatus = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        header.hStatus:SetPoint("RIGHT", header, "RIGHT", -15, 0)
        header.hStatus:SetText("ESTADO")
        header.hStatus:SetTextColor(1, 0.82, 0)
    end
    
    local classLoc = GearAnalyzer:GetLocalizedClassName(ignoreForced)
    local curSpec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local specLabel = GearAnalyzer:GetSpecLabel(curSpec)
    header.hEquip:SetText("ANÁLISIS: " .. classLoc .. " " .. specLabel)
    
    header.hEquip:Show()
    header.hMejora:Show()
    header.hStatus:Show()
    
    if header.bBtn then header.bBtn:Hide() end
    header:Show()
    
    table.insert(self.rows, header)
    y = y - 35

    -- 2. FILAS DE OBJETOS
    local class = GearAnalyzer:GetClassToken(ignoreForced)
    local normSpec = GearAnalyzer:NormalizeSpecName(curSpec)
    
    -- Cargar datos de clase si no están cargados
    GearAnalyzer:LoadClassData(class)
    local classData = GearAnalyzer.ClassData[class:upper()]
    local specEnchants = classData and classData.Enchants and classData.Enchants[normSpec]

    for i, itemData in ipairs(data) do
        local d = itemData
        local slotKey = GearAnalyzer:GetSlotKey(d.slotName, d.slotID)
        
        -- Ocultar Mano Secundaria si el master dice 0 y está vacía
        local shouldSkip = (slotKey == "offhand" and specEnchants and specEnchants.offhand == 0 and not d.itemLink)
        
        if not shouldSkip then
            local row = self:GetOrCreateRow(i, content)
            row:SetPoint("TOPLEFT", 10, y)
            row:SetSize(1010, 42)
            row:Show()

            local prefix = ignoreForced and "" or "guide_"

            if d.itemLink then
                -- MODO EQUIPADO
                local _, _, quality = GetItemInfo(d.itemLink)
                local r, g, b = GetItemQualityColor(quality or 1)

                row.bg:Show()
                row.icon:Show()
                row.icon:SetTexture(GetItemIcon(d.itemLink))
                row.border:Hide()
                
                local isBIS = d[prefix.."isBIS"]
                local gemStatus = d[prefix.."gemStatus"] or 0
                local enchStatus = d[prefix.."enchStatus"] or 0
                local nextUpgradeID = d[prefix.."nextUpgradeID"]

                if isBIS then
                    row.bg:SetTexture(0, 1, 0, 0.15)
                    row.border:SetVertexColor(0, 1, 0, 1)
                else
                    row.bg:SetTexture(1, 1, 1, 0.03)
                    row.border:SetVertexColor(r, g, b, 0.8)
                end

                row.iconBtn:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(d.itemLink)
                    if d.setInfo then
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine(d.setInfo)
                    end
                    GameTooltip:Show()
                end)
                row.iconBtn:SetScript("OnClick", function(self)
                    if d.itemLink then
                        HandleModifiedItemClick(d.itemLink)
                    end
                end)

                local rankTag = ""
                local dRank = d[prefix.."rank"]
                if dRank then
                    local isGoldRank = isBIS
                    local rankColor = isGoldRank and "|cffffd100" or "|cff00ccff"
                    rankTag = rankColor .. "[Top " .. dRank .. "]|r "
                end
                
                local slotKey = d.slotName
                if d.slotID == 11 then slotKey = "SLOT_FINGER1"
                elseif d.slotID == 12 then slotKey = "SLOT_FINGER2"
                elseif d.slotID == 13 then slotKey = "SLOT_TRINKET1"
                elseif d.slotID == 14 then slotKey = "SLOT_TRINKET2"
                end
                local slotDisp = L[slotKey] or d.slotName
                row.nameText:SetText("|cffaaaaaa" .. slotDisp .. ":|r " .. rankTag .. d.itemLink)
                GearAnalyzer:ApplyStyle(row.nameText)
                
                local ilvlText = "|cffffffffilvl " .. (d.iLevel or "??") .. "|r"
                row.infoText:SetText(ilvlText .. "  |  ")
                GearAnalyzer:ApplyStyle(row.infoText)
                
                -- Gemas
                local gCol = (gemStatus == 2) and "|cff00ff00" or (gemStatus == 1 and "|cffffff00" or "|cffff0000")
                row.gemText:SetText(gCol .. "[G]|r")
                row.gemBtn:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetText("Análisis de Gemas y Ranuras")
                    
                    if d.socketBonusText then
                        local worth = GearAnalyzer:ShouldFollowSocket(class, curSpec, "unknown", d.bonusStat, d.bonusVal)
                        local worthCol = worth and "|cff00ff00(VALE LA PENA)|r" or "|cffff0000(IGNORAR)|r"
                        GameTooltip:AddLine("Bono: " .. d.socketBonusText .. " " .. worthCol)
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
                                GameTooltip:AddLine("   Sugerida: |cff00ff00"..s.recommendedName.."|r")
                            end
                        end
                    else
                        GameTooltip:AddLine(d.gemTooltip or "Sin datos", 1, 1, 1)
                    end
                    
                    if d.slotName:find("Pecho") or d.slotName:find("Chest") then
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine("|cff3fc7ebNota:|r Se recomienda la |cffff00ffLágrima de pesadilla|r aquí para activar la Meta.", 1, 1, 1, true)
                    end
                    
                    GameTooltip:Show()
                end)
                
                -- Encantos
                local eCol = "|cffff0000"
                if enchStatus == 2 then eCol = "|cff00ff00"
                elseif enchStatus == 3 then eCol = "|cffffa500"
                elseif enchStatus == 1 then eCol = "|cffffff00"
                end
                row.enchText:SetText(eCol .. "[E]|r")
                row.enchBtn:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetText("Estado de Encantamiento")
                    GameTooltip:AddLine(d.enchTooltip or "Sin datos", 1, 1, 1)
                    GameTooltip:Show()
                end)

                -- Estado
                local estadoTexto = "|cffaaaaaaFalta Data|r"
                if isBIS then 
                    estadoTexto = "|cff00ff00BiS Final|r"
                elseif d[prefix.."isAlternative"] then 
                    estadoTexto = "|cff00ccffCasi BiS|r"
                elseif d[prefix.."isIncorrect"] then 
                    estadoTexto = "|cffff0000No Óptimo|r"
                elseif d[prefix.."isTier10Normal"] then 
                    estadoTexto = "|cffffff00Mejorable|r"
                elseif d[prefix.."isLowLevel"] then 
                    estadoTexto = "|cffffa500iLvl Bajo|r"
                elseif d[prefix.."isCorrect"] then 
                    estadoTexto = "|cffffff00Mejorable|r" 
                end
                row.status:SetText(estadoTexto)
                GearAnalyzer:ApplyStyle(row.status)

                -- Botón Equipar
                local betterItemLink = d[prefix.."betterItemLink"]
                local betterInBags = d[prefix.."betterInBags"]
                local betterInBank = d[prefix.."betterInBank"]
                local betterItemBag = d[prefix.."betterItemBag"]
                local betterItemSlot = d[prefix.."betterItemSlot"]

                if betterItemLink then
                    row.bBtn:SetText(betterInBags and "EQUIPAR" or "BANCO")
                    if betterInBags then 
                        row.bBtn:Enable() 
                    else 
                        row.bBtn:Disable() 
                    end
                    
                    row.bBtn:SetScript("OnClick", function()
                        if betterInBags and betterItemBag and betterItemSlot then
                            local invSlot = d.slotID
                            if invSlot then
                                ClearCursor()
                                PickupContainerItem(betterItemBag, betterItemSlot)
                                EquipCursorItem(invSlot)
                                ClearCursor()
                                local slotKey = d.slotName
                                if d.slotID == 11 then slotKey = "SLOT_FINGER1"
                                elseif d.slotID == 12 then slotKey = "SLOT_FINGER2"
                                elseif d.slotID == 13 then slotKey = "SLOT_TRINKET1"
                                elseif d.slotID == 14 then slotKey = "SLOT_TRINKET2"
                                end
                                local slotDisp = L[slotKey] or d.slotName
                                print("|cff00ff00GearAnalyzer:|r Equipando " .. betterItemLink .. " en slot |cffffd100" .. slotDisp .. "|r")
                            else
                                UseContainerItem(betterItemBag, betterItemSlot)
                                print("|cff00ff00GearAnalyzer:|r Equipando " .. betterItemLink)
                            end
                            GearAnalyzer:After(0.4, function() GearAnalyzer:FullReload() end)
                        end
                    end)

                    row.bBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
                    row.bBtn:Show()
                    -- Icono de la mejora recomendada
                    local _, _, _, _, _, _, _, _, _, betterTexture = GetItemInfo(betterItemLink)
                    row.betterIcon:SetTexture(betterTexture or GetItemIcon(betterItemLink))
                    row.betterIcon:Show()
                    
                    local locationText = betterInBags and "|cff00ff00(En tus bolsas)|r" or "|cffff0000(En el BANCO)|r"
                    row.betterIconBtn:SetScript("OnEnter", function(self)
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                        GameTooltip:SetHyperlink(betterItemLink)
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine("Ubicación: " .. locationText)
                        if betterInBank then
                            GameTooltip:AddLine("|cffff0000Debes sacarlo del banco para poder equiparlo.|r", 1, 0, 0, true)
                        else
                            GameTooltip:AddLine("|cff00ff00Haz clic en EQUIPAR para usarlo.|r")
                        end
                        GameTooltip:Show()
                    end)
                    row.betterIconBtn:SetScript("OnClick", function(self)
                        if betterItemLink then
                            HandleModifiedItemClick(betterItemLink)
                        end
                    end)
                    row.betterIconBtn:Show()
                else
                    row.bBtn:Hide()
                    row.betterIcon:Hide()
                    row.betterIconBtn:Hide()
                end
            else
                -- MODO VACÍO
                row.bg:SetTexture(1, 1, 1, 0.03)
                row.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                row.icon:Show()
                row.border:SetVertexColor(1, 1, 1, 0.5)
                row.border:Show()
                
                local slotKey = d.slotName
                if d.slotID == 11 then slotKey = "SLOT_FINGER1"
                elseif d.slotID == 12 then slotKey = "SLOT_FINGER2"
                elseif d.slotID == 13 then slotKey = "SLOT_TRINKET1"
                elseif d.slotID == 14 then slotKey = "SLOT_TRINKET2"
                end
                local slotDisp = L[slotKey] or d.slotName
                row.nameText:SetText("|cffaaaaaa" .. slotDisp .. ":|r |cff888888(" .. L["EMPTY"] .. ")|r")
                row.infoText:SetText("")
                row.gemText:SetText("")
                row.enchText:SetText("")
                row.status:SetText("|cff888888Vacío|r")
                row.bBtn:Hide()
                row.betterIcon:Hide()
                row.betterIconBtn:Hide()
                row.iconBtn:SetScript("OnEnter", nil)
            end

            -- SIGUIENTE MEJOR (Para ambos modos)
            local nextUpgradeID = d[prefix.."nextUpgradeID"]
            if nextUpgradeID then
                local _, itemLink, _, _, _, _, _, _, _, texture = GetItemInfo(nextUpgradeID)
                row.nextIcon:SetTexture(texture or GetItemIcon(nextUpgradeID))
                row.nextIcon:Show()
                row.nextBtn:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(itemLink or ("item:"..nextUpgradeID))
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine("|cffffd100Siguiente gran mejora para este slot|r")
                    GameTooltip:Show()
                end)
                row.nextBtn:SetScript("OnClick", function(self)
                    local link = itemLink or ("item:"..nextUpgradeID)
                    HandleModifiedItemClick(link)
                end)
                row.nextBtn:Show()
            else
                row.nextIcon:Hide()
                row.nextBtn:Hide()
            end

            table.insert(self.rows, row)

            -- AJUSTAR TAMAÑO DINÁMICO
            local iconSize = 32
            row:SetHeight(iconSize + 10)
            row.icon:SetSize(iconSize, iconSize)
            row.iconBtn:SetSize(iconSize, iconSize)
            row.nextIcon:SetSize(iconSize * 0.85, iconSize * 0.85)
            row.nextBtn:SetSize(iconSize * 0.85, iconSize * 0.85)
            row.betterIcon:SetSize(iconSize * 0.85, iconSize * 0.85)
            row.betterIconBtn:SetSize(iconSize * 0.85, iconSize * 0.85)
            
            y = y - (iconSize + 14)
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

    content:SetHeight(math.abs(y) + 20)
end

function Tab:GetOrCreateRow(i, parent)
    self.allRows = self.allRows or {}
    if self.allRows[i] then return self.allRows[i] end

    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(1010, 42)
    
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
    row.iconBtn = iconBtn

    local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    nameText:SetPoint("TOPLEFT", icon, "TOPRIGHT", 12, -4)
    nameText:SetPoint("RIGHT", row, "RIGHT", -160, 0)
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
    row.gemBtn = gemBtn
    row.gemText = gemText

    local enchBtn = CreateFrame("Button", nil, row)
    enchBtn:SetSize(25, 20)
    enchBtn:SetPoint("LEFT", gemBtn, "RIGHT", 2, 0)
    local enchText = enchBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    enchText:SetAllPoints()
    enchBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    row.enchBtn = enchBtn
    row.enchText = enchText

    local nextIcon = row:CreateTexture(nil, "ARTWORK")
    nextIcon:SetSize(32, 32)
    nextIcon:SetPoint("RIGHT", row, "RIGHT", -110, 0)
    local nextBtn = CreateFrame("Button", nil, row)
    nextBtn:SetSize(32, 32)
    nextBtn:SetPoint("CENTER", nextIcon, "CENTER")
    nextBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    row.nextIcon = nextIcon
    row.nextBtn = nextBtn

    local status = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    status:SetPoint("RIGHT", row, "RIGHT", -15, 0)
    row.status = status

    local bBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    bBtn:SetSize(75, 22)
    bBtn:SetPoint("RIGHT", nextIcon, "LEFT", -10, 0)
    bBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    row.bBtn = bBtn

    local betterIcon = row:CreateTexture(nil, "ARTWORK")
    betterIcon:SetSize(32, 32)
    betterIcon:SetPoint("RIGHT", bBtn, "LEFT", -5, 0)
    row.betterIcon = betterIcon

    local betterIconBtn = CreateFrame("Button", nil, row)
    betterIconBtn:SetSize(32, 32)
    betterIconBtn:SetPoint("CENTER", betterIcon, "CENTER")
    betterIconBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    row.betterIconBtn = betterIconBtn

    self.allRows[i] = row
    return row
end

function Tab:GetOrCreateLegend(parent)
    if self.legend then return self.legend end
    local legend = CreateFrame("Frame", nil, parent)
    legend:SetSize(990, 60)
    local legTitle = legend:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    legTitle:SetPoint("TOPLEFT", 5, 0)
    legTitle:SetText("LEYENDA DE ANÁLISIS:")
    local legText = legend:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    legText:SetPoint("TOPLEFT", 5, -15)
    legText:SetJustifyH("LEFT")
    legText:SetText(
        "|cff00ff00[G]|r Gemas OK    |cffffff00[G]|r Gemas no óptimas    |cffff0000[G]|r Faltan gemas\n" ..
        "|cff00ff00[E]|r Encantado    |cffffa500[E]|r Profesión    |cffff0000[E]|r Sin encantar\n" ..
        "|cff00ff00BiS|r Perfecto    |cff00ccffCasi BiS|r Top 6    |cffffff00Mejorable|r Correcto    |cffffa500Bajo Lvl|r Desfasado\n" ..
        "|cffaaaaaaFalta Data|r: Objeto no encontrado en la base de datos de BiS para tu clase/especialización."
    )
    self.legend = legend
    return legend
end
