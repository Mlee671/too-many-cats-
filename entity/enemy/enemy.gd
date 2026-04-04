extends CharacterBody2D
class_name Enemy

@export var tilemap: TileMapLayer

@export var move_speed: float
var accel: int

enum BEHAVIOUR {WANDER, ATTACK}

var enemyState := BEHAVIOUR.WANDER
var wander_stalling := false

#move
#nav
#proc on char sight
#hp signals
#

@onready var wander_timer := $wander_stall_timer
@onready var nav_agent := $NavigationAgent2D

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
	print(nav_agent.target_position)

# empty function to fill with attack behaviour for subclasses
func attack_logic() -> void:
	push_error("Attack logic for enemy not implemented, must be overwritten.")

func _physics_process(_delta) -> void:
	if enemyState == BEHAVIOUR.WANDER and not wander_stalling:
		# if at target node, get new target node
		if nav_agent.is_navigation_finished():
			wander_stalling = true
			wander_timer.start(2)

		# get new direction to get to next path node
		var new_velocity: Vector2 = (nav_agent.get_next_path_position() - global_position).normalized() * move_speed
		nav_agent.set_velocity(new_velocity)
	
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
