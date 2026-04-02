extends Entity
class_name main_character

const COOLDOWN := .5

# loads the bullet scene when starting the game
@onready var projectile := preload("res://entity/Projectiles/Bullet.tscn")

# gets a reference to the cooldown timer
@onready var cooldown := $cooldown

var on_cooldown := false

func get_move_direction() -> Vector2:
	return Input.get_vector("Left", "Right", "Up", "Down")

func _ready() -> void:
	speed = 100
	acceleration = 20
	
func _process(_delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	# checks if your left clicking
	if Input.is_action_pressed("fire_gun"):
		if not on_cooldown:
			fire_gun(get_local_mouse_position())
	
	# movement, as per Entity superclass
	super.move(delta)

			
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
