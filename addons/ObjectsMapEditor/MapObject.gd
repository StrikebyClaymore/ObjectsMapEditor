tool
extends TextureButton
class_name MapObject

var objects_map_editor: EditorPlugin
var idx: int = 0
var textures: Array = []
var subtile: bool = false

func init(m: EditorPlugin, parent: Control, i: int, texs: Array, t: Texture, s: bool = true) -> void:
	objects_map_editor = m
	idx = i
	textures = texs
	texture_normal = t
	subtile = s
	parent.add_child(self)
	self.set_owner(parent)

func _on_MapObject_pressed() -> void:
	if subtile: objects_map_editor.show_subtiles(textures)
	objects_map_editor.set_selected_map_object(self)


