extends Node2D

@onready var cm:=$character_manager
@onready var room_manager := $Room_manager
@export var character_hud: CanvasLayer



func _ready() -> void:
	#finishes the fading transition
	$fade_transition.show()
	
	$fade_transition/AnimationPlayer.play("fade_out")

	
	# cm.switch_to("blue_knight")
	var start = room_manager.generate_rooms(5)
	cm.spawn_character(start)
	await get_tree().create_timer(1.5).timeout
	character_hud.visible = true
