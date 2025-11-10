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

var current_slot : TextureButton

func _process(delta: float) -> void:
	gold_text.text = "Current gold: {amount}".format({"amount": ui.game.player.gold})

func _on_button_pressed() -> void:
	ui.game.reset_loop()

func build_options(cur_slot : TextureButton):
	"""
	this function opens the buildcontainer and saves the slot in current slot
	"""
	current_slot = cur_slot
	build_options_container.visible = true
	

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
