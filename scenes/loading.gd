extends Control

const GAME_SCENE = "res://scenes/game.tscn"
const MENU_SCENE = "res://scenes/title_screen.tscn"

var target_scene = "res://scenes/title_screen.tscn" # By default, just go to the title screen

var loading_status : int
var progress : Array[float]

@onready var progress_bar : ProgressBar = $ProgressBar

func _ready() -> void:
	match SignalBus.scene_to_load_next:
		"title":
			target_scene = MENU_SCENE
		"game":
			target_scene = GAME_SCENE
	ResourceLoader.load_threaded_request(target_scene) # "Hello, may I have one scene please?"
	MusicHandler.switch_music(SignalBus.scene_to_load_next) # Switch the music

func _process(_delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 # Update the value
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene))
		ResourceLoader.THREAD_LOAD_FAILED:
			# If something's gone wrong, pretend nothing happened and go back to the title screen lol
			get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
