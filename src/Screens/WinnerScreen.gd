extends Control

onready var label: Label = get_node("Label")
export var player: String

func _get_configuration_warning() -> String:
	return "A player name needs to be given" if not player else ""

func _ready() -> void:
	label.text = label.text % PlayerData.playerName
