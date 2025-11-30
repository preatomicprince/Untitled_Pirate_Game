extends Node

#current vars
var gold : int = 0
var infamy : int = 0

var ship_destroyed : bool = false

var MAX_INFAMY : int = 100
#gold stuff
var GOLD_TO_WIN : int = 1000000

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
var tav_cost : int = 20
var fish_cost : int = 10
var pier_cost : int = 30
var trader_cost : int = 30
var gov_cost : int = 500
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
var CART_MAX : int = 1
var GOV_MAX : int = 1

#Arrays for available tiles
var available_land : Array = []
var available_sea : Array = []
var current_buildings : Array = []
