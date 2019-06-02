quads = {}
snd = {}

local lg = love.graphics
local la = love.audio

COLORS = {
	yellow 		= {237/255,201/255,81/255},
	red 		= {204/255,51/255,63/255},
	orange 		= {235/255,104/255,65/255},
	offwhite 	= {231/255,231/255,231/255},
	lightblue   = {105/255,188/255,188/255},
	darkblue	= {0,160/255,176/255},
	darkbrown   = {71/255,44/255,31/255},
	lightbrown  = {106/255,75/255,60/255},
	green       = {105/255,188/255,109/255}
}

function loadImages()
	imgPlayer = lg.newImage("art/player.png")
	imgPlayer2 = lg.newImage("art/player2.png")
	imgPlayerW = lg.newImage("art/player_white.png")
	imgObjects = lg.newImage("art/objects.png")
	imgEnemies = lg.newImage("art/enemies.png")
	imgHUD     = lg.newImage("art/hud.png")
	imgTitle   = lg.newImage("art/titlescreen.png")
	imgTitle:setFilter("linear","linear")
	imgLevels  = lg.newImage("art/levelscreen.png")
	imgLevels:setFilter("linear","linear")

	local imgFontSmall = "art/font_small.png"
	local imgFontBold = "art/font_bold.png"
	local imgFontMedium = "art/font_medium.png"
	fontSmall = lg.newImageFont(imgFontSmall, " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,-!$:;'", 1)
	fontMedium = lg.newImageFont(imgFontMedium, " 0123456789abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ!-.,$", 1)
	fontBold = lg.newImageFont(imgFontBold, " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789*:|=-<>./'\"+", 1)
	lg.setFont(fontBold)
end

function loadSounds()
	snd.Burn  	= la.newSource("sfx/burn.wav",  "static")
	snd.Jump  	= la.newSource("sfx/jump.wav",  "static")
	snd.Hurt  	= la.newSource("sfx/hurt.wav",  "static")
	snd.Checkpoint = la.newSource("sfx/checkpoint.wav", "static")
	snd.Jumppad = la.newSource("sfx/jumppad.wav", "static")
	snd.RockRelease = la.newSource("sfx/rockrelease.wav", "static")
	snd.RockGone = la.newSource("sfx/rockgone.wav", "static")
	snd.Fireball1 = la.newSource("sfx/fireball.wav", "static")
	snd.Fireball2 = la.newSource("sfx/fireball2.wav", "static")
	snd.Coin = la.newSource("sfx/coin.wav", "static")
	snd.Turret = la.newSource("sfx/turret.wav", "static")
	snd.Blip = la.newSource("sfx/blip.wav", "static")
	snd.Blip2 = la.newSource("sfx/blip2.wav", "static")

	for i,v in pairs(snd) do
		v:addTags("sfx")
	end

	snd.Music = la.newSource("sfx/rugar-a_scent_of_europe.ogg", "stream")
	snd.Music:addTags("music")
	snd.Music:setLooping(true)

	updateVolumes()
	love.audio.play(snd.Music)
end

function updateVolumes()
	love.audio.tags["sfx"].setVolume(sound_volume)
	love.audio.tags["music"].setVolume(music_volume)
end

function createQuads()
	----------------
	-- Player quads
	----------------
	quads.player_wait1 = lg.newQuad(32,0,13,20,128,128)
	quads.player_wait2 = lg.newQuad(0,0,13,20,128,128)

	quads.player_wall = lg.newQuad(16,0,13,19,128,128)
	quads.player_run = {}
	for i=0,5 do
		quads.player_run[i] = lg.newQuad(i*16, 32, 13, 20, 128, 128)
	end
	quads.player_burn = {}
	for i=0,7 do
		quads.player_burn[i] = lg.newQuad(i*16, 64, 13, 20, 128, 128)
	end

	----------------------
	-- Misc. entity quads
	----------------------
	quads.star = lg.newQuad(109,110,19,18, 128, 128)
	quads.spike = {}
	for i = 0,1 do
		quads.spike[i] = lg.newQuad(i*16, 0, 16, 16, 128, 128)
	end
	quads.jumppad = {}
	for i=0,3 do
		quads.jumppad[i] = lg.newQuad(i*16, 32, 16, 16, 128, 128)
	end
	quads.coin = {}
	for i=0,3 do
		quads.coin[i] = lg.newQuad(i*16,48, 16,16, 128,128)
	end

	---------------
	-- Enemy quads
	---------------
	quads.orb  = lg.newQuad(48, 0, 16, 16, 128, 128)

	quads.dog      = lg.newQuad( 0, 32, 16, 16, 128, 128)
	quads.dog_jump = lg.newQuad(16, 32, 16, 19, 128, 128)

	quads.stone = lg.newQuad(96,96,28,28,128,128)

	quads.mole = {}
	for i=0,4 do
		quads.mole[i] = lg.newQuad(48+i*16, 0, 16, 16, 128,128)
	end

	quads.bee = {}

	quads.bee[0] = lg.newQuad( 0, 0, 15, 19, 128, 128)
	quads.bee[1] = lg.newQuad(16, 0, 15, 19, 128, 128)

	quads.spider = lg.newQuad(48, 32, 25, 24, 128, 128)

	quads.snake = {}
	for i = 0, 5 do
		quads.snake[i] = lg.newQuad(i*15, 64, 15, 24, 128, 128)
	end

	quads.fireball_moving = lg.newQuad( 96, 80, 7, 13, 128,128)
	quads.fireball_still  = lg.newQuad(104, 80, 7,  8, 128,128)

	quads.stalactite_whole = lg.newQuad(64, 96, 16, 16, 128,128)
	quads.stalactite_base  = lg.newQuad(80, 96, 16,  3, 128,128)
	quads.stalactite_tip   = lg.newQuad(80, 100, 16, 16, 128,128)

	quads.turret = lg.newQuad(112,17, 16, 16, 128, 128)
	quads.arrow  = lg.newQuad(112,80, 12,  3, 128, 128)

	-------------
	-- HUD quads
	-------------
	quads.hud_skull = lg.newQuad(0,0, 15,12, 128,128)
	quads.hud_coin  = lg.newQuad(16, 0, 8, 13, 128,128)
	quads.hud_clock = lg.newQuad(0,16,13,13,128,128)
	quads.title = lg.newQuad(0,0, 900, 600, 1024, 1024)
	quads.text_level = lg.newQuad(0,96, 76,14, 128,128)
	quads.text_cleared = lg.newQuad(0,112, 109,14, 128,128)
	quads.level_unlocked = lg.newQuad(32,0, 18,18, 128,128)
	quads.level_locked = lg.newQuad(64,0, 18,18, 128,128)
	quads.level_selected = lg.newQuad(96,0, 22,22, 128,128)
end
