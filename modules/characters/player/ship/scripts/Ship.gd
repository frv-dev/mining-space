class_name Ship extends Node2D

export (int) var speed := 1000
export (int) var maximum_shoots := 16

var screen_size_object: ScreenSize
var config_data_object: ConfigData

var width: float
var height: float

var has_automatic_shoot: bool
var can_it_shoot_again: bool = true

signal shoot(position)


func _ready() -> void:
	screen_size_object = load('res://scripts/ScreenSize.gd').new(self)
	config_data_object = ConfigData.load()
	
	_set_shoot_mechanics()
	_set_ship_size()
	_set_initial_position()
	_config_shoot_timer()


func _process(delta: float) -> void:
	_mouse_and_finger_movement_mechanics(delta)
	_keys_and_controller_movement_mechanics(delta)
	_movement_limitations()
	
	if not has_automatic_shoot: _keys_and_controller_shoot_mechanics()


func _set_shoot_mechanics() -> void:
	has_automatic_shoot = config_data_object.is_it_using_touch_screen


func _set_ship_size() -> void:
	var ship_sprite := ($ShipSprite as Sprite)
	
	width = ship_sprite.texture.get_width() * ship_sprite.transform.get_scale().x
	height = ship_sprite.texture.get_height() * ship_sprite.transform.get_scale().y


func _set_initial_position() -> void:
	var screen_size := screen_size_object.get_size()
	
	global_position.x = screen_size.x / 2
	global_position.y = screen_size.y - (height / 2) - 100


func _config_shoot_timer() -> void:
	var shoot_timer = ($ShootTimer as Timer)
	
	shoot_timer.one_shot = not has_automatic_shoot
	
	if has_automatic_shoot:
		shoot_timer.wait_time = 0.2
	else:
		shoot_timer.wait_time = 0.15


func _mouse_and_finger_movement_mechanics(delta: float) -> void:
	if Input.is_action_pressed('ui_click'):
		var mouse_position := get_global_mouse_position()
		
		var x_variation := abs(global_position.x - mouse_position.x)
		var y_variation := abs(global_position.y - mouse_position.y)
		
		if x_variation > 20 or y_variation > 20:
			translate(global_position.direction_to(mouse_position) * speed * delta)


func _keys_and_controller_movement_mechanics(delta: float) -> void:
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


func _movement_limitations() -> void:
	var screen_size := screen_size_object.get_size()
	
	var x_minimum := round(width / 4)
	var x_maximum := round(screen_size.x - x_minimum)
	
	var y_minimum := round(height / 2)
	var y_maximum := round(screen_size.y - y_minimum)
	
	global_position.x = clamp(global_position.x, x_minimum, x_maximum)
	global_position.y = clamp(global_position.y, y_minimum, y_maximum)


func _on_ShootTimer_timeout() -> void:
	if has_automatic_shoot: _shoot()
	else: can_it_shoot_again = true


func _keys_and_controller_shoot_mechanics() -> void:
	if Input.is_action_pressed('ui_accept') and can_it_shoot_again:
		_shoot()
		can_it_shoot_again = false
		($ShootTimer as Timer).start()


func _shoot() -> void:
	var quantity_shoots = get_tree().get_nodes_in_group('shoots').size()
		
	if quantity_shoots < maximum_shoots * 2:
		emit_signal('shoot', Vector2(global_position.x - 82, global_position.y - 80))
		emit_signal('shoot', Vector2(global_position.x + 78, global_position.y - 80))
