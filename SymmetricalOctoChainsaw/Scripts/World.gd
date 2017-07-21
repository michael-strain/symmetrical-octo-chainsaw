extends Node2D

var enemy = preload ("res://Scenes/BlackAndPurple.tscn")
var challenge = 1
var difficulty
var num_of_players

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	#num_of_players = get_tree().get_nodes_in_group("numofplayers")
	num_of_players = 1
	#Challenge:
	difficulty = "easy"
	if (difficulty == "easy"):
		challenge=(challenge*1)*num_of_players
	if (difficulty == "normal"):
		challenge=challenge*1.5*num_of_players
	if (difficulty == "hard"):
		challenge=(challenge*2)*num_of_players
