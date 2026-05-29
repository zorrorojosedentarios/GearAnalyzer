-- ============================================================
-- GearAnalyzer: Paladin (PALADIN)
-- Data-on-Demand Module
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

function GearAnalyzer:LoadPaladinData()
    if rawget(self.ClassData, "PALADIN") then return end

    self.ClassData["PALADIN"] = {
        Glyphs = {
            ["Holy"] = {
                major = { 45741, 41106, 41109 }, -- Señal de la Luz, Luz Sagrada, Sello de Luz
                minor = { 43367, 43365, 43369 }  -- Bendicion de sabiduria, Bendicion de reyes, Imposicion de manos
            },
            ["Protection"] = {
                major = { 41101, 45745, 43869 }, -- Escudo de vengador, Suplica divina, Sello de venganza
                minor = { 43368, 43365, 43367 }  -- Captar no-muertos, Bendicion de reyes, Imposicion de manos
            },
            ["Retribution"] = {
                major = { 41092, 41103, 45743 }, -- Sentencia, Exorcismo, Tormenta divina
                minor = { 43340, 43365, 43368 }  -- Bendicion de poderio, Bendicion de reyes, Captar no-muertos
            }
        },
        Gems = {
            ["Holy"] = {
                meta = 41333, -- Diamante de llama celeste de ascuas (+25 SP / +2% Int)
                red = 40123, -- Ámbar del rey luminoso (+20 Intelecto)
                yellow = 40123, -- Ámbar del rey luminoso (+20 Intelecto)
                blue = 40123, -- Intelecto por defecto
                prismatic = 49110, -- Lágrima de pesadilla
                prismaticSlot = "chest",
                note = "FULL INTELECTO. +20 Int en ranuras rojas, amarillas y azules para maximizar maná total y la regeneración de Súplica Divina. Ignorar bonus de ranura salvo que den mucho beneficio."
            },
            ["Protection"] = {
                meta = 41380, -- Diamante de asedio de tierra austero (+32 Aguante / +2% Armadura)
                red = 40130, -- Piedra de terror cambiante (+10 Agilidad / +15 Aguante) o Parada/Aguante
                yellow = 40167, -- Ojo de Zul duradero (+10 Defensa / +15 Aguante)
                blue = 40119, -- Circón majestuoso sólido (+30 Aguante)
                note = "Full Aguante. Mantener Defensa en 540 mínimo. Gemar Def/Aguante o Agi/Aguante en ranuras que den buen bonus."
            },
            ["Retribution"] = {
                meta = 41398, -- Diamante de asedio de tierra incansable (+21 Agilidad / +3% CD)
                red = 40111, -- Rubí cárdeno llamativo (+20 Fuerza)
                yellow = 40111, -- Rubí cárdeno llamativo (+20 Fuerza)
                blue = 40111, -- Fuerza por defecto
                prismatic = 49110, -- Lágrima de pesadilla
                prismaticSlot = "chest",
                note = "FULL FUERZA. Fuerza en todas las ranuras. No usa ArPen en absoluto."
            }
        },
        TalentTrees = {
            [1] = { name = "Holy", icon = "Interface\\Icons\\Spell_Holy_HolyBolt" },
            [2] = { name = "Protection", icon = "Interface\\Icons\\Ability_Paladin_ShieldofTheRighteous" },
            [3] = { name = "Retribution", icon = "Interface\\Icons\\Spell_Holy_AuraOfLight" },
        },
        Caps = {
            ["Protection"] = {
                role = "Tank",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "DEF", label = "Defensa", cap = 540, note = "Cap Inmunidad Críticos (540)" },
                    { stat = "STA", label = "Aguante", note = "Prioridad Máxima" },
                    { stat = "EXP", cap = 56, label = "Pericia", note = "26 mín. / 56 Hard Cap (evitar Parry-rush)" },
                    { stat = "BLOCK", label = "Valor de Bloqueo" },
                }
            },
            ["Retribution"] = {
                role = "Melee",
                hitCap = { percent = 8, rating = 263 },
                expertiseCap = { skill = 26, rating = 214 },
                priorities = {
                    { stat = "STR", label = "Fuerza", note = "Full Fuerza siempre (No usa ArPen ya que el daño sagrado ignora armadura)" },
                    { stat = "CRIT", label = "Crítico" },
                }
            },
            ["Holy"] = {
                role = "Healer",
                priorities = {
                    { stat = "INT", label = "Intelecto", note = "Prioridad Absoluta (Maxmana / Regen / SP)" },
                    { stat = "HASTE", cap = 676, label = "Celeridad", note = "Soft 600 / Hard 676 (GCD Luz Sagrada a 1s)" },
                    { stat = "SP", label = "Poder de Hechizos" },
                }
            }
        },
        Enchants = {
            ["Holy"] = {
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
                ["offhand"]   = 1128,   -- Intelecto (Escudo)
            },
            ["Protection"] = {
                ["weapon"]    = 3869,   -- Amparo de hojas
                ["head"]      = 3818,   -- Arcanum del protector leal
                ["shoulders"] = 3811,   -- Inscripción del pináculo superior
                ["back"]      = 3294,   -- 3294 Armadura
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 3850,   -- Aguante mayor (+40)
                ["hands"]     = 3253,   -- Armero
                ["legs"]      = 3822,   -- Armadura para pierna de pellejo de escarcha
                ["feet"]      = 3232,   -- Vitalidad colmillarr (Naer ID)
                ["waist"]     = 3731,   -- Hebilla eterna
                ["offhand"]   = 1952,   -- Blindaje de titanio
            },
            ["Retribution"] = {
                ["weapon"]    = 3789,   -- Rabiar
                ["head"]      = 3817,   -- Arcanum de tormentos
                ["shoulders"] = 3808,   -- Inscripción del hacha superior
                ["back"]      = 3831,   -- Velocidad superior (+23 celeridad)
                ["chest"]     = 3832,   -- Estadísticas potentes (+10)
                ["wrists"]    = 3845,   -- Asalto superior (+50 PA)
                ["hands"]     = 1603,   -- Triturador (+44 PA)
                ["legs"]      = 3823,   -- Armadura para pierna de escama de hielo
                ["feet"]      = 3826,   -- Caminante de hielo
                ["waist"]     = 3731,   -- Hebilla eterna
                ["offhand"]   = 0,
            }
        },
        Talents = {
            ["Holy"] = {
                label = "54/17/0 - Paladin Elfo de Sangre (Caster Heal)",
                exportCode = "503501520220130531005152215032013120000000000000000000000000000000000000000000",
                [1] = { name = "Holy", points = 54 },
                [2] = { name = "Protection", points = 17 },
                [3] = { name = "Retribution", points = 0 }
            },
            ["Protection"] = {
                label = "0/53/18 - Paladin Proteccion (Tanque)",
                exportCode = "010000000000000000000000000500513520310231133331231150230230000300000000000000",
                [1] = { name = "Holy", points = 0 },
                [2] = { name = "Protection", points = 53 },
                [3] = { name = "Retribution", points = 18 }
            },
            ["Retribution"] = {
                label = "11/5/55 - Paladin Reprension (PVE DPS)",
                exportCode = "050501000000000000000000000500000000000000000000000005232251003331302133231331",
                [1] = { name = "Holy", points = 11 },
                [2] = { name = "Protection", points = 5 },
                [3] = { name = "Retribution", points = 55 }
            }
        }
    }

    GA_BiSLists["PALADIN"] = GA_BiSLists["PALADIN"] or {}
