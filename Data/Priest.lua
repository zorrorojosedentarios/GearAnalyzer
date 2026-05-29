-- ============================================================
-- GearAnalyzer: Priest (PRIEST)
-- Data-on-Demand Module
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

function GearAnalyzer:LoadPriestData()
    if rawget(self.ClassData, "PRIEST") then return end

    self.ClassData["PRIEST"] = {
        Glyphs = {
            ["Discipline"] = {
                major = { 45756, 45758, 42408 }, -- Penitencia, Himno de esperanza, Palabra de poder: escudo
                minor = { 43374, 43370, 43371 }  -- Maligno de las sombras, Levitar, Gran entereza
            },
            ["Holy"] = {
                major = { 42396, 45755, 42400 }, -- Círculo de sanación, Espíritu guardián, Destello de Luz
                minor = { 43374, 43370, 43371 }  -- Maligno de las sombras, Levitar, Gran entereza
            },
            ["Shadow"] = {
                major = { 42406, 45753, 42407 }, -- Tortura mental, Dispersión, Sombra
                minor = { 43374, 43370, 43372 }  -- Maligno de las sombras, Levitar, Proteccion contra las Sombras
            }
        },
        Gems = {
            ["Discipline"] = {
                meta = 41333, -- Diamante de llama celeste de ascuas (+25 Poder con Hechizos / +2% Intelecto)
                red = 40113, -- Rubí cárdeno rúnico (+23 Poder con Hechizos)
                yellow = 40152, -- Ametrino pujante (+12 SP / +10 Crítico)
                blue = 40113, -- Rubí cárdeno rúnico (Ignore color, Full SP para Escudos)
                note = "FULL SP Y CRÍTICO. Rojas: SP. Amarillas: SP+Crítico (pujante) para activar Égida Divina. Azules: SP puro o SP+Espíritu solo si el bonus de ranura da mucho SP. Sin Espíritu."
            },
            ["Holy"] = {
                meta = 41333, -- Diamante de llama celeste de ascuas (+25 Poder con Hechizos / +2% Intelecto)
                red = 40113, -- Rubí cárdeno rúnico (+23 Poder con Hechizos)
                yellow = 40155, -- Ametrino temerario (+12 SP / +10 Celeridad)
                blue = 40133, -- Piedra de terror purificada (+12 Poder con Hechizos / +10 Espíritu)
                note = "Poder con Hechizos > Espíritu. Rojas: SP. Amarillas: SP+Celeridad (temerario). Azules: SP+Espíritu (purificada)."
            },
            ["Shadow"] = {
                meta = 41285, -- Diamante de llama celeste caótico (+21 Crítico / +3% Daño crítico)
                red = 40113, -- Rubí cárdeno rúnico (+23 Poder con Hechizos)
                yellow = 40155, -- Ametrino temerario (+12 Poder con Hechizos / +10 Celeridad)
                blue = 40133, -- Piedra de terror purificada (+12 Poder con Hechizos / +10 Espíritu)
                note = "SP > Celeridad. Rojas: SP. Amarillas: SP+Celeridad. Azules: SP+Espíritu (para Meta)."
            }
        },
        TalentTrees = {
            [1] = { name = "Discipline", icon = "Interface\\Icons\\Spell_Holy_WordFortitude" },
            [2] = { name = "Holy", icon = "Interface\\Icons\\Spell_Holy_GuardianSpirit" },
            [3] = { name = "Shadow", icon = "Interface\\Icons\\Spell_Shadow_ShadowWordPain" },
        },
        Caps = {
            ["Discipline"] = {
                role = "Healer",
                priorities = {
                    { stat = "SP", label = "Poder de Hechizos", note = "Escala tamaño de la absorción de escudos" },
                    { stat = "HASTE", cap = 434, label = "Celeridad", note = "Soft 434 (GCD escudo a 1.0s con talentos Prestidigitación)" },
                    { stat = "CRIT", cap = 30, label = "Crítico", isPercent = true, note = "Activa Égida Divina (Absorción extra)" },
                }
            },
            ["Shadow"] = {
                role = "Caster",
                hitCap = { percent = 11, rating = 289 },
                priorities = {
                    { stat = "HASTE", cap = 1269, label = "Celeridad", note = "Soft 1100 / Hard 1260-1269 (Extra Tick Peste Devoradora)" },
                    { stat = "SP", label = "Poder de Hechizos" },
                    { stat = "CRIT", label = "Crítico" },
                },
                gemAdjustments = {
                    { stat = "HIT", target = 289, yellow = 40153 }, -- Ametrino velado (SP/Hit)
                }
            },
            ["Holy"] = {
                role = "Healer",
                priorities = {
                    { stat = "SP", label = "Poder de Hechizos", note = "Sanación base" },
                    { stat = "SPIRIT", label = "Espíritu", note = "Regeneración de maná y SP por Meditación Espiritual" },
                    { stat = "HASTE", cap = 857, label = "Celeridad", note = "Soft 600 / Hard 857 (GCD Hechizos de casteo corto)" },
                }
            }
        },
        Enchants = {
            ["Discipline"] = {
                ["weapon"]    = { 3834, 3854 }, -- 1H: +63 SP / 2H: +81 SP
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
            ["Shadow"] = {
                ["weapon"]    = { 3834, 3854 }, -- 1H: +63 SP / 2H: +81 SP
                ["head"]      = 3820,   -- Arcanum de misterios ardientes
                ["shoulders"] = 3810,   -- Inscripción de la tormenta superior
                ["back"]      = 3722,   -- Bordado de tejido de luz (Sastrería)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 2332,   -- Poder con hechizos excelente (+30)
                ["hands"]     = 3246,   -- Poder con hechizos excepcional (+28)
                ["legs"]      = 3872,   -- Hilo de hechizo santificado (+50 SP / +20 Espíritu)
                ["feet"]      = 3826,   -- Caminante de hielo (+12 Hit / +12 Crit)
                ["waist"]     = 3731,   -- Hebilla eterna
                ["offhand"]   = 0,
            },
            ["Holy"] = {
                ["weapon"]    = { 3834, 3854 }, -- 1H: +63 SP / 2H: +81 SP
                ["head"]      = 3820,   -- Arcanum de misterios ardientes
                ["shoulders"] = 3810,   -- Inscripción de la tormenta superior
                ["back"]      = 3831,
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 2332,   -- Poder con hechizos excelente (+30)
                ["hands"]     = 3246,   -- Poder con hechizos excepcional (+28)
                ["legs"]      = 3719,   -- Hilo de hechizo luminoso
                ["feet"]      = 3826,   -- Caminante de hielo
                ["waist"]     = 3731,   -- Hebilla eterna
                ["offhand"]   = 0,
            }
        },
        Talents = {
            ["Discipline"] = {
                label = "57/14/0 - Sacerdote Disciplina (PVE)",
                exportCode = "0503203131302512331023231251005501030000000000000000000000000000000000000000000000",
                [1] = { name = "Discipline", points = 57 },
                [2] = { name = "Holy", points = 14 },
                [3] = { name = "Sombra", points = 0 }
            },
            ["Holy"] = {
                label = "13/58/0 - Sacerdote Sagrado (Heal en Banda)",
                exportCode = "0503203000000000000000000000235050032002152530025331051000000000000000000000000000",
                [1] = { name = "Discipline", points = 13 },
                [2] = { name = "Holy", points = 58 },
                [3] = { name = "Sombra", points = 0 }
            },
            ["Shadow"] = {
                label = "17/0/54 - Sacerdote Sombras (PVE DPS)",
                exportCode = "0503203110200000000000000000000000000000000000000000000325023001223012223152301351",
                [1] = { name = "Discipline", points = 17 },
                [2] = { name = "Holy", points = 0 },
                [3] = { name = "Sombra", points = 54 }
            }
        }
    }

    GA_BiSLists["PRIEST"] = GA_BiSLists["PRIEST"] or {}
GA_BiSLists["PRIEST"]["Discipline"] = {};
GA_BiSLists["PRIEST"]["Discipline"]["PR"] = {};
GA_BiSLists["PRIEST"]["Discipline"]["T9"] = {};
GA_BiSLists["PRIEST"]["Discipline"]["T10"] = {};
GA_BiSLists["PRIEST"]["Discipline"]["RS"] = {};
GA_BiSLists["PRIEST"]["Discipline"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 37294, [2] = 39295, [3] = 39514, [4] = 42553, [5] = 44909, [6] = 34339 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40681, [2] = 44657, [3] = 39232, [4] = 42647, [5] = 42023, [6] = 37683 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 40051 } }, [1] = 37196, [2] = 39310, [3] = 37673, [4] = 37655, [5] = 34202, [6] = 41550 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 41609, [2] = 39425, [3] = 37291, [4] = 34242, [5] = 42056, [6] = 44167 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40027 } }, [1] = 39515, [2] = 42102, [3] = 44180, [4] = 37258, [5] = 37222, [6] = 34399 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 } }, [1] = 37361, [2] = 37725, [3] = 37884, [4] = 41555, [5] = 37613, [6] = 34435 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 39519, [2] = 42113, [3] = 39285, [4] = 37825, [5] = 37172, [6] = 43287 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40697, [2] = 39190, [3] = 44302, [4] = 37289, [5] = 37242, [6] = 37637 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 } }, [1] = 37854, [2] = 39408, [3] = 39517, [4] = 39309, [5] = 37622, [6] = 34386 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 44202, [2] = 37730, [3] = 36954, [4] = 44900, [5] = 37218, [6] = 37867 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 44283, [2] = 42644, [3] = 37694, [4] = 37192, [5] = 40585, [6] = 43408 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42988, [2] = 40685, [3] = 37835, [4] = 42413, [5] = 44255, [6] = 44322 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 37169, [2] = 39423, [3] = 40488, [4] = 39424, [5] = 37360, [6] = 41384 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 44210, [2] = 40699, [3] = 39311, [4] = 37718, [5] = 37051, [6] = 37889 }
GA_BiSLists["PRIEST"]["Discipline"]["PR"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 37238, [2] = 39426, [3] = 39473, [4] = 37619, [5] = 34348, [6] = 37626 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 46197, [2] = 48035, [3] = 45497, [4] = 47984, [5] = 47694, [6] = 49483 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 47930, [2] = 47144, [3] = 46047, [4] = 45443, [5] = 47957, [6] = 45243 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 46190, [2] = 48029, [3] = 47987, [4] = 47715, [5] = 46068, [6] = 45390 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40134 } }, [1] = 47238, [2] = 47552, [3] = 47553, [4] = 48671, [5] = 46977, [6] = 45618 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 46193, [2] = 48031, [3] = 47605, [4] = 46993, [5] = 47986, [6] = 47603 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47587, [2] = 47208, [3] = 45446, [4] = 47585, [5] = 47203, [6] = 44008 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 46188, [2] = 45520, [3] = 47236, [4] = 45665, [5] = 48037, [6] = 47235 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 45619, [2] = 46973, [3] = 47977, [4] = 45558, [5] = 47837, [6] = 46972 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47189, [2] = 47062, [3] = 45488, [4] = 48033, [5] = 47931, [6] = 46034 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 46050, [2] = 47097, [3] = 45135, [4] = 49234, [5] = 45537, [6] = 45567 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 47237, [2] = 47733, [3] = 47224, [4] = 45495, [5] = 45614, [6] = 47054 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47059, [2] = 40432, [3] = 45535, [4] = 47041, [5] = 45308, [6] = 45929 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 47206, [3] = 45612, [4] = 47524, [5] = 45457, [6] = 47962 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 47146, [2] = 47138, [3] = 45271, [4] = 49490, [5] = 45314, [6] = 39766 }
GA_BiSLists["PRIEST"]["Discipline"]["T9"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 45294, [2] = 45170, [3] = 47922, [4] = 47658, [5] = 45713, [6] = 47612 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40134 } }, [1] = 51261, [2] = 50661, [3] = 51178, [4] = 50006, [5] = 48035, [6] = 51837 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50700, [2] = 50061, [3] = 50724, [4] = 50609, [5] = 51894, [6] = 51863 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51264, [2] = 50449, [3] = 51883, [4] = 51175, [5] = 48029, [6] = 47987 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50468, [2] = 50628, [3] = 47552, [4] = 47238, [5] = 50668, [6] = 47553 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51263, [2] = 50975, [3] = 50717, [4] = 51176, [5] = 48031, [6] = 50172 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50686, [2] = 50032, [3] = 51918, [4] = 47587, [5] = 47208, [6] = 45446 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51260, [2] = 50984, [3] = 50722, [4] = 45520, [5] = 50176, [6] = 51874 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50702, [2] = 50613, [3] = 50063, [4] = 51862, [5] = 49978, [6] = 45619 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51823, [2] = 49892, [3] = 51262, [4] = 51882, [5] = 51177, [6] = 47189 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51850, [2] = 50699, [3] = 49893, [4] = 51899, [5] = 50062, [6] = 47097 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50400, [2] = 50720, [3] = 50644, [4] = 50174, [5] = 50664, [6] = 50610 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50366, [2] = 47059, [3] = 50359, [4] = 40432, [5] = 50358, [6] = 50346 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50734, [2] = 50731, [3] = 50608, [4] = 50685, [5] = 46017, [6] = 51944 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 47146, [2] = 50719, [3] = 50635, [4] = 51922, [5] = 50173, [6] = 50423 }
GA_BiSLists["PRIEST"]["Discipline"]["T10"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50631, [2] = 50684, [3] = 51838, [4] = 50472, [5] = 50033, [6] = 51852 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40134 } }, [1] = 51261, [2] = 50661, [3] = 51178, [4] = 50006, [5] = 48035, [6] = 51837 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50700, [2] = 50061, [3] = 50724, [4] = 50609, [5] = 51894, [6] = 51863 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51264, [2] = 50449, [3] = 51883, [4] = 51175, [5] = 48029, [6] = 47987 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 54583, [2] = 50468, [3] = 50628, [4] = 47552, [5] = 47238, [6] = 50668 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51263, [2] = 50975, [3] = 50717, [4] = 51176, [5] = 48031, [6] = 50172 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50686, [2] = 54582, [3] = 50032, [4] = 51918, [5] = 53486, [6] = 47587 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51260, [2] = 50984, [3] = 50722, [4] = 45520, [5] = 50176, [6] = 51874 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50702, [2] = 50613, [3] = 50063, [4] = 51862, [5] = 49978, [6] = 45619 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51823, [2] = 49892, [3] = 51262, [4] = 51882, [5] = 51177, [6] = 47189 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51850, [2] = 50699, [3] = 49893, [4] = 51899, [5] = 50062, [6] = 47097 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50400, [2] = 50720, [3] = 50644, [4] = 54585, [5] = 50174, [6] = 50664 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50366, [2] = 47059, [3] = 50359, [4] = 54589, [5] = 40432, [6] = 54573 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50734, [2] = 50731, [3] = 50608, [4] = 50685, [5] = 46017, [6] = 51944 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 47146, [2] = 50719, [3] = 50635, [4] = 51922, [5] = 50173, [6] = 50423 }
GA_BiSLists["PRIEST"]["Discipline"]["RS"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50631, [2] = 50684, [3] = 51838, [4] = 50472, [5] = 50033, [6] = 51852 }
GA_BiSLists["PRIEST"]["Holy"] = {};
GA_BiSLists["PRIEST"]["Holy"]["PR"] = {};
GA_BiSLists["PRIEST"]["Holy"]["T9"] = {};
GA_BiSLists["PRIEST"]["Holy"]["T10"] = {};
GA_BiSLists["PRIEST"]["Holy"]["RS"] = {};
GA_BiSLists["PRIEST"]["Holy"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40047 } }, [1] = 37294, [2] = 43995, [3] = 39514, [4] = 42553, [5] = 37684, [6] = 34339 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40681, [2] = 44657, [3] = 39392, [4] = 40486, [5] = 42647, [6] = 37683 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 } }, [1] = 37655, [2] = 39310, [3] = 39518, [4] = 37673, [5] = 37196, [6] = 37691 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 41609, [2] = 39425, [3] = 37630, [4] = 37799, [5] = 37291, [6] = 34242 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 } }, [1] = 42102, [2] = 44180, [3] = 39515, [4] = 37258, [5] = 37222, [6] = 34233 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 } }, [1] = 37361, [2] = 39390, [3] = 37884, [4] = 37725, [5] = 44200, [6] = 37613 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 } }, [1] = 42113, [2] = 39519, [3] = 39285, [4] = 37172, [5] = 37798, [6] = 37825 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40047 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40697, [2] = 39190, [3] = 44302, [4] = 37242, [5] = 37637, [6] = 37289 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 } }, [1] = 37854, [2] = 39408, [3] = 39517, [4] = 39309, [5] = 37622, [6] = 37189 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 44202, [2] = 39254, [3] = 37730, [4] = 37867, [5] = 37218, [6] = 37629 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 44283, [2] = 40585, [3] = 39250, [4] = 37694, [5] = 37192, [6] = 42647 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 44255, [2] = 37111, [3] = 42413, [4] = 40430, [5] = 44322, [6] = 28823 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62948 } }, [1] = 37360, [2] = 40488, [3] = 39423, [4] = 39424, [5] = 37169, [6] = 41384 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 44210, [2] = 40699, [3] = 37718, [4] = 37051, [5] = 37889, [6] = -1 }
GA_BiSLists["PRIEST"]["Holy"]["PR"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 37619, [2] = 39426, [3] = 39473, [4] = 37238, [5] = 34348, [6] = 37626 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 48035, [2] = 45497, [3] = 47694, [4] = 47984, [5] = 49482, [6] = 49483 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 45243, [2] = 47144, [3] = 45443, [4] = 45447, [5] = 47139, [6] = 45933 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 48029, [2] = 47715, [3] = 46068, [4] = 46190, [5] = 47987, [6] = 45253 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47553, [2] = 47552, [3] = 46977, [4] = 48672, [5] = 48671, [6] = 45618 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 46993, [2] = 48083, [3] = 48080, [4] = 46992, [5] = 47603, [6] = 48075 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 47208, [2] = 45446, [3] = 47203, [4] = 47585, [5] = 47927, [6] = 44008 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 48037, [2] = 45665, [3] = 47236, [4] = 47983, [5] = 47235, [6] = 45520 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 46973, [2] = 46972, [3] = 45619, [4] = 47977, [5] = 45119, [6] = 47921 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 48033, [2] = 47062, [3] = 47985, [4] = 47051, [5] = 46195, [6] = 47980 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47097, [2] = 45135, [3] = 47092, [4] = 47205, [5] = 45537, [6] = 45566 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 45495, [2] = 47224, [3] = 47732, [4] = 45614, [5] = 47237, [6] = 47223 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47059, [2] = 46051, [3] = 47041, [4] = 45535, [5] = 40432, [6] = 45703 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 47206, [3] = 47524, [4] = 45886, [5] = 45457, [6] = 45612 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 47146, [2] = 47138, [3] = 45271, [4] = 49490, [5] = 39766, [6] = 45314 }
GA_BiSLists["PRIEST"]["Holy"]["T9"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 47922, [2] = 45511, [3] = 45294, [4] = 45170, [5] = 47612, [6] = 39426 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 51261, [2] = 50661, [3] = 51896, [4] = 51837, [5] = 50006, [6] = 51178 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 50609, [2] = 50724, [3] = 49975, [4] = 51871, [5] = 50700, [6] = 50182 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51264, [2] = 51883, [3] = 50449, [4] = 51175, [5] = 51859, [6] = 47715 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 50668, [2] = 47553, [3] = 50628, [4] = 50014, [5] = 47552, [6] = 51848 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50717, [2] = 51851, [3] = 50172, [4] = 51263, [5] = 50974, [6] = 46993 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 50686, [2] = 47208, [3] = 51872, [4] = 50032, [5] = 51918, [6] = 45446 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 51260, [2] = 50722, [3] = 50176, [4] = 51874, [5] = 51179, [6] = 48037 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50613, [2] = 50997, [3] = 50702, [4] = 51930, [5] = 49978, [6] = 46973 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51262, [2] = 51177, [3] = 49891, [4] = 47062, [5] = 48033, [6] = 51882 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50699, [2] = 47097, [3] = 50062, [4] = 45135, [5] = 49893, [6] = 51850 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50400, [2] = 50636, [3] = 50610, [4] = 50664, [5] = 50424, [6] = 50644 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50366, [2] = 47059, [3] = 50359, [4] = 46051, [5] = 50358, [6] = 50346 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 50685, [3] = 50731, [4] = 50734, [5] = 50725, [6] = 50608 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50635, [2] = 50719, [3] = 50423, [4] = 50173, [5] = 47146, [6] = 47138 }
GA_BiSLists["PRIEST"]["Holy"]["T10"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50684, [2] = 50631, [3] = 50033, [4] = 50472, [5] = 51838, [6] = 51852 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 51261, [2] = 50661, [3] = 51896, [4] = 51837, [5] = 50006, [6] = 51178 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 50609, [2] = 50724, [3] = 49975, [4] = 51871, [5] = 50700, [6] = 50182 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51264, [2] = 51883, [3] = 50449, [4] = 51175, [5] = 51859, [6] = 47715 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 50668, [2] = 54583, [3] = 47553, [4] = 50628, [5] = 54556, [6] = 53489 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50717, [2] = 51851, [3] = 50172, [4] = 51263, [5] = 50974, [6] = 46993 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 54582, [2] = 50686, [3] = 53486, [4] = 47208, [5] = 51872, [6] = 50032 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 51260, [2] = 50722, [3] = 50176, [4] = 51874, [5] = 51179, [6] = 48037 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50613, [2] = 50997, [3] = 50702, [4] = 51930, [5] = 49978, [6] = 46973 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51262, [2] = 51177, [3] = 49891, [4] = 47062, [5] = 48033, [6] = 51882 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50699, [2] = 47097, [3] = 50062, [4] = 45135, [5] = 49893, [6] = 51850 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50400, [2] = 54585, [3] = 50636, [4] = 50610, [5] = 50664, [6] = 53490 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50366, [2] = 47059, [3] = 54589, [4] = 50359, [5] = 54573, [6] = 46051 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 50685, [3] = 50731, [4] = 50734, [5] = 50725, [6] = 50608 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50635, [2] = 50719, [3] = 50423, [4] = 50173, [5] = 47146, [6] = 47138 }
GA_BiSLists["PRIEST"]["Holy"]["RS"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 50684, [2] = 50631, [3] = 50033, [4] = 50472, [5] = 51838, [6] = 51852 }
GA_BiSLists["PRIEST"]["Shadow"] = {};
GA_BiSLists["PRIEST"]["Shadow"]["PR"] = {};
GA_BiSLists["PRIEST"]["Shadow"]["T9"] = {};
GA_BiSLists["PRIEST"]["Shadow"]["T10"] = {};
GA_BiSLists["PRIEST"]["Shadow"]["RS"] = {};
GA_BiSLists["PRIEST"]["Shadow"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 34340, [2] = 43995, [3] = 39521, [4] = 44910, [5] = 42553, [6] = 41984 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40680, [2] = 44658, [3] = 39472, [4] = 40427, [5] = 37595, [6] = 42024 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40051 } }, [1] = 34210, [2] = 39529, [3] = 37673, [4] = 37655, [5] = 37196, [6] = 41550 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 41610, [2] = 39241, [3] = 42057, [4] = 36983, [5] = 44242, [6] = 37291 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40051 } }, [1] = 39523, [2] = 40526, [3] = 39396, [4] = 43401, [5] = 42102, [6] = 37258 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 } }, [1] = 37361, [2] = 39252, [3] = 39390, [4] = 37884, [5] = 37725, [6] = 44200 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40051 } }, [1] = 39530, [2] = 39192, [3] = 39192, [4] = 42113, [5] = 34344, [6] = 37172 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40049 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40696, [2] = 37408, [3] = 37850, [4] = 37680, [5] = 44302, [6] = 37242 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 } }, [1] = 37854, [2] = 34386, [3] = 37189, [4] = 37369, [5] = 43375, [6] = 37876 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 44202, [2] = 44899, [3] = 37730, [4] = 37218, [5] = 37867, [6] = 34563 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40585, [2] = 43253, [3] = 39389, [4] = 44283, [5] = 37694, [6] = 37192 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 37873, [2] = 40682, [3] = 42395, [4] = 39229, [5] = 36972, [6] = 32483 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 41384, [2] = 40489, [3] = 39424, [4] = 39423, [5] = 37169, [6] = 44173 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 40698, [2] = 39199, [3] = 37134, [4] = 44210, [5] = 37718, [6] = 37051 }
GA_BiSLists["PRIEST"]["Shadow"]["PR"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 37177, [2] = 39426, [3] = 36989, [4] = 37238, [5] = 34347, [6] = 38206 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 48085, [2] = 47693, [3] = 48078, [4] = 45150, [5] = 48073, [6] = 49482 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40153 } }, [1] = 47144, [2] = 45133, [3] = 47957, [4] = 45699, [5] = 47747, [6] = 45539 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 48082, [2] = 47713, [3] = 45186, [4] = 46068, [5] = 40459, [6] = 47715 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47552, [2] = 47095, [3] = 45242, [4] = 47089, [5] = 47553, [6] = 46042 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 48083, [2] = 47129, [3] = 47974, [4] = 47126, [5] = 46168, [6] = 46993 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47208, [2] = 47143, [3] = 47927, [4] = 47141, [5] = 47663, [6] = 47585 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 45665, [2] = 48086, [3] = 47956, [4] = 46045, [5] = 48077, [6] = 47236 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 46973, [2] = 47084, [3] = 47921, [4] = 47081, [5] = 47617, [6] = 45619 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 48084, [2] = 47189, [3] = 45488, [4] = 48079, [5] = 47187, [6] = 48074 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 47097, [2] = 47205, [3] = 47194, [4] = 47940, [5] = 45258, [6] = 45135 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 45495, [2] = 47237, [3] = 47928, [4] = 45451, [5] = 45297, [6] = 47618 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45518, [2] = 47188, [3] = 45148, [4] = 40255, [5] = 45866, [6] = 47213 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 47206, [2] = 46980, [3] = 45620, [4] = 46017, [5] = 46979, [6] = 47941 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 47064, [2] = 45617, [3] = 47958, [4] = 47053, [5] = 47742, [6] = 45115 }
GA_BiSLists["PRIEST"]["Shadow"]["T9"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 45294, [2] = 47658, [3] = 45257, [4] = 47922, [5] = 39712, [6] = 45511 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 51255, [2] = 48085, [3] = 47693, [4] = 51837, [5] = 51184, [6] = 50661 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50724, [2] = 50658, [3] = 50005, [4] = 51863, [5] = 45133, [6] = 51894 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 51257, [2] = 50643, [3] = 49991, [4] = 51859, [5] = 47713, [6] = 51182 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50628, [2] = 51826, [3] = 47095, [4] = 47552, [5] = 50205, [6] = 50668 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 51259, [2] = 50629, [3] = 50418, [4] = 47129, [5] = 51813, [6] = 50974 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50651, [2] = 49994, [3] = 51872, [4] = 47143, [5] = 47927, [6] = 50686 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51256, [2] = 50663, [3] = 51921, [4] = 50011, [5] = 51183, [6] = 50722 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50613, [2] = 50996, [3] = 47084, [4] = 47921, [5] = 49978, [6] = 51862 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50694, [2] = 51258, [3] = 50056, [4] = 48084, [5] = 51181, [6] = 49891 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50699, [2] = 49890, [3] = 47205, [4] = 51899, [5] = 50062, [6] = 47194 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50398, [2] = 50664, [3] = 50714, [4] = 50614, [5] = 51849, [6] = 50008 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50348, [2] = 50365, [3] = 50353, [4] = 50360, [5] = 50345, [6] = 50357 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50734, [2] = 50731, [3] = 51939, [4] = 50608, [5] = 50428, [6] = 51943 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50719, [2] = 51922, [3] = 47064, [4] = 45617, [5] = 50173, [6] = 50635 }
GA_BiSLists["PRIEST"]["Shadow"]["T10"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50684, [2] = 51852, [3] = 45294, [4] = 50631, [5] = 50033, [6] = 51838 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40133 } }, [1] = 51255, [2] = 48085, [3] = 47693, [4] = 51837, [5] = 51184, [6] = 50661 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50658, [2] = 50005, [3] = 51863, [4] = 45133, [5] = 50724, [6] = 51894 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 51257, [2] = 50643, [3] = 49991, [4] = 51859, [5] = 47713, [6] = 51182 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 54583, [2] = 51826, [3] = 47095, [4] = 50628, [5] = 47552, [6] = 53489 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 51259, [2] = 50629, [3] = 50418, [4] = 47129, [5] = 51813, [6] = 50974 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 54582, [2] = 50651, [3] = 49994, [4] = 51872, [5] = 47143, [6] = 53486 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 51256, [2] = 50663, [3] = 51921, [4] = 50011, [5] = 51183, [6] = 50722 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50613, [2] = 54562, [3] = 50996, [4] = 47084, [5] = 47921, [6] = 49978 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 40113 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50694, [2] = 51258, [3] = 50056, [4] = 48084, [5] = 51181, [6] = 49891 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40133 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50699, [2] = 49890, [3] = 47205, [4] = 51899, [5] = 50062, [6] = 47194 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50398, [2] = 50664, [3] = 50714, [4] = 50614, [5] = 54563, [6] = 51849 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50348, [2] = 54588, [3] = 50365, [4] = 50353, [5] = 54572, [6] = 50360 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 }, [2] = { ["type"] = "item", ["id"] = 40113 } }, [1] = 50734, [2] = 50731, [3] = 51939, [4] = 50608, [5] = 50428, [6] = 51943 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 50719, [2] = 51922, [3] = 47064, [4] = 45617, [5] = 50173, [6] = 50635 }
GA_BiSLists["PRIEST"]["Shadow"]["RS"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40155 } }, [1] = 50684, [2] = 51852, [3] = 45294, [4] = 50631, [5] = 50033, [6] = 51838 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"] = {};
GA_BiSLists["PRIEST"]["Discipline"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40562, [2] = 40447, [3] = 40287, [4] = 40339, [5] = 39295, [6] = 39514 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40047 } }, [1] = 44662, [2] = 40374, [3] = 40071, [4] = 44657, [5] = 39232, [6] = 40378 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40450, [2] = 40555, [3] = 39310, [4] = 39719, [5] = 40289, [6] = 37673 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 40724, [2] = 44005, [3] = 40251, [4] = 40405, [5] = 39425, [6] = 40254 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40194, [2] = 44002, [3] = 42102, [4] = 40381, [5] = 40602, [6] = 44180 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 44008, [2] = 40741, [3] = 39731, [4] = 40338, [5] = 40198, [6] = 37361 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40445, [2] = 39733, [3] = 42113, [4] = 39285, [5] = 40303, [6] = 37825 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40027 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40271, [2] = 40561, [3] = 39721, [4] = 39735, [5] = 39190, [6] = 44302 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40398, [2] = 40060, [3] = 40448, [4] = 39408, [5] = 39517, [6] = 39309 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 } }, [1] = 40236, [2] = 40558, [3] = 40326, [4] = 40246, [5] = 40751, [6] = 44202 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40108, [2] = 40720, [3] = 40399, [4] = 40375, [5] = 40719, [6] = 40433 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 40432, [2] = 42988, [3] = 37835, [4] = 42413, [5] = 40258, [6] = 40382 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 40395, [2] = 40300, [3] = 39423, [4] = 40488, [5] = 40244, [6] = 39424 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 40350, [2] = 39766, [3] = 40192, [4] = 40699, [5] = 39311, [6] = 44210 }
GA_BiSLists["PRIEST"]["Discipline"]["T7"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 40245, [2] = 39426, [3] = 40284, [4] = 40335, [5] = 39473, [6] = 37238 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"] = {};
GA_BiSLists["PRIEST"]["Discipline"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44876 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46197, [2] = 45497, [3] = 45289, [4] = 45532, [5] = 45386, [6] = 40447 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40027 } }, [1] = 45443, [2] = 45243, [3] = 45933, [4] = 45133, [5] = 45447, [6] = 45116 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44872 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46190, [2] = 46068, [3] = 45390, [4] = 45253, [5] = 46013, [6] = 45514 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45486, [2] = 45618, [3] = 46321, [4] = 45541, [5] = 44005, [6] = 45317 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46193, [2] = 45272, [3] = 45240, [4] = 44002, [5] = 45389, [6] = 46012 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45446, [2] = 44008, [3] = 40741, [4] = 45146, [5] = 39731, [6] = 45423 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45520, [2] = 45665, [3] = 46188, [4] = 45273, [5] = 45840, [6] = 45387 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45619, [2] = 45119, [3] = 40561, [4] = 45558, [5] = 45831, [6] = 45694 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46195, [2] = 45388, [3] = 46034, [4] = 45468, [5] = 45848, [6] = 40398 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46050, [2] = 45135, [3] = 45537, [4] = 45566, [5] = 45483, [6] = 45441 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45614, [2] = 46096, [3] = 45495, [4] = 45946, [5] = 46046, [6] = 46323 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 40432, [2] = 45535, [3] = 45308, [4] = 45929, [5] = 46051, [6] = 45703 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45612, [2] = 46017, [3] = 45457, [4] = 45886, [5] = 46035, [6] = 45147 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 45314, [2] = 45271, [3] = 39766, [4] = 40350, [5] = 40192, [6] = 40699 }
GA_BiSLists["PRIEST"]["Discipline"]["T8"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 45170, [2] = 45511, [3] = 40245, [4] = 45713, [5] = 39426, [6] = 40284 }
GA_BiSLists["PRIEST"]["Holy"]["T7"] = {};
GA_BiSLists["PRIEST"]["Holy"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40447, [2] = 40447, [3] = 40562, [4] = 40287, [5] = 43995, [6] = 39514 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40047 } }, [1] = 44662, [2] = 40374, [3] = 40071, [4] = 44657, [5] = 39392, [6] = 40486 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 } }, [1] = 40555, [2] = 39719, [3] = 40450, [4] = 39310, [5] = 40289, [6] = 39518 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 44005, [2] = 40405, [3] = 40723, [4] = 40251, [5] = 40253, [6] = 39425 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 44002, [2] = 42102, [3] = 40602, [4] = 40381, [5] = 40449, [6] = 40194 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 44008, [2] = 39731, [3] = 40741, [4] = 40198, [5] = 37361, [6] = 39390 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40445, [2] = 39733, [3] = 42113, [4] = 39519, [5] = 40303, [6] = 39285 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40561, [2] = 39735, [3] = 40271, [4] = 39190, [5] = 39721, [6] = 40697 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40398, [2] = 40060, [3] = 40448, [4] = 39408, [5] = 39517, [6] = 39309 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 } }, [1] = 40558, [2] = 40326, [3] = 40751, [4] = 40269, [5] = 40236, [6] = 39254 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40399, [2] = 40719, [3] = 40375, [4] = 40433, [5] = 40080, [6] = 39250 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 44255, [2] = 37111, [3] = 40432, [4] = 42413, [5] = 40382, [6] = 40430 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 40395, [2] = 40488, [3] = 39423, [4] = 40244, [5] = 40300, [6] = 39424 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 39766, [2] = 40192, [3] = 44210, [4] = 40699, [5] = 40350, [6] = 37718 }
GA_BiSLists["PRIEST"]["Holy"]["T7"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 39426, [2] = 40245, [3] = 40284, [4] = 40335, [5] = 39473, [6] = 37619 }
GA_BiSLists["PRIEST"]["Holy"]["T8"] = {};
GA_BiSLists["PRIEST"]["Holy"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45497, [2] = 45289, [3] = 46197, [4] = 45532, [5] = 40447, [6] = 40562 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45243, [2] = 45443, [3] = 45447, [4] = 45933, [5] = 45822, [6] = 45116 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46190, [2] = 46068, [3] = 45253, [4] = 45390, [5] = 46013, [6] = 45514 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 45618, [2] = 46321, [3] = 45486, [4] = 45541, [5] = 44005, [6] = 45529 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40026 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45240, [2] = 45272, [3] = 46193, [4] = 44002, [5] = 45389, [6] = 46012 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45446, [2] = 44008, [3] = 45146, [4] = 39731, [5] = 40741, [6] = 45423 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40026 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40047 } }, [1] = 45665, [2] = 45520, [3] = 46188, [4] = 45273, [5] = 45840, [6] = 45387 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40047 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40047 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45619, [2] = 45119, [3] = 40561, [4] = 45558, [5] = 45831, [6] = 45694 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46195, [2] = 46034, [3] = 45388, [4] = 45468, [5] = 40398, [6] = 40060 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40047 } }, [1] = 45135, [2] = 45537, [3] = 45566, [4] = 46050, [5] = 45483, [6] = 45441 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 45495, [2] = 45614, [3] = 45946, [4] = 46323, [5] = 46046, [6] = 46096 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45535, [2] = 46051, [3] = 40432, [4] = 45703, [5] = 45929, [6] = 44255 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 45886, [3] = 45457, [4] = 45612, [5] = 46035, [6] = 45147 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 45271, [2] = 39766, [3] = 45314, [4] = 40192, [5] = 44210, [6] = 40699 }
GA_BiSLists["PRIEST"]["Holy"]["T8"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 45511, [2] = 45170, [3] = 39426, [4] = 45713, [5] = 40245, [6] = 40284 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"] = {};
GA_BiSLists["PRIEST"]["Shadow"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40562, [2] = 40456, [3] = 43995, [4] = 40287, [5] = 40339, [6] = 39521 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 44661, [2] = 44658, [3] = 39472, [4] = 40064, [5] = 40427, [6] = 40374 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40459, [2] = 40286, [3] = 39529, [4] = 40351, [5] = 40555, [6] = 39719 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 44005, [2] = 40405, [3] = 39241, [4] = 40253, [5] = 40723, [6] = 42057 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 44002, [2] = 40526, [3] = 40234, [4] = 40458, [5] = 39523, [6] = 39396 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 } }, [1] = 44008, [2] = 40325, [3] = 40740, [4] = 39252, [5] = 39731, [6] = 39390 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40051 } }, [1] = 40454, [2] = 40380, [3] = 39192, [4] = 40197, [5] = 39192, [6] = 39733 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 40561, [2] = 40301, [3] = 40696, [4] = 37408, [5] = 39735, [6] = 37850 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 } }, [1] = 40560, [2] = 39720, [3] = 40376, [4] = 40398, [5] = 40457, [6] = 40060 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 } }, [1] = 40558, [2] = 40246, [3] = 40750, [4] = 40326, [5] = 40269, [6] = 40751 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40399, [2] = 40719, [3] = 39389, [4] = 40080, [5] = 40585, [6] = 43253 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 40255, [2] = 40432, [3] = 37873, [4] = 42395, [5] = 39229, [6] = 40682 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 40395, [2] = 40489, [3] = 40408, [4] = 39424, [5] = 39423, [6] = 40244 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 40273, [2] = 40698, [3] = 39199, [4] = 40192, [5] = 39766, [6] = 37134 }
GA_BiSLists["PRIEST"]["Shadow"]["T7"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { }, [1] = 39712, [2] = 39426, [3] = 40284, [4] = 37177, [5] = 36989, [6] = 37238 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"] = {};
GA_BiSLists["PRIEST"]["Shadow"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41285 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46172, [2] = 45150, [3] = 45464, [4] = 45497, [5] = 45391, [6] = 45532 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40049 } }, [1] = 45133, [2] = 45699, [3] = 45539, [4] = 44661, [5] = 45933, [6] = 45243 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46165, [2] = 45186, [3] = 46068, [4] = 40459, [5] = 40286, [6] = 39529 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45618, [2] = 45242, [3] = 46042, [4] = 46321, [5] = 44005, [6] = 45493 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 46168, [2] = 45395, [3] = 45865, [4] = 40526, [5] = 45272, [6] = 45240 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45446, [2] = 45275, [3] = 45549, [4] = 45291, [5] = 40325, [6] = 44008 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45665, [2] = 46045, [3] = 45976, [4] = 45520, [5] = 46163, [6] = 45273 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45619, [2] = 45557, [3] = 45508, [4] = 40301, [5] = 45119, [6] = 40561 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41602 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40049 } }, [1] = 46170, [2] = 45488, [3] = 45238, [4] = 40560, [5] = 46034, [6] = 45848 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 39998 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45135, [2] = 45258, [3] = 45537, [4] = 46050, [5] = 45566, [6] = 45483 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 45495, [2] = 46046, [3] = 45451, [4] = 45297, [5] = 45515, [6] = 46096 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45518, [2] = 45466, [3] = 45148, [4] = 40255, [5] = 45866, [6] = 45308 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 }, [2] = { ["type"] = "item", ["id"] = 40026 } }, [1] = 45620, [2] = 45612, [3] = 46035, [4] = 45171, [5] = 45527, [6] = 45457 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { }, [1] = 45617, [2] = 45115, [3] = 40273, [4] = 40698, [5] = 45271, [6] = 45314 }
GA_BiSLists["PRIEST"]["Shadow"]["T8"][15] = { ["slot_name"] = "Ranged", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39998 } }, [1] = 45294, [2] = 45257, [3] = 39712, [4] = 45511, [5] = 45170, [6] = 45713 }
end


