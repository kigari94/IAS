extends Node


var backgroundSound: AudioStreamPlayer
var effect = AudioServer.get_bus_effect(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	backgroundSound = AudioStreamPlayer.new()
	backgroundSound.bus = "Music"
	add_child(backgroundSound)
	backgroundSound.stream = preload("res://assets/Sounds/background_music/short-chill-music-8561 (mp3cut.net).mp3")
	backgroundSound.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	
#if progress > 1000 or progress < -1000:
#	 effect.cutoff_hz = 500
