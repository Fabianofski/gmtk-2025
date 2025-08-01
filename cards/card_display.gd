extends Node3D
class_name CardDisplay

var card: Card = null 
var selected: bool = false
var mouse_on_card: bool = false
signal update
@onready var front: Sprite3D = $front
@onready var card_number_display: Label3D = $"Card Number"

func _init():
	update.connect(update_card)
	SignalBus.next_round_started.connect(destroy_card)

func destroy_card(_state):
	if selected:
		queue_free()

func update_card(_card: Card): 
	card = _card
	front.texture = card.sprite
	# Show card number (a.k.a. score)
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

func _ready():
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

func _unhandled_input(event):
	var left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if not left_click or not mouse_on_card:
		return 

	selected = not selected
	if selected: 
		SignalBus.select_card.emit(card)
	else: 
		SignalBus.deselect_card.emit(card)

func _on_mouse_entered() -> void:
	mouse_on_card = true
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_POINTING_HAND)
	position.y = 0.2
	
func _on_mouse_exited() -> void:
	mouse_on_card = false
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_ARROW)
	if not selected: 
		position.y = 0
