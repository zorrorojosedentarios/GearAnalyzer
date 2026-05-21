-- =========================
-- GearAnalyzer Tab: Caps
-- Pestaña visual mejorada con todos los stats
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")
local L = LibStub("AceLocale-3.0"):GetLocale("GearAnalyzer")
local Tab = GearAnalyzer:NewModule("TabCaps")

function Tab:Update(page, ignoreForced)
    if page then
        self.page = page
    else
        page = self.page
    end
    GearAnalyzer:AnalyzeEquipment(ignoreForced)
    
    if not page then return end

    -- Asegurar que L tiene las entradas críticas si AceLocale falla
    if not L["HIT_CAP"] then L["HIT_CAP"] = "Cap de Golpe" end
    if not L["EXPERTISE_CAP"] then L["EXPERTISE_CAP"] = "Cap de Pericia" end

    -- 1. CREACIÓN ÚNICA
    if not self.scroll then
        local scroll = CreateFrame("ScrollFrame", "GACapsScroll", page, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 10, -40)
        scroll:SetPoint("BOTTOMRIGHT", -30, 10)
        self.scroll = scroll

        local content = CreateFrame("Frame", nil, scroll)
        local w = page:GetWidth()
        if not w or w <= 0 then w = 1060 end
        content:SetSize(w - 40, 1000)
        scroll:SetScrollChild(content)
        self.content = content

        local title = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 10, -10)
        self.title = title

        self.rows = {}
    end

    for _, row in ipairs(self.rows) do row:Hide() end

    local class = GearAnalyzer:GetClassToken(ignoreForced)
    local activeSpec = GearAnalyzer:GetCurrentSpecEnhanced(ignoreForced)
    local spec = GearAnalyzer:NormalizeSpecName(activeSpec)
    
    -- Obtener datos de caps desde ClassData directamente
    local classData = GearAnalyzer.ClassData[class]
    local specData = classData and classData.Caps and classData.Caps[spec]

    if not specData then
        self.title:SetText(string.format(L["STAT_ERROR_MSG"], class or "?", activeSpec or "?"))
        print("|cffff0000GearAnalyzer Debug:|r Caps missing for Class: " .. (class or "nil") .. ", Spec: " .. (spec or "nil"))
        return
    else
        self.title:SetText("|cffffff00" .. L["STATS_AND_CAPS"] .. "|r - " .. (L[spec] or spec))
        GearAnalyzer:ApplyStyle(self.title, true)
    end

    local y = -10
    local rowIndex = 0
    local isDev = GearAnalyzer.charDB and GearAnalyzer.charDB.settings and GearAnalyzer.charDB.settings.devMode
    
    -- =============================
    -- SECCIÓN 1: CAPS CRÍTICOS
    -- =============================
    if specData.hitCap or specData.expertiseCap then
        rowIndex = rowIndex + 1
        local header = self:GetOrCreateRow(rowIndex, true)
        header:ClearAllPoints()
        header:SetPoint("TOPLEFT", 10, y)
        header.text:SetText("|cffffd100" .. L["CRITICAL_CAPS"] .. "|r")
        GearAnalyzer:ApplyStyle(header.text, true)
        header.bar:Hide()
        header.icon:Hide()
        header.bg:Hide()
        header:Show()
        y = y - (GearAnalyzer.db.profile.settings.fontSize or 12) - 20
        
        -- Hit Cap
        if specData.hitCap then
            rowIndex = rowIndex + 1
            local row = self:GetOrCreateRow(rowIndex)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 20, y)
            
            local statKey = (specData.role == "Caster") and "HIT_SPELL" or "HIT"
            local current = GearAnalyzer:GetStatVal(statKey)
            local target = specData.hitCap.percent
            local hitNote = specData.hitCap.note

            -- AJUSTE DINÁMICO DE HIT CAP PARA ALLIANCE/HORDE Y DRAENEI
            if specData.role == "Caster" and class == "DRUID" and spec == "Balance" then
                local faction = UnitFactionGroup("player")
                if faction == "Horde" then
                    target = 10 -- Horde Balance Druid needs 10% hit
                else
                    -- Alliance
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
                hitNote = target == 9 and "9% (Con Draenei)" or "10% (Sin Draenei)"
            end

            -- APLICAR OVERRIDE PERSONALIZADO
            local overrideKey = (spec or "NONE") .. "_" .. statKey
            local customTarget = GearAnalyzer.db.global.customOverrides.caps[overrideKey]
            if customTarget then target = customTarget end

            -- Conversión para visualización
            local currentPct = (current / 26.23) -- Caster default
            if specData.role ~= "Caster" then currentPct = (current / 32.79) end

            local isCapped = currentPct >= target
            local isOver = currentPct > (target + 1) -- 1% margen

            local label = GearAnalyzer.StatTrans[statKey] or "Golpe"
            self:SetupRow(row, label, statKey, currentPct, target, isCapped, isOver, hitNote, true)

            -- LÓGICA MODO DEVELOPER
            if isDev then
                if not row.devEdit then
                    local edit = CreateFrame("EditBox", nil, row)
                    edit:SetSize(60, 20)
                    edit:SetPoint("RIGHT", row, "RIGHT", -10, 0)
                    edit:SetAutoFocus(false)
                    edit:SetFontObject("GameFontHighlightSmall")
                    edit:SetJustifyH("CENTER")
                    edit:EnableMouse(true)
                    row.devEdit = edit
                    edit:SetFrameLevel(45)
                    
                    local bgt = edit:CreateTexture(nil, "BACKGROUND")
                    bgt:SetAllPoints()
                    bgt:SetTexture(0, 0, 0.4, 0.8)
                    edit.bgt = bgt
                    
                    local reset = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                    reset:SetSize(20, 20)
                    reset:SetPoint("RIGHT", edit, "LEFT", -5, 0)
                    reset:SetText("R")
                    row.devReset = reset
                    reset:SetFrameLevel(45)
                end
                
                if not row.devEdit:HasFocus() then
                    row.devEdit:SetText(tostring(target or "0"))
                end
                
                row.devEdit:SetScript("OnEnterPressed", function(self)
                    local val = tonumber(self:GetText())
                    if val then GearAnalyzer.db.global.customOverrides.caps[overrideKey] = val; GearAnalyzer:FullReload() end
                    self:ClearFocus()
                end)
                row.devEdit:SetScript("OnEscapePressed", function(self)
                    self:SetText(tostring(target or "0"))
                    self:ClearFocus()
                end)
                row.devReset:SetScript("OnClick", function() GearAnalyzer.db.global.customOverrides.caps[overrideKey] = nil; GearAnalyzer:FullReload() end)
                
                row:SetScript("OnHide", function()
                    if row.devEdit then row.devEdit:ClearFocus() end
                end)

                row.devEdit:Show(); row.devReset:Show()
            elseif row.devEdit then row.devEdit:Hide(); row.devReset:Hide() end

            row:Show()
            y = y - 55
        end
        
        -- Expertise Cap
        if specData.expertiseCap and specData.expertiseCap.skill then
            rowIndex = rowIndex + 1
            local row = self:GetOrCreateRow(rowIndex)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 20, y)
            
            local overrideKey = (spec or "NONE") .. "_EXPERTISE"
            local currentVal = GearAnalyzer:GetStatVal("EXPERTISE")
            local targetSkill = specData.expertiseCap.skill
            
            local customTarget = GearAnalyzer.db.global.customOverrides.caps[overrideKey]
            if customTarget then targetSkill = customTarget end

            local currentSkill = math.floor(currentVal / 8.2)
            local isCapped = currentSkill >= targetSkill
            local isOver = currentSkill > (targetSkill + 2)

            local label = GearAnalyzer.StatTrans["EXPERTISE"] or "Pericia"
            self:SetupRow(row, label, "EXPERTISE", currentSkill, targetSkill, isCapped, isOver, specData.expertiseCap.note)

            -- LÓGICA MODO DEVELOPER
            if isDev then
                if not row.devEdit then
                    local edit = CreateFrame("EditBox", nil, row)
                    edit:SetSize(60, 20)
                    edit:SetPoint("RIGHT", row, "RIGHT", -10, 0)
                    edit:SetAutoFocus(false)
                    edit:SetFontObject("GameFontHighlightSmall")
                    edit:SetJustifyH("CENTER")
                    edit:EnableMouse(true)
                    row.devEdit = edit
                    edit:SetFrameLevel(45)
                    
                    local bgt = edit:CreateTexture(nil, "BACKGROUND")
                    bgt:SetAllPoints()
                    bgt:SetTexture(0, 0, 0.4, 0.8)
                    edit.bgt = bgt
                    
                    local reset = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                    reset:SetSize(20, 20)
                    reset:SetPoint("RIGHT", edit, "LEFT", -5, 0)
                    reset:SetText("R")
                    row.devReset = reset
                    reset:SetFrameLevel(45)
                end
                
                if not row.devEdit:HasFocus() then
                    row.devEdit:SetText(tostring(targetSkill or "0"))
                end
                
                row.devEdit:SetScript("OnEnterPressed", function(self)
                    local val = tonumber(self:GetText())
                    if val then GearAnalyzer.db.global.customOverrides.caps[overrideKey] = val; GearAnalyzer:FullReload() end
                    self:ClearFocus()
                end)
                row.devEdit:SetScript("OnEscapePressed", function(self)
                    self:SetText(tostring(targetSkill or "0"))
                    self:ClearFocus()
                end)
                row.devReset:SetScript("OnClick", function() GearAnalyzer.db.global.customOverrides.caps[overrideKey] = nil; GearAnalyzer:FullReload() end)
                
                row:SetScript("OnHide", function()
                    if row.devEdit then row.devEdit:ClearFocus() end
                end)

                row.devEdit:Show(); row.devReset:Show()
            elseif row.devEdit then row.devEdit:Hide(); row.devReset:Hide() end

            row:Show()
            y = y - 55
        end
    end
    
    -- =============================
    -- SECCIÓN 2: CAPS DE OPTIMIZACIÓN
    -- =============================
    if specData.priorities then
        local hasOptimizationCaps = false
        for _, priority in ipairs(specData.priorities) do
            if priority.cap then hasOptimizationCaps = true; break end
        end
        
        if hasOptimizationCaps then
            y = y - 15
            rowIndex = rowIndex + 1
            local header = self:GetOrCreateRow(rowIndex, true)
            header:ClearAllPoints()
            header:SetPoint("TOPLEFT", 10, y)
            header.text:SetText("|cffffd100" .. L["OPTIMIZATION_CAPS"] .. "|r")
            GearAnalyzer:ApplyStyle(header.text, true)
            header.bar:Hide()
            header.bg:Hide()
            header:Show()
            y = y - (GearAnalyzer.db.profile.settings.fontSize or 12) - 25
            
            for _, priority in ipairs(specData.priorities) do
                if priority.cap then
                    rowIndex = rowIndex + 1
                    local row = self:GetOrCreateRow(rowIndex)
                    row:ClearAllPoints()
                    row:SetPoint("TOPLEFT", 20, y)
                    
                    local current = GearAnalyzer:GetStatVal(priority.stat)
                    local target = priority.cap
                    
                    -- APLICAR OVERRIDE PERSONALIZADO
                    local overrideKey = (spec or "NONE") .. "_" .. priority.stat
                    local customTarget = GearAnalyzer.db.global.customOverrides.caps[overrideKey]
                    if customTarget then target = customTarget end

                    local isCapped = current >= target
                    local isOver = (target > 0) and (current > target * 1.5) or false -- Margen genérico

                    local label = priority.label or GearAnalyzer.StatTrans[priority.stat] or priority.stat
                    self:SetupRow(row, label, priority.stat, current, target, isCapped, isOver, priority.note, priority.isPercent)
                    
                    -- LÓGICA MODO DEVELOPER
                    if isDev then
                        if not row.devEdit then
                            local edit = CreateFrame("EditBox", nil, row, "InputBoxTemplate")
                            edit:SetSize(45, 20)
                            edit:SetPoint("RIGHT", row, "RIGHT", -5, 0)
                            edit:SetAutoFocus(false)
                            edit:SetFontObject("GameFontHighlightSmall")
                            edit:SetJustifyH("CENTER")
                            row.devEdit = edit
                            
                            local reset = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
                            reset:SetSize(20, 20)
                            reset:SetPoint("RIGHT", edit, "LEFT", -5, 0)
                            reset:SetText("R")
                            row.devReset = reset
                        end

                        if not row.devEdit:HasFocus() then
                            row.devEdit:SetText(tostring(target))
                        end
                        row.devEdit:SetScript("OnEnterPressed", function(self)
                            local val = tonumber(self:GetText())
                            if val then
                                GearAnalyzer.db.global.customOverrides.caps[overrideKey] = val
                                GearAnalyzer:FullReload()
                            end
                            self:ClearFocus()
                        end)
                        
                        row.devReset:SetScript("OnClick", function()
                            GearAnalyzer.db.global.customOverrides.caps[overrideKey] = nil
                            GearAnalyzer:FullReload()
                        end)

                        row.devEdit:Show()
                        row.devReset:Show()
                    elseif row.devEdit then
                        row.devEdit:Hide()
                        row.devReset:Hide()
                    end

                    row:Show()
                    y = y - 60
                end
            end
        end
    end
    
    -- =============================
    -- SECCIÓN 3: ESTADÍSTICAS PRINCIPALES
    -- =============================
    y = y - 15
    rowIndex = rowIndex + 1
    local header3 = self:GetOrCreateRow(rowIndex, true)
    header3:ClearAllPoints()
    header3:SetPoint("TOPLEFT", 10, y)
    header3.text:SetText("|cffffd100" .. L["MAIN_STATS"] .. "|r")
    GearAnalyzer:ApplyStyle(header3.text, true)
    header3.bar:Hide()
    header3.bg:Hide()
    header3:Show()
    y = y - (GearAnalyzer.db.profile.settings.fontSize or 12) - 25
    
    if specData.priorities then
        for _, priority in ipairs(specData.priorities) do
            if not priority.cap then
                rowIndex = rowIndex + 1
                local row = self:GetOrCreateRow(rowIndex)
                row:ClearAllPoints()
                row:SetPoint("TOPLEFT", 20, y)
                
                local current = self:GetPlayerStat(priority.stat)
                local label = priority.label or GearAnalyzer.StatTrans[priority.stat] or priority.stat
                self:SetupStatRow(row, label, priority.stat, current, priority.note)
                row:Show()
                y = y - 45
            end
        end
    end
    
    -- =============================
    -- SECCIÓN 4: OTRAS ESTADÍSTICAS
    -- =============================
    y = y - 15
    rowIndex = rowIndex + 1
    local header4 = self:GetOrCreateRow(rowIndex, true)
    header4:ClearAllPoints()
    header4:SetPoint("TOPLEFT", 10, y)
    header4.text:SetText("|cffffd100" .. L["GENERAL_SUMMARY"] .. "|r")
    GearAnalyzer:ApplyStyle(header4.text, true)
    header4.bar:Hide()
    header4.bg:Hide()
    header4:Show()
    y = y - (GearAnalyzer.db.profile.settings.fontSize or 12) - 25
    
    local additionalStats = self:GetAdditionalStats(specData.role)
    for _, statInfo in ipairs(additionalStats) do
        -- No repetir lo que ya está en prioridades
        local alreadyShown = false
        if specData.priorities then
            for _, p in ipairs(specData.priorities) do
                if p.stat == statInfo.stat then alreadyShown = true; break end
            end
        end
        
        if not alreadyShown then
            rowIndex = rowIndex + 1
            local row = self:GetOrCreateRow(rowIndex)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 20, y)
            
            local current = GearAnalyzer:GetStatVal(statInfo.stat)
            local label = statInfo.label or GearAnalyzer.StatTrans[statInfo.stat] or statInfo.stat
            self:SetupStatRow(row, label, statInfo.stat, current)
            row:Show()
            y = y - 45
        end
    end
    
    self.content:SetHeight(math.abs(y) + 20)
