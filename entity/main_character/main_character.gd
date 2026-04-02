extends CharacterBody2D
class_name main_character

const DODGE_SPRITE := preload("res://entity/main_character/dodge_placeholder.png")
const BASE_SPRITE := preload("res://entity/main_character/priest3_v2_1.png")

const SPEED := 100
const ACCEL_SMOOTH := 20 # how smooth stop/start movement
const FIRE_COOLDOWN := .5 # firing cd



# loads the bullet scene when starting the game
@onready var projectile := preload("res://entity/Projectiles/Bullet.tscn")

# gets a reference to the cooldown timer
@onready var cooldown := $cooldown
@onready var evade_timer := $evade_timer
@onready var char_sprite := $char_sprite

# noting 3 states. more verbose than 0,1,2
enum evadeState {READY, ACTIVE, COOLDOWN}

var on_cooldown := false
var evade_flag := evadeState.READY

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	# scans if wasd is pressed then returns a Vector2. x direction is left/right. y is up/down 
	var input_vector = Input.get_vector("Left", "Right", "Up", "Down")
	
	if evade_flag == evadeState.ACTIVE:
		# probably can't shoot during dodge
		velocity = lerp(velocity, input_vector * SPEED * 2, ACCEL_SMOOTH * delta)
		pass
	else:
		# sets the velocity. lerp is an acceleration function(starting speed, target speed, accel factor)
		velocity = lerp(velocity, input_vector * SPEED, ACCEL_SMOOTH * delta)
	
	# checks if your left clicking
	if Input.is_action_pressed("fire_gun"):
		if not on_cooldown:
			fire_gun(get_local_mouse_position())
			
	if Input.is_action_just_pressed("ability") and evade_flag == evadeState.READY:
		# change sprite
		evade_flag = evadeState.ACTIVE
		char_sprite.texture = DODGE_SPRITE;
		evade_timer.start(0.2);
	
	# physics procees for moving a character2D, returns bool if collision
	move_and_slide()

			
func fire_gun(target):
	on_cooldown = true
	# starts timer
	cooldown.start(FIRE_COOLDOWN)
	# method for spawning a new bullet
	var spawn = projectile.instantiate()
	var direction = target.normalized()
	spawn.velocity = direction * spawn.speed
	spawn.position = position + Vector2(8,8) * direction + Vector2(0,-8)
	# adds it to the main node otherwise it would move when we move
	get_parent().add_child(spawn)

# is called when timer hits zero
func _on_cooldown_timeout() -> void:
	on_cooldown = false

func _on_evade_active_timeout() -> void:
	if evade_flag == evadeState.ACTIVE:
		# set to cooldown state
		evade_flag = evadeState.COOLDOWN
		char_sprite.texture = BASE_SPRITE
		evade_timer.start(0.5)
	elif evade_flag == evadeState.COOLDOWN:
		evade_flag = evadeState.READY
