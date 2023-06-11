extends Control

onready var scene_tree: = get_tree()
onready var timer: Timer = get_node("Timer")
onready var counter: Label = get_node("Overlay/Counter")
onready var overlay: ColorRect = get_node("Overlay")

var time: int
var gameStarted: bool = false

func _process(_delta)-> void:
	if !gameStarted:
		showOverlay()

func pause(value)-> void:
	scene_tree.paused = value
	print(value)

func showOverlay()-> void:
	pause(true)
	time = timer.time_left
	counter.text = str(time)
	if time == 0:
		pause(false)
		overlay.visible = false
		gameStarted = true
