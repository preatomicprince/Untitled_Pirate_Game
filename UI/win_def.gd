extends Control

@onready var title = $"control for grid/GridContainer/title"
@onready var gold_col = $"control for grid/GridContainer/gold collected"
@onready var ship_sunk = $"control for grid/GridContainer/ships sunk"
@onready var towns_dest = $"control for grid/GridContainer/towns destroyed"
@onready var build_built = $"control for grid/GridContainer/buildings built"

var won : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func show_vict():
	title.text = "[center]Victory".format({})
	gold_col.text = "[center]Gold collected: {tre}".format({"tre": costs.tot_gold})
	ship_sunk.text = "[center]Ships sunk: {tre}".format({"tre": costs.tot_dest_ship})
	towns_dest.text = "[center]Towns destroyed: {tre}".format({"tre": costs.tot_towns_dest})
	build_built.text = "[center]Buildings built: {tre}".format({"tre": costs.tot_build_built})


func show_deft():
	title.text = "[center]Defeat".format({})
	gold_col.text = "[center]Gold collected: {tre}".format({"tre": costs.tot_gold})
	ship_sunk.text = "[center]Ships sunk: {tre}".format({"tre": costs.tot_dest_ship})
	towns_dest.text = "[center]Towns destroyed: {tre}".format({"tre": costs.tot_towns_dest})
	build_built.text = "[center]Buildings built: {tre}".format({"tre": costs.tot_build_built})

func _on_texture_button_pressed() -> void:
	costs.reset()
	get_tree().change_scene_to_file("res://Game/game.tscn")
