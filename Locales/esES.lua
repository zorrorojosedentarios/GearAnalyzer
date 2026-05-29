-- ============================================================
-- GearAnalyzer: Spanish (esES / esMX) Locale
-- Terminología oficial WoW WotLK (Wrath of the Lich King)
-- Always stored globally for language selector support
-- ============================================================
GearAnalyzer_Locale_esES = {}
local L = GearAnalyzer_Locale_esES

-- Also register with AceLocale if game client matches
local aceL = LibStub("AceLocale-3.0"):NewLocale("GearAnalyzer", "esES")
if not aceL then
    aceL = LibStub("AceLocale-3.0"):NewLocale("GearAnalyzer", "esMX")
end

-- Metatable to also write to AceLocale if available
setmetatable(L, {
    __newindex = function(t, k, v)
        rawset(t, k, v)
        if aceL then aceL[k] = (v == true and k or v) end
    end
})

-- ========================
-- Pestañas UI
-- ========================
L["TAB_EQUIPMENT"]          = "Equipo"
L["TAB_GEMS"]               = "Gemas"
L["TAB_ENCHANTS"]           = "Encantamientos"
L["TAB_GLYPHS"]             = "Glifos"
L["TAB_TALENTS"]            = "Talentos"
L["TAB_BIS"]                = "BiS / Tops"
L["TAB_CAPS"]               = "Caps / Stats"
L["TAB_GENERAL"]            = "Gemas/Glifos/Caps"
L["TAB_EXPORT"]             = "Exportar IA"
L["TAB_INFO"]               = "Información"
L["TAB_CONFIG"]             = "Configuración"

-- ========================
-- Pestaña Configuración
-- ========================
L["INTERFACE_SETTINGS"]     = "AJUSTES DE INTERFAZ"
L["DEV_SETTINGS_TITLE"]     = "AJUSTES DE INTERFAZ Y DESARROLLADOR"
L["DEV_MODE"]               = "Modo Dev"
L["DEV_MODE_TOGGLED"]       = "Modo Desarrollador %s"
L["SHOW_ERRORS"]            = "Ver Errores"
L["HIDE_ERRORS"]            = "Ocultar Errores"
L["SCAN_OPEN_PROF"]         = "Escanear Prof. Abierta"
L["DEBUG_GEMS"]             = "Debug Gemas"
L["SHOW_MINIMAP_ICON"]      = "Mostrar Icono en Minimapa"
L["FONT_SIZE"]              = "Tamaño de Fuente (Textos)"
L["ICON_SIZE"]              = "Tamaño de Iconos"
L["RESET_VISUAL"]           = "Restablecer Visual"
L["VISUAL_RESET_MSG"]       = "Ajustes visuales restaurados (Fuente: 12, Iconos: 32)."
L["ON"]                     = "ACTIVADO"
L["OFF"]                    = "DESACTIVADO"

