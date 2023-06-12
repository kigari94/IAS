extends Node

signal playerName
signal playerOneActive
signal countDownActive

var playerName: = "" setget set_name
var playerOneActive: bool = true setget set_active
var countDownActive: bool = true setget set_countdown

func set_name(value: String) -> void:
	playerName = value
	emit_signal("playerName")

func set_active(value: bool) -> void:
	playerOneActive = value
	emit_signal("playerOneActive")
	
func set_countdown(value: bool) -> void:
	countDownActive = value
	emit_signal("countDownActive")
