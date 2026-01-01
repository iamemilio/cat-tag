extends Node2D

var use_num: int = 0

func _ready() -> void:
	pass# Replace with function body.



func destroy_trap():
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Something touched me: ", body.name)
	if body.is_in_group("enemy"):
		destroy_trap()
	