-- ========================
-- Pestaña Información
-- ========================
L["INFO_TITLE"]             = "Guía de Funcionamiento - GearAnalyzer %s"
L["INFO_INTRO"]             = "¡Hola %s!\n\nBienvenido a %s. Aquí tienes cómo aprovechar el addon:\n\n"
L["INFO_CREDITS"]           = "Addon desarrollado por zorrorojo Guild <Sedentarios> para el Servidor NaerZone"
L["SECTION_1_TITLE"]        = "A. SELECTORES (VENTANA DE GUÍA)"
L["SECTION_1_BODY"]         = "Al pulsar el botón |cffffd100'Abrir Guía'|r, verás dos menús en la esquina superior derecha:\n• |cffffd100Clase:|r Permite analizar cualquier clase del juego.\n• |cffffd100Especialización:|r Selecciona la rama de talentos que deseas consultar.\n• |cff00ff00Nota:|r En la ventana de tu personaje (PJ), esta selección es automática."
L["SECTION_2_TITLE"]        = "1. Pestaña: EQUIPO"
L["SECTION_2_BODY"]         = "Análisis en tiempo real de tu equipo equipado.\n• Compara tus piezas con la build BiS actual.\n• Indica si faltan |cffff0000[G]|r gemas o |cffff0000[E]|r encantamientos.\n• Muestra el 'Siguiente Mejor' ítem que podrías conseguir.\n• |cff00ff00Equipar:|r Botón inteligente para equipar lo mejor que tengas en bolsas."
L["SECTION_3_TITLE"]        = "2, 3 y 4. GEMAS / ENCANTOS / GLIFOS"
L["SECTION_3_BODY"]         = "Bibliotecas de referencia universales.\n• |cffffd100Gemas:|r Muestra los cortes óptimos según prioridades de estadísticas.\n• |cffffd100Encantos:|r Clasificados por ranura, priorizando los BiS.\n• |cffffd100Glifos:|r Sugerencias para maximizar el rendimiento de la especialización."
L["SECTION_4_TITLE"]        = "5. Pestaña: TALENTOS"
L["SECTION_4_BODY"]         = "Visualizador de builds optimizadas.\n• |cff00ff00Mapa BiS:|r Muestra los árboles de talentos completos.\n• |cffffd100Exportar:|r Compatible con el addon 'Talented' para copiar la build.\n• Permite ver talentos de cualquier clase usando el selector superior."
L["SECTION_5_TITLE"]        = "6. Pestaña: CAPS"
L["SECTION_5_BODY"]         = "Control de estadísticas críticas.\n• Calcula automáticamente cuánto te falta para los |cffffd100Caps suaves/duros|r.\n• Se adapta dinámicamente según los talentos y clase que estés analizando."
L["SECTION_6_TITLE"]        = "7. Pestaña: BIS / TOPS"
L["SECTION_6_BODY"]         = "Base de datos de botín por fases (Pre-raid, T9 hasta ICC/RS).\n• |cffffff00Alt + Clic:|r Fija un objeto como |cff00ff00OBJETIVO|r (fácil de seguir en el tooltip).\n• |cffffd100Filtros:|r Selecciona la fase de contenido para ver el top de piezas."
L["SECTION_7_TITLE"]        = "8. Pestaña: EXPORTAR IA"
L["SECTION_7_BODY"]         = "Integración con Inteligencia Artificial.\n• Genera un informe detallado de tu personaje en texto plano.\n• Cópialo y pégalo en |cffffd100ChatGPT, Claude o Gemini|r para recibir consejos avanzados."
L["SECTION_8_TITLE"]        = "9. VENTANA DE GUÍA"
L["SECTION_8_BODY"]         = "Accede mediante el botón |cffffd100'Abrir Guía'|r o el comando |cffffd100/gag|r.\n• Permite explorar recomendaciones de |cff00ff00CUALQUIER|r clase y especialización.\n• Ideal para armar alters o consultar datos sin cambiar de personaje."
L["SECTION_9_TITLE"]        = "10. Pestaña: CONFIGURACIÓN"
L["SECTION_9_BODY"]         = "Personaliza la experiencia del addon.\n• |cffffd100Interfaz:|r Cambia el tamaño de fuente e iconos.\n• |cffffd100Minimap:|r Oculta o muestra el botón de acceso rápido."
L["SECTION_10_TITLE"]       = "11. DETECCIÓN INTELIGENTE"
L["SECTION_10_BODY"]        = "El addon detecta automáticamente tu especialización analizando:\n• Tus puntos de talento invertidos.\n• Tus estadísticas actuales y equipo (ej. diferencia un DK Tanque de un DPS)."
L["SECTION_11_TITLE"]       = "12. GEMAS DINÁMICAS (PUNTO DE QUIEBRE)"
L["SECTION_11_BODY"]        = "Algunas clases cambian su gemado óptimo cuando acumulan suficiente Penetración de Armadura (ArPen) pasiva en el gear.\n\n|cffffd100¿Por qué no al cap de 1400?|r\nEl Punto de Quiebre es el momento donde poniendo gemas de ArPen ya alcanzas el hard cap de 1400. Si esperaras al cap, ya no necesitarías gemas.\n\n|cffffd100Umbrales por clase:|r\n• |cffff8000DK Escarcha:|r < 1000 ArPen → Full Fuerza | ≥ 1000 ArPen → Full ArPen\n• |cff00cc00Druida Feral (Gato):|r < 700 ArPen → Full Agilidad | ≥ 700 ArPen → Full ArPen\n• |cff00aaff Cazador Puntería:|r < 800 ArPen → Full Agilidad | ≥ 800 ArPen → Full ArPen\n\n|cff00ff00¿Cómo funciona?|r\nEl addon lee tu ArPen pasivo actual (gear + encantamientos) al abrir la pestaña Gemas. Si cruzas el umbral, el texto cambia a |cffffd100FASE FINAL|r y las gemas recomendadas se actualizan automáticamente sin configuración manual."

