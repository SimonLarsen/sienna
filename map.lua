local loader = require("AdvTiledLoader.Loader")
loader.path = "maps/"

local OBJ_SPIKE = 513
local floor = math.floor

function loadMap(name)
	map = loader.load(name)
	map.drawObjects = false
	map.spikes = {}
	fgtiles = map.tileLayers.fg.tileData

	MAPW = map.width*TILEW
	MAPH = map.height*TILEW
	map.startx = 16
	map.starty = 192

	for i,v in ipairs(map.objectLayers.obj.objects) do
		if v.type == "start" then
			map.startx = v.x
			map.starty = v.y
		elseif v.gid == OBJ_SPIKE or v.gid == OBJ_SPIKE+1 then
			table.insert(map.spikes, Spike.create(v.x, v.y-16))
		end
	end
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
