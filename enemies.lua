Bee = {}
Bee.__index = Bee

function Bee.create(x,y,dir,yint)
	local self = {}
	setmetatable(self, Bee)

	self.alive = true
	self.x = x
	self.inity = y
	self.y = y
	self.time = 0
	self.dir = dir or -1
	self.yint = yint

	return self
end

function Bee:update(dt)
	self.time = (self.time + dt*4)%(2*math.pi)
	self.y = self.inity + math.cos(self.time)*self.yint
end

function Bee:draw()
	love.graphics.drawq(imgEnemies, quads.bee, self.x, self.y, 0,self.dir,1, 7.5)
end

function Bee:collidePlayer(pl)
	return false
end
