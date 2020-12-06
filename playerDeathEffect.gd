extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "on_animation_finished")
	play("death")
	
func on_animation_finished():
	queue_free()
