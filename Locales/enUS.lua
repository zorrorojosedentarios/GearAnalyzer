-- ============================================================
-- GearAnalyzer: English (enUS/enGB) Base Locale
-- ============================================================
local MAJOR, MINOR = "AceLocale-3.0", 2
local aceL = LibStub(MAJOR):NewLocale("GearAnalyzer", "enUS", true)

GearAnalyzer_Locale_enUS = {}
local L = GearAnalyzer_Locale_enUS

-- Metatable to also write to AceLocale if available
setmetatable(L, {
    __newindex = function(t, k, v)
        rawset(t, k, v)
        if aceL then aceL[k] = (v == true and k or v) end
    end
})
if not L then return end

-- ========================
-- UI Tabs
-- ========================
L["TAB_EQUIPMENT"]          = "Equipment"
L["TAB_GEMS"]               = "Gems"
L["TAB_ENCHANTS"]           = "Enchants"
L["TAB_GLYPHS"]             = "Glyphs"
L["TAB_TALENTS"]            = "Talents"
L["TAB_BIS"]                = "BiS / Tops"
L["TAB_CAPS"]               = "Caps / Stats"
L["TAB_GENERAL"]            = "Gems/Glyphs/Caps"
L["TAB_EXPORT"]             = "Export AI"
L["TAB_INFO"]               = "Info"
L["TAB_CONFIG"]             = "Config"

-- ========================
-- Config Tab
-- ========================
L["INTERFACE_SETTINGS"]     = "INTERFACE SETTINGS"
L["DEV_SETTINGS_TITLE"]     = "INTERFACE AND DEVELOPER SETTINGS"
L["DEV_MODE"]               = "Dev Mode"
L["DEV_MODE_TOGGLED"]       = "Developer Mode %s"
L["SHOW_ERRORS"]            = "Show Errors"
L["HIDE_ERRORS"]            = "Hide Errors"
L["SCAN_OPEN_PROF"]         = "Scan Open Prof."
L["DEBUG_GEMS"]             = "Debug Gems"
L["SHOW_MINIMAP_ICON"]      = " Show Minimap Icon"
L["FONT_SIZE"]              = "Font Size (Text)"
L["ICON_SIZE"]              = "Icon Size"
L["RESET_VISUAL"]           = "Reset Visual"
L["VISUAL_RESET_MSG"]       = "Visual settings restored (Font: 12, Icons: 32)."
L["ON"]                     = "ON"
L["OFF"]                    = "OFF"

-- ========================
-- Info Tab
-- ========================
L["INFO_TITLE"]             = "Operational Guide - GearAnalyzer %s"
L["INFO_INTRO"]             = "Hi %s!\n\nWelcome to %s. Here's how to get the most out of the addon:\n\n"
L["INFO_CREDITS"]           = "Addon Developed by zorrorojo Guild <Sedentarios> for the NaerZone Server"
L["SECTION_1_TITLE"]        = "A. SELECTORS (GUIDE WINDOW)"
L["SECTION_1_BODY"]         = "By clicking the |cffffd100'Open Guide'|r button, you will see two menus in the top right corner:\n• |cffffd100Class:|r Allows you to analyze any class in the game.\n• |cffffd100Specialization:|r Select the talent tree you wish to consult.\n• |cff00ff00Note:|r In your character window (PJ), this selection is automatic."
L["SECTION_2_TITLE"]        = "1. Tab: EQUIPMENT"
L["SECTION_2_BODY"]         = "Real-time analysis of your equipped gear.\n• Compares your pieces with the current BiS build.\n• Indicates if |cffff0000[G]|r gems or |cffff0000[E]|r enchantments are missing.\n• Shows the 'Next Best' item you could get.\n• |cff00ff00Equip:|r Smart button to equip the best items from your bags."
L["SECTION_3_TITLE"]        = "2, 3 and 4. GEMS / ENCHANTS / GLYPHS"
L["SECTION_3_BODY"]         = "Universal reference libraries.\n• |cffffd100Gems:|r Shows optimal cuts according to stat priorities.\n• |cffffd100Enchants:|r Categorized by slot, prioritizing BiS.\n• |cffffd100Glyphs:|r Suggestions to maximize spec performance."
L["SECTION_4_TITLE"]        = "5. Tab: TALENTS"
L["SECTION_4_BODY"]         = "Optimized build visualizer.\n• |cff00ff00BiS Map:|r Shows complete talent trees.\n• |cffffd100Export:|r Compatible with the 'Talented' addon to copy the build.\n• Allows viewing talents of any class using the top selector."
L["SECTION_5_TITLE"]        = "6. Tab: CAPS"
L["SECTION_5_BODY"]         = "Critical stat monitoring.\n• Automatically calculates how much you need for |cffffd100Soft/Hard Caps|r.\n• Dynamically adapts according to the talents and class you are analyzing."
L["SECTION_6_TITLE"]        = "7. Tab: BIS / TOPS"
L["SECTION_6_BODY"]         = "Loot database by phases (Pre-raid, T9 to ICC/RS).\n• |cffffff00Alt + Click:|r Pins an item as |cff00ff00TARGET|r (easy to follow in the tooltip).\n• |cffffd100Filters:|r Select the content phase to see the top pieces."
L["SECTION_7_TITLE"]        = "8. Tab: EXPORT AI"
L["SECTION_7_BODY"]         = "Integration with Artificial Intelligence.\n• Generates a detailed character report in plain text.\n• Copy and paste it into |cffffd100ChatGPT, Claude, or Gemini|r for advanced advice."
L["SECTION_8_TITLE"]        = "9. GUIDE WINDOW"
L["SECTION_8_BODY"]         = "Access via the |cffffd100'Open Guide'|r button or |cffffd100/gag|r command.\n• Allows exploring recommendations for |cff00ff00ANY|r class and specialization.\n• Ideal for gearing alts or checking data without switching characters."
L["SECTION_9_TITLE"]        = "10. Tab: CONFIGURATION"
L["SECTION_9_BODY"]         = "Customize your addon experience.\n• |cffffd100Interface:|r Change font and icon size.\n• |cffffd100Minimap:|r Hide or show the quick access button."
L["SECTION_10_TITLE"]       = "11. SMART DETECTION"
L["SECTION_10_BODY"]        = "The addon automatically detects your specialization by analyzing:\n• Your spent talent points.\n• Your current stats and gear (e.g., distinguishes a Tank DK from a DPS DK)."
L["SECTION_11_TITLE"]       = "12. DYNAMIC GEMS (BREAK POINT)"
L["SECTION_11_BODY"]        = "Some classes change their optimal gemming when they accumulate enough passive Armor Penetration (ArPen) from gear.\n\n|cffffd100Why not at the 1400 hard cap?|r\nThe Break Point is the moment where gemming full ArPen will push you to the 1400 hard cap. If you waited until 1400, you'd already be capped without gems.\n\n|cffffd100Thresholds by class:|r\n• |cffff8000Frost DK:|r < 1000 ArPen → Full Strength | ≥ 1000 ArPen → Full ArPen\n• |cff00cc00Feral (Cat) Druid:|r < 700 ArPen → Full Agility | ≥ 700 ArPen → Full ArPen\n• |cff00aaff Marksmanship Hunter:|r < 800 ArPen → Full Agility | ≥ 800 ArPen → Full ArPen\n\n|cff00ff00How does it work?|r\nThe addon reads your current passive ArPen (gear + enchants) when you open the Gems tab. If you cross the threshold, the text changes to |cffffd100FINAL PHASE|r and gem recommendations update automatically with no manual configuration needed."

