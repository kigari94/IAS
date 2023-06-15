extends Actor

export var weapon_scene_path: = "res://src/Objects/Weapon.tscn"
export(NodePath) var camera

export var boost_speed = 3000

var main_camera =  null
var player_weapon = null
var input_enabled = true
var screen_position = null

onready var animation = $AnimationPlayer
onready var ray = $RayCastDown


var jumpSound: AudioStreamPlayer
var punchSound: AudioStreamPlayer
var deathSound: AudioStreamPlayer
var respawnSound: AudioStreamPlayer

func _ready() -> void:
	# Sound init	
	jumpSound = AudioStreamPlayer.new()
	jumpSound.bus = "Sounds"
	add_child(jumpSound)
	#jumpSound.stream = preload("res://assets/Sounds/pop.wav")
	jumpSound.stream = preload("res://assets/Sounds/JUMP/cartoon-jump-6462.mp3")
	
	punchSound = AudioStreamPlayer.new()
	punchSound.bus = "Sounds"
	add_child(punchSound)
	punchSound.stream = preload("res://assets/Sounds/FIGHT/punch-2-37333.mp3")
	
	deathSound = AudioStreamPlayer.new()
	deathSound.bus = "Sounds"
	add_child(deathSound)
	deathSound.stream = preload("res://assets/Sounds/TRAPS/negative_beeps-6008.mp3")
	
	respawnSound = AudioStreamPlayer.new()
	respawnSound.bus = "Sounds"
	add_child(respawnSound)
	respawnSound.stream = preload("res://assets/Sounds/JUMP/dramatic-sound-effect-01-144470_RESPAWN.mp3")

	#player_weapon.connect("attack_finished", self, "on_player_weapon_attack_finished")
	main_camera = get_node(camera)


func _on_DangerDetector_area_entered(_body: PhysicsBody2D) -> void:
	die()

# Godot function that handels physics calculations, it is called every frame
func _physics_process(_delta: float) -> void:
	death_out_of_screen()
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	facing_direction(direction.x)
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(_velocity, snap, FLOOR_NORMAL, true)
	
	if direction == Vector2(0,0) and _current_state != _STATES.ATTACK and _current_state != _STATES.DEATH:
		_current_state = _STATES.IDLE
	
	if _current_state == _STATES.IDLE and self.is_on_floor():
		animation.play("Idle_Animation")

	# Jump Animation + play jump sound
	if direction.y < 0 and _current_state != _STATES.ATTACK:
		animation.play("Jump_Animation")
		jumpSound.play()
		
				
	# Run Animation
	if ((direction.x < 0 or direction.x > 0) and _current_state != _STATES.ATTACK and _current_state != _STATES.DEATH and self.is_on_floor()):
		#print("run")
		_current_state = _STATES.MOVE
		animation.play("Run_Animation")
		
	# Higher run speed as hunter
	if PlayerData.playerOneActive == false:
		speed.x = boost_speed
	else:
		speed.x = 3000
	
	# Raycast for Ground detection
	#print(ray.is_colliding()," Point: ", ray.get_collision_point(),"Normal: ", ray.get_collision_normal(), " Collider: ", ray.get_collider())
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and input_enabled == true and _current_state != _STATES.ATTACK:
		_current_state = _STATES.ATTACK
		var weapon_instance = load(weapon_scene_path).instance()
		var weapon_anchor = $WeaponSpawnLocation/WeaponAnchorPoint
		weapon_anchor.add_child(weapon_instance)
		player_weapon = weapon_anchor.get_child(0)
		player_weapon.attack()
	# Fight Animation + play fight sound
		animation.play("Fight_Animation_2")
		punchSound.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	#print(anim_name)
	if anim_name == "Fight_Animation_2":
		#print("fight end")
		player_weapon.queue_free()
		_current_state = _STATES.IDLE
	if anim_name == "Run_Animation":
		#print("run_end")
		_current_state = _STATES.IDLE
	if anim_name == "Idle_Animation":
		pass
		#print("Idle end")

		
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
	_current_state = _STATES.DEATH
	$Timer.start()

	if name == "Player":
		main_camera.set_target(2)
		PlayerData.playerOneActive = false
	elif name == "Player2":
		main_camera.set_target(1)
		PlayerData.playerOneActive = true
	#TODO Death animation
	animation.play("Death_Animation")
	deathSound.play()

func _on_Timer_timeout():
	respawn()
	
func respawn_position():
#TODO: need to finde a way to calculate a good respawn position
	var new_position = Vector2()
	screen_position = main_camera.get_position()

	if name == "Player":
		new_position.x = screen_position.x - 6000 
	elif name == "Player2":
		new_position.x = screen_position.x + 6000 
	new_position.y = screen_position.y - 3000
	return  new_position
	
func respawn() -> void :
	#TODO Respawn animation
	# play respawn sound
	var new_position = respawn_position()
	respawnSound.play()
	self.position = Vector2(new_position.x ,new_position.y)
	ray.force_raycast_update()
	#print(ray.get_collider(), ray.get_collision_point())
	print(ray.get_collision_point().y - self.position.y)
	if ray.get_collider() == null:
		new_position.x += 1000 
		self.position = Vector2(new_position.x ,new_position.y)

		#print(abs(ray.get_collision_point().y - self.position.y))
	ray.force_raycast_update()
	print("collision point: ",ray.get_collision_point().y," - player position: ",self.position.y)
	while abs(ray.get_collision_point().y - self.position.y)  < 512:
		ray.force_raycast_update()

		#print(abs(ray.get_collision_point().y - self.position.y))
		new_position.y += 128 
		self.position = Vector2(new_position.x ,new_position.y)
	input_enabled = true
	_current_state = _STATES.IDLE

	
func facing_direction(direction: float) -> void:
	if direction > 0.0 and input_enabled:
		#$WeaponSpawnLocation.scale.x = 1.0
		self.scale.x = self.scale.y * 1 
	elif direction < 0.0 and input_enabled:
		#$WeaponSpawnLocation.scale.x = -1.0
		self.scale.x = self.scale.y * -1 

func death_out_of_screen() -> void:
	screen_position = main_camera.get_position()
	if screen_position.x + 7100 < self.get_position().x and _current_state != _STATES.DEATH:
		die()
