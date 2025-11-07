extends Node2D

enum scenes {
	Main_menu = 0,
	Tutorial = 1,
	Battle_field = 2,
	Results = 3,
	Town_builder = 4
}

var current_scene : int = scenes.Battle_field
