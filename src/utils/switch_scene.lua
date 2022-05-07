-- assumes global variable 'current_scene' as original scene
function switch_scene(new_scene)
	current_scene = new_scene
	cam = Camera(0, 0)
	current_scene:start()
end
