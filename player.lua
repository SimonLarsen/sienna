Player = {}
Player.__index = Player

local PLAYER_SPEED = 150
local MAX_SPEED = 200
local GRAVITY = 1000
local JUMP_POWER = 150
local MAX_JUMP = 32
local COL_OFFSETS = {{-2.5,  2}, {2.5,  2},
					 {-2.5, 10}, {2.5, 10},
					 {-2.5, 20}, {2.5, 20}}

local floor = math.floor
local lk = love.keyboard

function Player.create(x,y)
	local self = {}
	setmetatable(self,Player)

	self.x = x or 0
	self.y = y or 0

	self.xspeed = 0
	self.yspeed = 0
	self.onGround = false
	self.jump = 0

	return self
end

function Player:update(dt)
	self.xspeed = 0
	self.yspeed = self.yspeed + GRAVITY*dt
	if self.yspeed > MAX_SPEED then
		self.yspeed = MAX_SPEED
	end

	if lk.isDown("left") then
		self.xspeed = -PLAYER_SPEED
	end
	if lk.isDown("right") then
		self.xspeed =  PLAYER_SPEED
	end

	if lk.isDown(" ") then
		if self.onGround == true then
			self.jump = MAX_JUMP
		end
		if self.jump > 0 then
			self.yspeed = -JUMP_POWER
		end
	else
		if self.jump > 0 then
			self.jump = 0
		end
	end

	self:moveX(self.xspeed*dt)
	self:moveY(self.yspeed*dt)
end

function Player:moveY(dist)
	local newy = self.y + dist
	local col = false
	self.onGround = false

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

	for i=1, #COL_OFFSETS do
		local bx = floor((newx+COL_OFFSETS[i][1]) / TILEW)
		local by = floor((self.y+COL_OFFSETS[i][2]) / TILEW)

		if isSolid(bx, by) == true then
			if dist > 0 and bx*TILEW-2.5 < newx then
				newx = bx*TILEW-2.5001
			elseif dist < 0 and (bx+1)*TILEW+2.5 > newx then
				newx = (bx+1)*TILEW+2.5001
			end
		end
	end
	self.x = newx
end

function Player:draw()
	love.graphics.drawq(imgPlayer, quads.player, self.x, self.y, 0,1,1, 6.5)
end
