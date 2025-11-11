class_name Ability extends Node2D

var ability_type: int

func _ready() -> void:
	print(ability_type, get_parent())
	update_texture()
		
func update_texture():
	if ability_type == Ability_Types.None:
		$Sprite2D.visible = false
	else:
		$Sprite2D.visible = true
