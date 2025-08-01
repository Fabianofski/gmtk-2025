extends Node3D
class_name CardDisplay

var card: Card = null 
var selected: bool = false
var mouse_on_card: bool = false
signal update
signal tween_to_position(pos, rot, time)
@onready var front: Sprite3D = $front
@onready var card_number_display: Label3D = $"Card Number"
@onready var outline: Sprite3D = $outline 

func _init():
	update.connect(update_card)
	tween_to_position.connect(tween_to_new_position)
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

var tween
func tween_to_new_position(pos: Vector3, rot: Vector3, time: float): 
	if tween: 
		tween.kill()
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "position", pos, time)
	tween.tween_property(self, "rotation_degrees", rot, time)

func _unhandled_input(event):
	var left_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	if not left_click or not mouse_on_card:
		return 

	selected = not selected
	outline.visible = selected
	if selected: 
		SignalBus.select_card.emit(card)
	else: 
		SignalBus.deselect_card.emit(card)

func _on_mouse_entered() -> void:
	mouse_on_card = true
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_POINTING_HAND)
	tween_to_new_position(Vector3(position.x, 0.2, position.z), Vector3(-10,30,10), 0.2)
	
func _on_mouse_exited() -> void:
	mouse_on_card = false
	Input.set_default_cursor_shape(Input.CursorShape.CURSOR_ARROW)
	if not selected: 
		tween_to_new_position(Vector3(position.x, 0, position.z), Vector3.ZERO, 0.2)
