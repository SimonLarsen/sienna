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


Dog = {}
Dog.__index = Dog

function Dog.create(x,y,prop)
	local self = {}
	setmetatable(self, Dog)

	self.alive = true
	self.x = x
	self.inity = y
	self.y = y
	self.time = 0
	self.dir = prop.dir or -1
	self.jump = prop.jump or 40
	self.state = 0 -- 0 = idle, 1 = jumping

	return self
end

function Dog:update(dt)
	self.time = self.time + dt*4

	if self.state == 1 then
		self.y = self.inity - self.jump*math.sin(self.time)
		if self.time >= math.pi then
			self.state = 0
			self.y = self.inity
		end
	end
end

function Dog:draw()
	if self.state == 0 then
		love.graphics.drawq(imgEnemies, quads.dog, self.x, self.y, 0, self.dir, 1, 8)
	elseif self.state == 1 then
		love.graphics.drawq(imgEnemies, quads.dog_jump, self.x, self.y, 0, self.dir, 1, 8)
	end
end

function Dog:collidePlayer(pl)
	if self.state == 0 then
		local dist = math.pow(pl.x-self.x,2) + math.pow(pl.y-self.y,2)
		if dist < 1524 then
			self.state = 1
			self.time = 0
		end
	end

	if pl.x-5.5 > self.x+3.5 or pl.x+5.5 < self.x-3.5
	or pl.y+2 > self.y+16 or pl.y+20 < self.y+2 then
		return false
	else
		return true
	end
end
