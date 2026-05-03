extends CharacterBody2D
class_name main_character


# loads the bullet scene when starting the game
const PROJECTILE := preload("res://entities/player/attacks/player_projectile.tscn")

@onready var attack_timer := $AttackTimer
@onready var evade_cooldown := $EvadeCooldown
@onready var evade_duration := $EvadeDuration 
@onready var ability_cooldown_timer := $AbilityTimer
@onready var ability_duration_timer := $AbilityDuration
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
const DAMAGE_KNOCKBACK := 200 # default catch
const IFRAME_DUR := 0.3
const ATTACK_OFFSET := 10

var knockback_vec := Vector2.ZERO
var movement_vec := Vector2.ZERO
var attack_cooldown := false
# var evade_flag = evadeState.READY
var ability_cooldown := false
var is_alive := true
var dodge_direction := Vector2.ZERO
var locked := false




func _ready() -> void:
	
	state.switch_to(state.STATES.IDLE)
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
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("debug_tp"):
		global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("ability") and not ability_cooldown:
		character_ability()
		signal_bus.ability_used_signal.emit()
		
	if state.player_state != state.STATES.SWITCHING:
		if locked:
			knockback_vec = Vector2.ZERO
			return
		if evade_duration.time_left > 0:
			dodge_movement(delta)
		else:
			manage_movement(delta, direction)
			
		move_and_slide()
	handle_state()

func lock():
	locked = true
	
func unlock():
	locked = false


# when attack cooldown finishes
func _on_attack_timeout() -> void:
	attack_cooldown = false


func _on_iframe_timeout() -> void:
	iframe_flag = false
	char_visual.modulate = Color(1,1,1)
	

func manage_movement(delta: float, direction: Vector2) -> void:
	# gets directional vector based on keypress

	movement_vec = lerp(movement_vec, direction * stats.speed, stats.accel * delta)	
	if Input.is_action_just_pressed("evade"):
		if(evade_cooldown.time_left == 0):
			dodge_direction = direction.normalized()
			if(direction.normalized() != Vector2.ZERO) or velocity.length()> 0.5:
				velocity = dodge_direction * stats.dodge_speed
				start_dodge_roll()
				return

	# if user presses attack key
	if Input.is_action_pressed("attack") and not attack_cooldown:
		attack(get_local_mouse_position())
			
	# apply knockback additively to movement
	knockback_vec = knockback_vec.lerp(Vector2.ZERO, KNOCKBACK_DECAY * delta)
	velocity = movement_vec + knockback_vec


func start_dodge_roll():
	Sfx_Manager.play_sound_effect_from_dictionary("whoosh_1")
	state.switch_to(state.STATES.DODGING)
	state.disable_switch()
	evade_duration.start(stats.evade_dur)
	evade_cooldown.start(stats.evade_cd)
	iframe_flag = true


func dodge_movement(delta: float):
	velocity = lerp(velocity, Vector2.ZERO, delta)


func swap_character() -> void:
	Sfx_Manager.play_sound_effect_from_dictionary("finger_click")
	state.switch_to(States.STATES.SWITCHING)
	state.disable_switch()


## Creates bullet instance and fires from sprite to target vector.
## player projectiles are on collision layer 8 compared to enemies on 4 
func attack(target: Vector2) -> void:
	Sfx_Manager.play_sound_effect_from_dictionary("pop_1")
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	
	# Instantiates projectile
	var spawn = PROJECTILE.instantiate()
	spawn.proj_frame = stats.projectile_frame
	var direction = target.normalized()
	spawn.look_at(direction)
	spawn.set_velocity(direction * stats.projectile_speed)
	spawn.set_knockback(stats.projectile_knockback)
	spawn.set_damage(stats.damage)
	
	# spawn at sprite position in main scene, shifted
	# for where the sprite hands would be (presumably) 
	spawn.global_position = $AttackMarker.global_position + (ATTACK_OFFSET * direction)
	get_parent().add_child(spawn)


func character_ability():
	Sfx_Manager.play_sound_effect_from_dictionary("fire_lighting")
	ability_cooldown = true
	ability_cooldown_timer.start(stats.ability_cd)
	ability_duration_timer.start(stats.ability_dur)
	state.switch_to(States.STATES.USING_ABILITY)
	state.disable_switch()

func add_knockback(vec: Vector2) -> void:
	knockback_vec += vec

func take_damage(amount: int):
	# if you are hit you still get knocked back but do not take damage if in iframe
	if !iframe_flag:
		char_visual.modulate = Color(2,2,2)
		iframe_timer.start(IFRAME_DUR)
		iframe_flag = true
		character_hud.set_main_hp_bar(stats.max_hp, stats.hp - amount)
		stats.hp -= amount
		
		print(stats.hp)
		if stats.hp <=0:
			is_alive = false
			character_hud.kill_first_char()

## Sets run animation when in motion, otherwise idle animation.
func handle_state():
	if velocity.length() > 0.5:
		state.switch_to(state.STATES.RUNNING)
	else:
		state.switch_to(state.STATES.IDLE)

# function for detecting attacks and extracting the damage done to main character
func _on_hitbox_area_entered(area: Area2D, knockback_amount = 200) -> void:
	if !iframe_flag:
		var direction
		if area is Projectile:
			direction = area.velocity.normalized() * knockback_amount
		elif area is BossMelee: # scuffed but too late to rework damage system
			direction = (global_position - area.global_position).normalized() * 1200
		else:
			direction = (global_position - area.global_position).normalized() * knockback_amount
		take_damage(area.deal_damage())
		add_knockback(direction)

func _on_evade_duration_timeout() -> void:
	iframe_flag = false
	state.enable_switch()



func _on_evade_cooldown_timeout() -> void:
	pass # Replace with function body.

# logic for spikes and pits
func _on_hazard_box_body_entered(body: Node2D) -> void:
	if !iframe_flag:
		if body is TileMapLayer:
			take_damage(10)
			add_knockback(-velocity.normalized() * DAMAGE_KNOCKBACK * 2)
			
func heal_to_full() -> void:
	stats.hp = stats.max_hp
	

func _on_ability_timer_timeout() -> void:
	ability_cooldown = false
	

func _on_ability_duration_timeout() -> void:
	state.enable_switch()
	#state.switch_to(state.STATES.IDLE)
