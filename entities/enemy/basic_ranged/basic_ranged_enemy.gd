extends Enemy
class_name RangedEnemy

const PROJECTILE := preload("res://entities/enemy/components/projectile/enemy_projectile.tscn") 
const SPEED := 15.0
const ACCELERATION := 10.0
const HP := 100
const WEIGHT := 2
const ATTACKS_PER_SECOND := 1.0
const PROJECTILE_SPEED := 75
const ORBIT_DIST := 80.0
const CHASE_DIST := ORBIT_DIST * 1.3

var frame := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = SPEED
	accel = ACCELERATION
	mass_coef = WEIGHT
	health.set_health(HP)
	super()
	

func attack_logic() -> void:
	var attack_offset = $AttackOffset.position * _look_vector_direction(
			global_position.direction_to(raycast_target.global_position))
	var player_enemy_vec :Vector2 = global_position - raycast_target.global_position + attack_offset
	var player_enemy_direction := player_enemy_vec.normalized()
	var player_enemy_dist := player_enemy_vec.length()

	if frame % 10 == 0:
		# if not in range, move within chase range
		if player_enemy_dist > CHASE_DIST:
			nav_agent.target_position = (raycast_target.global_position +
					(player_enemy_direction * ORBIT_DIST))
		# if in range, orbit path around player (random cw or acw)
		elif nav_agent.is_navigation_finished():
			var orbit_vector = player_enemy_direction.rotated(
					randf_range(-PI / 4, PI / 4))
			nav_agent.target_position = (raycast_target.global_position
					+ (orbit_vector * ORBIT_DIST))
	frame += 1
	
	if not attack_cooldown:
		var attack := PROJECTILE.instantiate()
		animation.play_animation("attack", true)
		# point bullet toward player (inverting path calc vector) and apply speed
		attack.set_velocity(-player_enemy_direction * PROJECTILE_SPEED)
		get_parent().add_child(attack)
		attack.global_position = global_position + attack_offset
		# put attack on cooldown, based on inverse attack rate (higher val = lower cd)
		attack_cooldown = true
		attack_timer.start(1.0 / ATTACKS_PER_SECOND)
	
