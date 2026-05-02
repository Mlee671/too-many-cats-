extends Enemy
class_name BossEnemy

const PROJECTILE := preload("res://entities/enemy/boss/bouncing_proj.tscn") 

var attacking_melee := true;

@onready var attack_zone := $AttackZone
@onready var attack_shape := $AttackZone/AttackRadius

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = 100
	accel = 20
	health.set_health(100)
	super()
	attack_zone.monitoring = true

func deal_damage():
	return 40

func attack_logic() -> void:
	if attack_cooldown:
		return
	if randi() % 2:
		for angle in [-10, -5, 5, 10]:
			var proj := PROJECTILE.instantiate()
			get_parent().add_child(proj)
			proj.global_position = global_position
			proj.set_velocity(100 * (raycast_target.global_position - proj.global_position).normalized().rotated(deg_to_rad(angle)))
			
			attack_cooldown = true
			attack_timer.start(1.0 / 3)
	else:
		var scale_tween = create_tween()
		scale_tween.tween_property(attack_shape, "scale", Vector2.ONE, 0.3)
		scale_tween.tween_callback(func(): attack_shape.scale = Vector2.ZERO)
		pass
		#small size
		#quick grow
		#timer wait
		#shrink radius again
		#attack_zone.monitoring = false
