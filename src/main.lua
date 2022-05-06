Class = require 'libraries/classic/classic'
Timer = require 'libraries/hump/timer'
Json = require 'libraries/json_lua/json'
require 'file_loader'
debug_mode = true

function love.load()
	math.randomseed(os.time())

	-- initialise graphics
	love.graphics.setDefaultFilter("nearest")
	love.graphics.setLineStyle("rough")
	main_canvas = love.graphics.newCanvas(gw, gh)
	resize(8)

	-- require dependencies
	local file_loader = File_Loader()
	-- files with priority due to dependencies
	file_loader:load_files({"objects/game_object.lua",
		"objects/physics/collider.lua",
		"objects/groups/group.lua",
		"objects/level/tile.lua",
		"src/objects/scenes/scene.lua",
		"objects/physics/physics_collider.lua"})
	file_loader:load_folder("objects")
	file_loader:load_folder("utils")
	file_loader:require()

	for i, c in ipairs(pal) do
		for j, value in ipairs(pal[i]) do
			pal[i][j] = value / 255
		end
	end

	sheet = Spritesheet("assets/visuals/spritesheet.png", 8)

	-- get level data
	level_parser = Level_Parser("assets/levels/levels.ldtk")
	
	current_scene = Level_Scene()
	
	timer = Timer()
	input = Input()
	input:bind('move_left', {'a', 'left'})
	input:bind('move_right', {'d', 'right'})
	input:bind('jump', {'space', 'z'})

	debug = Debug()

	cam = Camera(0, 0)

	love.graphics.setBackgroundColor(pal[1])

	current_scene:start()
end

function love.update(dt)
	dt = dt * 1
	if input:key_just_pressed("r") then
		current_scene:reset()
	end
	timer:update(dt)
	current_scene:update(dt)
	cam:update(dt)

	input:update()
end

function love.draw()
	love.graphics.setCanvas(main_canvas)
    love.graphics.clear()
	cam:focus()
	current_scene:draw()

	cam:unfocus()
	love.graphics.setCanvas()
	
	love.graphics.draw(main_canvas, 0, 0, 0, sx, sy)

	debug:draw()
end

function love.keypressed(key)
	input:on_key_down(key)
end

function love.keyreleased(key)
	input:on_key_up(key)
end

function resize(s)
    love.window.setMode(s*gw, s*gh) 
    sx, sy = s, s
end
