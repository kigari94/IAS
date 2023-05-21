extends Actor


#export var stomp_impulse: = 600.0

func _on_DangerDetector_area_entered(area):
	die()

# Godot function that handels physics calculations, it is called every frame
func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump_p2") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)

# Calculating a Vector2, from the user inputs, as direction value for the player 
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right_p2") - Input.get_action_strength("move_left_p2"),
		-Input.get_action_strength("jump_p2") if is_on_floor() and Input.is_action_just_pressed("jump_p2") else 0.0
	)

# Calculating a Vector2 from given linear velocity, direction and speed as velocity value for the player
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity
	
# not in use for now
#
#func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
#	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
#	return Vector2(linear_velocity.x, stomp_jump)
#
#
func die() -> void:
	queue_free()

