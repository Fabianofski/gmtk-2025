extends Control 

@onready var label: Label = $"Label"
@onready var attack_sound: AudioStreamPlayer3D = $"AttackSound"
@onready var defense_sound: AudioStreamPlayer3D = $"DefenseSound"

var queue: Array[String] = []
var tween_playing = false

func _init():
	SignalBus.game_won.connect(func(x): show_text("Round %d" % (x + 1)))
	SignalBus.next_round_started.connect(round_started)
	SignalBus.show_text_popup.connect(show_text)

func _ready():
	show_text("Round 1")

func round_started(state: Game.STATE): 
	match(state): 
		Game.STATE.Attack: 
			show_text("Attack") 
			attack_sound.play()
		Game.STATE.Defense: 
			show_text("Defense") 
			defense_sound.play()

func show_text(msg: String): 
	if tween_playing: 
		queue.append(msg)
	else:
		tween_playing = true
		label.text = msg 
		scale = Vector2.ZERO
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector2.ONE, 0.5)
		hide_text()

func hide_text():
	await get_tree().create_timer(2).timeout
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)

	await tween.finished
	tween_playing = false
	if queue.size() > 0: 
		show_text(queue.pop_back())
