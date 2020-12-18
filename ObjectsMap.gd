tool
extends Node2D
class_name ObjectsMap

var objects_map_editor: EditorPlugin

#export (Array, Resource) var tile_set: = []
export var tile_size: int = 32
export (Array, Texture) var tile_set: = [] setget update_tile_set
export var tile_textures: Array = []

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

func create_tiles(idx: int, t: Texture) -> void:
	tile_textures[idx].clear()
	var img = t.get_data()
	img.lock()
	for y in img.get_height() / tile_size:
		for x in img.get_width() / tile_size:
			var new_img: Image = img.get_rect(Rect2(x*tile_size, y*tile_size, tile_size, tile_size))
			create_texture(idx, new_img)
	img.unlock()
	pass

func create_texture(idx: int, img: Image) -> void:
	var img_tex = ImageTexture.new()
	img_tex.create_from_image(img, 0)
	tile_textures[idx].append(img_tex)

func set_map_plugin(m: EditorPlugin) -> void:
	objects_map_editor = m


