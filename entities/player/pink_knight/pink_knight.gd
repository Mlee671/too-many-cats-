extends main_character
class_name PinkKnight

const SPREAD_DEG := 30
const ATTACK_KNOCKBACK := 250.0

const ABILITY_DURATION := 1.5

var ability_on_cooldown := false

@onready var uptime_timer = $AbilityUptimeTimer

func attack(target: Vector2) -> void:
	Sfx_Manager.play_sound_effect_from_dictionary("sword_light")
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	var mouse_angle = target.normalized()
	for angle in [-(SPREAD_DEG / 2.0), 0, SPREAD_DEG / 2.0]:
		var spawn = PROJECTILE.instantiate()
		spawn.proj_frame = stats.projectile_frame
		var direction = mouse_angle.rotated(deg_to_rad(angle))
		spawn.look_at(direction)
		spawn.set_velocity(direction * stats.projectile_speed)
		spawn.set_knockback(stats.projectile_knockback)
		spawn.set_damage(stats.damage)
		spawn.global_position = $AttackMarker.global_position + (ATTACK_OFFSET * direction)
		get_parent().add_child(spawn)
	add_knockback(-target.normalized() * ATTACK_KNOCKBACK)

func character_ability():
	super()
	char_visual.modulate = Color(0.92, 0.246, 0.744, 1.0)
	# start ability timer
	if !ability_on_cooldown:
		uptime_timer.start(ABILITY_DURATION)
		# change attack rate
		stats.fire_cd /= 6
		ability_on_cooldown = true


func _on_ability_uptime_timeout() -> void:
	char_visual.modulate = Color(1.0, 1.0, 1.0, 1.0)
	stats.fire_cd *= 6
	ability_on_cooldown = false
