extends Control

onready var music: AudioStreamPlayer = get_node("ColorRect/AudioStreamPlayer")

func _ready():
	music.play()

func _on_MasterVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
