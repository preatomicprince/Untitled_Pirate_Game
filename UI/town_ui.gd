extends Control

enum buildings {
	map_maker = 0,
	sextant = 1,
	fishmonger,
	rum_dist,
	harbour,
	fencer,
	tavern,
}

@onready var ui : CanvasLayer = self.get_parent()
@onready var player_town 
@onready var build_options_container : Control = $"build container"
@onready var gold_text : RichTextLabel = $"gold text"

@onready var map_maker = $"build container/GridContainer/map maker"
@onready var fish_monger = $"build container/GridContainer/fishmonger"
@onready var pier = $"build container/GridContainer/harbour"
@onready var trader = $"build container/GridContainer/fencer"
@onready var tavern = $"build container/GridContainer/tavern"
@onready var gov_man = $"build container/GridContainer/gov man"

var current_slot : TextureButton

func _process(delta: float) -> void:
	gold_text.text = "Current gold: {amount}".format({"amount": costs.gold})
	decide_whats_available()
	
func _on_button_pressed() -> void:
	ui.game.reset_loop()

func build_options(cur_slot : TextureButton):
	"""
	this function opens the buildcontainer and saves the slot in current slot
	"""
	current_slot = cur_slot
	build_options_container.visible = true
	

func decide_whats_available():
	"""
	disables certain buttons if conditions arnt met
	"""
	if costs.gold >= costs.tav_cost:
		tavern.disabled = false
	else:
		tavern.disabled = true
		
	if costs.gold >= costs.fish_cost:
		fish_monger.disabled = false
	else:
		fish_monger.disabled = true
		
	if costs.gold >= costs.pier_cost:
		pier.disabled = false
	else:
		pier.disabled = true
		
	if costs.gold >= costs.trader_cost:
		trader.disabled = false
	else:
		trader.disabled = true
		
	if costs.gold >= costs.gov_cost:
		gov_man.disabled = false
	else:
		gov_man.disabled = true
		
	if costs.gold >= costs.map_cost:
		map_maker.disabled = false
	else:
		map_maker.disabled = true
#########
#
#	PROCESS FUNCTIONS
#
#######
#related to building stuff
func _on_map_maker_pressed() -> void:
	current_slot.create_building(buildings.map_maker)
	build_options_container.visible = false


func _on_sextant_pressed() -> void:
	current_slot.create_building(buildings.sextant)
	build_options_container.visible = false


func _on_fishmonger_pressed() -> void:
	current_slot.create_building(buildings.fishmonger)
	build_options_container.visible = false


func _on_rum_distilery_pressed() -> void:
	current_slot.create_building(buildings.rum_dist)
	build_options_container.visible = false


func _on_fencer_pressed() -> void:
	current_slot.create_building(buildings.fencer)
	build_options_container.visible = false


func _on_tavern_pressed() -> void:
	current_slot.create_building(buildings.tavern)
	build_options_container.visible = false

func _on_harbour_pressed() -> void:
	current_slot.create_building(buildings.harbour)
	build_options_container.visible = false
	
func _on_close_pressed() -> void:
	build_options_container.visible = false
