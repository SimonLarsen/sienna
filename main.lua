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
require("levelselection")
require("data")

local host = require('hostinfo')

local love = love
local min = math.min
local max = math.max
local floor = math.floor
local lg = love.graphics

TILEW = 16
WIDTH = 300
HEIGHT = 200

STATE_MAINMENU = 0
STATE_INGAME_MENU = 1
STATE_INGAME = 2
STATE_LEVEL_MENU = 3
STATE_LEVEL_COMPLETED = 4

function love.load()
	loadSettings()
	loadData()

	lg.setDefaultFilter("nearest","nearest")
	lg.setBackgroundColor(COLORS.darkbrown)
	lg.setLineStyle("rough")

	loadImages()
	loadSounds()
	createQuads()
	createMenus()

	gamestate = STATE_MAINMENU
	current_menu = main_menu

	player = Player.create()
end

function love.update(dt)
	if gamestate == STATE_INGAME then
		-- Upper bound on frame delay
		if dt > 0.06 then dt = 0.06 end

		if love.keyboard.isDown("s") then
			dt = dt/100
		end

		-- Progress timer
		map.time = map.time + dt

		-- Update entitites
		player:update(dt)
		if player.x > MAPW+6 then
			gamestate = STATE_LEVEL_COMPLETED
		end

		Spike.globalUpdate(dt)
		Jumppad.globalUpdate(dt)
		Coin.globalUpdate(dt)

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

		-- Target screen translation
		local totx = player.x + 6.5 - WIDTH/2
		local toty = player.y + 10 - HEIGHT/2
		-- Calculate new screen translation
		if SCROLL_SPEED == 9 then
			tx = min(max(0, totx), MAPW-WIDTH)
			ty = min(max(0, toty), MAPH-HEIGHT)
		else
			tx = min(max(0, tx+(totx-tx)*SCROLL_SPEED*dt), MAPW-WIDTH)
			ty = min(max(0, ty+(toty-ty)*SCROLL_SPEED*dt), MAPH-HEIGHT)
		end
	end
end

local scale_x, scale_y

function love.draw()
	lg.scale(scale_x, scale_y)

	-- STATE: In game
	if gamestate == STATE_INGAME then
		lg.push()
		drawIngame()
		lg.pop()
		drawIngameHUD()
	elseif gamestate == STATE_INGAME_MENU then
		lg.push()
		drawIngame()
		lg.pop()
		current_menu:draw()
	elseif gamestate == STATE_MAINMENU then
		love.graphics.draw(imgTitle, quads.title, 0,0, 0, WIDTH/900)
		current_menu:draw()
	elseif gamestate == STATE_LEVEL_MENU then
		LevelSelection.draw()
	elseif gamestate == STATE_LEVEL_COMPLETED then
		lg.push()
		drawIngame()
		lg.pop()
		drawCompletionHUD()
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

function drawIngameHUD()
	local time = getTimerString(map.time)

	-- Draw text
	lg.draw(imgHUD, quads.hud_coin, 9, 10)
	lg.draw(imgHUD, quads.hud_skull, 48, 10)
	lg.setColor(1,1,1,1)
	lg.print(map.numcoins.."/5", 21, 13)
	lg.print(map.deaths, 67, 13)
	lg.printf(time, WIDTH-120, 13, 100, "right")
end

function drawCompletionHUD()
	lg.setColor(0,0,0,200/255)
	lg.rectangle("fill", 0,0, WIDTH,HEIGHT)
	lg.setColor(1,1,1,1)
	lg.draw(imgHUD, quads.text_level, 48,40)
	lg.draw(imgHUD, quads.text_cleared, 140,40)

	lg.print("COINS:", 66,75)
	lg.print(map.numcoins.."/5", 130,75)
	lg.print("DEATHS:", 66,95)
	lg.print(map.deaths, 130,95)
	lg.print("TIME:", 66,115)
	lg.print(getTimerString(map.time), 130,115)

	-- Draw coins difference
	if map.numcoins > level_status[current_map].coins then
		lg.setColor(COLORS.green)
		lg.print("+"..map.numcoins-level_status[current_map].coins, 160, 75)
	end
	-- Draw deaths difference
	if level_status[current_map].deaths then
		if map.deaths > level_status[current_map].deaths then
			lg.setColor(COLORS.red)
			lg.print("+"..map.deaths-level_status[current_map].deaths, 148, 95)
		elseif map.deaths < level_status[current_map].deaths then
			lg.setColor(COLORS.green)
			lg.print("-"..level_status[current_map].deaths-map.deaths, 148, 95)
		end
	end
	-- Draw time difference
	if level_status[current_map].time then
		if map.time > level_status[current_map].time then
			lg.setColor(COLORS.red)
			lg.print("+"..getTimerString(map.time-level_status[current_map].time), 194, 115)
		elseif map.time < level_status[current_map].time then
			lg.setColor(COLORS.green)
			lg.print("-"..getTimerString(level_status[current_map].time-map.time), 194, 115)
		end
	end


	lg.setColor(1,1,1,1)
	lg.print("PRESS ANY KEY TO CONTINUE", 55, 165)
