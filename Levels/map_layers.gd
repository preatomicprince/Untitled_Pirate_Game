extends Node2D
@onready var level = self.get_parent()
@onready var map_layer : TileMapLayer = $"map layer"
@onready var fog_layer : TileMapLayer = $"fog layer"
@onready var nav_region : NavigationRegion2D = $NavigationRegion2D

#preloads for maps and its accociated map layer
@onready var tortuga_map = preload("res://Levels/tortuga_tileset.tres")
@onready var tortuga_nav = preload("res://Levels/tortuga_nav_region.tres")

#TODO set up a function that rolls back fog, and hides ships under the fog

func _ready() -> void:
	set_level_map(level.current_level)

func set_level_map(cur_level : int):
	"""
	this sets the tile map in the map layer, and the nav layer in nav region
	based on what level it is in level
	"""
	match cur_level:
		level.levels.tortuga:
			map_layer.tile_set = tortuga_map
			nav_region.navigation_polygon = tortuga_nav
			print("this might work")
		level.levels.jamaica:
			pass

func set_initial_fog():
	pass
