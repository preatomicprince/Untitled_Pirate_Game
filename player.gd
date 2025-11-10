class_name Player extends Node2D

@onready var game : Node2D = self.get_parent()

var defeated : bool = false

var ships: Array[Ship] = []

var mouse_pos: Vector2 = Vector2(-1, -1)

var dragging: bool = false
var box_start: Vector2 = Vector2(-1, -1)
var over_units: Array = []
var selected_units: Array = []

var level: Level 

var STARTING_NUM_SHIPS : int = 3
var maximum_number_of_ships : int = STARTING_NUM_SHIPS
var gold: int = 0
var infamy: int = 0
var STARTING_MULTIPLIER : float = 1.0
var sell_item_multiplier : float = 1.0

func setup() -> void:
	await get_tree().physics_frame
	level = $"../Level"
	
func _ready() -> void:
	setup()

func _process(delta: float) -> void:
	if defeated == true:
		game.current_scene = game.scenes.Town_builder
		game.choose_scene(game.current_scene)
		defeated = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motherload"):
		self.gold += 10

func _physics_process(delta: float) -> void:
	mouse_pos = get_global_mouse_position()
	
	if Input.is_action_just_pressed("select"):
		dragging = true
		$Select_Box.visible = true
		box_start = mouse_pos
		$Select_Box.position = box_start 
	if Input.is_action_pressed("select"):
		# Drag to select mechanic
		var x_lims: Array = [box_start.x, mouse_pos.x]
		var y_lims: Array = [box_start.y, mouse_pos.y]
		
		$Select_Box.scale.x = -(box_start.x - mouse_pos.x)/100
		$Select_Box.scale.y = -(box_start.y - mouse_pos.y)/100
		for ship in ships:
			if ship.position.x > x_lims.min() and ship.position.x < x_lims.max():
				if ship.position.y > y_lims.min() and ship.position.y < y_lims.max():
					if ship not in over_units:
						over_units.append(ship)
	if Input.is_action_just_released("select"):
		dragging = false
		$Select_Box.visible = false
		#Remove enemy ships
		for i in over_units:
			if i not in ships:
				over_units.erase(i)
		selected_units = over_units.duplicate()
		over_units.clear()
		print(selected_units)
		
	if Input.is_action_just_pressed("action"):
		# Keep unit position offset
		var average_pos:  Vector2 = Vector2(0, 0)
		for i in selected_units:
			average_pos += i.position
		average_pos.x = average_pos.x/len(selected_units)
		average_pos.y = average_pos.y/len(selected_units)
		
		for unit in selected_units:
			var offset = unit.position - average_pos
			unit.set_target_pos(mouse_pos + offset)
			
			# Setting combat target
			if unit.enemy_target != null:
				unit.enemy_target = null
			for i in over_units:
				if i in level.enemy_ships:
					unit.enemy_target = i
