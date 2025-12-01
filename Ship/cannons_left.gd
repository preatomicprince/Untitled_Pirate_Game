extends Node2D

@onready var ship : CharacterBody2D = self.get_parent().get_parent()
var team
#either left or right to change the z index relative to ship images
@export var side : String 
var fireing : bool = false
var is_player : bool = false
var cannons : Array

var rotation_when_fired : float
var current_rotation : float

func _ready() -> void:
	team = ship.team
	if team == ship.Team.Player:
		is_player =  true

################
#
#	INPUT AND PROCESS FUNCTION
#
#################

func _input(event: InputEvent) -> void:
	
	if self.side == "left" and is_player == true:
		if event.is_action_pressed("fire_left"):
			if ship.level.game.current_scene == ship.level.game.scenes.Battle_field:
				ship.cannon_sound.play()
				fire_cannon()
	
	if self.side == "right" and is_player == true:
		if event.is_action_pressed("fire_right"):
			if ship.level.game.current_scene == ship.level.game.scenes.Battle_field:
				ship.cannon_sound.play()
				fire_cannon()

func fire_cannon():
	for c in cannons:

		c.firing = true

func sort_z():
	"""
	goes determins its z index based on what possition the ship is in
	"""
	if side == "left":
		pass
	if side == "right":
		pass
