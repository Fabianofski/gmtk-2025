extends Node3D 
class_name Game

var selected_cards: Array[Card] = []
var last_played: Array[Card] = []
@export var health: int = 10
@onready var round_info: Label = $RoundInfo
@onready var state_info: Label = $"State/StateInfo"
@onready var goal_info: Label = $"Goal/GoalInfo"
@onready var health_label: Label = $"Health/Health Label"
@onready var score_label: Label = $"Score/Score Label"

@export var score: int = 0
@export var current_round: int = 0
@export var round_target_scores: Array[int] = [] 
var target_score = func (): return round_target_scores[current_round]

enum STATE { Attack, Defense }
var state: STATE = STATE.Attack

func _init():
	SignalBus.select_card.connect(select_card)	
	SignalBus.deselect_card.connect(deselect_card)	

func select_card(card: Card): 
	selected_cards.append(card)
	update_label()

func deselect_card(card: Card): 
	var index = selected_cards.find_custom(func (x): return x.id == card.id)
	selected_cards.remove_at(index)
	update_label()

func update_label(): 
	var preview = calc_atk_dfs_values(selected_cards)
	print(preview)
	if state == STATE.Attack: 
		round_info.text = "Atk: " + str(preview['atk']) + ", Score: " + str(preview['score'])
	else: 
		round_info.text = "Def: " + str(preview['dfs'])

func calc_atk_dfs_values(cards: Array[Card]): 
	var atk = 0
	var dfs = 0
	var round_score = 0

	for card in cards: 
		atk += card.attack
		dfs += card.defense
		round_score += card.score

	for card in cards: 
		atk *= card.attack_multiplier
		dfs *= card.defense_multiplier
		round_score *= card.score_multiplier

	round_score = int(round_score * max(1, log(cards.size()) * 10))

	return {
		'score': round_score, 
		'atk': atk, 
		'dfs': dfs
	}

func next_round(): 
	if state == STATE.Attack: 
		var values = calc_atk_dfs_values(selected_cards)
		score += values['score']

		last_played = selected_cards
		state = STATE.Defense

		score_label.text = str(score).pad_zeros(9)
		state_info.text = "DEF"
		goal_info.text = "Beat your own attack with " + str(values['atk']) + " ATK points"
	else: 
		var hand = calc_atk_dfs_values(selected_cards)
		var old_hand = calc_atk_dfs_values(last_played)
		
		var diff = hand['dfs'] - old_hand['atk']
		if diff <= 0: 
			print("losing ", diff, ' hearts')
			health += diff

		if health <= 0: 
			SignalBus.game_over.emit("You ran out of hearts!")
		
		state = STATE.Attack
		state_info.text = "ATK"
		goal_info.text = "Attack and score points!"
		health_label.text = str(health).pad_zeros(4)

	selected_cards = []
	update_label()
	SignalBus.next_round_started.emit(state)
