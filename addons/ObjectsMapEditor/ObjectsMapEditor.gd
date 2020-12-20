tool
extends EditorPlugin

var map_obj_tscn: PackedScene = preload("res://addons/ObjectsMapEditor/MapObject.tscn")

var main_editor_panel: Control
var bottom_editor_panel: Control

var cursor: TextureRect
var default_cursor_offset: = Vector2(16, 16)

var selected_objects_map: ObjectsMap
var selected_map_object: MapObject

func handles(object) -> bool:
	return true

func edit(object) -> void:
	if object == selected_objects_map: return
	
	if selected_objects_map:
			selected_objects_map.draw_grid = false
			
	selected_objects_map = object as ObjectsMap
	if selected_objects_map:
		selected_objects_map.draw_grid = true
		_make_visible(true)
		selected_objects_map.set_map_plugin(self)
		add_tiles_to_panel(selected_objects_map.tile_textures)
		#print(selected_objects_map.tiles)
	else:
		#print(main_editor_panel, " ", main_editor_panel.get_parent())
		#print(object)
		
		#Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
		if object is Node:
			_make_visible(false)

func forward_canvas_gui_input(ev: InputEvent): # -> bool
	if not selected_objects_map: return
	if ev is InputEventMouseButton:
		if not ev.pressed and ev.button_index == BUTTON_LEFT:
			#selected_objects_map.tile_created()
			pass
		elif ev.pressed and ev.button_index == BUTTON_RIGHT:
			pass
	if ev is InputEventMouseMotion:
		if selected_objects_map:
			#var scene_root = get_tree().get_edited_scene_root()
			#var mouse_coords = scene_root.get_global_mouse_position()
			cursor.rect_global_position = get_viewport().get_mouse_position() - default_cursor_offset
			selected_objects_map.update()

func set_selected_map_object(object: TextureButton) -> void:
	#printt("123", object.texture_normal)
	#Input.set_custom_mouse_cursor(object.texture_normal)
	cursor.texture = object.texture_normal
	cursor.visible = true
	pass

func add_tiles_to_panel(tileset: Array) -> void:
	var t_box: VBoxContainer = main_editor_panel.get_node("Panels/TopButton/Buttons")
#	var b_box: VBoxContainer = main_editor_panel.get_node("Panels/BottomButton/Buttons")
	for textures in tileset:
		if textures.empty(): continue
		var o: = map_obj_tscn.instance()
		o.init(self, t_box, t_box.get_child_count(), textures, textures[0])
#		for t in textures:
#			o = map_obj_tscn.instance()
#			o.init(self, b_box, b_box.get_child_count(), t)

func update_tiles(tileset: Array) -> void:
	var t_box: VBoxContainer = main_editor_panel.get_node("Panels/TopButton/Buttons")
#	var b_box: VBoxContainer = main_editor_panel.get_node("Panels/BottomButton/Buttons")
	for c in t_box.get_children():
		c.queue_free()
#	for c in b_box.get_children():
#		c.queue_free()
	for textures in tileset:
		if textures.empty(): continue
		var o: = map_obj_tscn.instance()
		o.init(self, t_box, t_box.get_child_count(), textures, textures[0])
#		for t in textures:
#			o = map_obj_tscn.instance()
#			o.init(self, b_box, b_box.get_child_count(), t)

func show_subtiles(textures: Array) -> void:
	var b_box: VBoxContainer = main_editor_panel.get_node("Panels/BottomButton/Buttons")
	for c in b_box.get_children():
		c.queue_free()
	for t in textures:
		var o: = map_obj_tscn.instance()
		o.init(self, b_box, b_box.get_child_count(), textures, t, false)

func _enter_tree() -> void:
	main_editor_panel = load("res://addons/ObjectsMapEditor/MainPanel.tscn").instance()
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, main_editor_panel)
	
	var panel_button: = main_editor_panel.get_node("Panels/TopButton")
	panel_button.rect_min_size.y = OS.window_size.y/2
	panel_button.connect("pressed", self, "_on_TopButton_pressed")
	
	panel_button = main_editor_panel.get_node("Panels/BottomButton")
	panel_button.rect_min_size.y = OS.window_size.y/2
	panel_button.connect("pressed", self, "_on_BottomButton_pressed")
	
	cursor = main_editor_panel.get_node("Cursor")
	
	#bottom_editor_panel = load("res://addons/TileMapObjectsEditor/BottomPanel.tscn").instance()
	#bottom_editor_panel.rect_size.x = main_editor_panel.rect_size.x
	#main_editor_panel.add_child(bottom_editor_panel)
	
	#add_control_to_container(EditorPlugin.CONTAINER_, bottom_editor_panel)
	#add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU)
	_make_visible(false)
	pass

func _exit_tree() -> void:
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, main_editor_panel)
	#remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_SIDE_RIGHT, bottom_editor_panel)
	pass

func _on_TopButton_pressed():
	main_editor_panel.get_node("Panels/BottomButton").pressed = false

func _on_BottomButton_pressed():
	main_editor_panel.get_node("Panels/TopButton").pressed = false

func _make_visible(visible: bool) -> void:
	var panels: VBoxContainer = main_editor_panel.get_node("Panels")
	var top_button = panels.get_node("TopButton")
	var box: VBoxContainer = top_button.get_node("Buttons")
	for c in box.get_children():
		#c.visible = visible
		c.queue_free()
	box.visible = visible
	
	top_button.visible = visible
	panels.get_node("BottomButton").visible = visible
	panels.visible = visible
	#main_editor_panel.get_node("BottomPanel").visible = visible
	cursor.visible = visible
	
	main_editor_panel.visible = visible
	
#	box = bottom_editor_panel.get_node("VBoxContainer")
#	for c in box.get_children():
#		#c.visible = visible
#		c.queue_free()
#	box.visible = visible
#	bottom_editor_panel.visible = visible
#	#remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_SIDE_RIGHT, main_editor_panel)
