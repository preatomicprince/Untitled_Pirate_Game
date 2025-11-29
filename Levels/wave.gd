extends CharacterBody2D

var distance_traveled : int = 0
var speed : int = 200
var disap : bool = false
func _process(delta: float) -> void:

	is_wave(delta)
	disapate()


#a wave that hits the player and damages them
func is_wave(delta):
	var dir = Vector2.RIGHT.rotated(self.rotation)
	velocity = dir * speed
	distance_traveled += 1
	move_and_slide()

func disapate():
	if distance_traveled >= 200:

		if disap == false:
			self.modulate.a = lerp(self.modulate.a, 0.00, 0.1)
			disap = true
			print("here")
		self.queue_free()