GA_BiSLists["PALADIN"]["Holy"] = {};
GA_BiSLists["PALADIN"]["Holy"]["PR"] = {};
GA_BiSLists["PALADIN"]["Holy"]["T9"] = {};
GA_BiSLists["PALADIN"]["Holy"]["T10"] = {};
GA_BiSLists["PALADIN"]["Holy"]["RS"] = {};
GA_BiSLists["PALADIN"]["Holy"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 44296, [2] = 39260, [3] = 44949, [4] = 37180, [5] = 37182, [6] = 37592 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40681, [2] = 44657, [3] = 39232, [4] = 42647, [5] = 43285, [6] = 42023 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 } }, [1] = 37655, [2] = 39631, [3] = 37673, [4] = 34390, [5] = 37875, [6] = 37376 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 41609, [2] = 39425, [3] = 39415, [4] = 34242, [5] = 37291, [6] = 44167 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 39629, [2] = 39188, [3] = 44180, [4] = 37258, [5] = 42102, [6] = 37222 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 } }, [1] = 37788, [2] = 37884, [3] = 37240, [4] = 37590, [5] = 37361, [6] = 37696 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 39632, [2] = 42113, [3] = 37825, [4] = 37261, [5] = 37623, [6] = 34240 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 40691, [2] = 37643, [3] = 44181, [4] = 44302, [5] = 37242, [6] = 37637 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41604 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 37362, [2] = 39630, [3] = 37791, [4] = 37695, [5] = 37854, [6] = 44305 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 44202, [2] = 40519, [3] = 43996, [4] = 43405, [5] = 43469, [6] = 37730 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 44283, [2] = 40585, [3] = 39244, [4] = 37694, [5] = 42644, [6] = 37192 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 44255, [2] = 37111, [3] = 28823, [4] = 37835, [5] = 40685, [6] = 42988 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 37169, [2] = 39423, [3] = 40488, [4] = 41384, [5] = 44199, [6] = 37681 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60653 } }, [1] = 40700, [2] = 39233, [3] = 37061, [4] = 37216, [5] = 44032, [6] = 44210 }
GA_BiSLists["PALADIN"]["Holy"]["PR"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40705, [2] = 30063, [3] = 33502, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40175 } }, [1] = 48582, [2] = 48577, [3] = 49476, [4] = 47965, [5] = 48564, [6] = 46180 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 47144, [2] = 45443, [3] = 47139, [4] = 45933, [5] = 47930, [6] = 45243 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 48580, [2] = 47923, [3] = 47702, [4] = 45474, [5] = 46044, [6] = 48579 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 47552, [2] = 48671, [3] = 47553, [4] = 46977, [5] = 48672, [6] = 47238 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 47147, [2] = 45445, [3] = 47603, [4] = 47142, [5] = 46992, [6] = 47209 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 45460, [2] = 47585, [3] = 47066, [4] = 47208, [5] = 47098, [6] = 47068 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 45665, [2] = 47236, [3] = 48583, [4] = 47235, [5] = 45928, [6] = 48576 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 47924, [2] = 47145, [3] = 46973, [4] = 46991, [5] = 47207, [6] = 45616 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41604 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 47067, [2] = 47190, [3] = 47087, [4] = 47186, [5] = 47057, [6] = 47051 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 46986, [2] = 47099, [3] = 45537, [4] = 47097, [5] = 46985, [6] = 47090 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 47224, [2] = 45614, [3] = 45495, [4] = 47223, [5] = 46046, [6] = 45946 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 46051, [2] = 37111, [3] = 45535, [4] = 48724, [5] = 44255, [6] = 45929 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 47206, [3] = 47517, [4] = 48709, [5] = 45612, [6] = 47193 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60653 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 47085, [2] = 45470, [3] = 47079, [4] = 45887, [5] = 47963, [6] = 45682 }
GA_BiSLists["PALADIN"]["Holy"]["T9"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40705, [2] = 45436, [3] = 40268, [4] = 30063, [5] = 47662, [6] = 33502 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51272, [2] = 51837, [3] = 51167, [4] = 51906, [5] = 50701, [6] = 50626 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40175 } }, [1] = 50724, [2] = 50182, [3] = 51894, [4] = 50609, [5] = 51871, [6] = 50700 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 51273, [2] = 50698, [3] = 50059, [4] = 51811, [5] = 51166, [6] = 50617 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50628, [2] = 47552, [3] = 50205, [4] = 50668, [5] = 51848, [6] = 48671 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50680, [2] = 51274, [3] = 50723, [4] = 50974, [5] = 50027, [6] = 51813 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50721, [2] = 50687, [3] = 50175, [4] = 50030, [5] = 51929, [6] = 51907 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50650, [2] = 50703, [3] = 50722, [4] = 50976, [5] = 49995, [6] = 50064 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50613, [2] = 50671, [3] = 50705, [4] = 49978, [5] = 50451, [6] = 50989 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41604 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 49891, [2] = 51928, [3] = 51882, [4] = 51860, [5] = 50623, [6] = 51271 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50699, [2] = 51920, [3] = 49896, [4] = 50062, [5] = 50632, [6] = 50652 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50400, [2] = 50664, [3] = 50610, [4] = 50008, [5] = 49967, [6] = 51849 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 46051, [2] = 37111, [3] = 50366, [4] = 50359, [5] = 50346, [6] = 45535 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 50734, [3] = 50732, [4] = 50685, [5] = 50428, [6] = 50427 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60653 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50616, [2] = 47085, [3] = 50719, [4] = 49976, [5] = 51812, [6] = 45470 }
GA_BiSLists["PALADIN"]["Holy"]["T10"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40705, [2] = 45436, [3] = 40268, [4] = 50460, [5] = 30063, [6] = 47662 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 51272, [2] = 51837, [3] = 51167, [4] = 51906, [5] = 50701, [6] = 50626 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40175 } }, [1] = 50724, [2] = 50182, [3] = 51894, [4] = 50609, [5] = 51871, [6] = 50700 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 51273, [2] = 50698, [3] = 50059, [4] = 51811, [5] = 51166, [6] = 50617 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 54583, [2] = 50628, [3] = 53489, [4] = 47552, [5] = 54556, [6] = 50205 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50680, [2] = 51274, [3] = 50723, [4] = 50974, [5] = 50027, [6] = 51813 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 54584, [2] = 54582, [3] = 50721, [4] = 50687, [5] = 53134, [6] = 53486 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50650, [2] = 50703, [3] = 54560, [4] = 50722, [5] = 50976, [6] = 49995 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 54587, [2] = 50613, [3] = 50671, [4] = 53488, [5] = 54565, [6] = 50705 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41604 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40123 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 49891, [2] = 51928, [3] = 51882, [4] = 51860, [5] = 50623, [6] = 51271 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40123 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40151 } }, [1] = 54586, [2] = 50699, [3] = 53487, [4] = 54558, [5] = 51920, [6] = 49896 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50400, [2] = 54585, [3] = 50664, [4] = 50610, [5] = 53490, [6] = 50008 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 46051, [2] = 37111, [3] = 50366, [4] = 54589, [5] = 50359, [6] = 54573 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 50734, [3] = 50732, [4] = 50685, [5] = 50428, [6] = 50427 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60653 }, [2] = { ["type"] = "item", ["id"] = 40123 } }, [1] = 50616, [2] = 47085, [3] = 50719, [4] = 49976, [5] = 51812, [6] = 45470 }
GA_BiSLists["PALADIN"]["Holy"]["RS"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40705, [2] = 45436, [3] = 40268, [4] = 50460, [5] = 30063, [6] = 47662 }
GA_BiSLists["PALADIN"]["Protection"] = {};
GA_BiSLists["PALADIN"]["Protection"]["PR"] = {};
GA_BiSLists["PALADIN"]["Protection"]["T9"] = {};
GA_BiSLists["PALADIN"]["Protection"]["T10"] = {};
GA_BiSLists["PALADIN"]["Protection"]["RS"] = {};
GA_BiSLists["PALADIN"]["Protection"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 41387, [2] = 42549, [3] = 39640, [4] = 37633, [5] = 44902, [6] = 37135 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40679, [2] = 42646, [3] = 44660, [4] = 39246, [5] = 37646, [6] = 43282 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40089 } }, [1] = 37635, [2] = 39267, [3] = 39642, [4] = 37814, [5] = 34389, [6] = 44373 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 44188, [2] = 43988, [3] = 39225, [4] = 37197, [5] = 37728, [6] = 43565 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 39638, [2] = 39398, [3] = 44198, [4] = 37658, [5] = 37735, [6] = 44407 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 } }, [1] = 37620, [2] = 39467, [3] = 39195, [4] = 37682, [5] = 37040, [6] = 37668 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 39639, [2] = 37645, [3] = 44183, [4] = 37862, [5] = 37363, [6] = 37671 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40089 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 40689, [2] = 37241, [3] = 39298, [4] = 37379, [5] = 37801, [6] = 37826 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40022 } }, [1] = 43500, [2] = 39258, [3] = 37292, [4] = 34381, [5] = 37688, [6] = 41345 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44528 } }, [1] = 44201, [2] = 39234, [3] = 37618, [4] = 41392, [5] = 44895, [6] = 37082 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 42643, [2] = 37784, [3] = 40426, [4] = 39141, [5] = 37186, [6] = 44935 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 37220, [2] = 36993, [3] = 44063, [4] = 42341, [5] = 39292, [6] = 44323 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 } }, [1] = 37401, [2] = 39344, [3] = 37260, [4] = 37179, [5] = 41383, [6] = 36984 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 } }, [1] = 43085, [2] = 40475, [3] = 42508, [4] = 40701, [5] = 37162, [6] = 37107 }
GA_BiSLists["PALADIN"]["Protection"]["PR"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40707, [2] = 38363, [3] = 37574, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40129 } }, [1] = 48644, [2] = 47677, [3] = 49475, [4] = 48639, [5] = 45935, [6] = 48634 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40129 } }, [1] = 47133, [2] = 47939, [3] = 49492, [4] = 45485, [5] = 47116, [6] = 45538 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 48646, [2] = 48637, [3] = 47944, [4] = 47698, [5] = 48636, [6] = 47720 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47549, [2] = 47063, [3] = 45496, [4] = 48675, [5] = 47042, [6] = 45319 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40129 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40166 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 46968, [2] = 48642, [3] = 46962, [4] = 46039, [5] = 48641, [6] = 47964 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40129 } }, [1] = 47111, [2] = 47108, [3] = 47570, [4] = 47918, [5] = 45111, [6] = 45283 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 48643, [2] = 45487, [3] = 48640, [4] = 46174, [5] = 45834, [6] = 48633 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40129 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47076, [2] = 47072, [3] = 47937, [4] = 45825, [5] = 46041, [6] = 45139 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40129 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 48645, [2] = 47061, [3] = 47052, [4] = 45295, [5] = 48638, [6] = 45594 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44528 }, [2] = { ["type"] = "item", ["id"] = 40129 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47003, [2] = 45988, [3] = 46997, [4] = 47154, [5] = 47952, [6] = 45542 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 45471, [2] = 47157, [3] = 45326, [4] = 47731, [5] = 47955, [6] = 47149 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47088, [2] = 45158, [3] = 47080, [4] = 46021, [5] = 47216, [6] = 49487 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 47156, [2] = 46097, [3] = 47526, [4] = 45947, [5] = 45442, [6] = 47506 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 }, [2] = { ["type"] = "item", ["id"] = 40166 } }, [1] = 46964, [2] = 45587, [3] = 47978, [4] = 45450, [5] = 46963, [6] = 45877 }
GA_BiSLists["PALADIN"]["Protection"]["T9"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 47661, [2] = 47664, [3] = 45145, [4] = 40707, [5] = 40337, [6] = 38363 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40129 } }, [1] = 51266, [2] = 50640, [3] = 49986, [4] = 51173, [5] = 48644, [6] = 47677 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40129 } }, [1] = 50682, [2] = 50627, [3] = 50023, [4] = 50195, [5] = 47133, [6] = 51934 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 49110 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51269, [2] = 51170, [3] = 50854, [4] = 51847, [5] = 50003, [6] = 48646 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50718, [2] = 47549, [3] = 50466, [4] = 50074, [5] = 51888, [6] = 47063 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40129 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51265, [2] = 50681, [3] = 51174, [4] = 50968, [5] = 51917, [6] = 50024 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50611, [2] = 51901, [3] = 49960, [4] = 47111, [5] = 47108, [6] = 47570 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51267, [2] = 50716, [3] = 51172, [4] = 50978, [5] = 50075, [6] = 51835 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40129 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50691, [2] = 50991, [3] = 51831, [4] = 50036, [5] = 47076, [6] = 47072 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51268, [2] = 50612, [3] = 51895, [4] = 51171, [5] = 49904, [6] = 49964 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44528 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50625, [2] = 50190, [3] = 51816, [4] = 49907, [5] = 47003, [6] = 45988 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50404, [2] = 50622, [3] = 50642, [4] = 50185, [5] = 50447, [6] = 51913 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50364, [2] = 47088, [3] = 50344, [4] = 50356, [5] = 50361, [6] = 47080 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50672, [2] = 50737, [3] = 50012, [4] = 51893, [5] = 50412, [6] = 47156 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 }, [2] = { ["type"] = "item", ["id"] = 40129 } }, [1] = 50729, [2] = 50065, [3] = 51909, [4] = 46964, [5] = 45587, [6] = 47978 }
GA_BiSLists["PALADIN"]["Protection"]["T10"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 47661, [2] = 50461, [3] = 47664, [4] = 45145, [5] = 40707, [6] = 40337 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40141 } }, [1] = 51266, [2] = 50640, [3] = 49986, [4] = 51173, [5] = 48644, [6] = 47677 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40141 } }, [1] = 50682, [2] = 50627, [3] = 50023, [4] = 50195, [5] = 47133, [6] = 51934 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51269, [2] = 51170, [3] = 50854, [4] = 51847, [5] = 50003, [6] = 48646 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50718, [2] = 47549, [3] = 50466, [4] = 50074, [5] = 51888, [6] = 47063 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40141 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51265, [2] = 50681, [3] = 51174, [4] = 50968, [5] = 51917, [6] = 50024 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50611, [2] = 51901, [3] = 49960, [4] = 47111, [5] = 47108, [6] = 47570 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51267, [2] = 50716, [3] = 51172, [4] = 50978, [5] = 50075, [6] = 51835 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40141 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50691, [2] = 50991, [3] = 51831, [4] = 50036, [5] = 47076, [6] = 47072 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40166 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 51268, [2] = 50612, [3] = 51895, [4] = 51171, [5] = 49904, [6] = 49964 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44528 }, [2] = { ["type"] = "item", ["id"] = 40119 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 54579, [2] = 50625, [3] = 53129, [4] = 54564, [5] = 50190, [6] = 51816 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50404, [2] = 50622, [3] = 50642, [4] = 50185, [5] = 50447, [6] = 51913 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50364, [2] = 47088, [3] = 54591, [4] = 50344, [5] = 50356, [6] = 50361 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 }, [2] = { ["type"] = "item", ["id"] = 40119 } }, [1] = 50672, [2] = 50737, [3] = 50012, [4] = 51893, [5] = 50412, [6] = 47156 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 }, [2] = { ["type"] = "item", ["id"] = 40141 } }, [1] = 50729, [2] = 50065, [3] = 51909, [4] = 46964, [5] = 45587, [6] = 47978 }
GA_BiSLists["PALADIN"]["Protection"]["RS"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 47661, [2] = 50461, [3] = 47664, [4] = 45145, [5] = 40707, [6] = 40337 }
GA_BiSLists["PALADIN"]["Retribution"] = {};
GA_BiSLists["PALADIN"]["Retribution"]["PR"] = {};
GA_BiSLists["PALADIN"]["Retribution"]["T9"] = {};
GA_BiSLists["PALADIN"]["Retribution"]["T10"] = {};
GA_BiSLists["PALADIN"]["Retribution"]["RS"] = {};
GA_BiSLists["PALADIN"]["Retribution"]["PR"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 41386, [2] = 39399, [3] = 39403, [4] = 44902, [5] = 34244, [6] = 42552 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][2] = { ["slot_name"] = "Neck", ["enhs"] = { }, [1] = 40678, [2] = 39146, [3] = 44659, [4] = 39421, [5] = 42021, [6] = 42645 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 37139, [2] = 39637, [3] = 39249, [4] = 39237, [5] = 34388, [6] = 39534 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 37647, [2] = 39404, [3] = 39297, [4] = 38614, [5] = 42061, [6] = 34241 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39633, [2] = 43998, [3] = 43990, [4] = 37722, [5] = 37165, [6] = 43310 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 } }, [1] = 41355, [2] = 37891, [3] = 37366, [4] = 34431, [5] = 37853, [6] = 44203 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39634, [2] = 37409, [3] = 37363, [4] = 34378, [5] = 37639, [6] = 44399 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40694, [2] = 37088, [3] = 37407, [4] = 37826, [5] = 37194, [6] = 37171 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 37193, [2] = 43994, [3] = 37263, [4] = 37644, [5] = 34180, [6] = 44117 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 42702 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44306, [2] = 44297, [3] = 44895, [4] = 37666, [5] = 43402, [6] = 37167 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 44935, [2] = 37642, [3] = 40474, [4] = 39401, [5] = 43993, [6] = 43251 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42987, [2] = 37166, [3] = 40684, [4] = 37723, [5] = 44914, [6] = 42990 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 37852, [2] = 39417, [3] = 40497, [4] = 41257, [5] = 37653, [6] = 37733 }
GA_BiSLists["PALADIN"]["Retribution"]["PR"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 37574, [2] = 38362, [3] = -1, [4] = -1, [5] = -1, [6] = -1 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 48614, [2] = 45610, [3] = 45472, [4] = 47689, [5] = 49474, [6] = 47943 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47060, [2] = 47110, [3] = 47105, [4] = 49485, [5] = 45459, [6] = 45517 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48612, [2] = 45245, [3] = 48611, [4] = 47697, [5] = 48606, [6] = 45320 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47547, [2] = 48674, [3] = 47192, [4] = 47545, [5] = 45461, [6] = 47183 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 49110 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 48616, [2] = 47086, [3] = 47082, [4] = 46965, [5] = 47004, [6] = 45473 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47155, [2] = 47151, [3] = 46967, [4] = 47916, [5] = 45611, [6] = 46961 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40143 } }, [1] = 48615, [2] = 48608, [3] = 46043, [4] = 45444, [5] = 47917, [6] = 47240 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47002, [2] = 47112, [3] = 45241, [4] = 47153, [5] = 47107, [6] = 46095 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47132, [2] = 46975, [3] = 48613, [4] = 46974, [5] = 45982, [6] = 45134 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47154, [2] = 47077, [3] = 47919, [4] = 47109, [5] = 47071, [6] = 47608 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40142 } }, [1] = 46966, [2] = 47075, [3] = 45534, [4] = 47729, [5] = 46048, [6] = 47934 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 47131, [2] = 42987, [3] = 47115, [4] = 47734, [5] = 45522, [6] = 45286 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 47519, [2] = 47515, [3] = 45533, [4] = 47078, [5] = 47239, [6] = 46067 }
GA_BiSLists["PALADIN"]["Retribution"]["T9"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 47661, [2] = 42853, [3] = 42852, [4] = 45510, [5] = 40191, [6] = 37574 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51277, [2] = 50713, [3] = 50712, [4] = 50605, [5] = 50073, [6] = 50072 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50647, [2] = 51890, [3] = 49989, [4] = 50728, [5] = 47110, [6] = 51867 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51279, [2] = 50674, [3] = 50020, [4] = 45245, [5] = 48612, [6] = 50646 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50653, [2] = 51933, [3] = 47547, [4] = 48674, [5] = 47192, [6] = 47545 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51275, [2] = 50656, [3] = 50606, [4] = 50001, [5] = 50689, [6] = 51903 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40142 } }, [1] = 50659, [2] = 47155, [3] = 50002, [4] = 51914, [5] = 50670, [6] = 50655 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50690, [2] = 51276, [3] = 51892, [4] = 51163, [5] = 51844, [6] = 48615 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50707, [2] = 51925, [3] = 50987, [4] = 51879, [5] = 51935, [6] = 50620 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51278, [2] = 50697, [3] = 50042, [4] = 51829, [5] = 51161, [6] = 50645 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50607, [2] = 50711, [3] = 47077, [4] = 47919, [5] = 51818, [6] = 50639 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50402, [2] = 50618, [3] = 50604, [4] = 50678, [5] = 50657, [6] = 50693 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50706, [2] = 47131, [3] = 50351, [4] = 50363, [5] = 47115, [6] = 50343 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 49623, [2] = 50730, [3] = 50603, [4] = 50735, [5] = 50070, [6] = 51946 }
GA_BiSLists["PALADIN"]["Retribution"]["T10"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50455, [2] = 47661, [3] = 42853, [4] = 42852, [5] = 45510, [6] = 40191 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51277, [2] = 50713, [3] = 50712, [4] = 50605, [5] = 50073, [6] = 50072 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40142 } }, [1] = 54581, [2] = 50647, [3] = 51890, [4] = 54557, [5] = 49989, [6] = 50728 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51279, [2] = 50674, [3] = 50020, [4] = 45245, [5] = 48612, [6] = 50646 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50653, [2] = 51933, [3] = 47547, [4] = 48674, [5] = 47192, [6] = 47545 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 49110 } }, [1] = 51275, [2] = 50656, [3] = 50606, [4] = 50001, [5] = 50689, [6] = 54561 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 54580, [2] = 50659, [3] = 47155, [4] = 50002, [5] = 51914, [6] = 50670 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 40142 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50690, [2] = 51276, [3] = 51892, [4] = 51163, [5] = 51844, [6] = 48615 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50707, [2] = 51925, [3] = 50987, [4] = 51879, [5] = 51935, [6] = 50620 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 51278, [2] = 50697, [3] = 50042, [4] = 51829, [5] = 51161, [6] = 50645 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 54578, [2] = 53125, [3] = 50711, [4] = 47077, [5] = 47919, [6] = 54577 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 50402, [2] = 54576, [3] = 50604, [4] = 50678, [5] = 50657, [6] = 50618 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 50706, [2] = 54590, [3] = 50351, [4] = 47131, [5] = 50363, [6] = 54569 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 40111 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40111 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40111 } }, [1] = 49623, [2] = 50730, [3] = 50603, [4] = 50735, [5] = 50070, [6] = 51946 }
GA_BiSLists["PALADIN"]["Retribution"]["RS"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 50455, [2] = 47661, [3] = 42853, [4] = 42852, [5] = 45510, [6] = 40191 }
GA_BiSLists["PALADIN"]["Holy"]["T7"] = {};
GA_BiSLists["PALADIN"]["Holy"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 40298, [2] = 44007, [3] = 40339, [4] = 40571, [5] = 39260, [6] = 40304 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 44662, [2] = 40374, [3] = 44657, [4] = 40071, [5] = 40378, [6] = 39232 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 40573, [2] = 39725, [3] = 40590, [4] = 40439, [5] = 40377, [6] = 39631 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40094 } }, [1] = 44005, [2] = 40251, [3] = 39425, [4] = 40724, [5] = 39415, [6] = 40254 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 40569, [2] = 40283, [3] = 40453, [4] = 40588, [5] = 39188, [6] = 40249 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 40324, [2] = 40274, [3] = 40332, [4] = 44008, [5] = 40209, [6] = 40741 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 40570, [2] = 39703, [3] = 40564, [4] = 40302, [5] = 40316, [6] = 39632 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 40259, [2] = 40561, [3] = 40327, [4] = 40691, [5] = 40272, [6] = 40241 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41604 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 40572, [2] = 40352, [3] = 40204, [4] = 39630, [5] = 40398, [6] = 40363 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40047 } }, [1] = 40187, [2] = 40592, [3] = 40237, [4] = 40519, [5] = 43996, [6] = 39734 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40399, [2] = 40375, [3] = 39244, [4] = 40108, [5] = 40433, [6] = 44283 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 44255, [2] = 37111, [3] = 28823, [4] = 40258, [5] = 37835, [6] = 40685 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 40396, [2] = 40395, [3] = 39423, [4] = 40336, [5] = 40488, [6] = 40244 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60653 } }, [1] = 40401, [2] = 39716, [3] = 39233, [4] = 40700, [5] = 42564, [6] = 37061 }
GA_BiSLists["PALADIN"]["Holy"]["T7"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40705, [2] = 40268, [3] = 30063, [4] = 33502, [5] = -1, [6] = -1 }
GA_BiSLists["PALADIN"]["Holy"]["T8"] = {};
GA_BiSLists["PALADIN"]["Holy"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44877 }, [2] = { ["type"] = "item", ["id"] = 41401 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 46180, [2] = 45226, [3] = 45372, [4] = 45687, [5] = 45497, [6] = 45439 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45443, [2] = 45933, [3] = 45243, [4] = 45116, [5] = 45447, [6] = 46047 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44874 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 46182, [2] = 45474, [3] = 46044, [4] = 46068, [5] = 45140, [6] = 45373 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45486, [2] = 45618, [3] = 44005, [4] = 45541, [5] = 46321, [6] = 45317 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45445, [2] = 45519, [3] = 45867, [4] = 45272, [5] = 45531, [6] = 45259 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60767 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45460, [2] = 45446, [3] = 45269, [4] = 46345, [5] = 45187, [6] = 40324 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44592 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 46179, [2] = 45665, [3] = 45928, [4] = 45943, [5] = 45239, [6] = 45520 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45151, [2] = 45616, [3] = 45552, [4] = 45505, [5] = 45619, [6] = 45828 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 41604 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 46181, [2] = 46049, [3] = 45845, [4] = 45544, [5] = 45843, [6] = 45371 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47901 }, [2] = { ["type"] = "item", ["id"] = 40012 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45537, [2] = 45135, [3] = 45615, [4] = 45561, [5] = 46050, [6] = 45513 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45614, [2] = 46046, [3] = 45495, [4] = 45946, [5] = 46323, [6] = 45168 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 46051, [2] = 37111, [3] = 45535, [4] = 44255, [5] = 45929, [6] = 45490 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60714 } }, [1] = 46017, [2] = 45612, [3] = 46035, [4] = 45147, [5] = 45437, [6] = 40396 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60653 }, [2] = { ["type"] = "item", ["id"] = 40012 } }, [1] = 45470, [2] = 45887, [3] = 45682, [4] = 40401, [5] = 39716, [6] = 39233 }
GA_BiSLists["PALADIN"]["Holy"]["T8"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40705, [2] = 45436, [3] = 40268, [4] = 30063, [5] = 33502, [6] = -1 }
GA_BiSLists["PALADIN"]["Protection"]["T7"] = {};
GA_BiSLists["PALADIN"]["Protection"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 40581, [2] = 40328, [3] = 44006, [4] = 42549, [5] = 39640, [6] = 40366 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40022 } }, [1] = 44665, [2] = 40387, [3] = 40069, [4] = 42646, [5] = 44660, [6] = 39246 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40089 } }, [1] = 40584, [2] = 39704, [3] = 40334, [4] = 39267, [5] = 39642, [6] = 37814 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60663 } }, [1] = 40722, [2] = 40252, [3] = 43988, [4] = 40410, [5] = 39225, [6] = 37197 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 40579, [2] = 40203, [3] = 44000, [4] = 39398, [5] = 40279, [6] = 44198 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 } }, [1] = 39764, [2] = 40306, [3] = 40734, [4] = 39467, [5] = 39195, [6] = 39729 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 40580, [2] = 37645, [3] = 40188, [4] = 39726, [5] = 44183, [6] = 39639 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 39759, [2] = 40263, [3] = 40689, [4] = 37241, [5] = 39298, [6] = 37379 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 } }, [1] = 40589, [2] = 40446, [3] = 40583, [4] = 43500, [5] = 40240, [6] = 39258 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44528 } }, [1] = 40297, [2] = 40743, [3] = 39717, [4] = 39234, [5] = 44201, [6] = 37618 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40718, [2] = 40107, [3] = 40426, [4] = 42643, [5] = 39141, [6] = 40370 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 37220, [2] = 40257, [3] = 44063, [4] = 42341, [5] = 39292, [6] = 44323 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 } }, [1] = 40345, [2] = 40402, [3] = 37401, [4] = 39344, [5] = 37260, [6] = 37179 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 } }, [1] = 40400, [2] = 40475, [3] = 40266, [4] = 42508, [5] = 43085, [6] = 40701 }
GA_BiSLists["PALADIN"]["Protection"]["T7"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 40707, [2] = 40337, [3] = 38363, [4] = 37574, [5] = -1, [6] = -1 }
GA_BiSLists["PALADIN"]["Protection"]["T8"] = {};
GA_BiSLists["PALADIN"]["Protection"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44878 }, [2] = { ["type"] = "item", ["id"] = 41380 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 46175, [2] = 45935, [3] = 45502, [4] = 40581, [5] = 45382, [6] = 40328 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 45485, [2] = 45538, [3] = 40387, [4] = 44665, [5] = 45696, [6] = 45262 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44957 }, [2] = { ["type"] = "item", ["id"] = 40034 } }, [1] = 46177, [2] = 45251, [3] = 45385, [4] = 39704, [5] = 45697, [6] = 40584 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47672 }, [2] = { ["type"] = "item", ["id"] = 40034 } }, [1] = 45496, [2] = 45319, [3] = 46014, [4] = 45322, [5] = 45588, [6] = 40722 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 46039, [2] = 46173, [3] = 45334, [4] = 45381, [5] = 45225, [6] = 40203 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 62256 } }, [1] = 45111, [2] = 45283, [3] = 45663, [4] = 40306, [5] = 39764, [6] = 40734 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 34207 }, [2] = { ["type"] = "item", ["id"] = 40034 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 45487, [2] = 46174, [3] = 45834, [4] = 45228, [5] = 45383, [6] = 46340 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45825, [2] = 46041, [3] = 45139, [4] = 45551, [5] = 45304, [6] = 45241 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38373 }, [2] = { ["type"] = "item", ["id"] = 40034 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 45594, [2] = 45295, [3] = 40589, [4] = 46176, [5] = 45842, [6] = 45384 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44528 }, [2] = { ["type"] = "item", ["id"] = 40008 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45988, [2] = 45542, [3] = 45166, [4] = 45560, [5] = 40297, [6] = 45599 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 40088 } }, [1] = 45471, [2] = 45871, [3] = 45112, [4] = 45874, [5] = 45247, [6] = 45326 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 45158, [2] = 46021, [3] = 44063, [4] = 37220, [5] = 42341, [6] = 40257 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59619 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 46097, [2] = 45947, [3] = 45463, [4] = 45442, [5] = 45876, [6] = 40345 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][14] = { ["slot_name"] = "Off hand", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44936 }, [2] = { ["type"] = "item", ["id"] = 40008 } }, [1] = 45587, [2] = 45450, [3] = 45877, [4] = 45707, [5] = 40400, [6] = 40475 }
GA_BiSLists["PALADIN"]["Protection"]["T8"][15] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 45145, [2] = 40707, [3] = 40337, [4] = 38363, [5] = 37574, [6] = -1 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"] = {};
GA_BiSLists["PALADIN"]["Retribution"]["T7"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 44006, [2] = 41386, [3] = 40576, [4] = 40543, [5] = 39399, [6] = 39403 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44664, [2] = 40065, [3] = 39146, [4] = 44659, [5] = 39421, [6] = 40369 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40578, [2] = 40414, [3] = 39637, [4] = 39249, [5] = 39237, [6] = 40315 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 } }, [1] = 40403, [2] = 40721, [3] = 39404, [4] = 40250, [5] = 39297, [6] = 38614 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40574, [2] = 39767, [3] = 40277, [4] = 40539, [5] = 43998, [6] = 43990 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40330, [2] = 40186, [3] = 40736, [4] = 40282, [5] = 39729, [6] = 39765 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 } }, [1] = 40541, [2] = 40261, [3] = 39727, [4] = 40347, [5] = 40262, [6] = 40575 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 40278, [2] = 40260, [3] = 40317, [4] = 39762, [5] = 39345, [6] = 39759 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 44011, [2] = 40294, [3] = 37193, [4] = 43994, [5] = 40577, [6] = 37263 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 39706, [2] = 39701, [3] = 40206, [4] = 40742, [5] = 40243, [6] = 40591 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][11] = { ["slot_name"] = "Finger", ["enhs"] = { }, [1] = 40075, [2] = 40717, [3] = 40474, [4] = 40074, [5] = 39401, [6] = 43993 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42987, [2] = 40431, [3] = 40256, [4] = 37166, [5] = 40371, [6] = 40684 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 } }, [1] = 40384, [2] = 39758, [3] = 39417, [4] = 40497, [5] = 40406, [6] = 40343 }
GA_BiSLists["PALADIN"]["Retribution"]["T7"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 42852, [2] = 40191, [3] = 37574, [4] = 38362, [5] = -1, [6] = -1 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"] = {};
GA_BiSLists["PALADIN"]["Retribution"]["T8"][1] = { ["slot_name"] = "Head", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44879 }, [2] = { ["type"] = "item", ["id"] = 41398 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 42702 } }, [1] = 45472, [2] = 45610, [3] = 45107, [4] = 45993, [5] = 45329, [6] = 45523 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][2] = { ["slot_name"] = "Neck", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45459, [2] = 45945, [3] = 45517, [4] = 45819, [5] = 46040, [6] = 45480 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][3] = { ["slot_name"] = "Shoulder", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 44871 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45245, [2] = 45320, [3] = 45677, [4] = 40414, [5] = 45227, [6] = 46037 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][4] = { ["slot_name"] = "Back", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 47898 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 46032, [2] = 45461, [3] = 45588, [4] = 46320, [5] = 45224, [6] = 45704 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][5] = { ["slot_name"] = "Chest", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60692 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45473, [2] = 46154, [3] = 45375, [4] = 45524, [5] = 39767, [6] = 45712 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][6] = { ["slot_name"] = "Wrist", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 44575 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45663, [2] = 45611, [3] = 45869, [4] = 45264, [5] = 40330, [6] = 45454 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][7] = { ["slot_name"] = "Hands", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60668 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45444, [2] = 46043, [3] = 45325, [4] = 40541, [5] = 40261, [6] = 46155 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][8] = { ["slot_name"] = "Waist", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 46095, [2] = 45241, [3] = 45829, [4] = 46041, [5] = 45555, [6] = 45547 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][9] = { ["slot_name"] = "Legs", ["enhs"] = { [1] = { ["type"] = "item", ["id"] = 38374 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 }, [5] = { ["type"] = "none", ["id"] = 0 }, [6] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45134, [2] = 45982, [3] = 45846, [4] = 46153, [5] = 45536, [6] = 44011 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][10] = { ["slot_name"] = "Feet", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 60763 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45599, [2] = 45989, [3] = 45564, [4] = 45244, [5] = 45501, [6] = 45330 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][11] = { ["slot_name"] = "Finger", ["enhs"] = { [1] = { ["type"] = "none", ["id"] = 0 }, [2] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45534, [2] = 45608, [3] = 46048, [4] = 45540, [5] = 45250, [6] = 46010 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][12] = { ["slot_name"] = "Trinket", ["enhs"] = { }, [1] = 42987, [2] = 45609, [3] = 45522, [4] = 45286, [5] = 46038, [6] = 45263 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][13] = { ["slot_name"] = "Weapon", ["enhs"] = { [1] = { ["type"] = "spell", ["id"] = 59621 }, [2] = { ["type"] = "item", ["id"] = 39996 }, [3] = { ["type"] = "none", ["id"] = 0 }, [4] = { ["type"] = "item", ["id"] = 39996 } }, [1] = 45516, [2] = 45533, [3] = 46067, [4] = 45868, [5] = 45521, [6] = 45165 }
GA_BiSLists["PALADIN"]["Retribution"]["T8"][14] = { ["slot_name"] = "Relic", ["enhs"] = { }, [1] = 42853, [2] = 42852, [3] = 45510, [4] = 40191, [5] = 37574, [6] = 38362 }
end


