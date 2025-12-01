extends Control


@onready var ui : CanvasLayer = self.get_parent()
@onready var player_town 
@onready var build_options_container : Control = $"build container"
@onready var gold_text : RichTextLabel = $"text container/game text"
@onready var tooltip : RichTextLabel = $tooltip
@onready var build_text : RichTextLabel = $"build container/game text"

@onready var build_sound = $"build sound"

@onready var map_maker = $"build container/GridContainer/map maker"
@onready var fish_monger = $"build container/GridContainer/fishmonger"
@onready var pier = $"build container/GridContainer/harbour"
@onready var trader = $"build container/GridContainer/fencer"
@onready var tavern = $"build container/GridContainer/tavern"
@onready var gov_man = $"build container/GridContainer/gov man"

#bools for tools
var fish_over : bool = false
var map_over : bool = false
var pier_over : bool = false
var trader_over : bool = false
var tavern_over : bool = false
var gov_over : bool = false



var fishmonger_text = "[center]Fishmonger: 
	Cost: {fishcost} treasure
	Heals your ship 1 HP every 10 seconds".format({"fishcost": costs.fish_cost})

var mapmaker_text = "[center]Cartographer:
	Cost: {mapcost} treasure, 1 allowed
	Reveals all towns on the map".format({"mapcost": costs.map_cost})
	
var pier_text = "[center]Harbour:
	Costs: {harcost} treasure
	Multiplies treasure from ships per harbour".format({"harcost": costs.pier_cost})
	
var trader_text = "[center]Trader:
	Costs: {trader} treasure
	Multiplies treasure from towns per trader".format({"trader": costs.trader_cost})
	
var tavern_text = "[center]Tavern:
	Costs: {tavcost} treasure
	Generates {gen} treasure every 10 seconds".format({"tavcost": costs.tav_cost, "gen": costs.tavern_add})

var gov_text = "[center]Governers Mansion:
	Costs: {govcost} treasure, 1 allowed
	Doubles treasure from all sources".format({"govcost": costs.gov_cost})

var current_slot : TextureButton

func _ready() -> void:
	if costs.tutorial_selected == true:
		$BuildingTutorial.visible = true

func _process(delta: float) -> void:
	gold_text.text = "[center]Treasure: {amount}".format({"amount": costs.gold})
	decide_whats_available()
	decide_text()
	
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
	var has_land_tiles : bool = false
	var has_water_tiles : bool = false
	
	if len(costs.available_land) > 0:
		has_land_tiles = true
		
	if len(costs.available_sea) > 0:
		has_water_tiles = true
	
	if costs.gold >= costs.tav_cost and has_land_tiles == true:
		tavern.disabled = false
	else:
		tavern.disabled = true
		
	if costs.gold >= costs.fish_cost and has_land_tiles == true:
		fish_monger.disabled = false
	else:
		fish_monger.disabled = true
		
	if costs.gold >= costs.pier_cost and has_water_tiles == true:
		pier.disabled = false
	else:
		pier.disabled = true
		
	if costs.gold >= costs.trader_cost and has_land_tiles == true:
		trader.disabled = false
	else:
		trader.disabled = true
		
	if costs.gold >= costs.gov_cost and has_land_tiles == true and costs.GOV_BUILT == false:
		gov_man.disabled = false
	else:
		gov_man.disabled = true
		
	if costs.gold >= costs.map_cost and costs.CART_BUILT == false and has_land_tiles == true:
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
	costs.tot_build_built += 1
	build_sound.play()

	ui.game.town_screen.set_building(costs.buildings.cartog)
	ui.game.level.reveal_towns()
	costs.CART_BUILT = true
	costs.gold -= costs.map_cost
	


func _on_fishmonger_pressed() -> void:
	costs.tot_build_built += 1
	build_sound.play()

	ui.game.town_screen.set_building(costs.buildings.fish_monger)
	costs.gold -= costs.fish_cost


func _on_fencer_pressed() -> void:
	costs.tot_build_built += 1
	build_sound.play()

	ui.game.town_screen.set_building(costs.buildings.trader)
	costs.gold -= costs.trader_cost


func _on_tavern_pressed() -> void:
	costs.tot_build_built += 1
	build_sound.play()

	ui.game.town_screen.set_building(costs.buildings.tavern)
	costs.gold -= costs.tav_cost

func _on_harbour_pressed() -> void:
	costs.tot_build_built += 1
	build_sound.play()

	ui.game.town_screen.set_building(costs.buildings.pier)
	costs.gold -= costs.pier_cost
	

func _on_gov_man_pressed() -> void:
	costs.tot_build_built += 1
	build_sound.play()

	ui.game.town_screen.set_building(costs.buildings.governer)
	costs.gold -= costs.gov_cost
	costs.GOV_BUILT = true


func decide_text():
	if fish_over == true:
		tooltip.text = fishmonger_text
		tooltip.visible = true
		build_text.visible = false
		return
		
	if map_over == true:
		tooltip.text = mapmaker_text
		tooltip.visible = true
		build_text.visible = false
		return
		
	if trader_over == true:
		tooltip.text = trader_text
		tooltip.visible = true
		build_text.visible = false
		return
		
	if pier_over == true:
		tooltip.text = pier_text
		tooltip.visible = true
		build_text.visible = false
		return
	
	if tavern_over == true:
		tooltip.text = tavern_text
		tooltip.visible = true
		build_text.visible = false
		return
		
	if gov_over == true:
		tooltip.text = gov_text
		tooltip.visible = true
		build_text.visible = false
		return
	tooltip.visible = false
	build_text.visible = true
	return
	
		
		
		
			
func _on_map_maker_mouse_entered() -> void:
	map_over = true

#

func _on_map_maker_mouse_exited() -> void:
	map_over = false


func _on_fishmonger_mouse_entered() -> void:
	fish_over = true



func _on_fishmonger_mouse_exited() -> void:
	fish_over = false


func _on_harbour_mouse_entered() -> void:
	pier_over = true

func _on_harbour_mouse_exited() -> void:
	pier_over = false


func _on_fencer_mouse_entered() -> void:
	trader_over = true


func _on_fencer_mouse_exited() -> void:
	trader_over = false
	

func _on_tavern_mouse_entered() -> void:
	tavern_over = true

func _on_tavern_mouse_exited() -> void:
	tavern_over = false

func _on_gov_man_mouse_entered() -> void:
	gov_over = true

func _on_gov_man_mouse_exited() -> void:
	gov_over = false


func _on_switch_but_button_up() -> void:
	if ui.game.current_scene == ui.game.scenes.Battle_field:
		ui.game.current_scene = ui.game.scenes.Town_builder
		ui.game.choose_scene(ui.game.current_scene)
		ui.decide_ui(ui.game.current_scene)
		ui.game.town_screen.tick_timer.set_paused(true)
		ui.game.sound_board.switch()
		return
			
	if ui.game.current_scene == ui.game.scenes.Town_builder:
		ui.game.current_scene = ui.game.scenes.Battle_field
		ui.game.choose_scene(ui.game.current_scene)
		ui.decide_ui(ui.game.current_scene)
		ui.game.town_screen.tick_timer.set_paused(false)
		ui.game.sound_board.switch()
		return
