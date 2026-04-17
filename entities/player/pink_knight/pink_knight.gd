extends main_character
class_name pink_knight

func fire_gun(target: Vector2) -> void:
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	var mouse_angle = target.normalized()
	for angle in [-15, 0, 15]:
		var spawn = projectile.instantiate()
		var direction = mouse_angle.rotated(deg_to_rad(angle))
		spawn.velocity = direction * projectile_speed
	
		# spawn at sprite position in main scene, shifted
		# for where the sprite hands would be (presumably) 
		spawn.position = position + Vector2(8,8) * direction + Vector2(0,-8)
		get_parent().add_child(spawn)
	stats.shots_fired += 1

func character_ability():
	pass
