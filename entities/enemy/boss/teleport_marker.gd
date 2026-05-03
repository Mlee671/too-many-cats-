extends Area2D
class_name TeleportMarker

signal player_found(caller, coords)

func _ready() -> void:
	$Sprite.animation = "idle"

func _on_body_entered(body: Node2D) -> void:
	if body is main_character:
		$Sprite.play("trigger")
		


func _on_sprite_animation_finished() -> void:
	player_found.emit(self, global_position)
	queue_free()
