extends Enemy

@export var projectile := preload("res://entities/enemy/components/attacks/projectile.tscn") 
@export var projectile_speed := 50
@export var attack_rate : float = 1.0

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
		var attack := projectile.instantiate()
		attack.set_velocity(-player_enemy_direction * 50)
		attack.global_position = global_position
		get_tree().root.add_child(attack)
		attack_cooldown = true
		attack_timer.start(1.0 / attack_rate)
		# inst bullet
		# aim raycast target and deploy
		pass
	
