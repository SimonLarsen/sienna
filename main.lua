require("resources")
require("map")
require("player")
require("enemies")
require("spike")
require("particles")
require("checkpoint")

local love = love
local min = math.min
local max = math.max
local floor = math.floor
local lg = love.graphics

TILEW = 16
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local SCALE = 3
local WIDTH = SCREEN_WIDTH/SCALE
local HEIGHT = SCREEN_HEIGHT/SCALE
local SCROLL_SPEED = 300

function love.load()
	lg.setMode(WIDTH*SCALE, HEIGHT*SCALE, false, true)
	lg.setBackgroundColor(71,44,31)
	lg.setDefaultImageFilter("nearest","nearest")

	loadImages()
	createQuads()

	loadMap("test.tmx")

	tx = 0
	ty = MAPH-HEIGHT

	player = Player.create(map.startx, map.starty)
end

function love.update(dt)
	if dt > 0.06 then dt = 0.06 end
	if love.keyboard.isDown("s") then
		dt = dt/10
	end

	player:update(dt)
	Spike.globalUpdate(dt)

	local totx = player.x + 6.5 - WIDTH/2
	local toty = player.y + 10 - HEIGHT/2
	tx = min(max(0, tx+(totx-tx)*6*dt), MAPW-WIDTH)
	ty = min(max(0, ty+(toty-ty)*6*dt), MAPH-HEIGHT)

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

	for i,v in ipairs(map.enemies) do
		v:draw()
	end

	for i,v in ipairs(map.entities) do
		v:draw()
	end

	for i,v in ipairs(map.particles) do
		v:draw()
	end
end

function love.keypressed(k, uni)
	if k == "escape" then
		love.event.quit()
	elseif k == "r" then
		player:respawn(map.startx, map.starty)
	else
		player:keypressed(k, uni)
	end
end

function love.keyreleased(k, uni)
	player:keyreleased(k, uni)
end
