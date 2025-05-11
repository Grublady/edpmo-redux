extends Control

signal game_lost

const ENTER_TIME: float = 0.25
const EXIT_TIME: float = 0.5

var tween: Tween

var adventurer_names: Array[String] = [
	"Norjor Poplarblossom",
	"Dave Roberts",
	"Hiro Izeth",
]

var _selected_quest: QuestData = null

@onready var title_text: RichTextLabel = $Margin/Panel/VBox/HBox/VBox/Header/Text/Title
@onready var quest_character_texture: TextureRect = $Margin/Panel/VBox/HBox/QuestCharacter/TextureRect

@onready var cards: Array[TextureRect] = [
	$Margin/Panel/VBox/HBox/VBox/Cards/Card,
	$Margin/Panel/VBox/HBox/VBox/Cards/Card2,
	$Margin/Panel/VBox/HBox/VBox/Cards/Card3,
]

@onready var stat_meters: Dictionary[StringName, Node] = {
	&"rations": $Margin/Panel/VBox/Footer/StatMeter,
	&"peace": $Margin/Panel/VBox/Footer/StatMeter2,
	&"money": $Margin/Panel/VBox/Footer/StatMeter3,
	&"joy": $Margin/Panel/VBox/Footer/StatMeter4,
}

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

func _init() -> void:
	EventBus.game_focus.connect(_on_event_game_focus)

func _on_event_game_focus(event: EventBus.GameFocus) -> void:
	match event:
		EventBus.GameFocus.game_board:
			exit_view()
		EventBus.GameFocus.quests:
			enter_view()

func _ready() -> void:
	position = Vector2(size.x, 0)
	hide()

func _on_quest_selected(data: QuestData) -> void:
	_selected_quest = data

func _on_confirm_button_pressed() -> void:
	stat_meters[&"rations"].value += (_selected_quest.rations / 100)
	stat_meters[&"peace"].value += (_selected_quest.peace / 100)
	stat_meters[&"money"].value += (_selected_quest.money / 100)
	stat_meters[&"joy"].value += (_selected_quest.joy / 100)
	for meter in stat_meters.values():
		if meter.value <= 0:
			game_lost.emit.call_deferred()
			break
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
	title_text.text = "[b]" + adventurer_names.pick_random() + "[/b] appears!"
	quest_character_texture.texture = adventurer_textures.pick_random()
	quests.shuffle()
	for i in cards.size():
		cards[i].data = quests[i]