-- ========================
-- Dynamic Gems Notes
-- ========================
L["DYNAMIC_GEM_NOTE_DK_FROST_FINAL"]   = "FASE FINAL (Full ArPen): Has superado el Punto de Quiebre de ArP (~1050). Se recomienda engemar Full ArPen (+20 ArPen) hasta el Hard Cap de 1400."
L["DYNAMIC_GEM_NOTE_DK_FROST_INITIAL"] = "FASE INICIAL (Full Fuerza): Aún no alcanzas el Punto de Quiebre (~1050 ArP pasivo). Se recomienda engemar Full Fuerza (+20 Fuerza)."
L["DYNAMIC_GEM_NOTE_DRUID_CAT_FINAL"]   = "FASE FINAL (Full ArPen): Has superado el Punto de Quiebre de ArP (~750). Se recomienda engemar Full ArPen (+20 ArPen) hasta el Hard Cap de 1400."
L["DYNAMIC_GEM_NOTE_DRUID_CAT_INITIAL"] = "FASE INICIAL (Full Agilidad): Aún no alcanzas el Punto de Quiebre (~750 ArP pasivo). Se recomienda engemar Full Agilidad (+20 Agi)."
L["DYNAMIC_GEM_NOTE_HUNTER_MM_FINAL"]   = "FASE FINAL (Full ArPen): Has superado el Punto de Quiebre de ArP (~800). Se recomienda engemar Full ArPen (+20 ArPen) hasta el Hard Cap de 1400."
L["DYNAMIC_GEM_NOTE_HUNTER_MM_INITIAL"] = "FASE INICIAL (Full Agilidad): Aún no alcanzas el Punto de Quiebre (~800 ArP pasivo). Se recomienda engemar Full Agilidad (+20 Agi)."


-- ========================
-- Interfaz General
-- ========================
L["CLOSE"]                  = "Cerrar"
L["LOADING"]                = "Cargando..."
L["RELOAD_UI"]              = "Recargar UI"
L["RESET_ALL"]              = "Borrar Todo"
L["EXPORT_CHANGES"]         = "Exportar"
L["SCAN_JEWELRY"]           = "Escanear Joyería"
L["SCAN_PROFESSION"]        = "Escanear Profesión"

-- ========================
-- Minimapa / Mensajes
-- ========================
L["VERSION_TOOLTIP"]        = "Versión: %s"
L["LEFT_CLICK_OPEN"]        = "Clic Izquierdo: Abrir/Cerrar Panel"
L["SPEC_DETECTED"]          = "Especialización detectada: %s"
L["DB_POPULATED"]           = "Base de datos maestra poblada con %d registros."

-- ========================
-- Selectores Clase y Spec
-- ========================
L["CLASS"]                  = "Clase:"
L["SPEC"]                   = "Especialización:"
L["AUTOMATIC"]              = "Automático"
L["DEATHKNIGHT"]            = "Caballero de la Muerte"
L["DRUID"]                  = "Druida"
L["HUNTER"]                 = "Cazador"
L["MAGE"]                   = "Mago"
L["PALADIN"]                = "Paladín"
L["PRIEST"]                 = "Sacerdote"
L["ROGUE"]                  = "Pícaro"
L["SHAMAN"]                 = "Chamán"
L["WARLOCK"]                = "Brujo"
L["WARRIOR"]                = "Guerrero"

-- Nombres de especialización (claves = nombres internos en inglés)
L["None"]                   = "Ninguna"
L["Feral"]                  = "Feral"
L["Assassination"]          = "Asesinato"
L["Combat"]                 = "Combate"
L["Subtlety"]               = "Sutileza"
L["Blood"]                  = "Sangre"
L["Frost"]                  = "Escarcha"
L["Unholy"]                 = "Profano"
L["Arms"]                   = "Armas"
L["Fury"]                   = "Furia"
L["Protection"]             = "Protección"
L["Holy"]                   = "Sagrado"
L["Retribution"]            = "Reprensión"
L["Discipline"]             = "Disciplina"
L["Shadow"]                 = "Sombras"
L["Elemental"]              = "Elemental"
L["Enhancement"]            = "Mejora"
L["Restoration"]            = "Restauración"
L["Affliction"]             = "Aflicción"
L["Demonology"]             = "Demonología"
L["Destruction"]            = "Destrucción"
L["Arcane"]                 = "Arcano"
L["Fire"]                   = "Fuego"
L["Fire FFB"]               = "Pirofrío (FFB)"
L["Frostfire"]              = "Pirofrío"
L["Balance"]                = "Equilibrio"
L["Feral Cat"]              = "Feral (Gato)"
L["Feral Bear"]             = "Feral (Oso)"
L["Beast Mastery"]          = "Maestría de Bestias"
L["Marksmanship"]           = "Puntería"
L["Survival"]               = "Supervivencia"

