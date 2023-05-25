extends Actor

export var weapon_scene_path: = "res://src/Objects/Weapon.tscn"
export(NodePath) var camera
var main_camera =  null
var player_weapon = null
var input_enabled = true



func _ready() -> void:
	var weapon_instance = load(weapon_scene_path).instance()
	var weapon_anchor = $WeaponSpawnLocation/WeaponAnchorPoint
	weapon_anchor.add_child(weapon_instance)
	player_weapon = weapon_anchor.get_child(0)
	#player_weapon.connect("attack_finished", self, "on_player_weapon_attack_finished")
	main_camera = get_node(camera)


func _on_DangerDetector_area_entered(body: PhysicsBody2D) -> void:
	die()

# Godot function that handels physics calculations, it is called every frame
func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	facing_direction(direction.x)
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and input_enabled == true: #and _current_state != _STATES.ATTACK:
		#_current_state = _STATES.ATTACK
		player_weapon.attack()
		
#func on_player_weapon_attack_finished() -> void:
	#_current_state = _STATES.IDLE

# Calculating a Vector2, from the user inputs, as direction value for the player 
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)

# Calculating a Vector2 from given linear velocity, direction and speed as velocity value for the player
# handeling no move in case of death
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	if input_enabled == true:
		velocity.x = speed.x * direction.x
		if direction.y != 0.0:
			velocity.y = speed.y * direction.y
		if is_jump_interrupted:
			velocity.y = 0.0
	else: 
		velocity = Vector2(0,0) 
	return velocity
	
func die() -> void:
	input_enabled = false
	$Timer.start()
	main_camera.set_target(2)
	#TODO Death animation


func _on_Timer_timeout():
	respawn()
	
func respawn_position():
#TODO: need to finde a way to calculate a good respawn position
	var new_position = Vector2()
	var old_position = self.position
	new_position.x = old_position.x - 2000
	new_position.y = old_position.y - 2000
	return  new_position
	

func respawn() -> void :
	#TODO Respawn animation
	input_enabled = true
	self.position = respawn_position()
	
#func on_player_weapon_attack_finished() -> void:
	#_current_state = _STATES.IDLE
	
func get_move_direction() ->Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		0.0 
	)
func facing_direction(direction: float) -> void:
	if direction > 0.0:
		$WeaponSpawnLocation.scale.x = 1.0
	elif direction < 0.0:
		$WeaponSpawnLocation.scale.x = -1.0
	
