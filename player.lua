Player = {}
Player.__index = Player

local PLAYER_SPEED = 150
local MAX_SPEED = 200
local GRAVITY = 1000
local JUMP_POWER = 200
local MAX_JUMP = 32
local COL_OFFSETS = {{-5.5,  2}, {5.5,  2},
					 {-5.5, 10}, {5.5, 10},
					 {-5.5, 20}, {5.5, 20}}

local floor = math.floor
local lk = love.keyboard

function Player.create(x,y)
	local self = {}
	setmetatable(self,Player)

	self.x = x or 0
	self.y = y or 0

	self.dir = 1 -- -1 or 1
	self.frame = 0

	self.xspeed = 0
	self.yspeed = 0
	self.onGround = false
	self.jump = 0
	self.onWall = false

	return self
end

function Player:update(dt)
	if dt > 0.06 then dt = 0.06 end

	self.frame = self.frame + dt*13

	self.xspeed = 0
	self.yspeed = self.yspeed + GRAVITY*dt
	if self.yspeed > MAX_SPEED then
		self.yspeed = MAX_SPEED
	end

	self.xspeed = self.dir*PLAYER_SPEED

	if self.jump > 0 then
		self.yspeed = -JUMP_POWER
	end

	-- move in X and Y direction
	self.onGround = false
	self:moveX(self.xspeed*dt)
	self:moveY(self.yspeed*dt)

	-- check wall jump
	self.onWall = false
	if self.onGround == false then
		if self.dir == -1 and collidePoint(self.x-6, self.y+19) then
			self.onWall = true
		elseif self.dir == 1 and collidePoint(self.x+6, self.y+19) then
			self.onWall = true
		end
	end
end

function Player:keypressed(k, uni)
	if k == " " then
		if self.onGround == true then
			self.jump = MAX_JUMP
		elseif self.onWall == true then
			self.jump = MAX_JUMP
			if self.dir == 1 then
				self.dir = -1
			else
				self.dir = 1
			end
		end
	end
end

function Player:keyreleased(k, uni)
	if k == " " then
		if self.jump > 0 then
			self.jump = 0
		end
	end
end

function Player:moveY(dist)
	local newy = self.y + dist
	local col = false

	for i=1, #COL_OFFSETS do
		local bx = floor((self.x+COL_OFFSETS[i][1]) / TILEW)
		local by = floor((newy+COL_OFFSETS[i][2]) / TILEW)

		if isSolid(bx, by) == true then
			col = true
			if dist > 0 and by*TILEW-20 < newy then
				newy = by*TILEW-20.0001
			elseif dist < 0 and (by+1)*TILEW-2 > newy then
				newy = (by+1)*TILEW-1.9999
			end
		end
	end
	self.y = newy
	if col == true then
		self.yspeed = 0
		if dist > 0 then
			self.onGround = true
		end
	end
	if dist < 0 then
		self.jump = self.jump + dist
	end
end

function Player:moveX(dist)
	local newx = self.x + dist
	local col = false

	for i=1, #COL_OFFSETS do
		local bx = floor((newx+COL_OFFSETS[i][1]) / TILEW)
		local by = floor((self.y+COL_OFFSETS[i][2]) / TILEW)

		if isSolid(bx, by) == true then
			col = true
			if dist > 0 and bx*TILEW-5.5 < newx then
				newx = bx*TILEW-5.5001
			elseif dist < 0 and (bx+1)*TILEW+5.5 > newx then
				newx = (bx+1)*TILEW+5.5001
			end
		end
	end
	self.x = newx
end

function Player:draw()
	if self.onGround == true then
		if self.xspeed == 0 then
			love.graphics.drawq(imgPlayer, quads.player, self.x, self.y, 0,self.dir,1, 6.5)
		else
			local frame = math.floor(self.frame % 6)
			love.graphics.drawq(imgPlayer, quads.player_run[frame], self.x, self.y, 0,self.dir,1, 6.5)
		end
	else
		if self.onWall == true then
			love.graphics.drawq(imgPlayer, quads.player_wall, self.x, self.y, 0,self.dir,1, 6.5)
		else
			love.graphics.drawq(imgPlayer, quads.player_run[5], self.x, self.y, 0,self.dir,1, 6.5)
		end
	end
end
