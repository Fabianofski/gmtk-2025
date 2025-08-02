extends Node

var tutorial_shown = false

@warning_ignore_start("unused_signal")
signal select_card(card)
signal deselect_card(card)
signal put_card_back_to_deck(card)
signal next_round_started(state)
signal game_over(message)
signal game_won(round)
signal card_unlocked(cards)
signal defended_against_attack(health)
signal add_hearts(count)
signal animate_card_score(card_id, current_score, addition)
@warning_ignore_restore("unused_signal")

func _ready() -> void:
	get_window().min_size = Vector2i(1200, 520)
