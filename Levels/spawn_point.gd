extends Node2D
#######
#
#	THIS EXISTS TO SPAWN ATTACKING UNITS. DEPENDING ON THE LEVEL OF PLAYER INFAMY
#	SPAWNING WILL HAPPEN MORE FREQUENTLY WITH STRONGER SHIPS
#
######
@onready var ship = load("res://Ship/ship.tscn")
@onready var timer = $"spawn timer"

enum Ship_Type {
	Clipper = 0,
	Frigate = 1,
	Man_Of_War = 2
	}

enum Team {
	Player,
	Enemy
}

var spawn_quick : float = 10.0
var spawn_medium : float = 15.0
var spawn_slow : float = 20.0


##############
#
#	functions related to the spawn point
#
###############

func spawn_ship():
	"""
	called in the time out function
	"""
	var new_ship = ship.instantiate()
	new_ship.position = self.position
	if costs.infamy < 30:
		new_ship.ship_type = Ship_Type.Clipper
	if costs.infamy >= 30 and costs.infamy < 70:
		new_ship.ship_type = Ship_Type.Frigate
	if costs.infamy >= 70:
		timer.wait_time = spawn_quick
	new_ship.team = Team.Enemy
	new_ship.hunting = true
	self.get_parent().ship_layer.add_child(new_ship)
	decided_ship_spawn_rate()

func decided_ship_spawn_rate():
	"""
	take the players infamy then sets a new rate, before starting the timer again
	"""
	if costs.infamy < 30:
		timer.wait_time = spawn_slow
	if costs.infamy >= 30 and costs.infamy < 70:
		timer.wait_time = spawn_medium
	if costs.infamy >= 70:
		timer.wait_time = spawn_quick
		
	timer.start()
	

#################
#
#	SIGNAL FUNCTIONS
#
###############

func _on_spawn_timer_timeout() -> void:
	spawn_ship()
