extends Resource
class_name CharacterInfo


# ------------------------ ENUMS ------------------------

enum CharacterType {NONE, CAT, CUCUMBER}

# ------------------------ CONSTS ------------------------

const NONE := CharacterType.NONE
const CAT := CharacterType.CAT
const CUCUMBER := CharacterType.CUCUMBER

# ------------------------ EXPORT ------------------------

@export var name: String = ""
@export var locked_name: String = "???"
@export var locked: bool = false
@export var body_sprite_frames: SpriteFrames = null
@export var paddle_sprite_frames: SpriteFrames = null

@export_group("Properties")
@export var speed: float = 300.0
@export var run_factor: float = 1.5
@export var court_size: float = 300.0

# ------------------------ STATIC ------------------------

static var cat_resource: CharacterInfo = load("res://common/resources/cat_resource.tres")
static var cucumber_resource: CharacterInfo = load("res://common/resources/cucumber_resource.tres")
static var current_resource: CharacterInfo = null
