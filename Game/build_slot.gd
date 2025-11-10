extends TextureButton

@onready var town_main : Node2D = $"../.."
@onready var building_ims = preload("res://Game/buildings.tscn")

@export var on_coast : bool = false

var building_here : bool = false
var slot_selected : bool = false

func create_building(build_type: int):
	"""
	called in the town ui, adds a building over this slot
	"""
	#create the building instance
	var building_instance = building_ims.instantiate()
	building_instance.frame = build_type
	building_instance.position = self.position
	town_main.building_container.add_child(building_instance)
	
	town_main.building_que[self.get_parent().get_children().find(self)] = town_main.function_list[build_type]
	print(town_main.building_que)
	self.building_here = true
	self.visible = false
