extends Node2D

const WEST_DOOR := [Vector2i(7,4),Vector2i(7,5)]
const EAST_DOOR := [Vector2i(8,4),Vector2i(8,5)]
const NORTH_DOOR_CLOSED := [Vector2i(6,3),Vector2i(7,3)]
const SOUTH_DOOR_CLOSED := [Vector2i(6,6),Vector2i(7,6)]
const NS_DOOR_OPEN := [Vector2i(7,5),Vector2i(8,5)]

var enemy_list : Array = []
var locked := false

@onready var door_west := $West_door
@onready var door_east := $East_door
@onready var door_north := $North_door
@onready var door_south := $South_door
@onready var objects := $NavRegion/Environment

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_lock_doors"):
		locked = !locked
		_query_doors()

# if locked, doors can't open
func _query_doors():
	door_west.monitoring = !locked
	door_north.monitoring = !locked
	door_east.monitoring = !locked
	door_south.monitoring = !locked

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

# only mask on player layer
func _on_room_activator_body_entered(body: Node2D) -> void:
	locked = true
	SignalBus.room_lock.emit(locked)
	
	_query_doors()
	_on_north_door_body_exited(body)
	_on_south_door_body_exited(body)
	_on_east_door_body_exited(body)
	_on_west_door_body_exited(body)
	
	
	if body is Enemy:
		enemy_list.append(body)
	elif body is main_character:
		for enemy in enemy_list:
			# print("enemies activated")
			# activation method here
			pass

func _on_room_activator_body_exited(body: Node2D) -> void:
	locked = false
	_query_doors()
	
	if body is main_character:
		for i in range(enemy_list.size() - 1, -1, -1):
			if enemy_list[i]:
				# print("enemies deactivated")
				# deactivate here. though once we have combat the doors will be locked
				pass
			else:
				enemy_list.remove_at(i)
				# print("removed dead enemy")
