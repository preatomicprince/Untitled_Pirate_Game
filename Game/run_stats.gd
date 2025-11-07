extends Node

#This is to track stats for any given run
var total_gold : int
var booty_taken : int
var ships_destroyed : int
var ships_captured : int
var towns_looted : int

func _ready() -> void:
	reset()

func reset():
	"""
	this can be used to reset all the stats at the begining of a run
	"""
	total_gold = 0
	booty_taken = 0
	ships_destroyed = 0
	ships_captured = 0
	towns_looted = 0
