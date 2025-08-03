extends Control

@onready var tutorial_text: Label = $"Tutorial Panel/Tutorial Text"

@onready var back_button: Button = $"Tutorial Panel/Back Button"
@onready var next_button: Button = $"Tutorial Panel/Next Button"

var current_displayed_string : int = 1

# ALERT: Hardcoded strings!!!
const STRING_ARRAY : Array = ["OK!",

"Are you familiar with asymmetrical card games involving time travel?",

"In this game, the attacker will draw up to six cards, and then score points based on the number on the card.
Then, the defender will draw up to six cards, and try to defend against their attack.

The goal is for the attacker to reach the high score, and the defender to not lose all their health.",

"However, this is no ordinary card game. Because your opponent... is YOURSELF!

A time machine malfunction has resulted in you being forced to play against yourself on a loop, as both the attacker AND the defender.",

"Play as many attack cards as you want to rack up a combo, then travel TO THE FUTURE and defend yourself from your own attack!
Then, go BACK TO THE PAST, and set up a new attack!

Reach the score win condition before shedding all your cards, or else the timestream will dissipate FOREVER.",

"And with that, that's the end of this tutorial!",

"P.S.: If you're ever confused on what to do, look at the ticker at the top of the screen!",

""]

func _ready():
	if SignalBus.tutorial_shown: 
		self.visible = false
	else: 
		SignalBus.tutorial_shown = true

func _process(_delta: float) -> void:
	tutorial_text.text = STRING_ARRAY[current_displayed_string] # Set text to the correct label
	
	# Button labels
	# ALERT: Hardcoded strings!!!
	match current_displayed_string:
		1:
			back_button.text = "Oh yeah."
			next_button.text = "Huh???"
		2:
			back_button.text = "Back"
			next_button.text = "Next"
		4: # Yes, I know...
			back_button.text = "Back"
			next_button.text = "Next"
		5:
			next_button.text = "Okay."
		6:
			next_button.text = "OKAY!!!"
	
	if current_displayed_string == 0 or current_displayed_string == 7:
		self.queue_free() # Delete the whole dang tutorial node

# Button zone
func _on_back_button_pressed() -> void:
	current_displayed_string -= 1

func _on_next_button_pressed() -> void:
	current_displayed_string += 1
