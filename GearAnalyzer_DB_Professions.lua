-- =========================
-- GearAnalyzer DB: Professions
-- Contains profession-specific enchantments/tinkers
-- Sync with NaerZone Scanned IDs
-- =========================
local GearAnalyzer = LibStub("AceAddon-3.0"):GetAddon("GearAnalyzer")

GearAnalyzer.ProfessionsDB = {
    -- INGENIERÍA
    [3606] = { prof = "ENGINEERING", name = "Propulsores de nitro", slot = "feet" },
    [3860] = { prof = "ENGINEERING", name = "Armadura reticulada", slot = "hands" },
    [3604] = { prof = "ENGINEERING", name = "Aceleradores hiperveloces", slot = "hands" },
    [3603] = { prof = "ENGINEERING", name = "Cohete explosivo", slot = "hands" },
    [3601] = { prof = "ENGINEERING", name = "Bomba de fragmentación", slot = "waist" },
    [3599] = { prof = "ENGINEERING", name = "Generador PEM", slot = "waist" },
    [3878] = { prof = "ENGINEERING", name = "Amplificador mental", slot = "head" },
    [3859] = { prof = "ENGINEERING", name = "Tejido arácnido elástico", slot = "back" },
    [3605] = { prof = "ENGINEERING", name = "Tejido flexible", slot = "back" },
    [3249] = { prof = "ENGINEERING", name = "Capa de paracaídas", slot = "back" },

    -- SASTRERÍA
    [3722] = { prof = "TAILORING", name = "Bordado de tejido de luz", slot = "back" },
    [3728] = { prof = "TAILORING", name = "Bordado de resplandor oscuro", slot = "back" },
    [3730] = { prof = "TAILORING", name = "Bordado de guardia de espada", slot = "back" },
    [3872] = { prof = "TAILORING", name = "Hilo de hechizo santificado", slot = "legs" },

    -- PELETERÍA
    [3756] = { prof = "LEATHERWORKING", name = "Forro de pelaje de ataque", slot = "wrists" },
    [3757] = { prof = "LEATHERWORKING", name = "Forro de pelaje de aguante", slot = "wrists" },
    [3758] = { prof = "LEATHERWORKING", name = "Forro de pelaje de poder con hechizos", slot = "wrists" },

    -- INSCRIPCIÓN
    [61117] = { prof = "INSCRIPTION", name = "Inscripción del hacha de maestro", slot = "shoulders" },
    [61118] = { prof = "INSCRIPTION", name = "Inscripción de la tormenta de maestro", slot = "shoulders" },
    [61120] = { prof = "INSCRIPTION", name = "Inscripción del risco de maestro", slot = "shoulders" },
    [61119] = { prof = "INSCRIPTION", name = "Inscripción del pináculo de maestro", slot = "shoulders" },
  --  [3835] = { prof = "INSCRIPTION", name = "Inscripción del hacha del maestro (Legacy)", slot = "shoulders" },
    [3838] = { prof = "INSCRIPTION", name = "Inscripción de la tormenta del maestro (Legacy)", slot = "shoulders" },

    -- ENCANTAMIENTO
    [3840] = { prof = "ENCHANTING", name = "Encantar anillo: poder con hechizos superior", slot = "ring" },
    [3839] = { prof = "ENCHANTING", name = "Encantar anillo: asalto superior", slot = "ring" },
    [3791] = { prof = "ENCHANTING", name = "Encantar anillo: aguante superior", slot = "ring" },
    [2094] = { prof = "ENCHANTING", name = "Encantar anillo: poder con hechizos", slot = "ring" },
}
