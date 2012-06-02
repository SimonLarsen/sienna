OBJ_ROTSPIKE = 513
OBJ_CHECKPOINT = 517
OBJ_SPIKE_S = 33
OBJ_SPIKE_E = 36

local floor = math.floor
local loader = require("AdvTiledLoader.Loader")
loader.path = "maps/"

function loadMap(name)
	map = loader.load(name)
	map.drawObjects = false
	fgtiles = map.tileLayers.fg.tileData

	map.enemies = {}
	map.particles = {}
	map.entities = {}

	MAPW = map.width*TILEW
	MAPH = map.height*TILEW
	map.startx = 16
	map.starty = 192

	for i,v in ipairs(map.objectLayers.obj.objects) do
		if v.gid == OBJ_ROTSPIKE or v.gid == OBJ_ROTSPIKE+1 then
			table.insert(map.enemies, Spike.create(v.x, v.y-16))
		elseif v.gid == OBJ_CHECKPOINT then
			table.insert(map.entities, Checkpoint.create(v.x+8, v.y-16))
		elseif v.type == "bee" then
			table.insert(map.enemies, Bee.create(v.x, v.y-18, v.properties))
		elseif v.type == "start" then
			map.startx = v.x
			map.starty = v.y
		end
	end
end

function collidePoint(x,y)
	return isSolid(floor(x/TILEW), floor(y/TILEW))
end

function collideSpike(x,y, pl)
	x = x*TILEW
	y = y*TILEW
	if pl.x-5.5 > x+10 or pl.x+5.5 < x+3
	or pl.y+2 > y+10 or pl.y+20 < y+3 then
		return false
	else
		return true
	end
end

function isSolid(x,y)
	local tile = fgtiles(x,y)
	if tile ~= nil and tile.id <= 32 then
		return true
	else
		return false
	end
end
