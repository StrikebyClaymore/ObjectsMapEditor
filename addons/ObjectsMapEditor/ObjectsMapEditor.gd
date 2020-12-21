tool
extends EditorPlugin

var map_obj_tscn: PackedScene = preload("res://addons/ObjectsMapEditor/MapObject.tscn")

var main_editor_panel: Control
var bottom_editor_panel: Control

var cursor: TextureRect
var default_cursor_offset: = Vector2(16, 16)

var selected_map: ObjectsMap

var selected_main_object: MapObject
var selected_object: MapObject

var selected_tile: Vector2

func handles(object) -> bool:
	return true

func edit(object) -> void:
	if object == selected_map: return
	
	if selected_map:
			selected_map.draw_grid = false
			
	selected_map = object as ObjectsMap
	if selected_map:
		selected_map.draw_grid = true
		_make_visible(true)
		selected_map.set_map_plugin(self)
		add_tiles_to_panel(selected_map.tile_textures)
	else:
		if object is Node:
			_make_visible(false)

func forward_canvas_gui_input(ev: InputEvent): # -> bool
	if not selected_map: return
	if ev is InputEventMouseButton:
		if not ev.pressed and ev.button_index == BUTTON_LEFT:
			#selected_map.tile_created()
			pass
		elif ev.pressed and ev.button_index == BUTTON_RIGHT:
			pass
	if ev is InputEventMouseMotion:
		if selected_map:
			cursor.rect_global_position = get_viewport().get_mouse_position() - default_cursor_offset
			selected_map.update()
			pass

func set_selected_map_object(object: MapObject) -> void:
	if not object:
		 return
	if selected_object:
		if object == selected_object: # Если новый объект это старый, то ничего не делать
			return
		elif selected_main_object and object.has_subtile:# and selected_object.has(object.textures[0])
			selected_main_object.pressed = false
			selected_object.pressed = false
		elif not object.has_subtile and not selected_object.has_subtile:
			selected_object.pressed = false
	if object.has_subtile:
		selected_main_object = object
	selected_object = object # Присвоение нового объекта на котороый кликнули
	cursor.texture = object.get_node("Icon").texture
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
		b_box.remove_child(c)
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
