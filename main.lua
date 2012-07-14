require("slam")
require("resources")
require("map")
require("player")
require("enemies")
require("spike")
require("particles")
require("checkpoint")
require("jumppad")
require("orb")
require("coin")
require("menu")

local love = love
local min = math.min
local max = math.max
local floor = math.floor
local lg = love.graphics

TILEW = 16
WIDTH = 300
HEIGHT = 200

SCROLL_SPEED = 5 -- 3 to 8 = smooth, 9 = none

STATE_MAINMENU = 0
STATE_INGAME_MENU = 1
STATE_INGAME = 2

function love.load()
	setScale(3)
	lg.setDefaultImageFilter("nearest","nearest")
	lg.setBackgroundColor(COLORS.darkbrown)

	loadImages()
	loadSounds()
	createQuads()
	createMenus()

	player  = Player.create(1)

	loadMap("temple5.tmx")

	gamestate = STATE_INGAME
	current_menu = main_menu
end

function love.update(dt)
	if gamestate == STATE_INGAME then
		if dt > 0.06 then dt = 0.06 end
		if love.keyboard.isDown("s") then
			dt = dt/10
		end

		player:update(dt)
		Spike.globalUpdate(dt)
		Jumppad.globalUpdate(dt)
		Coin.globalUpdate(dt)

		local totx = player.x + 6.5 - WIDTH/2
		local toty = player.y + 10 - HEIGHT/2
		if SCROLL_SPEED == 9 then
			tx = min(max(0, totx), MAPW-WIDTH)
			ty = min(max(0, toty), MAPH-HEIGHT)
		else
			tx = min(max(0, tx+(totx-tx)*SCROLL_SPEED*dt), MAPW-WIDTH)
			ty = min(max(0, ty+(toty-ty)*SCROLL_SPEED*dt), MAPH-HEIGHT)
		end

		-- Update enemies
		for i=#map.enemies,1,-1 do
			local enem = map.enemies[i]
			if enem.alive == true then
				if enem.update then
					enem:update(dt)
				end
			else
				table.remove(map.enemies, i)
			end
		end

		-- Update particles
		for i=#map.particles,1,-1 do
			local part = map.particles[i]
			if part.alive == true then
				part:update(dt)
			else
				table.remove(map.particles, i)
			end
		end
	end
end

function love.draw()
	lg.scale(SCALE)

	-- STATE: In game
	if gamestate == STATE_INGAME then
		drawIngame()
	elseif gamestate == STATE_INGAME_MENU then
		lg.push()
		drawIngame()
		lg.pop()
		current_menu:draw()
	elseif gamestate == STATE_MAINMENU then
		love.graphics.drawq(imgTitle, quads.title, 0,0, 0, WIDTH/900)
		current_menu:draw()
	end
end

function drawIngame()
	lg.translate(-tx, -ty)

	map:setDrawRange(tx,ty,WIDTH,HEIGHT)
	map:draw()

	player:draw()

	for i,v in ipairs(map.entities) do
		v:draw()
	end

	for i,v in ipairs(map.coins) do
		v:draw()
	end

	for i,v in ipairs(map.enemies) do
		if v.draw then
			v:draw()
		end
	end

	for i,v in ipairs(map.particles) do
		v:draw()
	end
end

function love.keypressed(k, uni)
	if gamestate == STATE_INGAME then
		if k == "escape" then
			gamestate = STATE_INGAME_MENU
			current_menu = ingame_menu
		elseif k == "r" then
			player:kill()
		elseif k == "return" then
			reloadMap()
		else
			player:keypressed(k, uni)
		end
	elseif gamestate == STATE_INGAME_MENU or gamestate == STATE_MAINMENU then
		current_menu:keypressed(k,uni)
	end
end

function love.keyreleased(k, uni)
	if gamestate == STATE_INGAME then
		if k ~= "escape" and k ~= "r" then
			player:keyreleased(k, uni)
		end
	end
end

function love.mousepressed(x,y,button)
	if gamestate == STATE_INGAME then
		player:keypressed(" ")
	end
end

function love.mousereleased(x,y,button)
	if gamestate == STATE_INGAME then
		player:keyreleased(" ")
	end
end

function love.focus(f)
	if f == false and gamestate == STATE_INGAME then
		gamestate = STATE_INGAME_MENU
		current_menu = ingame_menu
	end
end

function setScale(scale)
	if scale < 1 or scale == SCALE then return end

	SCALE = scale
	SCREEN_WIDTH  = WIDTH*SCALE
	SCREEN_HEIGHT = HEIGHT*SCALE

	lg.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, false, true)
end

function setResolution(w,h)
	lg.setMode(w, h, false, true)

	if w == 0 and h == 0 then
		SCREEN_WIDTH = lg.getWidth()
		SCREEN_HEIGHT = lg.getHeight()
		lg.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, false, true)
	else
		SCREEN_WIDTH = w
		SCREEN_HEIGHT = h
	end

	SCALE = 1
	while (20*16*SCALE) < SCREEN_WIDTH or (16*16*SCALE) < SCREEN_HEIGHT do
		SCALE = SCALE + 1
	end
	WIDTH = SCREEN_WIDTH/SCALE
	HEIGHT = SCREEN_HEIGHT/SCALE
end
