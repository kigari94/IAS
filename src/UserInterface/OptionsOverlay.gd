extends Control

onready var music: AudioStreamPlayer = get_node("ColorRect/AudioStreamPlayer")
onready var masterDisplay = get_node("ColorRect/MasterVolume/MasterDisplay")
onready var musicDisplay = get_node("ColorRect/MusicVolume/MusicDisplay")
onready var soundsDisplay = get_node("ColorRect/SoundsVolume/SoundsDisplay")

func _ready():
	music.play()

func _on_MasterVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	masterDisplay.text = str(100 - ((value / (-50)) * 100)) 


func _on_MusicVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	musicDisplay.text = str(100 - ((value / (-50)) * 100))


func _on_SoundsVolume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), value)
	soundsDisplay.text = str(100 - ((value / (-50)) * 100))
