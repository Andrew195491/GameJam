extends Panel

@onready var left_panel = $LeftControl/LeftPanel

func _ready():
    # Set the colors for each panel
    left_panel.color = Color(1, 0, 0)  # Red
