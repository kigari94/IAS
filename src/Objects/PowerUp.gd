extends Node2D


onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("PowerUp_Animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	#print(body)
	body.power_up_speed()
	queue_free()
	
