-- ============================================================
-- GearAnalyzer: Druid (DRUID)
-- Data-on-Demand Module
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

function GearAnalyzer:LoadDruidData()
    if self.ClassData["DRUID"] then return end

    self.ClassData["DRUID"] = {
        Glyphs = {
            ["Balance"] = {
                major = { 40916, 40923, 40921 }, -- Fuego estelar, Fuego lunar, Lluvia de estrellas
                minor = { 43335, 43331, 43674 }  -- Salvaje, Renacer, Carrerilla
            },
            ["Feral Cat"] = {
                major = { 40902, 40901, 45604 }, -- Destripar, Triturar, Rugido salvaje
                minor = { 43335, 43331, 43674 }  -- Salvaje, Renacer, Carrerilla
            },
            ["Feral Bear"] = {
                major = { 40897, 40896, 46372 }, -- Mazo, Regeneracion frenetica, Instintos de supervivencia
                minor = { 43335, 43331, 43334 }  -- Salvaje, Renacer, Rugido desafiante
            },
            ["Restoration"] = {
                major = { 45602, 45603, 50125 }, -- Crecimiento salvaje, Nutrir, Rejuvenecimiento rapido
                minor = { 43335, 43331, 43674 }  -- Salvaje, Renacer, Carrerilla
            }
        },
        Gems = {
            ["Balance"] = {
                meta = 41285, -- Diamante de llama celeste caótico (+21 Crítico / +3% CD)
                red = 40113, -- Rubí cárdeno rúnico (+23 SP)
                yellow = 40152, -- Ametrino pujante (+12 SP / +10 Crítico)
                blue = 40133, -- Piedra de terror purificada (+12 SP / +10 Espíritu)
                note = "SP > Crítico. Azules solo en Botas y Cinturón para activar Meta. Resto no respetan color."
            },
            ["Feral Cat"] = {
                meta = 41398, -- Diamante de asedio de tierra incansable (+21 Agilidad / +3% CD)
                red = 40117, -- Rubí cárdeno fracturado (+20 ArPen) o 40112 (Agi) / 40111 (Fuerza)
                yellow = 40147, -- Ametrino letal (+10 Agilidad / +10 Crítico)
                blue = 40117, -- ArPen por defecto
                prismatic = 49110, -- Lágrima de pesadilla
                prismaticSlot = "chest",
                note = "ArPen Hard Cap (1400) > Agilidad > Crítico. Usa Ametrino letal en amarillas."
            },
            ["Feral Bear"] = {
                meta = 41380, -- Diamante de asedio de tierra austero (+32 Aguante / +2% Armadura)
                red = 40130, -- Piedra de terror cambiante (+10 Agilidad / +15 Aguante)
                yellow = 40119, -- Circón majestuoso sólido (+30 Aguante)
                blue = 40119, -- Circón majestuoso sólido (+30 Aguante)
                note = "Prioridad: Agilidad (1600) > Aguante. Usa Ojo de Zul vívido (Hit/Stam) en amarillas si falta golpe."
            },
            ["Restoration"] = {
                meta = 41401, -- Diamante de asedio de tierra perspicaz (+21 Intelecto / Prob. Maná)
                red = 40113, -- Rubí cárdeno rúnico (+23 Poder con Hechizos)
                yellow = 40155, -- Ametrino temerario (+12 Poder con Hechizos / +10 Celeridad)
                blue = 40133, -- Piedra de terror purificada (+12 Poder con Hechizos / +10 Espíritu)
                note = "Prioridad: Celeridad (856) > SP. Usa Azules (SP/Espíritu) solo para activar la Meta."
            }
        },
        TalentTrees = {
            [1] = { name = "Balance", icon = "Interface\\Icons\\Spell_Nature_StarFall" },
            [2] = { name = "Combate Feral", icon = "Interface\\Icons\\Ability_Druid_CatForm" },
            [3] = { name = "Restauración", icon = "Interface\\Icons\\Spell_Nature_HealingTouch" },
        },
        Caps = {
            ["Balance"] = {
                role = "Caster",
                hitCap = { percent = 9, rating = 237, note = "9% Uni / 14% Multi" },
                priorities = {
                    { stat = "HASTE", cap = 1000, label = "Celeridad" },
                    { stat = "SP", label = "Poder de Hechizos" },
                    { stat = "CRIT", cap = 50, label = "Crítico", isPercent = true, note = "50% Buffed/Pollo" },
                }
            },
            ["Feral Cat"] = {
                role = "Melee",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "ARPEN", cap = 1400, label = "Penetración de Armadura", note = "Hard Cap" },
                    { stat = "AGI", label = "Agilidad" },
                    { stat = "CRIT", cap = 69, label = "Crítico", isPercent = true, note = "Objetivo 69% Raid Buffed" },
                },
                gemAdjustments = {
                    { stat = "HIT", target = 263, yellow = 40162 }, -- Ametrino de precisión (Pericia/Golpe)
                    { stat = "EXP", target = 214, yellow = 40162 }, -- Ametrino de precisión (Pericia/Golpe)
                }
            },
            ["Feral Bear"] = {
                role = "Tank",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "AGI", cap = 1600, label = "Agilidad", note = "Armor/Esquive" },
                    { stat = "STA", label = "Aguante", note = "EH (Salud Efectiva)" },
                },
                gemAdjustments = {
                    { stat = "HIT", target = 263, yellow = 40161 }, -- Ojo de Zul vívido (Golpe/Aguante)
                }
            },
            ["Restoration"] = {
                role = "Healer",
                priorities = {
                    { stat = "HASTE", cap = 856, label = "Celeridad", note = "Cap GCD" },
                    { stat = "SP", label = "Poder de Hechizos" },
                }
            }
        },
        Enchants = {
            ["Balance"] = {
                ["weapon"]    = { 3834, 3854 },   -- Poder con hechizos (1H/2H)
                ["head"]      = 3820,   -- Arcanum de misterios ardientes
                ["shoulders"] = 3810,   -- Inscripción de la tormenta superior
                ["back"]      = 3831,   -- Velocidad superior (+23 celeridad)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 2332,   -- Poder con hechizos excelente (+30)
                ["hands"]     = 3246,   -- Poder con hechizos excepcional (+28)
                ["legs"]      = 3719,   -- Hilo de hechizo luminoso
                ["feet"]      = 3826,   -- Caminante de hielo
                ["waist"]     = 3731,   -- Hebilla eterna
                ["offhand"]   = 0,
            },
            ["Feral Cat"] = {
                ["weapon"]    = 3789,   -- Rabiar
                ["head"]      = 3817,   -- Arcanum de tormentos
                ["shoulders"] = 3808,   -- Inscripción del hacha superior
                ["back"]      = 3296,   -- Agilidad mayor (+22)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 3845,   -- Asalto superior (+50 PA)
                ["hands"]     = 1603,   -- Triturador (+44 PA)
                ["legs"]      = 3823,   -- Armadura para pierna de escama de hielo
                ["feet"]      = 3826,   -- Caminante de hielo
                ["waist"]     = 3731,   -- Hebilla eterna
                ["offhand"]   = 0,
            },
            ["Feral Bear"] = {
                ["weapon"]    = 2673,   -- Mangosta
                ["head"]      = 3818,   -- Arcanum del protector leal
                ["shoulders"] = 3811,   -- Inscripción del pináculo superior
                ["back"]      = 3294,   -- Armadura poderosa (+225)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 3850,   -- Aguante mayor (+40)
                ["hands"]     = 3253,   -- A2% amenaza
                ["legs"] = 3822, -- Armadura para pierna de pellejo de escarcha
                ["feet"] = { 3232, 1075 }, -- Vitalidad colmillarr
                ["waist"] = 3731, -- Hebilla eterna
                ["offhand"] = 0,
            },
            ["Restoration"] = {
                ["weapon"] = { 3834, 3854 }, -- Poder con hechizos (1H/2H)
                ["head"] = 3820, -- Arcanum de misterios ardientes
                ["shoulders"] = 3810, -- Inscripción de la tormenta superior
                ["back"] = 3831, -- Velocidad superior (+23 celeridad)
                ["chest"] = 3832, -- Estadísticas potentes (+10)
                ["wrists"] = 2332, -- Poder con hechizos excelente (+30)
                ["hands"] = 3246, -- Poder con hechizos excepcional (+28)
                ["legs"] = 3719, -- Hilo de hechizo luminoso
                ["feet"] = 1147, -- Espíritu superior (+18)
                ["waist"] = 3731, -- Hebilla eterna
                ["offhand"] = 0,
            }
        },
        Talents = {
            ["Balance"] = {
                label = "58/0/13 - Druida Equilibrio PVE (Starfall)",
                exportCode = "5302003115331303013335310231000000000000000000000000000000205003012000000000000000000",
                [1] = { name = "Balance", points = 58 },
                [2] = { name = "Feral", points = 0 },
                [3] = { name = "Restoration", points = 13 }
            },
            ["Feral Cat"] = {
                label = "0/55/16 - Druida Feral Gato PVE (ArPen)",
                exportCode = "0000000000000000000000000000553202032322010053100030312511203503012000000000000000000",
                [1] = { name = "Balance", points = 0 },
                [2] = { name = "Feral", points = 55 },
                [3] = { name = "Restoration", points = 16 }
            },
            ["Feral Bear"] = {
                label = "0/56/15 - Druida Feral Oso PVE (Tank)",
                exportCode = "0000000000000000000000000000503232130322010353100300313511203503002000000000000000000",
                [1] = { name = "Balance", points = 0 },
                [2] = { name = "Feral", points = 56 },
                [3] = { name = "Restoration", points = 15 }
            },
            ["Restoration"] = {
                label = "14/0/57 - Druida Restauración PVE (Tree of Life)",
                exportCode = "0532003100000000000000000000000000000000000000000000000000230023312130502531053313051",
                [1] = { name = "Balance", points = 14 },
                [2] = { name = "Feral", points = 0 },
                [3] = { name = "Restoration", points = 57 }
            }
        }
    }

    -- Clone to support both Feral Cat / Feral dps and Feral Bear / Feral tank
    local druid = self.ClassData["DRUID"]
    if druid then
        if druid.Glyphs then
            druid.Glyphs["Feral dps"] = druid.Glyphs["Feral Cat"]
            druid.Glyphs["Feral tank"] = druid.Glyphs["Feral Bear"]
        end
        if druid.Gems then
            druid.Gems["Feral dps"] = druid.Gems["Feral Cat"]
            druid.Gems["Feral tank"] = druid.Gems["Feral Bear"]
        end
        if druid.Caps then
            druid.Caps["Feral dps"] = druid.Caps["Feral Cat"]
            druid.Caps["Feral tank"] = druid.Caps["Feral Bear"]
        end
        if druid.Enchants then
            druid.Enchants["Feral dps"] = druid.Enchants["Feral Cat"]
            druid.Enchants["Feral tank"] = druid.Enchants["Feral Bear"]
        end
        if druid.Talents then
            druid.Talents["Feral dps"] = druid.Talents["Feral Cat"]
            druid.Talents["Feral tank"] = druid.Talents["Feral Bear"]
        end
    end

    -- Data Mapping (Optional internal lists)
    -- Only populate GA_BiSLists if you have actual data to provide.
    -- The system will automatically sync from Bistooltip if GA_BiSLists is empty.
end

