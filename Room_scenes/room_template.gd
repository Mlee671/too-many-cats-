extends Node2D

const WEST_DOOR := [Vector2i(7,4),Vector2i(7,5)]
const EAST_DOOR := [Vector2i(8,4),Vector2i(8,5)]
const NORTH_DOOR_CLOSED := [Vector2i(6,3),Vector2i(7,3)]
const SOUTH_DOOR_CLOSED := [Vector2i(6,6),Vector2i(7,6)]
const NS_DOOR_OPEN := [Vector2i(7,5),Vector2i(8,5)]


@onready var objects := $NavRegion/Environment

func _on_west_door_body_entered(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(-10,-1), Vector2i(-10,0)]
		for i in 2:
			objects.set_cell(doorway[i],0,WEST_DOOR[i],1)

func _on_west_door_body_exited(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(-10,-1), Vector2i(-10,0)]
		for i in 2:
			objects.set_cell(doorway[i],0,WEST_DOOR[i],0)


func _on_east_door_body_entered(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(9,-1), Vector2i(9,0)]
		for i in 2:
			objects.set_cell(doorway[i],0,EAST_DOOR[i],1)


func _on_east_door_body_exited(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(9,-1), Vector2i(9,0)]
		for i in 2:
			objects.set_cell(doorway[i],0,EAST_DOOR[i],0)


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


func _on_south_door_body_entered(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(-1,9), Vector2i(0,9)]
		for i in 2:
			objects.set_cell(doorway[i],0,NS_DOOR_OPEN[i],0)


func _on_south_door_body_exited(body: Node2D) -> void:
	if body is main_character:
		var doorway := [Vector2i(-1,9), Vector2i(0,9)]
		for i in 2:
			objects.set_cell(doorway[i],0,SOUTH_DOOR_CLOSED[i],0)
