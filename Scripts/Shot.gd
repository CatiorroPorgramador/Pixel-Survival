extends Area2D

export (int) var speed = 3000
export (int) var hp = 200

var motion = Vector2()

func _ready():
	motion = Vector2(speed, 0).rotated(get_parent().get_node('Player').get_angle_for_shot())
	
func _physics_process(delta):
	position += motion * delta

func _on_Shot_body_entered(body):
	if (body.is_in_group('Zombies')):
		body.add_hp(
			-get_parent().get_node('Player').inventory[get_parent().get_node('Player').actually_item].damage
		)
		
		randomize()
		if (rand_range(0, 10) > 5):
			queue_free()
	
	elif (body.is_in_group('Boxes')):
		body.queue_free()
		queue_free()
	
	elif (body is TileMap):
		var mouse_position = get_global_mouse_position()
		print(get_parent().get_node(body.name).tile_set.tile_get_name(
			get_parent().get_node(body.name).get_cell(int(global_position.x/64), int(global_position.y/64)))
		)
		
		print(body.name)
		queue_free()
	
func _on_Timer_timeout():
	queue_free()
