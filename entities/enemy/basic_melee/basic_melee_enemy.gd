extends Enemy
class_name BasicMeleeEnemy

const ATTACK_DURATION := 0.5
const DAMAGE := 15
const SPEED := 50.0
const ACCELERATION := 20.0
const HP := 100
const KNOCKBACK := 300
const ATTACKS_PER_SECOND := 1.5

@onready var attack_visual := $AttackComponent
@onready var detect_radius := $AttackComponent/AttackDetect
@onready var attack_sprite := $AttackComponent/AttackSprite
@onready var attack_duration_timer := $AttackRenderTimer
@onready var attack_box := $AttackComponent/Attackbox

var attack_mode = false
var frame : int = 0

func _ready() -> void:
	move_speed = SPEED
	accel = ACCELERATION
	health.set_health(HP)
	attack_sprite.visible = false
	super()


func _physics_process(delta: float) -> void:
	if raycast_target and not attack_cooldown:
		attack_visual.look_at(raycast_target.global_position)
	# once maincharacter enters attack range checks each frame if they are still in range
	if attack_mode and !attack_cooldown:
		var bodies = detect_radius.get_overlapping_bodies()
		for body in bodies:
			if body is main_character:
				melee_attack()
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
	attack_box.toggle_disable(true)

# currently causes bouncing due to shape of attack being square and stickinging out of the attack radius. 
# once sprites are in and the attack more circular this will fix itself mostly 
func melee_attack():
		attack_sprite.visible = true
		attack_box.toggle_disable(false)
		animation.play_animation("attack", true)
		attack_cooldown = true
		stop_moving = true
		nav_agent.set_velocity(Vector2.ZERO)
		attack_timer.start(1.0 / ATTACKS_PER_SECOND)
		attack_duration_timer.start(ATTACK_DURATION)
