extends Enemy
class_name BossEnemy

const PROJECTILE := preload("res://entities/enemy/boss/bouncing_proj.tscn") 

var attacking_melee := true;

var shots_remaining := 3
var first_attack_flag := true

@onready var attack_zone := $AttackZone
@onready var ranged_timer := $RangedTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = 0
	accel = 20
	health.set_health(100)
	super()
	attack_zone.monitoring = true

func attack_logic() -> void:
	# first time
	if first_attack_flag:
		first_attack_flag = false
		ranged_timer.start(1)
	if attack_cooldown:
		return
	if randi() % 2:
		return
		for angle in [-5, 5]:
			var proj := PROJECTILE.instantiate()
			get_parent().add_child(proj)
			proj.global_position = global_position
			proj.set_velocity(100 * (raycast_target.global_position - proj.global_position).normalized().rotated(deg_to_rad(angle)))
			
			attack_cooldown = true
			attack_timer.start(1.0 / 3)
	else:
		stop_moving = true
		animation.play_animation("attack")
		await animation.animation_finished
		animation.play_animation("RESET")
		attack_cooldown = true
		attack_timer.start(5)


func _on_ranged_timer_timeout() -> void:
	if shots_remaining:
		shots_remaining -= 1
		ranged_timer.start(0.3)
		
		var proj := PROJECTILE.instantiate()
		get_parent().add_child(proj)
		proj.global_position = global_position
		proj.set_velocity(100 * (raycast_target.global_position - proj.global_position).normalized())
		return
	shots_remaining = 3
	ranged_timer.start(3)
	
