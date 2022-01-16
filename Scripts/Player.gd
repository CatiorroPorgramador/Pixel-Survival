extends KinematicBody2D

onready var shot_tscn = preload('res://Objects/Shot.tscn')
onready var smoke_effect_tscn = preload('res://Objects/Effects/Smoke.tscn')

export (int) var speed = 180
var hp:int = 100
var kills:int = 0

var aiming_mode:bool = false

var inventory = []
var actually_item = 1
var shot_speed = null

var motion:Vector2 = Vector2()
var side:bool = true

var angle_for_shot : float

var muzzle_flash_index = 0

func update_bar_life():
	$BarLife.value = hp

func add_hp(value):
	print('tomei')
	randomize()
	hp += value
	var blood_effect = preload('res://Objects/Effects/Blood.tscn').instance()
	
	blood_effect.global_position = global_position
	blood_effect.rotation = global_position.angle_to_point(Vector2(rand_range(0, 900), rand_range(0, 900)))
	
	get_parent().add_child(blood_effect)
	
	update_bar_life()
	print(hp)

func add_kills(value):
	kills += value

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

func inventory_control():
	if (Input.is_action_just_pressed("ui_1")):
		actually_item = 0
		change_item(actually_item)
	
	elif (Input.is_action_just_pressed("ui_2")):
		actually_item = 1
		change_item(actually_item)
	
	elif (Input.is_action_just_pressed("ui_3")):
		actually_item = 2
		change_item(actually_item)
	
	elif (Input.is_action_just_pressed("ui_4")):
		actually_item = 3
		change_item(actually_item)

func to_push_control():
	if (Input.is_action_just_pressed("ui_to_push")):
		pass

func shoot_control():
	if (Input.is_action_just_pressed("ui_shoot") and (inventory[actually_item].type == 'gun')):
		# Shoot
		var shot = shot_tscn.instance()
		
		shot.position = $Gun/Position2D.global_position
		shot.speed = shot_speed

		shot.add_to_group('Shots')
		
		get_parent().add_child(shot)
		
		$Gun/Position2D/MuzzleFlash.visible = true
		#play_sound(preload('res://Data/Sounds/Shoot Sound.mp3'))
		
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

func change_item(item):
	$Gun.frame = inventory[item]['frame']
	shot_speed = inventory[item]['speed']
	get_parent().update_inventory()

func add_item(item):
	pass

func _ready():
	add_to_group('Player')
	for i in range(0, 4):
		inventory.append(get_parent().items['null'])

func _physics_process(delta):
	movement_control(delta)

func _process(delta):
	gun_stuff()
	shoot_control()
	inventory_control()
