extends CharacterBody2D
class_name main_character

# loads the bullet scene when starting the game
# TODO: replace with child node to generate within (e.g. AttackComponent)
@onready var projectile := preload("res://entities/player/attacks/Bullet.tscn")

@onready var attack_timer := $AttackTimer
@onready var evade_timer := $EvadeTimer
@onready var animate_2d_sprite := $CharacterVisuals/AnimatedSprite2D
@onready var char_visual := $CharacterVisuals
@onready var stats := $Stats

enum evadeState {READY, ACTIVE, COOLDOWN}

var attack_cooldown := false
var evade_flag = evadeState.READY
var is_alive := true

func _ready() -> void:
	add_to_group("Player")
	animate_2d_sprite.play("idle")
	
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
	if (Input.is_action_just_pressed("ability")
			and evade_flag == evadeState.READY):
		# change sprite
		animate_2d_sprite.play("dodge")
		evade_flag = evadeState.ACTIVE
		evade_timer.start(stats.evade_dur);
		
	# move and animate if not in dodge state
	move_and_slide()
	if evade_flag != evadeState.ACTIVE:
		handle_animation()

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


## Called by enemy attacks when colliding with body. Currently does nothing.
func take_damage(amount: int):
	print("[DEBUG] Player taken ", amount, " damage")

## Sets run animation when in motion, otherwise idle animation.
func handle_animation():
	if velocity.length_squared() > 0.5:
		animate_2d_sprite.play("run")
	else:
		animate_2d_sprite.play("idle")
