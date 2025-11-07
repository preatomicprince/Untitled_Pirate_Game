class_name Level extends Node2D

@onready var game = get_parent()
@onready var player = $"../Player"

#set current level with an enum
enum levels {
	tortuga = 0,
	jamaica = 1
}
var current_level : int = levels.jamaica

var enemy_ships: Array = []
