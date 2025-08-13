extends Control

@onready var tutorial_panel: NinePatchRect = $"Tutorial Panel"
@onready var tutorial_text: Label = $"Tutorial Panel/Tutorial Text"

@onready var back_button: Button = $"Tutorial Panel/Back Button"
@onready var next_button: Button = $"Tutorial Panel/Next Button"

@onready var mouse_input_blocker: ColorRect = $"Mouse Input Blocker"

@export var forced_cards: Array[Card]
# SignalBus.force_card_draw.emit(forced_cards)
# set the cards in the inspector and then call this SignalBus Signal where you need it :)

var line_to_display: int = 0

# Centre, bottom right, top left, top right, top
var positions: Array = [Vector2(422, 277), Vector2(815, 450), Vector2(28, 100), Vector2(815, 100), Vector2(422, 112)]

func _ready() -> void:
	if SignalBus.tutorial_shown == true:
		self.queue_free()
	SignalBus.next_round_started.connect(_should_be_shown)
	_refresh_text()

func _on_back_button_pressed() -> void:
	if line_to_display != 23: # "Please repeat" should make the tutorial repeat itself from earlier
		line_to_display -= 1
	else:
		line_to_display = 20 # "So, to recap..."
	_refresh_text()

func _on_next_button_pressed() -> void:
	line_to_display += 1
	_refresh_text()

func _should_be_shown(state) -> void:
	if str(state) == "HIDE":
		self.visible = false
		mouse_input_blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		self.visible = true
		mouse_input_blocker.mouse_filter = Control.MOUSE_FILTER_STOP

func _refresh_text() -> void:
	if line_to_display == -1 or line_to_display == 26: # Clean house if no more text
		SignalBus.tutorial_shown = true
		SignalBus.has_set_custom_seed = false
		self.queue_free()
	tutorial_text.text = tr("tutorial_str_%d" % line_to_display) # Set text
	match line_to_display: # Change buttons (NOTE: Yes the duplicates are ugly)
		0:
			back_button.text = tr("tutorial_btn_0_intro")
			next_button.text = tr("tutorial_btn_1_intro")
		1:
			back_button.text = tr("tutorial_btn_0_default")
			next_button.text = tr("tutorial_btn_1_default")
		20:
			back_button.text = tr("tutorial_btn_0_default")
			next_button.text = tr("tutorial_btn_1_default")
		23:
			back_button.text = tr("tutorial_btn_0_end")
			next_button.text = tr("tutorial_btn_1_end")
		24:
			back_button.text = tr("tutorial_btn_0_default")
			next_button.text = tr("tutorial_btn_1_default")
	_move_to_new_pos()

# ALERT: Ugly-yet-functional code zone.
func _move_to_new_pos():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	match line_to_display:
		0:
			tween.tween_property(tutorial_panel, "position", positions[0], 0.25)
		1:
			back_button.disabled = true # Disable the back button for shenanigan prevention
			back_button.visible = false
		5:
			tween.tween_property(tutorial_panel, "position", positions[1], 0.25)
		6:
			_should_be_shown("HIDE") # Hide tutorial to allow the player to... play
			tween.tween_property(tutorial_panel, "position", positions[0], 0.25)
		7:
			tween.tween_property(tutorial_panel, "position", positions[2], 0.25)
		9:
			tween.tween_property(tutorial_panel, "position", positions[0], 0.25)
		13:
			tween.tween_property(tutorial_panel, "position", positions[4], 0.25)
		14:
			_should_be_shown("HIDE")
			tween.tween_property(tutorial_panel, "position", positions[0], 0.25)
		15:
			tween.tween_property(tutorial_panel, "position", positions[3], 0.25)
		16:
			tween.tween_property(tutorial_panel, "position", positions[1], 0.25)
		19:
			tween.tween_property(tutorial_panel, "position", positions[0], 0.25)
		20:
			back_button.disabled = true
			back_button.visible = false
		23:
			back_button.disabled = false # Re-enable the back button
			back_button.visible = true
		24:
			back_button.disabled = true
			back_button.visible = false
			tween.tween_property(tutorial_panel, "position", positions[4], 0.25)
