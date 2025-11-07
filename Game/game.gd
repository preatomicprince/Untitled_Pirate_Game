extends Node2D

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
