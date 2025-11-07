extends Node2D

enum town_types {
	settlement = 0,
	fort = 1,
	citadel = 2
}

var town_name : String = "Kingston"
var strength: float = 1.0
var health : float = 100.0
#TODO set a proper system for this
var gold : int = 10

var under_attack : bool = false

func choose_type(town_im: Vector2i) -> int:
	"""
	take the tile its spawned on, from there return its type
	"""
	return town_types.settlement

func set_up():
	"""
	go through and set values based on 
	"""
