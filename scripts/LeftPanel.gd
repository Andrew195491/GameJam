extends Control

@onready var color_rect = $LeftPanel  # Reference to the ColorRect node for background color
@onready var progress_bar = $LeftPanel/ProgressTimer  # Timer for the drink creation
@onready var timer = $LeftPanel/DrinkTimer  # Timer for the drink creation
@onready var chosen_ingredients = $LeftPanel/ChosenIngredients # Label to show ingredients of chosen drink
@onready var quantum_cafe = $LeftPanel/QuantumCafe
@onready var koffein = $LeftPanel/Koffein
@onready var lightspeed = $LeftPanel/Lightspeed
@onready var mad_innit = $LeftPanel/MadInnit
@onready var stellar_vodka = $LeftPanel/StellarVodka
@onready var f = $LeftPanel/F
@onready var zitrone = $LeftPanel/Zitrone
@onready var orange = $LeftPanel/Orange
@onready var alien_fruit = $LeftPanel/AlienFruit
@onready var curtis = $LeftPanel/Curtis
@onready var finger_claw = $LeftPanel/FingerClaw
@onready var black = $LeftPanel/Black
@onready var gs = $LeftPanel/GreatSuccess
@onready var gs2 = $LeftPanel/GreatSuccess2
@onready var open = $LeftPanel/OpenCocktail
@onready var closed = $LeftPanel/ClosedCocktail
@onready var fat_man = $LeftPanel/FatMan
@onready var eye = $LeftPanel/Eye
@onready var orange_cocktail = $LeftPanel/OrangeCocktail
@onready var muffin = $LeftPanel/Muffin
@onready var maquina = $LeftPanel/Maquina
@onready var mask = $LeftPanel/MaskOverlay

var is_round_active = true
var fail = 0

# Variables to control the drink creation process
var drink_progress = 0.0  # Tracks the progress of drink-making (0.0 to 1.0)

# List of unique ingredients for button creation
var cat1 = [
    "cafe_cuantico",
    "caffeine_molecule",
    "light_speed"]
var cat2 = [
    "mad",
    "estelar_vodka",
    "f"]
var cat3 = [
    "lemon",
    "naranja",
    "fruta_alien"]
var cat4 = [
    "grupo_1",
    "dedo",
    "agujero_negro"]

var ingredient_images = {
    "cafe_cuantico": "res://assets/cafe_cuantico.png",
    "caffeine_molecule": "res://assets/caffeine_molecule.png",
    "light_speed": "res://assets/light_speed.png",
    "mad": "res://assets/mad.png",
    "estelar_vodka": "res://assets/estelar_vodka.png",
    "f": "res://assets/f.png",
    "lemon": "res://assets/lemon.png",
    "naranja": "res://assets/naranja.png",
    "fruta_alien": "res://assets/fruta_alien.png",
    "grupo_1": "res://assets/grupo_1.png",
    "dedo": "res://assets/dedo.png",
    "agujero_negro": "res://assets/agujero_negro.png",
}

var ingredient_sound_system = {}

# Define the drinks and their ingredients
var drinks = [
    {
        "name": "Pickle Rick’s Caffeinated Transformation",
        "ingredients": [            
        ]
    },
    {
        "name": "Portal Fluid Drip",
        "ingredients": [            
        ]
    },
    {
        "name": "The Evil Morty Dark Roast",
        "ingredients": [            
        ]
    },
    {
        "name": "Schwifty Spritzer",
        "ingredients": [            
        ]
    },
    {
        "name": "Covfefe Drip",
        "ingredients": [            
        ]
    },
    {
        "name": "Fat Rat Black Hole",
        "ingredients": [            
        ]
    },
    {
        "name": "Fat Rat Black Hole",
        "ingredients": [            
        ]
    }
]

# Variables for drink creation and selection
var selected_drink = null
var selected_ingredients = []
var selected_drink_ingredients = []

