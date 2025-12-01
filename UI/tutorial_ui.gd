extends Control



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		$forward.visible = false
	if event.is_action_pressed("left"):
		$left.visible = false
	if event.is_action_pressed("right"):
		$right.visible = false
	if event.is_action_pressed("fire_right"):
		$"left cannon".visible = false
	if event.is_action_pressed("fire_left"):
		$"right cannon".visible = false
	if event.is_action_pressed("switch"):
		$town.visible = false
