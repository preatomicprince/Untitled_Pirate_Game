extends Node2D
@onready var level = self.get_parent()
@onready var map_layer : TileMapLayer 
@onready var tortuga_layer : TileMapLayer = $"tortuga layer"
@onready var jamaica_layer : TileMapLayer = $"jamaica layer"
@onready var fog_layer : TileMapLayer = $"fog layer"
@onready var nav_region : NavigationRegion2D = $NavigationRegion2D

var layer_array : Array 
#vectors for the fog of war
var UNEXPLORED_VEC : Vector2i = Vector2i(4, 1)
var SHADOW_VEC : Vector2i = Vector2i(1, 1)
#preloads for maps and its accociated map layer
#TORTUGA
@onready var tortuga_nav = preload("res://Levels/tortuga_nav_region.tres")

#JAMAICA
@onready var jamaica_nav = preload("res://Levels/jamaica_nav_region.tres")
#TODO set up a function that rolls back fog, and hides ships under the fog

func _ready() -> void:
	layer_array = [tortuga_layer, jamaica_layer]
	set_level_map(level.current_level)
	set_initial_fog()

func _process(delta: float) -> void:
	update_fog()

#############
#
#	Fog updates
#
##########
func update_fog():
	"""
	this takes the position of the players boats and determins if fog 
	should be removed or not
	"""
	var player_ships = level.player.ships
	
	#just a stop gap so we dont go breaking the game trying to find the location of a dead list
	if len(player_ships) == 0:
		return
	var saved_tiles : Array = []
	var second_saved_tiles : Array = []
	for s in player_ships:
		#get the tile surrounding
		for t in fog_layer.get_surrounding_cells(fog_layer.local_to_map(s.position)):
			saved_tiles.append(t)
		
		#get the tiles surrounding the ones above for another layer
		for t in saved_tiles:
			for tt in fog_layer.get_surrounding_cells(t):
				if tt not in saved_tiles:
					second_saved_tiles.append(tt)
	
	#iterate through saved tile to reveal them
	for t in saved_tiles+second_saved_tiles:
		fog_layer.set_cell(t, 0, Vector2i(-1, -1))
	
	for t in map_layer.get_used_cells():
		if fog_layer.get_cell_atlas_coords(t) == Vector2i(-1, -1) and t not in saved_tiles+second_saved_tiles:
			fog_layer.set_cell(t, 0, SHADOW_VEC)

##############
#
#	SET INTIAL MAP STUFF
#
################
func set_level_map(cur_level : int):
	"""
	this sets the tile map in the map layer, and the nav layer in nav region
	based on what level it is in level
	"""
	match cur_level:
		level.levels.tortuga:
			map_layer = tortuga_layer
			nav_region.navigation_polygon = tortuga_nav
			
		level.levels.jamaica:
			map_layer = jamaica_layer
			nav_region.navigation_polygon = jamaica_nav
	
	for l in layer_array:
		if map_layer == l:
			l.visible = true
		else:
			l.visible = false
			
func set_initial_fog():
	for t in map_layer.get_used_cells():
		fog_layer.set_cell(t, 0, UNEXPLORED_VEC)
