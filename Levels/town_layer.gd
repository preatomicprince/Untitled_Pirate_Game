extends Node2D

@onready var town = preload("res://Levels/town.tscn")

var town_cells : Array[Vector2i] = [Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2)]


func reload_map():
	spawn_towns(self.get_parent().map_layer)

func clear_towns():
	"""
	so that towns dont carry over map to map
	"""
	for child in self.get_children():
		child.queue_free()

func spawn_towns(tile_layer : TileMapLayer):
	"""
	takes the tile layer and places towns in the appropriate places
	"""
	for t in tile_layer.get_used_cells():
		if tile_layer.get_cell_atlas_coords(t) in town_cells:
			var town_instance = town.instantiate()
			var world_pos = tile_layer.map_to_local(t)
			town_instance.position = world_pos
			self.add_child(town_instance)

func destroy_town(pos):
	var town_loc = self.get_parent().map_layer.local_to_map(pos)
	if self.get_parent().map_layer.get_cell_atlas_coords(town_loc) == town_cells[1]:
		self.get_parent().map_layer.set_cell(town_loc, 0, Vector2i(3, 1))
		
	if self.get_parent().map_layer.get_cell_atlas_coords(town_loc) == town_cells[2]:
		self.get_parent().map_layer.set_cell(town_loc, 0, Vector2i(3, 2))
