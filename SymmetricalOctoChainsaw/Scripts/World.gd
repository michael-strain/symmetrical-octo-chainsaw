extends Node2D

#var enemy = preload ("res://Scenes/BlackAndPurple.tscn")
var players = []
var playerSize

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	players = get_tree().get_nodes_in_group("players")
	playerSize = players.size()
