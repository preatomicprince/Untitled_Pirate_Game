extends Control

@onready var ui : CanvasLayer = self.get_parent()

func _on_button_pressed() -> void:
	#TODO do this better this is temp
	ui.game.current_scene = ui.game.scenes.Battle_field
	ui.game.choose_scene(ui.game.current_scene)
