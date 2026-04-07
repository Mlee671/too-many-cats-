extends Node2D

const TILE_SIZE = 16
const ROOM_SIZE = 30

@onready var hall_tiles := $Hallway

var room_array : Array = []
var hallway_pos : Array[Vector2i] = []
var room_pos : Array[Vector2i] = []

func _ready() -> void:
	# loads all rooms in the room folder
	var dir = DirAccess.open("res://Room_scenes/Rooms/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			room_array.append(load("res://Room_scenes/Rooms/" + file_name))
			file_name = dir.get_next()

func generate_rooms(rooms : int) -> Vector2:
	# generates positions for rooms based on previous room position starting at 0,0
	# num of rooms decided in main
	_get_room_positions(rooms)
	# does dfs search to check if rooms are connected 
	# adds a hallway node if they are diagonaly touching
	_connect_rooms(rooms)
	# randomly selects premade rooms and places them on room_pos
	_spawn_rooms()
	# places hallway tiles on hallway nodes to connect rooms.
	# places floors to remove walls at end of hallway
	_spawn_corridors()
	# prints a minimap in terminal
	# _show_minimap(rooms)
	# returns spawn point for character
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
	# chacks all 8 directions for another room
	for dir_x in [-1,0,1]:
		for dir_y in [-1,0,1]:
			if dir_x == 0 and dir_y == 0:
				continue
			var neighbour = Vector2i(room.x + dir_x, room.y + dir_y)
			if dir_x == 0 or dir_y == 0:
				if room_pos.has(neighbour):
					if !can_reach[room_pos.find(neighbour)]:
						# recursive call
						_find_neighbours(can_reach, room_pos.find(neighbour))
			elif room_pos.has(neighbour):
				if !can_reach[room_pos.find(neighbour)]:
					# generates a hallway node
					var new_corridor = (neighbour - room)
					new_corridor.x = 0
					new_corridor += room
					#checks if its a room
					if !room_pos.has(new_corridor):
						hallway_pos.append(new_corridor)
						# recursive call
						_find_neighbours(can_reach, room_pos.find(neighbour))

func _spawn_rooms():
	for pos in room_pos:
		var room = room_array.pick_random().instantiate()
		room.global_position = pos * ROOM_SIZE * TILE_SIZE
		add_child(room)

func _spawn_corridors():
	var hallway_tile = []
	var remove_wall = []
	for hallway in hallway_pos:
		for room in room_pos:
			var dir = (room - hallway)
			if dir.length() == 1:
				for i in range(15):
					# makes hallway 2 tiles wide and 15 long in node to room direction
					hallway_tile.append(hallway * ROOM_SIZE + dir * i)
					hallway_tile.append(hallway * ROOM_SIZE + dir * i - abs(Vector2i(dir.y,dir.x)))
				# removes walls from end of hallways
				remove_wall.append(hallway * ROOM_SIZE + dir * 15)
				remove_wall.append(hallway * ROOM_SIZE + dir * 15 - abs(Vector2i(dir.y,dir.x)))
	# terrain places hallway floors and spawns walls around it
	hall_tiles.set_cells_terrain_connect(hallway_tile,0 ,0, false)
	# for removing walls
	for cell in remove_wall:
		hall_tiles.set_cell(cell, 0, Vector2i(9,7), 0)

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
	
