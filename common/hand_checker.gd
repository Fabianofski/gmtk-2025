class_name HandChecker

static var pair_payout = 2
static var flush_payout = 3
static var straight_payout = 4
static var three_of_a_kind_payout = 5
static var straight_flush_payout = 6

class Bonus:
	var type: String
	var payout: int

	func _init(_type: String = "", _payout: int = 0) -> void:
		type = _type
		payout = _payout

static func sort_cards(a: Card, b: Card): 
	if a.suit == b.suit: 
		return a.score < b.score 
	else: 
		return a.suit < b.suit

static func check_for_straight(cards: Array[Card]) -> bool: 
	if cards.size() < 3: 
		return false
	var straight_length = 1
	var last_card_score = cards.pop_front().score
	for card in cards: 
		if last_card_score + 1 == card.score: 
			straight_length += 1 
		else: 
			straight_length = 1
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

	if score_counts.values().has(2):
		bonuses.append(Bonus.new("pair", pair_payout))

	if suit_counts.values().has(3):
		bonuses.append(Bonus.new("flush", flush_payout))

	if check_for_straight(cards):
		bonuses.append(Bonus.new("straight", straight_payout))

	if score_counts.values().has(3):
		bonuses.append(Bonus.new("three of a kind", three_of_a_kind_payout))

	if check_for_straight(cards):
		bonuses.append(Bonus.new("straight flush", straight_flush_payout))

	return bonuses
