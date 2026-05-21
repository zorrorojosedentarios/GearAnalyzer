-- ============================================================
-- GearAnalyzer: Druid (DRUID)
-- Data-on-Demand Module
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

function GearAnalyzer:LoadDruidData()
    if rawget(self.ClassData, "DRUID") then return end

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
                red = 40117, -- Rubí cárdeno fracturado (+20 ArPen) o 40112 (Agi)
                yellow = 40147, -- Ametrino letal (+10 Agilidad / +10 Crítico)
                blue = 40117, -- ArPen por defecto
                prismatic = 49110, -- Lágrima de pesadilla
                prismaticSlot = "chest",
                note = "PROGRESIÓN: Inicio Full Agilidad (+20 Agi). Punto de Quiebre: al alcanzar ~750-800 ArPen pasivo (T10+ICC), cambiar a Full ArPen (+20 ArPen) hasta Hard Cap 1400."
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
                hitCap = { percent = 10, rating = 263, note = "10% (263) con Balance of Power" },
                priorities = {
                    { stat = "HASTE", cap = 585, label = "Celeridad", note = "Soft 401 (sin buffs) / Hard 585 (con Tótem y Aura en Raid)" },
                    { stat = "SP", label = "Poder de Hechizos" },
                    { stat = "CRIT", cap = 50, label = "Crítico", isPercent = true, note = "50% Buffed/Pollo" },
                },
                gemAdjustments = {
                    { stat = "HIT", target = 263, yellow = 40153 }, -- Ametrino velado (SP/Golpe)
                    { stat = "HASTE", target = 585, yellow = 40155 }, -- Ametrino temerario (SP/Celeridad)
                }
            },
            ["Feral Cat"] = {
                role = "Melee",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "AGI", label = "Agilidad", note = "Soft Cap (Inicio: Full Agilidad)" },
                    { stat = "ARPEN", cap = 1400, label = "Penetración de Armadura", note = "Hard Cap (1400). Cambiar gemas al alcanzar ~750-800 ArPen pasivo con ICC." },
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
                    { stat = "STA", label = "Aguante", note = "Full Aguante (Sin cap de Defensa - Inmune por talento)" },
                    { stat = "AGI", cap = 1600, label = "Agilidad", note = "Armor/Esquive (La agi les da armadura y esquive del cuero)" },
                },
                gemAdjustments = {
                    { stat = "HIT", target = 263, yellow = 40161 }, -- Ojo de Zul vívido (Golpe/Aguante)
                }
            },
            ["Restoration"] = {
                role = "Healer",
                priorities = {
                    { stat = "HASTE", cap = 856, label = "Celeridad", note = "Soft 735 (GCD Rejuvenecimiento 1s) / Hard 856 (5 Nutrir en Alivio Presto)" },
                    { stat = "SP", label = "Poder de Hechizos" },
                    { stat = "SPI", label = "Espíritu", note = "Activa talento de SP (Vivir del Terreno)" },
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
                ["legs"]      = 3822,   -- Armadura para pierna de pellejo de escarcha
                ["feet"]      =  { 3232, 1075 },   -- Vitalidad colmillarr
                ["waist"]     = 3731,   -- Hebilla eterna
                ["offhand"]   = 0,
            },
            ["Restoration"] = {
                ["weapon"]    = { 3834, 3854 },   -- Poder con hechizos (1H/2H)
                ["head"]      = 3820,   -- Arcanum de misterios ardientes
                ["shoulders"] = 3810,   -- Inscripción de la tormenta superior
                ["back"]      = 3831,   -- Velocidad superior (+23 celeridad)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 2332,   -- Poder con hechizos excelente (+30)
                ["hands"]     = 3246,   -- Poder con hechizos excepcional (+28)
                ["legs"]      = 3719,   -- Hilo de hechizo luminoso
                ["feet"]      = 1147,   -- Espíritu superior (+18)
                ["waist"]     = 3731,   -- Hebilla eterna
                ["offhand"]   = 0,
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

    GA_BiSLists["DRUID"] = GA_BiSLists["DRUID"] or {}
GA_BiSLists["DRUID"]["Balance"] = {};
GA_BiSLists["DRUID"]["Balance"]["PR"] = {};
GA_BiSLists["DRUID"]["Balance"]["T9"] = {};
GA_BiSLists["DRUID"]["Balance"]["T10"] = {};
GA_BiSLists["DRUID"]["Balance"]["RS"] = {};
GA_BiSLists["DRUID"]["Balance"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40049 } }, [1] = 37180, [2] = 39545, [3] = 43995, [4] = 44907, [5] = 42554, [6] = 41984 }
GA_BiSLists["DRUID"]["Balance"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40680, [2] = 44658, [3] = 39472, [4] = 40427, [5] = 37595, [6] = 42024 }
GA_BiSLists["DRUID"]["Balance"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40049 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40014 } }, [1] = 34210, [2] = 39548, [3] = 37673, [4] = 37655, [5] = 37196, [6] = 37652 }
GA_BiSLists["DRUID"]["Balance"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 41610, [2] = 39241, [3] = 42057, [4] = 36983, [5] = 44242, [6] = 34242 }
GA_BiSLists["DRUID"]["Balance"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 39547, [2] = 40526, [3] = 39396, [4] = 43401, [5] = 42102, [6] = 34399 }
GA_BiSLists["DRUID"]["Balance"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 } }, [1] = 37361, [2] = 39252, [3] = 37884, [4] = 37696, [5] = 37725, [6] = 44200 }
GA_BiSLists["DRUID"]["Balance"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 39544, [2] = 39192, [3] = 34344, [4] = 42113, [5] = 37172, [6] = 37825 }
GA_BiSLists["DRUID"]["Balance"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40014 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40696, [2] = 37408, [3] = 37680, [4] = 37850, [5] = 44181, [6] = 37643 }
GA_BiSLists["DRUID"]["Balance"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 } }, [1] = 37791, [2] = 37854, [3] = 44931, [4] = 34181, [5] = 37389, [6] = 37369 }
GA_BiSLists["DRUID"]["Balance"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 44202, [2] = 40519, [3] = 44930, [4] = 37730, [5] = 37218, [6] = 37629 }
GA_BiSLists["DRUID"]["Balance"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40585, [2] = 43253, [3] = 39389, [4] = 42644, [5] = 44283, [6] = 37694 }
GA_BiSLists["DRUID"]["Balance"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 37873, [2] = 40682, [3] = 42395, [4] = 39229, [5] = 37660, [6] = 32483 }
GA_BiSLists["DRUID"]["Balance"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 41384, [2] = 40489, [3] = 39424, [4] = 39423, [5] = 37169, [6] = 44173 }
GA_BiSLists["DRUID"]["Balance"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 40698, [2] = 39199, [3] = 37134, [4] = 44210, [5] = 37718, [6] = 37051 }
GA_BiSLists["DRUID"]["Balance"]["PR"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40712, [2] = 32387, [3] = 38360, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Balance"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40153 } }, [1] = 48171, [2] = 48164, [3] = 47693, [4] = 48158, [5] = 45150, [6] = 46191 }
GA_BiSLists["DRUID"]["Balance"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 47144, [2] = 45133, [3] = 47957, [4] = 45699, [5] = 47747, [6] = 45539 }
GA_BiSLists["DRUID"]["Balance"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 48168, [2] = 47713, [3] = 45186, [4] = 47923, [5] = 46068, [6] = 45136 }
GA_BiSLists["DRUID"]["Balance"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47552, [2] = 47095, [3] = 45242, [4] = 47089, [5] = 46042, [6] = 47553 }
GA_BiSLists["DRUID"]["Balance"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 48169, [2] = 47129, [3] = 47974, [4] = 47126, [5] = 47838, [6] = 45865 }
GA_BiSLists["DRUID"]["Balance"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 47143, [2] = 47927, [3] = 47141, [4] = 47663, [5] = 45275, [6] = 47066 }
GA_BiSLists["DRUID"]["Balance"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 48172, [2] = 46045, [3] = 47956, [4] = 47745, [5] = 46189, [6] = 45665 }
GA_BiSLists["DRUID"]["Balance"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47084, [2] = 47921, [3] = 47081, [4] = 47617, [5] = 45557, [6] = 47145 }
GA_BiSLists["DRUID"]["Balance"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47190, [2] = 47189, [3] = 48170, [4] = 45488, [5] = 47187, [6] = 48165 }
GA_BiSLists["DRUID"]["Balance"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47097, [2] = 47205, [3] = 47194, [4] = 47940, [5] = 45258, [6] = 45537 }
GA_BiSLists["DRUID"]["Balance"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 47237, [2] = 46046, [3] = 47928, [4] = 45297, [5] = 47618, [6] = 45451 }
GA_BiSLists["DRUID"]["Balance"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47188, [2] = 45518, [3] = 45148, [4] = 40255, [5] = 45866, [6] = 47182 }
GA_BiSLists["DRUID"]["Balance"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 47206, [2] = 46980, [3] = 45620, [4] = 46017, [5] = 46979, [6] = 45612 }
GA_BiSLists["DRUID"]["Balance"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 47064, [2] = 45617, [3] = 47958, [4] = 47053, [5] = 47742, [6] = 47146 }
GA_BiSLists["DRUID"]["Balance"]["T9"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 47670, [2] = 40321, [3] = 40712, [4] = 32387, [5] = 45270, [6] = 38360 }
GA_BiSLists["DRUID"]["Balance"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51290, [2] = 48171, [3] = 48164, [4] = 50661, [5] = 50679, [6] = 51837 }
GA_BiSLists["DRUID"]["Balance"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50724, [2] = 50658, [3] = 50005, [4] = 51863, [5] = 50609, [6] = 51894 }
GA_BiSLists["DRUID"]["Balance"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51292, [2] = 50643, [3] = 49991, [4] = 51859, [5] = 47713, [6] = 50715 }
GA_BiSLists["DRUID"]["Balance"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50628, [2] = 51826, [3] = 47095, [4] = 45242, [5] = 47552, [6] = 50668 }
GA_BiSLists["DRUID"]["Balance"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 51294, [2] = 50629, [3] = 50418, [4] = 47129, [5] = 50717, [6] = 50649 }
GA_BiSLists["DRUID"]["Balance"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51872, [2] = 50651, [3] = 49994, [4] = 47143, [5] = 50630, [6] = 50686 }
GA_BiSLists["DRUID"]["Balance"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50663, [2] = 51291, [3] = 51921, [4] = 50011, [5] = 51148, [6] = 50722 }
GA_BiSLists["DRUID"]["Balance"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50613, [2] = 50996, [3] = 47084, [4] = 47921, [5] = 50705, [6] = 49978 }
GA_BiSLists["DRUID"]["Balance"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 51293, [2] = 50694, [3] = 50056, [4] = 51146, [5] = 47189, [6] = 50696 }
GA_BiSLists["DRUID"]["Balance"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50699, [2] = 49890, [3] = 47205, [4] = 51899, [5] = 47194, [6] = 50665 }
GA_BiSLists["DRUID"]["Balance"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50398, [2] = 50664, [3] = 50714, [4] = 50614, [5] = 50636, [6] = 49977 }
GA_BiSLists["DRUID"]["Balance"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50365, [2] = 50348, [3] = 50360, [4] = 50353, [5] = 50357, [6] = 47188 }
GA_BiSLists["DRUID"]["Balance"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50734, [2] = 51815, [3] = 50608, [4] = 51939, [5] = 50731, [6] = 51943 }
GA_BiSLists["DRUID"]["Balance"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50719, [2] = 51922, [3] = 47064, [4] = 45617, [5] = 47958, [6] = 50635 }
GA_BiSLists["DRUID"]["Balance"]["T10"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50457, [2] = 47670, [3] = 40321, [4] = 40712, [5] = 32387, [6] = 45270 }
GA_BiSLists["DRUID"]["Balance"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51290, [2] = 48171, [3] = 48164, [4] = 50661, [5] = 50679, [6] = 51837 }
GA_BiSLists["DRUID"]["Balance"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50724, [2] = 50658, [3] = 50005, [4] = 51863, [5] = 50609, [6] = 51894 }
GA_BiSLists["DRUID"]["Balance"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51292, [2] = 50643, [3] = 49991, [4] = 51859, [5] = 47713, [6] = 50715 }
GA_BiSLists["DRUID"]["Balance"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 54583, [2] = 51826, [3] = 47095, [4] = 45242, [5] = 50628, [6] = 47552 }
GA_BiSLists["DRUID"]["Balance"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40153 } }, [1] = 51294, [2] = 50629, [3] = 50418, [4] = 47129, [5] = 50717, [6] = 50649 }
GA_BiSLists["DRUID"]["Balance"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 54582, [2] = 50651, [3] = 51872, [4] = 49994, [5] = 47143, [6] = 54584 }
GA_BiSLists["DRUID"]["Balance"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50663, [2] = 51291, [3] = 51921, [4] = 50011, [5] = 51148, [6] = 54560 }
GA_BiSLists["DRUID"]["Balance"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50613, [2] = 54562, [3] = 50996, [4] = 47084, [5] = 47921, [6] = 50705 }
GA_BiSLists["DRUID"]["Balance"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40153 } }, [1] = 51293, [2] = 50694, [3] = 50056, [4] = 51146, [5] = 47189, [6] = 50696 }
GA_BiSLists["DRUID"]["Balance"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50699, [2] = 49890, [3] = 47205, [4] = 51899, [5] = 47194, [6] = 50665 }
GA_BiSLists["DRUID"]["Balance"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40153 } }, [1] = 50398, [2] = 50664, [3] = 50714, [4] = 50614, [5] = 54563, [6] = 50636 }
GA_BiSLists["DRUID"]["Balance"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50365, [2] = 50348, [3] = 50360, [4] = 54588, [5] = 50353, [6] = 50357 }
GA_BiSLists["DRUID"]["Balance"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50734, [2] = 51815, [3] = 50608, [4] = 51939, [5] = 50731, [6] = 51943 }
GA_BiSLists["DRUID"]["Balance"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50719, [2] = 51922, [3] = 47064, [4] = 45617, [5] = 47958, [6] = 50635 }
GA_BiSLists["DRUID"]["Balance"]["RS"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50457, [2] = 47670, [3] = 40321, [4] = 40712, [5] = 32387, [6] = 45270 }
GA_BiSLists["DRUID"]["Feral tank"] = {};
GA_BiSLists["DRUID"]["Feral tank"]["PR"] = {};
GA_BiSLists["DRUID"]["Feral tank"]["T9"] = {};
GA_BiSLists["DRUID"]["Feral tank"]["T10"] = {};
GA_BiSLists["DRUID"]["Feral tank"]["RS"] = {};
GA_BiSLists["DRUID"]["Feral tank"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 37293, [2] = 39399, [3] = 44908, [4] = 39553, [5] = 42550, [6] = 43403 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40023 } }, [1] = 42646, [2] = 39246, [3] = 44659, [4] = 40679, [5] = 42021, [6] = 40678 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 } }, [1] = 43481, [2] = 39556, [3] = 37139, [4] = 37593, [5] = 34392, [6] = 44190 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 } }, [1] = 43565, [2] = 43988, [3] = 43406, [4] = 42061, [5] = 37840, [6] = 37728 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 43590, [2] = 43990, [3] = 39554, [4] = 37165, [5] = 34211, [6] = 44303 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 } }, [1] = 37183, [2] = 41830, [3] = 39247, [4] = 37853, [5] = 44203, [6] = 37366 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 39557, [2] = 39299, [3] = 37409, [4] = 37846, [5] = 37678, [6] = 44397 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 43591, [2] = 37194, [3] = 41827, [4] = 40694, [5] = 43484, [6] = 37243 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 43286, [2] = 39555, [3] = 37644, [4] = 37374, [5] = 37890, [6] = 44179 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 43592, [2] = 44893, [3] = 41828, [4] = 37841, [5] = 43312, [6] = 44297 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 37784, [2] = 43582, [3] = 43993, [4] = 42643, [5] = 37591, [6] = 37257 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 44253, [2] = 37220, [3] = 44063, [4] = 42341, [5] = 40767, [6] = 44323 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 46098 } }, [1] = 37883, [2] = 39422, [3] = 40497, [4] = 37190, [5] = 41257, [6] = 43409 }
GA_BiSLists["DRUID"]["Feral tank"]["PR"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 38365, [2] = 33509, [3] = -1, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 48204, [2] = 47689, [3] = 49471, [4] = 48211, [5] = 49473, [6] = 48214 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 47133, [2] = 47133, [3] = 47116, [4] = 47939, [5] = 47060, [6] = 45517 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 48207, [2] = 45245, [3] = 48208, [4] = 47708, [5] = 47972, [6] = 48217 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47545, [2] = 47549, [3] = 47547, [4] = 47063, [5] = 48673, [6] = 45461 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47004, [2] = 48206, [3] = 45473, [4] = 47599, [5] = 48209, [6] = 47004 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 45611, [2] = 47155, [3] = 47581, [4] = 45869, [5] = 47151, [6] = 45108 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 48203, [2] = 48212, [3] = 46043, [4] = 46158, [5] = 45325, [6] = 47945 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47112, [2] = 47107, [3] = 46095, [4] = 45555, [5] = 45829, [6] = 45491 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 46975, [2] = 48205, [3] = 45536, [4] = 46974, [5] = 48210, [6] = 45846 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47077, [2] = 47919, [3] = 47071, [4] = 45232, [5] = 47608, [6] = 45564 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47955, [2] = 47731, [3] = 45471, [4] = 49489, [5] = 47075, [6] = 47157 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47088, [2] = 45158, [3] = 47080, [4] = 46021, [5] = 47216, [6] = 47735 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 46098 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47130, [2] = 47239, [3] = 45533, [4] = 47519, [5] = 45613, [6] = 47979 }
GA_BiSLists["DRUID"]["Feral tank"]["T9"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 45509, [2] = 47668, [3] = 38365, [4] = 33509, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 51296, [2] = 50713, [3] = 50073, [4] = 51143, [5] = 48204, [6] = 51866 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50682, [2] = 50023, [3] = 50627, [4] = 50633, [5] = 47133, [6] = 50195 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51299, [2] = 50646, [3] = 49987, [4] = 51140, [5] = 45245, [6] = 48207 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50718, [2] = 50466, [3] = 50653, [4] = 47545, [5] = 50074, [6] = 47549 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50656, [2] = 51298, [3] = 50001, [4] = 50972, [5] = 51141, [6] = 47004 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50670, [2] = 47155, [3] = 50333, [4] = 51820, [5] = 45611, [6] = 47581 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51295, [2] = 50675, [3] = 50021, [4] = 50982, [5] = 51144, [6] = 48203 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50707, [2] = 50995, [3] = 47112, [4] = 50067, [5] = 51925, [6] = 47107 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51297, [2] = 50697, [3] = 50042, [4] = 51889, [5] = 49899, [6] = 51142 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50607, [2] = 49895, [3] = 49950, [4] = 47077, [5] = 51856, [6] = 47919 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50622, [2] = 50404, [3] = 50185, [4] = 50604, [5] = 50678, [6] = 50618 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50364, [2] = 47088, [3] = 50344, [4] = 50361, [5] = 50356, [6] = 47080 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 46098 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50735, [2] = 50727, [3] = 50603, [4] = 50695, [5] = 50425, [6] = 51945 }
GA_BiSLists["DRUID"]["Feral tank"]["T10"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50456, [2] = 45509, [3] = 47668, [4] = 38365, [5] = 33509, [6] = -1 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 51296, [2] = 50713, [3] = 50073, [4] = 51143, [5] = 48204, [6] = 51866 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50682, [2] = 50023, [3] = 50627, [4] = 50633, [5] = 47133, [6] = 54581 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51299, [2] = 50646, [3] = 49987, [4] = 51140, [5] = 45245, [6] = 48207 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50718, [2] = 50466, [3] = 50653, [4] = 47545, [5] = 50074, [6] = 47549 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50656, [2] = 51298, [3] = 50001, [4] = 50972, [5] = 54561, [6] = 51141 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 54580, [2] = 50670, [3] = 53126, [4] = 47155, [5] = 50333, [6] = 51820 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51295, [2] = 50675, [3] = 50021, [4] = 50982, [5] = 51144, [6] = 48203 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50707, [2] = 50995, [3] = 47112, [4] = 50067, [5] = 51925, [6] = 47107 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51297, [2] = 50697, [3] = 50042, [4] = 51889, [5] = 49899, [6] = 51142 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50607, [2] = 49895, [3] = 49950, [4] = 47077, [5] = 51856, [6] = 47919 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50622, [2] = 54576, [3] = 50404, [4] = 50185, [5] = 50604, [6] = 50678 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50364, [2] = 47088, [3] = 54591, [4] = 50344, [5] = 50361, [6] = 50356 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 46098 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50735, [2] = 50727, [3] = 50603, [4] = 50695, [5] = 50425, [6] = 51945 }
GA_BiSLists["DRUID"]["Feral tank"]["RS"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50456, [2] = 45509, [3] = 47668, [4] = 38365, [5] = 33509, [6] = -1 }
GA_BiSLists["DRUID"]["Feral dps"] = {};
GA_BiSLists["DRUID"]["Feral dps"]["PR"] = {};
GA_BiSLists["DRUID"]["Feral dps"]["T9"] = {};
GA_BiSLists["DRUID"]["Feral dps"]["T10"] = {};
GA_BiSLists["DRUID"]["Feral dps"]["RS"] = {};
GA_BiSLists["DRUID"]["Feral dps"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 37293, [2] = 39399, [3] = 39553, [4] = 42550, [5] = 34244, [6] = 34404 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40678, [2] = 44659, [3] = 39146, [4] = 39421, [5] = 42645, [6] = 37861 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39997 } }, [1] = 37139, [2] = 39237, [3] = 39556, [4] = 43481, [5] = 34392, [6] = 37593 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 43406, [2] = 39404, [3] = 39297, [4] = 37647, [5] = 38614, [6] = 37840 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40014 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40014 } }, [1] = 39554, [2] = 43990, [3] = 37219, [4] = 44303, [5] = 37165, [6] = 34397 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 } }, [1] = 44203, [2] = 39247, [3] = 37366, [4] = 37853, [5] = 41830, [6] = 37117 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 39997 } }, [1] = 39557, [2] = 37409, [3] = 39299, [4] = 34370, [5] = 37846, [6] = 37678 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40014 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40014 } }, [1] = 40694, [2] = 43484, [3] = 37194, [4] = 39279, [5] = 37243, [6] = 37714 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 } }, [1] = 37644, [2] = 39224, [3] = 39555, [4] = 44179, [5] = 34188, [6] = 37374 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44589 } }, [1] = 44297, [2] = 39196, [3] = 37666, [4] = 37841, [5] = 44893, [6] = 43312 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40586, [2] = 42642, [3] = 40474, [4] = 43993, [5] = 39401, [6] = 37642 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 44253, [2] = 40684, [3] = 39257, [4] = 37166, [5] = 37723, [6] = 37390 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 37883, [2] = 40497, [3] = 39422, [4] = 41257, [5] = 37848, [6] = 37733 }
GA_BiSLists["DRUID"]["Feral dps"]["PR"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40713, [2] = 38365, [3] = -1, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40142 } }, [1] = 48204, [2] = 47689, [3] = 49471, [4] = 48211, [5] = 49328, [6] = 45523 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47060, [2] = 45945, [3] = 45459, [4] = 47915, [5] = 49485, [6] = 47110 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 48207, [2] = 45245, [3] = 47708, [4] = 48208, [5] = 45677, [6] = 47972 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47545, [2] = 47547, [3] = 48673, [4] = 45461, [5] = 46032, [6] = 46971 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40142 } }, [1] = 48206, [2] = 47599, [3] = 47954, [4] = 45453, [5] = 47004, [6] = 45473 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40118 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40118 } }, [1] = 47155, [2] = 45869, [3] = 45611, [4] = 47581, [5] = 47151, [6] = 40186 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 48203, [2] = 47945, [3] = 46043, [4] = 45325, [5] = 48212, [6] = 47719 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47112, [2] = 46095, [3] = 47107, [4] = 45829, [5] = 45547, [6] = 45555 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 45536, [2] = 46975, [3] = 48205, [4] = 46974, [5] = 48210, [6] = 45141 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44589 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47077, [2] = 47919, [3] = 47071, [4] = 47608, [5] = 45232, [6] = 45564 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 45608, [2] = 47075, [3] = 47934, [4] = 46048, [5] = 45157, [6] = 47703 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45931, [2] = 47131, [3] = 47115, [4] = 45522, [5] = 47734, [6] = 45609 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47130, [2] = 47239, [3] = 47519, [4] = 45613, [5] = 45533, [6] = 46033 }
GA_BiSLists["DRUID"]["Feral dps"]["T9"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 47668, [2] = 40713, [3] = 39757, [4] = 38365, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51296, [2] = 50713, [3] = 51866, [4] = 51143, [5] = 47689, [6] = 48204 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50633, [2] = 50728, [3] = 50180, [4] = 51890, [5] = 50421, [6] = 51822 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51299, [2] = 51830, [3] = 45245, [4] = 51140, [5] = 50646, [6] = 48207 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47545, [2] = 51933, [3] = 50467, [4] = 47547, [5] = 50653, [6] = 48673 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40162 } }, [1] = 51298, [2] = 50656, [3] = 50001, [4] = 51923, [5] = 47599, [6] = 50972 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40162 } }, [1] = 50670, [2] = 50333, [3] = 47155, [4] = 45869, [5] = 45611, [6] = 47581 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40143 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50675, [2] = 51295, [3] = 50021, [4] = 51904, [5] = 51144, [6] = 50982 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50707, [2] = 50995, [3] = 50067, [4] = 47112, [5] = 51925, [6] = 46095 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 51297, [2] = 51142, [3] = 50697, [4] = 49899, [5] = 50042, [6] = 51841 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44589 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50607, [2] = 47077, [3] = 51856, [4] = 47919, [5] = 49950, [6] = 49895 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50402, [2] = 50604, [3] = 50618, [4] = 50678, [5] = 51878, [6] = 51900 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 50343, [3] = 50362, [4] = 47131, [5] = 50355, [6] = 47115 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50735, [2] = 50603, [3] = 50695, [4] = 50727, [5] = 51945, [6] = 50425 }
GA_BiSLists["DRUID"]["Feral dps"]["T10"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50456, [2] = 47668, [3] = 40713, [4] = 39757, [5] = 38365, [6] = -1 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51296, [2] = 50713, [3] = 51866, [4] = 51143, [5] = 47689, [6] = 48204 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50633, [2] = 50728, [3] = 50180, [4] = 54581, [5] = 51890, [6] = 50421 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51299, [2] = 51830, [3] = 45245, [4] = 51140, [5] = 50646, [6] = 48207 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47545, [2] = 51933, [3] = 50467, [4] = 47547, [5] = 50653, [6] = 48673 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40162 } }, [1] = 51298, [2] = 50656, [3] = 50001, [4] = 54561, [5] = 51923, [6] = 47599 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 54580, [2] = 50670, [3] = 50333, [4] = 47155, [5] = 45869, [6] = 45611 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40162 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50675, [2] = 51295, [3] = 50021, [4] = 51904, [5] = 51144, [6] = 50982 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50707, [2] = 50995, [3] = 50067, [4] = 47112, [5] = 51925, [6] = 46095 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 51297, [2] = 51142, [3] = 50697, [4] = 49899, [5] = 50042, [6] = 51841 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44589 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50607, [2] = 47077, [3] = 51856, [4] = 47919, [5] = 49950, [6] = 49895 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50402, [2] = 54576, [3] = 50604, [4] = 50618, [5] = 50678, [6] = 51878 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 54590, [2] = 50363, [3] = 54569, [4] = 50362, [5] = 47131, [6] = 50343 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50735, [2] = 50603, [3] = 50695, [4] = 50727, [5] = 51945, [6] = 50425 }
GA_BiSLists["DRUID"]["Feral dps"]["RS"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50456, [2] = 47668, [3] = 40713, [4] = 39757, [5] = 38365, [6] = -1 }
GA_BiSLists["DRUID"]["Restoration"] = {};
GA_BiSLists["DRUID"]["Restoration"]["PR"] = {};
GA_BiSLists["DRUID"]["Restoration"]["T9"] = {};
GA_BiSLists["DRUID"]["Restoration"]["T10"] = {};
GA_BiSLists["DRUID"]["Restoration"]["RS"] = {};
GA_BiSLists["DRUID"]["Restoration"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40017 } }, [1] = 37149, [2] = 39240, [3] = 43995, [4] = 34339, [5] = 37684, [6] = 44906 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 37683, [2] = 39392, [3] = 44658, [4] = 39232, [5] = 42023, [6] = 33281 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 40026 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 34209, [2] = 37673, [3] = 37368, [4] = 37196, [5] = 37655, [6] = 44370 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 37799, [2] = 41610, [3] = 39272, [4] = 37291, [5] = 42056, [6] = 43283 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 } }, [1] = 42102, [2] = 39538, [3] = 44180, [4] = 34398, [5] = 37236, [6] = 37258 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 } }, [1] = 37361, [2] = 39390, [3] = 37725, [4] = 34445, [5] = 44200, [6] = 37724 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 } }, [1] = 42113, [2] = 39543, [3] = 34342, [4] = 37798, [5] = 37261, [6] = 37858 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40017 } }, [1] = 37643, [2] = 39190, [3] = 39308, [4] = 44302, [5] = 40697, [6] = 37842 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 } }, [1] = 37791, [2] = 39408, [3] = 39191, [4] = 43495, [5] = 34386, [6] = 37189 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 44202, [2] = 39215, [3] = 39254, [4] = 37730, [5] = 43502, [6] = 37640 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 37694, [2] = 37192, [3] = 39250, [4] = 44283, [5] = 44934, [6] = 43408 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 37111, [2] = 37657, [3] = 44322, [4] = 42988, [5] = 37835, [6] = 36972 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62948 } }, [1] = 37360, [2] = 40488, [3] = 39423, [4] = 41384, [5] = 37169, [6] = 37384 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 40699, [2] = 37718, [3] = 44210, [4] = 37051, [5] = 37889, [6] = -1 }
GA_BiSLists["DRUID"]["Restoration"]["PR"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 33508, [2] = 25643, [3] = 38366, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 48141, [2] = 47690, [3] = 46184, [4] = 45439, [5] = 49472, [6] = 45864 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 45243, [2] = 45443, [3] = 45447, [4] = 47144, [5] = 45822, [6] = 45116 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 48138, [2] = 46068, [3] = 48137, [4] = 47715, [5] = 48131, [6] = 46187 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 47553, [2] = 46977, [3] = 48672, [4] = 45618, [5] = 47552, [6] = 46976 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40155 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 47096, [2] = 46993, [3] = 45519, [4] = 46992, [5] = 47094, [6] = 48169 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47066, [2] = 47208, [3] = 45446, [4] = 47055, [5] = 47203, [6] = 45149 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 48142, [2] = 45665, [3] = 47236, [4] = 45273, [5] = 45840, [6] = 45512 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40155 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 47145, [2] = 46973, [3] = 45616, [4] = 47140, [5] = 46972, [6] = 45455 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 48140, [2] = 47062, [3] = 48135, [4] = 47051, [5] = 46049, [6] = 47190 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47097, [2] = 45135, [3] = 47092, [4] = 47205, [5] = 45483, [6] = 45566 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 45495, [2] = 47224, [3] = 47732, [4] = 45614, [5] = 47223, [6] = 45946 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 54589, [2] = 45535, [3] = 47059, [4] = 47041, [5] = 45703, [6] = 40432 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 47206, [3] = 46980, [4] = 45886, [5] = 45620, [6] = 45612 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 47958, [2] = 45271, [3] = 47146, [4] = 47138, [5] = 39766, [6] = 47742 }
GA_BiSLists["DRUID"]["Restoration"]["T9"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40342, [2] = 47671, [3] = 33508, [4] = 25643, [5] = 38366, [6] = 46138 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51302, [2] = 51896, [3] = 50661, [4] = 50679, [5] = 51837, [6] = 47690 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50609, [2] = 49975, [3] = 51871, [4] = 50724, [5] = 45243, [6] = 45443 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51304, [2] = 50715, [3] = 50171, [4] = 51839, [5] = 48138, [6] = 46068 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50668, [2] = 47553, [3] = 50014, [4] = 46977, [5] = 48672, [6] = 51848 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50717, [2] = 50973, [3] = 51851, [4] = 50172, [5] = 46993, [6] = 47096 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50630, [2] = 47066, [3] = 47208, [4] = 45446, [5] = 50686, [6] = 51872 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51301, [2] = 50722, [3] = 50615, [4] = 50176, [5] = 51874, [6] = 51138 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50705, [2] = 50997, [3] = 50069, [4] = 51930, [5] = 50613, [6] = 47145 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 51303, [2] = 50696, [3] = 50041, [4] = 51897, [5] = 51136, [6] = 48140 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 49894, [2] = 47097, [3] = 50699, [4] = 45135, [5] = 51920, [6] = 50665 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50400, [2] = 50636, [3] = 50610, [4] = 50424, [5] = 49967, [6] = 51884 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50366, [2] = 47059, [3] = 50359, [4] = 47041, [5] = 50358, [6] = 45535 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 50731, [3] = 50734, [4] = 50685, [5] = 50725, [6] = 50608 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50635, [2] = 50423, [3] = 50719, [4] = 50173, [5] = 45271, [6] = 47146 }
GA_BiSLists["DRUID"]["Restoration"]["T10"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50454, [2] = 40342, [3] = 47671, [4] = 33508, [5] = 25643, [6] = 38366 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51302, [2] = 51896, [3] = 50661, [4] = 50679, [5] = 51837, [6] = 47690 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50609, [2] = 49975, [3] = 51871, [4] = 50724, [5] = 45243, [6] = 45443 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51304, [2] = 50715, [3] = 50171, [4] = 51839, [5] = 48138, [6] = 46068 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50668, [2] = 47553, [3] = 54583, [4] = 50014, [5] = 54556, [6] = 46977 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50717, [2] = 50973, [3] = 51851, [4] = 50172, [5] = 46993, [6] = 47096 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50630, [2] = 54582, [3] = 54584, [4] = 47066, [5] = 47208, [6] = 53486 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51301, [2] = 50722, [3] = 50615, [4] = 50176, [5] = 51874, [6] = 51138 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50705, [2] = 50997, [3] = 50069, [4] = 51930, [5] = 50613, [6] = 47145 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 51303, [2] = 50696, [3] = 50041, [4] = 51897, [5] = 51136, [6] = 48140 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 49894, [2] = 47097, [3] = 50699, [4] = 45135, [5] = 51920, [6] = 50665 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50400, [2] = 50636, [3] = 54585, [4] = 50610, [5] = 50424, [6] = 53490 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50366, [2] = 47059, [3] = 54589, [4] = 50359, [5] = 47041, [6] = 50358 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 50731, [3] = 50734, [4] = 50685, [5] = 50725, [6] = 50608 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50635, [2] = 50423, [3] = 50719, [4] = 50173, [5] = 45271, [6] = 47146 }
GA_BiSLists["DRUID"]["Restoration"]["RS"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50454, [2] = 40342, [3] = 47671, [4] = 33508, [5] = 25643, [6] = 38366 }
GA_BiSLists["DRUID"]["Balance"]["T7"] = {};
GA_BiSLists["DRUID"]["Balance"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40467, [2] = 39545, [3] = 40562, [4] = 44007, [5] = 40339, [6] = 43995 }
GA_BiSLists["DRUID"]["Balance"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 44661, [2] = 44658, [3] = 39472, [4] = 40427, [5] = 40064, [6] = 40374 }
GA_BiSLists["DRUID"]["Balance"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40470, [2] = 40286, [3] = 40351, [4] = 39548, [5] = 40555, [6] = 40594 }
GA_BiSLists["DRUID"]["Balance"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 44005, [2] = 40405, [3] = 39241, [4] = 40251, [5] = 40253, [6] = 40723 }
GA_BiSLists["DRUID"]["Balance"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40469, [2] = 40526, [3] = 40234, [4] = 39396, [5] = 44002, [6] = 43401 }
GA_BiSLists["DRUID"]["Balance"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 44008, [2] = 40325, [3] = 40740, [4] = 39252, [5] = 40198, [6] = 40323 }
GA_BiSLists["DRUID"]["Balance"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40466, [2] = 40380, [3] = 40197, [4] = 39192, [5] = 40238, [6] = 39733 }
GA_BiSLists["DRUID"]["Balance"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40561, [2] = 40301, [3] = 40696, [4] = 37408, [5] = 40341, [6] = 40200 }
GA_BiSLists["DRUID"]["Balance"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 } }, [1] = 40560, [2] = 39720, [3] = 40376, [4] = 40398, [5] = 40468, [6] = 40379 }
GA_BiSLists["DRUID"]["Balance"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 } }, [1] = 40519, [2] = 40246, [3] = 40750, [4] = 40558, [5] = 40409, [6] = 40270 }
GA_BiSLists["DRUID"]["Balance"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40399, [2] = 40080, [3] = 39389, [4] = 40719, [5] = 43253, [6] = 40585 }
GA_BiSLists["DRUID"]["Balance"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 40255, [2] = 40432, [3] = 37873, [4] = 42395, [5] = 40682, [6] = 39229 }
GA_BiSLists["DRUID"]["Balance"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 40395, [2] = 40489, [3] = 40408, [4] = 39424, [5] = 39763, [6] = 39423 }
GA_BiSLists["DRUID"]["Balance"]["T7"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 40192, [2] = 40273, [3] = 40698, [4] = 39199, [5] = 37134, [6] = 39766 }
GA_BiSLists["DRUID"]["Balance"]["T7"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40321, [2] = 40712, [3] = 32387, [4] = 38360, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Balance"]["T8"] = {};
GA_BiSLists["DRUID"]["Balance"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45497, [2] = 45150, [3] = 46191, [4] = 45464, [5] = 46313, [6] = 40467 }
GA_BiSLists["DRUID"]["Balance"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40048 } }, [1] = 45133, [2] = 45699, [3] = 45539, [4] = 44661, [5] = 44658, [6] = 45933 }
GA_BiSLists["DRUID"]["Balance"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46196, [2] = 45186, [3] = 46068, [4] = 45136, [5] = 40470, [6] = 40286 }
GA_BiSLists["DRUID"]["Balance"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40048 } }, [1] = 45242, [2] = 46042, [3] = 45618, [4] = 44005, [5] = 45486, [6] = 46321 }
GA_BiSLists["DRUID"]["Balance"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40048 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 45519, [2] = 45865, [3] = 40526, [4] = 40234, [5] = 45272, [6] = 46194 }
GA_BiSLists["DRUID"]["Balance"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45446, [2] = 45275, [3] = 45549, [4] = 45291, [5] = 40325, [6] = 40740 }
GA_BiSLists["DRUID"]["Balance"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45665, [2] = 46045, [3] = 46189, [4] = 45976, [5] = 45351, [6] = 45520 }
GA_BiSLists["DRUID"]["Balance"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40048 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40048 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45619, [2] = 45557, [3] = 45508, [4] = 45616, [5] = 40301, [6] = 45455 }
GA_BiSLists["DRUID"]["Balance"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46192, [2] = 45488, [3] = 45238, [4] = 40560, [5] = 45353, [6] = 46049 }
GA_BiSLists["DRUID"]["Balance"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 45537, [2] = 45258, [3] = 45135, [4] = 46050, [5] = 40246, [6] = 45566 }
GA_BiSLists["DRUID"]["Balance"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45495, [2] = 46046, [3] = 45451, [4] = 45297, [5] = 45515, [6] = 39389 }
GA_BiSLists["DRUID"]["Balance"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45518, [2] = 45466, [3] = 45148, [4] = 45866, [5] = 40255, [6] = 37873 }
GA_BiSLists["DRUID"]["Balance"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45620, [2] = 45612, [3] = 46035, [4] = 45171, [5] = 45527, [6] = 45457 }
GA_BiSLists["DRUID"]["Balance"]["T8"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 45617, [2] = 45115, [3] = 40273, [4] = 40698, [5] = 45271, [6] = 45314 }
GA_BiSLists["DRUID"]["Balance"]["T8"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40321, [2] = 40712, [3] = 32387, [4] = 45270, [5] = 38360, [6] = -1 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"] = {};
GA_BiSLists["DRUID"]["Feral tank"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 40329, [2] = 40473, [3] = 39399, [4] = 44908, [5] = 39553, [6] = 42550 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40387, [2] = 44664, [3] = 42646, [4] = 39246, [5] = 40069, [6] = 44659 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40023 } }, [1] = 40494, [2] = 40437, [3] = 39556, [4] = 40305, [5] = 43481, [6] = 37139 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 } }, [1] = 40252, [2] = 40722, [3] = 40403, [4] = 43988, [5] = 43565, [6] = 43406 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 40471, [2] = 40277, [3] = 43590, [4] = 40539, [5] = 40319, [6] = 43990 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 } }, [1] = 40186, [2] = 39765, [3] = 40738, [4] = 37183, [5] = 41830, [6] = 39247 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 40472, [2] = 40362, [3] = 39727, [4] = 40541, [5] = 39299, [6] = 39557 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 43591, [2] = 40260, [3] = 37194, [4] = 40205, [5] = 41827, [6] = 40694 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 44011, [2] = 40493, [3] = 39555, [4] = 40333, [5] = 39761, [6] = 37644 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 40243, [2] = 43592, [3] = 40748, [4] = 44893, [5] = 41828, [6] = 39701 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40370, [2] = 37784, [3] = 43993, [4] = 40718, [5] = 43582, [6] = 42643 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 44253, [2] = 37220, [3] = 44063, [4] = 42341, [5] = 40257, [6] = 40767 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 27984 } }, [1] = 40280, [2] = 40388, [3] = 40233, [4] = 39422, [5] = 40406, [6] = 40497 }
GA_BiSLists["DRUID"]["Feral tank"]["T7"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 38365, [2] = 33509, [3] = -1, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"] = {};
GA_BiSLists["DRUID"]["Feral tank"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40023 } }, [1] = 45993, [2] = 45523, [3] = 46161, [4] = 45356, [5] = 45893, [6] = 40329 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45517, [2] = 45485, [3] = 45459, [4] = 45945, [5] = 45696, [6] = 40387 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40023 } }, [1] = 45245, [2] = 46157, [3] = 45265, [4] = 45359, [5] = 45677, [6] = 40494 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45461, [2] = 45496, [3] = 45588, [4] = 46032, [5] = 46320, [6] = 45224 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45473, [2] = 46159, [3] = 45358, [4] = 45940, [5] = 45453, [6] = 40471 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45611, [2] = 45869, [3] = 45108, [4] = 39765, [5] = 40186, [6] = 40738 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 46043, [2] = 45325, [3] = 46158, [4] = 45355, [5] = 45838, [6] = 45312 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 46095, [2] = 45555, [3] = 45829, [4] = 45491, [5] = 45547, [6] = 45709 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45536, [2] = 45846, [3] = 46160, [4] = 45357, [5] = 44011, [6] = 45141 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45232, [2] = 45564, [3] = 45162, [4] = 40243, [5] = 45302, [6] = 43592 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45471, [2] = 45112, [3] = 45608, [4] = 45534, [5] = 45871, [6] = 45874 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45158, [2] = 46021, [3] = 44253, [4] = 44063, [5] = 37220, [6] = 42341 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 27984 } }, [1] = 45533, [2] = 45613, [3] = 46033, [4] = 46067, [5] = 45256, [6] = 45498 }
GA_BiSLists["DRUID"]["Feral tank"]["T8"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 45509, [2] = 38365, [3] = 33509, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"] = {};
GA_BiSLists["DRUID"]["Feral dps"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40473, [2] = 40329, [3] = 39399, [4] = 39553, [5] = 42550, [6] = 37293 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44664, [2] = 40065, [3] = 44659, [4] = 39146, [5] = 40369, [6] = 39421 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40494, [2] = 40437, [3] = 40305, [4] = 39237, [5] = 39556, [6] = 43481 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 40403, [2] = 40250, [3] = 39404, [4] = 40721, [5] = 39297, [6] = 43406 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40539, [2] = 40277, [3] = 40471, [4] = 43990, [5] = 39554, [6] = 40319 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39765, [2] = 40186, [3] = 40738, [4] = 39247, [5] = 44203, [6] = 37366 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 } }, [1] = 40541, [2] = 39727, [3] = 40362, [4] = 40472, [5] = 37409, [6] = 39299 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40014 } }, [1] = 40205, [2] = 40260, [3] = 40694, [4] = 43484, [5] = 37194, [6] = 39279 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 44011, [2] = 40493, [3] = 39761, [4] = 40333, [5] = 39224, [6] = 39555 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44589 }, [2] = { ["type"] = "item", ["id"] = 40038 } }, [1] = 40243, [2] = 39701, [3] = 40748, [4] = 44297, [5] = 39196, [6] = 37666 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40474, [2] = 40717, [3] = 40074, [4] = 40075, [5] = 43993, [6] = 39401 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42987, [2] = 40256, [3] = 40431, [4] = 40684, [5] = 39257, [6] = 37166 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 40388, [2] = 40497, [3] = 40406, [4] = 40208, [5] = 39758, [6] = 39422 }
GA_BiSLists["DRUID"]["Feral dps"]["T7"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 39757, [2] = 40713, [3] = 38365, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"] = {};
GA_BiSLists["DRUID"]["Feral dps"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 46161, [2] = 45993, [3] = 45523, [4] = 45893, [5] = 45356, [6] = 40473 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 45517, [2] = 45459, [3] = 45945, [4] = 45820, [5] = 45480, [6] = 44664 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 45245, [2] = 45677, [3] = 46157, [4] = 45359, [5] = 45265, [6] = 40437 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40014 } }, [1] = 46032, [2] = 45461, [3] = 45588, [4] = 45224, [5] = 45704, [6] = 45138 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 45473, [2] = 45453, [3] = 40539, [4] = 46159, [5] = 45940, [6] = 45358 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40014 } }, [1] = 45869, [2] = 45611, [3] = 40186, [4] = 45108, [5] = 39765, [6] = 40738 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 46158, [2] = 46043, [3] = 45325, [4] = 40541, [5] = 45838, [6] = 45355 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 46095, [2] = 45547, [3] = 45829, [4] = 45555, [5] = 45709, [6] = 45491 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40038 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 45536, [2] = 45846, [3] = 45141, [4] = 44011, [5] = 46160, [6] = 45324 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44589 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45564, [2] = 45232, [3] = 45162, [4] = 39701, [5] = 45302, [6] = 40243 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 46048, [2] = 45608, [3] = 45157, [4] = 45534, [5] = 46322, [6] = 45456 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45931, [2] = 45609, [3] = 45522, [4] = 46038, [5] = 45286, [6] = 42987 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 45613, [2] = 45533, [3] = 46033, [4] = 46067, [5] = 45498, [6] = 45256 }
GA_BiSLists["DRUID"]["Feral dps"]["T8"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40713, [2] = 39757, [3] = 38365, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Restoration"]["T7"] = {};
GA_BiSLists["DRUID"]["Restoration"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40017 } }, [1] = 44007, [2] = 40287, [3] = 40562, [4] = 39240, [5] = 43995, [6] = 40461 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 39392, [2] = 44661, [3] = 40071, [4] = 44658, [5] = 40374, [6] = 39232 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 39719, [2] = 40063, [3] = 40594, [4] = 40555, [5] = 40465, [6] = 40286 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 40723, [2] = 44005, [3] = 40405, [4] = 41610, [5] = 40253, [6] = 39272 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 44002, [2] = 40463, [3] = 39756, [4] = 42102, [5] = 39538, [6] = 40194 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40051 } }, [1] = 44008, [2] = 40323, [3] = 39731, [4] = 39390, [5] = 40741, [6] = 37361 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40017 } }, [1] = 40460, [2] = 39733, [3] = 40349, [4] = 42113, [5] = 39543, [6] = 40197 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40017 } }, [1] = 40561, [2] = 40341, [3] = 40566, [4] = 39190, [5] = 39308, [6] = 40271 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40017 } }, [1] = 40379, [2] = 40060, [3] = 39408, [4] = 40398, [5] = 39191, [6] = 40462 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 } }, [1] = 40558, [2] = 40409, [3] = 40326, [4] = 40751, [5] = 39215, [6] = 39254 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40719, [2] = 40375, [3] = 39250, [4] = 40399, [5] = 40433, [6] = 37694 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 40432, [2] = 37111, [3] = 44322, [4] = 37657, [5] = 42988, [6] = 37835 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 40395, [2] = 40488, [3] = 39763, [4] = 39423, [5] = 40244, [6] = 40300 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 39766, [2] = 40699, [3] = 40192, [4] = 37718, [5] = 44210, [6] = 37051 }
GA_BiSLists["DRUID"]["Restoration"]["T7"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40342, [2] = 33508, [3] = 25643, [4] = 38366, [5] = -1, [6] = -1 }
GA_BiSLists["DRUID"]["Restoration"]["T8"] = {};
GA_BiSLists["DRUID"]["Restoration"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46184, [2] = 45439, [3] = 45864, [4] = 44007, [5] = 45497, [6] = 45346 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45243, [2] = 45443, [3] = 45447, [4] = 45822, [5] = 45116, [6] = 45933 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46187, [2] = 46068, [3] = 45492, [4] = 45253, [5] = 45136, [6] = 46187 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45618, [2] = 46321, [3] = 45541, [4] = 40723, [5] = 45486, [6] = 45317 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40017 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 45519, [2] = 46194, [3] = 45240, [4] = 45354, [5] = 45272, [6] = 44002 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45446, [2] = 45149, [3] = 44008, [4] = 40323, [5] = 39731, [6] = 45146 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46183, [2] = 45665, [3] = 45273, [4] = 45840, [5] = 45512, [6] = 45462 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45616, [2] = 45455, [3] = 45556, [4] = 45830, [5] = 45119, [6] = 45619 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40104 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46185, [2] = 46049, [3] = 45482, [4] = 45468, [5] = 46034, [6] = 40379 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40017 } }, [1] = 45135, [2] = 45483, [3] = 45566, [4] = 45537, [5] = 45378, [6] = 46050 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45495, [2] = 45614, [3] = 45946, [4] = 46323, [5] = 45418, [6] = 45235 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45703, [2] = 45535, [3] = 40432, [4] = 45929, [5] = 44322, [6] = 37111 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 45886, [3] = 45620, [4] = 45612, [5] = 45479, [6] = 46035 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 45271, [2] = 39766, [3] = 40699, [4] = 45314, [5] = 40192, [6] = 37718 }
GA_BiSLists["DRUID"]["Restoration"]["T8"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40342, [2] = 33508, [3] = 25643, [4] = 38366, [5] = 46138, [6] = -1 }
end


