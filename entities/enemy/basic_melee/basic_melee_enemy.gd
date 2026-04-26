extends Enemy
class_name BasicMeleeEnemy

const ATTACK_DURATION := 0.5
const DAMAGE := 15

@export var speed := 50.0
@export var acceleration := 20.0
@export var wander_range := 6
@export var hp := 100
@export var attack_rate : float = 1.5

## The distance the melee attack spawns from the enemy position
@export var attack_offset_magnitude := 20.0

@onready var attack_visual := $AttackComponent
@onready var detect_radius := $AttackComponent/AttackDetect
@onready var attack_box := $AttackComponent/Attackbox
@onready var attack_sprite := $AttackComponent/AttackSprite
@onready var attack_duration_timer := $AttackRenderTimer

var attack_mode = false
var frame : int = 0

func _ready() -> void:
	move_speed = speed
	accel = acceleration
	pathfind_range = wander_range
	health.set_health(hp)
	
	attack_sprite.visible = false
	super._ready()


func _physics_process(delta: float) -> void:
	if raycast_target and not attack_cooldown:
		attack_visual.look_at(raycast_target.global_position)
	# once maincharacter enters attack range checks each frame if they are still in range
	if attack_mode and !attack_cooldown:
		var bodies = detect_radius.get_overlapping_bodies()
		for body in bodies:
			if body is main_character:
				melee_attack()
				body.take_damage(DAMAGE, self, 300)
	super._physics_process(delta)


func attack_logic() -> void:
	# move to player directly, no need to trigger every frame
	if (frame % 10 == 0):
		nav_agent.target_position = raycast_target.global_position
	frame += 1

func _on_attack_radius_triggered(body: Node2D) -> void:
	if body is main_character:
		attack_mode = true
	
func _on_attack_radius_exited(body: Node2D) -> void:
	if body is main_character:
		attack_mode = false

# disables attack visuals, rotate hitbox so that body_entered can retrigger
func _on_attack_render_timeout() -> void:
	attack_sprite.visible = false
	attack_visual.rotate(PI)

# currently causes bouncing due to shape of attack being square and stickinging out of the attack radius. 
# once sprites are in and the attack more circular this will fix itself mostly 
func melee_attack():
		attack_sprite.visible = true
		animation.play_animation("attack", true)
		attack_cooldown = true
		stop_moving = true
		nav_agent.set_velocity(Vector2.ZERO)
		attack_timer.start(1.0 / attack_rate)
		attack_duration_timer.start(ATTACK_DURATION)
