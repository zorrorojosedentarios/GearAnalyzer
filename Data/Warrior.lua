-- ============================================================
-- GearAnalyzer: Warrior (WARRIOR)
-- Data-on-Demand Module
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

function GearAnalyzer:LoadWarriorData()
    if rawget(self.ClassData, "WARRIOR") then return end

    self.ClassData["WARRIOR"] = {
        Glyphs = {
            ["Fury"] = {
                major = { 43432, 43418, 43414 }, -- Torbellino, Golpe heroico, Rajar
                minor = { 43396, 43395, 49084 }  -- Ira sangrienta, Batalla, Orden
            },
            ["Protection"] = {
                major = { 43429, 45797, 43425 }, -- Provocar, Muro de escudo, Bloqueo
                minor = { 43399, 43396, 49084 }  -- Atronar, Ira sangrienta, Orden
            },
            ["Arms"] = {
                major = { 43421, 43422, 43432 }, -- Golpe mortal, Abrumar, Torbellino
                minor = { 43396, 43395, 49084 }  -- Ira sangrienta, Batalla, Orden
            }
        },
        Gems = {
            ["Fury"] = {
                meta = 41398, -- Diamante de asedio de tierra incansable (+21 Agilidad / +3% CD)
                red = 40117, -- Rubí cárdeno fracturado (+20 ArPen)
                yellow = 40147, -- Ametrino letal (+10 Agilidad / +10 Crítico)
                blue = 40117, -- ArPen por defecto
                prismatic = 49110, -- Lágrima de pesadilla
                prismaticSlot = "chest",
                note = "ARPEN DESDE DÍA 1. Buscar Soft Cap 722 usando abalorio Escorpión (Forja H). Al conseguir Testamento/Escama, tirar Escorpión y buscar Hard Cap 1400 fijo."
            },
            ["Protection"] = {
                meta = 41395, -- Diamante de asedio de tierra eterno (+21 Defensa / +5% Bloqueo)
                red = 40129, -- Piedra de terror soberana (+10 Fuerza / +15 Aguante) o 40130 (Agi/Aguante)
                yellow = 40167, -- Ojo de Zul duradero (+10 Defensa / +15 Aguante)
                blue = 40119, -- Circón majestuoso sólido (+30 Aguante)
                note = "EH Build: Full Aguante > Defensa (540 mín). Usa ranuras mixtas de Def/Agi/Aguante."
            },
            ["Arms"] = {
                meta = 41398, -- Diamante de asedio de tierra incansable (+21 Agilidad / +3% CD)
                red = 40117, -- Rubí cárdeno fracturado (+20 ArPen)
                yellow = 40147, -- Ametrino letal (+10 Agilidad / +10 Crítico)
                blue = 40117, -- ArPen por defecto
                prismatic = 49110, -- Lágrima de pesadilla
                prismaticSlot = "chest",
                note = "ARPEN DESDE DÍA 1. Soft Cap 722 con Escorpión, luego Hard Cap 1400 pasivo con abalorios de ICC25 (Testamento/Escama)."
            }
        },
        TalentTrees = {
            [1] = { name = "Arms", icon = "Interface\\Icons\\Ability_Warrior_SavageBlow" },
            [2] = { name = "Fury", icon = "Interface\\Icons\\Ability_Warrior_InnerRage" },
            [3] = { name = "Protection", icon = "Interface\\Icons\\Ability_Warrior_DefensiveStance" },
        },
        Caps = {
            ["Fury"] = {
                role = "Melee",
                hitCap = { percent = 5, rating = 164, note = "5% (164 rating) asumiendo talento Precisión 3/3" },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "ARPEN", cap = 1400, label = "Penetración de Armadura", note = "Soft Cap 722 (con Escorpión) / Hard Cap 1400 (con Testamento/Escama)" },
                    { stat = "STR", label = "Fuerza" },
                    { stat = "CRIT", cap = 50, label = "Crítico", isPercent = true, note = "55% con Desenfreno" },
                }
            },
            ["Protection"] = {
                role = "Tank",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "DEF", label = "Defensa", cap = 540, note = "Cap Inmunidad Críticos (540)" },
                    { stat = "STA", label = "Aguante", note = "Prioridad Principal" },
                    { stat = "EXP", cap = 56, label = "Pericia", note = "26 mín. / 56 Hard Cap (evitar Parry-rush)" },
                    { stat = "BLOCK", label = "Valor de Bloqueo" },
                }
            },
            ["Arms"] = {
                role = "Melee",
                hitCap = { percent = 8, rating = 263, note = "8% Cap de golpe físico" },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "ARPEN", cap = 1400, label = "Penetración de Armadura", note = "Soft Cap 722 (con Escorpión) / Hard Cap 1400 pasivo" },
                    { stat = "STR", label = "Fuerza" },
                    { stat = "CRIT", label = "Crítico" },
                }
            }
        },
        Enchants = {
            ["Fury"] = {
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
                ["offhand"]   = 3789,   -- Rabiar
            },
            ["Protection"] = {
                ["weapon"]    = 3869,   -- Amparo de hojas
                ["head"]      = 3818,   -- Arcanum del protector leal
                ["shoulders"] = 3811,   -- Inscripción del pináculo superior
                ["back"]      = 3294,   -- Armadura poderosa (+225)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 3850,   -- Aguante mayor (+40)
                ["hands"]     = 3253,   -- Armero
                ["legs"]      = 3822,   -- Armadura para pierna de pellejo de escarcha
                ["feet"]      = 3232,   -- Vitalidad colmillarr
                ["waist"]     = 3731,   -- Hebilla eterna
                ["offhand"]   = 1952,   -- Defensa
            },
            ["Arms"] = {
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
                ["offhand"]   = 0,      -- No aplica (Arma 2M)
            }
        },
        Talents = {
            ["Fury"] = {
                label = "18/53/0 - Guerrero Furia DPS (Titan's Grip)",
                exportCode = "3020230023300000000000000000000305043000503310053120510351000000000000000000000000000",
                [1] = { name = "Arms", points = 18 },
                [2] = { name = "Fury", points = 53 },
                [3] = { name = "Protection", points = 0 }
            },
            ["Protection"] = {
                label = "15/3/53 - Guerrero Proteccion (Tanque)",
                exportCode = "3502000023000000000000000000000300000000000000000000000000053351225000212521030113321",
                [1] = { name = "Arms", points = 15 },
                [2] = { name = "Fury", points = 3 },
                [3] = { name = "Protection", points = 53 }
            },
            ["Arms"] = {
                label = "54/17/0 - Guerrero Armas DPS (Axe/Polearm)",
                exportCode = "3020332023335100202212013231251325000130000000000000000000000000000000000000000000000",
                [1] = { name = "Arms", points = 54 },
                [2] = { name = "Fury", points = 17 },
                [3] = { name = "Protection", points = 0 }
            }
        }
    }

    GA_BiSLists["WARRIOR"] = GA_BiSLists["WARRIOR"] or {}
    GA_BiSLists["WARRIOR"]["Arms"] = GA_BiSLists["WARRIOR"]["Arms"] or {};
    GA_BiSLists["WARRIOR"]["Arms"]["PR"] = {};
    GA_BiSLists["WARRIOR"]["Arms"]["T9"] = {};
    GA_BiSLists["WARRIOR"]["Arms"]["T10"] = {};
    GA_BiSLists["WARRIOR"]["Arms"]["RS"] = {};
    GA_BiSLists["WARRIOR"]["Fury"] = GA_BiSLists["WARRIOR"]["Fury"] or {};
    GA_BiSLists["WARRIOR"]["Protection"] = GA_BiSLists["WARRIOR"]["Protection"] or {};
