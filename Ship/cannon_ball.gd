extends CharacterBody2D

#a position for the cannon to go back to once its hit something or reached its destination
var reset_postion : Vector2 
var dist_traveled : int = 0
var range_travel : int = 300
var cannon_speed : int = 500
var cur_rot 
var dir

var firing : bool = false
var hit : bool = false
var hit_something : bool = false

func _ready() -> void:
	reset_postion = self.position
	self.get_parent().cannons.append(self)

###########
#
#	process
#
##########
func _process(delta: float) -> void:
	fired()
	workout_visible()
	destroy()


###########
#
#
#
################
func fired():
	
	if self.get_parent().side == "left":
		dir = Vector2.RIGHT.rotated(self.get_parent().get_parent().rotation)
		
	else:
		dir = Vector2.LEFT.rotated(self.get_parent().get_parent().rotation)
		
	if firing == true:
		velocity = dir * cannon_speed
		
		dist_traveled += 5
		move_and_slide()

func workout_visible():
	"""
	after it reaches a certain point or hits something it'll go invisible
	"""
	if firing == true:
		if hit == false:
			self.visible = true
			return
		else:
			self.visible = false
			return
	else:
		self.visible = false


func hit_target(attacker, defender):
	"""
	
	"""
	hit_something = true

	defender.take_damage(attacker.strength, attacker)
	
func destroy():
	if dist_traveled >= range_travel or hit_something == true:
		self.visible = false
		self.firing = false
		self.hit_something = false
		self.position = reset_postion
		dist_traveled = 0


###############
#
#	SIGNAL FUNCTIONS
#
###############


func _on_cannon_area_area_entered(area: Area2D) -> void:
	if area.get_parent() != null:
		if firing == true:
			if area.get_parent().has_method("boarding"):
				#workout if cannon hits own ships
				if area.get_parent().team == self.get_parent().team:
					return
				else:
					hit_target(self.get_parent().ship, area.get_parent())
					
			if area.get_parent().has_method("is_town"):
				if area.get_parent().team == self.get_parent().team:
					return
				else:
					hit_target(self.get_parent().ship, area.get_parent())