-- ========================
-- Dynamic Gems Notes
-- ========================
L["DYNAMIC_GEM_NOTE_DK_FROST_FINAL"]   = "FINAL PHASE (Full ArPen): You have passed the ArP Break Point (~1050). It is recommended to gem Full ArPen (+20 ArPen) up to the Hard Cap of 1400."
L["DYNAMIC_GEM_NOTE_DK_FROST_INITIAL"] = "INITIAL PHASE (Full Strength): You have not yet reached the Break Point (~1050 passive ArP). It is recommended to gem Full Strength (+20 Strength)."
L["DYNAMIC_GEM_NOTE_DRUID_CAT_FINAL"]   = "FINAL PHASE (Full ArPen): You have passed the ArP Break Point (~750). It is recommended to gem Full ArPen (+20 ArPen) up to the Hard Cap of 1400."
L["DYNAMIC_GEM_NOTE_DRUID_CAT_INITIAL"] = "INITIAL PHASE (Full Agility): You have not yet reached the Break Point (~750 passive ArP). It is recommended to gem Full Agility (+20 Agi)."
L["DYNAMIC_GEM_NOTE_HUNTER_MM_FINAL"]   = "FINAL PHASE (Full ArPen): You have passed the ArP Break Point (~800). It is recommended to gem Full ArPen (+20 ArPen) up to the Hard Cap of 1400."
L["DYNAMIC_GEM_NOTE_HUNTER_MM_INITIAL"] = "INITIAL PHASE (Full Agility): You have not yet reached the Break Point (~800 passive ArP). It is recommended to gem Full Agility (+20 Agi)."

-- ========================
-- General UI
-- ========================
L["CLOSE"]                  = "Close"
L["LOADING"]                = "Loading..."
L["RELOAD_UI"]              = "Reload UI"
L["RESET_ALL"]              = "Reset All"
L["EXPORT_CHANGES"]         = "Export"
L["SCAN_JEWELRY"]           = "Scan Jewelry"
L["SCAN_PROFESSION"]        = "Scan Profession"

-- ========================
-- Minimap / Messages
-- ========================
L["VERSION_TOOLTIP"]        = "Version: %s"
L["LEFT_CLICK_OPEN"]        = "Left Click: Open/Close Panel"
L["SPEC_DETECTED"]          = "Specialization detected: %s"
L["DB_POPULATED"]           = "Master Database populated with %d records."

-- ========================
-- Class & Spec Selectors
-- ========================
L["CLASS"]                  = "Class:"
L["SPEC"]                   = "Specialization:"
L["AUTOMATIC"]              = "Automatic"
L["DEATHKNIGHT"]            = "Death Knight"
L["DRUID"]                  = "Druid"
L["HUNTER"]                 = "Hunter"
L["MAGE"]                   = "Mage"
L["PALADIN"]                = "Paladin"
L["PRIEST"]                 = "Priest"
L["ROGUE"]                  = "Rogue"
L["SHAMAN"]                 = "Shaman"
L["WARLOCK"]                = "Warlock"
L["WARRIOR"]                = "Warrior"

-- Spec display names (keys = internal English names from GetCurrentSpecEnhanced)
L["None"]                   = "None"
L["Feral"]                  = "Feral"
L["Assassination"]          = "Assassination"
L["Combat"]                 = "Combat"
L["Subtlety"]               = "Subtlety"
L["Blood"]                  = "Blood"
L["Frost"]                  = "Frost"
L["Unholy"]                 = "Unholy"
L["Arms"]                   = "Arms"
L["Fury"]                   = "Fury"
L["Protection"]             = "Protection"
L["Holy"]                   = "Holy"
L["Retribution"]            = "Retribution"
L["Discipline"]             = "Discipline"
L["Shadow"]                 = "Shadow"
L["Elemental"]              = "Elemental"
L["Enhancement"]            = "Enhancement"
L["Restoration"]            = "Restoration"
L["Affliction"]             = "Affliction"
L["Demonology"]             = "Demonology"
L["Destruction"]            = "Destruction"
L["Arcane"]                 = "Arcane"
L["Fire"]                   = "Fire"
L["Frostfire"]              = "Frostfire"
L["Fire FFB"]               = "Fire (FFB)"
L["Balance"]                = "Balance"
L["Feral Cat"]              = "Feral (Cat)"
L["Feral Bear"]             = "Feral (Bear)"
L["Beast Mastery"]          = "Beast Mastery"
L["Marksmanship"]           = "Marksmanship"
L["Survival"]               = "Survival"
L["Sangre (Tanque)"]        = "Blood (Tank)"
L["Escarcha (DPS)"]         = "Frost (DPS)"
L["Profano (DPS)"]          = "Unholy (DPS)"
L["Escarcha (Tanque)"]      = "Frost (Tank)"
L["Proteccion (Paladin)"]   = "Protection (Paladin)"
L["Proteccion (Guerrero)"]  = "Protection (Warrior)"