-- Nombres internos españoles (usados por GetCurrentSpec/GetClassSpecs)
L["Ninguna"]                = "Ninguna"
L["Equilibrio"]             = "Equilibrio"
L["Feral Gato"]             = "Feral (Gato)"
L["Feral Oso"]              = "Feral (Oso)"
L["Restauracion"]           = "Restauración"
L["Sangre"]                 = "Sangre"
L["Escarcha"]               = "Escarcha"
L["Profano"]                = "Profano"
L["Sagrado"]                = "Sagrado"
L["Proteccion"]             = "Protección"
L["Reprension"]             = "Reprensión"
L["Armas"]                  = "Armas"
L["Furia"]                  = "Furia"
L["Arcano"]                 = "Arcano"
L["Fuego"]                  = "Fuego"
L["Pirofrio"]               = "Pirofrío"
L["Disciplina"]             = "Disciplina"
L["Sombras"]                = "Sombras"
L["Mejora"]                 = "Mejora"
L["Afliccion"]              = "Aflicción"
L["Demonologia"]            = "Demonología"
L["Demonologia (Diablillo)"] = "Demonología (Diablillo)"
L["Demonologia (Guardia Vil)"] = "Demonología (Guardia Vil)"
L["Destruccion"]            = "Destrucción"
L["Asesinato"]              = "Asesinato"
L["Combate"]                = "Combate"
L["Bestias"]                = "Maestría de Bestias"
L["Punteria"]               = "Puntería"
L["Supervivencia"]          = "Supervivencia"
L["Sangre (Tanque)"]        = "Sangre (Tanque)"
L["Escarcha (DPS)"]         = "Escarcha (DPS)"
L["Profano (DPS)"]          = "Profano (DPS)"
L["Escarcha (Tanque)"]      = "Escarcha (Tanque)"
L["Proteccion (Paladin)"]   = "Protección (Paladín)"
L["Proteccion (Guerrero)"]  = "Protección (Guerrero)"

-- ========================
-- Tipos de Gemas (Pestaña Gemas)
-- ========================
L["GEM_META"]               = "Meta"
L["GEM_RED"]                = "Roja"
L["GEM_YELLOW"]             = "Amarilla"
L["GEM_BLUE"]               = "Azul"
L["PROFESSION_ONLY"]        = "Profesión específica"
L["JEWELRY_BIS"]            = "(Joyero BiS: Ojo de dragón)"
L["LACKING"]                = "Faltan %s"
L["LACKING_HIT"]            = "Falta Índice de Golpe"
L["IGNORE_COLOR"]           = "(IGNORAR COLOR)"
L["NO_GEM_FOUND"]           = "Gema no encontrada"

-- ========================
-- Nombres de Estadísticas
-- ========================
L["STAT_HIT"]               = "Índice de Golpe"
L["STAT_HIT_SPELL"]         = "Golpe (Hechizos)"
L["STAT_EXPERTISE"]         = "Pericia"
L["STAT_ARP"]               = "Pen. de Armadura"
L["STAT_HASTE"]             = "Celeridad"
L["STAT_CRIT"]              = "Crítico"
L["STAT_SP"]                = "Poder de Hechizos"
L["STAT_STA"]               = "Aguante"
L["STAT_AGI"]               = "Agilidad"
L["STAT_STR"]               = "Fuerza"
L["STAT_INT"]               = "Intelecto"
L["STAT_SPIRIT"]            = "Espíritu"
L["STAT_DEF"]               = "Defensa"
L["STAT_ARMOR"]             = "Armadura"
L["STAT_DODGE"]             = "Esquiva"
L["STAT_PARRY"]             = "Parada"
L["STAT_AP"]                = "Poder de Ataque"
L["STAT_RAP"]               = "P. Ataque a Distancia"

-- ========================
-- Pestaña Caps / Stats
-- ========================
L["STATS_AND_CAPS"]         = "ESTADÍSTICAS Y CAPS"
L["CRITICAL_CAPS"]          = "CAPS CRÍTICOS"
L["OPTIMIZATION_CAPS"]      = "CAPS DE OPTIMIZACIÓN"
L["MAIN_STATS"]             = "ESTADÍSTICAS PRINCIPALES"
L["GENERAL_SUMMARY"]        = "RESUMEN GENERAL"
L["EXCESS_TAG"]             = "[EXCESO]"
L["CAPPED_OK"]              = "[OK]"
L["EXCESS"]                 = "EXCESO"
L["MISSING_LABEL"]          = "FALTAN"
L["STAT_ERROR_MSG"]         = "|cffff0000Error:|r No hay datos para |cffffffff%s / %s|r"
L["HIT_CAP"]                = "Cap de Golpe"
L["EXPERTISE_CAP"]          = "Cap de Pericia"
L["EXP_SOFT_CAP"]           = " (Soft Cap)"
L["EXP_HARD_CAP"]           = " (Hard Cap)"
L["EXP_NOTE_TANK"]          = "Evitar Esquivas (Dodge)"
L["EXP_NOTE_DPS"]           = "Hard Cap (Evitar Esquivas)"
L["EXP_SOFT_HARD_FMT"]      = "Soft %d / Hard %d"
L["BADGE_INCOMPLETE"]       = "[INCOMPLETO]"
L["BADGE_EXCESS"]           = "[EXCESO]"
L["BADGE_CAP_OK"]           = "[CAP OK]"
L["BADGE_SOFT_OK"]          = "[SOFT OK]"
L["BADGE_HARD_OK"]          = "[HARD OK]"
L["HASTE_GOAL"]             = "Objetivo de Celeridad"
L["ARMOR_PEN_CAP"]          = "Cap de Pen. de Armadura"
L["SPELL_PEN_CAP"]          = "Cap de Pen. de Hechizos"
L["STAT_PRIORITY"]          = "Prioridad de Estadísticas"
L["PRIORITY_ORDER"]         = "Orden de Prioridad"
L["NOTES"]                  = "Notas"
L["SECONDARY_CAPS"]         = "CAPS SECUNDARIOS"

