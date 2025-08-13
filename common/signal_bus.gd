extends Node

var rng = RandomNumberGenerator.new()
var has_set_custom_seed = false

var tutorial_shown = false
var selected_cards = 0

var scene_to_load_next: String = "title"

var scoring_sfx: int = 0

@warning_ignore_start("unused_signal")
signal select_card(card)
signal deselect_card(card)
signal force_card_draw(cards)
signal put_card_back_to_deck(card)
signal next_round_started(state)
signal game_over(message)
signal show_text_popup(message)
signal game_won(round)
signal card_unlocked(cards)
signal defended_against_attack(health)
signal add_hearts(count)
signal animate_card_score(card_id, current_score, addition)
signal animate_bonus_score(bonus, current_score, multiplier)
@warning_ignore_restore("unused_signal")

func _ready() -> void:
	get_window().min_size = Vector2i(1200, 520) # Enforce a minimum window size
	query_rng()

func query_rng() -> void:
	print("The current RNG seed is "+str(rng.seed)+". That a custom seed has been set is "+str(has_set_custom_seed)+".")

func load_scene(scene) -> void:
	scene_to_load_next = scene
	get_tree().change_scene_to_file("res://scenes/loading_scene.tscn")
