extends CharacterBody2D

#a position for the cannon to go back to once its hit something or reached its destination
var reset_postion : Vector2 

var fired : bool = false
var hit : bool = false

func _ready() -> void:
	reset_postion = self.position
	
func _process(delta: float) -> void:
	workout_visible()
	
func workout_visible():
	"""
	after it reaches a certain point or hits something it'll go invisible
	"""
	if fired == true:
		if hit == false:
			self.visible = true
			return
		else:
			self.visible = false
			return
	else:
		self.visible = false

###############
#
#	SIGNAL FUNCTIONS
#
###############


func _on_cannon_area_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
