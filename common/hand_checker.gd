class_name HandChecker

static var pair_payout = 2
static var flush_payout = 3
static var straight_payout = 4
static var three_of_a_kind_payout = 5

class Bonus:
	var type: String
	var payout: int

	func _init(_type: String = "", _payout: int = 0) -> void:
		type = _type
		payout = _payout

static func sort_cards(a: Card, b: Card): 
	if a.score == b.score: 
		return a.suit < b.suit
	else: 
		return a.score < b.score 

static func check_for_straight(cards: Array[Card]) -> bool: 
	if cards.size() < 3: 
		return false
	var straight_length = 1
	var last_card_score = cards.pop_front().score
	for card in cards: 
		if last_card_score + 1 == card.score: 
			straight_length += 1 
		elif last_card_score != card.score: 
			straight_length = 1
		if straight_length >= 3:
			return true
		last_card_score = card.score
	return straight_length >= 3

static func check_for_bonus(_cards: Array[Card]) -> Array[Bonus]:
	var bonuses: Array[Bonus] = []

	var cards = _cards.duplicate()
	cards.sort_custom(sort_cards)

	var score_counts = {}
	var suit_counts = {}

	for card in cards:
		score_counts[card.score] = score_counts.get(card.score, 0) + 1
		suit_counts[card.suit] = suit_counts.get(card.suit, 0) + 1

	for i in score_counts.values().filter(func(x): return x == 2):
		bonuses.append(Bonus.new("Pair", pair_payout))

	for i in suit_counts.values().filter(func(x): return x >= 3):
		bonuses.append(Bonus.new("Flush", flush_payout))

	if check_for_straight(cards):
		bonuses.append(Bonus.new("Straight", straight_payout))

	for i in score_counts.values().filter(func(x): return x >= 3):
		bonuses.append(Bonus.new("Three of a Kind", three_of_a_kind_payout))

	return bonuses
