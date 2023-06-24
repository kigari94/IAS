tool
extends Area2D

const pathToWinnerScreen = "res://src/Screens/WinnerScreen.tscn"
const winnerScene = preload(pathToWinnerScreen)

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
export var playerName: String

func _ready():
	anim_player.play("Portal_Animation")

func _get_configuration_warning() -> String:
	return "A scene needs to be selected" if not playerName else ""

func teleport() -> void:
	PlayerData.playerName = playerName
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(winnerScene)


func _on_body_entered(_body: PhysicsBody2D) -> void:
	teleport()
