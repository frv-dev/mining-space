class_name BackgroundDisplacement extends TileMap

var main_player: Ship
var time := .0
var last_y_position: float


func _ready() -> void:
	var nodes := get_tree().get_nodes_in_group('main_player')
	
	if nodes.size() == 0:
		set_process(false)
	
	main_player = nodes[0]


func _process(delta: float) -> void:
	if not main_player:
		set_process(false)
	
	var x_displacement := (main_player.global_position.x - main_player.width / 4) * .0007
	var tile_set_ids: PoolIntArray = tile_set.get_tiles_ids()
	var tile_material: ShaderMaterial
	
	if tile_set_ids.size() == 0:
		return
	
	if not last_y_position:
		time += delta
	elif round(last_y_position) < round(main_player.global_position.y):
		time += delta / 1.5
	elif round(last_y_position) > round(main_player.global_position.y):
		time += delta * 2
	else:
		time += delta
	
	for tile_set_id in tile_set_ids:
		tile_material = (tile_set.tile_get_material(tile_set_id) as ShaderMaterial)
		tile_material.set_shader_param('x_displacement', x_displacement)
		tile_material.set_shader_param('time', time)

	last_y_position = main_player.global_position.y
