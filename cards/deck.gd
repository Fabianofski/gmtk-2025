class_name Deck
extends Node 

@export var cards: Array[Card] = []
var cards_folder = "res://cards/res"

func _init():
	var dir := DirAccess.open(cards_folder)
	if dir:
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			if file_name == "":
				break
			if dir.current_is_dir():
				continue
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var card = load(cards_folder + "/" + file_name)
				if card is Card:
					cards.append(card)
		dir.list_dir_end()

func shuffle_cards(): 
	cards.shuffle()

func draw_cards(amount: int) -> Array[Card]: 
	var drawed_cards: Array[Card] = []
	for i in amount:
		drawed_cards.append(cards.pop_back())
	return drawed_cards