# Timer variables
var drink_creation_time = 22.0  # Total time for the drink creation (in seconds)
var time_left = drink_creation_time  # Time remaining for the drink creation
var mouse_is_on_screen = false  # Flag to track if the mouse is on screen

func _ready():
    randomize()
    
    mask.show()
    open.show()
    closed.hide()
    fat_man.hide()
    eye.hide()
    orange_cocktail.hide()
    muffin.hide()
    maquina.hide()
    
    ingredient_sound_system = {
        "cafe_cuantico": quantum_cafe,
        "caffeine_molecule": koffein,
        "light_speed": lightspeed,
        "mad": mad_innit,
        "estelar_vodka": stellar_vodka,
        "f": f,
        "lemon": zitrone,
        "naranja": orange,
        "fruta_alien": alien_fruit,
        "grupo_1": curtis,
        "dedo": finger_claw,
        "agujero_negro": black
    }

    # Set up UI elements and initial configurations
    self.add_theme_stylebox_override("panel", StyleBoxFlat.new())
    var stylebox = get_theme_stylebox("panel")
    stylebox.bg_color = Color(0, 0, 1)  # Blue background

    progress_bar.min_value = 0
    progress_bar.max_value = drink_creation_time
    progress_bar.value = drink_creation_time

    # Setup timer and start it
    timer.wait_time = 1.0
    timer.one_shot = false
    timer.start()
    time_left = drink_creation_time

    # Set up mouse detection
    set_process(true)
    
    # Pick a random drink and update labels
    select_random_drink()

    # Dynamically create ingredient buttons
    create_ingredient_buttons_with_images()

