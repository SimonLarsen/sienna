local loader = require("AdvTiledLoader.Loader")
loader.path = "maps/"

local floor = math.floor

function loadMap(name)
	map = loader.load(name)
	map.drawObjects = false
	fgtiles = map.tileLayers.fg.tileData

	MAPW = map.width*TILEW
	MAPH = map.height*TILEW
end


function collidePoint(x,y)
	return isSolid(floor(x/TILEW), floor(y/TILEW))
end

function isSolid(x,y)
	local tile = fgtiles(x,y)
	if tile ~= nil and tile.id <= 32 then
		return true
	else
		return false
	end
end
