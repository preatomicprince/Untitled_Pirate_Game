class_name Level extends Node2D

@onready var game = get_parent()
@onready var player = $"../Player"
@onready var map_layers : Node2D = $"map layers"
@onready var town_layer : Node2D =$"map layers/town layer"
#set current level with an enum
enum levels {
	none = 0,
	tortuga = 1,
	jamaica = 2
}
var current_level : int = levels.tortuga

var enemy_ships: Array = []

func reload_map():
	map_layers.reload_map()
