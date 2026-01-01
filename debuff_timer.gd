extends Label

@onready var player = get_tree().get_first_node_in_group("enemy")

func _ready():
	pass

func _process(_delta):
	if player:
		var timer = player.get_node("DebuffTimer")
		
		if not timer.is_stopped():
			text = "Slowed For: %0.1fs" % timer.time_left
			modulate = Color.RED # Change color when on cooldown
		else:
			text = "No Debuff!"
			modulate = Color.GREEN # Change color when ready