end

-- Configurar una fila con cap (con barra de progreso)
function Tab:SetupRow(row, label, stat, current, target, isCapped, isOver, note, isPercent)
    label = GearAnalyzer:LocalizeText(label)
    local percent = (target > 0) and (current / target) * 100 or 100
    
    row.bg:Show()
    row.icon:SetTexture(self:GetStatIcon(stat))
    row.icon:Show()
    
    -- Texto
    local color = isOver and "|cffffa500" or (isCapped and "|cff00ff00" or "|cffffd100")
    local statusText = isOver and (" |cffffa500" .. (L["EXCESS_TAG"] or "EXCESO") .. "|r") or (isCapped and (" |cff00ff00" .. (L["CAPPED_OK"] or "CAP") .. "|r") or "")
    local noteText = note and (" |cffaaaaaa(" .. tostring(note) .. ")|r") or ""
    row.text:SetText(string.format("%s:|r %s%s|r / %s%s%s", 
        tostring(label or ""), 
        color, self:FormatStat(current, stat, isPercent), 
        self:FormatStat(target, stat, isPercent),
        statusText,
        noteText))
    GearAnalyzer:ApplyStyle(row.text)
    
    -- Barra de progreso
    row.bar:SetMinMaxValues(0, 100)
    row.bar:SetValue(math.min(100, percent))
    row.bar:Show()
    
    -- Color de la barra con gradiente
    if isOver then
        row.bar:SetStatusBarColor(1, 0.5, 0, 0.8) -- Naranja
    elseif isCapped then
        row.bar:SetStatusBarColor(0, 1, 0, 0.8) -- Verde brillante
    else
        row.bar:SetStatusBarColor(1, 0.7, 0, 0.8) -- Ámbar
    end
    local formattedVal = self:FormatStat(current, stat, isPercent)
    local completionPct = math.min(100, percent)
    row.barText:SetText(string.format("%s (%.0f%%)", formattedVal, completionPct))
    GearAnalyzer:ApplyStyle(row.barText)
    row.barText:Show()

    -- Ajustar Tamaño Dinámico
    local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
    row:SetHeight(iconSize + 10)
    row.icon:SetSize(iconSize, iconSize)
    row.bar:SetHeight(iconSize * 0.4)
    
    local isDev = GearAnalyzer.db.profile.settings.developerMode
    row.bar:ClearAllPoints()
    if isDev then
        row.bar:SetPoint("RIGHT", -110, 0)
    else
        row.bar:SetPoint("RIGHT", -20 - (iconSize*0.5), 0)
    end
