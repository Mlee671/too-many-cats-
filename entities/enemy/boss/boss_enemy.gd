extends Enemy
class_name BossEnemy

const PROJECTILE := preload("res://entities/enemy/boss/bouncing_proj.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = 100
	accel = 20
	health.set_health(100)
	super()

func _process(delta: float) -> void:
	print(vision_circle.shape.radius)

func attack_logic() -> void:
	if attack_cooldown:
		return
	if randi() % 2:
		print("going")
		for angle in [-10, -5, 5, 10]:
			var proj := PROJECTILE.instantiate()
			get_parent().add_child(proj)
			proj.global_position = global_position
			proj.set_velocity(100 * (raycast_target.global_position - proj.global_position).normalized().rotated(deg_to_rad(angle)))
			
			attack_cooldown = true
			attack_timer.start(1.0 / 3)
	else:
		pass
