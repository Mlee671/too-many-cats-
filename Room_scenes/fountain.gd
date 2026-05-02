extends StaticBody2D
class_name fountain
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var explosion := $Explosion

func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body is main_character:
		rich_text_label.visible = true
		

func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body is main_character:
		rich_text_label.visible = false

func _physics_process(_delta: float) -> void:
	if rich_text_label.visible:
		if Input.is_action_just_pressed("interact"):
			rich_text_label.visible = false
			explosion.visible = true
			explosion.play()
			

			
			
func _on_explosion_animation_finished() -> void:
	
	explosion.visible = false
	Input.action_press("debug_open_reward_screen")
	Input.action_release("debug_open_reward_screen")
