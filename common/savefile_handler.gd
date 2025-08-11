extends Node

var config = ConfigFile.new()
const SAVE_FILE_PATH = "user://savefile.ini"

func _ready() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH) == false:
		config.set_value("playerinfo", "highest_level_reached", 0)
		config.set_value("playerinfo", "highest_score_reached", 0)
		config.set_value("options", "music_volume", 0.5)
		config.set_value("options", "sfx_volume", 1.0)
		config.set_value("options", "has_seen_tutorial", false)
		config.save(SAVE_FILE_PATH)
	else:
		config.load(SAVE_FILE_PATH)

func save_to_file(section: String, key: String, value):
	config.set_value(section, key, value)
	config.save(SAVE_FILE_PATH)

func load_from_file(section: String):
	var saved_data: Dictionary = {}
	for saved_key in config.get_section_keys(section):
		saved_data[saved_key] = config.get_value(section, saved_key)
	return saved_data

func reset_to_default():
	config.set_value("playerinfo", "highest_level_reached", 0)
	config.set_value("playerinfo", "highest_score_reached", 0)
	config.set_value("options", "music_volume", 0.5)
	config.set_value("options", "sfx_volume", 1.0)
	config.set_value("options", "has_seen_tutorial", false)
	config.save(SAVE_FILE_PATH)
