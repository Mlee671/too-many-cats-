extends Node2D

@onready var cm:=$character_manager
@onready var room_manager := $Room_manager
@onready var character := $character_slot


func _ready() -> void:
	character.global_position = Vector2(32,32)
	# cm.switch_to("blue_knight")
	room_manager.generate_rooms(5)
