extends Control

@onready var ui : CanvasLayer = self.get_parent()

func _on_button_pressed() -> void:
	ui.game.reset_loop()
