extends Enemy
class_name RangedEnemy

const PROJECTILE := preload("res://entities/enemy/components/projectile/enemy_projectile.tscn") 

const ACCELERATION := 10.0
const WEIGHT := 2
const ORBIT_DIST := 80.0
const CHASE_DIST := ORBIT_DIST * 1.3
const VISION := 80.0

# functionally const, var because of subclassing
var ATTACKS_PER_SECOND := 1.0
var PROJECTILE_SPEED := 75
var SPEED := 15.0
var HP := 100

var frame := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = SPEED
	accel = ACCELERATION
	mass_coef = WEIGHT
	health.set_health(HP)
	vision_range = VISION
	super()

func fire_bullet(dir: Vector2, pos: Vector2):
	var attack := PROJECTILE.instantiate()
	animation.play_animation("attack", true)
	attack.set_velocity(dir * PROJECTILE_SPEED)
	get_parent().add_child(attack)
	attack.global_position = pos

func attack_check(dir: Vector2, pos: Vector2):
	if not attack_cooldown:
		fire_bullet(
			dir,
			pos
		)
		attack_cooldown = true
		attack_timer.start(1.0 / ATTACKS_PER_SECOND)

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
	
	attack_check(
			-player_enemy_direction,
			global_position + attack_offset)
	
