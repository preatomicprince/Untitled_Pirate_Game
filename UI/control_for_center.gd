class_name WarUI extends Control

@onready var ui : CanvasLayer = self.get_parent()
@onready var infamy_bar : TextureProgressBar = $"top_grid/control for center/infamy progress"

@onready var abilities_bar: Array[AbilityUI] = [$bottom_grid/centre/AbilityUi, $bottom_grid/centre/AbilityUi2, $bottom_grid/centre/AbilityUi3, $bottom_grid/centre/AbilityUi4, $bottom_grid/centre/AbilityUi5]
@onready var ship_info = $Ship_Info
@onready var ship_bar: Array[ShipUI] = []

@onready var tool_tip = $tooltip
@onready var cargo_text = $"cargo text"
var No_goods_text = "[center]Collect cargo from sunked ships".format({})
var Silk_Sails_text = "[center]Silk Sails
	+Speed
	Drag and drop into equipment to use".format({}) # +Speed
var Ornate_Cannons_text = "[center]Ornate Cannons
	+Strength
	Drag and drop into equipment to use".format({}) # +Strength
var Munitions_Training_text = "[center]Munitions Training
	Increased fire rate
	Drag and drop into equipment to use".format({}) # +Fire-rate
var Grappling_Hooks_text = "[center]Grappling Hook
	More treasure from sunken ships
	Drag and drop into equipment to use".format({}) # +Boarding speed
var Fireshot_text = "[center]Fireshot
	Deals passive fire damage
	Drag and drop into equipment to use".format({}) #0.75 base damage. Sets on fire (1 dam per sec for 5 secs)
	#TODO move this around if have time
var Grapeshot_text = "[center]Grapeshot
	-damage on ships +damage on towns
	Drag and drop into equipment to use".format({}) #+25% dam against towns, -25% dam against ships
var Artillery_text = "[center]Artillery
	-damage on towns, +damage on ships
	Drag and drop into equipment to use".format({}) #+25% dam to ships, -25% dam against towns
var Chainshot_text = "[center]Chainshot
	-damage +increased chance of a critical
	Drag and drop into equipment to use".format({}) #-25% damage, +10% crit chance
var Charismatic_Captain_text = "[center]Feared Captain
	Restores health after destroying ships
	Drag and drop into equipment to use".format({}) #Restore 10hp when capturing enemy ship
@onready var game: Game 

func open_tool_tip(type):
	"""
	"""
	tool_tip.visible = true
	cargo_text.visible = false
	match type:
		Ability_Types.None:
			tool_tip.text = No_goods_text
		Ability_Types.Silk_Sails:
			tool_tip.text = Silk_Sails_text
		
		Ability_Types.Ornate_Cannons:
			tool_tip.text = Ornate_Cannons_text # +Strength
		
		Ability_Types.Munitions_Training:
			tool_tip.text = Munitions_Training_text # +Fire-rate
		
		Ability_Types.Grappling_Hooks:
			tool_tip.text = Grappling_Hooks_text # +Boarding speed
		
		Ability_Types.Fireshot:
			tool_tip.text = Fireshot_text #0.75 base damage. Sets on fire (1 dam per sec for 5 secs)
		
		Ability_Types.Grapeshot:
			tool_tip.text = Grapeshot_text #+25% dam against towns, -25% dam against ships
		
		Ability_Types.Artillery:
			tool_tip.text = Artillery_text #+25% dam to ships, -25% dam against towns
		
		Ability_Types.Chainshot:
			tool_tip.text = Chainshot_text #-25% damage, +10% crit chance
		
		Ability_Types.Charismatic_Captain:
			tool_tip.text = Charismatic_Captain_text #Restore 10hp when capturing enemy ship

func close_tool_tip():
	tool_tip.visible = false
	cargo_text.visible = true

func setup():
	await get_tree().physics_frame
	game = self.get_parent().game

func update_player_invemtory() -> void:
	var player_inv = $"../../Player".inventory
	for i in range(len(abilities_bar)):
		player_inv[i] = abilities_bar[i].ability_type
		
func _process(delta: float) -> void:
	if self.visible == true:
		top_level_changes()
	else:
		return
		
func top_level_changes():
	"""
	on the left well have the cargo and the ability to look through it, this has ya booty
	on the center well have ya gold and ya infamy
	on the right well have time left
	"""
	$"top_grid/control for center/text container/game text".text = "[center]Treasure: {current}/{goal}".format({"current": costs.gold, "goal": costs.GOLD_TO_WIN})
	infamy_bar.value = costs.infamy

func _on_UI_entered():
	self.get_parent().game.player.over_UI = true
	
func _on_UI_exited():
	self.get_parent().game.player.over_UI = false


func _on_switch_but_pressed() -> void:
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
