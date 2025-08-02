extends Node3D 
class_name Game

var selected_cards: Array[Card] = []
var last_played: Array[Card] = []
@export var health: int = 10
@onready var state_info: Label = $"State/StateInfo"
@onready var goal_info: Label = $"Goal/GoalInfo"
@onready var health_label: Label = $"Health/Health Label"
@onready var score_label: Label = $"Score/Score Label"

@onready var round_hearts: Control = $"RoundInfo/Hearts"
@onready var round_hearts_label: Label = $"RoundInfo/Hearts/Hearts"
@onready var round_atk: Control = $"RoundInfo/Atk"
@onready var round_atk_label: Label = $"RoundInfo/Atk/Atk"
@onready var round_dfs: Control = $"RoundInfo/Dfs"
@onready var round_dfs_label: Label = $"RoundInfo/Dfs/Dfs"
@onready var round_bonus: Label = $"Bonus"

@export var score: int = 0
@export var current_round: int = 0
@export var round_target_scores: Array[int] = [] 
var target_score = func(): return round_target_scores[current_round]

enum STATE { Attack, Defense }
var state: STATE = STATE.Attack

func _init():
	SignalBus.select_card.connect(select_card)	
	SignalBus.deselect_card.connect(deselect_card)	

func _ready():
	update_label()

func _process(_delta: float) -> void: # Update score display
	if int(score_label.text) < score:
		score_label.text = str(int(score_label.text)+1).pad_zeros(9)
	elif int(score_label.text) > score:
		score_label.text = str(int(score_label.text)-1).pad_zeros(9)

func select_card(card: Card): 
	print("select %s" % card.id) 
	selected_cards.append(card)
	update_label()

func deselect_card(card: Card): 
	print("deselect %s" % card.id) 
	var index = selected_cards.find_custom(func (x): return x.id == card.id)
	selected_cards.remove_at(index)
	update_label()

func update_label(): 
	var hand = calc_atk_dfs_values(selected_cards)
	var old_hand = calc_atk_dfs_values(last_played)
	if state == STATE.Attack: 
		round_dfs.visible = false
		round_hearts.visible = false
		round_atk_label.text = str(hand['atk'])
		round_bonus.text = ','.join(hand['bonuses'].map(func(b): return b.type + " (" + str(b.payout) + "x)"))
		goal_info.text = "Score %d more points to win" % (max(0, target_score.call() - score))
		state_info.text = "ATK"
	else: 
		round_dfs.visible = true
		round_hearts.visible = true 
		round_dfs_label.text = str(hand['dfs'])
		round_atk_label.text = str(old_hand['atk'])
		var diff = hand['dfs'] - old_hand['atk']
		round_hearts.visible = diff < 0
		round_hearts_label.text = str(diff)
		state_info.text = "DEF"
	health_label.text = str(health).pad_zeros(4)

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

	var bonuses = HandChecker.check_for_bonus(cards)
	for bonus in bonuses: 
		round_score = round_score * bonus.payout 

	return {
		'bonuses': bonuses,
		'score': round_score, 
		'atk': atk, 
		'dfs': dfs
	}

func next_round(): 
	if state == STATE.Attack: 
		var values = calc_atk_dfs_values(selected_cards)
		score += values['score']

		if score >= target_score.call(): 
			print("WON!")
			score = 0
			current_round += 1
			SignalBus.game_won.emit(current_round)
		else:
			last_played = selected_cards
			state = STATE.Defense

		goal_info.text = "Beat your own attack's " + str(values['atk']) + " points"
	else: 
		var hand = calc_atk_dfs_values(selected_cards)
		var old_hand = calc_atk_dfs_values(last_played)
		
		var diff = hand['dfs'] - old_hand['atk']
		if diff <= 0: 
			health += diff

		if health <= 0: 
			SignalBus.game_over.emit("( RAN OUT OF HEALTH )")
		
		state = STATE.Attack

	selected_cards = []
	update_label()
	SignalBus.next_round_started.emit(state)
