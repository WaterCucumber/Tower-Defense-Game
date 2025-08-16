extends JsonResource
class_name DataRes

@export var name := "Player"
@export var health := 100
@export var speed := 5.0
@export var minions : Array[Minion] = []
@export var other_data := "Data"

var internal_data := false

func load_from_dict(dict: Dictionary) -> void:
	name = dict.get("name", "Player")
	health = dict.get("health", 100)
	speed = dict.get("speed", 5.0)
	
	# Загружаем массив миньонов
	if dict.has("minions"):
		minions.clear()  # Очищаем текущий массив
		for minion_data in dict["minions"]:
			var minion = Minion.new()  # Замените на путь к вашему ресурсу Minion
			minion.load_from_dict(minion_data)  # Загружаем данные в миньона
			minions.append(minion)

	# Загружаем другие параметры
	other_data = dict.get("other_data", "Yea")
