class_name Player extends Node2D

var ships: Array[Ship] = []

var mouse_pos: Vector2 = Vector2(-1, -1)

var dragging: bool = false
var box_start: Vector2 = Vector2(-1, -1)
var over_units: Array = []
var selected_units: Array = []

func _physics_process(delta: float) -> void:
	mouse_pos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("select"):
		dragging = true
		box_start = mouse_pos
	if Input.is_action_pressed("select"):
		# Drag to select mechanic
		var x_lims: Array = [box_start.x, mouse_pos.x]
		var y_lims: Array = [box_start.y, mouse_pos.y]
		for ship in ships:
			if ship.position.x > x_lims.min() and ship.position.x < x_lims.max():
				if ship.position.y > y_lims.min() and ship.position.y < y_lims.max():
					if ship not in over_units:
						over_units.append(ship)
	if Input.is_action_just_released("select"):
		dragging = false
		#Remove enemy ships
		for i in over_units:
			if i not in ships:
				over_units.erase(i)
		selected_units = over_units.duplicate()
		over_units.clear()
		print(selected_units)
		
	if Input.is_action_just_pressed("action"):
		for unit in selected_units:
			unit.set_target_pos(mouse_pos)
			if unit.enemy_target != null:
				unit.enemy_target = null
			for i in over_units:
				if over_units not in ships:
					unit.enemy_target = i