func create_ingredient_buttons_with_images():
    var randomised_cat1 = cat1.duplicate()
    randomised_cat1.shuffle()
    var randomised_cat2 = cat2.duplicate()
    randomised_cat2.shuffle()
    var randomised_cat3 = cat3.duplicate()
    randomised_cat3.shuffle()
    var randomised_cat4 = cat4.duplicate()
    randomised_cat4.shuffle()
    
    $ButtonContainer1.columns = 1
    $ButtonContainer2.columns = 1
    $ButtonContainer3.columns = 1
    $ButtonContainer4.columns = 1

    for ingredient in randomised_cat1:
        var container1 = MarginContainer.new()
        container1.add_theme_constant_override("margin_left", 5)
        container1.add_theme_constant_override("margin_right", 5)
        container1.add_theme_constant_override("margin_top", 18)
        container1.add_theme_constant_override("margin_bottom", 18)
        
        var button = Button.new()
        # Create a Sprite to hold the image for the ingredient
        var sprite = Sprite2D.new()
        # Set the sprite's texture using the image path from the dictionary
        if ingredient_images.has(ingredient):
            sprite.texture = load(ingredient_images[ingredient])
        
        # Add the sprite as the button's child so the image appears on the button
        button.flat = true
        button.custom_minimum_size = Vector2(80, 80)
        # Adjust the sprite size (if necessary)
        sprite.scale = Vector2(0.8, 0.8)  # Scale the image if needed
        sprite.position = Vector2(button.custom_minimum_size.x / 2, button.custom_minimum_size.y / 2)
        button.add_child(sprite)

        # Connect the button press to the ingredient handler
        button.pressed.connect(_on_ingredient_button_pressed.bind(ingredient))
        
        container1.add_child(button)
        $ButtonContainer1.add_child(container1)
        
    for ingredient in randomised_cat2:
        var container2 = MarginContainer.new()
        container2.add_theme_constant_override("margin_left", 5)
        container2.add_theme_constant_override("margin_right", 5)
        container2.add_theme_constant_override("margin_top", 18)
        container2.add_theme_constant_override("margin_bottom", 18)
        
        var button = Button.new()
        # Create a Sprite to hold the image for the ingredient
        var sprite = Sprite2D.new()
        # Set the sprite's texture using the image path from the dictionary
        if ingredient_images.has(ingredient):
            sprite.texture = load(ingredient_images[ingredient])
        
        # Add the sprite as the button's child so the image appears on the button
        button.flat = true
        button.custom_minimum_size = Vector2(80, 80)
        # Adjust the sprite size (if necessary)
        sprite.scale = Vector2(0.8, 0.8)  # Scale the image if needed
        sprite.position = Vector2(button.custom_minimum_size.x / 2, button.custom_minimum_size.y / 2)
        button.add_child(sprite)

        # Connect the button press to the ingredient handler
        button.pressed.connect(_on_ingredient_button_pressed.bind(ingredient))
        
        container2.add_child(button)
        $ButtonContainer2.add_child(container2)
        
    for ingredient in randomised_cat3:
        var container3 = MarginContainer.new()
        container3.add_theme_constant_override("margin_left", 5)
        container3.add_theme_constant_override("margin_right", 5)
        container3.add_theme_constant_override("margin_top", 18)
        container3.add_theme_constant_override("margin_bottom", 18)
        
        var button = Button.new()
        # Create a Sprite to hold the image for the ingredient
        var sprite = Sprite2D.new()
        # Set the sprite's texture using the image path from the dictionary
        if ingredient_images.has(ingredient):
            sprite.texture = load(ingredient_images[ingredient])
        
        # Add the sprite as the button's child so the image appears on the button
        button.flat = true
        button.custom_minimum_size = Vector2(80, 80)
        # Adjust the sprite size (if necessary)
        sprite.scale = Vector2(0.8, 0.8)  # Scale the image if needed
        sprite.position = Vector2(button.custom_minimum_size.x / 2, button.custom_minimum_size.y / 2)
        button.add_child(sprite)

        # Connect the button press to the ingredient handler
        button.pressed.connect(_on_ingredient_button_pressed.bind(ingredient))
        
        container3.add_child(button)
        $ButtonContainer3.add_child(container3)
            
    for ingredient in randomised_cat4:
        var container4 = MarginContainer.new()
        container4.add_theme_constant_override("margin_left", 5)
        container4.add_theme_constant_override("margin_right", 5)
        container4.add_theme_constant_override("margin_top", 18)
        container4.add_theme_constant_override("margin_bottom", 18)
        
        var button = Button.new()
        # Create a Sprite to hold the image for the ingredient
        var sprite = Sprite2D.new()
        # Set the sprite's texture using the image path from the dictionary
        if ingredient_images.has(ingredient):
            sprite.texture = load(ingredient_images[ingredient])
        
        # Add the sprite as the button's child so the image appears on the button
        button.flat = true
        button.custom_minimum_size = Vector2(80, 80)
        # Adjust the sprite size (if necessary)
        sprite.scale = Vector2(0.8, 0.8)  # Scale the image if needed
        sprite.position = Vector2(button.custom_minimum_size.x / 2, button.custom_minimum_size.y / 2)
        button.add_child(sprite)

        # Connect the button press to the ingredient handler
        button.pressed.connect(_on_ingredient_button_pressed.bind(ingredient))
        
        container4.add_child(button)
        $ButtonContainer4.add_child(container4)

func select_random_drink():
    
    mask.show()
    open.show()
    closed.hide()
    fat_man.hide()
    eye.hide()
    orange_cocktail.hide()
    muffin.hide()
    maquina.hide()
    
    var index = randi() % drinks.size()
    var ingredients = []
    selected_drink = drinks[index]
    selected_ingredients.clear()
    selected_drink_ingredients.clear()
    ingredients.append(cat1[randi() % cat1.size()])
    ingredients.append(cat2[randi() % cat2.size()])
    ingredients.append(cat3[randi() % cat3.size()])
    ingredients.append(cat4[randi() % cat4.size()])
    selected_drink["ingredients"] = ingredients

    chosen_ingredients.text = "Ingredientes: "
    
    for i in selected_drink["ingredients"]:
        selected_drink_ingredients.append(i)
    selected_drink_ingredients.shuffle()
    
    $LeftPanel/Ingredient1.texture = load(ingredient_images.get(selected_drink_ingredients[0]))
    $LeftPanel/Ingredient2.texture = load(ingredient_images.get(selected_drink_ingredients[1]))
    $LeftPanel/Ingredient3.texture = load(ingredient_images.get(selected_drink_ingredients[2]))
    $LeftPanel/Ingredient4.texture = load(ingredient_images.get(selected_drink_ingredients[3]))
    
    $LeftPanel/Ingredient1.scale = Vector2(0.5, 0.5)
    $LeftPanel/Ingredient2.scale = Vector2(0.5, 0.5)
    $LeftPanel/Ingredient3.scale = Vector2(0.5, 0.5)
    $LeftPanel/Ingredient4.scale = Vector2(0.5, 0.5)

