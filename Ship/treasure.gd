extends Sprite2D

var pier : Vector2i = Vector2i(0, 4)
var governers_mansion : Vector2i = Vector2i(0, 8)
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
	var gold_mult : int = 1
	var has_gov : bool = false
	var cur_gold : int = costs.gold_from_treasure
	
	for b in costs.current_buildings:
		if b == pier:
			gold_mult += 1
		if b == governers_mansion:
			has_gov = true
	
	cur_gold = cur_gold*gold_mult
	if has_gov == true:
		cur_gold = cur_gold * 2
	
	costs.gold += cur_gold
	self.queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("boarding"):
		#workout if cannon hits own ships
		if area.get_parent().team == area.get_parent().Team.Player:
			
			collect(area)
			
