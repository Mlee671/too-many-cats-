extends Node2D

@onready var cm:=$character_manager


func _ready() -> void:
	cm.switch_to("blue_knight")
