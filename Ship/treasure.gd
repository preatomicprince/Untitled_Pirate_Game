extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func collect(area):
	"""
	show some animation, sound ect
	"""
	costs.gold += costs.gold_from_treasure
	self.queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("boarding"):
		#workout if cannon hits own ships
		if area.get_parent().team == area.get_parent().Team.Player:
			
			collect(area)
			
