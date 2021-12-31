extends KinematicBody2D

onready var shot_tscn = preload('res://Objects/Shot.tscn')
onready var smoke_effect_tscn = preload('res://Objects/Effects/Smoke.tscn')

export (int) var speed = 180
var hp:int = 100

var motion:Vector2 = Vector2()
var side:bool = true

var angle_for_shot : float

var muzzle_flash_index = 0

func add_hp(value):
	randomize()
	hp += value
	var blood_effect = preload('res://Objects/Effects/Blood.tscn').instance()
	
	blood_effect.global_position = global_position
	blood_effect.rotation = global_position.angle_to_point(Vector2(rand_range(0, 900), rand_range(0, 900)))
	
	get_parent().add_child(blood_effect)

func play_sound(sound):
	var sound_shot = AudioStreamPlayer2D.new()
	sound_shot.stream = sound
	add_child(sound_shot)
	
	sound_shot.play()

func movement_control(delta):
	# Motion
	motion.x = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))) * speed
	motion.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))) * speed
	
	move_and_slide(motion)

func gun_stuff():
	var mouse_position = get_global_mouse_position()
	angle_for_shot = mouse_position.angle_to_point($Gun.global_position)
	
	$Gun.look_at(mouse_position)
	
	if (global_position.x > mouse_position.x):
		$Gun.scale.y = -2.5
		$Sprite.scale.x = -4
	else:
		$Gun.scale.y = 2.5
		$Sprite.scale.x = 4

func camera_stuff():
	if (Input.is_action_pressed("ui_zoom_out")):
		$Camera2D.zoom = Vector2(3, 3)
	else:
		$Camera2D.zoom = Vector2(1, 1)

func to_push_control():
	if (Input.is_action_just_pressed("ui_to_push")):
		pass

func shoot_control():
	if (Input.is_action_just_pressed("ui_shoot")):
		# Shoot
		var shot = shot_tscn.instance()
		
		shot.position = $Gun/Position2D.global_position
		shot.add_to_group('Shots')
		
		$Gun/Position2D/MuzzleFlash.visible = true
		
		get_parent().add_child(shot)
		
		play_sound(preload('res://Data/Sounds/Shoot Sound.mp3'))
		
		# Smoke Effect
		var mouse_position = get_global_mouse_position()
		var smoke_effect = smoke_effect_tscn.instance()
		smoke_effect.global_position = $Gun/Position2D.global_position
		smoke_effect.rotation = angle_for_shot
		
		get_parent().add_child(smoke_effect)

	else: 
		$Gun/Position2D/MuzzleFlash.visible = false

func get_angle_for_shot():
	return angle_for_shot


func _ready():
	add_to_group('Player')

func _physics_process(delta):
	movement_control(delta)

func _process(delta):
	gun_stuff()
	shoot_control()
	
	if (hp <= 0): visible = false
