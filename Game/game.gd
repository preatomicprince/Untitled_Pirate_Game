class_name Game extends Node2D

#
#
# THERES A FILE IN GAME CALLED RUN_STATS FOR RECORDING ALL THE STATS, ITS NOT HOOKED UPTO ANYTHING YET
#
@onready var player = $Player
@onready var town_screen = $"Town screen"
@onready var level = $Level
@onready var progress = $"Progress screen"
@onready var timer = $"game timer"
@onready var ui = $"ui main"
@onready var camera = $"game camera"

#using to decide how long you have in a level

var STARTING_TIME_LEFT : float = 100.00
var time_left : float = STARTING_TIME_LEFT
var gold_target : int = 100

enum scenes {
	Main_menu = 0,
	Tutorial = 1,
	Battle_field,
	Results,
	Town_builder,
	Progress
}

var current_scene : int = scenes.Town_builder

func _ready() -> void:
	choose_scene(current_scene)

func choose_scene(cur : int):
	town_screen.visible = false
	progress.visible = false
	level.visible = false
	timer.stop()
	ui.decide_ui(current_scene)
	match cur:
		scenes.Battle_field:
			level.visible = true
			town_screen.new_map()
			return
			
		scenes.Progress:
			progress.visible = true
			return
			
		scenes.Town_builder:
			#camera.snap_to(town_screen.position)
			town_screen.visible = true
			return
			

func reset_loop():
	"""
	if you get booted back to the town, this function resets all the levels and shit
	called in town ui
	"""
	level.current_level = level.levels.tortuga
	current_scene = scenes.Battle_field
	level.reload_map()
	choose_scene(current_scene)
	

func _on_game_timer_timeout() -> void:
	#TODO this should only kill you if you didnt reach the gold threshold
	if player.gold >= self.gold_target:
		current_scene = scenes.Progress
		level.current_level += 1
		level.reload_map()
		choose_scene(current_scene)
	else:
		player.defeated = true
