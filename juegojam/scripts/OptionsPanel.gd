extends Panel

@onready var volume_label = $Control/OptionsContainer/VolumeLabel
@onready var volume_slider = $Control/OptionsContainer/Volume
@onready var back_button = $Control/OptionsContainer/BackButton



func _ready():
    volume_label.add_text("Volume")
    back_button.text = "Back"
    
    var volume = ProjectSettings.get_setting("audio/volume", 1.0)
    volume_slider.value = volume
    
    volume_slider.connect("value_changed", _on_volume_changed)
    back_button.connect("pressed", _on_back_pressed)
    
    _on_volume_changed(volume) # set it on load

func _on_volume_changed(value):
    print("Volume!")
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
    ProjectSettings.set_setting("audio/volume", value)
    ProjectSettings.save()

    # Show a settings panel or go to a settings scene

func _on_back_pressed():
    print("Back")
    get_tree().change_scene_to_file("res://scenes/main.tscn")