-- Internal Slot Tags (used in mapping and AI Export)
L["SLOT_HEAD"]              = "Head"
L["SLOT_NECK"]              = "Neck"
L["SLOT_SHOULDERS"]         = "Shoulders"
L["SLOT_BACK"]              = "Back"
L["SLOT_CHEST"]             = "Chest"
L["SLOT_WRISTS"]            = "Wrists"
L["SLOT_HANDS"]             = "Hands"
L["SLOT_WAIST"]             = "Waist"
L["SLOT_LEGS"]              = "Legs"
L["SLOT_FEET"]              = "Feet"
L["SLOT_FINGER1"]           = "Finger 1"
L["SLOT_FINGER2"]           = "Finger 2"
L["SLOT_TRINKET1"]          = "Trinket 1"
L["SLOT_TRINKET2"]          = "Trinket 2"
L["SLOT_MAINHAND"]          = "Main Hand"
L["SLOT_OFFHAND"]           = "Off Hand"
L["SLOT_RANGED"]            = "Ranged"
L["SLOT_TABARD"]            = "Tabard"
L["SLOT_SHIRT"]             = "Shirt"

-- Gem Types
L["GEM_META"]               = "Meta"
L["GEM_RED"]                = "Red"
L["GEM_YELLOW"]             = "Yellow"
L["GEM_BLUE"]               = "Blue"

-- Statistics Translators (for Dynamic Labels)
L["Fuerza"]                 = "Strength"
L["Agilidad"]               = "Agility"
L["Aguante"]                = "Stamina"
L["Intelecto"]              = "Intellect"
L["Espiritu"]               = "Spirit"
L["Poder con hechizos"]     = "Spell Power"
L["Poder de hechizos"]      = "Spell Power"
L["Poder de Hechizos"]      = "Spell Power"
L["Hechizos"]               = "Spell Power"
L["Poder de ataque"]        = "Attack Power"
L["Indice de golpe"]        = "Hit Rating"
L["Golpe (Hechizos)"]      = "Spell Hit"
L["Indice de golpe critico"] = "Crit Rating"
L["Celeridad"]              = "Haste"
L["Pericia"]                = "Expertise"
L["Penetracion de armadura"] = "Armor Pen"
L["Defensa"]                = "Defense"
L["Esquiva"]                = "Dodge"
L["Parada"]                 = "Parry"
L["Bloqueo"]                = "Block"
L["Resplemancimiento"]      = "MP5"

-- Analysis Messages
L["OK"]                     = "OK"
L["MISSING_TAG"]            = "MISSING"
L["EXCESS_TAG"]             = "EXCESS"
L["LACKING"]                = "Lacking %s"
L["GEMS_LACKING_RED"]       = "Missing Red Gems (%d/%d)"
L["GEMS_LACKING_YELLOW"]    = "Missing Yellow Gems (%d/%d)"
L["GEMS_LACKING_BLUE"]      = "Missing Blue Gems (%d/%d)"
L["GEMS_REQ_RED_GT_YELLOW"] = "Requires Red > Yellow"
L["IGNORE_COLOR"]           = "(IGNORE COLOR)"
L["JEWELRY_BIS"]            = "(Jewelry BiS: Dragon's Eye)"
L["NO_ENCHANT_REQUIRED"]    = "No enchant required"
L["NO_REQ_EMPTY"]           = "No requirement (Empty)"
L["NO_REQ_2H"]              = "Not applicable (2H Weapon)"
L["NO_REQ_SHIELD"]          = "Not applicable (Not a shield)"
L["WRONG_ENCHANT"]          = "Wrong enchant"
L["CORRECT_ENCHANT"]        = "Correct enchant"
L["PROFESSION_ONLY"]        = "Profession specific"
L["GEMS_OK"]                = "Gems OK"
L["GEMS_TO_CHANGE"]         = "Gems to change"
L["NO_GEM_FOUND"]           = "Gem not found"

-- Caps & Stats Tab Headers
L["CRITICAL_CAPS"]          = "Critical Caps"
L["OPTIMIZATION_CAPS"]      = "Optimization Caps"
L["MAIN_STATS"]             = "Primary Stats"
L["GENERAL_SUMMARY"]        = "General Stats"
L["STATS_AND_CAPS"]         = "Stats & Caps"
L["CAPPED_OK"]              = "CAPPED"
L["EXCESS"]                 = "EXCESS"
L["STAT_ERROR_MSG"]         = "No stats data for %s %s"

L["AI_INTRO_PROMPT"]       = "Analyze this World of Warcraft 3.3.5a (WotLK) profile from the NaerZone server. Act as an expert in gear optimization, gems, and rotation:"
L["TALENT_DISTRIBUTION"]   = "TALENT DISTRIBUTION"
L["ACTIVE_GLYPHS"]         = "ACTIVE GLYPHS"
L["KEY_STATS"]             = "KEY STATISTICS"
L["CAPS_STATUS_LOGS"]      = "CAPS STATUS / ACHIEVEMENTS"
L["EQUIPMENT_DETAILS"]     = "DETAILED GEAR & GEMS"
L["MAJOR"]                 = "Major"
L["MINOR"]                 = "Minor"
L["MAX_HEALTH"]            = "Max Health"
L["ARMOR"]                 = "Armor"
L["ATTACK_POWER"]          = "Attack Power"
L["RANGE"]                 = "Range"
L["ENCHANT_LABEL"]         = "Enchant"
L["GEM_LABEL"]             = "Gem"
L["NO_GLYPHS"]             = "No glyphs detected"
L["PRIORITY_TAG"]          = "Priority"
L["PROFILE_FINISH"]        = "END OF PROFILE"
L["GENERATED_BY"]          = "Generated by GearAnalyzer"
L["BRANCH"]                = "Branch"
L["EMPTY"]                 = "Empty"
L["SPEC_LABEL"]            = "SPEC"
L["PROFILE_LABEL"]         = "PROFILE"
L["Equilibrio"]             = "Balance"
L["Feral Gato"]             = "Feral (Cat)"
L["Feral Oso"]              = "Feral (Bear)"
L["Restauracion"]           = "Restoration"
L["Sangre"]                 = "Blood"
L["Escarcha"]               = "Frost"
L["Profano"]                = "Unholy"
L["Sagrado"]                = "Holy"
L["Proteccion"]             = "Protection"
L["Reprension"]             = "Retribution"
L["Armas"]                  = "Arms"
L["Furia"]                  = "Fury"
L["Arcano"]                 = "Arcane"
L["Fuego"]                  = "Fire"
L["Pirofrio"]               = "Frostfire"
L["Disciplina"]             = "Discipline"
L["Sombras"]                = "Shadow"
L["Mejora"]                 = "Enhancement"
L["Afliccion"]              = "Affliction"
L["Demonologia"]            = "Demonology"
L["Demonologia (Diablillo)"] = "Demonology (Imp)"
L["Demonologia (Guardia Vil)"] = "Demonology (Felguard)"
L["Destruccion"]            = "Destruction"
L["Asesinato"]              = "Assassination"
L["Combate"]                = "Combat"
L["Bestias"]                = "Beast Mastery"
L["Punteria"]               = "Marksmanship"
L["Supervivencia"]          = "Survival"

