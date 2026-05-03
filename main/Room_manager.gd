extends Node2D
class_name Room_manager

const TILE_SIZE = 16
const ROOM_SIZE = 30

@onready var hall_tiles := $Hallway

@onready var start_room := preload("res://Room_scenes/Unique_Scenes/starting_room.tscn")
@onready var fountain_room := preload("res://Room_scenes/Rooms/fountain_room.tscn")
@onready var boss_room := preload("res://Room_scenes/Unique_Scenes/boss_room.tscn")

var room_array : Array = []
var hallway_pos : Array[Vector2i] = []
var room_pos : Array[Vector2i] = []
var enemy_array : Array = []
var neighbour_vectors : Array = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

func _ready() -> void:
	# loads all rooms in the room folder
	var dir = DirAccess.open("res://Room_scenes/Rooms/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			room_array.append(load("res://Room_scenes/Rooms/" + file_name))
			file_name = dir.get_next()
	var dir2 = DirAccess.open("res://entities/enemy/Enemy_scenes/")
	if dir2:
		dir2.list_dir_begin()
		var file_name = dir2.get_next()
		while file_name != "":
			enemy_array.append(load("res://entities/enemy/Enemy_scenes/" + file_name))
			file_name = dir2.get_next()

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
	_blank_area()
	## _show_minimap(rooms)
	# returns spawn point for character
	return room_pos[0] * ROOM_SIZE * TILE_SIZE
				
func _get_room_positions(rooms : int):
	room_pos.append(Vector2i(0,1))
	room_pos.append(Vector2i(0,0))
	for i in rooms:
		while true:
			var prev_pos = room_pos[-1]
			var new_pos := Vector2i(randi_range(-1,1),randi_range(-1,1))
			new_pos += prev_pos
			if !room_pos.has(new_pos):
				room_pos.append(new_pos)
				break

func _connect_rooms(rooms : int):
	var can_reach : Array[bool] = []
	can_reach.resize(rooms + 2) 
	can_reach.fill(false)
	_find_neighbours(can_reach, 0)

func _find_neighbours(can_reach : Array[bool], start):
	var room = room_pos[start]
	can_reach[start] = true
	if room == Vector2i(0,1):
		_find_neighbours(can_reach, room_pos.find(Vector2i(0,0)))
	# chacks all 8 directions for another room
	for dir_x in [-1,0,1]:
		for dir_y in [-1,0,1]:
			if dir_x == 0 and dir_y == 0:
				continue
			var neighbour = Vector2i(room.x + dir_x, room.y + dir_y)
			if dir_x == 0 or dir_y == 0:
				if neighbour != Vector2i(0,1) and room_pos.has(neighbour):
					if !can_reach[room_pos.find(neighbour)]:
						# recursive call if find a room directly connected
						_find_neighbours(can_reach, room_pos.find(neighbour))
			elif room_pos.has(neighbour):
				if !can_reach[room_pos.find(neighbour)]:
					# generates a hallway node
					var new_corridor = (neighbour - room)
					var temp = Vector2i(0, new_corridor.y)
					# check for if corridor overlaps with origin and goes a different direction if true
					if room + temp == Vector2i(0,1):
						new_corridor.y = 0
					else:
						new_corridor.x = 0
					new_corridor += room
					# checks if corridor overlaps a room
					if !room_pos.has(new_corridor):
						hallway_pos.append(new_corridor)
						# recursive call if found a room diagonally connected
						_find_neighbours(can_reach, room_pos.find(neighbour))

func _spawn_rooms():
	_add_boss_room()
	for pos in room_pos:
		var room
		if pos == Vector2i(0,1):
			room = start_room.instantiate()
			room.global_position = pos * ROOM_SIZE * TILE_SIZE
		elif pos == Vector2i(0,0):
			room = fountain_room.instantiate()
			room.global_position = pos * ROOM_SIZE * TILE_SIZE
		elif pos == room_pos[-1]:
			room = boss_room.instantiate()
			room.global_position = pos * ROOM_SIZE * TILE_SIZE
		else:
			room = room_array.pick_random().instantiate()
			room.global_position = pos * ROOM_SIZE * TILE_SIZE
		add_child(room)
		## removing hallways
		if pos != Vector2i(0,1) and pos != room_pos[-1]:
			for neighbour in neighbour_vectors:
				if neighbour + pos == Vector2i(0,1) and pos != Vector2i(0,0):
					room.remove_direction(neighbour)
				elif !hallway_pos.has(neighbour + pos):
					if !room_pos.has(neighbour + pos):
						room.remove_direction(neighbour)

func _spawn_corridors():
	var hallway_tile = []
	var remove_wall = []
	var black_tile = []
	for hallway in hallway_pos:
		for i in range(-15,15):
			for j in range(-15,15):
				black_tile.append(hallway * ROOM_SIZE + Vector2i(i,j))
		for room in room_pos:
			var dir = (room - hallway)
			if dir.length() == 1 and room != Vector2i(0,1):
				for i in range(15):
					# makes hallway 2 tiles wide and 15 long in node to room direction
					hallway_tile.append(hallway * ROOM_SIZE + dir * i)
					hallway_tile.append(hallway * ROOM_SIZE + dir * i - abs(Vector2i(dir.y,dir.x)))
				# removes walls from end of hallways
				remove_wall.append(hallway * ROOM_SIZE + dir * 15)
				remove_wall.append(hallway * ROOM_SIZE + dir * 15 - abs(Vector2i(dir.y,dir.x)))
	# terrain places hallway floors and spawns walls around it
	hall_tiles.set_cells_terrain_connect(hallway_tile,0 ,0, false)
	var used_cells = hall_tiles.get_used_cells()
	for cell in black_tile:
		if !used_cells.has(cell):
			hall_tiles.set_cell(cell, 0, Vector2i(8,7), 0)
	# for removing walls
	for cell in remove_wall:
		hall_tiles.set_cell(cell, 0, Vector2i(9,7), 0)

func _blank_area():
	var black_tile = []
	for room in room_pos:
		# check all dir around every room
		for dir_x in [-1,0,1]:
			for dir_y in [-1,0,1]:
				var dir = Vector2i(dir_x,dir_y)
				if dir == Vector2i(0,0):
					continue
				# if dir is empty fill with black area
				if !room_pos.has(room + dir):
					if !hallway_pos.has(room + dir):
						for i in range(-15,15):
							for j in range(-15,15):
								black_tile.append((room + dir) * ROOM_SIZE + Vector2i(i,j))
	for cell in black_tile:
		hall_tiles.set_cell(cell, 0, Vector2i(8,7), 0)

func _add_boss_room():
	for i in range(room_pos.size()-1, -1, -1):
		var pos = room_pos[i] + Vector2i.UP
		if !room_pos.has(pos):
			if !hallway_pos.has(pos):
				if check_neighbours(pos, room_pos[i]):
					room_pos.append(pos)
					return

func check_neighbours(pos : Vector2i, from : Vector2i):
	for dir in neighbour_vectors:
		var vec_pos = pos + dir
		if vec_pos == from:
			continue
		if room_pos.has(vec_pos) || hallway_pos.has(vec_pos):
			return false
	return true

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
	
func get_enemy() -> PackedScene:
	var enemy = enemy_array.pick_random()
	return enemy
