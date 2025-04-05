extends Node2D

@onready var continueButton = $Pause/ContinueButton
@onready var menuButton = $Pause/MenuButton
@onready var optionsButton = $Pause/OptionsButton
@onready var optionsLabel = $Pause/OptionsButton/Label
@onready var menuLabel = $Pause/MenuButton/Label
@onready var continueLabel = $Pause/ContinueButton/Label
@onready var pause = $Pause

func _ready():
    continueButton.pressed.connect(_continueButton_pressed)
    menuButton.pressed.connect(_menuButton_pressed)
    optionsButton.pressed.connect(_optionsButton_pressed)

func _physics_process(delta):   
    if Input.is_action_just_pressed("pausa"):
        pausa()
        
func _continueButton_pressed():
    pausa()
    
func _menuButton_pressed():
    get_tree().paused = not get_tree().paused
    get_tree().change_scene_to_file("res://scenes/main.tscn")
    
func _optionsButton_pressed():
    get_tree().paused = not get_tree().paused
    get_tree().change_scene_to_file("res://scenes/options_window.tscn")
    
func pausa():
    get_tree().paused = not get_tree().paused
    pause.visible = not pause.visible
    continueButton.visible = not continueButton.visible
    menuButton.visible = not menuButton.visible
    optionsButton.visible = not optionsButton.visible
    continueLabel.visible = not continueLabel.visible
    menuLabel.visible = not menuLabel.visible
    optionsLabel.visible = not optionsLabel.visible
