extends Node

@onready var game_music: AudioStreamPlayer = $"Game Music"
@onready var main_menu_music: AudioStreamPlayer = $"Main Menu"

@onready var scoring_sfx_player: AudioStreamPlayer = $"Scoring SFX"
@onready var scoring_sfx_array = [preload("res://audio/sfx/card_score_sfx_1.ogg"), preload("res://audio/sfx/card_score_sfx_2.ogg"),
preload("res://audio/sfx/card_score_sfx_3.ogg"), preload("res://audio/sfx/card_score_sfx_4.ogg"),
preload("res://audio/sfx/card_score_sfx_5.ogg"), preload("res://audio/sfx/card_score_sfx_6.ogg")]

var sfx_volume: float = 1.0
var music_volume: float = 0.5
@onready var music_bus = AudioServer.get_bus_index("Music")
@onready var sfx_bus = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	main_menu_music.play()

func switch_music(track):
	game_music.pitch_scale = 1.0 # Reset pitch shenanigans
	match track:
		"game":
			game_music.volume_db = music_volume
			main_menu_music.volume_db = -80.0
		"title":
			game_music.volume_db = -80.0
			main_menu_music.volume_db = music_volume

func wind_tape(sitch):
	match sitch:
		"restart":
			game_music.pitch_scale = 0.25
			var tween = get_tree().create_tween()
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(game_music, "pitch_scale", 1.0, 2)
		"lose":
			game_music.pitch_scale = 1.0
			var tween = get_tree().create_tween()
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_IN)
			tween.tween_property(game_music, "pitch_scale", 0.25, 2)
		"next_round":
			game_music.pitch_scale = randf_range(0.25, 1.5)
			var tween = get_tree().create_tween()
			tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(game_music, "pitch_scale", 1.0, 0.25)

func play_scoring_sfx():
	scoring_sfx_player.stream = scoring_sfx_array[min(scoring_sfx_array.size() - 1, SignalBus.scoring_sfx)]
	scoring_sfx_player.play()
	SignalBus.scoring_sfx += 1

func adjust_sound():
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_volume))
