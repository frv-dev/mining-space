class_name SmallShot extends Node2D

export (float) var speed := 1000.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	translate(Vector2(0, - speed * delta))


func _on_VisibilityNotifier_screen_exited() -> void:
	queue_free()
