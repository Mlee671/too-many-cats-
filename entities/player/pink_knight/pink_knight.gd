extends main_character
class_name pink_knight

const ATTACK_KNOCKBACK := 300.0
@onready var uptime_timer = $AbilityUptimeTimer

func fire_gun(target: Vector2) -> void:
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	var mouse_angle = target.normalized()
	for angle in [-15, 0, 15]:
		var spawn = projectile.instantiate()
		var direction = mouse_angle.rotated(deg_to_rad(angle))
		spawn.velocity = direction * projectile_speed
		spawn.position = position + Vector2(8,8) * direction + Vector2(0,-8)
		get_parent().add_child(spawn)
	stats.shots_fired += 1
	add_knockback(-target.normalized() * ATTACK_KNOCKBACK)

func character_ability():
	# start ability timer
	uptime_timer.start(stats.ability_dur)
	# change attack rate
	stats.fire_cd /= 2


func _on_ability_uptime_timeout() -> void:
	stats.fire_cd *= 2
