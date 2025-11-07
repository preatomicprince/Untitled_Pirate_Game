extends Node2D

enum scenes {
	Main_menu = 0,
	Tutorial = 1,
	Battle_field,
	Results,
	Town_builder 
}

var current_scene : int = scenes.Battle_field
