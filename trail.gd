extends Line2D
class_name Trails
 
var queue : Array
@export var MAX_LENGTH : int
 
func _process(_delta):
	var pos = get_global_mouse_position()
 
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
 
	clear_points()
 
 
	for point in queue:
		add_point(point)
 
func _get_position():
	return get_global_mouse_position()
