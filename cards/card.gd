extends Resource 
class_name Card

enum Suits { Diamond, Club, Spade, Heart }
enum Rarity { Standard, Silver, Gold, Crystal }
enum CardType { Standard, Multiplier, Signal }

@export_category("Common")
@export var sprite: Texture2D = null
@export var id: String = ""
@export var suit: Suits = Suits.Diamond 
@export var rarity: Rarity = Rarity.Standard
@export var type: CardType = CardType.Standard
@export var score: int = 0
@export var round_unlock = 0

@export_category("Standard")
@export var attack: int = 0
@export var defense: int = 0

@export_category("Multiplier")
@export var score_multiplier: int = 1
@export var attack_multiplier: int = 1
@export var defense_multiplier: int = 1

@export_category("Signal")
@export var signal_name: String = ""
@export var signal_value: String = ""
@export var explanation: String = ""
