tool
extends TextureButton
class_name MapObject

var objects_map_editor: EditorPlugin
var idx: int = 0
var textures: Array = []
var has_subtile: bool = false

func init(m: EditorPlugin, parent: Control, i: int, texs: Array, t: Texture, s: bool = true) -> void:
	objects_map_editor = m
	idx = i
	textures = texs
	texture_normal = t
	has_subtile = s
	parent.add_child(self)
	self.set_owner(parent)
	hint_tooltip = t.resource_name
	if not s:
		hint_tooltip = str(idx)

func _on_MapObject_pressed() -> void:
	if has_subtile: objects_map_editor.show_subtiles(textures)
	objects_map_editor.set_selected_map_object(self)


