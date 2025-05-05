extends Control

const ENTER_TIME: float = 0.25
const EXIT_TIME: float = 0.5

var tween: Tween

var adventurer_names: Array[String] = [
	"Norjor Poplarblossom",
	"Dave Roberts",
	"Hiro Izeth",
]

var _selected_quest: QuestData = null

@onready var adventurer_textures: Array[Texture2D] = [
	ResourceLoader.load("res://sprites/characters/clericcut.png"),
	ResourceLoader.load("res://sprites/characters/druidcut.png"),
	ResourceLoader.load("res://sprites/characters/magecut.png"),
	ResourceLoader.load("res://sprites/characters/rangercut.png"),
]

@onready var quests: Array[QuestData] = [
	ResourceLoader.load("res://resources/quests/cursed_animal_calls_quest.tres"),
	ResourceLoader.load("res://resources/quests/dance_duel_quest.tres"),
	ResourceLoader.load("res://resources/quests/dave_needs_quest.tres"),
	ResourceLoader.load("res://resources/quests/hands_wanted_quest.tres"),
	ResourceLoader.load("res://resources/quests/mystery_hole_quest.tres"),
	ResourceLoader.load("res://resources/quests/pig_party_quest.tres"),
	ResourceLoader.load("res://resources/quests/rat_solution_quest.tres"),
]

func _ready() -> void:
	position = Vector2(size.x, 0)
	hide()

func _on_quest_selected(data: QuestData) -> void:
	_selected_quest = data

func _on_confirm_button_pressed() -> void:
	$"..".hide_quests()

func enter_view() -> void:
	generate_adventurer()
	
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.set_parallel(true)
	tween.tween_property(self, ^"position", Vector2.ZERO, ENTER_TIME)
	tween.tween_property(self, ^"modulate", Color.WHITE, ENTER_TIME)
	
	show()

func exit_view() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.set_parallel(true)
	tween.tween_property(self, ^"position", Vector2(size.x, 0), EXIT_TIME)
	tween.tween_property(self, ^"modulate", Color.TRANSPARENT, EXIT_TIME)
	
	tween.set_parallel(false)
	tween.tween_callback(hide)

func generate_adventurer() -> void:
	$Margin/Panel/HBox/VBox/Header/Text/Title.text = "[b]" + adventurer_names.pick_random() + "[/b] appears!"
	$Margin/Panel/HBox/QuestCharacter/TextureRect.texture = adventurer_textures.pick_random()
	quests.shuffle()
	$Margin/Panel/HBox/VBox/Cards/Card.data = quests[0]
	$Margin/Panel/HBox/VBox/Cards/Card2.data = quests[1]
	$Margin/Panel/HBox/VBox/Cards/Card3.data = quests[2]
