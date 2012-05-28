WIDTH = 300
HEIGHT = 200
TILEW = 16
MAPW = 0
MAPH = 0
SCALE = 2

require("resources")
require("player")
require("map")

local love = love
local min = math.min
local max = math.max
local floor = math.floor
local lg = love.graphics

function love.load()
	lg.setMode(WIDTH*SCALE, HEIGHT*SCALE, false, true)
	lg.setDefaultImageFilter("nearest","nearest")

	loadImages()
	createQuads()

	loadMap("test.tmx")

	player = Player.create(128, 128)
end

function love.update(dt)
	player:update(dt)
end

function love.draw()
	lg.scale(SCALE)
	tx = floor(min(max(0, player.x + 6.5 - WIDTH/2), MAPW-WIDTH)*2000)/2000
	ty = floor(min(max(0, player.y + 10 - HEIGHT/2), MAPH-HEIGHT)*2000)/2000

	lg.translate(-tx, -ty)

	map:setDrawRange(tx,ty,WIDTH,HEIGHT)
	map:draw()
	player:draw()
end

function love.keypressed(k, uni)
	if k == "escape" then
		love.event.quit()
	end
end
