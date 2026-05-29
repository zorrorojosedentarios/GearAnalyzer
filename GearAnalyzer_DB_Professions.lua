-- =========================
-- GearAnalyzer DB: Professions
-- Contains profession-specific enchantments/tinkers
-- Sync with NaerZone Scanned IDs
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

GearAnalyzer.ProfessionsDB = {
    -- INGENIERÍA
    [3606] = { prof = "ENGINEERING", name = "Propulsores de nitro", slot = "feet" },
    [3855] = { prof = "ENGINEERING", name = "Propulsores de nitro (asentado)", slot = "feet" },
    [3860] = { prof = "ENGINEERING", name = "Armadura reticulada", slot = "hands" },
    [3604] = { prof = "ENGINEERING", name = "Aceleradores hiperveloces", slot = "hands" },
    [3603] = { prof = "ENGINEERING", name = "Cohete explosivo", slot = "hands" },
    [3601] = { prof = "ENGINEERING", name = "Bomba de fragmentación", slot = "waist" },
    [3599] = { prof = "ENGINEERING", name = "Generador PEM", slot = "waist" },
    [3878] = { prof = "ENGINEERING", name = "Plato de amplificación mental", slot = "head" },
    [3875] = { prof = "ENGINEERING", name = "Gafas de visión nocturna", slot = "head" },
    [41269] = { prof = "ENGINEERING", name = "Gafas de titanio", slot = "head" },
    [3859] = { prof = "ENGINEERING", name = "Tejido arácnido elástico", slot = "back" },
    [3605] = { prof = "ENGINEERING", name = "Tejido flexible", slot = "back" },
    [3830] = { prof = "ENGINEERING", name = "Tejido flexible", slot = "back" },
    [3249] = { prof = "ENGINEERING", name = "Capa de paracaídas", slot = "back" },

    -- SASTRERÍA
    [3722] = { prof = "TAILORING", name = "Bordado de tejido de luz", slot = "back" },
    [3728] = { prof = "TAILORING", name = "Bordado de resplandor oscuro", slot = "back" },
    [3730] = { prof = "TAILORING", name = "Bordado de guardia de espada", slot = "back" },
    [3872] = { prof = "TAILORING", name = "Hilo de hechizo santificado", slot = "legs" },
    [3719] = { prof = "TAILORING", name = "Hilo de hechizo luminoso", slot = "legs" },

    -- PELETERÍA
    [3756] = { prof = "LEATHERWORKING", name = "Forro de pelaje de ataque", slot = "wrists" },
    [3850] = { prof = "LEATHERWORKING", name = "Forro de pelaje de ataque", slot = "wrists" },
    [3757] = { prof = "LEATHERWORKING", name = "Forro de pelaje de aguante", slot = "wrists" },
    [3758] = { prof = "LEATHERWORKING", name = "Forro de pelaje de poder con hechizos", slot = "wrists" },
    [3851] = { prof = "LEATHERWORKING", name = "Forro de pelaje de poder con hechizos", slot = "wrists" },

    -- INSCRIPCIÓN (actuales 61117-61120 + legacy 3835-3838)
    [61117] = { prof = "INSCRIPTION", name = "Inscripción del hacha de maestro", slot = "shoulders" },
    [61118] = { prof = "INSCRIPTION", name = "Inscripción de la tormenta de maestro", slot = "shoulders" },
    [61120] = { prof = "INSCRIPTION", name = "Inscripción del risco de maestro", slot = "shoulders" },
    [61119] = { prof = "INSCRIPTION", name = "Inscripción del pináculo de maestro", slot = "shoulders" },
    [3835] = { prof = "INSCRIPTION", name = "Inscripción del hacha de maestro (Legacy)", slot = "shoulders" },
    [3836] = { prof = "INSCRIPTION", name = "Inscripción de la tormenta de maestro (Legacy)", slot = "shoulders" },
    [3837] = { prof = "INSCRIPTION", name = "Inscripción del pináculo de maestro (Legacy)", slot = "shoulders" },
    [3838] = { prof = "INSCRIPTION", name = "Inscripción del risco de maestro (Legacy)", slot = "shoulders" },

    -- ENCANTAMIENTO
    [3840] = { prof = "ENCHANTING", name = "Encantar anillo: poder con hechizos superior", slot = "ring" },
    [3839] = { prof = "ENCHANTING", name = "Encantar anillo: asalto superior", slot = "ring" },
    [3791] = { prof = "ENCHANTING", name = "Encantar anillo: aguante superior", slot = "ring" },
    [2094] = { prof = "ENCHANTING", name = "Encantar anillo: poder con hechizos", slot = "ring" },

    -- JOYERÍA
    [3731] = { prof = "JEWELCRAFTING", slot = "waist", name = "Hebilla eterna" },
    [3732] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón llamativo" },
    [3734] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón rúnico" },
    [3737] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón luminoso" },
    [3739] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón liso" },
    [3738] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón rápido" },
    [3746] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón precioso" },
    [3736] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón chispeante" },
    [3735] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón centelleante" },
    [3744] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón templado" },
    [3741] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón rígido" },
    [3740] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón de esquivar" },
    [3743] = { prof = "JEWELCRAFTING", slot = "gem", name = "Ojo de dragón delicado" },

    -- HERRERÍA
    [44941] = { prof = "BLACKSMITHING", slot = "wrists", name = "Ranura de muñeca" },
    [44942] = { prof = "BLACKSMITHING", slot = "hands", name = "Ranura de guantes" },
    [44936] = { prof = "BLACKSMITHING", slot = "weapon", name = "Encantamiento de arma extra" },

    -- MINERÍA
    [2933] = { prof = "MINING", slot = "passive", name = "Aguante de minero" },
    [3831] = { prof = "MINING", slot = "passive", name = "Aguante" },

    -- HERBOLARIO
    [2934] = { prof = "HERBALISM", slot = "passive", name = "Vida de herbalista" },

    -- DESOLLAR
    [2935] = { prof = "SKINNING", slot = "passive", name = "Maestro desollador" },
}
