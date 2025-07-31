extends Node

@export var max_cards = 6
@export var hand: Array[Card]
@onready var hand_parent: Node3D = $Cards
var card_prefab = preload("res://cards/card.tscn")
@onready var deck: Deck = $Deck

func _init():
	SignalBus.select_card.connect(remove_card_from_hand)	
	SignalBus.deselect_card.connect(add_card_back_to_hand)	
	SignalBus.next_round_started.connect(draw_cards)

func _ready():
	deck.shuffle_cards() 
	hand.append_array(deck.draw_cards(max_cards))
	display_cards(hand)

func remove_card_from_hand(card: Card): 
	var index = hand.find_custom(func (x): return x.id == card.id)
	hand.remove_at(index)

func add_card_back_to_hand(card: Card): 
	hand.append(card)

func draw_cards(_state): 
	var cards_to_draw = max_cards - hand.size()
	var new_cards = deck.draw_cards(cards_to_draw)
	display_cards(new_cards) 
	hand.append_array(new_cards)

func display_cards(cards: Array[Card]):
	for i in cards.size(): 
		var card_res = cards[i]
		var card = card_prefab.instantiate()
		hand_parent.add_child(card)
		card.position.x = i * 0.8 
		card.emit_signal("update", card_res) 
