quads = {}
snd = {}

local lg = love.graphics
local la = love.audio

COLORS = {
	yellow 		= {237,201,81},
	red 		= {204,51,63},
	orange 		= {235,104,65},
	offwhite 	= {231,231,231},
	lightblue   = {105,188,188},
	darkblue	= {0,160,176},
	darkbrown   = {71,44,31},
	lightbrown  = {106,75,60}
}

function loadImages()
	imgPlayer = lg.newImage("art/player.png")
	imgPlayer2 = lg.newImage("art/player2.png")
	imgObjects = lg.newImage("art/objects.png")
	imgEnemies = lg.newImage("art/enemies.png")
end

function loadSounds()
	snd.Burn  	= la.newSource("sfx/burn.wav",  "static")
	snd.Jump  	= la.newSource("sfx/jump.wav",  "static")
	snd.Hurt  	= la.newSource("sfx/hurt.wav",  "static")
	snd.Star  	= la.newSource("sfx/star.wav",  "static")
	snd.Water 	= la.newSource("sfx/water.wav", "static")
	snd.Jumppad = la.newSource("sfx/jumppad.wav", "static")
	snd.RockRelease = la.newSource("sfx/rockrelease.wav", "static")
	snd.RockGone = la.newSource("sfx/rockgone.wav", "static")
end

function createQuads()
	-- Player quads
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

	-- Misc. entity quads
	quads.star = lg.newQuad(109,110,19,18, 128, 128)
	quads.spike = {}
	for i = 0,1 do
		quads.spike[i] = lg.newQuad(i*16, 0, 16, 16, 128, 128)
	end
	quads.jumppad = {}
	for i=0,3 do
		quads.jumppad[i] = lg.newQuad(i*16, 32, 16, 16, 128, 128)
	end

	-- Enemy quads
	quads.orb  = lg.newQuad(48, 0, 16, 16, 128, 128)
	quads.dog  = lg.newQuad(0, 32, 16, 16, 128, 128)
	quads.dog_jump = lg.newQuad(16, 32, 16, 19, 128, 128)
	quads.stone = lg.newQuad(96,96,28,28,128,128)
	quads.mole = {}
	for i=0,4 do
		quads.mole[i] = lg.newQuad(48+i*16, 0, 16, 16, 128,128)
	end
	quads.bee = {}
	quads.bee[0] = lg.newQuad( 0, 0, 15, 19, 128,128)
	quads.bee[1] = lg.newQuad(16, 0, 15, 19, 128,128)
	quads.spider = lg.newQuad(48, 32, 25, 24, 128,128)
end
