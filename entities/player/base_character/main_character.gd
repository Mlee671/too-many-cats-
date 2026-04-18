extends CharacterBody2D
class_name main_character


# loads the bullet scene when starting the game
# TODO: replace with child node to generate within (e.g. AttackComponent)
@onready var projectile := preload("res://entities/player/attacks/player_projectile.tscn")

@onready var attack_timer := $AttackTimer
@onready var evade_timer := $EvadeTimer
@onready var ability_timer := $AbilityTimer
#@onready var animation_player := $CharacterVisuals/AnimatedSprite2D
@onready var char_visual := $CharacterVisuals
@onready var stats := $Stats
@onready var animation_tree := $CharacterVisuals/AnimationTree

@onready var character_hud: CanvasLayer = $"../character_hud"

enum evadeState {READY, ACTIVE, COOLDOWN, KNOCKBACK}

const KNOCKBACK_DUR := 0.1
const KNOCKBACK_DECAY := 10.0
const DAMAGE_KNOCKBACK := 200.0 # kb scalar

var projectile_speed := 200

var knockback_vec := Vector2.ZERO
var movement_vec := Vector2.ZERO
var attack_cooldown := false
var evade_flag = evadeState.READY
var ability_cooldown := false
var is_alive := true

func _input(event):
	if (Input.is_action_just_pressed("evade") and evade_flag == evadeState.READY):
		evade_flag = evadeState.ACTIVE
		evade_timer.start(stats.evade_dur);
	
	if (Input.is_action_just_pressed("ability")
			and not ability_cooldown):
		character_ability()
		# start cooldown
		ability_cooldown = true
		ability_timer.start(stats.ability_cd)
	
func _ready() -> void:
	stats.player_state = Stats.states.IDLE
	add_to_group("Player")
	animation_tree.active = true
	
	
func _process(_delta: float) -> void:
	# flip character based on mouse position
	if stats.player_state != stats.states.DODGING:
		if get_local_mouse_position().x < 0:
			char_visual.scale.x = -1
		else:
			char_visual.scale.x = 1
	
func _physics_process(delta: float) -> void:
	if stats.player_state != stats.states.DODGING:
		manage_movement(delta)
		pass
	
	# move and animate if not in dodge state
	move_and_slide()
	if evade_flag != evadeState.ACTIVE:
		handle_animation()

# when attack cooldown finishes
func _on_attack_timeout() -> void:
	attack_cooldown = false

# when evade cooldown finishes
func _on_evade_timeout() -> void:
	# after active, evade is cooldown
	if evade_flag == evadeState.ACTIVE:
		evade_flag = evadeState.COOLDOWN
		evade_timer.start(stats.evade_cd)
	# after cooldown or knockback, evade is ready
	else:
		evade_flag = evadeState.READY
		modulate = Color(1,1,1)

func _on_ability_timeout() -> void:
	ability_cooldown = false

func manage_movement(delta: float) -> void:
	# gets directional vector based on keypress
	var input_vector = Input.get_vector("left", "right", "up", "down")
	
	# scales movement speed if dodging
	if evade_flag == evadeState.ACTIVE:
		stats.player_state = Stats.states.DODGING
		position = position.move_toward(input_vector * 10000, 100 *delta)

	else:
		movement_vec = movement_vec.lerp(
				input_vector * stats.speed,
				stats.accel * delta)
	
		# if user presses attack key
		if Input.is_action_pressed("fire_gun") and not attack_cooldown:
			fire_gun(get_local_mouse_position())
			
	# apply knockback additively to movement
	knockback_vec = knockback_vec.lerp(Vector2.ZERO, KNOCKBACK_DECAY * delta)
	velocity = movement_vec + knockback_vec

func swap_character() -> void:
	# dodge should skip straight to cooldown to prevent abuse
	evade_flag = evadeState.READY
	handle_animation() # force change animation away from dodge
	evade_timer.start(stats.evade_cd)

## Creates bullet instance and fires from sprite to target vector.
## player projectiles are on collision layer 8 compared to enemies on 4 
func fire_gun(target: Vector2) -> void:
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

## Called by enemy attacks when colliding with body. Currently does nothing.
func take_damage(amount: int):
	
	#print("[DEBUG] Player taken ", amount, " damage")
	
	character_hud.set_main_hp_bar(stats.hp - amount)
	stats.hp -=amount
	

## Sets run animation when in motion, otherwise idle animation.
func handle_animation():
	if velocity.length_squared() > 0.5:
		stats.player_state = Stats.states.RUNNING
	else:
		stats.player_state = Stats.states.IDLE

# function for detecting attacks and extracting the damage done to main character
func _on_hitbox_area_entered(area: Area2D) -> void:
	if evade_flag == evadeState.ACTIVE:
		return
	if area is Projectile or area is Attack:
		add_knockback((global_position - area.global_position).normalized() * DAMAGE_KNOCKBACK)
		evade_timer.start(KNOCKBACK_DUR)
		modulate = Color(2,2,2)
		take_damage(area.deal_damage())
