quads = {}

local lg = love.graphics

function loadImages()
	imgPlayer = lg.newImage("art/player.png")
	imgObjects = lg.newImage("art/objects.png")
end

function createQuads()
	quads.player = lg.newQuad(0,0,13,20,128,128)
	quads.player_wall = lg.newQuad(16,0,13,19,128,128)

	quads.player_run = {}
	for i=0,5 do
		quads.player_run[i] = lg.newQuad(i*16, 32, 13, 20, 128, 128)
	end

	quads.spike = {}
	for i = 0,1 do
		quads.spike[i] = lg.newQuad(i*16, 0, 16, 16, 128, 128)
	end

	quads.star = lg.newQuad(109,110,19,18, 128,128)
end
