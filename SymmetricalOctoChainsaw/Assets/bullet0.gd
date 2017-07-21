extends RigidBody2D

export var BULLET_SPEED = 2500
export var take_player_speed = 3000
export var time_left = 3.0
export var damage = 1.0

var dangerous = true
var force = Vector2(0,0)
var source
var collision = false

func _ready():
	set_fixed_process(true)
	add_to_group("bullets")
	

func _fixed_process(delta):
	time_left -= delta
	if(time_left <= 0.0):
		dangerous = false
		queue_free()
	
	if(dangerous):
		set_linear_velocity(get_linear_velocity() + force)
		force = force.linear_interpolate(Vector2(0,0),delta*4)
		#if(get_colliding_bodies() != null):
			#for body in get_colliding_bodies():
				#if(body.has_method("damage")):
					#body.damage(source,damage)
				#queue_free()
		