extends Enemy
class_name BossEnemy

const PROJECTILE := preload("res://entities/enemy/boss/bouncing_proj.tscn") 

var attacking_melee := true;

var shots_remaining := 3
var first_attack_flag := true

const ORBIT_DIST_INNER := 50
const ORBIT_DIST_OUTER := 70
var orbit_dir := 1

var frame := 0

@onready var attack_zone := $AttackZone
@onready var ranged_timer := $RangedTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = 80
	accel = 20
	health.set_health(100)
	super()
	attack_zone.monitoring = true

func attack_logic() -> void:
	# first time, start ranged attack timer
	frame += 1
	if first_attack_flag:
		first_attack_flag = false
		ranged_timer.start(1)
	if attack_cooldown:
		if frame % 10 == 0:
			print("repos")
			var player_boss_vec := raycast_target.global_position - global_position
			var player_boss_dist := player_boss_vec.length()
			var player_boss_dir := player_boss_vec.normalized()
			# gaining distance, moves at tangent
			var target_shift := player_boss_dir.rotated(PI/2 * orbit_dir) * 20
			# backtrack further if not in range, additive vector
			if player_boss_dist >= ORBIT_DIST_INNER:
				target_shift += player_boss_dir * 30
			elif player_boss_dist < ORBIT_DIST_OUTER:
				target_shift += -player_boss_dir * 30
				
			nav_agent.target_position = global_position + target_shift
		
	else:
		if frame % 10 == 0:
			print("chasing")
			nav_agent.target_position = raycast_target.global_position
		if (raycast_target.global_position - global_position).length() < 40: # in range
			stop_moving = true
			animation.no_interrupt = false
			animation.play_animation("attack", true)
			await animation.animation_finished
			animation.no_interrupt = false # brute force lock
			stop_moving = false
			# quite scuffed, yes
			$AttackZone/box1.disabled = true
			$AttackZone/box2.disabled = true
			$AttackZone/box3.disabled = true
			$AttackZone/box4.disabled = true
			$AttackZone/box5.disabled = true
			$AttackZone/AttackSprite.frame = 0
			$AttackZone/AttackSprite.visible = false
			
			# determines orbit direction, random cw or acw
			orbit_dir = (-1) ** randi_range(0,1)
			
			attack_cooldown = true
			attack_timer.start(5)
		
	


func _on_ranged_timer_timeout() -> void:
	if shots_remaining:
		shots_remaining -= 1
		print(float(health.current_health / health.max_health), health.current_health, health.max_health)
		ranged_timer.start(0.2 * (float(health.current_health) / float(health.max_health)))
		
		var proj := PROJECTILE.instantiate()
		get_parent().add_child(proj)
		proj.global_position = global_position
		proj.set_velocity(100 * (raycast_target.global_position - proj.global_position).normalized())
		return
	shots_remaining = 3
	ranged_timer.start(3.0 * (float(health.current_health) / float(health.max_health)))
	
