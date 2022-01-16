extends Node2D

export (int) var _round = 1
export (bool) var in_round = true

var live_zombies = 0
var zombie_scoreboard = 0

onready var zombie_tscn = preload("res://Objects/Zombie.tscn")
var zombie_spawn_level:float = 1
var zombie_spawn_index:int = 0

var items = {
	'null' : {
		'frame': 14,
		'speed': 0,
		'damage': null,
		'type': 'null',
	},
	
	'rifle': {
		'frame': 1,
		'speed': 3000,
		'damage': 40,
		'type': 'gun'
	},
	
	'pistol': {
		'frame': 0,
		'speed': 2000,
		'damage': 20,
		'type': 'gun'
	},
	
	'medic kit': {
		
	}
}

const spawner_positions = [
	Vector2(470, -300), # up 
	Vector2(470, 900), # down
	Vector2(-500, 290), # left
	Vector2(1400, 290), # right
]

func update_round(value):
	_round += value
	$'Interface/Counters/Round Counter'.text = "Round: " + str(_round)

func add_zombie_counter(value):
	live_zombies += value
	$'Interface/Counters/Zombie Scoreboard'.text = str(live_zombies) + "/" + str(zombie_scoreboard)

func spawn_control():
	if (in_round):
		randomize()
		for i in range(1, int(rand_range(_round+2, _round*3))):
			print(i)
			randomize()
			
			live_zombies += 1
			zombie_scoreboard = live_zombies
			$'Interface/Counters/Zombie Scoreboard'.text = str(live_zombies) + "/" + str(zombie_scoreboard)
			randomize()
			var zombie = zombie_tscn.instance()
			
			zombie.position = spawner_positions[rand_range(0, len(spawner_positions))] - Vector2(int(rand_range(-300, 300)), int(rand_range(-300, 300)))
			add_child(zombie)
			in_round = false
	
	else:
		if (live_zombies <= 0):
			update_round(1)
			in_round = true
	
	zombie_spawn_index += zombie_spawn_level

func update_inventory():
	var i = 1
	
	for item in get_node('Player').inventory:
		get_node('Interface/Inventory/Slot'+str(i)+str('/Item')).texture = preload('res://Data/Sprites/Weapons Sprite Sheet.png')
		get_node('Interface/Inventory/Slot'+str(i)+str('/Item')).scale = Vector2(0.2, 0.2)
		get_node('Interface/Inventory/Slot'+str(i)+str('/Item')).rotation = 45
		
		get_node('Interface/Inventory/Slot'+str(i)+str('/Item')).hframes = get_node('Player/Gun').hframes
		get_node('Interface/Inventory/Slot'+str(i)+str('/Item')).vframes = get_node('Player/Gun').vframes
	
		get_node('Interface/Inventory/Slot'+str(i)+str('/Item')).frame = item['frame']
		
		i += 1

func inventory_control():
	get_node('Player').inventory[0] = items['pistol']
	get_node('Player').inventory[1] = items['rifle']
	get_node('Player').change_item(1)
	
func _ready():
	update_round(0)
	inventory_control()
	update_inventory()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	spawn_control()
