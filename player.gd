class_name Player extends Node2D

@onready var game : Node2D = self.get_parent()
@onready var war_ui : WarUI = $"../ui main/war ui"

var defeated : bool = false

var ships: Array[Ship] = []

var mouse_pos: Vector2 = Vector2(-1, -1)

var dragging: bool = false
var over_UI: bool = false
var box_start: Vector2 = Vector2(-1, -1)
var over_units: Array = []
var selected_units: Array = []

var level: Level 

var STARTING_NUM_SHIPS : int = 3
var maximum_number_of_ships : int = STARTING_NUM_SHIPS

var STARTING_MULTIPLIER : float = 1.0
var sell_item_multiplier : float = 1.0

# Used to buy abilities. Each type buy different types of abilities
var booty: Array = [0, 0, 0]
#0 Cotton, Defensive
#1 Grain, Offensive
#2 Jewels, Misc.

# Stores abilities
var inventory: Array[int] = [0, 0, 0, 0, 0]
var max_abilities: int = 5

func get_ability(ability) -> void:
	for i in inventory:
		if i == 0:
			i = ability
			return
		
func update_inventory() -> void:
	for i in range(max_abilities):
		war_ui.abilities_bar[i].set_ability_type(inventory[i], 0)

func setup() -> void:
	await get_tree().physics_frame
	update_inventory()
	level = $"../Level"


	
func _ready() -> void:
	
	setup()
	
func _process(delta: float) -> void:
	if len(self.ships) > 0 and len(self.selected_units) == 0:
		self.selected_units.append(self.ships[0])
		for i in selected_units:
			var new_ship_ui: ShipUI = preload("res://UI/ship_ui.tscn").instantiate()
			war_ui.ship_info.add_child(new_ship_ui)
			war_ui.ship_bar.append(new_ship_ui)
			new_ship_ui.set_ship(i)
	if defeated == true:
		game.current_scene = game.scenes.Town_builder
		game.choose_scene(game.current_scene)
		defeated = false
