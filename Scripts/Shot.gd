extends Area2D

export (int) var speed = 3500

var motion = Vector2()

func _ready():
	motion = Vector2(speed, 0).rotated(get_parent().get_node('Player').get_angle_for_shot())
	
func _physics_process(delta):
	position += motion * delta
	rotate(90)


func _on_Shot_body_entered(body):
	if (body.is_in_group('Shots')):
		body.queue_free()
	
	elif (body.is_in_group('Zombies')):
		body.add_hp(-40)
	
	queue_free()
