extends Node2D

const GRID_WIDTH := 40
const GRID_HEIGHT := 16
const CELL_SIZE := 16
const PATH_LENGTH := 100
const MIN_STRAIGHT_LENGTH = 2

const OFFSET := Vector2.ZERO#Vector2.UP * 8 + Vector2.LEFT * 13

@export var path_2d : Path2D

func _ready():
	# Генерируем путь клеток
	var path_cells = generate_path_with_min_straight(PATH_LENGTH, MIN_STRAIGHT_LENGTH)
	
	# Заполняем path точками пути в мировых координатах
	var curve = Curve2D.new()
	for cell in path_cells:
		var pos = cell * CELL_SIZE + Vector2(CELL_SIZE / 2.0, CELL_SIZE / 2.0) # центр клетки
		curve.add_point(pos + OFFSET * CELL_SIZE)
	path_2d.curve = curve


func generate_path_with_min_straight(length, min_straight_length):
	var path = []
	var visited = {}
	
	var current = Vector2(0, 0)
	path.append(current)
	visited[current] = true
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Возможные направления с приоритетом
	var main_dirs = [Vector2(1, 0), Vector2(0, 1)]  # вправо и вниз
	var side_dirs = [Vector2(-1, 0), Vector2(0, -1)]  # влево и вверх (редко)
	
	var current_dir = main_dirs[rng.randi_range(0, main_dirs.size() - 1)]
	var steps_in_dir = 0
	
	while path.size() < length:
		var next_cell = current + current_dir
		
		# Проверяем границы и посещённость
		if next_cell.x < 0 or next_cell.x >= GRID_WIDTH or next_cell.y < 0 or next_cell.y >= GRID_HEIGHT or visited.has(next_cell):
			# Если не можем идти дальше в текущем направлении — попробуем сменить направление
			var new_dir = choose_new_direction(current, visited, rng, main_dirs, side_dirs)
			if new_dir == null:
				break  # нет куда идти
			current_dir = new_dir
			steps_in_dir = 0
			continue
		
		path.append(next_cell)
		visited[next_cell] = true
		current = next_cell
		steps_in_dir += 1
		
		# Если прошли минимальное число шагов, с небольшой вероятностью меняем направление
		if steps_in_dir >= min_straight_length:
			if rng.randi_range(0, 2) == 0:  # 20% шанс сменить направление
				var new_dir = choose_new_direction(current, visited, rng, main_dirs, side_dirs)
				if new_dir != null and new_dir != current_dir:
					current_dir = new_dir
					steps_in_dir = 0
	
	return path


func choose_new_direction(current, visited, rng, main_dirs, side_dirs):
	var candidates = []
	
	# Добавляем основные направления, если можно туда пойти и не посещено
	for dir in main_dirs:
		var c = current + dir
		if c.x >= 0 and c.x < GRID_WIDTH and c.y >= 0 and c.y < GRID_HEIGHT and not visited.has(c):
			candidates.append(dir)
	
	# Редко добавляем боковые направления
	if rng.randi_range(0, 9) == 0:
		for dir in side_dirs:
			var c = current + dir
			if c.x >= 0 and c.x < GRID_WIDTH and c.y >= 0 and c.y < GRID_HEIGHT and not visited.has(c):
				candidates.append(dir)
	
	if candidates.is_empty():
		return null
	
	return candidates[rng.randi_range(0, candidates.size() - 1)]


func get_unvisited_neighbors(cell, visited):
	var neighbors = []
	var directions = [
		Vector2(1, 0),
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(0, -1)
	]
	for dir in directions:
		var neighbor = cell + dir
		if neighbor.x >= 0 and neighbor.x < GRID_WIDTH and neighbor.y >= 0 and neighbor.y < GRID_HEIGHT:
			if not visited.has(neighbor):
				neighbors.append(neighbor)
	return neighbors
