extends Node2D

var player_words = [] # the words the player chooses
var current_story = {}
var test = { "OK" : "its okay",
			"No": "its still ok"}
var strings # all the text that is displayed to the player

func _ready():
	set_random_story()
	strings = get_from_json("other_strings.json")
	$BlackBoard/StoryText.text = strings ["intro_text"]
	prompt_player()
	$BlackBoard/TextBox.clear()
	print(test["No"])

func set_random_story ():
	var stories = get_from_json("stories.json")
	randomize();
	current_story = stories [randi() % stories.size()]
	
func get_from_json (filename):
	var file = File.new() # the file object
	file.open(filename, File.READ) # TODO assuming the file exist, must error check
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data
	
func _on_TextureButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		var new_text = $BlackBoard/TextBox.get_text()
		_on_TextBox_text_entered(new_text)

func _on_TextBox_text_entered(new_text):
	player_words.append(new_text)
	$BlackBoard/TextBox.clear()
	$BlackBoard/StoryText.clear()
	check_player_word_length()
	
func is_story_done ():
	return player_words.size() == current_story.prompt.size()
	
func prompt_player ():
	var next_prompt = current_story["prompt"][player_words.size()]
	$BlackBoard/StoryText.text += (strings["prompt"] % next_prompt)
	
func check_player_word_length ():
	if is_story_done():
		$BlackBoard/TextureButton/ButtonLabel.text = strings["again"]
		tell_story()
	else:
		prompt_player()

func tell_story ():
	$BlackBoard/StoryText.text = current_story.story % player_words
	end_game()
	
func end_game ():
	$BlackBoard/TextBox.queue_free()