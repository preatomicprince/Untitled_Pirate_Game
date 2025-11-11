class_name ShipUI extends Control

var ship: Ship = null

var abilities = [0, 0, 0]
@onready var ability_bar = [$Ability, $Ability2, $Ability3]
var max_abilities = 1

func _ready() -> void:
	update_texture()
	
	
func set_ship(ship_r: Ship) -> void:
	visible = true
	ship = ship_r
	max_abilities = ship.max_abilities
	for i in range(ship.max_abilities):
		set_ability_type(ship.abilities[i], i)
		
func set_ability_type(ability: int, index: int) -> int:
	var prev_type = abilities[index]
	abilities[index] = ability
	ship.abilities[index] = abilities[index]
	ship.set_abilities()
	update_texture()
	return prev_type
	
func update_texture():
	for i in range(len(ability_bar)):
		ability_bar[i].frame_coords = Vector2i(abilities[i], 0)
		
func make_data(ability: int, prev_box, index: int):
	
	var data = [ability, prev_box, index]
	return data
	
func _get_drag_data(at_position: Vector2) -> Variant:
	var ind: int = 2
	if at_position.y > 300:
		ind = 2
	elif at_position.y > 200:
		ind = 1
	elif at_position.y > 100:
		ind = 0
		
	ability_bar[ind].visible = false
	if abilities[ind] == Ability_Types.None:
		return null
		
	var preview_tex = TextureRect.new()
	preview_tex.texture = ability_bar[ind].texture
	preview_tex.expand_mode = 1
	preview_tex.size = Vector2(50, 50)
	preview_tex.position = Vector2(-10, -10)
	
	var preview = Control.new()
	preview.add_child(preview_tex)
	
	set_drag_preview(preview)
	
	return make_data(abilities[ind], self, ind)
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data[0] is int
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	
	var ind: int = 2
	if at_position.y > 300:
		ind = 2
	elif at_position.y > 200:
		ind = 1
	elif at_position.y > 100:
		ind = 0
	if ind >= ship.max_abilities:
		data[1].set_ability_type(data[0], data[2])
		return
	data[1].set_ability_type(set_ability_type(data[0], ind), data[2])
