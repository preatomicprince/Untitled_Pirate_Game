extends CanvasLayer

@onready var game : Game = self.get_parent()
@onready var battle_ui : Control = $"war ui"
@onready var town_ui : Control = $town_ui
@onready var def_vict_ui : Control = $"win def"
@onready var tutorial_ui : Control = $tutorial_ui
var all_ui_nodes : Array

func _ready() -> void:
	all_ui_nodes = [battle_ui]
	for u in all_ui_nodes:
		u.visible = false
	
	decide_ui(game.current_scene)
	
	if costs.tutorial_selected == true:
		tutorial_ui.visible = true


func decide_ui(cur_scene : int) -> void:
	"""
	used to show different control nodes depending on the current scene
	"""
	battle_ui.visible = false
	town_ui.visible = false
	match cur_scene:
		game.scenes.Battle_field:
			battle_ui.visible = true
		
			
		game.scenes.Town_builder:
			town_ui.visible = true
