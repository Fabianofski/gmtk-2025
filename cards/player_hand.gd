extends Node

@export var max_cards = 6
@export var hand: Array[Card]
@onready var hand_parent: Node3D = $PlayerHandCards
@onready var atk_hand_parent: Node3D = $PastPlayerHandCards
var card_prefab = preload("res://cards/card.tscn")
@onready var deck: Deck = $Deck

func _ready():
	SignalBus.select_card.connect(remove_card_from_hand)	
	SignalBus.deselect_card.connect(add_card_back_to_hand)	
	SignalBus.next_round_started.connect(draw_cards)
	SignalBus.game_won.connect(game_won)

	deck.shuffle_cards() 
	hand.append_array(deck.draw_cards(max_cards))
	display_cards(hand)

func game_won(_round: int): 
	hand = [] 
	clear_cards(hand_parent) 
	clear_cards(atk_hand_parent) 
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

func clear_cards(node: Node3D): 
	for child in node.get_children(): 
		child.queue_free()

func display_cards(cards: Array[Card]):
	for i in cards.size(): 
		var card_res = cards[i]
		var card = card_prefab.instantiate()
		hand_parent.add_child(card)
		card.global_position = deck.global_position
		card.global_rotation = deck.global_rotation
		card.emit_signal("update", card_res) 

	sort_cards(hand_parent)
	sort_cards(atk_hand_parent)

func sort_cards(node: Node3D): 
	await get_tree().process_frame
	var i = 0
	for child in node.get_children():
		if not is_instance_valid(child): 
			continue
		var target_pos = Vector3(i*0.8,0,0)
		child.emit_signal("tween_to_position", target_pos, Vector3(0,0,0), 0.5) 
		await get_tree().create_timer(0.1).timeout
		i += 1
