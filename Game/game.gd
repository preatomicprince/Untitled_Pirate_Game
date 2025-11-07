extends Node2D

#
#
# THERES A FILE IN GAME CALLED RUN_STATS FOR RECORDING ALL THE STATS, ITS NOT HOOKED UPTO ANYTHING YET
#
@onready var player = $Player
@onready var town_screen = $"Town screen"
@onready var level = $Level

enum scenes {
	Main_menu = 0,
	Tutorial = 1,
	Battle_field,
	Results,
	Town_builder,
	Progress
}

var current_scene : int = scenes.Battle_field
