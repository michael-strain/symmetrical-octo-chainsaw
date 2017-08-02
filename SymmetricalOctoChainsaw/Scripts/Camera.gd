extends Camera2D
var players = []
var playersize
var cameraPos

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	players = get_parent().players
	playersize = get_parent().playerSize
	
	var playerPosAvg = Vector2(0,0)
	for playersize in players:
		playerPosAvg = playerPosAvg + playersize.get_global_pos()
	
	var playersizedivided
	if (playersize==4):
		playersizedivided=0.25
	elif (playersize==3):
		playersizedivided = 1/3
	elif (playersize==2):
		playersizedivided=0.5
	else:
		playersizedivided=1
	
	cameraPos = playerPosAvg*playersizedivided
	set_global_pos(cameraPos)
	
	#var newpos = (p1.get_global_pos()+p2.get_global_pos())*0.5
    #set_global_pos(newpos)
    #then comes the zoom
	
	
func get_closest_node2d(array_of_node2ds, enemyLocation):
	var min_node = null
	var min_distance_squared = 99999999999999999
	for kinematicbody2d in array_of_node2ds:
		var distance_squared = enemyLocation.distance_squared_to(kinematicbody2d.get_pos())
		if distance_squared < min_distance_squared:
			min_distance_squared = distance_squared
			min_node = kinematicbody2d
	return min_node