-- ========================
-- Stats Names
-- ========================
L["STAT_HIT"]               = "Hit Rating"
L["STAT_HIT_SPELL"]         = "Hit (Spell)"
L["STAT_EXPERTISE"]         = "Expertise"
L["STAT_ARP"]               = "Armor Pen."
L["STAT_HASTE"]             = "Haste"
L["STAT_CRIT"]              = "Crit"
L["STAT_SP"]                = "Spell Power"
L["STAT_STA"]               = "Stamina"
L["STAT_AGI"]               = "Agility"
L["STAT_STR"]               = "Strength"
L["STAT_INT"]               = "Intellect"
L["STAT_SPIRIT"]            = "Spirit"
L["STAT_DEF"]               = "Defense"
L["STAT_ARMOR"]             = "Armor"
L["STAT_DODGE"]             = "Dodge"
L["STAT_PARRY"]             = "Parry"
L["STAT_AP"]                = "Attack Power"
L["STAT_RAP"]               = "Ranged AP"

-- ========================
-- Caps & Stats Tab
-- ========================
L["STATS_AND_CAPS"]         = "STATS AND CAPS"
L["CRITICAL_CAPS"]          = "CRITICAL CAPS"
L["OPTIMIZATION_CAPS"]      = "OPTIMIZATION CAPS"
L["MAIN_STATS"]             = "MAIN STATISTICS"
L["GENERAL_SUMMARY"]        = "GENERAL SUMMARY"
L["EXCESS_TAG"]             = "[EXCESS]"
L["CAPPED_OK"]              = "[OK]"
L["EXCESS"]                 = "EXCESS"
L["MISSING_LABEL"]          = "MISSING"
L["STAT_ERROR_MSG"]         = "Error: No data for %s / %s"
L["HIT_CAP"]                = "Hit Cap"
L["EXPERTISE_CAP"]          = "Expertise Cap"
L["EXP_SOFT_CAP"]           = " (Soft Cap)"
L["EXP_HARD_CAP"]           = " (Hard Cap)"
L["EXP_NOTE_TANK"]          = "Avoid Dodges"
L["EXP_NOTE_DPS"]           = "Hard Cap (Avoid Dodges)"
L["EXP_SOFT_HARD_FMT"]      = "Soft %d / Hard %d"
L["BADGE_INCOMPLETE"]       = "[INCOMPLETE]"
L["BADGE_EXCESS"]           = "[EXCESS]"
L["BADGE_CAP_OK"]           = "[CAP OK]"
L["BADGE_SOFT_OK"]          = "[SOFT OK]"
L["BADGE_HARD_OK"]          = "[HARD OK]"
L["HASTE_GOAL"]             = "Haste Goal"
L["ARMOR_PEN_CAP"]          = "Armor Pen. Cap"
L["SPELL_PEN_CAP"]          = "Spell Pen. Cap"
L["STAT_PRIORITY"]          = "Stat Priority"
L["PRIORITY_ORDER"]         = "Priority Order"
L["NOTES"]                  = "Notes"
L["SECONDARY_CAPS"]         = "Secondary Caps"

-- ========================
-- Slot Names
-- ========================
L["SLOT_HEAD"]              = "Head"
L["SLOT_NECK"]              = "Neck"
L["SLOT_SHOULDERS"]         = "Shoulders"
L["SLOT_BACK"]              = "Back"
L["SLOT_CHEST"]             = "Chest"
L["SLOT_WRISTS"]            = "Wrists"
L["SLOT_HANDS"]             = "Hands"
L["SLOT_WAIST"]             = "Waist"
L["SLOT_LEGS"]              = "Legs"
L["SLOT_FEET"]              = "Feet"
L["SLOT_RING"]              = "Ring"
L["SLOT_TRINKET"]           = "Trinket"
L["SLOT_WEAPON"]            = "Weapon"
L["SLOT_OFFHAND"]           = "Off-hand"
L["SLOT_RELIC"]             = "Relic"
L["SLOT_RANGED"]            = "Ranged"

-- ========================
-- BiS / Tops Tab
-- ========================
L["PHASE"]                  = "Phase"
L["INTERNAL_GUIDES"]        = "Internal (Guides v3.5)"
L["INTERNAL"]               = "Internal"
L["INTERNAL_DB"]            = "Internal Database"
L["FINAL_BIS_GUIDE"]        = "Final BiS Guide"
L["TOKEN_MISSION"]          = "Token / Quest"
L["PROFESSION_VENDOR"]      = "Profession / Vendor"
L["GUIDE"]                  = "GUIDE"
L["RESET"]                  = "RESET"
L["BIS_RESET_MSG"]          = "BiS selection reset to Top 1."
L["RESTORE_BIS"]            = "Restore BiS"
L["RESTORE_BIS_DESC"]       = "Clear your manually pinned targets\nand return to the default Top 1."
L["SELECTED_TARGET"]        = "SELECTED TARGET (BOSS / DROP)"
L["USAGE_INSTRUCTIONS"]     = "USAGE INSTRUCTIONS"
L["ALT_CLICK"]              = "Alt + Click"
L["ALT_CLICK_DESC"]         = "Pin the item as your manual TARGET."
L["GREEN_BORDER"]           = "Green Border"
L["GREEN_BORDER_DESC"]      = "It is your pinned goal. White Border: It is the best item (Top 1)."
L["SAVE_BETWEEN_SESSIONS"]  = "Targets are saved permanently between sessions."
L["SOURCE"]                 = "Source"
L["SOURCE_COLON"]           = "Source:"
L["RANKING"]                = "Ranking"
L["ALREADY_HAVE_ITEM"]      = "You already have this item!"
L["TARGET_SAVED_MSG"]       = "Target SAVED for %s: %s"
L["GUIDE_RECOMMENDATION"]   = "GUIDE RECOMMENDATION"
L["ABSOLUTE_BIS"]           = "Absolute BiS / Manual"
L["CURRENT_TARGET"]         = "CURRENT TARGET"
L["CHOSEN_VIA_ALT_CLICK"]   = "Chosen via Alt+Click"

