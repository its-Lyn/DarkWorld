extends Area2D

@export var dialogue_path = ""
var _river_in := false
var tbody

func _physics_process(delta):
	if _river_in and Input.is_action_just_pressed("Interact") and tbody != null:
		tbody.interact(dialogue_path)


func _on_body_entered(body):
	if body.name == "River":
		_river_in = true
		tbody = body


func _on_body_exited(body):
	if body.name == "River":
		_river_in = false
		tbody = null
