extends CharacterBody2D
class_name Enemy

@export var tilemap: TileMapLayer

@export var move_speed: float
@export var accel: int

## Emitted when enemy has taken damage
signal damage(amount: int)
## Emitted when enemy has received healing
signal heal(amount: int)

enum BEHAVIOUR {WANDER, ATTACK}

var enemyState := BEHAVIOUR.WANDER
var wander_stalling := false

#proc on char sight

@onready var wander_timer := $WanderTimer
@onready var nav_agent := $NavigationAgent2D
@onready var health := $HealthBar

func nearby_vector(range: Vector2) -> Vector2i:
	return Vector2i(
		randi_range(position.x - range.x, position.x + range.x),
		randi_range(position.y - range.y, position.y + range.y))

func _ready() -> void:
	setup_nav.call_deferred()

func setup_nav() -> void:
	while tilemap == null:
		await get_tree().process_frame
	# wait until map sync
	await get_tree().physics_frame
	set_wander_target()

func set_wander_target() -> void:
	nav_agent.target_position = nearby_vector(tilemap.map_to_local(Vector2i(6, 6)))

func attack_logic() -> void:
	push_error("Attack Logic not implemented. Must be overwritten.")

func _physics_process(delta: float) -> void:
	if enemyState == BEHAVIOUR.WANDER and not wander_stalling:
		# if at target node, get new target node
		if nav_agent.is_navigation_finished():
			wander_stalling = true
			wander_timer.start(randf_range(1.0, 2.0))

		# get new direction to get to next path node
		var new_velocity: Vector2 = (nav_agent.get_next_path_position() - global_position).normalized() * move_speed
		var smooth_velocity: Vector2 = lerp(velocity, new_velocity, accel * delta)
		nav_agent.set_velocity(smooth_velocity)
	
	# if attacking user, run corresponding logic
	elif enemyState == BEHAVIOUR.ATTACK:
		attack_logic()

## navigation agent handles movement after adjusting vector
func _on_nav_dist_adjust(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_wander_timeout() -> void:
	wander_stalling = false
	set_wander_target()

func _on_death() -> void:
	pass # Replace with function body.
