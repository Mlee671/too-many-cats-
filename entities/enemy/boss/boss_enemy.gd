extends Enemy
class_name BossEnemy

const PROJECTILE := preload("res://entities/enemy/boss/bouncing_proj.tscn") 
const TELEPORT := preload("res://entities/enemy/boss/teleport_marker.tscn")

const SPEED := 110
const ACCELERATION := 20
const HP := 1000
const WEIGHT := 3
const ORBIT_DIST_INNER := 50 # min dist to maintain after melee attack
const ORBIT_DIST_OUTER := 70 # max dist to maintain after melee attack
const VISION := 100
const TELEPORT_TRAP_COOLDOWN := 10 # trap deploy cooldown
const MELEE_ATTACK_RANGE := 40 # max distance between target before spin-attack
const PROJECTILE_SPEED := 100
const PROJECTILE_INTRA_COOLDOWN := 0.2 # time between each projectile in one burst
const PROJECTILE_INTER_COOLDOWN := 3.0 # time between projectile bursts
const MELEE_COOLDOWN := 5.0

var orbit_dir := 1
var frame := 0
var teleport_cooldown := false
var active_traps := []
var shots_remaining := 3
var first_attack_flag := true

@onready var attack_zone := $AttackZone
@onready var ranged_timer := $RangedTimer
@onready var teleport_timer := $TeleportTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_speed = SPEED
	accel = ACCELERATION
	health.set_health(HP)
	mass_coef = WEIGHT
	vision_range = VISION
	super()
	attack_zone.monitoring = true


func set_trap():
	var tp := TELEPORT.instantiate()
	active_traps.append(tp)
	get_parent().add_child(tp)
	move_to_front()
	tp.global_position = global_position
	tp.player_found.connect(_on_teleport_trap_activation)
	teleport_cooldown = true
	teleport_timer.start(TELEPORT_TRAP_COOLDOWN)


func attack_logic() -> void:
	# first time, start ranged attack timer
	frame += 1
	if first_attack_flag:
		first_attack_flag = false
		ranged_timer.start(1)
		
	if not teleport_cooldown:
		stop_moving = true
		animation.no_interrupt = false
		animation.play_animation("deploy_trap", true)
		await animation.animation_finished
		animation.no_interrupt = false
		stop_moving = false
		
			
	if attack_cooldown:
		if frame % 10 == 0:
			var player_boss_vec := raycast_target.global_position - global_position
			var player_boss_dist := player_boss_vec.length()
			var player_boss_dir := player_boss_vec.normalized()
			# gaining distance, moves at tangent
			var target_shift := player_boss_dir.rotated(PI/2 * orbit_dir) * 20
			
			# move ahead or away from player depending on dist
			if player_boss_dist >= ORBIT_DIST_INNER:
				target_shift += player_boss_dir * 30
			elif player_boss_dist < ORBIT_DIST_OUTER:
				target_shift += -player_boss_dir * 30
				
			nav_agent.target_position = global_position + target_shift
		
	else:
		if frame % 10 == 0:
			nav_agent.target_position = raycast_target.global_position
		if (raycast_target.global_position - global_position).length() < MELEE_ATTACK_RANGE: # in range
			stop_moving = true
			animation.no_interrupt = false
			animation.play_animation("attack", true)
			await animation.animation_finished
			animation.no_interrupt = false # brute force lock
			stop_moving = false
			# disables all hitboxes and attack sprite states, quite scuffed, yes
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
			attack_timer.start(MELEE_COOLDOWN)


func _on_ranged_timer_timeout() -> void:
	if shots_remaining:
		shots_remaining -= 1
		ranged_timer.start(PROJECTILE_INTRA_COOLDOWN * (float(health.current_health) / float(health.max_health)))
		
		var proj := PROJECTILE.instantiate()
		get_parent().add_child(proj)
		proj.global_position = global_position
		proj.set_velocity(PROJECTILE_SPEED * (raycast_target.global_position - proj.global_position).normalized())
		return
	shots_remaining = 3
	ranged_timer.start(PROJECTILE_INTER_COOLDOWN * (float(health.current_health) / float(health.max_health)))
	
func _on_teleport_trap_activation(caller: TeleportMarker, coords: Vector2):
	global_position = coords
	nav_agent.set_velocity(Vector2.ZERO)
	velocity = Vector2.ZERO
	frame = -1 # auto re-register pathing next frame
	# allows immediate attack next frame
	attack_cooldown = false
	attack_timer.stop()
	# removes trap from traplist
	active_traps.erase(caller)
	
func _on_death() -> void:
	for trap in active_traps:
		trap.queue_free()
	super()


func _on_teleport_timer_timeout() -> void:
	teleport_cooldown = false
