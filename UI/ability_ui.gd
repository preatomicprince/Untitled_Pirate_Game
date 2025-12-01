class_name AbilityUI extends Control

@onready var war_ui = self.get_parent().get_parent().get_parent()
@export var ability_type: int = 0
	
func _ready() -> void:
	update_texture()

func _process(delta: float) -> void:
	update_texture()

func set_ability_type(ability: int, _ind: int) -> int:
	var prev_type = ability_type
	self.ability_type = ability
	var ind = $"../../../".abilities_bar.find(self)
	$"../../../".abilities_bar[ind] = ability_type
	update_texture()
	return prev_type

func update_texture():
	$Texture.frame_coords = Vector2i(ability_type, 0)
	if ability_type == Ability_Types.None:
		$Texture.frame = 0
	else:
		$Texture.visible = true
		
func make_data(ability: int, prev_box, index: int):
	
	var data = [ability, prev_box, index]
	return data

func _get_drag_data(at_position: Vector2) -> Variant:

	if ability_type == Ability_Types.None:
		return null
		
	var preview_tex = TextureRect.new()
	preview_tex.texture = $Texture.texture
	preview_tex.expand_mode = 1
	preview_tex.size = Vector2(50, 50)
	preview_tex.position = Vector2(-10, -10)
	
	var preview = Control.new()
	preview.add_child(preview_tex)
	
	set_drag_preview(preview)
	
	return make_data(ability_type, self, 0)
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data[0] is int
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	data[1].visible = true
	data[1].set_ability_type(set_ability_type(data[0], 0), data[2])
	$"../../../".update_player_invemtory()
	
	
func _notification(what:int) -> void:
	if what == NOTIFICATION_DRAG_END and not is_drag_successful():
		update_texture()
	


func _on_mouse_entered() -> void:
	war_ui.open_tool_tip(ability_type)


func _on_mouse_exited() -> void:
	war_ui.close_tool_tip()
