extends StaticBody2D
class_name fountain

@onready var label := $Label
@onready var explosion := $Explosion

func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body is main_character:
		label.visible = true
		

func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body is main_character:
		label.visible = false

func _physics_process(_delta: float) -> void:
	if label.visible:
		if Input.is_action_just_pressed("interact"):
			label.visible = false
			explosion.visible = true
			explosion.play()

func _on_explosion_animation_finished() -> void:
	explosion.visible = false
