quads = {}

local lg = love.graphics
function loadImages()
	imgPlayer = lg.newImage("art/player.png")
end

function createQuads()
	quads.player = lg.newQuad(0,0,13,20,128,128)
end
