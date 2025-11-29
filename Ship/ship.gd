class_name Ship extends CharacterBody2D

#for ship images
@onready var carrack_ims : Sprite2D = $Carrack
@onready var man_o_war_ims : Sprite2D = $ManOWar
@onready var shot_radius : Sprite2D = $ShotRadius
#assign the right sprite sheet depending on what ship the ship is
var current_ims : Sprite2D

@onready var ship_ims : Sprite2D = $Ships
@onready var ship_flag : Sprite2D = $Flags
@onready var ship_collisions : CollisionShape2D = $CollisionShape2D
@onready var interact_area : CollisionShape2D = $Area2D/CollisionShape2D

#ship timers
@onready var knock_back_timer : Timer = $Knock_back_Timer

# Navigation
@onready var target_pos: Vector2 = position
@onready var nav_agent: NavigationAgent2D = $nav_agent

#for player ship navigation
var forward = false
var left = false
var right = false
var knock_back = false
#source of a knockback
var source_pos : Vector2 

#for swaying in the sea
var left_sway : bool = false
var right_sway : bool = true
var sway_speed : float = 0.01
var sway_strength : float = 5.0


enum Ship_Type {
	Clipper = 0,
	Frigate = 1,
	Man_Of_War = 2
	}
	
enum Team {
	Player,
	Enemy
}

enum State {
	Moving,
	Combat,
	Imobilised,
	Boarding
}

var rewards = { # [Gold drop, ability drop chance, max item drop]
	Ship_Type.Clipper : [10, 0, 2],
	Ship_Type.Frigate : [50, 0.1, 10],
	Ship_Type.Man_Of_War : [25, 0.3, 5]
}

@export var ship_type: Ship_Type
@export var team: Team
var state: State = State.Moving

@export var patrolling: bool = false

# Stats for each ship type
# Strength is 1-5, and speed is 1-3
var stats = { # [Strength, Speed, health]
	Ship_Type.Clipper : [1, 3, 15],
	Ship_Type.Frigate : [3, 2, 20],
	Ship_Type.Man_Of_War : [5, 1, 25]
}
var level: Level = null
var player: Player = null
# Core stats
var strength: float = 1.0
var speed: float  = 1.0
var health: float = 100.0
var firing_speed: float = 1.0
var boarding_speed: float = 6.0
var accuracy: float = 0.8

var damage_over_time: bool = false
var crit_odds: float = 0.05
const CRIT_MULT: float = 2.0

const MOVE_SPEED = 50 # Const to change speed of all ships moving

func set_core_stats() -> void:
	self.strength = stats[ship_type][0]
	self.speed = stats[ship_type][1]
	self.health = stats[ship_type][2]	
	
	for i in self.abilities:
		match i:
			Ability_Types.Ornate_Cannons:
				self.strength += Ability_Values.Ornate_Cannons
			Ability_Types.Silk_Sails:
				self.speed += Ability_Values.Silk_Sails
			Ability_Types.Munitions_Training:
				self.firing_speed += Ability_Values.Munitions_Training
			Ability_Types.Grappling_Hooks:
				self.boarding_speed += Ability_Values.Grappling_Hooks
				
			Ability_Types.Fireshot:
				self.strength += self.strength*Ability_Values.Fireshot_Dam
				self.damage_over_time = true
			Ability_Types.Chainshot:
				self.strength += self.strength*Ability_Values.Chainshot_Dam
				self.crit_chance += Ability_Values.Chainshot_Crit
				
func set_abilities():
	set_core_stats()
	set_attack_mult()
	
# Attack multipliers
var town_attack: float = 1.0
var ship_attack: float = 1.0

func set_attack_mult() -> void:
	town_attack = strength
	ship_attack = strength
	
	for i in self.abilities:
		match i:
			Ability_Types.Grapeshot:
				town_attack += Ability_Values.Grapeshot_Town_Dam
				ship_attack += Ability_Values.Grapeshot_Ship_Dam
			Ability_Types.Artillery:
				town_attack += Ability_Values.Artillery_Town_Dam
				ship_attack += Ability_Values.Artillery_Ship_Dam
				

