extends Control

const TARGET_SCENE = "res://scenes/game.tscn"

var loading_status : int
var progress : Array[float]

@onready var progress_bar : ProgressBar = $ProgressBar

func _ready() -> void:
	ResourceLoader.load_threaded_request(TARGET_SCENE) # "Hello, may I have one game scene please?"
	MusicHandler.switch_to_game_music() # Self-explanatory

func _process(_delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(TARGET_SCENE, progress)
	
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 # Update the value
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the game
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(TARGET_SCENE))
		ResourceLoader.THREAD_LOAD_FAILED:
			# If something's gone wrong, pretend nothing happened and go back to the title screen lol
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
