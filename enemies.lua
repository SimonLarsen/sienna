Bee = {}
Bee.__index = Bee

function Bee.create(x,y,prop)
	local self = {}
	setmetatable(self, Bee)

	self.alive = true
	self.x = x
	self.inity = y
	self.y = y
	self.time = prop.time or 0
	self.dir = prop.dir or -1
	self.yint = prop.yint or 32

	return self
end

function Bee:update(dt)
	self.time = (self.time + dt*4)%(2*math.pi)
	self.y = self.inity + math.cos(self.time)*self.yint
end

function Bee:draw()
	local frame = math.floor(self.time*4) % 2
	love.graphics.drawq(imgEnemies, quads.bee[frame], self.x, self.y, 0,self.dir,1, 7.5)
end

function Bee:collidePlayer(pl)
	if pl.x-5.5 > self.x+3.5 or pl.x+5.5 < self.x-3.5
	or pl.y+2 > self.y+17 or pl.y+20 < self.y+2 then
		return false
	else
		return true
	end
end
