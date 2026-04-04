extends CharacterBody2D
class_name Enemy

@export var tilemap: TileMapLayer

@export var move_speed: float
var accel: int

#move
#nav
#proc on char sight
#hp signals
#

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	# Performance tip: Don't update the target every frame if it doesn't move.
	# We wait for the first physics frame so the NavigationServer is ready.
	call_deferred("setup_nav")

func setup_nav():
	# Wait for the first physics frame to ensure the map is synced
	await get_tree().physics_frame
	set_movement_target() # Initialize at current spot

func set_movement_target():
	nav_agent.target_position = _get_new_pos()
# 14,2 24,10
func _get_new_pos():
	return tilemap.map_to_local(Vector2i(randi_range(14,39),randi_range(2,21)))

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		set_movement_target()

	# 1. Find the next point in the path
	var current_agent_position:= global_position
	var next_path_position:= nav_agent.get_next_path_position()

	# 2. get direction, multiply by movement scalar
	var new_velocity:= next_path_position - current_agent_position
	new_velocity = new_velocity.normalized() * move_speed

	nav_agent.set_velocity(new_velocity)

func _on_nav_dist_adjust(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
