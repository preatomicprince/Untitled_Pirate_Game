extends Control

@onready var ui : CanvasLayer = self.get_parent()
@onready var progress_bar : TextureProgressBar = $progress
func _process(delta: float) -> void:
	if self.visible == true:
		change_ui()
	
func change_ui():
	progress_bar.value = ui.game.level.current_level

func _on_button_pressed() -> void:
	#TODO do this better this is temp
	ui.game.current_scene = ui.game.scenes.Battle_field
	ui.game.choose_scene(ui.game.current_scene)
