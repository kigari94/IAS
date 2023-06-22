extends Control

onready var scene_tree: = get_tree()
onready var timer: Timer = get_node("Timer")
onready var counter: Label = get_node("Overlay/Counter")
onready var overlay: ColorRect = get_node("Overlay")

var countdownSound: AudioStreamPlayer
var time: int

func _ready():
	countdownSound = AudioStreamPlayer.new()
	countdownSound.bus = "Music"
	add_child(countdownSound)
	countdownSound.stream = preload("res://assets/Sounds/EFFEKT/arcade-countdown.wav")
	countdownSound.play()

func _process(_delta)-> void:
	if PlayerData.countDownActive:
		showOverlay()

func pause(value)-> void:
	scene_tree.paused = value

func showOverlay()-> void:
	pause(true)
	
	time = timer.time_left
	counter.text = str(time)
	if time == 0:
		pause(false)
		overlay.visible = false
		PlayerData.countDownActive = false
		timer.stop()
