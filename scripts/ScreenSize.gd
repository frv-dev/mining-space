class_name ScreenSize

var node: Node2D
var size: Vector2


func _init(node: Node2D):
	self.node = node
	_change_size()
	node.get_tree().root.connect('size_changed', self, '_change_size')	


func get_size() -> Vector2:
	return size


func _change_size() -> void:
	size = node.get_viewport_rect().size