# Ability slots
var abilities = [0, 0, 0]
var max_abilities = 3

var team_colour = Color()
var enemy_colour = Color(0.641, 0.515, 0.214, 1.0)

var fleeing: bool = false

func actor_setup():
	await get_tree().physics_frame
	set_target_pos(target_pos)
	level = self.get_parent().get_parent()
	player = level.player
	if team == Team.Player:
		player.ships.append(self)
	if team == Team.Enemy:
		level.enemy_ships.append(self)
		if patrolling:
			get_path_points()
		
func set_target_pos(target_pos: Vector2):
	nav_agent.target_position = target_pos
	
	
# Combat
var enemy_target: Ship = null
const COMBAT_DISTANCE = 100
var can_attack: bool = true
var on_fire: bool = false
var fire_time: int = 0

# AI
var path_points: Array = []
var current_point: int = 0
var patrol_back: bool = false # Going backwards?

func get_path_points() -> void:
	for i in range($Path2D.curve.get_point_count()):
		path_points.append($Path2D.curve.get_point_position(i) + position)
		

func attack(ship: Ship) -> void:
	if can_attack == false:
		return
	$Combat_Timer.start()
	can_attack = false
	var hit_chance = randfn(0.0, 1.0)
	var crit_chance = randf()
	if hit_chance < accuracy:
		var damage = self.strength
		if crit_chance < crit_odds:
			damage = self.CRIT_MULT
		ship.take_damage(damage, self)
		
func take_damage(damage: int, attacker: Ship) -> void:
	health -= damage
	
	if health <= 0:
		if attacker != null:
			if Ability_Types.Charismatic_Captain in attacker.abilities:
				attacker.health += Ability_Values.Charismatic_HP
		imobilise()
		
	if attacker == null:
		return
		
	if attacker.abilities.has(Ability_Types.Fireshot):
		fire_time = Ability_Values.Fire_Time
		$Fire_Timer.start(1.0)
	if enemy_target == null:
		enemy_target = attacker
	
			
func imobilise()->void:
	state = State.Imobilised
	$Flags.visible = false
	if team == Team.Player:
		delete()
	elif team == Team.Enemy:
		for i in player.ships:
			if i.enemy_target == self:
				i.enemy_target = null
		player.gold += rewards[ship_type][0]
		var drop_chance = randf()
		if drop_chance < rewards[ship_type][1]:
			player.get_ability(randi_range(0, Ability_Types.MAX))
			
		# Booty drops
		var item_type = randi_range(0, 2)
		var item_ammount = randi_range(1, rewards[ship_type][2])
		player.booty[item_type] += item_ammount
		
			
func boarding() -> void:
	if $Boarding_Timer.is_stopped():
		$Boarding_Timer.set_wait_time(boarding_speed)
		$Boarding_Timer.start(boarding_speed)
		
func stop_boarding() -> void:
	state = State.Moving
	$Boarding_Timer.stop()
	
func capture() -> void:
	if team == Team.Player:
		return
	level.enemy_ships.erase(self)
	player.ships.append(self)
	team = Team.Player
	for i in player.ships:
			if i.enemy_target == self:
				i.enemy_target = null
	$Flags.visible = true
	$Flags.modulate = team_colour
	state = State.Moving
	health = stats[ship_type][2]
	patrolling = false
			
func delete()-> void:
	if team == Team.Player:
		player.selected_units.erase(self)
		player.over_units.erase(self)
		for i in level.enemy_ships:
			if i.enemy_target == self:
				i.enemy_target = null
		player.ships.erase(self)
	else:
		for i in player.ships:
			if i.enemy_target == self:
				i.enemy_target = null
		level.enemy_ships.erase(self)
	queue_free()
	
	
func _ready() -> void:
	
	set_core_stats()
	set_attack_mult()
	

	# Navigation
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	actor_setup.call_deferred()