end

-- Configurar una fila de stat sin cap (solo muestra valor)
function Tab:SetupStatRow(row, label, stat, current, note)
    label = GearAnalyzer:LocalizeText(label)
    row.bg:Show()
    row.icon:SetTexture(self:GetStatIcon(stat))
    row.icon:Show()
    
    -- Texto
    local noteText = note and (" |cffaaaaaa(" .. tostring(note) .. ")|r") or ""
    row.text:SetText(string.format("|cffffff00%s:|r |cffffffff%s|r%s", 
        tostring(label or ""), 
        self:FormatStat(current, stat),
        noteText))
    GearAnalyzer:ApplyStyle(row.text)
    
    -- Ocultar barra para stats sin cap
    row.bar:Hide()
    row.barText:Hide()

    -- Asegurar que los elementos de modo developer se oculten (SOLUCIÓN AL BUG)
    if row.devEdit then row.devEdit:Hide() end
    if row.devReset then row.devReset:Hide() end

    -- Ajustar Tamaño Dinámico
    local iconSize = GearAnalyzer.db.profile.settings.iconSize or 32
    row:SetHeight(iconSize + 10)
    row.icon:SetSize(iconSize, iconSize)
end


-- Obtener stats adicionales según el rol
function Tab:GetAdditionalStats(role)
    local stats = {}
    
    if role == "Caster" then
        table.insert(stats, { label = "Poder de Hechizos", stat = "SP" })
        table.insert(stats, { label = "Intelecto", stat = "INT" })
        table.insert(stats, { label = "Espíritu", stat = "SPIRIT" })
        table.insert(stats, { label = "Crítico", stat = "CRIT" })
    elseif role == "Healer" then
        table.insert(stats, { label = "Poder de Hechizos", stat = "SP" })
        table.insert(stats, { label = "Intelecto", stat = "INT" })
        table.insert(stats, { label = "Espíritu", stat = "SPIRIT" })
        table.insert(stats, { label = "Crítico", stat = "CRIT" })
        table.insert(stats, { label = "Celeridad", stat = "HASTE" })
    elseif role == "Melee" then
        table.insert(stats, { label = "Poder de Ataque", stat = "AP" })
        table.insert(stats, { label = "Crítico", stat = "CRIT" })
    elseif role == "Tanque" then
        table.insert(stats, { label = "Aguante", stat = "STA" })
        table.insert(stats, { label = "Armadura", stat = "ARMOR" })
        table.insert(stats, { label = "Esquiva", stat = "DODGE" })
        table.insert(stats, { label = "Parada", stat = "PARRY" })
    elseif role == "Rango" then
        table.insert(stats, { label = "Poder de Ataque a Distancia", stat = "RAP" })
        table.insert(stats, { label = "Crítico", stat = "CRIT" })
    end
    
    return stats
