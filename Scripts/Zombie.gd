extends KinematicBody2D

var hp:int = 100
var speed:int = 80
var index:int = 0

var angle_to_walk:float

var motion = Vector2()
var collider

func add_hp(value):
	hp += value
	speed -= 20
	$ProgressBar.value = hp
	
	var blood_effect = preload('res://Objects/Effects/Blood.tscn').instance()
	
	blood_effect.global_position = global_position
	blood_effect.rotation = global_position.angle_to_point(get_parent().get_node('Player').global_position)
	
	get_parent().add_child(blood_effect)

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

func _process(delta):
	if (hp <= 0): queue_free()
	
	if (global_position.x > get_parent().get_node('Player').global_position.x): $Sprite.scale.x = -4
	else: $Sprite.scale.x = 4

func _physics_process(delta):
	walk_to_target(delta)

func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play('idle')
	if (collider and collider.collider.name == 'Player'):
		get_parent().get_node('Player').add_hp(-40)
