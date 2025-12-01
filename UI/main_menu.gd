extends Control

@onready var credit_text = $"credits text"


func _on_play_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Game/game.tscn")


func _on_tutorial_button_button_up() -> void:
	print("go to tutorial")

func _on_credits_button_pressed() -> void:
	credit_text.visible = true