end

-- Obtener icono para cada stat
function Tab:GetStatIcon(stat)
    local icons = {
        ["HIT"] = "Interface\\Icons\\Ability_Marksmanship",
        ["HIT_SPELL"] = "Interface\\Icons\\Spell_Nature_StarFall",
        ["EXPERTISE"] = "Interface\\Icons\\Ability_Warrior_WeaponMastery",
        ["DEFENSE"] = "Interface\\Icons\\Ability_Defend",
        ["DEF"] = "Interface\\Icons\\Ability_Defend",
        ["HASTE"] = "Interface\\Icons\\Spell_Nature_RavenForm",
        ["ArPen"] = "Interface\\Icons\\Ability_Warrior_Riposte",
        ["ARPEN"] = "Interface\\Icons\\Ability_Warrior_Riposte",
        ["ARP"] = "Interface\\Icons\\Ability_Warrior_Riposte",
        ["CRIT"] = "Interface\\Icons\\Ability_CriticalStrike",
        ["STR"] = "Interface\\Icons\\Ability_Warrior_OffensiveStance",
        ["AGI"] = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        ["INT"] = "Interface\\Icons\\Spell_Holy_MagicalSentry",
        ["STA"] = "Interface\\Icons\\Spell_Holy_WordFortitude",
        ["SPIRIT"] = "Interface\\Icons\\Spell_Holy_DivineSpirit",
        ["SP"] = "Interface\\Icons\\Spell_Nature_Lightning",
        ["AP"] = "Interface\\Icons\\Ability_Warrior_BattleShout",
        ["RAP"] = "Interface\\Icons\\Ability_Hunter_RapidKilling",
        ["ARMOR"] = "Interface\\Icons\\INV_Chest_Plate01",
        ["DODGE"] = "Interface\\Icons\\Ability_Rogue_Feint",
        ["PARRY"] = "Interface\\Icons\\Ability_Parry",
    }
    return icons[stat] or "Interface\\Icons\\INV_Misc_QuestionMark"
