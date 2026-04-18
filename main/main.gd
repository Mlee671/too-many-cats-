extends Node2D

@onready var cm:=$character_manager
@onready var room_manager := $Room_manager


func _ready() -> void:
	
	$fade_transition/AnimationPlayer.play("fade_out")

	# cm.switch_to("blue_knight")
	room_manager.generate_rooms(5)
	cm.spawn_character(Vector2(32,32))
