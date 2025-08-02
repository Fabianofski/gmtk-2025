extends Resource 
class_name Card

enum Suits { Diamond, Club, Spade, Heart }

@export var sprite: Texture2D = null
@export var id: String = ""
@export var suit: Suits = Suits.Diamond 
@export var score: int = 0
@export var attack: int = 0
@export var defense: int = 0
@export var score_multiplier: int = 1
@export var attack_multiplier: int = 1
@export var defense_multiplier: int = 1
