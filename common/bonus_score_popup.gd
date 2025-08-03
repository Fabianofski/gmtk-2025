extends Node3D

@onready var score_animation: Node3D = $Score
@onready var bonus_label: Label3D = $"Score/BonusLabel"
@onready var score_label: Label3D = $"Score/ScoreLabel" 

func _init():
	SignalBus.animate_bonus_score.connect(animate_bonus_score)

func animate_bonus_score(bonus: String, score: int, multiplier: int):
	print("animate bonus")
	score_label.text = "%dx%d" % [score, multiplier]
	bonus_label.text = bonus.to_upper()
	
	MusicHandler.play_scoring_sfx()
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(score_animation, "scale", Vector3.ONE, 0.1)

	await get_tree().create_timer(0.5).timeout
	score_label.text = "%d" % (score * multiplier) 
	tween = get_tree().create_tween()
	tween.tween_property(score_animation, "scale", Vector3(1.25, 1.25, 1.25), 0.25)
	await get_tree().create_timer(0.75).timeout
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(score_animation, "scale", Vector3.ZERO, 0.1)
