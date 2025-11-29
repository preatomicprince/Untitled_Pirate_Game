extends Node2D

enum town_types {
	settlement = 0,
	fort = 1,
	citadel = 2
}
enum Team {
	Player,
	Enemy
}
var team = Team.Enemy

var town_name : String = "Kingston"
var strength: float = 1.0
var health : float = 100.0
#TODO set a proper system for this
var gold : int = 10

var alive : bool = true
var under_attack : bool = false

func choose_type(town_im: Vector2i) -> int:
	"""
	take the tile its spawned on, from there return its type
	"""
	return town_types.settlement

func set_up():
	"""
	go through and set values based on 
	"""

func take_damage(damage : int, attacker : Ship):
	"""
	works like the same function in ship
	"""
	if alive == false:
		return
		
	health -= damage
	print("town health", health)
	if health <= 0:
		destroyed()
	
func destroyed():
	"""
	right now just give gold to the player 
	will get it to spawn treasure
	"""
	alive = false
	print("town destroyed")
	costs.gold += costs.gold_from_town

func is_town():
	pass
