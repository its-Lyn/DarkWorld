extends CharacterBody2D

@onready
var anim_tree := $Sprites
var speed := 250.0
var last_input = "Down"


func interact(dialogue_path: String):
	$TextboxLayer/Dialogue/DialogueBox.begin_dialogue_sequence(dialogue_path)


func _handle_animations():
	if Input.is_action_pressed("Down"):
		last_input = "Down"
		anim_tree.play("Walk_Front")
	elif Input.is_action_pressed("Up"):
		last_input = "Up"
		anim_tree.play("Walk_Back")
	elif Input.is_action_pressed("Right"):
		last_input = "Right"
		anim_tree.play("Walk_Right")
	elif Input.is_action_pressed("Left"):
		last_input = "Left"
		anim_tree.play("Walk_Left")
	else:
		match last_input:
			"Down":
				anim_tree.play("Idle_Down")
			"Up":
				anim_tree.play("Idle_Up")
			"Right":
				anim_tree.play("Idle_Right")
			"Left":
				anim_tree.play("Idle_Left")


func _handle_dialogue_area():
	for area in $DialogueInteract.get_overlapping_areas():
		print("C: ", area.name)


func _ready():
	anim_tree.play("Idle_Down")


func _physics_process(delta):
	_handle_animations()
	
	var input_direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed
	
	
	move_and_slide()
