extends main_character
class_name YellowKnight

@onready var attack_component := $AttackComponent
@onready var attack_box := $AttackComponent/AttackBox
@onready var animplayer := $AttackComponent/AttackBox/PlaceholderPlayer
@onready var ability_shape := $AbilityArea/AbilityShape

const ABILITY_KNOCKBACK := 300

func _ready() -> void:
	attack_box.monitoring = false
	ability_shape.scale = Vector2.ZERO
	attack_box.set_damage(stats.damage)
	super()
	

func attack(_target: Vector2) -> void:
	Sfx_Manager.play_sound_effect_from_dictionary("sword_slice")
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	# vertical mirror depending on cursor location
	if get_global_mouse_position().x < 0:
		attack_box.scale.y = -1
	else:
		attack_box.scale.y = 1
	attack_component.look_at(get_global_mouse_position())
	animplayer.play("attackbox")


func character_ability() -> void:
	super()
	Sfx_Manager.play_sound_effect_from_dictionary("sword_sharpen") # change noise
	# scale up ability area size to trigger area_entered
	

func repulse():
	var scale_tween = create_tween()
	scale_tween.tween_property(ability_shape, "scale", Vector2.ONE, 0.2)
	scale_tween.tween_callback(func(): ability_shape.scale = Vector2.ZERO)

# Delete projectiles caught in range
func _on_ability_area_projectile_entered(area: Area2D) -> void:
	if area is Projectile:
		area.queue_free()

# knock back enemies caught in range
func _on_ability_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.apply_knockback((body.global_position - global_position).normalized(), ABILITY_KNOCKBACK)
