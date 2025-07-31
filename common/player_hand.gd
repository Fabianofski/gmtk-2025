extends Node

@export var hand: Array[Card]
@onready var deck: Deck = $Deck

func _ready():
	print(deck)
	deck.shuffle_cards() 
	hand.append_array(deck.draw_cards(6))
