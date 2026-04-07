extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = 30.0
	accel = 20.0
	pathfind_range = 6
	health.set_health(100)
	super._ready()

func attack_logic(delta: float) -> void:
	var maintain_dist := 50.0
	var player_enemy_direction := (global_position - raycast_target.global_position).normalized()
	nav_agent.target_position = player_enemy_direction * maintain_dist
	
	var new_velocity: Vector2 = (
			(nav_agent.get_next_path_position() - global_position)
			.normalized() * move_speed)
	var smooth_velocity: Vector2 = lerp(velocity,
			new_velocity,
			accel * delta)
	nav_agent.set_velocity(smooth_velocity)
	animation.play_animation("moving")
	
	if not attack_cooldown:
		# inst bullet
		# aim raycast target and deploy
		pass
	
