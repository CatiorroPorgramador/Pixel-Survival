extends KinematicBody2D

const types = {
	'Simple Zombie': {
		'texture': preload('res://Data/Sprites/Zombies/Simple Zombie Sprite Sheet.png'),
		'hframes': 4,
		'hp': 100,
		'vframes': 0,
		'damage': [-30, -40],
		'speed': 80,
	},
	'Bricklayer Zombie': {
		'texture': preload('res://Data/Sprites/Zombies/Bricklayer Zombie Sprite Sheet.png'),
		'hframes': 4,
		'hp': 140,
		'vframes': 0,
		'damage': [-50, -60],
		'speed': 40,
	},
	'Policeman Zombie': {
		'texture': preload('res://Data/Sprites/Zombies/Policeman Zombie Sprite Sheet.png'),
		'hframes': 4,
		'hp': 100,
		'vframes': 0,
		'damage': [-50, -60],
		'speed': 100,
	}
}

var hp:int = 100
var speed:int = 80
var index:int = 0

export (int) var damage = -40

var angle_to_walk:float

var motion = Vector2()
var collider

func add_hp(value):
	hp += value
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)
	
	var blood_effect = preload('res://Objects/Effects/Blood.tscn').instance()
	
	blood_effect.global_position = global_position
	blood_effect.rotation = global_position.angle_to_point(get_parent().get_node('Player').global_position)
	
	get_parent().add_child(blood_effect)

func set_type(type):
	$Sprite.texture = type['texture']
	$Sprite.hframes = type['hframes']
	hp = type['hp']
	$Sprite.vframes = type['vframes']
	damage = type['damage']
	speed = type['speed']
	
	update_porgress_bar()

func update_porgress_bar():
	$ProgressBar.value = hp
	$ProgressBar/Label.text = str(hp)

func when_to_die():
	get_parent().get_node('Player').add_kills(1)
	get_parent().add_zombie_counter(-1)
	queue_free()

func walk_to_target(delta):
	angle_to_walk = get_parent().get_node('Player').global_position.angle_to_point(global_position)
	
	motion = Vector2(speed, 0).rotated(angle_to_walk)
	
	collider = move_and_collide(motion*delta)
	
	if (collider):
		if (collider.collider.name == 'Player'):
			index += 1
			
			if (index > 5):
				$AnimationPlayer.play('attack')
				index = 0


func _ready():
	add_to_group('Zombies')
	set_type(types['Policeman Zombie'])
	
	update_porgress_bar()
	
	print($ProgressBar.value)

func _process(delta):
	if (hp <= 0):
		when_to_die()
	
	if (global_position.x > get_parent().get_node('Player').global_position.x): $Sprite.scale.x = -4
	else: $Sprite.scale.x = 4

func _physics_process(delta):
	walk_to_target(delta)

func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play('idle')
	if (collider and collider.collider.name == 'Player'):
		# hit player
		get_parent().get_node('Player').add_hp(
			int(rand_range(damage[0], damage[1]))
		)
