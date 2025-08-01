class_name Deck
extends Node 

@export var cards: Array[Card] = []
@onready var cards_label: Label3D = $"CardsLeft3D"
var cards_copy: Array[Card] = []
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
					cards_copy.append(card)
		dir.list_dir_end()

	cards = cards_copy.duplicate()

	SignalBus.put_card_back_to_deck.connect(put_card_back_to_deck)
	SignalBus.game_won.connect(game_won)

func _ready():
	update_label()

func game_won(_round: int): 
	cards = cards_copy.duplicate()

func put_card_back_to_deck(card: Card): 
	cards.insert(0, card)

func shuffle_cards(): 
	cards.shuffle()

func update_label(): 
	cards_label.text = "%d" % cards.size()

func draw_cards(amount: int) -> Array[Card]: 
	var drawed_cards: Array[Card] = []
	for i in amount:
		var card = cards.pop_back()
		if card == null: 
			if i == 0: 
				SignalBus.game_over.emit("(RAN OUT OF CARDS)")
				return []
			else: 
				update_label()
				return drawed_cards
		else:
			drawed_cards.append(card)
	update_label()
	return drawed_cards