# Handle ingredient button press
func _on_ingredient_button_pressed(ingredient):
    if selected_drink == null:
        return
    
    if ingredient == "cafe_cuantico":
        ingredient_sound_system["cafe_cuantico"].play()
    elif ingredient == "caffeine_molecule":
        ingredient_sound_system["caffeine_molecule"].play()
    elif ingredient == "light_speed":
        ingredient_sound_system["light_speed"].play()
    elif ingredient == "mad":
        ingredient_sound_system["mad"].play()
    elif ingredient == "estelar_vodka":
        ingredient_sound_system["estelar_vodka"].play()
    elif ingredient == "f":
        ingredient_sound_system["f"].play()
    elif ingredient == "lemon":
        ingredient_sound_system["lemon"].play()
    elif ingredient == "naranja":
        ingredient_sound_system["naranja"].play()
    elif ingredient == "fruta_alien":
        ingredient_sound_system["fruta_alien"].play()
    elif ingredient == "grupo_1":
        ingredient_sound_system["grupo_1"].play()
    elif ingredient == "dedo":
        ingredient_sound_system["dedo"].play()
    elif ingredient == "agujero_negro":
        ingredient_sound_system["agujero_negro"].play()

    # If already selected, it's now considered incorrect
    if ingredient in selected_ingredients:
        _handle_incorrect_selection(ingredient)
        return

    if ingredient in selected_drink_ingredients:
        _handle_correct_selection(ingredient)
    else:
        _handle_incorrect_selection(ingredient)

# Handle correct ingredient selection
func _handle_correct_selection(ingredient):
    if not is_round_active:
        return

    if ingredient in selected_ingredients:
        _handle_incorrect_selection(ingredient)
        return

    if ingredient not in selected_drink_ingredients:
        _handle_incorrect_selection(ingredient)
        return
    
    selected_ingredients.append(ingredient)

    # Filter and update UI
    var remaining = []
    for item in selected_drink_ingredients:
        if item not in selected_ingredients:
            remaining.append(item)

    chosen_ingredients.text = "Ingredientes: "
    
    # Find the index of the clicked ingredient in the drink's ingredient list
    var index = selected_drink_ingredients.find(ingredient)

    # Clear the corresponding Sprite2D texture
    if selected_drink_ingredients[index] == selected_drink_ingredients[0]:
        $LeftPanel/Ingredient1.texture = null
    elif selected_drink_ingredients[index] == selected_drink_ingredients[1]:
        $LeftPanel/Ingredient2.texture = null
    elif selected_drink_ingredients[index] == selected_drink_ingredients[2]:
        $LeftPanel/Ingredient3.texture = null
    elif selected_drink_ingredients[index] == selected_drink_ingredients[3]:
        $LeftPanel/Ingredient4.texture = null
    
    if remaining.size() == 0:
        if time_left > 5.0:
            var random_choice = randi() % 2
            if random_choice == 0:
                gs.play()
            else:
                gs2.play()
        time_left = 0
        is_round_active = false
        complete_drink(true)