GA_BiSLists["WARRIOR"]["Arms"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 41386, [2] = 39399, [3] = 42552, [4] = 44902, [5] = 34333, [6] = 37188 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 42645, [2] = 44659, [3] = 39421, [4] = 40678, [5] = 37861, [6] = 42021 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 34392, [2] = 39249, [3] = 39608, [4] = 37139, [5] = 37373, [6] = 44195 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 37647, [2] = 39404, [3] = 39297, [4] = 38614, [5] = 43406, [6] = 42061 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39606, [2] = 43998, [3] = 37722, [4] = 44295, [5] = 37165, [6] = 44303 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 } }, [1] = 44203, [2] = 39278, [3] = 34441, [4] = 41355, [5] = 37891, [6] = 37366 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40038 } }, [1] = 39609, [2] = 37409, [3] = 39194, [4] = 37363, [5] = 37639, [6] = 37886 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40692, [2] = 37407, [3] = 37088, [4] = 37826, [5] = 37243, [6] = 37171 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 } }, [1] = 37263, [2] = 43994, [3] = 37193, [4] = 37644, [5] = 34188, [6] = 37669 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44306, [2] = 44297, [3] = 34569, [4] = 37666, [5] = 43402, [6] = 44895 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40038 } }, [1] = 42642, [2] = 40586, [3] = 40474, [4] = 43993, [5] = 43251, [6] = 37685 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42987, [2] = 40684, [3] = 37166, [4] = 39257, [5] = 37723, [6] = 42990 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 37852, [2] = 40497, [3] = 39417, [4] = 39221, [5] = 37653, [6] = 43409 }
GA_BiSLists["WARRIOR"]["Arms"]["PR"][14] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 37191, [2] = 43612, [3] = 39296, [4] = 44504, [5] = 37692, [6] = 44245 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 48383, [2] = 45610, [3] = 45472, [4] = 48378, [5] = 47674, [6] = 49478 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47915, [2] = 45459, [3] = 47110, [4] = 45945, [5] = 47105, [6] = 49485 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 48381, [2] = 45245, [3] = 47697, [4] = 45677, [5] = 48380, [6] = 47708 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47545, [2] = 47547, [3] = 48673, [4] = 48674, [5] = 47192, [6] = 45461 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 48385, [2] = 47086, [3] = 47082, [4] = 45524, [5] = 47589, [6] = 48376 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47074, [2] = 47155, [3] = 45869, [4] = 45264, [5] = 47935, [6] = 47572 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47240, [2] = 48384, [3] = 46043, [4] = 47945, [5] = 45325, [6] = 45444 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47153, [2] = 47112, [3] = 47152, [4] = 45241, [5] = 45547, [6] = 47925 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 48382, [2] = 46975, [3] = 47191, [4] = 45248, [5] = 47970, [6] = 45536 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47077, [2] = 47109, [3] = 47071, [4] = 47106, [5] = 47919, [6] = 47154 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 45608, [2] = 47934, [3] = 46048, [4] = 45157, [5] = 45534, [6] = 47703 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 46038, [2] = 47131, [3] = 45931, [4] = 47734, [5] = 40256, [6] = 45522 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47078, [2] = 47515, [3] = 47239, [4] = 47519, [5] = 45533, [6] = 45516 }
GA_BiSLists["WARRIOR"]["Arms"]["T9"][14] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 46995, [2] = 45296, [3] = 48711, [4] = 47950, [5] = 45870, [6] = 45570 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51227, [2] = 50712, [3] = 50713, [4] = 51866, [5] = 50605, [6] = 50072 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50728, [2] = 50633, [3] = 50647, [4] = 51890, [5] = 51822, [6] = 45459 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51229, [2] = 51865, [3] = 50674, [4] = 51830, [5] = 50020, [6] = 51210 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47545, [2] = 51933, [3] = 47547, [4] = 50470, [5] = 48673, [6] = 48674 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51225, [2] = 50656, [3] = 50606, [4] = 50689, [5] = 50965, [6] = 51923 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50670, [2] = 50659, [3] = 47155, [4] = 50655, [5] = 50002, [6] = 50670 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 51226, [2] = 50675, [3] = 51926, [4] = 51904, [5] = 51892, [6] = 51844 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50707, [2] = 51879, [3] = 50620, [4] = 50688, [5] = 47153, [6] = 51000 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50645, [2] = 50697, [3] = 51817, [4] = 49899, [5] = 51829, [6] = 50042 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50607, [2] = 47077, [3] = 50639, [4] = 47109, [5] = 50711, [6] = 51856 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50402, [2] = 50618, [3] = 50604, [4] = 50693, [5] = 50186, [6] = 51900 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 50343, [3] = 50362, [4] = 47131, [5] = 50706, [6] = 45931 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 49623, [2] = 50735, [3] = 50730, [4] = 50425, [5] = 50727, [6] = 49888 }
GA_BiSLists["WARRIOR"]["Arms"]["T10"][14] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50733, [2] = 51940, [3] = 45296, [4] = 51845, [5] = 51880, [6] = 51927 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51227, [2] = 50712, [3] = 50713, [4] = 51866, [5] = 50605, [6] = 50072 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 54581, [2] = 50728, [3] = 50633, [4] = 50647, [5] = 51890, [6] = 51822 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51229, [2] = 51865, [3] = 50674, [4] = 51830, [5] = 50020, [6] = 51210 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47545, [2] = 51933, [3] = 47547, [4] = 50470, [5] = 48673, [6] = 48674 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51225, [2] = 50656, [3] = 50606, [4] = 50689, [5] = 50965, [6] = 51923 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 50670, [2] = 50659, [3] = 47155, [4] = 54559, [5] = 50655, [6] = 50002 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 51226, [2] = 50675, [3] = 51926, [4] = 51904, [5] = 51892, [6] = 51844 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50707, [2] = 51879, [3] = 50620, [4] = 50688, [5] = 47153, [6] = 51000 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50645, [2] = 50697, [3] = 51817, [4] = 49899, [5] = 51829, [6] = 50042 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 54578, [2] = 47077, [3] = 53125, [4] = 50607, [5] = 54577, [6] = 50639 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 50402, [2] = 50618, [3] = 54576, [4] = 50604, [5] = 50693, [6] = 54567 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 54590, [2] = 50363, [3] = 54569, [4] = 50362, [5] = 50343, [6] = 47131 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 49623, [2] = 50735, [3] = 50730, [4] = 50425, [5] = 50727, [6] = 49888 }
GA_BiSLists["WARRIOR"]["Arms"]["RS"][14] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50733, [2] = 51940, [3] = 45296, [4] = 51845, [5] = 51880, [6] = 51927 }
GA_BiSLists["WARRIOR"]["Fury"] = {};
GA_BiSLists["WARRIOR"]["Fury"]["PR"] = {};
GA_BiSLists["WARRIOR"]["Fury"]["T9"] = {};
GA_BiSLists["WARRIOR"]["Fury"]["T10"] = {};
GA_BiSLists["WARRIOR"]["Fury"]["RS"] = {};
GA_BiSLists["WARRIOR"]["Fury"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 41386, [2] = 39605, [3] = 42552, [4] = 44902, [5] = 37293, [6] = 37188 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40678, [2] = 44659, [3] = 39421, [4] = 39146, [5] = 37861, [6] = 42645 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40038 } }, [1] = 34388, [2] = 39249, [3] = 39608, [4] = 37139, [5] = 44195, [6] = 39534 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 37647, [2] = 39404, [3] = 39297, [4] = 38614, [5] = 43406, [6] = 37840 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39606, [2] = 43998, [3] = 37722, [4] = 37219, [5] = 37165, [6] = 36950 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 } }, [1] = 44203, [2] = 41355, [3] = 34441, [4] = 37891, [5] = 37366, [6] = 37170 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40038 } }, [1] = 39609, [2] = 37409, [3] = 37363, [4] = 37639, [5] = 37886, [6] = 34341 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40694, [2] = 37088, [3] = 37407, [4] = 37826, [5] = 37171, [6] = 37194 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 34180, [2] = 43994, [3] = 37263, [4] = 37193, [5] = 37644, [6] = 37669 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44306, [2] = 44297, [3] = 34569, [4] = 37666, [5] = 44895, [6] = 37367 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40586, [2] = 37642, [3] = 40474, [4] = 43993, [5] = 39401, [6] = 43251 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42987, [2] = 40684, [3] = 39257, [4] = 37166, [5] = 37390, [6] = 37723 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 37852, [2] = 39417, [3] = 41257, [4] = 37653, [5] = 44249, [6] = 37733 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 37852, [2] = 40497, [3] = 39417, [4] = 41257, [5] = 37653, [6] = 44249 }
GA_BiSLists["WARRIOR"]["Fury"]["PR"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 37191, [2] = 39296, [3] = 39419, [4] = 43612, [5] = 44504, [6] = 44245 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 48383, [2] = 47689, [3] = 45472, [4] = 45610, [5] = 48378, [6] = 47942 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 47060, [2] = 45459, [3] = 47110, [4] = 45945, [5] = 49485, [6] = 47915 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 48381, [2] = 45245, [3] = 47697, [4] = 48380, [5] = 47708, [6] = 45677 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47545, [2] = 47547, [3] = 48674, [4] = 47192, [5] = 48673, [6] = 45461 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 48385, [2] = 47086, [3] = 47082, [4] = 47004, [5] = 47954, [6] = 47589 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40142 } }, [1] = 46967, [2] = 47155, [3] = 45611, [4] = 45869, [5] = 47074, [6] = 47151 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47240, [2] = 48384, [3] = 46043, [4] = 45444, [5] = 47945, [6] = 48377 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40142 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47002, [2] = 47153, [3] = 47112, [4] = 45241, [5] = 46095, [6] = 47152 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48382, [2] = 46975, [3] = 47191, [4] = 48379, [5] = 46150, [6] = 45536 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47077, [2] = 47109, [3] = 47919, [4] = 47154, [5] = 47071, [6] = 47106 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47075, [2] = 46966, [3] = 47934, [4] = 46048, [5] = 45534, [6] = 45157 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45931, [2] = 47131, [3] = 40256, [4] = 45522, [5] = 47115, [6] = 45609 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47078, [2] = 47515, [3] = 47519, [4] = 45516, [5] = 46067, [6] = 48713 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47078, [2] = 47515, [3] = 47519, [4] = 45516, [5] = 46067, [6] = 48713 }
GA_BiSLists["WARRIOR"]["Fury"]["T9"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 46995, [2] = 45296, [3] = 48711, [4] = 47950, [5] = 47659, [6] = 45570 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51227, [2] = 50712, [3] = 50713, [4] = 51866, [5] = 50072, [6] = 50073 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50633, [2] = 54581, [3] = 50728, [4] = 50647, [5] = 51890, [6] = 50180 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51229, [2] = 50674, [3] = 51865, [4] = 51830, [5] = 50020, [6] = 49987 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47545, [2] = 51933, [3] = 47547, [4] = 50653, [5] = 50470, [6] = 50677 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51225, [2] = 50656, [3] = 50606, [4] = 51923, [5] = 50689, [6] = 50001 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 50670, [2] = 50659, [3] = 50655, [4] = 47155, [5] = 50002, [6] = 50333 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50675, [2] = 51226, [3] = 51892, [4] = 51926, [5] = 51844, [6] = 51904 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50620, [2] = 51879, [3] = 50707, [4] = 50688, [5] = 47153, [6] = 51925 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51228, [2] = 50697, [3] = 50645, [4] = 50042, [5] = 51817, [6] = 50624 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40125 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50639, [2] = 50607, [3] = 47077, [4] = 50711, [5] = 51915, [6] = 49983 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40125 } }, [1] = 50402, [2] = 50618, [3] = 50604, [4] = 50693, [5] = 50678, [6] = 51900 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 50343, [3] = 50362, [4] = 47131, [5] = 50706, [6] = 45931 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 49623, [2] = 50730, [3] = 50603, [4] = 51946, [5] = 51905, [6] = 50070 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50730, [2] = 50603, [3] = 51946, [4] = 51905, [5] = 50070, [6] = 49888 }
GA_BiSLists["WARRIOR"]["Fury"]["T10"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50733, [2] = 51940, [3] = 51845, [4] = 51880, [5] = 45296, [6] = 51927 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51227, [2] = 50712, [3] = 50713, [4] = 51866, [5] = 50072, [6] = 50073 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 54581, [2] = 50728, [3] = 50633, [4] = 50647, [5] = 51890, [6] = 50180 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51229, [2] = 50674, [3] = 51865, [4] = 51830, [5] = 50020, [6] = 49987 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47545, [2] = 51933, [3] = 47547, [4] = 50653, [5] = 50470, [6] = 50677 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51225, [2] = 50656, [3] = 50606, [4] = 51923, [5] = 54561, [6] = 50689 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 54580, [2] = 50659, [3] = 50670, [4] = 54559, [5] = 50655, [6] = 47155 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40143 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50675, [2] = 51226, [3] = 51892, [4] = 51926, [5] = 51844, [6] = 51904 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40143 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50620, [2] = 51879, [3] = 50707, [4] = 50688, [5] = 47153, [6] = 51925 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 51228, [2] = 50697, [3] = 50645, [4] = 50042, [5] = 51817, [6] = 50624 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 54578, [2] = 53125, [3] = 54577, [4] = 50639, [5] = 50607, [6] = 47077 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40142 } }, [1] = 50402, [2] = 50618, [3] = 54576, [4] = 50604, [5] = 50693, [6] = 50678 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50363, [2] = 54590, [3] = 50362, [4] = 54569, [5] = 50343, [6] = 47131 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 49623, [2] = 50730, [3] = 50603, [4] = 51946, [5] = 51905, [6] = 50070 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40117 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40117 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50730, [2] = 50603, [3] = 51946, [4] = 51905, [5] = 50070, [6] = 49888 }
GA_BiSLists["WARRIOR"]["Fury"]["RS"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40117 } }, [1] = 50733, [2] = 51940, [3] = 51845, [4] = 51880, [5] = 45296, [6] = 51927 }
GA_BiSLists["WARRIOR"]["Protection"] = {};
GA_BiSLists["WARRIOR"]["Protection"]["PR"] = {};
GA_BiSLists["WARRIOR"]["Protection"]["T9"] = {};
GA_BiSLists["WARRIOR"]["Protection"]["T10"] = {};
GA_BiSLists["WARRIOR"]["Protection"]["RS"] = {};
GA_BiSLists["WARRIOR"]["Protection"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 41387, [2] = 39610, [3] = 42549, [4] = 39395, [5] = 44902, [6] = 34401 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40679, [2] = 39470, [3] = 44660, [4] = 37646, [5] = 42646, [6] = 37689 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 34389, [2] = 39267, [3] = 44312, [4] = 39613, [5] = 37814, [6] = 37635 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 37728, [2] = 43988, [3] = 37197, [4] = 39225, [5] = 43565, [6] = 44188 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 39611, [2] = 39398, [3] = 44198, [4] = 37658, [5] = 37735, [6] = 34394 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 } }, [1] = 37620, [2] = 39467, [3] = 37682, [4] = 40887, [5] = 37040, [6] = 34442 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44529 }, [2] = { ["type"] = "item", ["id"] = 40034 } }, [1] = 39622, [2] = 39197, [3] = 37645, [4] = 44183, [5] = 37862, [6] = 43213 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40089 } }, [1] = 40689, [2] = 39298, [3] = 34547, [4] = 37379, [5] = 37241, [6] = 37801 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40034 } }, [1] = 43500, [2] = 39258, [3] = 39612, [4] = 37292, [5] = 37688, [6] = 34381 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 } }, [1] = 44201, [2] = 39234, [3] = 37082, [4] = 44243, [5] = 44895, [6] = 40878 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 34213, [2] = 37784, [3] = 40426, [4] = 39141, [5] = 37186, [6] = 42643 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 37220, [2] = 36993, [3] = 44063, [4] = 42341, [5] = 39292, [6] = 44323 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 } }, [1] = 37401, [2] = 40491, [3] = 39270, [4] = 39344, [5] = 37260, [6] = 37255 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 } }, [1] = 40701, [2] = 40475, [3] = 39276, [4] = 43085, [5] = 42508, [6] = 37162 }
GA_BiSLists["WARRIOR"]["Protection"]["PR"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 41168, [2] = 39419, [3] = 43612, [4] = 40716, [5] = 44118, [6] = 37615 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 48433, [2] = 48430, [3] = 47677, [4] = 49479, [5] = 48429, [6] = 46166 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 47133, [2] = 47939, [3] = 45485, [4] = 49492, [5] = 47116, [6] = 47679 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 48455, [2] = 47944, [3] = 48454, [4] = 47698, [5] = 47720, [6] = 46167 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47549, [2] = 47063, [3] = 48675, [4] = 45496, [5] = 47547, [6] = 47042 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40130 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40166 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 46968, [2] = 48451, [3] = 46962, [4] = 48450, [5] = 47964, [6] = 46039 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 47111, [2] = 47570, [3] = 47918, [4] = 47108, [5] = 46967, [6] = 45111 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44529 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 48453, [2] = 45487, [3] = 48452, [4] = 45228, [5] = 46164, [6] = 45834 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40130 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47076, [2] = 47072, [3] = 47937, [4] = 45139, [5] = 47002, [6] = 45825 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40130 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 48447, [2] = 47061, [3] = 48446, [4] = 45594, [5] = 47052, [6] = 48445 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40130 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47003, [2] = 47952, [3] = 46997, [4] = 45988, [5] = 47154, [6] = 45542 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 47157, [2] = 45471, [3] = 47955, [4] = 47149, [5] = 47731, [6] = 45247 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47088, [2] = 45158, [3] = 47080, [4] = 46021, [5] = 47216, [6] = 49487 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 47506, [2] = 47001, [3] = 45442, [4] = 45876, [5] = 48714, [6] = 47967 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 45587, [2] = 46964, [3] = 47978, [4] = 45877, [5] = 46963, [6] = 47835 }
GA_BiSLists["WARRIOR"]["Protection"]["T9"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 47660, [2] = 45137, [3] = 47521, [4] = 45570, [5] = 46995, [6] = 48711 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 51221, [2] = 50640, [3] = 49986, [4] = 48433, [5] = 51218, [6] = 48430 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 50682, [2] = 50627, [3] = 50195, [4] = 50023, [5] = 51934, [6] = 47133 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51224, [2] = 51215, [3] = 50849, [4] = 51847, [5] = 50003, [6] = 48455 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 50718, [2] = 47549, [3] = 50074, [4] = 51888, [5] = 50466, [6] = 47063 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40130 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51220, [2] = 50681, [3] = 50024, [4] = 50968, [5] = 51917, [6] = 46968 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 50611, [2] = 49960, [3] = 51901, [4] = 47111, [5] = 47570, [6] = 47918 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44529 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 51222, [2] = 50716, [3] = 51835, [4] = 51217, [5] = 50978, [6] = 50075 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40130 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50691, [2] = 51831, [3] = 50036, [4] = 50991, [5] = 47076, [6] = 51564 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51223, [2] = 50612, [3] = 48447, [4] = 51895, [5] = 49964, [6] = 51216 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50625, [2] = 50190, [3] = 51816, [4] = 49907, [5] = 47003, [6] = 47952 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50404, [2] = 50622, [3] = 50642, [4] = 51913, [5] = 50447, [6] = 50185 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50364, [2] = 47088, [3] = 50344, [4] = 50356, [5] = 50361, [6] = 47080 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50738, [2] = 50654, [3] = 50708, [4] = 51947, [5] = 49997, [6] = 51869 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 }, [2] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 50729, [2] = 50065, [3] = 50794, [4] = 46964, [5] = 45587, [6] = 47978 }
GA_BiSLists["WARRIOR"]["Protection"]["T10"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51834, [2] = 50444, [3] = 50733, [4] = 51940, [5] = 51880, [6] = 47660 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40141 } }, [1] = 51221, [2] = 50640, [3] = 49986, [4] = 48433, [5] = 51218, [6] = 48430 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40141 } }, [1] = 50682, [2] = 50627, [3] = 50195, [4] = 50023, [5] = 51934, [6] = 47133 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51224, [2] = 51215, [3] = 50849, [4] = 51847, [5] = 50003, [6] = 48455 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 50718, [2] = 47549, [3] = 50074, [4] = 51888, [5] = 50466, [6] = 47063 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40141 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51220, [2] = 50681, [3] = 50024, [4] = 50968, [5] = 51917, [6] = 46968 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 50611, [2] = 49960, [3] = 51901, [4] = 47111, [5] = 47570, [6] = 47918 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44529 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 51222, [2] = 50716, [3] = 51835, [4] = 51217, [5] = 50978, [6] = 50075 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40130 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50691, [2] = 51831, [3] = 50036, [4] = 50991, [5] = 47076, [6] = 51564 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51223, [2] = 50612, [3] = 48447, [4] = 51895, [5] = 49964, [6] = 51216 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 54579, [2] = 50625, [3] = 53129, [4] = 54564, [5] = 50190, [6] = 51816 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 50404, [2] = 50622, [3] = 50642, [4] = 51913, [5] = 50447, [6] = 50185 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50364, [2] = 47088, [3] = 54591, [4] = 50344, [5] = 50356, [6] = 50361 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50738, [2] = 50654, [3] = 50708, [4] = 51947, [5] = 49997, [6] = 51869 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 }, [2] = { ["type"] = "item", ["id"] = 40130 } }, [1] = 50729, [2] = 50065, [3] = 50794, [4] = 46964, [5] = 45587, [6] = 47978 }
GA_BiSLists["WARRIOR"]["Protection"]["RS"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51834, [2] = 50444, [3] = 50733, [4] = 51940, [5] = 51880, [6] = 47660 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"] = {};
GA_BiSLists["WARRIOR"]["Arms"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40528, [2] = 41386, [3] = 40543, [4] = 40344, [5] = 44006, [6] = 39399 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44664, [2] = 40065, [3] = 44659, [4] = 39421, [5] = 40369, [6] = 42645 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40037 } }, [1] = 40530, [2] = 40414, [3] = 40185, [4] = 39249, [5] = 40315, [6] = 39608 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 40403, [2] = 40250, [3] = 39404, [4] = 40721, [5] = 39297, [6] = 38614 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40539, [2] = 39767, [3] = 40525, [4] = 40277, [5] = 39606, [6] = 43998 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40330, [2] = 40282, [3] = 39765, [4] = 39278, [5] = 40186, [6] = 40738 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 } }, [1] = 40541, [2] = 40261, [3] = 40262, [4] = 39727, [5] = 37409, [6] = 39194 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40260, [2] = 40278, [3] = 39762, [4] = 40692, [5] = 39345, [6] = 40205 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 42702 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40037 } }, [1] = 40318, [2] = 44011, [3] = 40294, [4] = 43994, [5] = 37263, [6] = 37193 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 } }, [1] = 40591, [2] = 40206, [3] = 39701, [4] = 40549, [5] = 40746, [6] = 40742 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40474, [2] = 43993, [3] = 40074, [4] = 40717, [5] = 43251, [6] = 40586 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 40256, [2] = 42987, [3] = 37166, [4] = 39257, [5] = 40684, [6] = 40431 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 40384, [2] = 40497, [3] = 40208, [4] = 39417, [5] = 39221, [6] = 42317 }
GA_BiSLists["WARRIOR"]["Arms"]["T7"][14] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 40385, [2] = 40190, [3] = 40265, [4] = 43612, [5] = 39296, [6] = 40346 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"] = {};
GA_BiSLists["WARRIOR"]["Arms"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40038 } }, [1] = 45472, [2] = 45610, [3] = 45107, [4] = 46151, [5] = 45329, [6] = 45993 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45459, [2] = 45945, [3] = 45285, [4] = 45819, [5] = 45517, [6] = 45820 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40038 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 46037, [2] = 45245, [3] = 45677, [4] = 45227, [5] = 46149, [6] = 45320 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40037 } }, [1] = 46032, [2] = 45461, [3] = 45588, [4] = 46320, [5] = 45704, [6] = 45138 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45473, [2] = 45524, [3] = 45712, [4] = 46146, [5] = 39767, [6] = 40525 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45663, [2] = 45869, [3] = 45264, [4] = 45888, [5] = 40330, [6] = 45454 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 45444, [2] = 46043, [3] = 45325, [4] = 40541, [5] = 45997, [6] = 40261 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 45241, [2] = 45547, [3] = 45555, [4] = 45824, [5] = 46095, [6] = 45161 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 45536, [2] = 45982, [3] = 45248, [4] = 45844, [5] = 46150, [6] = 45134 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45599, [2] = 45989, [3] = 45244, [4] = 45564, [5] = 45501, [6] = 40591 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45608, [2] = 46322, [3] = 46048, [4] = 45534, [5] = 45157, [6] = 45675 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 46038, [2] = 45931, [3] = 40256, [4] = 45522, [5] = 45286, [6] = 45609 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 45516, [2] = 45533, [3] = 45868, [4] = 45498, [5] = 46067, [6] = 45458 }
GA_BiSLists["WARRIOR"]["Arms"]["T8"][14] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45296, [2] = 45570, [3] = 45870, [4] = 46018, [5] = 45086, [6] = 45309 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"] = {};
GA_BiSLists["WARRIOR"]["Fury"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 44006, [2] = 41386, [3] = 40528, [4] = 40543, [5] = 40344, [6] = 39605 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44664, [2] = 40065, [3] = 44659, [4] = 39421, [5] = 40369, [6] = 39146 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40037 } }, [1] = 40530, [2] = 40414, [3] = 40185, [4] = 39249, [5] = 39608, [6] = 44003 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 40403, [2] = 40250, [3] = 40721, [4] = 39404, [5] = 39297, [6] = 38614 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40539, [2] = 40525, [3] = 39767, [4] = 40277, [5] = 39606, [6] = 43998 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39765, [2] = 40330, [3] = 40282, [4] = 40733, [5] = 40186, [6] = 39729 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 } }, [1] = 40541, [2] = 40261, [3] = 40262, [4] = 39727, [5] = 40527, [6] = 40362 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40205, [2] = 40278, [3] = 40260, [4] = 40317, [5] = 39762, [6] = 39345 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40529, [2] = 44011, [3] = 40318, [4] = 40294, [5] = 43994, [6] = 39761 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 } }, [1] = 40591, [2] = 40206, [3] = 39701, [4] = 40549, [5] = 39706, [6] = 40742 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40474, [2] = 43993, [3] = 40074, [4] = 40717, [5] = 40075, [6] = 39401 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 40256, [2] = 42987, [3] = 40531, [4] = 40684, [5] = 39257, [6] = 37166 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 40384, [2] = 40497, [3] = 39417, [4] = 39758, [5] = 40208, [6] = 40406 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 40384, [2] = 40497, [3] = 39417, [4] = 39758, [5] = 40208, [6] = 40406 }
GA_BiSLists["WARRIOR"]["Fury"]["T7"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 40385, [2] = 40190, [3] = 40265, [4] = 40346, [5] = 39296, [6] = 39419 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"] = {};
GA_BiSLists["WARRIOR"]["Fury"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 46151, [2] = 45472, [3] = 45610, [4] = 45107, [5] = 45993, [6] = 45893 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45459, [2] = 45945, [3] = 45517, [4] = 45285, [5] = 45819, [6] = 45820 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 46149, [2] = 45245, [3] = 45677, [4] = 45320, [5] = 46037, [6] = 45227 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40037 } }, [1] = 46032, [2] = 45461, [3] = 45588, [4] = 46320, [5] = 45704, [6] = 45138 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 46146, [2] = 45473, [3] = 45524, [4] = 45453, [5] = 45712, [6] = 45225 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40037 } }, [1] = 45611, [2] = 45869, [3] = 45264, [4] = 45663, [5] = 45888, [6] = 40330 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40037 } }, [1] = 46148, [2] = 45444, [3] = 46043, [4] = 45325, [5] = 45430, [6] = 40541 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 46095, [2] = 45241, [3] = 46041, [4] = 45829, [5] = 45547, [6] = 45555 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45536, [2] = 45982, [3] = 46150, [4] = 45134, [5] = 45248, [6] = 45432 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40002 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40002 } }, [1] = 45599, [2] = 45989, [3] = 45564, [4] = 45244, [5] = 45501, [6] = 45232 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45608, [2] = 46322, [3] = 46048, [4] = 45534, [5] = 45157, [6] = 45540 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45931, [2] = 45609, [3] = 40256, [4] = 45522, [5] = 45286, [6] = 46038 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45516, [2] = 45533, [3] = 46067, [4] = 45868, [5] = 45521, [6] = 45498 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45516, [2] = 46067, [3] = 45868, [4] = 45521, [5] = 45233, [6] = 45165 }
GA_BiSLists["WARRIOR"]["Fury"]["T8"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45296, [2] = 45570, [3] = 45870, [4] = 45086, [5] = 46018, [6] = 45309 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"] = {};
GA_BiSLists["WARRIOR"]["Protection"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40034 } }, [1] = 40546, [2] = 44006, [3] = 39610, [4] = 40328, [5] = 42549, [6] = 39395 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40387, [2] = 44665, [3] = 40069, [4] = 39470, [5] = 44660, [6] = 40679 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40034 } }, [1] = 39704, [2] = 40548, [3] = 39267, [4] = 40334, [5] = 44312, [6] = 39613 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 40722, [2] = 40410, [3] = 40252, [4] = 43988, [5] = 37197, [6] = 39225 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 44000, [2] = 39767, [3] = 40203, [4] = 39398, [5] = 40279, [6] = 40544 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 } }, [1] = 39764, [2] = 40734, [3] = 40306, [4] = 39467, [5] = 37620, [6] = 37682 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44529 }, [2] = { ["type"] = "item", ["id"] = 40034 } }, [1] = 40545, [2] = 40188, [3] = 39726, [4] = 39197, [5] = 39622, [6] = 37645 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 39759, [2] = 39298, [3] = 34547, [4] = 40263, [5] = 40689, [6] = 37379 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 } }, [1] = 40589, [2] = 40446, [3] = 40547, [4] = 39258, [5] = 40240, [6] = 39612 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 } }, [1] = 40297, [2] = 39717, [3] = 40743, [4] = 39234, [5] = 37082, [6] = 44243 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40718, [2] = 40370, [3] = 40075, [4] = 40107, [5] = 40426, [6] = 39141 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 37220, [2] = 40257, [3] = 44063, [4] = 42341, [5] = 39292, [6] = 36993 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 } }, [1] = 40402, [2] = 40264, [3] = 40491, [4] = 39730, [5] = 39270, [6] = 39344 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 } }, [1] = 40400, [2] = 40475, [3] = 40266, [4] = 39276, [5] = 40701, [6] = 43085 }
GA_BiSLists["WARRIOR"]["Protection"]["T7"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 41168, [2] = 40265, [3] = 40385, [4] = 40190, [5] = 39419, [6] = 43612 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"] = {};
GA_BiSLists["WARRIOR"]["Protection"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 46166, [2] = 45502, [3] = 45935, [4] = 45472, [5] = 45425, [6] = 40546 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 45485, [2] = 45821, [3] = 45262, [4] = 45538, [5] = 44665, [6] = 45696 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 46167, [2] = 45251, [3] = 45428, [4] = 45697, [5] = 39704, [6] = 40548 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 }, [2] = { ["type"] = "item", ["id"] = 40034 } }, [1] = 45496, [2] = 45319, [3] = 45588, [4] = 46014, [5] = 45322, [6] = 40722 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 46039, [2] = 45334, [3] = 46162, [4] = 45424, [5] = 39767, [6] = 40203 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 } }, [1] = 45111, [2] = 45283, [3] = 39764, [4] = 40734, [5] = 40306, [6] = 39467 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44529 }, [2] = { ["type"] = "item", ["id"] = 40034 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 45487, [2] = 45228, [3] = 46164, [4] = 45834, [5] = 45426, [6] = 45310 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45139, [2] = 45825, [3] = 45551, [4] = 45241, [5] = 45304, [6] = 39759 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40034 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 45594, [2] = 45295, [3] = 46169, [4] = 45842, [5] = 45427, [6] = 40589 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45988, [2] = 45542, [3] = 45166, [4] = 45560, [5] = 45599, [6] = 39717 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 45471, [2] = 45247, [3] = 45326, [4] = 45112, [5] = 45874, [6] = 45871 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45158, [2] = 46021, [3] = 44063, [4] = 37220, [5] = 42341, [6] = 40257 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 }, [2] = { ["type"] = "item", ["id"] = 40034 } }, [1] = 45442, [2] = 45876, [3] = 46036, [4] = 45110, [5] = 45142, [6] = 45315 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45587, [2] = 45877, [3] = 45450, [4] = 45707, [5] = 40400, [6] = 40475 }
GA_BiSLists["WARRIOR"]["Protection"]["T8"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 45137, [2] = 45570, [3] = 45296, [4] = 45870, [5] = 45086, [6] = 41168 }
end


