extends StaticBody2D
class_name fountain
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var explosion := $Explosion

var used := false

func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body is main_character and !used:
		rich_text_label.visible = true
		

func _on_interaction_zone_body_exited(body: Node2D) -> void:
	pass
	#if body is main_character:
		#rich_text_label.visible = false

func _physics_process(_delta: float) -> void:
	if rich_text_label.visible and !used:
		if Input.is_action_just_pressed("interact"):
			
			explosion.visible = true
			explosion.play()
			SFX_Manager.play_sound_effect_from_dictionary("music_box_mystery")

			used = true
			Input.action_press("debug_open_reward_screen")
			Input.action_release("debug_open_reward_screen")

			rich_text_label.text = "\nPress 'E\nto change character\n"

			
func _on_explosion_animation_finished() -> void:
	explosion.visible = false
