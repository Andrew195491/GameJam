extends Panel

@onready var play_button = $Control/MenuContainer/PlayButton
@onready var settings_button = $Control/MenuContainer/SettingsButton
@onready var quit_button = $Control/MenuContainer/QuitButton
@onready var main_music = $MainMusic
@onready var minecraft = $Control/MenuContainer/Minecraft
@onready var sine1 = $Control/MenuContainer/Sine1
@onready var sine2 = $Control/MenuContainer/Sine2
@onready var square1 = $Control/MenuContainer/Square1
@onready var square2 = $Control/MenuContainer/Square2

func _ready():
    main_music.play()
    play_button.text = "Jugar"
    settings_button.text = "Créditos"
    quit_button.text = "Salir"
    
    play_button.connect("pressed", _on_play_pressed)
    settings_button.connect("pressed",_on_settings_pressed)
    quit_button.connect("pressed", _on_quit_pressed)

func _on_play_pressed():
    var random_choice = randi() % 2
    if random_choice == 0:
        square1.play()
    else:
        square2.play()
    get_tree().change_scene_to_file("res://scenes/game_window.tscn")

func _on_settings_pressed():
    var random_choice = randi() % 2
    if random_choice == 0:
        sine1.play()
    else:
        sine2.play()
    get_tree().change_scene_to_file("res://scenes/credits_window_first.tscn")

func _on_quit_pressed():
    minecraft.play()
    get_tree().quit()