end

function getTimerString(time)
	local msec = math.floor((time % 1)*100)
	local sec = math.floor(time % 60)
	local min = math.floor(time/60)
	return string.format("%02d'%02d\"%02d",min,sec,msec)
end

function love.keypressed(k)
	if gamestate == STATE_INGAME then
		if k == "space" or k == "z" or k == "x" then
			player:keypressed(k)
		elseif k == "escape" then
			gamestate = STATE_INGAME_MENU
			current_menu = ingame_menu
			ingame_menu.selected = 1
		elseif k == "r" then
			player:kill()
		elseif k == "return" then
			reloadMap()
		elseif k == "c" then
			gamestate = STATE_LEVEL_COMPLETED
		end
	elseif gamestate == STATE_INGAME_MENU or gamestate == STATE_MAINMENU then
		current_menu:keypressed(k)
	elseif gamestate == STATE_LEVEL_MENU then
		LevelSelection.keypressed(k)
	elseif gamestate == STATE_LEVEL_COMPLETED then
		levelCompleted()
	end
end

function love.keyreleased(k)
	if gamestate == STATE_INGAME then
		if k ~= "escape" and k ~= "r" then
			player:keyreleased(k)
		end
	end
end

local touches = {}

function love.touchpressed(id, x, y)
	table.insert(touches, {id = id, x = x, y = y})
	if gamestate == STATE_INGAME then
		player:keypressed(' ')
	end
end

function love.touchreleased(id, x, y)
	local ignore = false
	for i = #touches, 1, -1 do
		if touches[i].moved then
			ignore = true
		end
		if touches[i].id == id then
			table.remove(touches, i)
		end
	end
	if not ignore then
		if gamestate == STATE_INGAME then
			player:keyreleased(' ')
		elseif gamestate == STATE_INGAME_MENU or gamestate == STATE_MAINMENU then
			current_menu:keypressed('return')
		elseif gamestate == STATE_LEVEL_MENU then
			LevelSelection.keypressed('return')
		elseif gamestate == STATE_LEVEL_COMPLETED then
			levelCompleted()
		end
	end
end

function love.touchmoved(id, x, y)
	for i, v in ipairs(touches) do
		if v.id == id and not v.moved then
			local xv = x - v.x
			local yv = y - v.y
			local axv = math.abs(xv)
			local ayv = math.abs(yv)

			-- Ignore touchmoves below a certain threshold
			local threshold = 0.08

			if axv < threshold and ayv < threshold then
				return
			end

			v.moved = true
			local function send(key)
				if gamestate == STATE_INGAME_MENU or gamestate == STATE_MAINMENU then
					current_menu:keypressed(key)
				elseif gamestate == STATE_LEVEL_MENU then
					LevelSelection.keypressed(key)
				end
			end
			if ayv > axv then
				if yv > 0 then
					send('down')
				elseif yv < 0 then
					send('up')
				end
			else
				if xv > 0 then
					send('right')
				elseif xv < 0 then
					send('left')
				end
			end
			return
		end
	end
end

function love.focus(f)
	if f == false and gamestate == STATE_INGAME then
		gamestate = STATE_INGAME_MENU
		current_menu = ingame_menu
		ingame_menu.selected = 1
	end
end

function setScale(scale)
	if scale < 1 or scale == SCALE then return end

	SCALE = scale

	if host.isTouchDevice() then
		scale_x = love.graphics.getWidth() / WIDTH
		scale_y = love.graphics.getHeight() / HEIGHT
	else
		scale_x = scale
		scale_y = scale
	end

	SCREEN_WIDTH  = WIDTH*SCALE
	SCREEN_HEIGHT = HEIGHT*SCALE

	love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {
		fullscreen=false,
		vsync=true,
		borderless = host.isTouchDevice()
	})
end

function setResolution(w,h)
	love.window.setMode(w, h, {
		fullscreen=false,
		vsync=true,
		borderless = host.isTouchDevice()
	})

	if w == 0 and h == 0 then
		SCREEN_WIDTH = lg.getWidth()
		SCREEN_HEIGHT = lg.getHeight()
		love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {
			fullscreen=false,
			vsync=true,
			borderless = host.isTouchDevice()
		})
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

function love.quit()
	saveSettings()
	saveData()
end
