extends Camera2D


var move_speed : int = 35
var zoom_speed : Vector2 = Vector2(0.1, 0.1)
var left : bool = false
var right : bool = false
var up : bool = false
var down : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		self.up = true
	if event.is_action_released("up"):
		self.up = false
		
	if event.is_action_pressed("down"):
		self.down = true
	if event.is_action_released("down"):
		self.down = false
		
	if event.is_action_pressed("left"):
		self.left = true
	if event.is_action_released("left"):
		self.left = false
		
	if event.is_action_pressed("right"):
		self.right = true
	if event.is_action_released("right"):
		self.right = false
	
	if event.is_action("zoom in"):
		zoom_in()
		
	if event.is_action("zoom out"):
		zoom_out()
	
func _process(delta: float) -> void:
	pass
	#move_cam(delta)

func move_cam(delta):
	var direction = Vector2.ZERO

	if left == true and self.position.x > self.limit_left:
		direction[0] -= move_speed
	if right == true and self.position.x < self.limit_right:
		direction[0] += move_speed
		
	if up == true and self.position.y > self.limit_top:
		direction[1] -= move_speed
	if down == true and self.position.y < self.limit_bottom:
		direction[1] += move_speed

	position += direction * move_speed  * delta 


func zoom_out():
	var target_zoom = self.zoom - zoom_speed
	target_zoom = target_zoom.clamp(Vector2(0.2, 0.2), Vector2(1, 1)) # optional bounds

	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", target_zoom, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
func zoom_in():
	var target_zoom = self.zoom + zoom_speed
	target_zoom = target_zoom.clamp(Vector2(0.2, 0.2), Vector2(1, 1))

	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", target_zoom, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func snap_to(loc: Vector2) -> void:
	"""
	this function snaps the camera to an important location. can be called in the game when its the units turn
	"""
	position = loc
