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
@onready var atk_display: Label3D = $atk
@onready var atk_icon: Sprite3D = $atk_icon
@onready var dfs_display: Label3D = $dfs
@onready var dfs_icon: Sprite3D = $dfs_icon

var atk_mult: String = ""
var dfs_mult: String = ""

@onready var past_player_hand_parent: Node3D = get_node("../../PastPlayerHandCards")
@onready var player_hand_parent: Node3D = get_node("../../PlayerHandCards")

@onready var draw_sound: AudioStreamPlayer3D = $"DrawSound"

var base_pos: Vector3; 
var base_rot: Vector3; 

func _init():
	update.connect(update_card)
	tween_to_position.connect(set_base_pos)
	SignalBus.next_round_started.connect(next_round_started)

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
	# Generate the attack/defense multiplier display only if it's different than 1
	if card.attack_multiplier != 1:
		atk_mult = "x%d" % card.attack_multiplier
	else:
		atk_mult = ""
	if card.defense_multiplier != 1:
		dfs_mult = "x%d" % card.defense_multiplier
	else:
		dfs_mult = ""
	# Display attack and defense
	atk_display.text = str(_card.attack) + atk_mult
	dfs_display.text = str(_card.defense) + dfs_mult
	# Show card number (a.k.a. score)
	# NOTE: Having the percentage be included makes it look too busy, so simply show the multiplied number
	card_number_display.text = str(card.score*card.score_multiplier)
	match card_number_display.text:
		"11":
			card_number_display.text = "J"
		"12":
			card_number_display.text = "Q"
		"13":
			card_number_display.text = "K"
		"14":
			card_number_display.text = "A"
	# Change number colour depending on the suit
	if card.id.begins_with("heart") or card.id.begins_with("diamond"):
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

	selected = not selected
	outline.visible = selected
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
