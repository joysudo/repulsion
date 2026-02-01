extends CanvasLayer

@onready var coin_label: Label = $Label

var coins_collected := 0
var total_coins := 0

func _ready():
	var coins = get_tree().get_nodes_in_group("coins")
	total_coins = coins.size()

	for coin in coins:
		coin.collected.connect(_on_coin_collected)

	update_coin_label()

func _on_coin_collected():
	coins_collected += 1
	update_coin_label()

func update_coin_label():
	coin_label.text = "Coins: %d / %d" % [coins_collected, total_coins]
