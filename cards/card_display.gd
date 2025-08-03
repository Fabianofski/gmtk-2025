extends Node3D
class_name CardDisplay

var card: Card = null 
var selected: bool = false
var card_used: bool = false
var mouse_on_card: bool = false
signal update
signal tween_to_position(pos, rot, time)
@onready var front: Sprite3D = $front
@onready var background: Sprite3D = $card_bg
@onready var outline: Sprite3D = $outline 

@export var standard_bg: Texture2D; 
@export var silver_bg: Texture2D; 
@export var gold_bg: Texture2D; 
@export var crystal_bg: Texture2D; 

@onready var card_number_display: Label3D = $"Card Number"
@onready var atk_def_holder: Node3D = $ATK_DEF
@onready var atk_display: Label3D = $"ATK_DEF/atk"
@onready var atk_icon: Sprite3D = $"ATK_DEF/atk_icon"
@onready var dfs_display: Label3D = $"ATK_DEF/dfs"
@onready var dfs_icon: Sprite3D = $"ATK_DEF/dfs_icon"
@export var score_texture: Texture2D; 

@onready var special_holder: Node3D = $Special
@onready var special_display: Node3D = $"Special/sp"

@onready var score_animation: Node3D = $"Score"
@onready var score_animation_label: Label3D = $"Score/ScoreLabel"

@onready var unlocked: Label3D = $Unlocked

@onready var past_player_hand_parent: Node3D = get_node("../../PastPlayerHandCards")
@onready var player_hand_parent: Node3D = get_node("../../PlayerHandCards")

@onready var draw_sound: AudioStreamPlayer3D = $"DrawSound"

var base_pos: Vector3; 
var base_rot: Vector3; 

func _init():
	update.connect(update_card)
	tween_to_position.connect(set_base_pos)
	SignalBus.next_round_started.connect(next_round_started)
	SignalBus.animate_card_score.connect(animate_card_score)

func animate_card_score(id: String, score: int, addition: int): 
	if id != card.id or not selected: 
		return
	var type = "x" if card.type == Card.CardType.Multiplier else "+"
	score_animation_label.text = "%d %s %d" % [score, type, addition]
	
	MusicHandler.play_scoring_sfx()
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(score_animation, "scale", Vector3.ONE, 0.1)

	await get_tree().create_timer(0.25).timeout
	var final_score = score * addition if card.type == Card.CardType.Multiplier else score + addition
	score_animation_label.text = "%d" % final_score 
	tween = get_tree().create_tween()
	tween.tween_property(score_animation, "scale", Vector3(1.25, 1.25, 1.25), 0.1)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(score_animation, "scale", Vector3.ZERO, 0.25)

func next_round_started(state):
	if selected and state == Game.STATE.Attack:
		# SignalBus.put_card_back_to_deck.emit(card)
		# dont put cards back to deck like in Durak
		queue_free()

	if selected and state == Game.STATE.Defense:
		card_used = true
		self.reparent(past_player_hand_parent)

func update_card(_card: Card): 
	card = _card
	front.texture = card.sprite
	unlocked.visible = false
	card_number_display.text = str(card.score)
	match card_number_display.text:
		"11":
			card_number_display.text = "J"
		"12":
			card_number_display.text = "Q"
		"13":
			card_number_display.text = "K"
		"14":
			card_number_display.text = "A"

	if card.suit == Card.Suits.Diamond or card.suit == Card.Suits.Heart:
		card_number_display.modulate = Color("#E64539")
	else:
		card_number_display.modulate = Color("BLACK")

	match card.rarity: 
		Card.Rarity.Standard: 
			background.texture = standard_bg
		Card.Rarity.Silver: 
			background.texture = silver_bg
		Card.Rarity.Gold: 
			background.texture = gold_bg 
		Card.Rarity.Crystal: 
			background.texture = crystal_bg

	match card.type: 
		Card.CardType.Standard: 
			atk_display.text = str(card.attack)
			dfs_display.text = str(card.defense)
			atk_def_holder.visible = true
			special_holder.visible = false
		Card.CardType.Multiplier:
			if card.attack_multiplier != 1: 
				atk_display.text = "%dx" % card.attack_multiplier
			else:
				atk_display.text = "%dx" % card.score_multiplier
				atk_icon.texture = score_texture
			if card.defense_multiplier != 1: 
				dfs_display.text = "%dx" % card.defense_multiplier
			else:
				dfs_display.text = "%dx" % card.score_multiplier
				dfs_icon.texture = score_texture
			atk_def_holder.visible = true
			special_holder.visible = false
			if card.explanation != "": # Should the "explanation" field not be empty...
				special_display.text = card.explanation
				atk_def_holder.visible = false
				special_holder.visible = true
		Card.CardType.Signal: 
			special_display.text = card.explanation
			atk_def_holder.visible = false
			special_holder.visible = true


func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func set_base_pos(pos: Vector3, rot: Vector3, time: float): 
	base_rot = rot; 
	base_pos = pos; 
	tween_to_new_position(pos, rot, time)

func tween_to_new_position(pos: Vector3, rot: Vector3, time: float): 
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "position", pos, time)
	tween.tween_property(self, "rotation_degrees", rot, time)

	if not draw_sound.playing:
		draw_sound.pitch_scale = randf_range(.8, 1)
		draw_sound.play()

func _unhandled_input(event):
	var left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if card_used or not left_click or not mouse_on_card:
		return 

	if not selected and SignalBus.selected_cards >= 4:
		return
	selected = not selected
	outline.visible = selected
	
	if not draw_sound.playing:
		draw_sound.pitch_scale = randf_range(.8, 1)
		draw_sound.play()
	
	if selected: 
		SignalBus.select_card.emit(card)
	else: 
		SignalBus.deselect_card.emit(card)

func _on_mouse_entered() -> void:
	if card_used:
		return
	mouse_on_card = true
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_POINTING_HAND)
	tween_to_new_position(Vector3(base_pos.x, 0.2, 0.2), Vector3(-15, 0, 0), 0.2)
	
func _on_mouse_exited() -> void:
	if card_used: 
		return
	mouse_on_card = false
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_ARROW)
	if not selected: 
		tween_to_new_position(Vector3(base_pos.x, 0, base_pos.z), base_rot, 0.2)

func make_unlock_text_visible():
	card_used = true
	unlocked.visible = true # simple as
