-- ============================================================
-- GearAnalyzer: Death Knight (DEATHKNIGHT)
-- Data-on-Demand Module
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

function GearAnalyzer:LoadDeathKnightData()
    if rawget(self.ClassData, "DEATHKNIGHT") then return end -- Ya cargado

    self.ClassData["DEATHKNIGHT"] = {
        Glyphs = {
            ["Blood Tank"] = {
                major = { 43554, 43534, 43542 }, -- Sangre vampírica, Golpe al corazón, Muerte y descomposición
                minor = { 43544, 43672, 43535 }  -- Cuerno de invierno, Pestilencia, Sangre reforzada
            },
            ["Blood DPS"] = {
                major = { 43554, 43534, 43542 }, -- Golpe al corazón, Golpe de Escarcha (o Asolar), Muerte y descomposición
                minor = { 43544, 43672, 43535 }  -- Cuerno de invierno, Pestilencia, Sangre reforzada
            },
            ["Frost"] = {
                major = { 43547, 43543, 43546 }, -- Asolar, Golpe de Escarcha, Toque helado
                minor = { 43544, 43672, 43535 }  -- Cuerno de invierno, Pestilencia, Sangre reforzada
            },
            ["Unholy"] = {
                major = { 45804, 43551, 45805 }, -- Muerte oscura (Death Coil), Golpe de la Plaga, Enfermedad
                minor = { 43544, 43672, 43535 }  -- Cuerno de invierno, Pestilencia, Sangre reforzada
            }
        },
        Gems = {
            ["Blood Tank"] = {
                meta = 41380, -- Diamante de asedio de tierra austero (+32 Aguante / +2% Armadura)
                red = 40139, -- Piedra de terror del defensor (+10 Parada / +15 Aguante)
                yellow = 40167, -- Ojo de Zul duradero (+10 Defensa / +15 Aguante)
                blue = 40119, -- Circón majestuoso sólido (+30 Aguante)
                note = "Prioridad: Aguante y Mitigación (Defensa/Parada). Huecos rojos con Parada/Aguante."
            },
            ["Blood DPS"] = {
                meta = 41398, -- Diamante de asedio de tierra incansable (+21 Agilidad / +3% CD)
                red = 40111, -- Rubí cárdeno llamativo (+20 Fuerza)
                yellow = 40111, -- Rubí cárdeno llamativo (+20 Fuerza)
                blue = 40111, -- Fuerza por defecto
                prismatic = 49110, -- Lágrima de pesadilla
                prismaticSlot = "chest",
                note = "Prioridad: Fuerza > ArP > Crítico. Rubí cárdeno en todo."
            },
            ["Frost"] = {
                meta = 41398, -- Diamante de asedio de tierra incansable (+21 Agilidad / +3% CD)
                red = 40111, -- Rubí cárdeno llamativo (+20 Fuerza)
                yellow = 40111, -- Rubí cárdeno llamativo (+20 Fuerza)
                blue = 40111, -- Fuerza por defecto
                prismatic = 49110, -- Lágrima de pesadilla
                prismaticSlot = "chest",
                note = "PROGRESIÓN: Inicio Full Fuerza (+20 STR). Punto de Quiebre: al alcanzar ~1050 ArPen pasivo (T10+ICC25), cambiar a Full ArPen (+20 ArPen) hasta Hard Cap 1400."
            },
            ["Unholy"] = {
                meta = 41398, -- Diamante de asedio de tierra incansable (+21 Agilidad / +3% CD)
                red = 40111, -- Rubí cárdeno llamativo (+20 Fuerza)
                yellow = 40111, -- Rubí cárdeno llamativo (+20 Fuerza)
                blue = 40111, -- Fuerza por defecto
                prismatic = 49110, -- Lágrima de pesadilla
                prismaticSlot = "chest",
                note = "Prioridad: FULL FUERZA. Usa Lágrima en Pecho para activar Meta."
            }
        },
        TalentTrees = {
            [1] = { name = "Sangre", icon = "Interface\\Icons\\Spell_Deathknight_BloodPresence" },
            [2] = { name = "Frost", icon = "Interface\\Icons\\Spell_Deathknight_FrostPresence" },
            [3] = { name = "Unholy", icon = "Interface\\Icons\\Spell_Deathknight_UnholyPresence" },
        },
        Caps = {
            ["Blood Tank"] = {
                role = "Tank",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "DEF", cap = 540, label = "Defensa", note = "Cap Inmunidad Críticos (540 mínimo)" },
                    { stat = "STA", label = "Aguante", note = "EH (Salud Efectiva)" },
                    { stat = "EXP", cap = 56, label = "Pericia", note = "26 mín. / 56 Hard Cap (evitar Parry-rush)" },
                    { stat = "PARRY", label = "Parada" },
                },
                gemAdjustments = {
                    { stat = "HIT", target = 263, yellow = 40166 }, -- Ojo de Zul vívido (Hit/Stam)
                    { stat = "EXPERTISE", target = 214, yellow = 40161 }, -- Ojo de Zul vívido (Exp/Stam)
                }
            },
            ["Blood DPS"] = {
                role = "Melee",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "STR", label = "Fuerza" },
                    { stat = "ARP", label = "ArP", note = "Penetración de Armadura" },
                    { stat = "CRIT", label = "Crítico" },
                }
            },
            ["Frost"] = {
                role = "Melee",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "STR", label = "Fuerza", note = "Soft Cap (Inicio / Medio equipo)" },
                    { stat = "ARPEN", cap = 1400, label = "ArPen", note = "Hard Cap (1400 pasivo con T10+ICC25). Cambiar gemas al alcanzar ~1050 pasivo." },
                },
                gemAdjustments = {
                    { stat = "HIT", target = 263, yellow = 40143 }, -- Ametrina grabada (Str/Hit)
                    { stat = "EXPERTISE", target = 214, yellow = 40162 }, -- Ametrino de precisión (Exp/Hit)
                }
            },
            ["Unholy"] = {
                role = "Melee",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "STR", label = "Fuerza", note = "Full Fuerza siempre (No usa ArPen)" },
                    { stat = "HASTE", label = "Celeridad" },
                },
                gemAdjustments = {
                    { stat = "HIT", target = 263, yellow = 40143 }, -- Ametrina grabada (Str/Hit)
                    { stat = "EXPERTISE", target = 214, yellow = 40162 }, -- Ametrino de precisión (Exp/Hit)
                }
            }
        },
        Enchants = {
            ["Blood Tank"] = {
                ["weapon"]    = 3847,   -- Runa de la gárgola de piel de piedra
                ["head"]      = 3818,   -- Arcanum del protector leal (+37 Aguante / +20 Def)
                ["shoulders"] = 3811,   -- Inscripción del pináculo superior (+20 Esquiva / +15 Def)
                ["back"]      = 3294,   -- Armadura poderosa (+225)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 3850,   -- Aguante mayor (+40)
                ["hands"]     = 3253,   -- Armero (+10 Parada / +2% Amenaza)
                ["legs"]      = 3822,   -- Armadura de pierna de pellejo de escarcha (+55 Aguante / +22 Agi)
                ["feet"]      = { 3232, 1075 }, -- Vitalidad colmillarr (Velocidad) / Aguante superior (+22)
                ["waist"]     = 3731,   -- Hebilla eterna
                ["ring1"]     = 3521,   -- Asalto (+40 PA) - Profesión
                ["ring2"]     = 3521,
                ["offhand"]   = 0,
            },
            ["Blood DPS"] = {
                ["weapon"]    = 3368,   -- Runa del cruzado caído
                ["head"]      = 3817,   -- Arcanum de tormentos
                ["shoulders"] = 3808,   -- Inscripción del hacha superior
                ["back"]      = 3831,   -- Velocidad superior (+23 celeridad)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 3845,   -- Asalto superior (+50 PA)
                ["hands"]     = 1603,   -- Triturador (+44 PA)
                ["legs"]      = 3823,   -- Armadura para pierna de escama de hielo
                ["feet"]      = 1597,   -- Asalto superior (+32 PA)
                ["waist"]     = 3731,   -- Hebilla eterna
                ["ring1"]     = 3521,   -- Asalto (+40 PA) - Profesión
                ["ring2"]     = 3521,
                ["offhand"]   = 0,
            },
            ["Frost"] = {
                ["weapon"]    = 3368,   -- Runa del cruzado caído
                ["head"]      = 3817,   -- Arcanum de tormentos
                ["shoulders"] = 3808,   -- Inscripción del hacha superior
                ["back"]      = 3831,   -- Velocidad superior (+23 celeridad)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 3845,   -- Asalto superior (+50 PA)
                ["hands"]     = 1603,   -- Triturador (+44 PA)
                ["legs"]      = 3823,   -- Armadura para pierna de escama de hielo
                ["feet"]      = 1597,   -- Asalto superior (+32 PA)
                ["waist"]     = 3731,   -- Hebilla eterna
                ["ring1"]     = 3521,   -- Asalto (+40 PA) - Profesión
                ["ring2"]     = 3521,
                ["offhand"]   = 3370,   -- Runa de cuchilla de hielo
            },
            ["Unholy"] = {
                ["weapon"]    = 3368,   -- Runa del cruzado caído
                ["head"]      = 3817,   -- Arcanum de tormentos
                ["shoulders"] = 3808,   -- Inscripción del hacha superior
                ["back"]      = 3831,   -- Velocidad superior (+23 celeridad)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 3845,   -- Asalto superior (+50 PA)
                ["hands"]     = 1603,   -- Triturador (+44 PA)
                ["legs"]      = 3823,   -- Armadura para pierna de escama de hielo
                ["feet"]      = 1597,   -- Asalto superior (+32 PA)
                ["waist"]     = 3731,   -- Hebilla eterna
                ["ring1"]     = 3521,   -- Asalto (+40 PA) - Profesión
                ["ring2"]     = 3521,
                ["offhand"]   = 0,   
            }
        },
        Talents = {
            ["Frost"] = {
                label = "10/53/8 - DK Escarcha DPS (Dual Wield)",
                exportCode = "2305000000000000000000000000320053503402030123000331013512300003000000000000000000000000",
                [1] = { name = "Sangre", points = 10 },
                [2] = { name = "Frost", points = 53 },
                [3] = { name = "Unholy", points = 8 }
            },
            ["Blood Tank"] = {
                label = "43/26/2 - DK Sangre Tanque (Standard Survival)",
                exportCode = "0055021533300313201020130000305050500202300100000000000000020000000000000000000000000000",
                [1] = { name = "Sangre", points = 43 },
                [2] = { name = "Frost", points = 26 },
                [3] = { name = "Unholy", points = 2 }
            },
            ["Blood DPS"] = {
                label = "51/0/20 - DK Sangre DPS (ArP Build)",
                exportCode = "2305020530003303231023101351000000000000000000000000000000000230030000000000000000000000",
                [1] = { name = "Sangre", points = 51 },
                [2] = { name = "Frost", points = 0 },
                [3] = { name = "Unholy", points = 20 }
            },
            ["Unholy"] = {
                label = "0/17/54 - DK Profano DPS (Morbid)",
                exportCode = "0000000000000000000000000000320050500002000000000000000002302303350032050000150003133151",
                [1] = { name = "Sangre", points = 0 },
                [2] = { name = "Frost", points = 17 },
            }
        }
    }
    
    -- Tablas de BiS Cortas para referencia rápida
    self.ClassData["DEATHKNIGHT"].BiS = {
        ["Blood Tank"] = {
            head = 51306, neck = 50627, shoulders = 51309, back = 50718,
            chest = 51305, wrists = 50611, hands = 51307, waist = 50691,
            legs = 51308, feet = 50625, ring1 = 50642, ring2 = 50404,
            trinket1 = 50364, trinket2 = 50356, weapon = 50730, idol = 50462
        },
        ["Blood DPS"] = {
            head = 51312, neck = 50633, shoulders = 51314, back = 50677,
            chest = 51310, wrists = 50659, hands = 51311, waist = 50620,
            legs = 51313, feet = 50639, ring1 = 50402, ring2 = 52572,
            trinket1 = 50363, trinket2 = 50362, weapon = 49623, idol = 50459
        },
        ["Escarcha (DPS)"] = {
            head = 51312, neck = 54581, shoulders = 51314, back = 47547,
            chest = 51310, wrists = 54559, hands = 51311, waist = 50620,
            legs = 51817, feet = 54578, ring1 = 52572, ring2 = 50693,
            trinket1 = 50363, trinket2 = 54590, weapon = 50737, idol = 50459
        },
        ["Profano (DPS)"] = {
            head = 51312, neck = 50647, shoulders = 51314, back = 50677,
            chest = 51310, wrists = 50659, hands = 51311, waist = 50620,
            legs = 50624, feet = 50639, ring1 = 52572, ring2 = 50693,
            trinket1 = 50363, trinket2 = 54590, weapon = 49623, idol = 50459
        }
    }

    -- Poblamos GA_BiSLists para retrocompatibilidad
    GA_BiSLists["DEATHKNIGHT"] = GA_BiSLists["DEATHKNIGHT"] or {}
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 41387, [2] = 39395, [3] = 39625, [4] = 42549, [5] = 44902, [6] = 37633 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40679, [2] = 44660, [3] = 39246, [4] = 42646, [5] = 43282, [6] = 37689 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 } }, [1] = 37814, [2] = 39267, [3] = 39627, [4] = 44312, [5] = 37635, [6] = 37115 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 } }, [1] = 43565, [2] = 43988, [3] = 39225, [4] = 37728, [5] = 44188, [6] = 37197 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47900 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 39623, [2] = 39398, [3] = 37658, [4] = 44198, [5] = 43310, [6] = 34394 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 } }, [1] = 37620, [2] = 39467, [3] = 39195, [4] = 37682, [5] = 37891, [6] = 37040 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 39624, [2] = 39197, [3] = 37645, [4] = 44183, [5] = 37363, [6] = 37862 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40089 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 40689, [2] = 37241, [3] = 37801, [4] = 37379, [5] = 37826, [6] = 37171 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40022 } }, [1] = 43500, [2] = 39626, [3] = 43994, [4] = 37292, [5] = 37193, [6] = 34381 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 } }, [1] = 44201, [2] = 39234, [3] = 44895, [4] = 41392, [5] = 37618, [6] = 44306 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 42643, [2] = 37784, [3] = 39141, [4] = 40426, [5] = 37257, [6] = 44935 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 37220, [2] = 36993, [3] = 44063, [4] = 42341, [5] = 39292, [6] = 44323 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62158 } }, [1] = 41257, [2] = 39344, [3] = 43409, [4] = 37852, [5] = 37401, [6] = 37260 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 39344, [2] = 37401, [3] = 37260, [4] = 37179, [5] = 41383, [6] = 36984 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["PR"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40822, [2] = 40714, [3] = -1, [4] = -1, [5] = -1, [6] = -1 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 48545, [2] = 49467, [3] = 48540, [4] = 47677, [5] = 49332, [6] = 48529 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47133, [2] = 47939, [3] = 45485, [4] = 49492, [5] = 47116, [6] = 47679 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 48543, [2] = 48542, [3] = 47698, [4] = 46122, [5] = 48535, [6] = 47944 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47549, [2] = 47063, [3] = 45496, [4] = 48675, [5] = 47042, [6] = 47547 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47900 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 46968, [2] = 48547, [3] = 46962, [4] = 47964, [5] = 47591, [6] = 46039 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47111, [2] = 47570, [3] = 47918, [4] = 47108, [5] = 45111, [6] = 47611 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 45487, [2] = 48546, [3] = 48539, [4] = 46119, [5] = 45834, [6] = 48537 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40129 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47076, [2] = 47072, [3] = 47937, [4] = 45825, [5] = 45551, [6] = 45304 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47061, [2] = 48544, [3] = 45594, [4] = 47052, [5] = 48541, [6] = 45295 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47003, [2] = 47952, [3] = 45988, [4] = 46997, [5] = 47738, [6] = 45166 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 45471, [2] = 47157, [3] = 47955, [4] = 47731, [5] = 47149, [6] = 45326 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47088, [2] = 45158, [3] = 47080, [4] = 46021, [5] = 47216, [6] = 49487 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62158 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47515, [2] = 47519, [3] = 45533, [4] = 47506, [5] = 46067, [6] = 45442 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 47506, [2] = 45442, [3] = 45876, [4] = 47967, [5] = 48714, [6] = 45110 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T9"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 47672, [2] = 45144, [3] = 40714, [4] = 40822, [5] = -1, [6] = -1 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40129 } }, [1] = 51306, [2] = 50640, [3] = 49986, [4] = 51133, [5] = 48545, [6] = 49467 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50682, [2] = 50627, [3] = 50195, [4] = 50023, [5] = 51934, [6] = 47133 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51309, [2] = 50660, [3] = 51847, [4] = 50003, [5] = 51130, [6] = 48543 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50718, [2] = 47549, [3] = 50074, [4] = 50466, [5] = 51888, [6] = 47063 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47900 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51305, [2] = 50681, [3] = 50968, [4] = 50024, [5] = 51917, [6] = 51134 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50611, [2] = 51901, [3] = 49960, [4] = 47111, [5] = 47570, [6] = 47918 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51307, [2] = 50716, [3] = 51835, [4] = 51132, [5] = 50978, [6] = 50075 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50691, [2] = 51831, [3] = 50991, [4] = 50036, [5] = 47076, [6] = 47072 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50612, [2] = 51895, [3] = 51308, [4] = 49904, [5] = 47061, [6] = 48544 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50625, [2] = 50190, [3] = 51816, [4] = 49907, [5] = 47003, [6] = 47952 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50622, [2] = 50404, [3] = 50604, [4] = 50185, [5] = 47731, [6] = 45471 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50364, [2] = 47088, [3] = 50344, [4] = 50356, [5] = 50361, [6] = 47080 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62158 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50730, [2] = 50735, [3] = 50603, [4] = 50727, [5] = 50738, [6] = 47515 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50738, [2] = 51947, [3] = 51937, [4] = 49997, [5] = 51869, [6] = 47506 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["T10"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50462, [2] = 47672, [3] = 45144, [4] = 40714, [5] = 40822, [6] = 40867 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40129 } }, [1] = 50640, [2] = 51306, [3] = 49986, [4] = 51133, [5] = 48545, [6] = 49467 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50682, [2] = 50627, [3] = 50195, [4] = 50023, [5] = 51934, [6] = 47133 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51309, [2] = 50660, [3] = 51847, [4] = 50003, [5] = 51130, [6] = 48543 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50718, [2] = 47549, [3] = 50074, [4] = 50466, [5] = 51888, [6] = 47063 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47900 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51305, [2] = 50681, [3] = 50968, [4] = 50024, [5] = 51917, [6] = 51134 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50611, [2] = 51901, [3] = 49960, [4] = 47111, [5] = 47570, [6] = 47918 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51307, [2] = 50716, [3] = 51835, [4] = 51132, [5] = 50978, [6] = 50075 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50691, [2] = 51831, [3] = 50991, [4] = 50036, [5] = 47076, [6] = 47072 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51308, [2] = 51895, [3] = 50612, [4] = 49904, [5] = 47061, [6] = 48544 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50625, [2] = 50190, [3] = 51816, [4] = 49907, [5] = 47003, [6] = 47952 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50622, [2] = 50404, [3] = 50604, [4] = 50185, [5] = 47731, [6] = 45471 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50364, [2] = 47088, [3] = 54591, [4] = 50344, [5] = 50356, [6] = 50361 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62158 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50730, [2] = 50735, [3] = 50603, [4] = 50727, [5] = 50738, [6] = 47515 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50738, [2] = 51947, [3] = 51937, [4] = 49997, [5] = 51869, [6] = 47506 }
    GA_BiSLists["DEATHKNIGHT"]["Blood Tank"]["RS"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50462, [2] = 47672, [3] = 45144, [4] = 40714, [5] = 40822, [6] = 40867 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 41386, [2] = 39403, [3] = 39619, [4] = 44902, [5] = 42552, [6] = 32373 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 42645, [2] = 39146, [3] = 44659, [4] = 39421, [5] = 42021, [6] = 40678 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 34388, [2] = 39621, [3] = 39249, [4] = 39534, [5] = 43198, [6] = 43387 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 37647, [2] = 39404, [3] = 39297, [4] = 38614, [5] = 42061, [6] = 43406 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39617, [2] = 43998, [3] = 34397, [4] = 37219, [5] = 44303, [6] = 37612 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 } }, [1] = 41355, [2] = 39195, [3] = 37891, [4] = 37668, [5] = 43944, [6] = 37366 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39618, [2] = 37409, [3] = 37363, [4] = 34341, [5] = 44399, [6] = 35651 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40688, [2] = 37088, [3] = 37826, [4] = 37407, [5] = 37171, [6] = 37243 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 37193, [2] = 43994, [3] = 37263, [4] = 34180, [5] = 44205, [6] = 37644 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 43402, [2] = 44297, [3] = 44895, [4] = 44306, [5] = 37367, [6] = 32345 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 44935, [2] = 37642, [3] = 40474, [4] = 43993, [5] = 39401, [6] = 43251 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42987, [2] = 40684, [3] = 37166, [4] = 37390, [5] = 37723, [6] = 43573 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53343 } }, [1] = 41383, [2] = 39291, [3] = 43611, [4] = 44250, [5] = 37235, [6] = 37871 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 } }, [1] = 44250, [2] = 39291, [3] = 41383, [4] = 43611, [5] = 37235, [6] = 37871 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["PR"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40715, [2] = 40822, [3] = -1, [4] = -1, [5] = -1, [6] = -1 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40142 } }, [1] = 48488, [2] = 49466, [3] = 45472, [4] = 47674, [5] = 47943, [6] = 49333 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 45459, [2] = 47110, [3] = 47060, [4] = 47915, [5] = 47105, [6] = 45517 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48486, [2] = 48485, [3] = 47697, [4] = 46037, [5] = 47972, [6] = 48478 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47547, [2] = 47545, [3] = 48674, [4] = 47192, [5] = 48673, [6] = 46971 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 49110 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48490, [2] = 47086, [3] = 47589, [4] = 46965, [5] = 47004, [6] = 47082 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 45663, [2] = 47155, [3] = 46967, [4] = 47572, [5] = 47935, [6] = 47074 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47240, [2] = 48489, [3] = 47234, [4] = 47917, [5] = 47945, [6] = 48482 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 45241, [2] = 47002, [3] = 47153, [4] = 47925, [5] = 47112, [6] = 46999 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48487, [2] = 47132, [3] = 45134, [4] = 47970, [5] = 47191, [6] = 48484 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47154, [2] = 47077, [3] = 45599, [4] = 47109, [5] = 47150, [6] = 47071 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40142 } }, [1] = 46966, [2] = 47920, [3] = 45534, [4] = 47075, [5] = 47934, [6] = 45608 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47131, [2] = 45931, [3] = 47115, [4] = 42987, [5] = 45609, [6] = 46038 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53343 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47526, [2] = 47156, [3] = 47966, [4] = 47973, [5] = 46097, [6] = 45947 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47526, [2] = 47156, [3] = 47966, [4] = 47973, [5] = 46097, [6] = 45947 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T9"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40207, [2] = 47673, [3] = 45254, [4] = 40715, [5] = 40822, [6] = -1 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51312, [2] = 50712, [3] = 50713, [4] = 51866, [5] = 51127, [6] = 49466 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50728, [2] = 50647, [3] = 50633, [4] = 50180, [5] = 45459, [6] = 51822 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51314, [2] = 51865, [3] = 50674, [4] = 51830, [5] = 51125, [6] = 48486 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47547, [2] = 50467, [3] = 47545, [4] = 51933, [5] = 50677, [6] = 50653 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51310, [2] = 50656, [3] = 50606, [4] = 50965, [5] = 51923, [6] = 51129 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50670, [2] = 50659, [3] = 50655, [4] = 50002, [5] = 50333, [6] = 47155 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51311, [2] = 50675, [3] = 51892, [4] = 51844, [5] = 51904, [6] = 50690 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50620, [2] = 51879, [3] = 50707, [4] = 50688, [5] = 50187, [6] = 50995 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51817, [2] = 50697, [3] = 51313, [4] = 50645, [5] = 49903, [6] = 50624 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50639, [2] = 50607, [3] = 51915, [4] = 49983, [5] = 49906, [6] = 51856 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 52572, [2] = 50693, [3] = 50618, [4] = 51878, [5] = 50657, [6] = 50604 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 47131, [3] = 50362, [4] = 47115, [5] = 50343, [6] = 50355 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53343 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50737, [2] = 50672, [3] = 50412, [4] = 50012, [5] = 51893, [6] = 51916 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50672, [2] = 50737, [3] = 50412, [4] = 50012, [5] = 51893, [6] = 51916 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["T10"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40207, [2] = 50459, [3] = 47673, [4] = 45254, [5] = 40715, [6] = 40822 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51312, [2] = 50712, [3] = 50713, [4] = 51866, [5] = 51127, [6] = 49466 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 54581, [2] = 50728, [3] = 50647, [4] = 50633, [5] = 53132, [6] = 50180 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51314, [2] = 51865, [3] = 50674, [4] = 51830, [5] = 51125, [6] = 48486 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47547, [2] = 50467, [3] = 47545, [4] = 51933, [5] = 50677, [6] = 50653 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51310, [2] = 50656, [3] = 50606, [4] = 50965, [5] = 51923, [6] = 51129 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 54559, [2] = 50659, [3] = 50670, [4] = 50655, [5] = 50002, [6] = 50333 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51311, [2] = 50675, [3] = 51892, [4] = 51844, [5] = 51904, [6] = 50690 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40143 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50620, [2] = 51879, [3] = 50707, [4] = 50688, [5] = 50187, [6] = 50995 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51817, [2] = 50697, [3] = 51313, [4] = 50645, [5] = 49903, [6] = 50624 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 54578, [2] = 50639, [3] = 53125, [4] = 50607, [5] = 51915, [6] = 54577 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 52572, [2] = 50693, [3] = 54576, [4] = 50618, [5] = 54567, [6] = 51878 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 54590, [3] = 50362, [4] = 54569, [5] = 47131, [6] = 47115 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53343 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50737, [2] = 50672, [3] = 50412, [4] = 50012, [5] = 51893, [6] = 51916 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50737, [2] = 50672, [3] = 50412, [4] = 50012, [5] = 51893, [6] = 51916 }
    GA_BiSLists["DEATHKNIGHT"]["Frost"]["RS"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40207, [2] = 50459, [3] = 47673, [4] = 45254, [5] = 40715, [6] = 40822 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 41386, [2] = 39403, [3] = 39619, [4] = 41344, [5] = 44902, [6] = 42552 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 37397, [2] = 39421, [3] = 39146, [4] = 44659, [5] = 42645, [6] = 42021 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 34388, [2] = 39621, [3] = 39249, [4] = 37627, [5] = 39534, [6] = 43198 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 37647, [2] = 39404, [3] = 39297, [4] = 34241, [5] = 43566, [6] = 42061 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39617, [2] = 39239, [3] = 43990, [4] = 34215, [5] = 43310, [6] = 36950 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 } }, [1] = 41355, [2] = 39195, [3] = 37668, [4] = 37891, [5] = 37853, [6] = 28795 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 33995 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39618, [2] = 34378, [3] = 37363, [4] = 37409, [5] = 37874, [6] = 44399 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40688, [2] = 37171, [3] = 37088, [4] = 37826, [5] = 30032, [6] = 37243 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 37193, [2] = 43994, [3] = 39620, [4] = 34180, [5] = 37263, [6] = 37675 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44306, [2] = 39139, [3] = 43402, [4] = 44895, [5] = 37367, [6] = 44297 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 44935, [2] = 43251, [3] = 40474, [4] = 39401, [5] = 40586, [6] = 37651 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42987, [2] = 37390, [3] = 37166, [4] = 40684, [5] = 39257, [6] = 44914 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 } }, [1] = 41383, [2] = 40491, [3] = 44311, [4] = 37401, [5] = 43611, [6] = 37235 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 } }, [1] = 40703, [2] = 40491, [3] = 44311, [4] = 37401, [5] = 43611, [6] = 37235 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["PR"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40867, [2] = 40822, [3] = 40715, [4] = -1, [5] = -1, [6] = -1 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 48488, [2] = 49466, [3] = 45472, [4] = 47943, [5] = 48483, [6] = 45107 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47110, [2] = 47105, [3] = 45459, [4] = 46040, [5] = 47060, [6] = 45193 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 48486, [2] = 48485, [3] = 47697, [4] = 46117, [5] = 48478, [6] = 45320 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47547, [2] = 48674, [3] = 47192, [4] = 45588, [5] = 47183, [6] = 45461 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48490, [2] = 47086, [3] = 47082, [4] = 48481, [5] = 46965, [6] = 47004 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 45663, [2] = 47155, [3] = 46967, [4] = 46961, [5] = 47572, [6] = 45611 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 33995 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48489, [2] = 47917, [3] = 48482, [4] = 47240, [5] = 48480, [6] = 46113 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47002, [2] = 47112, [3] = 45241, [4] = 46999, [5] = 47925, [6] = 46041 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 49110 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 47132, [2] = 45134, [3] = 47121, [4] = 46975, [5] = 45982, [6] = 48487 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 45599, [2] = 47154, [3] = 47150, [4] = 45501, [5] = 47919, [6] = 47077 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 46966, [2] = 45534, [3] = 47729, [4] = 46959, [5] = 47920, [6] = 45250 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47131, [2] = 45609, [3] = 47115, [4] = 47734, [5] = 45522, [6] = 42987 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47526, [2] = 47156, [3] = 45947, [4] = 46097, [5] = 47001, [6] = 47506 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47526, [2] = 47156, [3] = 46036, [4] = 45947, [5] = 47001, [6] = 46097 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T9"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 47673, [2] = 45254, [3] = 42620, [4] = 40867, [5] = 40822, [6] = 40715 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51312, [2] = 50712, [3] = 50072, [4] = 49466, [5] = 51866, [6] = 51924 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50647, [2] = 51890, [3] = 49989, [4] = 47110, [5] = 50728, [6] = 50633 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51314, [2] = 50674, [3] = 51865, [4] = 50020, [5] = 48486, [6] = 50646 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 50677, [2] = 47547, [3] = 48674, [4] = 47192, [5] = 50653, [6] = 51912 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51310, [2] = 50606, [3] = 47086, [4] = 49951, [5] = 51902, [6] = 50965 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 50659, [2] = 50002, [3] = 47155, [4] = 51832, [5] = 50670, [6] = 50655 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 33995 }, [2] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 51311, [2] = 51844, [3] = 51892, [4] = 50690, [5] = 51128, [6] = 50675 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40146 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50620, [2] = 51879, [3] = 50987, [4] = 47112, [5] = 51925, [6] = 50707 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40146 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 50624, [2] = 51313, [3] = 50192, [4] = 51854, [5] = 51817, [6] = 49903 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40146 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50639, [2] = 50711, [3] = 49983, [4] = 50607, [5] = 49906, [6] = 51915 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 52572, [2] = 50693, [3] = 50604, [4] = 50657, [5] = 50453, [6] = 51855 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 47131, [3] = 50362, [4] = 47115, [5] = 50343, [6] = 50355 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 49623, [2] = 50737, [3] = 50672, [4] = 50012, [5] = 51858, [6] = 51893 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50737, [2] = 50672, [3] = 50012, [4] = 51858, [5] = 51893, [6] = 50738 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["T10"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50459, [2] = 47673, [3] = 45254, [4] = 42620, [5] = 40867, [6] = 40822 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51312, [2] = 50712, [3] = 50072, [4] = 49466, [5] = 51866, [6] = 51924 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 54581, [2] = 50647, [3] = 51890, [4] = 49989, [5] = 47110, [6] = 50728 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51314, [2] = 50674, [3] = 51865, [4] = 50020, [5] = 48486, [6] = 50646 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 50677, [2] = 47547, [3] = 48674, [4] = 47192, [5] = 50653, [6] = 51912 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51310, [2] = 50606, [3] = 47086, [4] = 49951, [5] = 51902, [6] = 50965 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 50659, [2] = 50002, [3] = 54580, [4] = 54559, [5] = 47155, [6] = 51832 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 33995 }, [2] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 51311, [2] = 51844, [3] = 51892, [4] = 50690, [5] = 51128, [6] = 50675 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40146 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50620, [2] = 51879, [3] = 50987, [4] = 47112, [5] = 51925, [6] = 50707 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40146 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 50624, [2] = 51313, [3] = 50192, [4] = 51854, [5] = 51817, [6] = 49903 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 54578, [2] = 53125, [3] = 50639, [4] = 50711, [5] = 49983, [6] = 50607 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 52572, [2] = 50693, [3] = 50604, [4] = 54576, [5] = 54567, [6] = 50657 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 54590, [3] = 50362, [4] = 47131, [5] = 54569, [6] = 47115 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 49623, [2] = 50737, [3] = 50672, [4] = 50012, [5] = 51858, [6] = 51893 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50737, [2] = 50672, [3] = 50012, [4] = 51858, [5] = 51893, [6] = 50738 }
    GA_BiSLists["DEATHKNIGHT"]["Unholy"]["RS"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50459, [2] = 47673, [3] = 45254, [4] = 42620, [5] = 40867, [6] = 40822 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"] = {};
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 41386, [2] = 39403, [3] = 39619, [4] = 41344, [5] = 44902, [6] = 42552 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 37397, [2] = 39421, [3] = 39146, [4] = 44659, [5] = 42645, [6] = 42021 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 34388, [2] = 39621, [3] = 39249, [4] = 37627, [5] = 39534, [6] = 43198 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 37647, [2] = 39404, [3] = 39297, [4] = 34241, [5] = 43566, [6] = 42061 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39617, [2] = 39239, [3] = 43990, [4] = 34215, [5] = 43310, [6] = 36950 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 } }, [1] = 41355, [2] = 39195, [3] = 37668, [4] = 37891, [5] = 37853, [6] = 28795 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 33995 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39618, [2] = 34378, [3] = 37363, [4] = 37409, [5] = 37874, [6] = 44399 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40688, [2] = 37171, [3] = 37088, [4] = 37826, [5] = 30032, [6] = 37243 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 37193, [2] = 43994, [3] = 39620, [4] = 34180, [5] = 37263, [6] = 37675 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44306, [2] = 39139, [3] = 43402, [4] = 44895, [5] = 37367, [6] = 44297 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 44935, [2] = 43251, [3] = 40474, [4] = 39401, [5] = 40586, [6] = 37651 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42987, [2] = 37390, [3] = 37166, [4] = 40684, [5] = 39257, [6] = 44914 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 } }, [1] = 41383, [2] = 40491, [3] = 44311, [4] = 37401, [5] = 43611, [6] = 37235 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["PR"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40867, [2] = 40822, [3] = 40715, [4] = -1, [5] = -1, [6] = -1 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 48488, [2] = 49466, [3] = 45472, [4] = 47943, [5] = 48483, [6] = 45107 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47110, [2] = 47105, [3] = 45459, [4] = 46040, [5] = 47060, [6] = 45193 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 48486, [2] = 48485, [3] = 47697, [4] = 46117, [5] = 48478, [6] = 45320 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47547, [2] = 48674, [3] = 47192, [4] = 45588, [5] = 47183, [6] = 45461 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48490, [2] = 47086, [3] = 47082, [4] = 48481, [5] = 46965, [6] = 47004 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 45663, [2] = 47155, [3] = 46967, [4] = 46961, [5] = 47572, [6] = 45611 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 33995 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48489, [2] = 47917, [3] = 48482, [4] = 47240, [5] = 48480, [6] = 46113 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47002, [2] = 47112, [3] = 45241, [4] = 46999, [5] = 47925, [6] = 46041 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 49110 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40146 } }, [1] = 47132, [2] = 45134, [3] = 47121, [4] = 46975, [5] = 45982, [6] = 48487 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 45599, [2] = 47154, [3] = 47150, [4] = 45501, [5] = 47919, [6] = 47077 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 46966, [2] = 45534, [3] = 47729, [4] = 46959, [5] = 47920, [6] = 45250 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47131, [2] = 45609, [3] = 47115, [4] = 47734, [5] = 45522, [6] = 42987 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47526, [2] = 47156, [3] = 45947, [4] = 46097, [5] = 47001, [6] = 47506 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T9"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 47673, [2] = 45254, [3] = 42620, [4] = 40867, [5] = 40822, [6] = 40715 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51312, [2] = 50712, [3] = 50713, [4] = 51866, [5] = 51127, [6] = 50072 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50728, [2] = 50633, [3] = 50647, [4] = 50180, [5] = 45459, [6] = 51890 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51314, [2] = 51865, [3] = 50674, [4] = 51830, [5] = 51125, [6] = 50646 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50677, [2] = 47547, [3] = 50467, [4] = 47545, [5] = 51933, [6] = 50653 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51310, [2] = 50656, [3] = 50606, [4] = 51923, [5] = 50965, [6] = 51129 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50659, [2] = 50670, [3] = 50655, [4] = 50002, [5] = 47155, [6] = 50333 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50675, [2] = 51311, [3] = 51892, [4] = 51844, [5] = 50021, [6] = 50690 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50620, [2] = 51879, [3] = 50707, [4] = 50995, [5] = 50688, [6] = 50187 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51313, [2] = 50697, [3] = 51817, [4] = 50645, [5] = 50624, [6] = 49903 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50639, [2] = 50607, [3] = 51915, [4] = 49983, [5] = 49906, [6] = 51856 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 52572, [2] = 50693, [3] = 50618, [4] = 50604, [5] = 51878, [6] = 50657 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 47131, [3] = 50362, [4] = 50343, [5] = 47115, [6] = 50342 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 49623, [2] = 50735, [3] = 50730, [4] = 50603, [5] = 51946, [6] = 50727 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["T10"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50459, [2] = 47673, [3] = 40207, [4] = 45254, [5] = 40715, [6] = 40822 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51312, [2] = 50712, [3] = 50713, [4] = 51866, [5] = 51127, [6] = 50072 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 54581, [2] = 50728, [3] = 50633, [4] = 50647, [5] = 50180, [6] = 53132 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51314, [2] = 51865, [3] = 50674, [4] = 51830, [5] = 51125, [6] = 50646 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 50677, [2] = 47547, [3] = 50467, [4] = 47545, [5] = 51933, [6] = 50653 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51310, [2] = 50656, [3] = 50606, [4] = 51923, [5] = 50965, [6] = 51129 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 54580, [2] = 50659, [3] = 50670, [4] = 54559, [5] = 50655, [6] = 50002 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40143 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50675, [2] = 51311, [3] = 51892, [4] = 51844, [5] = 50021, [6] = 50690 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40143 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50620, [2] = 51879, [3] = 50707, [4] = 50995, [5] = 50688, [6] = 50187 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51313, [2] = 50697, [3] = 51817, [4] = 50645, [5] = 50624, [6] = 49903 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 54578, [2] = 53125, [3] = 50639, [4] = 50607, [5] = 51915, [6] = 54577 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 52572, [2] = 54576, [3] = 50693, [4] = 50618, [5] = 50604, [6] = 54567 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 54590, [3] = 50362, [4] = 54569, [5] = 47131, [6] = 50343 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 53344 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 49623, [2] = 50735, [3] = 50730, [4] = 50603, [5] = 51946, [6] = 50727 }
    GA_BiSLists["DEATHKNIGHT"]["Blood DPS"]["RS"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50459, [2] = 47673, [3] = 40207, [4] = 45254, [5] = 40715, [6] = 40822 }
end