-- ========================
-- Equipment Tab
-- ========================
L["ANALYSIS"]               = "ANALYSIS"
L["NEXT_UPGRADE"]           = "NEXT UPGRADE"
L["STATUS"]                 = "STATUS"
L["NO_DATA"]                = "No Data"
L["STATUS_BIS"]             = "Final BiS"
L["STATUS_ALMOST_BIS"]      = "Almost BiS"
L["STATUS_INCORRECT"]       = "Not Optimal"
L["STATUS_UPGRADABLE"]      = "Upgradable"
L["STATUS_LOW_LVL"]         = "Low iLvl"
L["EQUIP"]                  = "EQUIP"
L["BANK"]                   = "BANK"
L["EQUIPPING_MSG"]          = "Equipping %s in slot %s"
L["EQUIPPING_SIMPLE_MSG"]   = "Equipping %s"
L["IN_BAGS"]                = "(In your bags)"
L["IN_BANK"]                = "(In the BANK)"
L["LOCATION"]               = "Location"
L["BANK_WARNING"]           = "You must take it out of the bank to equip it."
L["EQUIP_INSTRUCTIONS"]     = "Click EQUIP to use it."
L["EMPTY"]                  = "Empty"
L["NEXT_BIG_UPGRADE"]       = "Next big upgrade for this slot"
L["ANALYSIS_LEGEND"]        = "ANALYSIS LEGEND"
L["LEGEND_TEXT"]            = "|cff00ff00[G]|r Gems OK    |cffffff00[G]|r Gems not optimal    |cffff0000[G]|r Missing gems\n" ..
        "|cff00ff00[E]|r Enchanted    |cffffa500[E]|r Profession    |cffff0000[E]|r Not enchanted\n" ..
        "|cff00ff00BiS|r Perfect    |cff00ccffAlmost BiS|r Top 6    |cffffff00Upgradable|r Correct    |cffffa500Low Lvl|r Outdated\n" ..
        "|cffaaaaaaNo Data|r: Item not found in the BiS database for your class/specialization."
L["CAPS_LEGEND"]            = "PROGRESS BAR COLOR GUIDE"
L["CAPS_LEGEND_TEXT"]       = "• |cffffd100Gold / Amber|r: Incomplete. You have not yet reached the minimum or soft cap.\n• |cff33d1ffCeleste / Blue|r: Soft Cap OK. You have reached the soft cap (good intermediate status).\n• |cff44ff44Emerald Green|r: Hard Cap OK. You have reached the final or absolute cap.\n• |cffff9900Vibrant Orange|r: Excess. You have significantly exceeded the maximum cap (inefficient)."

L["ENCHANT_STATUS_TITLE"]   = "Enchantment Status"
L["WORTH_IT"]               = "WORTH IT"
L["IGNORE"]                 = "IGNORE"
L["BONUS"]                  = "Bonus"
L["SUGGESTED"]              = "Suggested"
L["NOTE"]                   = "Note"
L["NIGHTMARE_TEAR_RECOMMENDATION"] = "Nightmare Tear is recommended here to activate the Meta gem."

-- ========================
-- Gems Tab
-- ========================
L["RECOMMENDED_GEMS"]       = "Recommended Gems"
L["GEM_PRIORITY_HINT"]      = "Prioritize gems that help you reach your stat Caps first."
L["GEM_ANALYSIS_TITLE"]     = "Gems and Sockets Analysis"
L["GUIDE_LABEL"]            = "Guide:"
L["PRIORITY_LABEL"]         = "Priority:"
L["BAGS"]                   = "Bags"
L["CAPS_STATUS"]            = "Caps Status"
L["MISSING_GEMS_TITLE"]     = "Missing gems in equipment:"
L["MISSING_GEMS_COUNT"]     = "Missing %d gems (Empty Sockets):"
L["CHANGE_GEMS_COUNT"]      = "You must change %d gems:"
L["TOTAL_TO_SHOP"]          = "Total to buy/get:"
L["YOUR_EQUIPPED_GEMS"]     = "Your Equipped Gems:"
L["NO_GEMS_EQUIPPED"]       = "You have no gems equipped."
L["ALL_GEMS_CORRECT"]       = "All gems are correct in your current equipment!"
L["META"]                   = "Meta"
L["RED"]                    = "Red"
L["YELLOW"]                 = "Yellow"
L["BLUE"]                   = "Blue"
L["JEWELRY"]                = "Jewelry"
L["USE"]                    = "Use"

-- ========================
-- Enchants Tab
-- ========================
L["ENCHANT_GUIDE"]          = "Enchantment Guide"
L["NO_ENCHANT_GUIDE_FOUND"] = "No enchantment guides registered for:"
L["ENCHANT_LEGEND_TEXT"]    = "|cff00ff00(Green Check)|r: Correct enchantment\n" ..
            "|cffffa500(Orange Check)|r: Profession benefit\n" ..
            "|cffff0000(Red Cross)|r: Missing or incorrect enchantment"

-- ========================
-- Glyphs Tab
-- ========================
L["GLYPH_MANAGEMENT"]       = "Glyph Management"
L["RECOMMENDED_GUIDE"]      = "RECOMMENDED (GUIDE)"
L["CURRENTLY_EQUIPPED"]     = "CURRENTLY EQUIPPED"
L["MAJOR_GLYPHS"]           = "MAJOR GLYPHS"
L["MINOR_GLYPHS"]           = "MINOR GLYPHS"
L["MAJOR"]                  = "Major"
L["MINOR"]                  = "Minor"
L["GLYPH_OF"]               = "Glyph of "
L["GLYPH_OF_2"]             = "Glyph - "

