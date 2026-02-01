extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var coins = get_tree().get_nodes_in_group("coin")
	#var numcoins = get_parent().get_children()
	$NumCoinsCollected.text = "0/" + str(coins.size())
	# loop thru children to count number of coins in scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func when receive signal from coin idk do stiff
