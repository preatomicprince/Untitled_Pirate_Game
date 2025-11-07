extends CanvasLayer

@onready var game : Node2D = self.get_parent()
@onready var battle_ui : Control = $"war ui"
@onready var progress_ui : Control = $"progress ui"

var all_ui_nodes : Array

func _ready() -> void:
	all_ui_nodes = [battle_ui]
	for u in all_ui_nodes:
		u.visible = false
	
func _process(delta: float) -> void:
	#dont need to do this every frame, in fact it might break it, its just a quick
	#implementation
	decide_ui(game.current_scene)
	

func decide_ui(cur_scene : int) -> void:
	"""
	used to show different control nodes depending on the current scene
	"""
	match cur_scene:
		game.scenes.Battle_field:
			battle_ui.visible = true
		
		game.scenes.Progress:
			progress_ui.visible = true
