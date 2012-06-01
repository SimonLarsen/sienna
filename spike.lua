Spike = {frame = 0}
Spike.__index = Spike

function Spike.create(x,y)
	local self = {}

	self.alive = true
	self.x = x
	self.y = y

	setmetatable(self, Spike)
	return self
end

function Spike.globalUpdate(dt)
	Spike.frame = (Spike.frame + dt*16) % 2
end

function Spike:draw()
	love.graphics.drawq(imgObjects, quads.spike[math.floor(Spike.frame)], self.x, self.y)
end

function Spike:collidePlayer(pl)
	if pl.x-5.5 > self.x+10 or pl.x+5.5 < self.x+3
	or pl.y+2 > self.y+10 or pl.y+20 < self.y+3 then
		return false
	else
		return true
	end
end
