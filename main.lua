Class = require 'libraries/classic/classic'
Timer = require 'libraries/hump/timer'
Json = require 'libraries/json_lua/json'
require 'file_loader'

function love.load()
	math.randomseed(os.time())

	-- initialise graphics
	love.graphics.setDefaultFilter("nearest")
	love.graphics.setLineStyle("rough")
	main_canvas = love.graphics.newCanvas(gw, gh)
	resize(6)

	-- require dependencies
	local file_loader = File_Loader()
	-- files with priority due to dependencies
	file_loader:load_files({"objects/game_object.lua",
		"objects/physics/collider.lua",
		"objects/physics/physics_collider.lua"})
	file_loader:load_folder("objects")
	file_loader:load_folder("utils")
	file_loader:require()

	sheet = Spritesheet("assets/visuals/spritesheet.png", 8)

	-- get level data
	level_parser = Level_Parser("assets/levels/levels.ldtk")
	
	current_scene = Scene()
	level = Group(current_scene)
	
	timer = Timer()
	input = Input()
	
	p = Player(level, 16, 88, 8, 6)
	p:add_mask("tiles")

	for i = 0, 23, 1 do
		local y = 96 - math.floor(i / 8) * 16
		-- local y = 96
		local t = Tile(level, i * 8, y, 8, 8, math.floor(math.random() * 4))
		t:add_layer("tiles")
		t = Tile(level, i * 8, y + 8, 8, 8, 9 + weighted_random({10, 1, 1, 1}))
		t:add_layer("tiles")
		t = Tile(level, i * 8, y + 16, 8, 8, 9 + weighted_random({10, 1, 1, 1}))
		t:add_layer("tiles")
		t = Tile(level, i * 8, y + 24, 8, 8, 9 + weighted_random({10, 1, 1, 1}))
		t:add_layer("tiles")
		t = Tile(level, i * 8, y + 32, 8, 8, 9 + weighted_random({10, 1, 1, 1}))
		t:add_layer("tiles")
		t = Tile(level, i * 8, y + 40, 8, 8, 9 + weighted_random({10, 1, 1, 1}))
		t:add_layer("tiles")
	end

	debug = Debug()

	cam = Camera(0, 0)

	love.graphics.setBackgroundColor(0.102, 0.110, 0.173, 1.0)
end

function love.update(dt)
	timer:update(dt)
	current_scene:update(dt)

	-- cam.x = cam.x + dt * 2

	input:update()
end

function love.draw()
	love.graphics.setCanvas(main_canvas)
    love.graphics.clear()
	cam:focus()
	current_scene:draw()
	debug:draw()

	cam:unfocus()
	love.graphics.setCanvas()
	
	love.graphics.draw(main_canvas, 0, 0, 0, sx, sy)
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
