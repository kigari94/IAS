extends Control


onready var keyboard_overlay = get_node("KeyboardTexture")
onready var gamepad_overlay = get_node("GamepadTexture")
onready var keyboard_button = get_node("KeyboardOverlayButton")
onready var gamepad_button = get_node("GamepadOverlayButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	gamepad_button.add_color_override("font_color",Color(0.5,0.5,0.5))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_KeyboardOverlayButton_button_up():
	if keyboard_overlay.visible == false:
		keyboard_overlay.visible = true
		gamepad_overlay.visible = false
		gamepad_button.add_color_override("font_color",Color(0.5,0.5,0.5))
	else:
		pass


func _on_GamepadOverlayButton_button_up():
	if gamepad_overlay.visible == false:
		gamepad_overlay.visible = true
		keyboard_overlay.visible= false
		keyboard_button.add_color_override("font_color",Color(0.5,0.5,0.5))
	else:
		pass # Replace with function body.
