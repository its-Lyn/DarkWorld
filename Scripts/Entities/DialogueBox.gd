extends TextureRect


@onready var ndialogue := $Dialogue
@onready var text_timer := $TextTimer


var path: String = ""
var dialogue_finished: bool = false
var line_num: int = 0;
var text_speed = 0.005
var dialogue_started = false
var dialogues: Array = []


func _input(event):
	if event.is_action_pressed("Dialogue"):
		if !dialogue_finished:
			ndialogue.visible_characters = len(ndialogue.text)
		else:
			handle_dialogue()


func begin_dialogue_sequence(dpath: String) -> void:
	if not visible:
		visible = true

	path = dpath
	text_timer.wait_time = text_speed
	dialogues = fetch_dialogues()
	
	get_tree().paused = true
	
	if not dialogue_started:
		handle_dialogue()
		
	dialogue_started = true


func handle_dialogue() -> void:
	if line_num >= len(dialogues):
		visible = false
		
		line_num = 0
		dialogue_finished = false
		dialogue_started = false
		get_tree().paused = false
		return
	
	dialogue_finished = false
	
	$Name.bbcode_text = dialogues[line_num]["Name"]
	ndialogue.bbcode_text = dialogues[line_num]["Dialogue"]

	ndialogue.visible_characters = 0
	
	while ndialogue.visible_characters <= len(ndialogue.text):
		ndialogue.visible_characters += 1
		
		text_timer.start()
		await text_timer.timeout
		
	dialogue_finished = true
	line_num += 1
	text_timer.stop()
	
	return


func fetch_dialogues() -> Array:
	assert(FileAccess.file_exists(path), "File does not exist mate")
	
	var file = FileAccess.open(path, FileAccess.READ)
	
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	assert(error == OK, "JSON Parse Error: %s at line %d" % [json.get_error_message(), json.get_error_line()])
	
	# Make sure the data we get from our JSON file is an array
	# assert checks if the given expression is false
	var data_recieved = json.data
	assert(typeof(data_recieved["Dialogues"]) == TYPE_ARRAY, "Unexpected dialogue recieved...")
	
	file.close()
	
	return data_recieved["Dialogues"]