# Handle incorrect ingredient selection
func _handle_incorrect_selection(ingredient):
    if not is_round_active:
        return

    selected_ingredients.clear()
    chosen_ingredients.text = "Ingredientes: "
    
    # Optionally, clear the textures from the Ingredient sprites if needed
    $LeftPanel/Ingredient1.texture = load(ingredient_images.get(selected_drink_ingredients[0]))
    $LeftPanel/Ingredient2.texture = load(ingredient_images.get(selected_drink_ingredients[1]))
    $LeftPanel/Ingredient3.texture = load(ingredient_images.get(selected_drink_ingredients[2]))
    $LeftPanel/Ingredient4.texture = load(ingredient_images.get(selected_drink_ingredients[3]))

# Timer countdown to track drink progress
func _process(delta):
    if not is_round_active:
        return  # Don't update timer if round is done
    var mouse_pos = get_local_mouse_position()

    # Check if mouse is on the left side of the screen
    if color_rect.get_rect().has_point(mouse_pos):
        mouse_is_on_screen = true
    else:
        mouse_is_on_screen = false

    # Adjust timer speed based on mouse position
    if mouse_is_on_screen:
        time_left -= delta
    else:
        time_left -= delta * 1.4  # Speed up timer when mouse is not on screen

    # If time is up, stop the timer and complete the drink
    if time_left > 0:
        time_left -= delta
        progress_bar.value = time_left
    else:
        is_round_active = false
        timer.stop()
        complete_drink(false)

# Function to complete the drink
func complete_drink(flag):
    if flag:
        
        mask.show()
        open.hide()
        closed.show()
        await get_tree().create_timer(2.5).timeout
        var random_choice = randi() % 5
        if random_choice == 0:
            mask.show()
            closed.hide()
            eye.hide()
            orange_cocktail.hide()
            muffin.hide()
            maquina.hide()
            fat_man.show()
        elif random_choice == 1:
            mask.show()
            closed.hide()
            fat_man.hide()
            orange_cocktail.hide()
            muffin.hide()
            maquina.hide()
            eye.show()
        elif random_choice == 2:
            mask.show()
            closed.hide()
            fat_man.hide()
            eye.hide()
            muffin.hide()
            maquina.hide()
            orange_cocktail.show()
        elif random_choice == 3:
            mask.show()
            closed.hide()
            fat_man.hide()
            eye.hide()
            orange_cocktail.hide()
            maquina.hide()
            muffin.show()
        elif random_choice == 4:
            mask.show()
            closed.hide()
            fat_man.hide()
            eye.hide()
            orange_cocktail.hide()
            muffin.hide()
            maquina.show()
        
    else:
        fail += 1
        mask.show()
        open.hide()
        closed.hide()
        fat_man.hide()
        eye.hide()
        orange_cocktail.hide()
        muffin.hide()
        maquina.show()
    await get_tree().create_timer(2.5).timeout
    
    if fail == 3:
        get_tree().change_scene_to_file("res://scenes/game_over.tscn")
    
    reset_game_state()
    
    select_random_drink()

func reset_game_state():
    # Clear selected ingredients
    selected_ingredients.clear()
    mask.show()
    open.hide()
    closed.hide()
    fat_man.hide()
    eye.hide()
    orange_cocktail.hide()
    muffin.hide()
    maquina.show()

    # Clear all buttons in the ButtonContainer
    for child in $ButtonContainer1.get_children():
        child.queue_free()
    for child in $ButtonContainer2.get_children():
        child.queue_free()
    for child in $ButtonContainer3.get_children():
        child.queue_free()
    for child in $ButtonContainer4.get_children():
        child.queue_free()
    
    $LeftPanel/Ingredient1.texture = null
    $LeftPanel/Ingredient2.texture = null
    $LeftPanel/Ingredient3.texture = null
    $LeftPanel/Ingredient4.texture = null
    
    # Recreate ingredient buttons
    create_ingredient_buttons_with_images()

    # Reset timer and progress bar
    time_left = drink_creation_time
    progress_bar.value = drink_creation_time
    timer.start()

    # Update chosen_ingredients label
    chosen_ingredients.text = "Ingredientes: "

    # Reactivate round logic
    is_round_active = true