-- ========================
-- Talents Tab
-- ========================
L["VIEW_MY_POINTS"]         = "VIEW: MY POINTS"
L["VIEW_SUGGESTED"]         = "VIEW: SUGGESTED"
L["PET"]                    = "Pet"
L["TREE"]                   = "Tree"
L["SUGGESTED_POINTS"]       = "Suggested points:"
L["INVESTED_POINTS"]        = "Invested points:"
L["PET_TALENTS"]            = "PET TALENTS"
L["EXPORT_TO_TALENTED"]     = "EXPORT TO TALENTED"
L["SUGGESTED_MAP"]          = "SUGGESTED MAP"
L["MY_CONFIGURATION"]       = "MY CONFIGURATION"
L["TALENTED_NOT_ACTIVE"]    = "Addon 'Talented' is not active."

-- ========================
-- Export AI Tab
-- ========================
L["EXPORT_AI_TITLE"]        = "Export Profile to Artificial Intelligence"
L["EXPORT_AI_DESC"]         = "Press Ctrl+C in the text box to copy your complete profile.\nYou can paste this text into ChatGPT, Claude, or Gemini for advice on your gear, rotation, or where to get the best pieces."
L["SELECT_ALL"]             = "Select All"

-- ========================
-- Language Selector
-- ========================
L["LANGUAGE"]               = "Language"
L["LANGUAGE_CHANGE_MSG"]    = "Language changed. Some elements may need a /reload to fully update."
L["OPEN_GUIDE"]             = "Open Guide"
L["OPEN_PJ"]                = "View My PJ"

-- ========================
-- Gems Dictionary (esES -> enUS)
-- For AI Export and analysis on Spanish servers
-- ========================
-- Meta Gems
L["Diamante de asedio de tierra incansable"] = "Relentless Earthsiege Diamond"
L["Diamante de llama celeste caótico"]      = "Chaotic Skyflare Diamond"
L["Diamante de llama celeste de destructor"] = "Destructive Skyflare Diamond"
L["Diamante de asedio de tierra de asalto"]  = "Thundering Earthsiege Diamond"
L["Diamante de asedio de tierra austero"]   = "Austere Earthsiege Diamond"
L["Diamante de llama celeste de ascuas"]    = "Ember Skyflare Diamond"
L["Diamante de llama celeste tonante"]     = "Forlorn Skyflare Diamond"
L["Diamante de asedio de tierra eterno"]    = "Eternal Earthsiege Diamond"

-- Red Gems (Cardinal Ruby)
L["Rubí cárdeno llamativo"]     = "Bold Cardinal Ruby"
L["Rubí cárdeno delicado"]       = "Delicate Cardinal Ruby"
L["Rubí cárdeno rúnico"]        = "Runed Cardinal Ruby"
L["Rubí cárdeno preciso"]       = "Precise Cardinal Ruby"
L["Rubí cárdeno destellante"]   = "Flashing Cardinal Ruby"
L["Rubí cárdeno sutil"]         = "Subtle Cardinal Ruby"
L["Rubí cárdeno fracturado"]    = "Fractured Cardinal Ruby"

