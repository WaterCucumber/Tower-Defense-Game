extends Polygon2D
class_name CircleVisualizer

@export var shape : CollisionShape2D
@export var radius := 0.0
@export var segments: int = 32 # Number of segments to approximate the circle


func create_new_circle():
	polygon = [] # Clear Polygon

	var result_radius : float
	# Select Radius
	if not shape.shape:
		result_radius = radius
	elif shape.shape is not CircleShape2D: 
		result_radius = radius
		printerr("Can't visualize shape's range! Shape ", shape.shape ," is not CircleShape2D!")
	else:
		result_radius = shape.shape.radius

	var points := PackedVector2Array()
	# Generate Points
	for i in range(segments + 1):
		var angle = i * PI * 2 / segments
		var x = result_radius * cos(angle)
		var y = result_radius * sin(angle)
		points.append(Vector2(x, y))
	polygon = points # Set Points To Polygon
