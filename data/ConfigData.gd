class_name ConfigData extends Resource

export(bool) var is_it_using_touch_screen = true

const path = 'user://config.tres'

static func save(data: ConfigData) -> void:
	ResourceSaver.save(path, data)


static func load() -> ConfigData:
	var file_check := File.new()
	
	if file_check.file_exists(path):
		return load(path) as ConfigData
	
	var data := load('res://data/ConfigData.gd').new() as ConfigData
	
	ResourceSaver.save(path, data)
	
	return data
