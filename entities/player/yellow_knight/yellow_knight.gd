extends main_character
class_name YellowKnight

@onready var attack_box := $AttackBox
@onready var animplayer := $AttackBox/PlaceholderPlayer

func _ready() -> void:
	attack_box.monitoring = false

func fire_gun(_target: Vector2) -> void:
	attack_cooldown = true
	attack_timer.start(stats.fire_cd)
	animplayer.play("attackbox")
	
func character_ability() -> void:
	var scale_tween = create_tween()
	
	scale_tween.tween_property($AbilityArea/AbilityShape, "scale", Vector2.ONE, 0.3)
	scale_tween.tween_callback(func(): $AbilityArea/AbilityShape.scale = Vector2.ZERO)


func _on_ability_area_projectile_entered(area: Area2D) -> void:
	if area is Projectile:
		area.queue_free()


func _on_ability_area_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.apply_knockback((body.global_position - global_position).normalized(), 300)
