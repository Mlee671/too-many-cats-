extends CharacterBody2D
class_name main_character

var SPEED := 25
const ACCEL_SMOOTH := 20
const COOLDOWN := .5

# loads the bullet scene when starting the game
@onready var projectile := preload("res://entity/Projectiles/Bullet.tscn")

# gets a reference to the cooldown timer
@onready var cooldown := $cooldown

@onready var animated_sprite :=$Sprite2D

var on_cooldown := false

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	if Input.is_key_pressed(KEY_1):
		SPEED += 100 * delta
	elif Input.is_key_pressed(KEY_2):
		SPEED -= 100 * delta
	
	# scans if wasd is pressed then returns a Vector2. x direction is left/right. y is up/down 
	var input_vector = Input.get_vector("Left", "Right", "Up", "Down")
	# sets the velocity. lerp is an accelleration function(starting speed, target speed, accel factor)
	velocity = lerp(velocity, input_vector * SPEED, ACCEL_SMOOTH * delta)
	
	animated_sprite.speed_scale = velocity.length() / 25
	
	if input_vector.length() != 0:
		animated_sprite.play()
	
	if input_vector.x < 0:
		animated_sprite.flip_h = false
	elif input_vector.x> 0:
		animated_sprite.flip_h = true	
	elif input_vector.x ==0 && input_vector.y ==0:
		animated_sprite.stop()
	
	
	# checks if your left clicking
	if Input.is_action_pressed("fire_gun"):
		if not on_cooldown:
			fire_gun(get_local_mouse_position())
	
	# physics procees for moving a character2D
	move_and_slide()

			
func fire_gun(target):
	on_cooldown = true
	# starts timer
	cooldown.start(COOLDOWN)
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
