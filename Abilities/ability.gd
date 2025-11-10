class_name Ability extends Node2D

var ability_type: int

func _ready() -> void:
	print(ability_type, get_parent())
