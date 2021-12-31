extends CPUParticles2D

var index:int = 0

func _process(delta):
	index += 1
	if (index > 1000): queue_free()

func _on_Timer_timeout():
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
