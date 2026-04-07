extends Node2D

const TILE_SIZE = 16

var room_array : Array = []
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
	room_pos.append(Vector2i(0,0))
	for i in rooms:
		while room_pos:
			var prev_pos = room_pos[-1]
			var new_pos := Vector2i(randi_range(-1,1),randi_range(-1,1)) * 20
			new_pos += prev_pos
			if !room_pos.has(new_pos):
				room_pos.append(new_pos)
				break
	var rand_room = randi_range(0, room_array.size() - 1)
	for pos in room_pos:
		var room = room_array.get(rand_room).instantiate()
		room.global_position = pos * TILE_SIZE
		add_child(room)
	return room_pos[0]
				
