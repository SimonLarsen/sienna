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

local love = love
local min = math.min
local max = math.max
local floor = math.floor
local lg = love.graphics

TILEW = 16
local SCREEN_WIDTH    local SCREEN_HEIGHT
local SCALE
local SCROLL_SPEED = 6
local scroll_smooth = true

local player

function love.load()
	setResolution(800,600)
	lg.setDefaultImageFilter("nearest","nearest")
	lg.setBackgroundColor(COLORS.darkbrown)

	loadImages()
	loadSounds()
	createQuads()

	loadMap("temple2.tmx")

	player  = Player.create(map.startx, map.starty, map.startdir, 1)
end

function love.update(dt)
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
	if scroll_smooth == true then
		tx = min(max(0, tx+(totx-tx)*SCROLL_SPEED*dt), MAPW-WIDTH)
		ty = min(max(0, ty+(toty-ty)*SCROLL_SPEED*dt), MAPH-HEIGHT)
	else
		tx = min(max(0, totx), MAPW-WIDTH)
		ty = min(max(0, toty), MAPH-HEIGHT)
	end

	btx = 128+tx*((MAPW-1024)/MAPW)

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

function love.draw()
	lg.scale(SCALE)
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
	if k == " " then
		player:keypressed(k, uni)
	elseif k == "escape" then
		love.event.quit()
	elseif k == "r" then
		player:respawn()
	elseif k == "1" then
		loadMap("mine.tmx")
		player:respawn()
	elseif k == "2" then
		loadMap("temple.tmx")
		player:respawn()
	end
end

function love.keyreleased(k, uni)
	if k == " " then
		player:keyreleased(k, uni)
	end
end

function love.mousepressed(x,y,button)
	player:keypressed(" ")
end

function love.mousereleased(x,y,button)
	player:keyreleased(" ")
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
