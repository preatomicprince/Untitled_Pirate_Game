class_name Ship extends CharacterBody2D

@onready var ship_ims : Sprite2D = $Ships
@onready var ship_flag : Sprite2D = $Flags
@onready var ship_collisions : CollisionShape2D = $CollisionShape2D
@onready var interact_area : CollisionShape2D = $Area2D/CollisionShape2D
var level: Level = null
var player: Player = null

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
	Imobilised
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

# Core stats
var strength: float = 1.0
var speed: float  = 1.0
var health: float = 100.0
var firing_speed: float = 1.0
var boarding_speed: float = 1.0
var accuracy: float = 0.8

const MOVE_SPEED = 50 # Const to change speed of all ships moving

func set_core_stats() -> void:
	self.strength = stats[ship_type][0]
	self.speed = stats[ship_type][1]
	self.health = stats[ship_type][2]
	self.firing_speed = 1.0
	self.boarding_speed = 1.0
	
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
		
	
# Attack multipliers
var town_attack: float = 1.0
var ship_attack: float = 1.0

func set_attack_mult() -> void:
	town_attack = strength
	ship_attack = strength
	
	for i in self.abilities:
		match i:
			Ability_Types.Grapeshot:
				town_attack += Ability_Values.Grapeshot
				ship_attack -= Ability_Values.Grapeshot
			Ability_Types.Artillery:
				town_attack -= Ability_Values.Artillery
				ship_attack += Ability_Values.Artillery

# Ability slots
var abilities = []
var max_abilities = 1

# Navigation
@onready var target_pos: Vector2 = position
@onready var nav_agent: NavigationAgent2D = $nav_agent

var fleeing: bool = false

func actor_setup():
	await get_tree().physics_frame
	set_target_pos(target_pos)
	level = get_parent()
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
const COMBAT_DISTANCE = 50
var can_attack = true

# AI
var path_points: Array = []
var current_point: int = 0
var patrol_back: bool = false # Going backwards?

func get_path_points() -> void:
	for i in range($Path2D.curve.get_point_count()):
		path_points.append($Path2D.curve.get_point_position(i) + position)
		
	print(path_points)

func attack(ship: Ship) -> void:
	if can_attack == false:
		return
	$Combat_Timer.start()
	can_attack = false
	var hit_chance = randfn(0.0, 1.0)
	if hit_chance < accuracy:
		print(self, " Hit ", ship.health)
		ship.take_damage(strength, self)
		
func take_damage(damage: int, attacker: Ship) -> void:
	health -= damage
	if enemy_target == null:
		enemy_target = attacker
	if health <= 0:
		state = State.Imobilised
		#dedug
		visible = false
	
	
func _ready() -> void:
	
	set_core_stats()
	set_attack_mult()
	
	# TODO, ships art but better
	decide_animation()
	# Navigation
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	actor_setup.call_deferred()

func _physics_process(delta):
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
					if position.distance_to(i.position) < COMBAT_DISTANCE && i.state != State.Imobilised:
						if not fleeing or enemy_target != null:
							state = State.Combat
							set_target_pos(position)
							enemy_target = i
							attack(enemy_target)
							return
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
	

func decide_animation()->void:
	"""
	right now this just decides what colour the ship flag is, and what image the 
	ship is. Later on ill use this to trigger the animation player
	"""
	#decide the image
	ship_ims.frame = ship_type
	#decide the ships flags and sails
	
	if self.team == Team.Player:
		ship_flag.modulate = Color()
	else:
		ship_flag.modulate = Color(0.641, 0.515, 0.214, 1.0)


############
#
#   Signal Functions
#
############

func _on_area_2d_mouse_entered() -> void:
	self.player.over_units.append(self)


func _on_area_2d_mouse_exited() -> void:
	if self in player.over_units:
		player.over_units.erase(self)


func _on_combat_timer_timeout() -> void:
	can_attack = true


func _on_flee_timer_timeout() -> void:
	fleeing = false
