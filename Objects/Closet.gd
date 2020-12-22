tool
extends BasicObject
class_name Closet

#enum States { CLOSED_LOCK = 0, CLOSED = 1, OPEN = 2, NO_DOOR = 3 }

var States: Dictionary = { CLOSED = 0, OPEN = 1, NO_DOOR = 2 }
export var state: int

export var load_from_map: bool = false
export var data: Dictionary = {"name": "", "texture": null, "idx": 0}

func _init():
	type = "Closet"

func init(parent: ObjectsMap, n: String, t: Texture, p: Vector2, _load_from_map: bool = false, i: int = 0) -> void:#, t: Texture
	load_from_map = _load_from_map
	name = n
	position = p
	set_state(i)
	set_texture(t)
	parent.add_child(self)
	set_owner(parent.get_parent())
	
	hide_collision()
	
	data.name = n
	data.texture = t
	data.idx = i

func _ready() -> void:
	if not Engine.is_editor_hint() and load_from_map:
		name = data.name
		set_state(data.idx)
		set_texture(data.texture)

func _left_click() -> void:
	match state:
		States.CLOSED: open()
		States.OPEN: close()

func set_texture(t: Texture = null) -> void:
	if has_node("Sprite"):
		$Sprite.texture = t
		$Sprite.hframes = 3
		$Sprite.frame = state

func set_state(i: int) -> void:
	state = i

func open():
	if state == States.CLOSED:
		state = States.OPEN
		$Sprite.frame = state

func close():
	if state == States.OPEN:
		state = States.CLOSED
		$Sprite.frame = state