-- ========================
-- Nombres de Ranuras
-- ========================
L["SLOT_HEAD"]              = "Cabeza"
L["SLOT_NECK"]              = "Cuello"
L["SLOT_SHOULDERS"]         = "Hombros"
L["SLOT_BACK"]              = "Espalda"
L["SLOT_CHEST"]             = "Pecho"
L["SLOT_WRISTS"]            = "Muñecas"
L["SLOT_HANDS"]             = "Manos"
L["SLOT_WAIST"]             = "Cintura"
L["SLOT_LEGS"]              = "Piernas"
L["SLOT_FEET"]              = "Pies"
L["SLOT_RING"]              = "Anillo"
L["SLOT_TRINKET"]           = "Abalorio"
L["SLOT_WEAPON"]            = "Arma"
L["SLOT_OFFHAND"]           = "Mano Secundaria"
L["SLOT_RELIC"]             = "Reliquia"
L["SLOT_RANGED"]            = "A Distancia"

-- ========================
-- Pestaña BiS / Tops
-- ========================
L["PHASE"]                  = "Fase"
L["INTERNAL_GUIDES"]        = "Interno (Guías v3.5)"
L["INTERNAL"]               = "Interno"
L["INTERNAL_DB"]            = "Base de Datos Interna"
L["FINAL_BIS_GUIDE"]        = "Guía BiS Final"
L["TOKEN_MISSION"]          = "Token / Misión"
L["PROFESSION_VENDOR"]      = "Profesión / Vendedor"
L["GUIDE"]                  = "GUÍA"
L["RESET"]                  = "RESTABLECER"
L["BIS_RESET_MSG"]          = "Selección BiS restablecida al Top 1."
L["RESTORE_BIS"]            = "Restaurar BiS"
L["RESTORE_BIS_DESC"]       = "Borra tus objetivos fijados manualmente\ny vuelve a los Top 1 por defecto."
L["SELECTED_TARGET"]        = "OBJETIVO SELECCIONADO (JEFE / DROP)"
L["USAGE_INSTRUCTIONS"]     = "INSTRUCCIONES DE USO"
L["ALT_CLICK"]              = "Alt + Clic"
L["ALT_CLICK_DESC"]         = "Fija el objeto como tu OBJETIVO manual."
L["GREEN_BORDER"]           = "Borde Verde"
L["GREEN_BORDER_DESC"]      = "Es tu meta fijada. Borde Blanco: Es el mejor objeto (Top 1)."
L["SAVE_BETWEEN_SESSIONS"]  = "Los objetivos se guardan permanentemente entre sesiones."
L["SOURCE"]                 = "Origen"
L["SOURCE_COLON"]           = "Origen:"
L["RANKING"]                = "Ranking"
L["ALREADY_HAVE_ITEM"]      = "¡Ya tienes este objeto!"
L["TARGET_SAVED_MSG"]       = "Objetivo GUARDADO para %s: %s"
L["GUIDE_RECOMMENDATION"]   = "RECOMENDACIÓN DE LA GUÍA"
L["ABSOLUTE_BIS"]           = "BiS Absoluto / Manual"
L["CURRENT_TARGET"]         = "OBJETIVO ACTUAL"
L["CHOSEN_VIA_ALT_CLICK"]   = "Elegido mediante Alt+Clic"

