tool
extends Closet
class_name ClosetWithLock

func _init():
	States = { CLOSED_LOCK = 0, CLOSED = 1, OPEN = 2, NO_DOOR = 3 }


func set_texture(t: Texture = null) -> void:
	if has_node("Sprite"):
		$Sprite.texture = t
		$Sprite.hframes = 4
		$Sprite.frame = state

func lock():
	if state == States.CLOSED:
		state = States.OPEN
		$Sprite.frame = state

func unlock():
	if state == States.CLOSED_LOCK:
		state = States.OPEN
		$Sprite.frame = state
