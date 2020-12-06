extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "on_animation_finished")
	play("die")
	
func on_animation_finished():
	queue_free()