-- ========================
-- Pestaña Equipo
-- ========================
L["ANALYSIS"]               = "ANÁLISIS"
L["NEXT_UPGRADE"]           = "SIG. MEJORA"
L["STATUS"]                 = "ESTADO"
L["NO_DATA"]                = "Sin Datos"
L["STATUS_BIS"]             = "BiS Final"
L["STATUS_ALMOST_BIS"]      = "Casi BiS"
L["STATUS_INCORRECT"]       = "No Óptimo"
L["STATUS_UPGRADABLE"]      = "Mejorable"
L["STATUS_LOW_LVL"]         = "iNivel Bajo"
L["EQUIP"]                  = "EQUIPAR"
L["BANK"]                   = "BANCO"
L["EQUIPPING_MSG"]          = "Equipando %s en ranura %s"
L["EQUIPPING_SIMPLE_MSG"]   = "Equipando %s"
L["IN_BAGS"]                = "(En tus bolsas)"
L["IN_BANK"]                = "(En el BANCO)"
L["LOCATION"]               = "Ubicación"
L["BANK_WARNING"]           = "Debes sacarlo del banco para poder equiparlo."
L["EQUIP_INSTRUCTIONS"]     = "Haz clic en EQUIPAR para usarlo."
L["EMPTY"]                  = "Vacío"
L["NEXT_BIG_UPGRADE"]       = "Siguiente gran mejora para esta ranura"
L["ANALYSIS_LEGEND"]        = "LEYENDA DE ANÁLISIS"
L["LEGEND_TEXT"]            = "|cff00ff00[G]|r Gemas OK    |cffffff00[G]|r Gemas no óptimas    |cffff0000[G]|r Faltan gemas\n" ..
        "|cff00ff00[E]|r Encantado    |cffffa500[E]|r Profesión    |cffff0000[E]|r Sin encantar\n" ..
        "|cff00ff00BiS|r Perfecto    |cff00ccffCasi BiS|r Top 6    |cffffff00Mejorable|r Correcto    |cffffa500Bajo Lvl|r Desfasado\n" ..
        "|cffaaaaaaFalta Data|r: Objeto no encontrado en la base de datos BiS para tu clase/especialización."
L["CAPS_LEGEND"]            = "GUÍA DE COLORES DE BARRAS DE PROGRESO"
L["CAPS_LEGEND_TEXT"]       = "• |cffffd100Dorado / Ámbar|r: Incompleto. Aún no has alcanzado el cap mínimo o soft cap.\n• |cff33d1ffCeleste / Azul|r: Soft Cap OK. Has alcanzado el cap suave (buen estado intermedio).\n• |cff44ff44Verde Esmeralda|r: Hard Cap OK. Has alcanzado el cap final o absoluto.\n• |cffff9900Naranja Vibrante|r: Exceso. Te has pasado considerablemente del cap máximo (ineficiente)."

L["ENCHANT_STATUS_TITLE"]   = "Estado del Encantamiento"
L["GEMS_OK"]                = "Gemas OK"
L["GEMS_TO_CHANGE"]         = "Gemas a cambiar"
L["MISSING_TAG"]            = "FALTAN"
L["WORTH_IT"]               = "VALE LA PENA"
L["IGNORE"]                 = "IGNORAR"
L["BONUS"]                  = "Bono"
L["SUGGESTED"]              = "Sugerida"
L["NOTE"]                   = "Nota"
L["NIGHTMARE_TEAR_RECOMMENDATION"] = "Se recomienda la Lágrima de Pesadilla aquí para activar la Meta."

-- ========================
-- Pestaña Gemas
-- ========================
L["RECOMMENDED_GEMS"]       = "Gemas Recomendadas"
L["GEM_PRIORITY_HINT"]      = "Prioriza las gemas que te ayuden a alcanzar los Caps de estadísticas primero."
L["GEM_ANALYSIS_TITLE"]     = "Análisis de Gemas y Ranuras"
L["GUIDE_LABEL"]            = "Guía:"
L["PRIORITY_LABEL"]         = "Prioridad:"
L["BAGS"]                   = "Bolsas"
L["CAPS_STATUS"]            = "Estado de Caps"
L["MISSING_GEMS_TITLE"]     = "Gemas faltantes en el equipo:"
L["MISSING_GEMS_COUNT"]     = "Faltan %d gemas (Huecos vacíos):"
L["CHANGE_GEMS_COUNT"]      = "Debes cambiar %d gemas:"
L["TOTAL_TO_SHOP"]          = "Total a comprar/conseguir:"
L["YOUR_EQUIPPED_GEMS"]     = "Tus Gemas Equipadas:"
L["NO_GEMS_EQUIPPED"]       = "No tienes gemas equipadas."
L["ALL_GEMS_CORRECT"]       = "¡Todas las gemas son correctas en tu equipo actual!"
L["META"]                   = "Meta"
L["RED"]                    = "Roja"
L["YELLOW"]                 = "Amarilla"
L["BLUE"]                   = "Azul"
L["JEWELRY"]                = "Joyería"
L["USE"]                    = "Usar"

