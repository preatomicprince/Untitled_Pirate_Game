extends Node2D

@onready var game : Node2D = self.get_parent()
@onready var tick_timer : Timer = $"tick timer"
@onready var building_container : Node2D = $"building container"
@onready var town_tiles : TileMapLayer = $"town tiles"
@onready var building_layer : TileMapLayer = $"building layer"
@onready var sea_layer : TileMapLayer = $"sea layer"

#BUILDING VECS
var tavern : Vector2i = Vector2i(0, 3)
var pier : Vector2i = Vector2i(0, 4)
var fish_monger : Vector2i = Vector2i(0, 5)
var cartographer : Vector2i = Vector2i(0, 6)
var trader : Vector2i = Vector2i(0, 7)
var governers_mansion : Vector2i = Vector2i(0, 8)
var shallows : Vector2i = Vector2i(2, 0)
var deep_water : Vector2i = Vector2i(2, 1)
var forest_tiles : Vector2i = Vector2i(3, 0)



#each section of this que represents a building slot,
#when that slot is filled it will have a function that then gets called 
#when a new map is loaded

var building_que : Array = []
var build_slots : Array = []
var function_list : Array = []




#values related to buildings
var TIME_ADD : float = 5.0
var HEALTH_ADD : float = 5.0
var GOLD_ADD : int = 10
var MULTIPLIER_ADD : float = 0.5
var SHIPS_ADD : int = 3

func _ready():
	pass


func _process(delta: float) -> void:
	###keep the town over the players unit
	if game.player.ships[0] != null:
		self.position = game.player.ships[0].position
##############
#
#	FOR SETTIN TILES
#
#############

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motherload"):
		set_building(costs.buildings.tavern)

func check_ables():
	"""
	goes through your buildings that have passive bonuses and adds them on the timer
	"""
	if costs.defeated == true:
		return
	if costs.infamy > 0:
		costs.infamy -= costs.infamy_decay
		
	if len(costs.current_buildings) == 0:
		print("no buildings")
		return
	print("is it getting here")
	var to_add_gold : int = 0
	var gov_man : bool = false
	var num_heal : int = 0
	
	for b in costs.current_buildings:
		if b == tavern:
			to_add_gold += costs.tavern_add 
		if b == governers_mansion:
			gov_man = true
		if b == fish_monger:
			num_heal += 1
			
	
	if gov_man == true:
		to_add_gold = to_add_gold * 2
	
	costs.gold += to_add_gold
	costs.tot_gold += to_add_gold
	#TODO PUT A MAX HEALTH ON
	if game.player.ships[0].health + num_heal > game.player.ships[0].max_health:
		game.player.ships[0].health = game.player.ships[0].max_health
	else:
		game.player.ships[0].health += num_heal


func set_building(type):
	print(costs.available_land)
	match type:
		costs.buildings.tavern:
			var rand_loc = costs.available_land[randi_range(0, len(costs.available_land)-1)]
			building_layer.set_cell(rand_loc, 0, tavern)
			costs.available_land.pop_at(costs.available_land.find(rand_loc))
			costs.current_buildings.append(tavern)
			
		costs.buildings.pier:
			var rand_loc = costs.available_sea[randi_range(0, len(costs.available_sea)-1)]
			building_layer.set_cell(rand_loc, 0, pier)
			costs.available_sea.pop_at(costs.available_sea.find(rand_loc))
			costs.current_buildings.append(pier)
			
		costs.buildings.fish_monger:
			var rand_loc = costs.available_land[randi_range(0, len(costs.available_land)-1)]
			building_layer.set_cell(rand_loc, 0, fish_monger)
			costs.available_land.pop_at(costs.available_land.find(rand_loc))
			costs.current_buildings.append(fish_monger)
			
		costs.buildings.cartog:
			var rand_loc = costs.available_land[randi_range(0, len(costs.available_land)-1)]
			building_layer.set_cell(rand_loc, 0, cartographer)
			costs.available_land.pop_at(costs.available_land.find(rand_loc))
			costs.current_buildings.append(cartographer)
			
		costs.buildings.trader:
			var rand_loc = costs.available_land[randi_range(0, len(costs.available_land)-1)]
			building_layer.set_cell(rand_loc, 0, trader)
			costs.available_land.pop_at(costs.available_land.find(rand_loc))
			costs.current_buildings.append(trader)
			
		costs.buildings.governer:
			var rand_loc = costs.available_land[randi_range(0, len(costs.available_land)-1)]
			building_layer.set_cell(rand_loc, 0, governers_mansion)
			costs.available_land.pop_at(costs.available_land.find(rand_loc))
			costs.current_buildings.append(governers_mansion)
	
func new_map():
	"""
	this function will be called at the begining to work out what tiles are available to 
	build on
	"""
	#Arrays for available tiles
	for t in town_tiles.get_used_cells():
		if town_tiles.get_cell_atlas_coords(t) != Vector2i(-1, -1):
			if town_tiles.get_cell_atlas_coords(t) != deep_water:
				if town_tiles.get_cell_atlas_coords(t) == shallows:
					costs.available_sea.append(t)
				else:
					costs.available_land.append(t)
	
	for t in town_tiles.get_used_cells():
		if town_tiles.get_cell_atlas_coords(t) == deep_water:
			sea_layer.set_cell(t, 0,deep_water)
		if town_tiles.get_cell_atlas_coords(t) == shallows:
			sea_layer.set_cell(t, 0,shallows)
	#for t in costs.available_sea:
		#building_layer.set_cell(t, 0, Vector2i(1, 7))
	
############
#
#	FUNCTIONS FOR BUILDINGS
#
##############

###########
#
#	SIGNAL FUNCTIONS RELATED TO BUILD SLOTS
#
##########


func _on_tick_timer_timeout() -> void:
	check_ables()
