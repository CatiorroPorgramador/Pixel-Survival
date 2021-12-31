extends KinematicBody2D

var hp:int = 100
var speed:int = 40

var angle_to_walk:float

var motion = Vector2()

func add_hp(value):
	hp += value
	$ProgressBar.value = hp

func walk_to_target():
	angle_to_walk = get_parent().get_node('Player').global_position.angle_to_point(global_position)
	
	motion = Vector2(100, 0).rotated(angle_to_walk)
	
	move_and_slide(motion)


func _ready():
	add_to_group('Zombies')

func _process(delta):
	if (hp <= 0): queue_free()
	
	if (global_position.x > get_parent().get_node('Player').global_position.x): $Sprite.scale.x = -4
	else: $Sprite.scale.x = 4

func _physics_process(delta):
	walk_to_target()
