Spike = {frame = 0}
Spike.__index = Spike

function Spike.create(x,y)
	local self = {}

	self.x = x
	self.y = y

	setmetatable(self, Spike)
	return self
end

function Spike.update(dt)
	Spike.frame = (Spike.frame + dt*16) % 2
end

function Spike:draw()
	love.graphics.drawq(imgObjects, quads.spike[math.floor(Spike.frame)], self.x, self.y)
end
