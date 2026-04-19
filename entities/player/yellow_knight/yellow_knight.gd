extends main_character
class_name YellowKnight

@onready var attack_box := $AttackBox
@onready var animplayer := $AttackBox/PlaceholderPlayer
@onready var ability_shape := $AbilityArea/AbilityShape

func _ready() -> void:
	attack_box.monitoring = false

func attack(target: Vector2) -> void:
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	# horizontal mirror depending on cursor location
	if target.x < 0:
		attack_box.scale.x = -1
	else:
		attack_box.scale.x = 1
	animplayer.play("attackbox")
	
func character_ability() -> void:
	# scale up ability area size to trigger area_entered
	var scale_tween = create_tween()
	scale_tween.tween_property(ability_shape, "scale", Vector2.ONE, 0.3)
	scale_tween.tween_callback(func(): ability_shape.scale = Vector2.ZERO)


# Delete projectiles caught in range
func _on_ability_area_projectile_entered(area: Area2D) -> void:
	if area is Projectile:
		area.queue_free()

# knock back enemies caught in range
func _on_ability_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.apply_knockback((body.global_position - global_position).normalized(), 300)