-- ========================
-- Pestaña Encantamientos
-- ========================
L["ENCHANT_GUIDE"]          = "Guía de Encantamientos"
L["NO_ENCHANT_GUIDE_FOUND"] = "No hay guías de encantamiento registradas para:"
L["ENCHANT_LEGEND_TEXT"]    = "|cff00ff00(Palomita Verde)|r: Encantamiento correcto\n" ..
            "|cffffa500(Palomita Naranja)|r: Beneficio de profesión\n" ..
            "|cffff0000(Cruz Roja)|r: Falta encantamiento o es incorrecto"

-- ========================
-- Pestaña Glifos
-- ========================
L["GLYPH_MANAGEMENT"]       = "Gestión de Glifos"
L["RECOMMENDED_GUIDE"]      = "RECOMENDADOS (GUÍA)"
L["CURRENTLY_EQUIPPED"]     = "EQUIPADOS ACTUALMENTE"
L["MAJOR_GLYPHS"]           = "GLIFOS MAYORES"
L["MINOR_GLYPHS"]           = "GLIFOS MENORES"
L["MAJOR"]                  = "Mayor"
L["MINOR"]                  = "Menor"
L["GLYPH_OF"]               = "Glifo de "
L["GLYPH_OF_2"]             = "Glifo: "

-- ========================
-- Pestaña Talentos
-- ========================
L["VIEW_MY_POINTS"]         = "VER: MIS PUNTOS"
L["VIEW_SUGGESTED"]         = "VER: SUGERIDOS"
L["PET"]                    = "Mascota"
L["TREE"]                   = "Árbol"
L["SUGGESTED_POINTS"]       = "Puntos sugeridos:"
L["INVESTED_POINTS"]        = "Puntos invertidos:"
L["PET_TALENTS"]            = "TALENTOS DE MASCOTA"
L["EXPORT_TO_TALENTED"]     = "EXPORTAR A TALENTED"
L["SUGGESTED_MAP"]          = "MAPA SUGERIDO"
L["MY_CONFIGURATION"]       = "MI CONFIGURACIÓN"
L["TALENTED_NOT_ACTIVE"]    = "El addon 'Talented' no está activo."

-- ========================
-- Pestaña Exportar IA
-- ========================
L["EXPORT_AI_TITLE"]        = "Exportar Perfil a Inteligencia Artificial"
L["EXPORT_AI_DESC"]         = "Presiona Ctrl+C en el cuadro de texto para copiar tu perfil completo.\nPuedes pegar este texto en ChatGPT, Claude o Gemini para pedir consejos sobre tu equipo, rotación o dónde conseguir las mejores piezas."
L["SELECT_ALL"]             = "Marcar Todo"

-- ========================
-- Exportación IA (Contenido)
-- ========================
L["AI_INTRO_PROMPT"]       = "Analiza este perfil de World of Warcraft 3.3.5a (WotLK) del servidor NaerZone. Actúa como un experto en optimización de equipo, gemas y rotación:"
L["TALENT_DISTRIBUTION"]   = "DISTRIBUCIÓN DE TALENTOS"
L["ACTIVE_GLYPHS"]         = "GLIFOS ACTIVOS"
L["KEY_STATS"]             = "ESTADÍSTICAS CLAVE"

-- UI Guide Elements
L["OPEN_GUIDE"]                     = "Abrir Guía"
L["PANEL_PJ"]                       = "Panel PJ"
L["RECOMMENDED_GEMS"]               = "GEMAS RECOMENDADAS"
L["RECOMMENDED_GLYPHS"]             = "GLIFOS RECOMENDADOS"
L["STATS_AND_CAPS"]                 = "CAPS Y ESTADÍSTICAS"
L["GUIDE_TITLE_FMT"]                = "Guía de %s - %s"
L["MAJOR"]                          = "Sublime"
L["MINOR"]                          = "Menor"
L["ENHANCEMENTS"]                   = "Mejoras"
L["APPLY_TO_BIS"]                   = "Aplicar en items bis (gemas)"

-- DB Notes Mapping
L["Hard Cap (1400 pasivo con T10+ICC25). Cambiar gemas al alcanzar ~1050 pasivo."] = "Hard Cap (1400 pasivo con T10+ICC25). Cambiar gemas al alcanzar ~1050 pasivo."
L["Soft Cap (Inicio / Medio equipo)"] = "Soft Cap (Inicio / Medio equipo)"
L["11% (289 rating) por talentos de Hit"] = "11% (289 rating) por talentos de Hit"
L["Soft ~900 (para rotación fluida) / Hard 1200 (sin sobrepasar GCD)"] = "Soft ~900 (para rotación fluida) / Hard 1200 (sin sobrepasar GCD)"
L["9% (Con Draenei)"] = "9% (Con Draenei)"
L["10% (Sin Draenei)"] = "10% (Sin Draenei)"
L["57/3/11 - Mago Arcano DPS"] = "57/3/11 - Mago Arcano DPS"