-- Yellow Gems (King's Amber)
L["Ámbar del rey liso"]         = "Smooth King's Amber"
L["Ámbar del rey rápido"]       = "Quick King's Amber"
L["Ámbar del rey rígido"]       = "Rigid King's Amber"
L["Ámbar del rey místico"]      = "Mystic King's Amber"
L["Ámbar del rey brillante"]    = "Brilliant King's Amber"

-- Purple Gems (Dreadstone)
L["Piedra de terror soberana"]  = "Sovereign Dreadstone"
L["Piedra de terror purificada"] = "Purified Dreadstone"
L["Piedra de terror velada"]    = "Veiled Dreadstone"
L["Piedra de terror intemporal"] = "Timeless Dreadstone"
L["Piedra de terror de fuerza/aguante"] = "Sovereign Dreadstone"

-- Orange Gems (Ametrine)
L["Ametrino tallado"]           = "Etched Ametrine"
L["Ametrino temerario"]         = "Reckless Ametrine"
L["Ametrino de fuerza/crítico"] = "Inscribed Ametrine"
L["Ametrino inscrito"]          = "Inscribed Ametrine"
L["Ametrino pujante"]           = "Potent Ametrine"
L["Ametrino luciente"]          = "Luminous Ametrine"
L["Ametrino de pericia/golpe"]  = "Accurate Ametrine"

-- Green Gems (Eye of Zul)
L["Ojo de Zul duradero"]        = "Enduring Eye of Zul"
L["Ojo de Zul enérgico"]        = "Energized Eye of Zul"
L["Ojo de Zul de aguante/crítico"] = "Jagged Eye of Zul"

-- Prismatics & Specials
L["Lágrima de pesadilla"]       = "Nightmare Tear"
L["Ojo de dragón llamativo"]    = "Bold Dragon's Eye"
L["Ojo de dragón delicado"]     = "Delicate Dragon's Eye"
L["Ojo de dragón rúnico"]       = "Runed Dragon's Eye"
L["Ojo de dragón fracturado"]   = "Fractured Dragon's Eye"
-- ========================
-- Enchants Dictionary (esES -> enUS)
-- ========================
L["Arcanum de tormentos"]           = "Arcanum of Torments"
L["Inscripción del hacha superior"] = "Greater Inscription of the Axe"
L["Velocidad superior"]             = "Greater Speed"
L["Estadísticas potentes"]          = "Powerful Stats"
L["Asalto superior"]                = "Greater Assault"
L["Triturador"]                     = "Crusher"
L["Armadura de pierna de escama de hielo"] = "Icescale Leg Armor"
L["Hebilla eterna"]                 = "Eternal Belt Buckle"
L["Runa del cruzado caído"]         = "Rune of the Fallen Crusader"
L["Asalto superior"]                = "Greater Assault"

L["+50 PA / +20 Crítico"]           = "+50 AP / +20 Crit"
L["+40 PA / +15 Crítico"]           = "+40 AP / +15 Crit"
L["+23 Celeridad"]                  = "+23 Haste"
L["+10 Estadísticas"]               = "+10 Stats"
L["+50 PA"]                         = "+50 AP"
L["+44 PA"]                         = "+44 AP"
L["+75 PA / +22 Crítico"]           = "+75 AP / +22 Crit"
L["+32 PA"]                         = "+32 AP"
L["+1 Ranura"]                      = "+1 Socket"
L["Proc % Fuerza / Heal"]           = "Proc % Strength / Heal"
L["Mira buscacorazones"]             = "Heartseeker Scope"
L["Agilidad superior y sigilo"]      = "Shadow Armor"
L["Mira de Rango"]                  = "Ranged Scope"
L["+10 Agi / +Sigilo"]               = "+10 Agility / +Stealth"
L["Puntería"]                        = "Marksmanship"
L["Bestias"]                         = "Beast Mastery"
L["Supervivencia"]                   = "Survival"
L["Cazador Punteria (ArPen DPS)"]    = "Marksmanship Hunter (ArPen DPS)"
L["Cazador Supervivencia (PvE)"] = "Survival Hunter (PvE)"
L["Cazador Bestias PVE"]             = "Beast Mastery Hunter (PvE)"
L["+30 Hechizos / +20 Crítico"]      = "+30 Spell Power / +20 Crit"
L["+37 aguante / +20 índice de defensa"] = "+37 Stamina / +20 Defense"
L["+30 SP / +10 MP5"]               = "+30 SP / +10 MP5"
L["+24 Hechizos / +15 Crítico"]      = "+24 Spell Power / +15 Crit"
L["+20 Esquivar / +15 Defensa"]      = "+20 Dodge / +15 Defense"
L["+24 Hechizos / +8 MP5"]          = "+24 Spell Power / +8 MP5"
L["Proc 295 SP"]                    = "Proc 295 SP"
L["+10 Espíritu / -2% Amenaza"]     = "+10 Spirit / -2% Threat"
L["+225 Armadura"]                  = "+225 Armor"
L["+16 Defensa"]                    = "+16 Defense"
L["+15 Espíritu"]                   = "+15 Spirit"
L["+275 Salud"]                     = "+275 Health"
L["+40 Aguante"]                    = "+40 Stamina"
L["+30 Hechizos"]                   = "+30 Spell Power"
L["+12 Crítico"]                    = "+12 Crit"
L["+2% Amenaza / +10 Parada"]       = "+2% Threat / +10 Parry"
L["+28 SP"]                         = "+28 SP"
L["+20 Agilidad"]                   = "+20 Agility"
L["+885 Armadura"]                  = "+885 Armor"
L["+340 Celeridad (Uso)"]           = "+340 Haste (Use)"
L["+15 Pericia"]                    = "+15 Expertise"

-- UI Guide Elements
L["OPEN_GUIDE"]                     = "Open Guide"
L["PANEL_PJ"]                       = "Character Panel"
L["RECOMMENDED_GEMS"]               = "RECOMMENDED GEMS"
L["RECOMMENDED_GLYPHS"]             = "RECOMMENDED GLYPHS"
L["STATS_AND_CAPS"]                 = "STATS AND CAPS"
L["GUIDE_TITLE_FMT"]                = "%s - %s Guide"
L["MAJOR"]                          = "Major"
L["MINOR"]                          = "Minor"
L["ENHANCEMENTS"]                   = "Enhancements"
L["APPLY_TO_BIS"]                   = "Apply to bis items (gems)"

-- DB Notes Mapping
L["Hard Cap (1400 pasivo con T10+ICC25). Cambiar gemas al alcanzar ~1050 pasivo."] = "Hard Cap (1400 passive with T10+ICC25). Change gems when reaching ~1050 passive."
L["Soft Cap (Inicio / Medio equipo)"] = "Soft Cap (Early / Mid gear)"
L["11% (289 rating) por talentos de Hit"] = "11% (289 rating) from Hit talents"
L["Soft ~900 (para rotación fluida) / Hard 1200 (sin sobrepasar GCD)"] = "Soft ~900 (smooth rotation) / Hard 1200 (don't exceed GCD)"
L["9% (Con Draenei)"] = "9% (With Draenei)"
L["10% (Sin Draenei)"] = "10% (Without Draenei)"
L["57/3/11 - Mago Arcano DPS"] = "57/3/11 - Arcane Mage DPS"

-- StatTrans keys (Static)
L["STAT_HIT"] = "Hit Rating"
L["STAT_HIT_SPELL"] = "Spell Hit"
L["STAT_EXPERTISE"] = "Expertise"
L["STAT_ARP"] = "Armor Pen."
L["STAT_HASTE"] = "Haste"
L["STAT_CRIT"] = "Critical"
L["STAT_SP"] = "Spell Power"
L["STAT_STA"] = "Stamina"
L["STAT_AGI"] = "Agility"
L["STAT_STR"] = "Strength"
L["STAT_INT"] = "Intellect"
L["STAT_SPIRIT"] = "Spirit"
L["STAT_DEF"] = "Defense"
L["STAT_ARMOR"] = "Armor"
L["STAT_DODGE"] = "Dodge"
L["STAT_PARRY"] = "Parry"
L["STAT_AP"] = "Attack Power"
L["STAT_RAP"] = "Ranged AP"

-- StatTrans keys (Dynamic fallback for esMX load time)
L["Poder de Ataque"] = "Attack Power"
L["Fuerza"] = "Strength"
L["Agilidad"] = "Agility"
L["Aguante"] = "Stamina"
L["Intelecto"] = "Intellect"
L["Espíritu"] = "Spirit"
L["Crítico"] = "Critical"
L["Poder de Hechizos"] = "Spell Power"
L["Celeridad"] = "Haste"
L["Armadura"] = "Armor"
L["Esquiva"] = "Dodge"
L["Parada"] = "Parry"
L["Poder de Ataque a Distancia"] = "Ranged AP"
L["Pen. Armadura"] = "Armor Pen."
L["Índice de Golpe"] = "Hit Rating"
L["Golpe (Hechizos)"] = "Spell Hit"
L["Pericia"] = "Expertise"
L["Defensa"] = "Defense"
L["RECOMENDADO"] = "RECOMMENDED"
L["+81 Valor de Bloqueo"]           = "+81 Block Value"
L["+55 Aguante / +22 Agilidad"]     = "+55 Stamina / +22 Agility"
L["+50 Hechizos / +20 Espíritu"]     = "+50 Spell Power / +20 Spirit"
L["+50 SP / +30 Aguante"]           = "+50 SP / +30 Stamina"
L["+12 Crit / +12 Hit"]             = "+12 Crit / +12 Hit"
L["Velocidad / +15 Aguante"]        = "Speed / +15 Stamina"
L["+35 Spell Pen"]                  = "+35 Spell Pen"
L["+18 Espíritu"]                    = "+18 Spirit"
L["+5 Resistencias"]                = "+5 Resistances"
L["+63 SP"]                         = "+63 SP"
L["+81 SP (Baston)"]                = "+81 SP (Staff)"
L["+110 PA (2H)"]                   = "+110 AP (2H)"
L["Proc Agi/Vel"]                   = "Proc Agi/Haste"
L["400 AP (Proc)"]                   = "400 AP (Proc)"
L["Proc Parada"]                    = "Proc Parry"
L["+28 Golpe / Desarme"]            = "+28 Hit / Disarm"
L["+7 SP (Escudo)"]                 = "+7 SP (Shield)"
L["+20 Defensa"]                    = "+20 Defense"
L["+25 intelecto"]                  = "+25 Intellect"
L["+40 Poder de Ataque"]            = "+40 Attack Power"
L["+23 Poder con hechizos"]         = "+23 Spell Power"

-- ============================================================
-- Data note translations (grey subtext lines in Caps/Stats tab)
-- ============================================================

-- DeathKnight Frost priorities
L["Hard Cap (1400 pasivo con T10+ICC25). Cambiar gemas al alcanzar ~1050 pasivo."] = "Hard Cap (1400 passive w/T10+ICC25). Swap gems at ~1050 passive."
L["Soft Cap (Inicio / Medio equipo)"] = "Soft Cap (Early / Mid gear)"

-- Warrior priorities
L["Soft Cap 722 (con Escorpión) / Hard Cap 1400 (con Testamento/Escama)"] = "Soft Cap 722 (with Scorpion) / Hard Cap 1400 (with Testament/Scale)"
L["Soft Cap 722 (con Escorpión) / Hard Cap 1400 pasivo"] = "Soft Cap 722 (with Scorpion) / Hard Cap 1400 passive"

-- Rogue priorities
L["Soft Cap 722 (con Escorpión) / Hard Cap 1400 Pasivo"] = "Soft Cap 722 (with Scorpion) / Hard Cap 1400 Passive"

-- Hunter priorities
L["Hard Cap (1400). Cambiar gemas al alcanzar ~800-850 ArPen pasivo con arco ICC."] = "Hard Cap (1400). Swap gems at ~800-850 passive ArPen with ICC bow."
L["Soft Cap (Inicio: Full Agilidad)"] = "Soft Cap (Early: Full Agility)"

-- Druid priorities
L["Hard Cap (1400). Cambiar gemas al alcanzar ~750-800 ArPen pasivo con ICC."] = "Hard Cap (1400). Swap gems at ~750-800 passive ArPen with ICC."

-- Warlock priorities
L["Soft Cap (1100)"] = "Soft Cap (1100)"

-- Expertie notes
L["Hard Cap (Avoid Dodges)"] = "Hard Cap (Avoid Dodges)"

-- Gem progression notes
L["PROGRESIÓN: Inicio Full Fuerza (+20 STR). Punto de Quiebre: al alcanzar ~1050 ArPen pasivo (T10+ICC25), cambiar a Full ArPen (+20 ArPen) hasta Hard Cap 1400."] = "PROGRESSION: Start Full Strength (+20 STR). Breakpoint: at ~1050 passive ArPen (T10+ICC25), swap to Full ArPen (+20 ArPen) up to Hard Cap 1400."
L["PROGRESIÓN: Inicio Full Agilidad (+20 Agi). Punto de Quiebre: al alcanzar ~750-800 ArPen pasivo (T10+ICC), cambiar a Full ArPen (+20 ArPen) hasta Hard Cap 1400."] = "PROGRESSION: Start Full Agility (+20 Agi). Breakpoint: at ~750-800 passive ArPen (T10+ICC), swap to Full ArPen (+20 ArPen) up to Hard Cap 1400."
L["PROGRESIÓN: Inicio Full Agilidad (+20 Agi). Punto de Quiebre: al alcanzar ~800-850 ArPen pasivo (T10+ICC+Arco ICC), cambiar a Full ArPen (+20 ArPen) hasta Hard Cap 1400."] = "PROGRESSION: Start Full Agility (+20 Agi). Breakpoint: at ~800-850 passive ArPen (T10+ICC+ICC Bow), swap to Full ArPen (+20 ArPen) up to Hard Cap 1400."
L["ARPEN DESDE DÍA 1. Buscar Soft Cap 722 usando abalorio Escorpión (Forja H). Al conseguir Testamento/Escama, tirar Escorpión y buscar Hard Cap 1400 fijo."] = "ARPEN FROM DAY 1. Aim for Soft Cap 722 with Scorpion trinket (Forge H). Once you get Testament/Scale, drop Scorpion and push for fixed Hard Cap 1400."
L["ARPEN DESDE DÍA 1. Soft Cap 722 con Escorpión, luego Hard Cap 1400 pasivo con abalorios de ICC25 (Testamento/Escama)."] = "ARPEN FROM DAY 1. Soft Cap 722 with Scorpion, then Hard Cap 1400 passive with ICC25 trinkets (Testament/Scale)."
L["ARPEN DESDE DÍA 1. Soft Cap 722 con Escorpión o Estandarte. Hard Cap 1400 pasivo. Celeridad en gemas amarillas/híbridas al llegar al Hard Cap."] = "ARPEN FROM DAY 1. Soft Cap 722 with Scorpion or Banner. Hard Cap 1400 passive. Haste in yellow/hybrid gems once at Hard Cap."

-- Other notes from enUS original
L["Soft Cap (Inicio / Medio equipo)"] = "Soft Cap (Early / Mid gear)"
