extends Control

onready var label: Label = get_node("Label")
export var player: String

var backgroundSound: AudioStreamPlayer

func _get_configuration_warning() -> String:
	return "A player name needs to be given" if not player else ""

func _ready() -> void:
	label.text = label.text % PlayerData.playerName
	
	backgroundSound = AudioStreamPlayer.new()
	add_child(backgroundSound)
	backgroundSound.stream = preload("res://assets/Sounds/WINNER/gewonnen-87838.mp3")
	backgroundSound.play()
