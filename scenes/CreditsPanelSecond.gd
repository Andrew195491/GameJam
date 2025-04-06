extends Node2D

@onready var credit_music = $CreditsPanel/CreditsMuffled

func _ready():
    credit_music.play()
    await get_tree().create_timer(4).timeout
    get_tree().change_scene_to_file("res://scenes/main.tscn")
