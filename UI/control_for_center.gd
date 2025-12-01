class_name WarUI extends Control

@onready var ui : CanvasLayer = self.get_parent()
@onready var infamy_bar : TextureProgressBar = $"top_grid/control for center/infamy progress"

@onready var abilities_bar: Array[AbilityUI] = [$bottom_grid/centre/AbilityUi, $bottom_grid/centre/AbilityUi2, $bottom_grid/centre/AbilityUi3, $bottom_grid/centre/AbilityUi4, $bottom_grid/centre/AbilityUi5]
@onready var ship_info = $Ship_Info
@onready var ship_bar: Array[ShipUI] = []

@onready var game: Game 

func setup():
	await get_tree().physics_frame
	game = self.get_parent().game

func update_player_invemtory() -> void:
	var player_inv = $"../../Player".inventory
	for i in range(len(abilities_bar)):
		player_inv[i] = abilities_bar[i].ability_type
		
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
	$"top_grid/control for center/text container/game text".text = "[center]Treasure: {current}/{goal}".format({"current": costs.gold, "goal": costs.GOLD_TO_WIN})
	infamy_bar.value = costs.infamy

func _on_UI_entered():
	self.get_parent().game.player.over_UI = true
	
func _on_UI_exited():
	self.get_parent().game.player.over_UI = false
