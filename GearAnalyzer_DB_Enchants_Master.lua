-- ============================================================
-- GearAnalyzer DB: Master Enchantments (NAERZONE/ULTIMOWOW HYBRID)
-- Esta base de datos es la FUENTE DE VERDAD del addon.
-- Los IDs son del SERVIDOR.
-- ============================================================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

GearAnalyzer.EnchantMasterDB = {
    -- [ServerID] = { item = ItemID, spell = SpellID, slot = "slot", name = "Name", stats = "Stats" }

    -- === CABALLERO DE LA MUERTE (RUNAS) ===
   -- [3368] = { spell = 53344, slot = "weapon", name = "Runa del cruzado caído", stats = "Proc % Fuerza / Heal" },
 --   [3370] = { spell = 53343, slot = "weapon", name = "Runa de cuchilla de hielo", stats = "Daño Escarcha" },
  --  [3847] = { spell = 62158, slot = "weapon", name = "Runa de la gárgola de piel de piedra", stats = "+2% Aguante / +25 Def" },
  --  [3369] = { spell = 47568, slot = "weapon", name = "Runa de glaciar de ceniza", stats = "Proc Daño Escarcha" },
    [3368] = { spell = 53344, slot = "weapon", name = "Runa del cruzado caído", stats = "Proc % Fuerza / Heal" },
    [3370] = { spell = 53343, slot = "weapon", name = "Runa de cuchilla de hielo", stats = "Daño Escarcha" },
    [3847] = { spell = 62158, slot = "weapon", name = "Runa de la gárgola de piel de piedra", stats = "+2% Aguante / +25 Def" },
  --  [3369] = { spell = 62158, slot = "weapon", name = "Runa de la gárgola de piel de piedra", stats = "+2% Aguante / +25 Def" },
    [3345] = { spell = 53343, slot = "weapon", name = "Runa de cuchilla de hielo", stats = "Daño Escarcha / Vulnerabilidad" },
    -- === CABEZA (ARCANUMS) ===
    [3878] = { spell = 67839, slot = "head", name = "Plato de amplificación mental", stats = "Control Mental", origin = "Ingeniería" },
    [3817] = { item = 44149, spell = 59954, slot = "head", name = "Arcanum de tormentos", stats = "+50 PA / +20 Crítico", origin = "Ébano" },
    [3820] = { item = 44159, spell = 59970, slot = "head", name = "Arcanum de misterios ardientes", stats = "+30 Hechizos / +20 Crítico", origin = "Kirin Tor" },
    [3818] = { item = 50369, spell = 59955, slot = "head", name = "Arcanum del protector leal", stats = "+37 aguante / +20 índice de defensa", origin = "Argenta" },
    [3819] = { item = 44150, spell = 44150, slot = "head", name = "Arcanum de renovación", stats = "+30 SP / +10 MP5", origin = "Reposo Dragón" },
    [3816] = { slot = "head", name = "Arcanum de resistencia al fuego", stats = "+25 Res. Fuego / +30 Aguante" },
    [3846] = { item = 44069, slot = "head", name = "Arcanum de triunfo", stats = "+50 PA / +20 Temple", origin = "PvP" },

    -- === HOMBROS ===
    [3808] = { item = 44133, spell = 59934, slot = "shoulders", name = "Inscripción del hacha superior", stats = "+40 PA / +15 Crítico", origin = "Hodir" },
    [3810] = { item = 44135, spell = 59937, slot = "shoulders", name = "Inscripción de la tormenta superior", stats = "+24 Hechizos / +15 Crítico", origin = "Hodir" },
    [3811] = { item = 44136, spell = 59941, slot = "shoulders", name = "Inscripción del pináculo superior", stats = "+20 Esquivar / +15 Defensa", origin = "Hodir" },
    [3809] = { item = 44135, spell = 59936, slot = "shoulders", name = "Inscripción del risco superior", stats = "+24 Hechizos / +8 MP5", origin = "Hodir" },
    [3852] = { item = 44068, spell = 59944, slot = "shoulders", name = "Inscripción del gladiador superior", stats = "+30 Aguante / +15 Temple", origin = "PvP" },
    [3843] = { item = 44631, slot = "shoulders", name = "Inscripción del triunfo superior", stats = "+40 PA / +15 Temple", origin = "PvP" },

    -- === ESPALDA (CAPAS) ===
    [1099] = { spell = 60663, slot = "back", name = "Agilidad superior", stats = "+22 Agilidad" },
    [3722] = { spell = 55642, slot = "back", name = "Bordado de tejido de luz", stats = "Proc 295 SP" },
    [3831] = { spell = 47898, slot = "back", name = "Velocidad superior", stats = "+23 Celeridad" },
    [3296] = { spell = 44631, slot = "back", name = "Agilidad y sigilo", stats = "+10 Agi / +Sigilo" },
    [3294] = { spell = 47672, slot = "back", name = "Armadura poderosa", stats = "+225 Armadura" },
    [1951] = { spell = 55002, slot = "back", name = "Tejido de titán", stats = "+16 Defensa" },
    [1144] = { spell = 38992, slot = "back", name = "Sabiduría superior", stats = "+15 Espíritu" },

    -- === PECHO ===
    [3832] = { spell = 60692, slot = "chest", name = "Estadísticas potentes", stats = "+10 Estadísticas" },
    [3297] = { spell = 47900, slot = "chest", name = "Salud excelente", stats = "+275 Salud" },

    -- === MUÑECAS ===
    [3845] = { spell = 44575, slot = "wrists", name = "Asalto superior", stats = "+50 PA" },
    [3850] = { spell = 62256, slot = "wrists", name = "Aguante mayor", stats = "+40 Aguante" },
    [2332] = { spell = 60767, slot = "wrists", name = "Poder con hechizos excelente", stats = "+30 Hechizos" },
    [3220] = { spell = 38992, slot = "wrists", name = "Crítico excelente", stats = "+12 Crítico" },

    -- === MANOS ===
    [1603] = { spell = 60668, slot = "hands", name = "Triturador", stats = "+44 PA" },
    [3253] = { spell = 44625, slot = "hands", name = "Armero", stats = "+2% Amenaza / +10 Parada" },
    [3849] = { spell = 44625, slot = "hands", name = "Armero", stats = "+2% Amenaza / +10 Parada" },
    [3246] = { spell = 44592, slot = "hands", name = "Poder con hechizos excepcional", stats = "+28 SP" },
    [3222] = { spell = 44529, slot = "hands", name = "Agilidad excelente / sublime", stats = "+20 Agilidad" },
    [3860] = { spell = 63770, slot = "hands", name = "Refuerzo para guantes", stats = "+885 Armadura" },
    [3604] = { spell = 54999, slot = "hands", name = "Aceleradores de hipervelocidad", stats = "+340 Celeridad (Uso)", origin = "Ingeniería" },
    [3231] = { spell = 44598, slot = "hands", name = "Pericia", stats = "+15 Pericia" },
    [3849] = { spell = 62201, slot = "offhand", name = "Blindaje de titanio", stats = "+81 Valor de Bloqueo" },

    -- === CINTURA ===
    [3731] = { item = 41611, spell = 55655, slot = "waist", name = "Hebilla eterna", stats = "+1 Ranura" },
    [3601] = { spell = 54793, slot = "waist", name = "Bomba de fragmentación", stats = "Cinturón bomba" },

    -- === PIERNAS ===
    [3823] = { item = 38374, spell = 50967, slot = "legs", name = "Armadura de pierna de escama de hielo", stats = "+75 PA / +22 Crítico" },
    [3822] = { item = 38373, spell = 60581, slot = "legs", name = "Armadura de pierna de pellejo de escarcha", stats = "+55 Aguante / +22 Agilidad" },
    [3719] = { item = 41602, spell = 56009, slot = "legs", name = "Hilo de hechizo luminoso", stats = "+50 Hechizos / +20 Espíritu" },
    [3872] = { spell = 56039, slot = "legs", name = "Hilo de hechizo santificado", stats = "+50 Hechizos / +20 Espíritu" },
    [3721] = { item = 41604, spell = 41604, slot = "legs", name = "Hilo de hechizo de zafiro", stats = "+50 SP / +30 Aguante" },

    -- === PIES ===
    [3826] = { spell = 60623, slot = "feet", name = "Caminante de hielo", stats = "+12 Crit / +12 Hit" },
    [3232] = { spell = 47901, slot = "feet", name = "Vitalidad colmillarr", stats = "Velocidad / +15 Aguante" },
    [3243] = { spell = 44436, slot = "feet", name = "Penetración de hechizo", stats = "+35 Spell Pen" },
    [1597] = { spell = 60763, slot = "feet", name = "Asalto superior", stats = "+32 PA" },
    [1147] = { spell = 44508, slot = "feet", name = "Encantar botas: espíritu superior", stats = "+18 Espíritu" },
    [3242] = { spell = 47901, slot = "feet", name = "Resistencia a todo", stats = "+5 Resistencias" },
    [1075] = { spell = 44528, slot = "feet", name = "Entereza Superior", stats = "+22 Aguante"},

    -- === ARMAS ===
    [3834] = { spell = 60714, slot = "weapon", name = "Poder con hechizos poderoso", stats = "+63 SP" },
    [3854] = { spell = 62948, slot = "weapon", name = "Poder con hechizos superior", stats = "+81 SP (Baston)" },
    [3827] = { spell = 60691, slot = "weapon", name = "Masacre", stats = "+110 PA (2H)" },
    [2673] = { spell = 27984, slot = "weapon", name = "Mangosta", stats = "Proc Agi/Vel" },
    [3789] = { spell = 59621, slot = "weapon", name = "Rabiar", stats = "400 AP (Proc)" },
    [3869] = { spell = 64441, slot = "weapon", name = "Amparo de hojas", stats = "Proc Parada" },
    [3240] = { item = 41976, spell = 55836, slot = "weapon", name = "Cadena de armas de titanio", stats = "+28 Golpe / Desarme" },

    -- === ESCUDOS / OFFHANDS ===
    [3602] = { slot = "offhand", name = "Poder con hechizos", stats = "+7 SP (Escudo)" },
    [1952] = { spell = 44489, slot = "shield", name = "Defensa", stats = "+20 Defensa" },
    -- [3849] también es Blindaje de titanio según extracción
    [1128] = { spell = 60653, slot = "shield", name = "Intelecto superior", stats = "+25 intelecto" },

    -- === RANGO ===
    [3608] = { item = 41167, spell = 56478, slot = "ranged", name = "Mira buscacorazones", stats = "Mira de Rango" },

    -- === ANILLOS (PROFE ENCH) ===
    [3839] = { spell = 44645, slot = "ring", name = "Encantar anillo: asalto", stats = "+40 Poder de Ataque" },
    [3840] = { spell = 47137, slot = "ring", name = "Encantar anillo: poder con hechizos", stats = "+23 Poder con hechizos" },
    [3841] = { slot = "ring", name = "Encantar anillo: poder con hechizos", stats = "+23 Poder con hechizos" },

    -- === GEMAS Y METAS ===
    -- ROJAS
    [40111] = { name = "Rubí cárdeno llamativo", stats = "+20 Fuerza", color = "red" },
    [40112] = { name = "Rubí cárdeno delicado", stats = "+20 Agilidad", color = "red" },
    [40113] = { name = "Rubí cárdeno rúnico", stats = "+23 Poder con Hechizos", color = "red" },
    [40117] = { name = "Rubí cárdeno fracturado", stats = "+20 Penetración de Armadura", color = "red" },
    [40114] = { name = "Rubí cárdeno brillante", stats = "+40 Poder de Ataque", color = "red" },
    [40118] = { name = "Rubí cárdeno preciso", stats = "+20 Pericia", color = "red" },

    -- AMARILLAS
    [40123] = { name = "Ámbar del rey luminoso", stats = "+20 Intelecto", color = "yellow" },
    [40128] = { name = "Ámbar del rey rápido", stats = "+20 Celeridad", color = "yellow" },
    [40124] = { name = "Ámbar del rey liso", stats = "+20 Crítico", color = "yellow" },
    [40125] = { name = "Ámbar del rey rígido", stats = "+20 Golpe", color = "yellow" },
    [40126] = { name = "Ámbar del rey grueso", stats = "+20 Defensa", color = "yellow" },

    -- AZULES
    [40119] = { name = "Circón majestuoso sólido", stats = "+30 Aguante", color = "blue" },
    [40120] = { name = "Circón majestuoso chispeante", stats = "+20 Espíritu", color = "blue" },
    [40122] = { name = "Circón majestuoso tormentoso", stats = "+25 Pen. Hechizo", color = "blue" },

    -- NARANJAS
    [40151] = { name = "Ametrino luminoso", stats = "+12 SP / +10 Intelecto", color = "orange" },
    [40142] = { name = "Ametrino con inscripciones", stats = "+10 Fuerza / +10 Crítico", color = "orange" },
    [40143] = { name = "Ametrino con grabados", stats = "+10 Fuerza / +10 Índice de Golpe", color = "orange" },
    [40155] = { name = "Ametrino temerario", stats = "+12 SP / +10 Celeridad", color = "orange" },
    [40152] = { name = "Ametrino pujante", stats = "+12 SP / +10 Crítico", color = "orange" },
    [40162] = { name = "Ametrino de precisión", stats = "+10 Pericia / +10 Golpe", color = "orange" },
    [40153] = { name = "Ametrino velado", stats = "+12 SP / +10 Golpe", color = "orange" },
    [3568] = { item = 40152, name = "Ametrino de adepto", stats = "+10 Esquivar / +10 Defensa", color = "orange" },
    [3569] = { name = "Ametrino acérrimo", stats = "+10 Parada / +10 Defensa", color = "orange" },

    -- PÚRPURAS
    [40129] = { name = "Piedra de terror soberana", stats = "+10 Fuerza / +15 Aguante", color = "purple" },
    [40133] = { name = "Piedra de terror purificada", stats = "+12 SP / +10 Espíritu", color = "purple" },
    [40141] = { name = "Piedra de terror de guardián", stats = "+10 Parada / +15 Aguante", color = "purple" },
    [40139] = { name = "Piedra de terror del defensor", stats = "+10 Parada / +15 Aguante", color = "purple" },
    [40134] = { name = "Piedra de terror real", stats = "+12 SP / +5 MP5", color = "purple" },

    -- VERDES
    [40165] = { name = "Ojo de Zul duradero", stats = "+10 Defensa / +15 Aguante", color = "green" },
    [40167] = { name = "Ojo de Zul duradero", stats = "+10 Defensa / +15 Aguante", color = "green" },
    [40166] = { name = "Ojo de Zul vívido", stats = "+10 Golpe / +15 Aguante", color = "green" },
    [40161] = { name = "Ojo de Zul de precisión", stats = "+10 Pericia / +15 Aguante", color = "green" },
    [3575] = { item = 40167, name = "Ojo de Zul duradero", stats = "+10 Defensa / +15 Aguante", color = "green" },
    [3532] = { item = 40167, name = "Ojo de Zul duradero", stats = "+10 Defensa / +15 Aguante", color = "green" },

    -- METAS
    [3621] = { name = "Diamante de llama celeste caótico", stats = "+21 Crítico / +3% CD", color = "meta" },
    [3628] = { name = "Diamante de asedio de tierra incansable", stats = "+21 Agilidad / +3% CD", color = "meta" },
    [3637] = { name = "Diamante de asedio de tierra austero", stats = "+32 Aguante / +2% Armadura", color = "meta" },
    [3627] = { name = "Diamante de asedio de tierra perspicaz", stats = "+21 Intelecto / Maná", color = "meta" },
    [3623] = { name = "Diamante de llama celeste ardiente", stats = "+25 SP / +2% Int", color = "meta" },
    [3624] = { name = "Diamante de asedio de tierra enigmático", stats = "+21 Crítico / -10% Frenado", color = "meta" },
    [3625] = { name = "Diamante de asedio de tierra presto", stats = "+42 PA / +Velocidad", color = "meta" },
    [3631] = { name = "Diamante de asedio de tierra eterno", stats = "+21 Defensa / +5% Bloqueo", color = "meta" },
    [41380] = { name = "Diamante de asedio de tierra austero", stats = "+32 Aguante / +2% Armadura", color = "meta" },

    -- PRISMÁTICAS
    [3879] = { name = "Lágrima de pesadilla", stats = "+10 todas las estadísticas", color = "prismatic" },
 [49110] = { name = "Lágrima de pesadilla", stats = "+10 todas las estadísticas", color = "prismatic" },

    -- OJOS DE DRAGÓN (PROFE)
    [3732] = { name = "Ojo de dragón llamativo", stats = "+34 Fuerza", color = "red" },
    [3746] = { name = "Ojo de dragón precioso", stats = "+34 Pericia", color = "red" },
    [3734] = { name = "Ojo de dragón rúnico", stats = "+39 SP", color = "red" },
    [3736] = { name = "Ojo de dragón chispeante", stats = "+17 MP5", color = "blue" },
    [3735] = { name = "Ojo de dragón centelleante", stats = "+34 Espíritu", color = "blue" },
    [3744] = { name = "Ojo de dragón templado", stats = "+34 Temple", color = "red" },
    [3737] = { name = "Ojo de dragón luminoso", stats = "+34 Intelecto", color = "yellow" },
    [3739] = { name = "Ojo de dragón liso", stats = "+34 Crítico", color = "yellow" },
    [3740] = { name = "Ojo de dragón liso", stats = "+34 Esquive", color = "yellow" },
    [3741] = { name = "Ojo de dragón rígido", stats = "+34 Parada", color = "yellow" },
    [3738] = { name = "Ojo de dragón rápido", stats = "+34 Celeridad", color = "yellow" },

    -- GEMAS EQUIPADAS (WOTLK ENCHANT IDs)
    [3518] = { name = "Rubí cárdeno llamativo", stats = "+20 Fuerza", color = "red" },
    [3520] = { name = "Rubí cárdeno rúnico", stats = "+23 Poder con hechizos", color = "red" },
    [3519] = { name = "Rubí cárdeno delicado", stats = "+20 Agilidad", color = "red" },
    [3524] = { name = "Rubí cárdeno preciso", stats = "+20 Pericia", color = "red" },
    [3525] = { name = "Rubí cárdeno fracturado", stats = "+20 Pen. Armadura", color = "red" },
    [3521] = { name = "Rubí cárdeno brillante", stats = "+40 Poder de Ataque", color = "red" },
    [3522] = { name = "Rubí cárdeno sutil", stats = "+20 Esquive", color = "red" },
    [3523] = { name = "Rubí cárdeno ostentoso", stats = "+20 Parada", color = "red" },
    [3530] = { name = "Ámbar del rey gladiador", stats = "+20 Temple", color = "yellow" },
    [3531] = { name = "Ámbar del rey rápido", stats = "+20 Celeridad", color = "yellow" },
    [3533] = { name = "Ámbar del rey chispeante", stats = "+20 Espíritu", color = "yellow" },
    [3529] = { name = "Ámbar del rey grueso", stats = "+20 Defensa", color = "yellow" },
    [3527] = { name = "Ámbar del rey liso", stats = "+20 Crítico", color = "yellow" },
    [3532] = { name = "Circón majestuoso sólido", stats = "+30 Aguante", color = "blue" },
    [3526] = { name = "Ámbar del rey luminoso", stats = "+20 Intelecto", color = "yellow" },
    [3528] = { name = "Ámbar del rey rígido", stats = "+20 Golpe", color = "yellow" },
    [3548] = { item = 40155, name = "Ametrino temerario", stats = "+12 SP / +10 Celeridad", color = "orange" },
    [3545] = { item = 40133, name = "Piedra de terror purificada", stats = "+12 SP / +10 Espíritu", color = "purple" },
    [3534] = { name = "Ámbar del rey de MP5", stats = "+10 MP5", color = "yellow" },
    [3550] = { item = 40143, name = "Ametrino con grabados", stats = "+10 Fuerza / +10 Índice de Golpe", color = "orange" },
    [3535] = { name = "Gema de Penetración de Hechizo", stats = "+25 Penetracion", color = "blue" },
    [3538] = { name = "Ametrino de SP/Aguante", stats = "+12 SP / +15 Aguante", color = "purple" },
    [3539] = { name = "Piedra de terror de AP/Aguante", stats = "+20 AP / +15 Aguante", color = "purple" },
    [3540] = { item = 40162, name = "Ametrino de precisión", stats = "+10 Pericia / +10 Golpe", color = "orange" },
    [3549] = { item = 40156, name = "Ametrino de fuerza/crítico", stats = "+10 Fuerza / +10 Crítico", color = "orange" },
    [3559] = { item = 40152, name = "Ametrino pujante", stats = "+12 SP / +10 Crítico", color = "orange" },
    [3563] = { item = 40155, name = "Ametrino temerario", stats = "+12 SP / +10 Celeridad", color = "orange" },
    [3541] = { name = "Piedra de terror de parada/aguante", stats = "+10 Parada / +15 Aguante", color = "purple" },
    [3536] = { name = "Piedra de terror de fuerza/aguante", stats = "+10 Fuerza / +15 Aguante", color = "purple" },
    [3542] = { name = "Piedra de terror de pericia/aguante", stats = "+10 Pericia / +15 Aguante", color = "purple" },
}

-- Link al mapeo principal
GearAnalyzer.EnchantMapping = GearAnalyzer.EnchantMasterDB
