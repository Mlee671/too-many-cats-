extends Enemy

@export var projectile := preload("res://entities/enemy/components/attacks/projectile.tscn") 
@export var projectile_speed := 50
@export var attack_rate : float = 1.0

@export var orbit_rate := 1.0

var orbit_dist := 80.0
var chase_dist := orbit_dist * 1.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = 30.0
	accel = 10.0
	pathfind_range = 6
	health.set_health(100)
	super._ready()

func attack_logic(_delta: float) -> void:
	var player_enemy_vec := global_position - raycast_target.global_position
	var player_enemy_direction := player_enemy_vec.normalized()
	var player_enemy_dist := player_enemy_vec.length()

	# if not in range, move to range
	if player_enemy_dist > chase_dist:
		nav_agent.target_position = raycast_target.global_position + (player_enemy_direction * orbit_dist)

	# if in range, orbit around player
	if nav_agent.is_navigation_finished():
		var orbit_vector = player_enemy_direction.rotated(randf_range(-PI / 4, PI / 4))
		nav_agent.target_position = raycast_target.global_position + (orbit_vector * orbit_dist)
	
	if not attack_cooldown:
		var attack := projectile.instantiate()
		attack.set_velocity(-player_enemy_direction * 50)
		attack.global_position = global_position
		get_tree().root.add_child(attack)
		attack_cooldown = true
		attack_timer.start(1.0 / attack_rate)
	
