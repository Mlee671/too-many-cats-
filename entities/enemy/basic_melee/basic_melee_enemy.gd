extends Enemy
class_name BasicMeleeEnemy

@export var melee := preload("res://entities/enemy/components/attacks/slash/slash.tscn") 
@export var speed := 80.0
@export var acceleration := 20.0
@export var wander_range := 6
@export var hp := 100
@export var attack_rate : float = 1.0

## The distance the melee attack spawns from the enemy position
@export var attack_offset_magnitude := 20

var current_attack : Slash = null
var attack_offset : Vector2

func _ready() -> void:
	move_speed = speed
	accel = acceleration
	pathfind_range = wander_range
	health.set_health(hp)
	super._ready()

func attack_logic() -> void:

	var player_enemy_vec := raycast_target.global_position - global_position
	var player_enemy_dist := player_enemy_vec.length()

	# move to player directly
	nav_agent.target_position = raycast_target.global_position
	
	if not attack_cooldown and player_enemy_dist < attack_offset_magnitude:
		current_attack = melee.instantiate()
		# point toward player
		current_attack.global_position = global_position
		current_attack.look_at(raycast_target.global_position)
		attack_offset = player_enemy_vec.normalized() * attack_offset_magnitude
		current_attack.global_position += attack_offset
		# put attack on cooldown, based on inverse attack rate (higher val = lower cd)
		get_tree().root.add_child(current_attack)
		attack_cooldown = true
		attack_timer.start(1.0 / attack_rate)
	elif attack_cooldown and current_attack != null:
		current_attack.global_position = global_position + attack_offset
