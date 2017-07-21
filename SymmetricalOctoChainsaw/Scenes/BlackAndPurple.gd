extends Area2D

var path = []
var players = []
var closestPos = Vector2(0,0)
var enemyPos = Vector2(0,0)

export var points = 1
export var MOVEMENT_SPEED = 2400
export var ROTATION_SPEED = 1000
export var MAX_HEALTH = 2
var health
var motion = Vector2(0,0)
var angle = 0.0
var killed_by

func _ready():
	MOVEMENT_SPEED = MOVEMENT_SPEED*get_parent().get_parent().challenge
	print (MOVEMENT_SPEED)
	#MAX_HEALTH = MAX_HEALTH*get_parent().get_parent().challenge
	set_fixed_process(true)
	add_to_group("enemies")
	health = MAX_HEALTH
	connect("body_enter",self,"_on_Area2D_body_enter")

func _fixed_process(delta):
	enemyPos = get_pos()
	players = get_tree().get_nodes_in_group("players")
	if (players.size()>0):
		var closest_node2d = get_closest_node2d(players, enemyPos)
		angle = self.get_pos().angle_to_point(closest_node2d.get_global_pos())+deg2rad(0)
		var t_dir= Vector2(0,1).rotated(angle)
		var c_dir = Vector2(0,1).rotated(get_rot())
		c_dir = c_dir.linear_interpolate(t_dir, min(ROTATION_SPEED*delta,1))
		set_rot(atan2(c_dir.x,c_dir.y))
		motion = Vector2(0,-10).rotated(angle)
		motion=motion.normalized()
		set_pos(get_pos() + motion * MOVEMENT_SPEED * delta)
	else:
		queue_free()
	
func _on_Area2D_body_enter(body):
	if(body.is_in_group("bullets")):
		health = health - 1
		var sampler = get_node("SamplePlayer")
		var voiceID = sampler.play("Boom")
		sampler.set_volume(voiceID, 1)
		if (health<=0):
			queue_free()
	if(body.is_in_group("players")):
		body.health = body.health - 1
		var sampler = get_node("SamplePlayer")
		var voiceID = sampler.play("Agh")
		sampler.set_volume(voiceID, 1.25)
		#queue_free()
	
func get_closest_node2d(array_of_node2ds, enemyLocation):
	var min_node = null
	var min_distance_squared = 99999999999999999
	for kinematicbody2d in array_of_node2ds:
		var distance_squared = enemyLocation.distance_squared_to(kinematicbody2d.get_pos())
		if distance_squared < min_distance_squared:
			min_distance_squared = distance_squared
			min_node = kinematicbody2d
	return min_node
	