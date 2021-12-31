extends KinematicBody2D

onready var shot_tscn = preload('res://Objects/Shot.tscn')

export (int) var speed = 180

var motion = Vector2()
var side = true

var angle_for_shot : float

var muzzle_flash_index = 0

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

func shoot_control():
	if (Input.is_action_just_pressed("ui_shoot")):
		var shot = shot_tscn.instance()
		
		shot.position = $Gun/Position2D.global_position
		shot.add_to_group('Shots')
		
		$Gun/Position2D/MuzzleFlash.visible = true
		
		get_parent().add_child(shot)
		
		play_sound(preload('res://Data/Sounds/Shoot Sound.mp3'))
		
	else:
		$Gun/Position2D/MuzzleFlash.visible = false

func get_angle_for_shot():
	return angle_for_shot

func _physics_process(delta):
	movement_control(delta)

func _process(delta):
	gun_stuff()
	shoot_control()
