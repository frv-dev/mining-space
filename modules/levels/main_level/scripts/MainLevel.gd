class_name MainLevel extends Node2D

var preloaded_small_shoot := preload('res://modules/models/shoots/small_shoot/SmallShoot.tscn') as PackedScene


func _ready() -> void:
	pass


func _on_Ship_shoot(position: Vector2) -> void:
	var small_shoot := preloaded_small_shoot.instance() as SmallShoot
	small_shoot.global_position = position
	add_child(small_shoot)
