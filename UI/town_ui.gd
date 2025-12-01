extends Control


@onready var ui : CanvasLayer = self.get_parent()
@onready var player_town 
@onready var build_options_container : Control = $"build container"
@onready var gold_text : RichTextLabel = $"text container/game text"

@onready var build_sound = $"build sound"

@onready var map_maker = $"build container/GridContainer/map maker"
@onready var fish_monger = $"build container/GridContainer/fishmonger"
@onready var pier = $"build container/GridContainer/harbour"
@onready var trader = $"build container/GridContainer/fencer"
@onready var tavern = $"build container/GridContainer/tavern"
@onready var gov_man = $"build container/GridContainer/gov man"

var current_slot : TextureButton

func _process(delta: float) -> void:
	gold_text.text = "[center]Treasure: {amount}".format({"amount": costs.gold})
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
	build_sound.play()
	print("map maker")
	ui.game.town_screen.set_building(costs.buildings.cartog)
	ui.game.level.reveal_towns()
	costs.CART_BUILT = true
	costs.gold -= costs.map_cost
	


func _on_fishmonger_pressed() -> void:
	build_sound.play()
	print("fish monger")
	ui.game.town_screen.set_building(costs.buildings.fish_monger)
	costs.gold -= costs.fish_cost


func _on_fencer_pressed() -> void:
	build_sound.play()
	print("market pressed")
	ui.game.town_screen.set_building(costs.buildings.trader)
	costs.gold -= costs.trader_cost


func _on_tavern_pressed() -> void:
	build_sound.play()
	print("tavern pressed")
	ui.game.town_screen.set_building(costs.buildings.tavern)
	costs.gold -= costs.tav_cost

func _on_harbour_pressed() -> void:
	build_sound.play()
	print("pier pressed")
	ui.game.town_screen.set_building(costs.buildings.pier)
	costs.gold -= costs.pier_cost
	

func _on_gov_man_pressed() -> void:
	build_sound.play()
	print("gov pressed")
	ui.game.town_screen.set_building(costs.buildings.governer)
	costs.gold -= costs.gov_cost
	costs.GOV_BUILT = true
