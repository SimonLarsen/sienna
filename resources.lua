quads = {}

local lg = love.graphics

COLORS = {
	yellow 		= {237,201,81},
	red 		= {204,51,63},
	orange 		= {235,104,65},
	offwhite 	= {231,231,231},
	lightblue   = {105,188,188},
	darkblue	= {0,160,176}
}

function loadImages()
	imgPlayer = lg.newImage("art/player.png")
	imgObjects = lg.newImage("art/objects.png")
	imgEnemies = lg.newImage("art/enemies.png")
end

function createQuads()
	quads.player = lg.newQuad(0,0,13,20,128,128)
	quads.player_wall = lg.newQuad(16,0,13,19,128,128)

	quads.player_run = {}
	for i=0,5 do
		quads.player_run[i] = lg.newQuad(i*16, 32, 13, 20, 128, 128)
	end

	quads.player_burn = {}
	for i=0,7 do
		quads.player_burn[i] = lg.newQuad(i*16, 64, 13, 20, 128, 128)
	end

	quads.spike = {}
	for i = 0,1 do
		quads.spike[i] = lg.newQuad(i*16, 0, 16, 16, 128, 128)
	end

	quads.jumppad = {}
	for i=0,3 do
		quads.jumppad[i] = lg.newQuad(i*16, 32, 16, 16, 128, 128)
	end

	quads.star = lg.newQuad(109,110,19,18, 128, 128)
	quads.orb  = lg.newQuad(48, 0, 16, 16, 128, 128)
	quads.dog  = lg.newQuad(0, 32, 16, 16, 128, 128)
	quads.dog_jump = lg.newQuad(16, 32, 16, 19, 128, 128)

	quads.bee = {}
	quads.bee[0] = lg.newQuad(0,0, 15,19, 128,128)
	quads.bee[1] = lg.newQuad(16,0, 15,19, 128,128)
end
