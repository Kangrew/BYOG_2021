extends Area2D
class_name Lock

onready var lockSprite = $Sprite;
onready var tween   = $Tween;
onready var collisionShape : CollisionShape2D = $CollisionShape2D;

export var islocked : bool = true;
export var anim_duration : float = 0.5;
export var lockColor : Color = Color.white;
export var unlockColor : Color = Color.white;


func _ready():
	if(islocked):
		lock();
	elif(!islocked):
		unlock();

func unlock():
	islocked = false;
	collisionShape.set_deferred("disabled", true);
	switchColor(lockColor, unlockColor, anim_duration);
	pass

func lock():
	islocked = true;
	collisionShape.set_deferred("disabled", false);
	switchColor(unlockColor,lockColor,anim_duration);
	pass

func switchColor(aColor, bColor, seconds):
	tween.interpolate_property(lockSprite, "self_modulate",aColor, bColor, seconds, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
	tween.start()
	pass

func toggle():
	if(!islocked):
		lock();
	elif(islocked):
		unlock();

func _on_Lock_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.is_in_group("Player") and islocked:
		var player : Player = area.get_parent();
		player.die();
		pass
	pass # Replace with function body.