-- StatTrans keys (Static)
L["STAT_HIT"] = "Índice de Golpe"
L["STAT_HIT_SPELL"] = "Golpe (Hechizos)"
L["STAT_EXPERTISE"] = "Pericia"
L["STAT_ARP"] = "Pen. Armadura"
L["STAT_HASTE"] = "Celeridad"
L["STAT_CRIT"] = "Crítico"
L["STAT_SP"] = "Poder de Hechizos"
L["STAT_STA"] = "Aguante"
L["STAT_AGI"] = "Agilidad"
L["STAT_STR"] = "Fuerza"
L["STAT_INT"] = "Intelecto"
L["STAT_SPIRIT"] = "Espíritu"
L["STAT_DEF"] = "Defensa"
L["STAT_ARMOR"] = "Armadura"
L["STAT_DODGE"] = "Esquiva"
L["STAT_PARRY"] = "Parada"
L["STAT_AP"] = "Poder de Ataque"
L["STAT_RAP"] = "P. Ataque Rango"

-- StatTrans keys (Dynamic fallback for esMX load time)
L["Poder de Ataque"] = "Poder de Ataque"
L["Fuerza"] = "Fuerza"
L["Agilidad"] = "Agilidad"
L["Aguante"] = "Aguante"
L["Intelecto"] = "Intelecto"
L["Espíritu"] = "Espíritu"
L["Crítico"] = "Crítico"
L["Poder de Hechizos"] = "Poder de Hechizos"
L["Celeridad"] = "Celeridad"
L["Armadura"] = "Armadura"
L["Esquiva"] = "Esquiva"
L["Parada"] = "Parada"
L["Poder de Ataque a Distancia"] = "P. Ataque Rango"
L["Pen. Armadura"] = "Pen. Armadura"
L["Índice de Golpe"] = "Índice de Golpe"
L["Golpe (Hechizos)"] = "Golpe (Hechizos)"
L["Pericia"] = "Pericia"
L["Defensa"] = "Defensa"
L["RECOMENDADO"] = "RECOMENDADO"
L["CAPS_STATUS_LOGS"]      = "ESTADO DE CAPS / LOGROS"
L["EQUIPMENT_DETAILS"]     = "EQUIPAMIENTO DETALLADO"
L["MAX_HEALTH"]            = "Salud Máxima"
L["ARMOR"]                 = "Armadura"
L["ATTACK_POWER"]          = "Poder de Ataque"
L["RANGE"]                 = "Rango"
L["PROFILE_LABEL"]         = "PERFIL"
L["GEM_LABEL"]             = "Gema"
L["ENCHANT_LABEL"]         = "Encantamiento"
L["NO_GLYPHS"]             = "No se detectaron glifos"
L["PRIORITY_TAG"]          = "Prioridad"
L["PROFILE_FINISH"]        = "FIN DEL PERFIL"
L["GENERATED_BY"]          = "Generado por GearAnalyzer"
L["BRANCH"]                = "Rama"
L["SPEC_LABEL"]            = "ESPEC"

-- ========================
-- Nombres de Ranuras (Slots)
-- ========================
L["SLOT_HEAD"]              = "Cabeza"
L["SLOT_NECK"]              = "Cuello"
L["SLOT_SHOULDERS"]         = "Hombros"
L["SLOT_BACK"]              = "Espalda"
L["SLOT_CHEST"]             = "Pecho"
L["SLOT_WRISTS"]            = "Brazales"
L["SLOT_HANDS"]             = "Manos"
L["SLOT_WAIST"]             = "Cintura"
L["SLOT_LEGS"]              = "Piernas"
L["SLOT_FEET"]              = "Pies"
L["SLOT_FINGER1"]           = "Anillo 1"
L["SLOT_FINGER2"]           = "Anillo 2"
L["SLOT_TRINKET1"]          = "Abalorio 1"
L["SLOT_TRINKET2"]          = "Abalorio 2"
L["SLOT_MAINHAND"]          = "Mano Principal"
L["SLOT_OFFHAND"]           = "Mano Izquierda"
L["SLOT_RANGED"]            = "Rango"
L["SLOT_RELIC"]             = "Reliquia"
L["SLOT_TABARD"]            = "Tabardo"
L["SLOT_SHIRT"]             = "Camisa"

-- ========================
-- Selector de Idioma
-- ========================
L["LANGUAGE"]               = "Idioma"
L["LANGUAGE_CHANGE_MSG"]    = "Idioma cambiado. Algunos elementos pueden necesitar /reload para actualizarse completamente."
L["OPEN_GUIDE"]             = "Abrir Guía"
L["OPEN_PJ"]                = "Ver mi PJ"
