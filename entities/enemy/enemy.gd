extends CharacterBody2D
class_name Enemy

@export var tilemap: TileMapLayer
@export var vision_range: float

var move_speed: float
var accel: float
var pathfind_range: int # tile range to pathfind to

enum BEHAVIOUR {WANDER, ATTACK, DEAD, INACTIVE}

var enemyState := BEHAVIOUR.INACTIVE
var raycast_target: Node2D
var attack_cooldown := false
var stop_moving := false

# debug flag for if attack is implemented - only one message activation
var attack_logic_flag := false

@onready var wander_timer := $WanderTimer
@onready var attack_timer := $AttackTimer
@onready var nav_agent := $NavigationAgent2D
@onready var vision := $VisionRadius
@onready var health := $HealthBar
@onready var animation := $AnimationPlayer
@onready var visual := $Visuals
@onready var hitbox := $Hitbox
@onready var vision_circle := $VisionArea/VisionCircle


func _ready() -> void:
	vision_circle.shape.radius = 0
	vision.set_enabled(false)
	# once room triggers are implemented, this can be removed
	# setup_nav()


func _physics_process(delta: float) -> void:
	if enemyState == BEHAVIOUR.INACTIVE: # does nothing if inactive
		return
	
	if Input.is_action_just_pressed("debug_damage_enemy"):
		take_damage(50)

	# should not go through move logic if dead
	if enemyState != BEHAVIOUR.DEAD and not stop_moving:
		_move(delta)

	if enemyState == BEHAVIOUR.WANDER:
		if vision.is_enabled() and vision.can_see_player(raycast_target):
			enemyState = BEHAVIOUR.ATTACK
			$VisionArea.monitoring = false
		
		if not stop_moving:
			# if at target node, get new target node
			if nav_agent.is_navigation_finished():
				stop_moving = true
				nav_agent.set_velocity(Vector2.ZERO)
				wander_timer.start(randf_range(1.0, 2.0))
				animation.play_animation("idle")
				return
			_look_vector_direction(velocity)
		
	elif enemyState == BEHAVIOUR.ATTACK:
		# raycast_target = get_tree().get_first_node_in_group("Player")
		attack_logic()
		# look in direction of player
		_look_vector_direction(global_position.direction_to(raycast_target.global_position))


func _move(delta: float) -> void:
	# get new direction to get to next path node
	var new_velocity: Vector2 = (
			(nav_agent.get_next_path_position() - global_position)
			.normalized() * move_speed)
	var smooth_velocity: Vector2 = lerp(velocity,
			new_velocity,
			accel * delta)
	nav_agent.set_velocity(smooth_velocity)
	animation.play_animation("moving")
	

func _look_vector_direction(direction: Vector2):
	# enemy looks left or right based on vector.x
	if direction.x < 0:
		visual.scale.x = -1
	else:
		visual.scale.x = 1

## navigation agent handles movement after adjusting vector
func _on_nav_dist_adjust(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_wander_timeout() -> void:
	stop_moving = false
	set_wander_target()


## Generic on death function:
## - Plays death animation (force overwrite current animations)
## - prevents movement
## - removes hitbox
## - removes instance after animation plays
func _on_death() -> void:
	animation.no_interrupt = false
	animation.play_animation("death", true)
	enemyState = BEHAVIOUR.DEAD
	nav_agent.set_velocity(Vector2.ZERO)
	hitbox.set_deferred("disabled", true)
	await animation.animation_finished
	get_parent().enemy_died()
	queue_free()


func _on_attack_timeout() -> void:
	attack_cooldown = false
	stop_moving = false


## Only has mask on player layer, thus group check not required afaik
func _on_vision_area_entered(body: Node2D) -> void:
	if body is main_character:
		vision.set_enabled(true)
		raycast_target = body


func _on_vision_area_exited(body: Node2D) -> void:
	if body is main_character:
		vision.set_enabled(false)


## Activates enemy to wander and attack, not stationary.
func activate_enemy() -> void:
	enemyState = BEHAVIOUR.WANDER
	vision_circle.shape.radius = vision_range
	set_wander_target()
	
func deactivate_enemy() -> void:
	enemyState = BEHAVIOUR.INACTIVE
	velocity = Vector2(0,0)
	$VisionArea.monitoring = true


func nearby_vector(tile_range: Vector2) -> Vector2:
	return Vector2(
		randf_range(global_position.x - tile_range.x, global_position.x + tile_range.x),
		randf_range(global_position.y - tile_range.y, global_position.y + tile_range.y))


func take_damage(amount: int) -> void:
	# makes sense that dealing damage to an enemy will aggro it
	if enemyState == BEHAVIOUR.WANDER:
		enemyState = BEHAVIOUR.ATTACK
		$VisionArea.monitoring = false
		
	health.take_damage(amount)
	animation.play_animation("damaged", true)


func setup_nav() -> void:
	# wait until map sync
	while tilemap == null:
		await get_tree().process_frame


func set_wander_target() -> void:
	nav_agent.target_position = nearby_vector(
		(Vector2i(pathfind_range*16, pathfind_range*16)))


func attack_logic() -> void:
	if not attack_logic_flag:
		attack_logic_flag = true
		push_warning("Attack Logic not implemented. Must be overwritten.")
