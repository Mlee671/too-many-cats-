extends Entity
class_name Player

const COOLDOWN := 0.5

# loads the bullet scene, cooldown and flag
@onready var projectile := preload("res://entities/Projectiles/Bullet.tscn")
@onready var attack_cooldown := $cooldown
var on_cooldown := false


func _ready() -> void:
	speed = 100
	acceleration = 20

func get_move_direction() -> Vector2:
	return Input.get_vector("Left", "Right", "Up", "Down")

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("fire_gun"):
		if not on_cooldown:
			fire_gun(get_local_mouse_position())

	# movement, as per Entity superclass
	super.move(delta)

func fire_gun(target):
	on_cooldown = true
	# starts timer
	attack_cooldown.start(COOLDOWN)
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
