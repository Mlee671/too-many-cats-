extends CharacterBody2D
class_name main_character

# loads the bullet scene when starting the game
@onready var projectile := preload("res://entity/Projectiles/Bullet.tscn")
# gets a reference to the cooldown timer
@onready var attack_cooldown := $attack_cooldown
@onready var evade_timer := $evade_timer
@onready var animate_2d_sprite := $char_visual/AnimatedSprite2D
@onready var char_visual := $char_visual
@onready var stats := $Stats

# current_character_scene
@onready var cm = $"../character_manager"
# noting 3 states. more verbose than 0,1,2
enum evadeState {READY, ACTIVE, COOLDOWN}

var on_cooldown := false

# probably use this for i-frame checking (if evadeState.ACTIVE)
var evade_flag = evadeState.READY

func _ready() -> void:
	animate_2d_sprite.play("idle")
	pass
	
func _process(_delta: float) -> void:
	# flip character based on mouse position
	if get_local_mouse_position().x < 0:
		char_visual.scale.x = -1
	else:
		char_visual.scale.x = 1
	
func _physics_process(delta: float) -> void:
	
	# scans if wasd is pressed then returns a Vector2. x direction is left/right. y is up/down 
	var input_vector = Input.get_vector("Left", "Right", "Up", "Down")
	
	if evade_flag == evadeState.ACTIVE:
		# probably can't shoot during dodge
		velocity = lerp(velocity, input_vector * stats.speed * stats.evade_movement_scaling, stats.accel * delta)
	else:
		# sets the velocity. lerp is an acceleration function(starting speed, target speed, accel factor)
		velocity = lerp(velocity, input_vector * stats.speed, stats.accel * delta)
	
		# checks if your left clicking
		if Input.is_action_pressed("fire_gun"):
			if not on_cooldown:
				fire_gun(get_local_mouse_position())
	
	# current implementation, cannot hold down to spam dodge - makes more sense to me
	if Input.is_action_just_pressed("ability") and evade_flag == evadeState.READY:
		# change sprite
		animate_2d_sprite.play("dodge")
		evade_flag = evadeState.ACTIVE
		evade_timer.start(stats.evade_dur);
	
	if Input.is_action_just_pressed("character_change"):
		cm.switch()
		pass
		
	# physics procees for moving a character2D, returns bool if collision
	move_and_slide()
	if evade_flag != evadeState.ACTIVE:
		handle_animation()

			
func fire_gun(target):
	on_cooldown = true
	# starts timer
	attack_cooldown.start(stats.fire_cd)
	# method for spawning a new bullet
	var spawn = projectile.instantiate()
	var direction = target.normalized()
	spawn.velocity = direction * spawn.speed
	spawn.position = position + Vector2(8,8) * direction + Vector2(0,-8)
	# adds it to the main node otherwise it would move when we move
	get_parent().add_child(spawn)
	stats.shots_fired += 1

# is called when timer hits zero
func _on_cooldown_timeout() -> void:
	on_cooldown = false

func _on_evade_active_timeout() -> void:
	if evade_flag == evadeState.ACTIVE:
		# set to cooldown state
		evade_flag = evadeState.COOLDOWN

		evade_timer.start(stats.evade_cd)
	elif evade_flag == evadeState.COOLDOWN:
		evade_flag = evadeState.READY
		
func handle_animation():
	if velocity.length_squared() > 0.5:
		animate_2d_sprite.play("run")
	else:
		animate_2d_sprite.play("idle")
