class_name Ship extends Node2D

export (int) var speed := 1000

var screen_size_object: ScreenSize

var width: float
var height: float


func _ready() -> void:
	screen_size_object = load('res://modules/scripts/ScreenSize.gd').new(self)
	
	var ship_sprite := ($ShipSprite as Sprite)
	
	width = ship_sprite.texture.get_width() * ship_sprite.transform.get_scale().x
	height = ship_sprite.texture.get_height() * ship_sprite.transform.get_scale().y
	
	_set_initial_position()


func _process(delta: float) -> void:
	_mouse_movement_mechanics(delta)
	_keys_controller_movement_mechanics(delta)
	_movement_limitations(delta)


func _set_initial_position() -> void:
	var screen_size := screen_size_object.get_size()
	
	global_position.x = screen_size.x / 2
	global_position.y = screen_size.y - (height / 2) - 100


func _mouse_movement_mechanics(delta: float) -> void:
	if Input.is_action_pressed('ui_click'):
		var mouse_position := get_global_mouse_position()
		
		var x_variation := abs(global_position.x - mouse_position.x)
		var y_variation := abs(global_position.y - mouse_position.y)
		
		if x_variation > 20 or y_variation > 20:
			translate(global_position.direction_to(mouse_position) * speed * delta)


func _keys_controller_movement_mechanics(delta: float) -> void:
	if Input.is_action_pressed('ui_click'):
		return
	
	var x_direction := 0.0
	var y_direction := 0.0
	
	if Input.is_action_pressed('ui_up'):
		y_direction -= .9
	if Input.is_action_pressed('ui_down'):
		y_direction += .9
	if Input.is_action_pressed('ui_right'):
		x_direction += .9
	if Input.is_action_pressed('ui_left'):
		x_direction -= .9
	
	translate(Vector2(x_direction, y_direction) * speed * delta)


func _movement_limitations(delta: float) -> void:
	var screen_size := screen_size_object.get_size()
	
	var x_minimum := round(width / 4)
	var x_maximum := round(screen_size.x - x_minimum)
	
	var y_minimum := round(height / 2)
	var y_maximum := round(screen_size.y - y_minimum)
	
	global_position.x = clamp(global_position.x, x_minimum, x_maximum)
	global_position.y = clamp(global_position.y, y_minimum, y_maximum)