extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		get_tree().quit()


var tutorial_selected : bool = false
#totals

var tot_gold = 0
var tot_dest_ship = 0
var tot_towns_dest = 0
var tot_build_built = 0
#current vars
var gold : int = 0
var infamy : int = 0
var infamy_decay : int = 2
var defeated = false
var ship_destroyed : bool = false

var MAX_INFAMY : int = 100
#gold stuff
var GOLD_TO_WIN : int = 50000

var gold_from_treasure : int = 50
var gold_from_town : int = 200

#infamy stuff
var infamy_attacking_town : int = 10
var infamy_attacking_ship : int = 10

#BUILDING STUFF
var fencer_add = 2
var harbour_add = 2 #a multiplier for sunk ships
var tavern_add = 100

#BUILDING COSTS
var tav_cost : int = 200
var fish_cost : int = 80
var pier_cost : int = 80
var trader_cost : int = 80
var gov_cost : int = 1000
var map_cost : int = 100

#TOWN TILES
var town_tiles : Array = []

enum buildings {
	tavern,
	pier,
	fish_monger,
	cartog,
	trader,
	governer
}

#max number for buildings
var CART_BUILT : bool = false
var GOV_BUILT : bool = false

#Arrays for available tiles
var available_land : Array = []
var available_sea : Array = []
var current_buildings : Array = []

func reset():
	tot_gold = 0
	tot_dest_ship = 0
	tot_towns_dest = 0
	tot_build_built = 0
	gold  = 0
	infamy  = 0
	defeated = false
	ship_destroyed = false
	town_tiles = []
	CART_BUILT = false
	GOV_BUILT = false
	available_land = []
	available_sea = []
	current_buildings = []