func _process(delta: float) -> void:
	decide_animation({})
	if team == Team.Player:
		#lets just see about getting the angle
		var node_pos = self.global_position
		var mouse_pos = get_global_mouse_position()
		var to_mouse = mouse_pos - node_pos
		
		var angle_rad = atan2(to_mouse.y, to_mouse.x)
		
		var angle_deg = $Highlight.rotation_degrees
		if angle_deg < 0:
			angle_deg += 360

		#$ManOWar.frame = lerp($ManOWar.frame, int(round(angle_deg / 360.0 * 80)) % 80, 0.1)



func _input(event: InputEvent) -> void:
	if team == Team.Player:
		if event.is_action_pressed("up"):
			forward = true
		if event.is_action_pressed("right"):
			right = true
		if event.is_action_pressed("left"):
			left = true
			
		if event.is_action_released("up"):
			forward = false
		if event.is_action_released("right"):
			right = false
		if event.is_action_released("left"):
			left = false
func _physics_process(delta):
	player_movement(delta)
	if player != null:
		if self in player.selected_units:
			$Highlight.visible = true
		else:
			$Highlight.visible = false
	
	# Get the correct list of enemies
	var enemies
	if level != null or player != null:
		if team == Team.Player:
			enemies = level.enemy_ships
		elif team == Team.Enemy:
			enemies = player.ships
		
	match state:
		State.Moving:
			#Check if we should move to combat
			if enemies != null:
				for i in enemies:
					if position.distance_to(i.position) < COMBAT_DISTANCE:
						if i.state != State.Imobilised:
							if not fleeing or i == enemy_target:
								state = State.Combat
								set_target_pos(position)
								enemy_target = i
								attack(enemy_target)
								return
						if i.state == State.Imobilised && i == enemy_target:
							state = State.Boarding
							boarding()
					
			# If no combat, move to set target
			if nav_agent.is_navigation_finished():
				
				# Patrolling behaviour
				if patrolling and len(path_points) > 0:
					if current_point >= len(path_points)-1:
						patrol_back = true
					if patrol_back and current_point == 0:
						patrol_back = false
					if patrol_back:
						current_point -= 1
					else:
						current_point += 1
					
					set_target_pos(path_points[current_point])
						
				return
			if enemy_target != null:
				set_target_pos(enemy_target.position)
			var current_agent_position: Vector2 = global_position
			var next_path_position: Vector2 = nav_agent.get_next_path_position()
			
			velocity = current_agent_position.direction_to(next_path_position) * speed * MOVE_SPEED
			var angle = velocity.angle()
			
			var angle_deg = rad_to_deg(velocity.angle())
			if angle_deg < 0:
				angle_deg += 360

			$Carrack.frame = lerp($Carrack.frame, int(round(angle_deg / 360.0 * 80)) % 80, 0.1)


				#var dirs = get_direction_flags(angle)
				#decide_animation(dirs)
					
			move_and_slide()
			
		State.Combat:
			# Stop attacking if enemy imobilised or too far
			if enemy_target == null:
					state = State.Moving
					fleeing = true
					$Flee_Timer.start() # Won't automatically start combat until timer ends
					return
			if enemy_target.state == State.Imobilised or position.distance_to(enemy_target.position) > COMBAT_DISTANCE:
				enemy_target == null
				$Combat_Timer.start()
				can_attack = false
				state = State.Moving
				return
			if can_attack:
				attack(enemy_target)
		
		State.Boarding:
			if enemy_target == null or enemy_target.state != State.Imobilised:
				stop_boarding()
				

