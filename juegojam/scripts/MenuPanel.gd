extends Panel

@onready var play_button = $Control/MenuContainer/PlayButton
@onready var settings_button = $Control/MenuContainer/SettingsButton
@onready var quit_button = $Control/MenuContainer/QuitButton
@onready var main_music = $MainMusic


func _ready():
    main_music.play()
    play_button.text = "Play"
    settings_button.text = "Options"
    quit_button.text = "Quit"
    
    play_button.connect("pressed", _on_play_pressed)
    settings_button.connect("pressed",_on_settings_pressed)
    quit_button.connect("pressed", _on_quit_pressed)

func _on_play_pressed():
    print("Play pressed!")
    get_tree().change_scene_to_file("res://scenes/game_window.tscn")

func _on_settings_pressed():
    print("Open settings!")
    get_tree().change_scene_to_file("res://scenes/options_window.tscn")

func _on_quit_pressed():
    print("Quit game.")
    get_tree().quit()
