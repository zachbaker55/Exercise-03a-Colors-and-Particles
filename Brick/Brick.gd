extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false

func _ready():
	position = new_position

func _physics_process(_delta):
	if dying:
		queue_free()

func hit():
	die()

func die():
	dying = true
	collision_layer = 0
	$ColorRect.hide()
	Global.update_score(score)
	get_parent().check_level()
