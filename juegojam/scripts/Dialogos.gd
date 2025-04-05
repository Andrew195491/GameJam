extends ColorRect

# Diálogos con sus respuestas, con ramificaciones por respuesta
@onready var dialogos = [
    
    # JANTIL
    {
        "id": 0,
        "personaje": "Jantil",
        "pregunta": "¡Este es el mejor festival que existe!",
        "respuesta": ["¡Sí, es lo más!", "¡Ya, mola muchísimo!"]
    },
    {
        "id": 1,
        "personaje": "Jantil",
        "pregunta": "Las bandas son las mejores de este sistema de lejos",
        "respuesta": ["Totalmente de acuerdo", "Podría haber mejores"]
    },
    {
        "id": 2,
        "personaje": "Jantil",
        "pregunta": "Y encima todo es tan barato. ¡Mira!, solo 4000 créditos por un café es una ganga",
        "respuesta": ["Sí, está bien la verdad", "Cobro menos que eso..."]
    },
    {
        "id": 3,
        "personaje": "Jantil",
        "pregunta": "En fin, espero que lo pases bien",
        "respuesta": ["Igualmente"]
    },
    
    #PLIPLO
    {
        "id": 4,
        "personaje": "Pliplo",
        "pregunta": "¡4000 CRÉDITOS POR UN CAFÉ?! ¡ESTO ES UNA ESTAFA!",
        "respuesta": ["Lo siento, no pongo los precios", "Me parece un precio justo"],
        "siguiente": [4.1, 4.2]
    },
    {
        "id": 4.1,
        "personaje": "Pliplo",
        "pregunta": "Tiene razón, no es tu culpa",
        "respuesta": ["Entonces... ¿va a pagar?"],
        "siguiente": 5
    },
    {
        "id": 4.2,
        "personaje": "Pliplo",
        "pregunta": "Voy a hacer como que no lo he escuchado",
        "respuesta": ["Entonces... ¿va a pagar?"],
        "siguiente": 5
    },
    {
        "id": 5,
        "personaje": "Pliplo",
        "pregunta": "No queda otra, pero me sigue pareciendo una estafa ",
        "respuesta": ["Bueno es lo que hay", "Ya lo siento que tenga un buen dia"],
        "siguiente": [5.1, 5.2]
    },
    {
        "id": 5.1,
        "personaje": "Pliplo",
        "pregunta": "Esto esta cada dia peor ",
        "respuesta": ["..."]
    },
    {
        "id": 5.2,
        "personaje": "Pliplo",
        "pregunta": "No pasa nada niño igualmente ",
        "respuesta": ["..."]
    },
    
    #YALMA
    {
        "id": 6,
        "personaje": "Yalma",
        "pregunta": "Hola, ¿puedes mezclar ese vodka con agua carbonatada?",
        "respuesta": ["Claro que si", "No sé si es buena idea"],
        "siguiente": [6.1, 6.2]
    },
    {
        "id": 6.1,
        "personaje": "Yalma",
        "pregunta": "Gracias, ¿podrias darme un trapo tambien porfavor?",
        "respuesta": ["Lo siento, pero no", "Claro"],
        "siguiente": [7, 8]
    },
    {
        "id": 6.2,
        "personaje": "Yalma",
        "pregunta": "De verdad, es mi bebida favorita",
        "respuesta": ["Valeee", "Prefiero no arriesgarme"],
        "siguiente": [6.1, 7]
    },
    {
        "id": 7,
        "personaje": "Yalma",
        "pregunta": "Porfaaaaaa",
        "respuesta": ["Ya he dicho que no"]
    },
    {
        "id": 8,
        "personaje": "Yalma",
        "pregunta": "Muchas Gracias",
        "respuesta": ["..."]
    }
]

@onready var personajes = [
    {
        "nombre": "Jantil",
        "ID_Dialogo": [0, 1, 2, 3]
    },
    {
        "nombre": "Pliplo",
        "ID_Dialogo": [4]
    },
    {
        "nombre": "Yalma",
        "ID_Dialogo": [6]
    }
]

@onready var button = $Button
@onready var button2 = $Button2
@onready var label = $Label
@onready var label3 = $Label3
@onready var timer = $Timer
@onready var progress = $ProgressBar

var dialogo_random
var ultimo_id = -1
var tiempo_total = 3.0
var tiempo_restante = tiempo_total
var personaje_actual

var jantil_dialogos_pendientes = []
var jantil_terminado = false

func _ready():
    button.pressed.connect(_button_pressed)
    button2.pressed.connect(_button2_pressed)
    timer.timeout.connect(_timer_timeout)
    mostrar_dialogo_nuevo()

func mostrar_dialogo_por_id(id):
    print(jantil_dialogos_pendientes)
    dialogo_random = dialogos.filter(func(d): return d["id"] == id)[0]
    label.text = dialogo_random["pregunta"]
    label3.text = dialogo_random.get("personaje", "")

    if dialogos["personaje"] == "Yalma":
        jantil_dialogos_pendientes = personajes[0]["ID_Dialogo"].duplicate()
    
    if dialogo_random["respuesta"].size() == 1:
        button.text = dialogo_random["respuesta"][0]
        button2.hide()
    else:
        button.text = dialogo_random["respuesta"][0]
        button2.text = dialogo_random["respuesta"][1]
        button2.show()

    ultimo_id = dialogo_random["id"]
    tiempo_restante = tiempo_total
    progress.max_value = tiempo_total
    progress.value = tiempo_total
    timer.start()

func mostrar_dialogo_nuevo():
    if not jantil_terminado:
        if jantil_dialogos_pendientes.is_empty():
            jantil_terminado = true
            mostrar_dialogo_nuevo()
            return
        var id = jantil_dialogos_pendientes.pick_random()
        jantil_dialogos_pendientes.erase(id)
        mostrar_dialogo_por_id(id)
        return
        
    var intentos = 0
    var max_intentos = 10
    var salir = false

    while intentos < max_intentos and not salir:
        personaje_actual = personajes.pick_random()
        label3.text = personaje_actual["nombre"]

        var dialogos_personaje = dialogos.filter(func(d):
            return personaje_actual["ID_Dialogo"].has(d["id"]) and d["id"] != ultimo_id
        )

        if not dialogos_personaje.is_empty():
            dialogo_random = dialogos_personaje.pick_random()
            salir = true

        intentos += 1

    if dialogo_random == null:
        dialogo_random = dialogos[0]

    mostrar_dialogo_por_id(dialogo_random["id"])

func _button_pressed():
    tiempo_restante = tiempo_total
    progress.value = tiempo_total
    timer.start()

    if dialogo_random.has("siguiente"):
        if dialogo_random["siguiente"] is Array:
            mostrar_dialogo_por_id(dialogo_random["siguiente"][0])
        else:
            mostrar_dialogo_por_id(dialogo_random["siguiente"])
    else:
        mostrar_dialogo_nuevo()

func _button2_pressed():
    tiempo_restante = tiempo_total
    progress.value = tiempo_total
    timer.start()

    if dialogo_random.has("siguiente"):
        if dialogo_random["siguiente"] is Array:
            mostrar_dialogo_por_id(dialogo_random["siguiente"][1])
        else:
            mostrar_dialogo_por_id(dialogo_random["siguiente"])
    else:
        mostrar_dialogo_nuevo()

func _timer_timeout():
    mostrar_dialogo_nuevo()

func _process(delta):
    if not timer.is_stopped():
        tiempo_restante -= delta
        progress.value = max(tiempo_restante, 0)
