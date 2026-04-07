extends CharacterBody2D
class_name Enemy

@export var tilemap: TileMapLayer
@export var vision_range: float

var move_speed: float
var accel: float
var pathfind_range: int # tile range to pathfind to

## Emitted when enemy has taken damage
signal damage(amount: int)
## Emitted when enemy has received healing
signal heal(amount: int)

# the assumption that enemies do not de-aggro
enum BEHAVIOUR {WANDER, ATTACK, DEAD, INACTIVE}

var enemyState := BEHAVIOUR.WANDER
var wander_stalling := false
var raycast_target: Node2D = null

# debug flag for if attack is implemented - only one message activation
var attack_logic_flag := false

@onready var wander_timer := $WanderTimer
@onready var nav_agent := $NavigationAgent2D
@onready var vision := $VisionRadius
@onready var health := $HealthBar
@onready var animation := $AnimationPlayer
@onready var visual := $Visuals
@onready var hitbox := $Hitbox
@onready var vision_circle := $VisionArea/VisionCircle


func _ready() -> void:
	vision_circle.shape.radius = vision_range
	setup_nav.call_deferred()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_damage_enemy"):
		animation.play_animation("damaged")
		animation.no_interrupt = true
		await animation.animation_finished
		animation.no_interrupt = false
	
	if vision.can_see_player(raycast_target):
		enemyState = BEHAVIOUR.ATTACK
		# stop vector drift from interrupting path
		nav_agent.target_position = global_position
		nav_agent.set_velocity(Vector2.ZERO)
	if enemyState == BEHAVIOUR.WANDER and not wander_stalling:
		# if at target node, get new target node
		if nav_agent.is_navigation_finished():
			wander_stalling = true
			wander_timer.start(randf_range(1.0, 2.0))
			animation.play_animation("idle")
			return

		# get new direction to get to next path node
		var new_velocity: Vector2 = (
				(nav_agent.get_next_path_position() - global_position)
				.normalized()* move_speed)
		var smooth_velocity: Vector2 = lerp(velocity,
				new_velocity,
				accel * delta)
		nav_agent.set_velocity(smooth_velocity)
		animation.play_animation("moving")
		
		# enemy looks left or right based on vector.x
		if smooth_velocity.x < 0:
			visual.scale.x = -1
		else:
			visual.scale.x = 1
	
	# if attacking user, run corresponding logic
	elif enemyState == BEHAVIOUR.ATTACK:
		attack_logic()
		# enemy should look left or right based on raycast to player


## navigation agent handles movement after adjusting vector
func _on_nav_dist_adjust(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func _on_wander_timeout() -> void:
	wander_stalling = false
	set_wander_target()


## Generic on death function:
## - Plays death animation
## - prevents movement
## - removes hitbox
## - removes instance after animation plays
func _on_death() -> void:
	animation.play_animation("death")
	enemyState = BEHAVIOUR.DEAD
	nav_agent.set_velocity(Vector2.ZERO)
	hitbox.set_deferred("disabled", true)
	animation.no_interrupt = true
	await animation.animation_finished
	queue_free()


func _on_attack_timeout() -> void:
	pass # Replace with function body.

func _on_vision_area_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		raycast_target = body
	
func _on_vision_area_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		raycast_target = null

func nearby_vector(tile_range: Vector2) -> Vector2:
	return Vector2(
		randf_range(position.x - tile_range.x, position.x + tile_range.x),
		randf_range(position.y - tile_range.y, position.y + tile_range.y))


func setup_nav() -> void:
	# wait until map sync
	while tilemap == null:
		await get_tree().process_frame
	set_wander_target()


func set_wander_target() -> void:
	nav_agent.target_position = nearby_vector(
			tilemap.map_to_local(Vector2i(pathfind_range, pathfind_range)))


func attack_logic() -> void:
	if not attack_logic_flag:
		attack_logic_flag = true
		push_warning("Attack Logic not implemented. Must be overwritten.")
