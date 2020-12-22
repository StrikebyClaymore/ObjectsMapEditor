extends KinematicBody2D
class_name BaseKinematicBody

var type: String = "BaseKinematicBody"

func _enter_tree() -> void:
	if not is_connected("input_event", self, "_on_BaseKinematicBody_input_event"):
		connect("input_event", self, "_on_BaseKinematicBody_input_event")

func _left_click() -> void:
	pass

func _right_click() -> void:
	pass

func _on_input_event(ev: InputEvent) -> void:
	if ev is InputEventMouseButton:
		if ev.is_action_pressed("left_click"): 
			_left_click()
		if ev.is_action_pressed("right_click"):
			_right_click()

func _on_BaseKinematicBody_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	_on_input_event(event)

func hide_collision():
	if has_node("CollisionShape2D"):
		$CollisionShape2D.visible = false

func show_collision():
	if has_node("CollisionShape2D"):
		$CollisionShape2D.visible = true
