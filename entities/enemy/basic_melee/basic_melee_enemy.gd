extends Enemy
class_name BasicMeleeEnemy

const ATTACK_PROC_DISTANCE := 27.0

@export var melee := preload("res://entities/enemy/components/attacks/slash/slash.tscn") 
@export var speed := 50.0
@export var acceleration := 20.0
@export var wander_range := 6
@export var hp := 100
@export var attack_rate : float = 1.0

## The distance the melee attack spawns from the enemy position
@export var attack_offset_magnitude := 20.0

var current_attack : Slash = null
var attack_offset : Vector2

func _ready() -> void:
	move_speed = speed
	accel = acceleration
	pathfind_range = wander_range
	health.set_health(hp)
	super._ready()

func attack_logic() -> void:

	var player_enemy_vec := global_position.direction_to(raycast_target.global_position)
	var player_enemy_dist := global_position.distance_squared_to(raycast_target.global_position)

	# move to player directly
	nav_agent.target_position = raycast_target.global_position
	
	if not attack_cooldown and player_enemy_dist < ATTACK_PROC_DISTANCE ** 2:
		animation.play_animation("attack")
		animation.no_interrupt = true
		current_attack = melee.instantiate()
		# point toward player
		current_attack.global_position = global_position
		current_attack.look_at(raycast_target.global_position)
		attack_offset = player_enemy_vec * attack_offset_magnitude
		current_attack.global_position += attack_offset
		# put attack on cooldown, based on inverse attack rate (higher val = lower cd)
		get_tree().root.add_child(current_attack)
		attack_cooldown = true
		nav_agent.set_velocity(Vector2.ZERO)
		attack_timer.start(1.0 / attack_rate)
	
	# if attacking, hitbox should stick to enemy
	elif attack_cooldown and current_attack != null:
		current_attack.global_position = global_position + attack_offset
