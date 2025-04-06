extends ColorRect

@onready var label = $Label
@onready var label2 = $Label2 # Add Label2
@onready var label3 = $Label3
@onready var button = $Button
@onready var button2 = $Button2
@onready var timer = $Timer
@onready var progress_bar = $ProgressBar
@onready var character1 = $CafeCuantico
@onready var character2 = $Grupo1
@onready var alien_girl = $ChicaAlien

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
var timer_duration = 10.0 # Set the duration in seconds
var time_remaining = timer_duration
var timer_active = false
var yalma_denied = false # New variable to track if Yalma has been denied
var delay_duration = 3.0 # Add the delay duration
var delay_remaining = 0.0
var delay_active = false
var label2_visible = true #For blink label

func _ready() -> void:
    button.flat = true
    button2.flat = true
    button.add_theme_color_override("font_color", "black")
    button2.add_theme_color_override("font_color", "black")
    button.add_theme_color_override("font_hover_color", "purple")
    button2.add_theme_color_override("font_hover_color", "purple")
    button.add_theme_color_override("font_hover_pressed_color", "black")
    button2.add_theme_color_override("font_hover_pressed_color", "black")
    button.add_theme_color_override("font_hover_pressed_color", "black")
    button2.add_theme_color_override("font_hover_pressed_color", "black")
    button.add_theme_color_override("font_focus_color", "black")
    button2.add_theme_color_override("font_focus_color", "black")
    button.add_theme_color_override("font_pressed_color", "black")
    button2.add_theme_color_override("font_pressed_color", "black")
    label.add_theme_color_override("font_color", "black")
    label2.add_theme_color_override("font_color", "red")
    button.pressed.connect(_button_pressed)
    button2.pressed.connect(_button2_pressed)
    timer.timeout.connect(_on_timer_timeout)
    numero_random.randomize()  # Seed the random number generator
    progress_bar.max_value = timer_duration  # Set max value of progress bar
    progress_bar.value = timer_duration  # Initialize progress bar
    label2.hide()  # Initially hide label2
    random()

func _process(delta):
    if timer_active:
        time_remaining -= delta
        progress_bar.value = time_remaining
        if time_remaining <= 0:
            timer_active = false
            time_remaining = timer_duration  # Reset timer
            progress_bar.value = timer_duration # Reset progress bar
            start_delay()  # Start the delay

    if delay_active: # Add code if delay is acive, count the delay
        delay_remaining -= delta
        if delay_remaining <= 0: # if finish, back to normal
            delay_active = false
            label2.hide()
            random() # select a new dialog
        else: #If still the delay, blink label2
            label2_visible = !label2_visible
            label2.visible = label2_visible
        
func _button_pressed():
    if dialogo_actual.has("camino"):
        var next_id = dialogo_actual["camino"][0] if typeof(dialogo_actual["camino"]) == TYPE_ARRAY else dialogo_actual["camino"]
        mostrar_dialogo_por_id(next_id)
        start_timer()

        # Si es Yalma y se seleccionó una negación
        if personajes_random["id_Per"] == 3 and dialogo_actual["id_Dia"] == 4:
            yalma_denied = true
            print("Yalma ha sido denegada.")
    else:
        random()
        

func _button2_pressed():
    if dialogo_actual.has("camino") and typeof(dialogo_actual["camino"]) == TYPE_ARRAY and dialogo_actual["camino"].size() > 1:
        var next_id = dialogo_actual["camino"][1]
        mostrar_dialogo_por_id(next_id)
        start_timer()

        # Si es Yalma y se seleccionó una negación
        if personajes_random["id_Per"] == 3 and dialogo_actual["id_Dia"] == 4:
            yalma_denied = true
            print("Yalma ha sido denegada.")
    else:
        random()

func random():
    stop_timer()  # Stop any existing timer
    button.disabled = false
    button2.disabled = false
    time_remaining = timer_duration # Reset the timer
    progress_bar.value = timer_duration
    if not jantil_completed:
        if personajes_random != null and personajes_random["id_Per"] == 1: #If the last character was Jantil, continue the dialog
            mostrar_jantil_dialog()
            return

    if personaje_anterior != null:
        id_Per_anterior = personaje_anterior["id_Per"]

    # Create a filtered array that excludes Yalma if she's been denied
    var available_characters = []
   

    while id_Per_anterior == id_Per:
       # Create a filtered array that excludes Yalma if she's been denied
        if yalma_denied:
            available_characters = personajes.filter(func(joaquin): return joaquin["id_Per"] != 3)
        else:
            available_characters = personajes.duplicate() # Create a copy to avoid modifying the original
        var random_number = numero_random.randi_range(0, available_characters.size() - 1)
        personajes_random = available_characters[random_number]
        id_Per = personajes_random["id_Per"]
        print(id_Per)
        if id_Per == 1:
            alien_girl.show()
            character1.hide()
            character2.hide()
        elif id_Per == 2:
            alien_girl.hide()
            character1.show()
            character2.hide()
        elif id_Per == 3:
            alien_girl.hide()
            character1.hide()
            character2.show()

    personaje_anterior = personajes_random
    if personajes_random["id_Per"] == 1:
        jantil_completed = false # Resets Jantil´s status for dialogs
        init_jantil_dialog()  # Initialize the Jantil's dialogs index array
        mostrar_jantil_dialog()
    else:
        mostrar_dialogo_personaje(personajes_random) #For other character, show it as usual

func mostrar_jantil_dialog() -> void:
    stop_timer()  # Stop any existing timer
    time_remaining = timer_duration
    progress_bar.value = timer_duration
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
        start_timer()
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
    stop_timer()  # Stop any existing timer
    time_remaining = timer_duration
    progress_bar.value = timer_duration
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
    start_timer()

func mostrar_dialogo_por_id(id_dia):
    stop_timer()  # Stop any existing timer
    time_remaining = timer_duration
    progress_bar.value = timer_duration
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
            start_timer()
            return

func start_timer():
    timer_active = true
    time_remaining = timer_duration
    progress_bar.value = timer_duration

func stop_timer():
    timer_active = false
    time_remaining = timer_duration
    progress_bar.value = timer_duration

func start_delay() -> void: # Add delay for start next dialog
    jantil_completed = true
    delay_active = true #Set the delay
    delay_remaining = delay_duration  # Set the timer
    label2.text = "¡El cliente se ha ido enfadado, viene otro cliente!"  # Set the text
    label2.show() # Show the label2
    button.disabled = true
    button2.disabled = true
    

func _on_timer_timeout():
    timer_active = false
    time_remaining = timer_duration
    progress_bar.value = timer_duration
    random() # Go to the next dialog