end

function Tab:GetPlayerStat(stat)
    local val = 0
    
    -- Hit Rating
    if stat == "HIT" then 
        local rating = GetCombatRating(CR_HIT_MELEE)
        val = (rating / 32.79)
    elseif stat == "HIT_SPELL" then 
        local rating = GetCombatRating(CR_HIT_SPELL)
        val = (rating / 26.23)
    -- Expertise
    elseif stat == "EXPERTISE" then 
        local rating = GetCombatRating(CR_EXPERTISE)
        val = (rating / 8.2)
    -- Defense
    elseif stat == "DEFENSE" or stat == "DEF" then 
        local base, modifier = UnitDefense("player")
        val = base + modifier
    -- Haste Rating
    elseif stat == "HASTE" then 
        val = GetCombatRating(CR_HASTE_SPELL)
        if val == 0 then val = GetCombatRating(CR_HASTE_MELEE) end
    -- Armor Penetration
    elseif stat == "ArPen" or stat == "ARPEN" or stat == "ARP" then 
        val = GetCombatRating(CR_ARMOR_PENETRATION)
    -- Crit
    elseif stat == "CRIT" then
        local class = GearAnalyzer:GetClassToken()
        local spec = GearAnalyzer:GetCurrentSpecEnhanced()
        local role = "Melee"
        if GearAnalyzer.ClassData[class] and GearAnalyzer.ClassData[class].Caps and GearAnalyzer.ClassData[class].Caps[spec] then
            role = GearAnalyzer.ClassData[class].Caps[spec].role
        end
        if role == "Caster" or role == "Healer" then
            local school = 4 -- Naturaleza por defecto (Druida/Chamán)
            if class == "MAGE" then
                if spec == "Arcane" then school = 7
                elseif spec == "Fire" or spec == "Fire FFB" then school = 3
                elseif spec == "Frost" then school = 5
                end
            elseif class == "PRIEST" then
                if spec == "Shadow" then school = 6
                else school = 2
                end
            elseif class == "WARLOCK" then
                if spec == "Destruction" then school = 3
                else school = 6
                end
            end
            val = GetSpellCritChance(school)
        else
            val = GetCritChance() -- Crítico Físico
        end
    -- Stats base
    elseif stat == "STR" then val = select(2, UnitStat("player", 1))
    elseif stat == "AGI" then val = select(2, UnitStat("player", 2))
    elseif stat == "STA" then val = select(2, UnitStat("player", 3))
    elseif stat == "INT" then val = select(2, UnitStat("player", 4))
    elseif stat == "SPIRIT" then val = select(2, UnitStat("player", 5))
    -- Spell Power (Especial para Sombras)
    elseif stat == "SP" then
        local spec = GearAnalyzer:GetCurrentSpecEnhanced()
        if spec == "Sombras" then
            val = GetSpellBonusDamage(6) -- 6 = Sombras
        else
            val = GetSpellBonusDamage(2) -- 2 = Holy/Base
        end
    -- Attack Power
    elseif stat == "AP" then val = select(1, UnitAttackPower("player"))
    elseif stat == "RAP" then val = select(1, UnitRangedAttackPower("player"))
    -- Defensive
    elseif stat == "ARMOR" then val = select(2, UnitArmor("player"))
    elseif stat == "DODGE" then val = GetDodgeChance()
    elseif stat == "PARRY" then val = GetParryChance()
    end
    
    return val or 0
