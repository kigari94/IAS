extends Node

signal playerName
signal playerOneActive

var playerName: = "" setget set_name
var playerOneActive: bool = true setget set_active

func set_name(value: String) -> void:
	playerName = value
	emit_signal("playerName")

func set_active(value: bool) -> void:
	playerOneActive = value
	emit_signal("playerOneActive")
