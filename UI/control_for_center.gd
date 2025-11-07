extends Control

@onready var top_grid : GridContainer = $".."

@onready var infamy_bar : TextureProgressBar = $"infamy progress"
func _process(delta: float) -> void:
	if self.visible == true:
		pass
	else:
		return
		
func top_level_changes():
	"""
	on the left well have the cargo and the ability to look through it, this has ya booty
	on the center well have ya gold and ya infamy
	on the right well have time left
	"""
	