func player_movement(delta):
	"""
	move the player based on inputs
	"""
	if self.team == Team.Player:
		if right == true:
			$ShotRadius.rotation_degrees += 4.5
			if $ManOWar.frame == 79:
				$ManOWar.frame = 0

			else:
				$ManOWar.frame += 1
				
		if left == true:
			$ShotRadius.rotation_degrees -= 4.5
			if $ManOWar.frame == 0:
				$ManOWar.frame = 79
			else:
				$ManOWar.frame -= 1
		if forward == true:
			var angle_deg = float($ManOWar.frame) * 4.5
			var angle_rad = deg_to_rad(angle_deg)
			
			var forwar = Vector2(cos(angle_rad), sin(angle_rad))
			
			
			velocity = forwar * 100
			move_and_slide()
		
		if knock_back == true:
			velocity = -global_position.direction_to(source_pos) * 1000
			move_and_slide()
		
		
func get_direction_flags(angle: float) -> Dictionary:
	# Convert radians to degrees for easier reasoning
	var deg = rad_to_deg(angle)

	# Normalize to -180..180
	if deg > 180:
		deg -= 360
	elif deg < -180:
		deg += 360

	# Initialize flags
	var flags = {
		"LEFT": false,
		"RIGHT": false,
		"UP": false,
		"DOWN": false,
		"TOP_LEFT": false,
		"TOP_RIGHT": false,
		"BOTTOM_LEFT": false,
		"BOTTOM_RIGHT": false
	}

	# Each slice is 45° wide
	if deg >= -22.5 and deg < 22.5:
		flags["RIGHT"] = true
	elif deg >= 22.5 and deg < 67.5:
		flags["BOTTOM_RIGHT"] = true
	elif deg >= 67.5 and deg < 112.5:
		flags["DOWN"] = true
	elif deg >= 112.5 and deg < 157.5:
		flags["BOTTOM_LEFT"] = true
	elif deg >= 157.5 or deg < -157.5:
		flags["LEFT"] = true
	elif deg >= -157.5 and deg < -112.5:
		flags["TOP_LEFT"] = true
	elif deg >= -112.5 and deg < -67.5:
		flags["UP"] = true
	elif deg >= -67.5 and deg < -22.5:
		flags["TOP_RIGHT"] = true

	return flags
func decide_animation(direction : Dictionary)->void:
	"""
	right now this just decides what colour the ship flag is, and what image the 
	ship is. Later on ill use this to trigger the animation player
	"""
	#decide the image
	ship_ims.frame = ship_type
	#decide the ships flags and sails
	
	#to allow for swaying
	if round($ManOWar.rotation_degrees) == sway_strength:
		right_sway = false
		left_sway = true
		
	if round($ManOWar.rotation_degrees) == -sway_strength:
		right_sway = true
		left_sway = false
		
	if right_sway == true:
		$ManOWar.rotation_degrees = lerp($ManOWar.rotation_degrees, sway_strength, sway_speed)

	
	if left_sway == true:
		$ManOWar.rotation_degrees = lerp($ManOWar.rotation_degrees, -sway_strength, sway_speed)
	
	
	#colour of flags
	if self.team == Team.Player:
		ship_flag.modulate = team_colour
	else:
		ship_flag.modulate = enemy_colour

func knock_back_func(dir):
	"""
	a knockback function, could be used if being hit by a cannon or a wave
	"""
	knock_back = true
	source_pos = dir
	knock_back_timer.start()

############
#
#   Signal Functions
#
############

func _on_area_2d_mouse_exited() -> void:
	if self in player.over_units:
		player.over_units.erase(self)


func _on_combat_timer_timeout() -> void:
	can_attack = true


func _on_flee_timer_timeout() -> void:
	fleeing = false

func _on_knock_back_timer_timeout() -> void:
	knock_back = false
	
func _on_boarding_timer_timeout() -> void:
	if state != State.Boarding:
		return
	if enemy_target == null:
		stop_boarding()
		return
	enemy_target.capture()
	enemy_target = null
	state = State.Moving


func _on_fire_timer_timeout() -> void:
	if fire_time > 0:
		take_damage(Ability_Values.Fire_Dam, null)
		$Fire_Timer.start()


func _on_area_2d_area_entered(area: Area2D) -> void:
	#work out if the player hits a wave
	if area.get_parent().has_method("is_wave"):
		knock_back_func(area.get_parent().global_position)


func _on_area_2d_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
