extends Area2D

@export var dialogue_path = ""
var _river_in := false
var river_body

func _physics_process(delta):
	if _river_in and Input.is_action_just_pressed("Interact") and river_body != null:
		river_body.interact(dialogue_path)


func _on_body_entered(body):
	if body.name == "River":
		_river_in = true
		river_body = body


func _on_body_exited(body):
	if body.name == "River":
		_river_in = false
		river_body = null
