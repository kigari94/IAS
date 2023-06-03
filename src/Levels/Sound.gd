extends Node


var backgroundSound: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	backgroundSound = AudioStreamPlayer.new()
	add_child(backgroundSound)
	backgroundSound.stream = preload("res://assets/Sounds/background_music/short-chill-music-8561 (mp3cut.net).mp3")
	backgroundSound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass