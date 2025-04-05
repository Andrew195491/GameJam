extends ColorRect

@onready var label = $Label
@onready var label3 = $Label3
@onready var button = $Button
@onready var button2 = $Button2

var numero_random = RandomNumberGenerator.new()
var personajes_random = null
var personaje_anterior = null
var id_Per_anterior = 0
var id_Per = 0
var dialogo_actual = null

@onready var personajes = [
    {
        "id_Per": 1,
        "nombre": "Jantil",
        "dialogos": [
            {"id_Dia": 1, "frase": "Este es el mejor festival que existe", "respuesta": ["Si es lo mas", "Ya mola muchisimo"], "usado": false},
            {"id_Dia": 2, "frase": "Las bandas son las mejores de este sistema, de lejos", "respuesta": ["Totalmente de acuerdo", "Podria haber mejores"]},
            {"id_Dia": 3, "frase": "Y encima todo es tan barato mira solo 4000 creditos por un cafe es una ganga", "respuesta": ["Sí, esta bien la verdad", "Cobro menos que eso…"]},
            {"id_Dia": 4, "frase": "En fin espero que lo pases bien", "respuesta": "Igualmente", "usado": false}
        ],
    },
    {
        "id_Per": 2,
        "nombre": "Pliplo",
        "dialogos": [
            {"id_Dia": 1, "frase": "¡¿4000 créditos por un café?! ¡Esto es una estafa!", "respuesta": ["Lo siento no pongo los precios", "Me parece un precio justo"], "camino": [2, 3]},
            {"id_Dia": 2, "frase": "Tiene razon, no es su culpa", "respuesta": "¿Entonces va a pagar?", "camino": 4},
            {"id_Dia": 3, "frase": "Voy a hacer como que no lo he escuchado", "respuesta": "¿Entonces va a pagar?", "camino": 4},
            {"id_Dia": 4, "frase": "No queda otra, pero me sigue pareciendo una estafa", "respuesta": ["Bueno... es lo que hay", "Ya, lo siento, que tenga un buen dia"], "camino": [5, 6]},
            {"id_Dia": 5, "frase": "Esto esta cada dia peor...", "respuesta": "..."},
            {"id_Dia": 6, "frase": "No pasa nada niño, igualmente...", "respuesta": "..."}
        ],
    },
    {
        "id_Per": 3,
        "nombre": "Yalma",
        "dialogos": [
            {"id_Dia": 1, "frase": "Hola, ¿puedes mezclar ese vodka con agua carbonatada?", "respuesta": ["Claro que si", "No se si es buena idea"], "camino": [2, 3]},
            {"id_Dia": 2, "frase": "Gracias, ¿podrias darme un trapo tambien, porfavor?", "respuesta": ["Claro", "Lo siento pero no"], "camino": [5, 4]},
            {"id_Dia": 3, "frase": "De verdad es mi bebida favorita", "respuesta": ["Valeee", "Prefiero no arriesgarme"], "camino": [2, 4]},
            {"id_Dia": 4, "frase": "Porfaaaaaa", "respuesta": "Ya he dicho que no"},
            {"id_Dia": 5, "frase": "Muchas Gracias", "respuesta": "..."},
        ],
    }
]

var jantil_dialog_indices = [] # Store available Jantil dialog indices
var jantil_completed = false # Flag to track if Jantil has said all his lines

func _ready() -> void:
    button.pressed.connect(_button_pressed)
    button2.pressed.connect(_button2_pressed)
    numero_random.randomize()  # Seed the random number generator
    random()

func _button_pressed():
    if dialogo_actual.has("camino"):
        var next_id = dialogo_actual["camino"][0] if typeof(dialogo_actual["camino"]) == TYPE_ARRAY else dialogo_actual["camino"]
        mostrar_dialogo_por_id(next_id)
    else:
        random()

func _button2_pressed():
    if dialogo_actual.has("camino") and typeof(dialogo_actual["camino"]) == TYPE_ARRAY and dialogo_actual["camino"].size() > 1:
        var next_id = dialogo_actual["camino"][1]
        mostrar_dialogo_por_id(next_id)
    else:
        random()

func random():
    if not jantil_completed:
        if personajes_random != null and personajes_random["id_Per"] == 1: #If the last character was Jantil, continue the dialog
            mostrar_jantil_dialog()
            return

    if personaje_anterior != null:
        id_Per_anterior = personaje_anterior["id_Per"]

    while id_Per_anterior == id_Per:
        var random_number = numero_random.randi_range(0, personajes.size() - 1)
        personajes_random = personajes[random_number]
        id_Per = personajes_random["id_Per"]

    personaje_anterior = personajes_random
    if personajes_random["id_Per"] == 1:
        jantil_completed = false # Resets Jantil´s status for dialogs
        init_jantil_dialog()  # Initialize the Jantil's dialogs index array
        mostrar_jantil_dialog()
    else:
        mostrar_dialogo_personaje(personajes_random) #For other character, show it as usual


func mostrar_jantil_dialog() -> void:
    if jantil_dialog_indices.size() > 0: # Check if there are any dialog to show
        var dialog_index = jantil_dialog_indices.pop_front()  # Get an index for show the dialog and remove the dialog

        dialogo_actual = personajes_random["dialogos"][dialog_index]
        label3.text = personajes_random["nombre"] # Set the character name
        label.text = dialogo_actual["frase"]

        # Set buttons based on available responses
        if typeof(dialogo_actual["respuesta"]) == TYPE_ARRAY:
            button.text = dialogo_actual["respuesta"][0]
            button2.text = dialogo_actual["respuesta"][1]
            button2.show()
        else:
            button.text = dialogo_actual["respuesta"]
            button2.hide()
        return # stop the proccess for show other character dialogs

    jantil_completed = true # if no dialog to show mark this to complete and jump another character
    random() # jump to random to select another character

func init_jantil_dialog() -> void: #This fuction is for initialize the Jantil array dialogs
    # Initialize jantil_dialog_indices with all dialog indices
    jantil_dialog_indices.clear() #First make sure that clear the array
    for i in range(personajes[0]["dialogos"].size()):
        jantil_dialog_indices.append(i)
    jantil_dialog_indices.shuffle() # Shuffle that

func mostrar_dialogo_personaje(personaje):
    var nombre = personaje["nombre"]
    var dialogos = personaje["dialogos"]

    # Mostrar el diálogo con ID 1 si existe
    dialogo_actual = null
    for d in dialogos:
        if d["id_Dia"] == 1:
            dialogo_actual = d
            break
    if dialogo_actual == null:
        dialogo_actual = dialogos.pick_random()

    label3.text = nombre
    label.text = dialogo_actual["frase"]

    if typeof(dialogo_actual["respuesta"]) == TYPE_ARRAY:
        button.text = dialogo_actual["respuesta"][0]
        button2.text = dialogo_actual["respuesta"][1]
        button2.show()
    else:
        button.text = dialogo_actual["respuesta"]
        button2.hide()


func mostrar_dialogo_por_id(id_dia):
    var dialogos = personajes_random["dialogos"]
    for d in dialogos:
        if d["id_Dia"] == id_dia:
            dialogo_actual = d
            label.text = d["frase"]
            if typeof(d["respuesta"]) == TYPE_ARRAY:
                button.text = d["respuesta"][0]
                button2.text = d["respuesta"][1]
                button2.show()
            else:
                button.text = d["respuesta"]
                button2.hide()
            return