end


function Tab:FormatStat(val, stat, isPercent)
    -- Stats que se muestran como porcentaje
    if stat == "HIT_SPELL" or stat == "HIT" or stat == "EXPERTISE" or stat == "CRIT" or stat == "DODGE" or stat == "PARRY" or isPercent then
        return string.format("%.1f%%", val)
    end
    
    -- Defense se muestra con el valor exacto
    if stat == "DEFENSE" then
        return string.format("%.0f", val)
    end
    
    -- El resto se muestra como enteros (ratings, stats base)
    return string.format("%.0f", val)
end



function Tab:GetOrCreateRow(i, isHeader)
    if self.rows[i] then return self.rows[i] end
    
    local row = CreateFrame("Frame", nil, self.content)
    row:SetSize(self.content:GetWidth() - 20, isHeader and 26 or 42)
    
    -- Fondo de la fila (Premium Look)
    local bg = row:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.03)
    row.bg = bg
    
    -- Icono
    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(24, 24)
    icon:SetPoint("LEFT", 8, 0)
    row.icon = icon
    
    -- Texto
    local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("LEFT", 40, 0)
    text:SetJustifyH("LEFT")
    row.text = text
    
    -- Barra de progreso
    local bar = CreateFrame("StatusBar", nil, row)
    bar:SetSize(180, 14)
    bar:SetPoint("RIGHT", -50, 0)
    bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    
    local barBg = bar:CreateTexture(nil, "BACKGROUND")
    barBg:SetAllPoints(bar)
    barBg:SetTexture(0, 0, 0, 0.6)
    row.barBg = barBg
    
    local barText = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    barText:SetPoint("CENTER", bar, "CENTER")
    row.barText = barText
    
    row.bar = bar
    self.rows[i] = row
    return row
end


