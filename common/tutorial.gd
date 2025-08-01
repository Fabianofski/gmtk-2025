extends Control

@onready var tutorial_text: Label = $"Tutorial Panel/Tutorial Text"

@onready var back_button: Button = $"Tutorial Panel/Back Button"
@onready var next_button: Button = $"Tutorial Panel/Next Button"

var current_displayed_string : int = 1

# ALERT: Hardcoded strings!!!
const STRING_ARRAY : Array = ["OK!",

"Are you familiar with Durak?",

"Durak is a card game popular in Russia and other post-Soviet states.
The goal is to get rid of all cards in the deck.",

"In Durak, you always have six cards in your hand.
Ordinarily, there are two distinct roles: ATTACKERS and DEFENDERS. [Attackers do this, defenders do that, PLACEHOLDER, PLEASE REPLACE WITH A SHORT EXPLANATION]",
"However, this is no ordinary game of Durak. Because your opponent today... is YOU, FROM THE PAST.",

"You read that right!
A time machine malfunction has resulted in you being forced to play Durak against yourself on a loop, as both the attacker AND the defender.",

"Play as many attack cards as you want to rack up a combo, then travel TO THE FUTURE and defend yourself from your own attack!
Then, go BACK TO THE PAST, and set up a new attack!",

"Reach the score win condition before shedding all your cards, or else the timestream will dissipate FOREVER.",

"Fun facts about Durak:
1. \"Durak\" means \"fool\" in Russian.
2. It is not considered \"traditional\" to play against time-displaced versions of yourself.
3. The most important rule of Durak is to have fun :)",

"And with that, that's the end of this tutorial!",

"P.S.: If you're ever confused on what to do, look at the ticker at the top of the screen!",

""]

func _process(delta: float) -> void:
	tutorial_text.text = STRING_ARRAY[current_displayed_string] # Set text to the correct label
	
	# Button labels
	# ALERT: Hardcoded strings!!!
	match current_displayed_string:
		1:
			back_button.text = "Oh yeah."
			next_button.text = "Du.. what?"
		2:
			back_button.text = "Back"
			next_button.text = "Next"
		8: # Yes, I know...
			back_button.text = "Back"
			next_button.text = "Next"
		9:
			next_button.text = "Okay."
		10:
			next_button.text = "OKAY!!!"
	
	if current_displayed_string == 0 or current_displayed_string == 11:
		self.queue_free() # Delete the whole dang tutorial node

# Button zone
func _on_back_button_pressed() -> void:
	current_displayed_string -= 1

func _on_next_button_pressed() -> void:
	current_displayed_string += 1
