extends Node2D

@onready var cm:=$character_manager
@onready var room_manager := $Room_manager
@export var character_hud: CanvasLayer



func _ready() -> void:
	#finishes the fading transition
	$fade_transition.show()
	$fade_transition/fade_transition_timer.start()
	$fade_transition/AnimationPlayer.play("fade_out")
	
	# cm.switch_to("blue_knight")
	room_manager.generate_rooms(5)
	cm.spawn_character(Vector2(32,32))


func _on_fade_transition_timer_timeout() -> void:
	character_hud.visible = true
