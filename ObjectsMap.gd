tool
extends Node2D
class_name ObjectsMap

var objects_map_editor: EditorPlugin

export var draw_grid: bool = true setget set_grid
export var grid_color: Color
export var cursor_grid_color: Color

#export (Array, Resource) var tile_set: = []
export var tile_size: int = 32
export (Array, Texture) var tile_set: = [] setget update_tile_set
export var tile_textures: Array = []

func set_grid(value: bool) -> void:
	draw_grid = value
	update()

func update_tile_set(value: Array) -> void:
#	if tile_set.size() == value.size():
#		for i in tile_set.size():
#			if tile_set[i] != value[i]:
#				#print(tile_set[i], " changed to ", value[i])
#				create_tiles(i, value[i])
#	elif tile_set.size() != 0 and tile_set.size() < value.size():
#		#print("Slot created")
#		for i in range(value.size() - tile_set.size()):
#			tiles.push_back([])
#	elif tile_set.size() == 0:
#		#print("Slot created")
#		for v in value:
#			tiles.push_back([])
#	elif tile_set.size() > value.size():
#		for i in tile_set.size():
#			if i == tile_set.size()-1 or tile_set[i] != value[i]:
#				#print("Slot ", i, "deleted")
#				tiles.remove(i)
#				break
	tile_set = value
	tile_textures.clear()
	for i in tile_set.size():
		tile_textures.append([])
		if tile_set[i]: create_tiles(i, tile_set[i])
	if objects_map_editor != null:
		objects_map_editor.update_tiles(tile_textures)

func _draw() -> void:
	if not draw_grid: return# or not update_grid
	
	var pos: = get_viewport_transform().get_origin() * (-1)
	var _scale: = get_viewport_transform().get_scale()
	#print(pos)
	var size: = OS.window_size # / tile_size
	#var view_port_rect: = Rect2(pos, size)
	
	#draw_rect(rect, grid_color, false, 4.0)
	
	#printt(pos, position_to_tile(pos), tile_to_position(position_to_tile(pos)),  tile_to_position(position_to_tile(Vector2(abs(pos.x), abs(pos.y)))))
	
	var _offset: = Vector2(tile_size/2, tile_size/2)
	#pos -= Vector2(tile_size/2, tile_size/2)
	pos = tile_to_position(position_to_tile(pos))
	
	#print(pos)
	
	for y in size.y / tile_size:
		for x in size.x / tile_size:
			var new_pos: = Vector2(pos.x + x*tile_size - _offset.x, pos.y + y*tile_size - _offset.y)
			draw_rect(Rect2(new_pos, Vector2(tile_size, tile_size)), grid_color, false)
	
#	for y in OS.window_size.y / tile_size:
#		for x in OS.window_size.x / tile_size:
#			draw_rect(Rect2(x*tile_size, y*tile_size, tile_size, tile_size), grid_color, false)
	set_grid_around_cursor()

func set_grid_around_cursor() -> void:
	var pos = tile_to_position(position_to_tile(get_global_mouse_position()))
	
	pos -= Vector2(tile_size/2, tile_size/2)
	#print(get_global_mouse_position())
	#print(pos)
	
	#print("START RECT")
	for y in range(-1, 2):
		for x in range(-1, 2):
			var rect: = Rect2(pos.x + x*tile_size, pos.y + y*tile_size, tile_size, tile_size)
			#print(rect)
			draw_rect(rect, cursor_grid_color, false)

func create_tiles(idx: int, t: Texture) -> void:
	tile_textures[idx].clear()
	
	var path_split: PoolStringArray = t.get_path().split("/")
	var _name: String = path_split[path_split.size()-1]
	_name.erase(_name.length()-4, 4)
	var img = t.get_data()
	img.lock()
	for y in img.get_height() / tile_size:
		for x in img.get_width() / tile_size:
			var new_img: Image = img.get_rect(Rect2(x*tile_size, y*tile_size, tile_size, tile_size))
			create_texture(idx, new_img, _name)
	img.unlock()
	pass

func create_texture(idx: int, img: Image, _name: String) -> void:
	var img_tex = ImageTexture.new()
	img_tex.create_from_image(img, 0)
	img_tex.resource_name = _name
	tile_textures[idx].append(img_tex)

func set_map_plugin(m: EditorPlugin) -> void:
	objects_map_editor = m

func position_to_tile(p: Vector2) -> Vector2:
	if p.x < 0 and p.y < 0:
		return Vector2(int((p.x - tile_size) / tile_size), int((p.y - tile_size) / tile_size))
	elif p.x < 0:
		return Vector2(int((p.x - tile_size) / tile_size), int(p.y / tile_size))
	elif p.y < 0:
		return Vector2(int(p.x / tile_size), int((p.y - tile_size) / tile_size))
	return Vector2(int(p.x / tile_size), int(p.y / tile_size))

func tile_to_position(t: Vector2) -> Vector2:
	return Vector2((t.x + 0.5) * tile_size, (t.y + 0.5) * tile_size)

#func _tile_to_id(x, y):
#	return x + y * width_in_cells
#
#func tile_to_id(t: Vector2):
#	return _tile_to_id(t.x, t.y)
#
#func position_to_id(p: Vector2):
#	return tile_to_id(position_to_tile(p))

export var _update: bool = false setget update_func

func update_func(value: bool) -> void:
	#_update = value
	#Input.set_custom_mouse_cursor(load("res://Images/closet.png"))
	#ProjectSettings.set("display/mouse_cursor/custom_image", load("res://Images/closet.png"))
	pass


