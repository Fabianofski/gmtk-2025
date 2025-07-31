extends Node

@export var hand: Array[Card]
@onready var hand_parent: Node3D = $Cards
var card_prefab = preload("res://cards/card.tscn")
@onready var deck: Deck = $Deck

func _ready():
	deck.shuffle_cards() 
	hand.append_array(deck.draw_cards(6))

	for i in hand.size(): 
		var card_res = hand[i]
		var card = card_prefab.instantiate()
		hand_parent.add_child(card)
		card.position.x = i * 0.8 
		card.emit_signal("update", card_res) 
