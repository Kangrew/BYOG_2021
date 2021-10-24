extends Node2D
class_name AudioManager

onready var bgm : AudioStreamPlayer = $BGM;
onready var deathsfx : AudioStreamPlayer = $DeathSFX;
onready var finishfx : AudioStreamPlayer = $FinishSFX;
onready var keySfx : AudioStreamPlayer = $KeySFX;
onready var zoopfx : AudioStreamPlayer = $ZoopSFX;

func _ready():
	deathsfx.stop();
	finishfx.stop();
	pass 

func PlayDeathSFX():
	deathsfx.play();

func PlayGoalSFX():
	finishfx.play();

func PlayKeySFX():
	keySfx.play();
	
func PlayZoopSFX():
	zoopfx.play();

func StopBGM():
	bgm.stop();

func PlayBGM():
	bgm.play();
