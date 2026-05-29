-- ============================================================
-- GearAnalyzer: Process & Events
-- Lifecycle, FullReload, and Event Handlers
-- ============================================================

function GearAnalyzer:PLAYER_LOGIN()
    if not self.charDB then self:InitializeAddonData() end
    self:SetupMinimapButton()
    
    self.lastHandledSpec = nil
    self.lastSpec = nil
    self.cachedCurrentSpec = nil
    self.cachedCurrentSpecClass = nil
    if self.evaluationCache then wipe(self.evaluationCache) end
    if self.itemDataCache then wipe(self.itemDataCache) end
    if self.socketColorsCache then wipe(self.socketColorsCache) end
    if self.scoreCache then wipe(self.scoreCache) end
    
    self.isReady = false
    self.warmupStartTime = GetTime()
    self:ScheduleTimer("WarmupBiS", 1)
    self:ScheduleTimer("FullReload", 6)
end

function GearAnalyzer:ForceReady()
    self.isReady = true
    if self.frame and self.frame:IsShown() then
        self:FullReload()
    end
end

function GearAnalyzer:WarmupBiS(retryCount)
    if self.isReady then return end
    retryCount = retryCount or 0
    
    if self.uiOpenedTime and (GetTime() - self.uiOpenedTime) > 2 then
        self:ForceReady()
        return
    end

    if (GetTime() - (self.warmupStartTime or 0)) > 10 then
        self:ForceReady()
        return
    end

    local class = self:GetClassToken()
    local spec = self:GetCurrentSpecEnhanced()
    local phase = self.db.profile.phase or self.db.profile.gamePhase or "T10"
    
    local specBiS = GA_BiSLists[class] and GA_BiSLists[class][spec] and GA_BiSLists[class][spec][phase]
    if not specBiS then 
        self:ForceReady()
        return 
    end
    
    local missingData = 0
    local totalData = 0
    
    for slotID, top6 in pairs(specBiS) do
        if type(top6) == "table" then
            for i = 1, 6 do
                local id = top6[i]
                if id and id > 0 then
                    totalData = totalData + 1
                    local name = GetItemInfo(id)
                    if not name then missingData = missingData + 1 end
                end
            end
        end
    end

    local isMostlyCached = (totalData == 0) or (missingData / totalData < 0.2)
    if not isMostlyCached and retryCount < 4 then
        self:ScheduleTimer("WarmupBiS", 2, retryCount + 1)
    else
        self:ForceReady()
    end
end

function GearAnalyzer:OnCombatEnter()
    self.inCombat = true
    if self.updateTimer then self:CancelTimer(self.updateTimer) end
    if self.talentTimer then self:CancelTimer(self.talentTimer) end
    if self.statsTimer then self:CancelTimer(self.statsTimer) end
end

function GearAnalyzer:OnCombatLeave()
    self.inCombat = false
    if self.frame and self.frame:IsShown() then
        self:FullReload()
    end
end

function GearAnalyzer:OnTalentChanged()
    if self.inCombat or InCombatLockdown() then return end
    if self.talentTimer then self:CancelTimer(self.talentTimer) end
    
    self.talentTimer = self:ScheduleTimer(function()
        self.lastHandledSpec = nil
        self.lastSpec = nil
        self.cachedCurrentSpec = nil
        self.cachedCurrentSpecClass = nil
        self._equipLinkCacheDirty = true -- Forzar re-escaneo de equipo en cambio de talentos
        -- No wipear itemDataCache (stats de items no cambian con talentos)
        -- No wipear socketColorsCache (colores de ranura no cambian con talentos)
        -- Solo invalidar evaluación (depende de spec) y scores
        if self.evaluationCache then wipe(self.evaluationCache) end
        if self.scoreCache then wipe(self.scoreCache) end
        if self._cacheCounts then self._cacheCounts.eval = 0; self._cacheCounts.score = 0 end

        if (self.frame and self.frame:IsShown()) or (self.guideFrame and self.guideFrame:IsShown()) then
            self:FullReload()
        end
    end, 3.0)
end

function GearAnalyzer:OnGearChanged()
    if self.inCombat or InCombatLockdown() then return end
    
    if self.updateTimer then self:CancelTimer(self.updateTimer) end
    
    self.updateTimer = self:ScheduleTimer(function()
        self.cachedCurrentSpec = nil
        self.cachedCurrentSpecClass = nil
        -- itemDataCache y socketColorsCache no cambian (son datos de items, no del equipo)
        -- scoreCache tampoco necesita invalidarse (los items siguen siendo los mismos)
        -- evaluationCache tampoco (la evaluación de un item no depende de qué items tengas puestos)
        self._equipLinkCacheDirty = true
        if self.bisTooltipCache then wipe(self.bisTooltipCache) end

        local isPJOpen = (self.frame and self.frame:IsShown()) or (self.guideFrame and self.guideFrame:IsShown())
        if isPJOpen then
            self:FullReload()
        end
    end, 1.0)
end

function GearAnalyzer:FullReload()
    if self.evaluationCache then wipe(self.evaluationCache) end
    if self.itemDataCache then wipe(self.itemDataCache) end
    if self.socketColorsCache then wipe(self.socketColorsCache) end
    if self.scoreCache then wipe(self.scoreCache) end
    if self.bisTooltipCache then wipe(self.bisTooltipCache) end
    if self._cacheCounts then
        self._cacheCounts.item = 0
        self._cacheCounts.bis = 0
        self._cacheCounts.eval = 0
        self._cacheCounts.score = 0
    end
    
    self.cachedProfessions = nil
    self.cachedCurrentSpec = nil 
    self.cachedCurrentSpecClass = nil

    local currentSpec = self:GetCurrentSpecEnhanced()
    local class = self:GetClassToken()
    self.temp_currentSpec = currentSpec
    self.temp_currentClass = class
    
    -- CARGA DINÁMICA: Si cambiamos de clase (simulación), cargar sus datos
    if self.LoadClassData then
        self:LoadClassData(class)
        -- También cargar la clase de la guía si es diferente
        local guideClass = self:GetClassToken(false)
        if guideClass and guideClass ~= class then
            self:LoadClassData(guideClass)
        end
    end

    if self.lastHandledSpec ~= currentSpec or self.lastHandledClass ~= class then
        self.lastHandledSpec = currentSpec
        self.lastHandledClass = class
        if self.db and self.db.profile then
            self.db.profile.top6 = nil
            self.db.profile.bis = nil
        end
        -- Reconstruir índice de BiS para los tooltips si la clase cambió
        if self.initBisTooltip then self:initBisTooltip() end
    end

    if self.SyncWithBiSTooltip then
        local phase = (self.charDB and self.charDB.gamePhase) or "T10"
        self:SyncWithBiSTooltip(phase)
    end
    
    self:ScanEquipment()
    self:ScanBagsAndBank()
    self:AnalyzeEquipment()
    
    local UI = self:GetModule("UI", true)
    if UI and ((self.frame and self.frame:IsShown()) or (self.guideFrame and self.guideFrame:IsShown())) then
        UI:Update()
    end
end
