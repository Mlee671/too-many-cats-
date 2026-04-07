extends Node2D

const TILE_SIZE = 16
const ROOM_SIZE = 30

@onready var hall_tiles := $Hallway

var room_array : Array = []
var hallway_pos : Array[Vector2i] = []
var room_pos : Array[Vector2i] = []

func _ready() -> void:
	var dir = DirAccess.open("res://Room_scenes/Rooms/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			room_array.append(load("res://Room_scenes/Rooms/" + file_name))
			file_name = dir.get_next()

func generate_rooms(rooms : int) -> Vector2:
	_get_room_positions(rooms)
	_connect_rooms(rooms)
	_spawn_rooms()
	_spawn_corridors()
	# _show_minimap(rooms)
	return room_pos[0]
				
func _get_room_positions(rooms : int):
	room_pos.append(Vector2i(0,0))
	for i in rooms:
		while room_pos:
			var prev_pos = room_pos[-1]
			var new_pos := Vector2i(randi_range(-1,1),randi_range(-1,1))
			new_pos += prev_pos
			if !room_pos.has(new_pos):
				room_pos.append(new_pos)
				break

func _connect_rooms(rooms : int):
	var can_reach : Array[bool] = []
	can_reach.resize(rooms + 1) 
	can_reach.fill(false)
	_find_neighbours(can_reach, 0)

func _find_neighbours(can_reach : Array[bool], start):
	var room = room_pos[start]
	can_reach[start] = true
	for dir_x in [-1,0,1]:
		for dir_y in [-1,0,1]:
			if dir_x == 0 and dir_y == 0:
				continue
			var neighbour = Vector2i(room.x + dir_x, room.y + dir_y)
			if dir_x == 0 or dir_y == 0:
				if room_pos.has(neighbour):
					if !can_reach[room_pos.find(neighbour)]:
						_find_neighbours(can_reach, room_pos.find(neighbour))
			elif room_pos.has(neighbour):
				if !can_reach[room_pos.find(neighbour)]:
					var new_corridor = (neighbour - room)
					new_corridor.x = 0
					new_corridor += room
					if !room_pos.has(new_corridor):
						hallway_pos.append(new_corridor)
						_find_neighbours(can_reach, room_pos.find(neighbour))

func _spawn_rooms():
	for pos in room_pos:
		var room = room_array.pick_random().instantiate()
		room.global_position = pos * ROOM_SIZE * TILE_SIZE
		add_child(room)

func _spawn_corridors():
	var hallway_tile = []
	for hallway in hallway_pos:
		for room in room_pos:
			var dir = (room - hallway)
			if dir.length() == 1:
				for i in range(16):
					hallway_tile.append(hallway * ROOM_SIZE + dir * i)
					if dir.x != 0:
						hallway_tile.append(hallway * ROOM_SIZE + dir * i + Vector2i(0,-1))
					else:
						hallway_tile.append(hallway * ROOM_SIZE + dir * i + Vector2i(-1,0))
		hall_tiles.set_cells_terrain_connect(hallway_tile,0 ,0, false)

func _show_minimap(rooms):
	for j in range(-rooms, rooms):
		var char_array = []
		for i in range(-rooms, rooms):
			if room_pos.has(Vector2i(i,j)):
				char_array.append("x")
			elif hallway_pos.has(Vector2i(i,j)):
				char_array.append("y")
			else:
				char_array.append(" ")
		print(char_array)
	
