extends Node2D

@onready var game : Node2D = self.get_parent()
@onready var slot_container : Node2D = $"slot container"
@onready var building_container : Node2D = $"building container"
#TODO proper land

#each section of this que represents a building slot,
#when that slot is filled it will have a function that then gets called 
#when a new map is loaded

var building_que : Array = []
var build_slots : Array = []
var function_list : Array = []

enum buildings {
	map_maker = 0,
	sextant = 1,
	fishmonger,
	rum_dist,
	fencer,
	tavern,
}

#values related to buildings
var TIME_ADD : float = 5.0
var HEALTH_ADD : float = 5.0
var GOLD_ADD : int = 10
var MULTIPLIER_ADD : float = 0.5
var SHIPS_ADD : int = 3

func _ready():
	#set up the order que based on how many building slots
	#and build slots
	for c in range(0, len(slot_container.get_children())):
		building_que.append(null)
	#set up the build slots
	build_slots = slot_container.get_children()
	
	function_list = [map_maker, sextanter, fishmonger, rum_distiler, harbour, fencer, tavern]

	
func new_map():
	"""
	this function will be called when the map resets during a run,
	"""
	#for ship
	game.player.maximum_number_of_ships = game.player.STARTING_NUM_SHIPS
	#this is for the bootlegger buildins, so we dont have compounding bonuses
	game.player.sell_item_multiplier = game.player.STARTING_MULTIPLIER
	#set a base time in case the people have a map maker
	game.time_left = game.STARTING_TIME_LEFT
	for f in building_que:
		if f != null:
			f.call()
	
	game.timer.start(game.time_left)
	
############
#
#	FUNCTIONS FOR BUILDINGS
#
##############

func map_maker():
	"""
	goes through the tile maps used and reveals relevant tiles
	"""
	for t in game.level.map_layers.map_layer.get_used_cells():
		if game.level.map_layers.map_layer.get_cell_atlas_coords(t) in game.level.map_layers.town_layer.town_cells:
			game.level.map_layers.fog_layer.set_cell(t, 0, Vector2i(-1, -1))
	print("map maker")
	
func sextanter():
	"""
	adds time to the timer
	"""
	game.time_left += TIME_ADD
	print("sextanter")
	
func fishmonger():
	"""
	loops over the players ships and adds health
	"""
	for s in game.player.ships:
		s.health += HEALTH_ADD
	print("fishmonger")
	
func rum_distiler():
	"""
	
	"""
	print("rum baybe")
	
func harbour():
	"""
	adds more ships to maximum ships
	"""
	game.player.maximum_number_of_ships += SHIPS_ADD
	
func fencer():
	"""
	more gold on selling shit, cant implement until the other stuff is in place
	"""
	game.player.sell_item_multiplier += MULTIPLIER_ADD
	
func tavern():
	"""
	adds gold to the player each time they boot up a level
	"""
	game.player.gold += GOLD_ADD


###########
#
#	SIGNAL FUNCTIONS RELATED TO BUILD SLOTS
#
##########

func _on_build_slot_pressed() -> void:
	game.ui.town_ui.build_options(build_slots[0])
	for c in build_slots:
		c.slot_selected = false
	
	build_slots[0].slot_selected = true


func _on_build_slot_2_pressed() -> void:
	game.ui.town_ui.build_options(build_slots[1])
	for c in build_slots:
		c.slot_selected = false
	
	build_slots[1].slot_selected = true


func _on_build_slot_3_pressed() -> void:
	game.ui.town_ui.build_options(build_slots[2])
	for c in build_slots:
		c.slot_selected = false
	
	build_slots[2].slot_selected = true


func _on_build_slot_4_pressed() -> void:
	game.ui.town_ui.build_options(build_slots[3])
	for c in build_slots:
		c.slot_selected = false
	
	build_slots[3].slot_selected = true


func _on_build_slot_5_pressed() -> void:
	game.ui.town_ui.build_options(build_slots[4])
	for c in build_slots:
		c.slot_selected = false
	
	build_slots[4].slot_selected = true


func _on_build_slot_6_pressed() -> void:
	game.ui.town_ui.build_options(build_slots[5])
	for c in build_slots:
		c.slot_selected = false
	
	build_slots[5].slot_selected = true
