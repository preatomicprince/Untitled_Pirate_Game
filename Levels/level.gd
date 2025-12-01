class_name Level extends Node2D

@onready var wave = load("res://Levels/wave.tscn")
@onready var game = get_parent()
@onready var player = $"../Player"
@onready var map_layers : Node2D = $"map layers"
@onready var town_layer : Node2D =$"map layers/town layer"
@onready var ship_layer : Node2D = $"ship layer"
#set current level with an enum
enum levels {
	none = 0,
	tortuga = 1,
	jamaica = 2,
	cuba,
	virginia,
	florida,
	
}

var gold_rec_per_level : Dictionary = {levels.tortuga : 100, levels.jamaica : 200, levels.cuba : 300, levels.virginia : 400}

var current_level : int = levels.tortuga

var enemy_ships: Array = []

enum wind_dirs {
	NORTH_EAST,
	SOUTH_EAST,
	SOUTH_WEST,
	NORTH_WEST
}
var wind_dir : int 

func _ready() -> void:
	if costs.tutorial_selected == true:
		$"tut text".visible = true

func reload_map():
	map_layers.reload_map()
	game.gold_target = gold_rec_per_level[current_level]

func send_waves():
	"""
	
	"""
	if costs.defeated == true:
		return
	var random_point = Vector2(
		randi_range(game.player.ships[0].position[0]-100, game.player.ships[0].position[0]+100),  
		randi_range(game.player.ships[0].position[1]-100, game.player.ships[0].position[1]+100)    
	)
	var water_cells = map_layers.water_layer.get_used_cells()
	var random_tile = water_cells[randi_range(0, len(water_cells)-1)]
	
	var target = NavigationServer2D.map_get_closest_point(map_layers.nav_region, map_layers.water_layer.map_to_local(random_tile))
	var new_wave = wave.instantiate()
	new_wave.position = map_layers.water_layer.map_to_local(random_tile)

	self.add_child(new_wave)


func change_wind_dir():
	pass

func _on_wave_timer_timeout() -> void:
	send_waves()

func reveal_towns():
	"""
	reveals all the towns, called when placing a map 
	"""

	for b in map_layers.tortuga_layer.get_used_cells():
		if map_layers.tortuga_layer.get_cell_atlas_coords(b) in map_layers.TOWN_VECS:
			map_layers.fog_layer.set_cell(b, 0, Vector2i(-1, -1))



func _on_wind_timer_timeout() -> void:
	pass # Replace with function body.
