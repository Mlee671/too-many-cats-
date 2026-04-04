extends Entity
class_name Player

const ATTACK_COOLDOWN := 0.5

const EVADE_MOVEMENT_SCALING := 2.5
# units in seconds
const EVADE_DURATION := 0.2
const EVADE_COOLDOWN := 0.5

const BASE_SPEED := 100.0
const BASE_ACCEL := 20.0

# loads the bullet scene, cooldown and flag
@onready var projectile := preload("res://entities/Projectiles/Bullet.tscn")
@onready var attack_cooldown := $atk_timer
var on_cooldown := false

@onready var evade_timer := $evade_timer
enum evadeState {READY, ACTIVE, COOLDOWN}
var evade_flag := evadeState.READY

@onready var texture := $flippable

func _ready() -> void:
	speed = BASE_SPEED
	acceleration = BASE_ACCEL

func get_move_direction() -> Vector2:
	return Input.get_vector("Left", "Right", "Up", "Down")

func _process(_delta: float) -> void:
	# flip character based on mouse position
	if get_local_mouse_position().x < 0:
		texture.scale.x = -1
	else:
		texture.scale.x = 1

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("fire_gun") and not on_cooldown:
		fire_gun(get_local_mouse_position())
	
	if Input.is_action_just_pressed("ability") and evade_flag == evadeState.READY:
		evade_timer.start(EVADE_DURATION)
		evade_flag = evadeState.ACTIVE
		speed = BASE_SPEED * EVADE_MOVEMENT_SCALING
		animation_lock = true
		animation.play("evade")

	# movement, as per Entity superclass
	super.move(delta)

func fire_gun(target):
	on_cooldown = true
	# starts timer
	attack_cooldown.start(ATTACK_COOLDOWN)
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


func _on_evade_timeout() -> void:
	if evade_flag == evadeState.ACTIVE:
		evade_flag = evadeState.COOLDOWN
		evade_timer.start(EVADE_COOLDOWN)
		speed = BASE_SPEED
		animation_lock = false
	elif evade_flag == evadeState.COOLDOWN:
		evade_flag = evadeState.READY
