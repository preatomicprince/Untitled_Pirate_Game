extends Node2D

var trader : Vector2i = Vector2i(0, 7)
var governers_mansion : Vector2i = Vector2i(0, 8)

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
	
	var gold_mult : int = 1
	var has_gov : bool = false
	var cur_gold : int = costs.gold_from_town
	
	for b in costs.current_buildings:
		if b == trader:
			gold_mult += 1
		if b == governers_mansion:
			has_gov = true
	
	cur_gold = cur_gold*gold_mult
	if has_gov == true:
		cur_gold = cur_gold * 2
	
	costs.gold += cur_gold


func is_town():
	pass
