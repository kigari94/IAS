extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
onready var playerOneHint: Sprite = get_node("ArrowAnimationPlayer1")
onready var playerTwoHint: Sprite = get_node("ArrowAnimationPlayer2")

onready var animation = $AnimationPlayer

var paused: = false setget set_paused


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = !paused
		scene_tree.set_input_as_handled()

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func _process(_delta) -> void:
	if PlayerData.playerOneActive:
		playerOneHint.visible = true
		playerTwoHint.visible = false
		animation.play("Arrow_Player1_Animation")
	else:
		playerTwoHint.visible = true
		playerOneHint.visible = false
		animation.play("Arrow_Player2_Animation")
