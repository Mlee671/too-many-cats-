extends CharacterBody2D
class_name main_character


# loads the bullet scene when starting the game
# TODO: replace with child node to generate within (e.g. AttackComponent)
@onready var projectile := preload("res://entities/player/attacks/Bullet.tscn")

@onready var attack_timer := $AttackTimer
@onready var evade_timer := $EvadeTimer
@onready var ability_timer := $AbilityTimer
#@onready var animation_player := $CharacterVisuals/AnimatedSprite2D
@onready var char_visual := $CharacterVisuals
@onready var stats := $Stats
@onready var animation_tree := $CharacterVisuals/AnimationTree

enum evadeState {READY, ACTIVE, COOLDOWN}

var attack_cooldown := false
var evade_flag = evadeState.READY
var ability_cooldown := false
var is_alive := true
var doors_lock := false

func _ready() -> void:
	SignalBus.room_lock.connect(_on_room_lock)
	stats.player_state = Stats.states.IDLE
	add_to_group("Player")
	#animation_player.play("idle")
	
func _process(_delta: float) -> void:
	# flip character based on mouse position
	if get_local_mouse_position().x < 0:
		char_visual.scale.x = -1
	else:
		char_visual.scale.x = 1
	
func _physics_process(delta: float) -> void:
	# gets directional vector based on keypress
	var input_vector = Input.get_vector("left", "right", "up", "down")
	
	# scales movement speed if dodging
	if evade_flag == evadeState.ACTIVE:
		stats.player_state = Stats.states.DODGING
		velocity = lerp(velocity,
				input_vector * stats.speed * stats.evade_movement_scaling,
				stats.accel * delta)
	else:
		velocity = lerp(velocity,
				input_vector * stats.speed,
				stats.accel * delta)
	
		# if user presses attack key
		if Input.is_action_pressed("fire_gun") and not attack_cooldown:
			fire_gun(get_local_mouse_position())
	
	# if user presses dodge key
	if (Input.is_action_just_pressed("evade")
			and evade_flag == evadeState.READY):
		# change sprite
		#animation_player.play("dodge")
		evade_flag = evadeState.ACTIVE
		evade_timer.start(stats.evade_dur);
		
	if (Input.is_action_just_pressed("ability")
			and not ability_cooldown):
		character_ability()
		# start cooldown
		ability_cooldown = true
		ability_timer.start(stats.ability_cd)
		
	if Input.is_action_just_pressed("debug_lock_doors"):
		doors_lock = !doors_lock
		
	# move and animate if not in dodge state
	move_and_slide()
	if evade_flag != evadeState.ACTIVE:
		handle_animation()
	

func _on_room_lock(locked: bool) -> void:
	doors_lock = locked

# when attack cooldown finishes
func _on_attack_timeout() -> void:
	attack_cooldown = false

# when evade cooldown finishes
func _on_evade_timeout() -> void:
	# after active, evade is cooldown
	if evade_flag == evadeState.ACTIVE:
		evade_flag = evadeState.COOLDOWN
		evade_timer.start(stats.evade_cd)
		
	# after cooldown, evade is ready
	elif evade_flag == evadeState.COOLDOWN:
		evade_flag = evadeState.READY

func _on_ability_timeout() -> void:
	ability_cooldown = false

func swap_character() -> void:
	# dodge should skip straight to cooldown to prevent abuse
	evade_flag = evadeState.COOLDOWN
	handle_animation() # force change animation away from dodge
	evade_timer.start(stats.evade_cd)

## Creates bullet instance and fires from sprite to target vector.
func fire_gun(target: Vector2) -> void:
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	
	# Instantiates bullet
	var spawn = projectile.instantiate()
	var direction = target.normalized()
	spawn.velocity = direction * spawn.speed
	
	# spawn at sprite position in main scene, shifted
	# for where the sprite hands would be (presumably) 
	spawn.position = position + Vector2(8,8) * direction + Vector2(0,-8)
	get_parent().add_child(spawn)
	stats.shots_fired += 1


func character_ability():
	var teleport_path: PackedVector2Array
	# if locked, disable nav tiles at and around doors via bit mask
	if doors_lock:
		teleport_path = NavigationServer2D.map_get_path(
					get_world_2d().get_navigation_map(),
					global_position, get_global_mouse_position(),
					false, 2)
	else:
		teleport_path = NavigationServer2D.map_get_path(
				get_world_2d().get_navigation_map(),
				global_position, get_global_mouse_position(),
				false, 6)
	# go to final calculated path node
	global_position = teleport_path[-1]


## Called by enemy attacks when colliding with body. Currently does nothing.
func take_damage(amount: int):
	print("[DEBUG] Player taken ", amount, " damage")

## Sets run animation when in motion, otherwise idle animation.
func handle_animation():
	if velocity.length_squared() > 0.5:
		stats.player_state = Stats.states.RUNNING
		#animation_player.play("run")
	else:
		stats.player_state = Stats.states.IDLE
		#animation_player.play("idle")
