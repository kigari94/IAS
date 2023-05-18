extends Node

signal player_name

var playerName: = "" setget set_name

func set_name(value: String) -> void:
	playerName = value
	emit_signal("playerName")

