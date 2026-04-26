extends CharacterBody2D
class_name main_character


# loads the bullet scene when starting the game
@onready var projectile := preload("res://entities/player/attacks/player_projectile.tscn")

@onready var attack_timer := $AttackTimer
@onready var evade_timer := $EvadeTimer
@onready var ability_timer := $AbilityTimer
@onready var iframe_timer := $IFrameTimer
#@onready var animation_player := $CharacterVisuals/AnimatedSprite2D
@onready var char_visual := $CharacterVisuals
@onready var stats := $Stats
@onready var state:= $States
@onready var animation_tree := $CharacterVisuals/AnimationTree

@onready var character_hud: CanvasLayer = $"../character_hud"

# enum evadeState {READY, ACTIVE, COOLDOWN, KNOCKBACK}

var iframe_flag := false
const KNOCKBACK_DUR := 0.1
const KNOCKBACK_DECAY := 10.0
const DAMAGE_KNOCKBACK := 200.0 # kb scalar
const IFRAME_DUR := 0.3

var projectile_speed := 200

var knockback_vec := Vector2.ZERO
var movement_vec := Vector2.ZERO
var attack_cooldown := false
# var evade_flag = evadeState.READY
var ability_cooldown := false
var is_alive := true

func _input(event):
	
	if (Input.is_action_just_pressed("ability")
			and not ability_cooldown):
		character_ability()
		# start cooldown
		ability_cooldown = true
		ability_timer.start(stats.ability_cd)

	
func _ready() -> void:
	print("Project path: ", ProjectSettings.globalize_path("res://"))
	state.player_state = state.STATES.IDLE
	add_to_group("Player")
	animation_tree.active = true
	
	
func _process(_delta: float) -> void:
	# flip character based on mouse position
	if state.player_state != state.STATES.DODGING:
		if get_local_mouse_position().x < 0:
			char_visual.scale.x = -1
		else:
			char_visual.scale.x = 1
	
func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("evade")):
		pass
	manage_movement(delta)
	handle_state()

# when attack cooldown finishes
func _on_attack_timeout() -> void:
	attack_cooldown = false

func _on_ability_timeout() -> void:
	ability_cooldown = false
	
func _on_iframe_timeout() -> void:
	iframe_flag = false
	char_visual.modulate = Color(1,1,1)

func manage_movement(delta: float) -> void:
	# gets directional vector based on keypress
	var input_vector = Input.get_vector("left", "right", "up", "down")

	movement_vec = lerp(movement_vec, input_vector * stats.speed, stats.accel * delta)

	# if user presses attack key
	if Input.is_action_pressed("attack") and not attack_cooldown:
		attack(get_local_mouse_position())
			
	# apply knockback additively to movement
	knockback_vec = knockback_vec.lerp(Vector2.ZERO, KNOCKBACK_DECAY * delta)
	velocity = movement_vec + knockback_vec
	move_and_slide()


func swap_character() -> void:
	# dodge should skip straight to cooldown to prevent abuse
	handle_state() # force change animation away from dodge
	evade_timer.start(stats.evade_cd)

## Creates bullet instance and fires from sprite to target vector.
## player projectiles are on collision layer 8 compared to enemies on 4 
func attack(target: Vector2) -> void:
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	
	# Instantiates projectile
	var spawn = projectile.instantiate()
	spawn.proj_frame = stats.projectile_frame
	var direction = target.normalized()
	spawn.look_at(direction)
	spawn.velocity = direction * projectile_speed
	
	# spawn at sprite position in main scene, shifted
	# for where the sprite hands would be (presumably) 
	spawn.position = position + Vector2(8,8) * direction + Vector2(0,-8)
	get_parent().add_child(spawn)
	stats.shots_fired += 1


func character_ability():
	pass
	# override in child

func add_knockback(vec: Vector2) -> void:
	knockback_vec += vec

func take_damage(amount: int, from: Node2D, knockback_scalar: int=DAMAGE_KNOCKBACK):
	if from is Projectile:
		add_knockback(from.velocity.normalized() * knockback_scalar)
	else:
		add_knockback((global_position - from.global_position).normalized() * knockback_scalar)
	char_visual.modulate = Color(2,2,2)
	iframe_timer.start(IFRAME_DUR)
## Called by enemy attacks when colliding with body. Currently does nothing.
	

## Sets run animation when in motion, otherwise idle animation.
func handle_state():
	if velocity != Vector2.ZERO:
		state.player_state = state.STATES.RUNNING
	else:
		state.player_state = state.STATES.IDLE

# function for detecting attacks and extracting the damage done to main character
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Projectile or area is Attack:
		pass
		#take_damage(area.deal_damage())
