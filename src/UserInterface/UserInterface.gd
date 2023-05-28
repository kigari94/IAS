extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var playerOneHint: Label = get_node("LabelRight")
onready var playerTwoHint: Label = get_node("LabelLeft")

var paused: = false setget set_paused


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = !paused
		scene_tree.set_input_as_handled()

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func _process(delta) -> void:
	if PlayerData.playerOneActive:
		playerOneHint.visible = true
		playerTwoHint.visible = false
	else:
		playerTwoHint.visible = true
		playerOneHint.visible = false
