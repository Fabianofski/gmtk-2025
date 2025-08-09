class_name Deck
extends Node 

@export var cards: Array[Card] = []
@onready var cards_label: Label3D = $"CardsLeft3D"
@onready var mesh: Node3D = $"mesh"
var cards_copy: Array[Card] = []

# Used for hologram movement
var glitchiness = 0.01
var elapsed_time = 0.0

func _init():
	SignalBus.put_card_back_to_deck.connect(put_card_back_to_deck)
	SignalBus.game_won.connect(reset_deck)
	# Shuffle the cards array based on our instanced RNG, and not the global RNG (uncontrollable seed)
	_shuffle(cards, SignalBus.rng)

func _ready():
	reset_deck(0)
	update_label()

func _process(delta: float) -> void: # Glitchy holo movement
	elapsed_time += delta
	if elapsed_time >= 3.0:
		elapsed_time -= 3.0
		cards_label.position = Vector3(0.055, 0, -0.381) + Vector3(randf_range(-glitchiness, glitchiness), randf_range(-glitchiness, glitchiness), randf_range(-glitchiness, glitchiness))
		cards_label.scale = Vector3(1.411 * randf_range(0.8, 1.2), 1.411 * randf_range(0.8, 1.2), 1.411 * randf_range(0.8, 1.2))
	elif elapsed_time >= 0.15 and elapsed_time <= 1.0:
		cards_label.position = Vector3(0.055, 0, -0.381)
		cards_label.scale = Vector3(1.411, 1.411, 1.411)

func reset_deck(_round: int): 
	cards_copy = []
	var unlocked_cards: Array[Card] = []
	for card in cards: 
		if _round == 0: 
			card.unlocked_temp = card.unlocked

		if _round != 0 and not card.unlocked_temp and unlocked_cards.size() < 3:
			var will_unlock = SignalBus.rng.randf() < 0.15 or unlocked_cards.size() == 0
			if will_unlock: 
				unlocked_cards.append(card)
				card.unlocked_temp = true

		if card.unlocked_temp:
			cards_copy.append(card)
	_shuffle(cards_copy, SignalBus.rng)
	SignalBus.card_unlocked.emit(unlocked_cards)
	if _round == 0: 
		return
	cards_label.text = "DECK RESET"
	await get_tree().create_timer(2).timeout
	cards_label.text = "%d" % cards_copy.size()

func put_card_back_to_deck(card: Card): 
	cards_copy.insert(0, card)

func shuffle_cards() -> void: 
	# Shuffle the cards_copy array with our beloved deterministic RNG
	_shuffle(cards_copy, SignalBus.rng)

func update_label(): 
	if cards_label.text != "DECK RESET": 
		cards_label.text = "%d" % cards_copy.size()
	mesh.scale.y = float(cards_copy.size()) / cards_copy.size()
	mesh.visible = cards_copy.size() > 0

func draw_cards(amount: int) -> Array[Card]: 
	var drawed_cards: Array[Card] = []
	for i in amount:
		var card = cards_copy.pop_back()
		if card == null: 
			if i == 0: 
				SignalBus.game_over.emit("( RAN OUT OF CARDS )")
				return []
			else: 
				update_label()
				return drawed_cards
		else:
			drawed_cards.append(card)
	update_label()
	return drawed_cards

func _shuffle(array: Array, rng: RandomNumberGenerator): # Implementation of Fisher–Yates shuffle (https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle#The_modern_algorithm)
	for i in array.size() - 2:
		var j = rng.randi_range(i, array.size() - 1)
		var temp = array[i]
		array[i] = array[j]
		array[j] = temp
	return array
