extends Control

@onready var ui : CanvasLayer = self.get_parent()
@onready var infamy_bar : TextureProgressBar = $"top_grid/control for center/infamy progress"

func _process(delta: float) -> void:
	if self.visible == true:
		top_level_changes()
	else:
		return
		
func top_level_changes():
	"""
	on the left well have the cargo and the ability to look through it, this has ya booty
	on the center well have ya gold and ya infamy
	on the right well have time left
	"""
	$"top_grid/control for center/text container/game text".text = "Treasure: {current}/{goal}".format({"current": ui.game.player.gold, "goal": 100})
	infamy_bar.value = ui.game.player.infamy
