extends Node
class_name Starting_room

const NORTH_DOOR_CLOSED := [Vector2i(6,3),Vector2i(7,3)]
const NS_DOOR_OPEN := [Vector2i(7,5),Vector2i(8,5)]

@onready var door_north := $North_door

@onready var objects := $Tilemaps/Environment

func _on_north_door_body_entered(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(-1,-10), Vector2i(0,-10)]
		for i in 2:
			objects.set_cell(doorway[i],0,NS_DOOR_OPEN[i],0)

func _on_north_door_body_exited(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(-1,-10), Vector2i(0,-10)]
		for i in 2:
			objects.set_cell(doorway[i],0,NORTH_DOOR_CLOSED[i],0)
