Player = {}
Player.__index = Player

local PLAYER_SPEED = 150
local MAX_SPEED = 200
local GRAVITY = 1000
local JUMP_POWER = 200
local MAX_JUMP = 32
local INVUL_TIME = 1
local BRAKE_POWER = 1
local COL_OFFSETS = {{-5.5,  2}, {5.5,  2},
					 {-5.5, 10}, {5.5, 10},
					 {-5.5, 20}, {5.5, 20}}
local STATE_WAIT = 0
local STATE_RUNNING = 1
local STATE_BURNING = 2

local floor = math.floor
local min = math.min
local lk = love.keyboard

function Player.create(x,y,dir,player)
	local self = {}
	setmetatable(self,Player)

	self.player = player or 1
	if self.player == 1 then
		self.img = imgPlayer
	else
		self.img = imgPlayer2
	end
	self:respawn(x,y,dir)

	return self
end

function Player:respawn(x,y,dir,player)
	self.x = x or map.startx
	self.y = y or map.starty
	self.dir = dir or map.startdir or 1 -- -1 = left, 1 = right

	self.frame = 0
	self.state = STATE_RUNNING

	self.xspeed = 0
	self.yspeed = 0
	self.onGround = false
	self.inWater = false
	self.jump = 0
	self.invul = INVUL_TIME
	self.onWall = false

	addSparkle(self.x, self.y+10, 32, COLORS.orange)
end

function Player:update(dt)
	self.frame = self.frame + dt*13
	if self.invul > 0 then
		self.invul = self.invul - dt
	end

	if self.state == STATE_RUNNING then
		self.xspeed = 0
		self.yspeed = self.yspeed + GRAVITY*dt
		self.yspeed = min(self.yspeed, MAX_SPEED)

		self.xspeed = self.dir*PLAYER_SPEED

		if self.jump > 0 then
			self.yspeed = -JUMP_POWER
		end

		-- Decrease speed if in water
		if self.inWater == true then
			self.xspeed = self.xspeed*0.4
		end

		-- move in X and Y direction
		self.onGround = false
		self:moveX(self.xspeed*dt)
		self:moveY(self.yspeed*dt)

		-- check wall jump
		self.onWall = false
		if self.onGround == false then
			if self.dir == -1 and collidePoint(self.x-6, self.y+5)
			or collidePoint(self.x-6, self.y+15) then
				self.onWall = true
			elseif self.dir == 1 and collidePoint(self.x+6, self.y+5)
			or collidePoint(self.x+6, self.y+15) then
				self.onWall = true
			end
		end

		for i,v in ipairs(map.enemies) do
			if v:collidePlayer(self) and self.invul <= 0 then
				love.audio.play(snd.Hurt)
				self:kill()
			end
		end

		for i,v in ipairs(map.entities) do
			if v.collidePlayer then
				v:collidePlayer(self)
			end
		end

		self:checkTiles()

		-- TODO: Replace with win stuff
		if self.y > MAPH then
			self:kill()
		end

	elseif self.state == STATE_BURNING then
		if self.frame >= 8 then
			self:kill()
		end
	end
end

function Player:kill(...)
	kills = kills + 1
	print(kills)
	self:respawn(...)
end

function Player:checkTiles()
	local hitWater = false
	local bx, by, tile
	for i=1, #COL_OFFSETS do
		bx = floor((self.x+COL_OFFSETS[i][1]) / TILEW)
		by = floor((self.y+COL_OFFSETS[i][2]) / TILEW)
		tile = fgtiles(bx,by)
		if tile ~= nil then
			if tile.id >= TILE_SPIKE_S and tile.id <= TILE_SPIKE_E then
				if collideSpike(bx,by,self) then
					addSparkle(self.x,self.y+20,32,COLORS.red)
					love.audio.play(snd.Hurt)
					self:kill()
					return
				end
			elseif tile.id == TILE_LAVA_TOP then -- Don't check for TILE_LAVA. Shouldn't be necessary
				if collideLava(bx,by,self) then
					self:kill(STATE_BURNING)
					self.frame = 0
					self.state = STATE_BURNING
					addSparkle(self.x,self.y+20,32,COLORS.red,1,-50)
					love.audio.play(snd.Burn)
					return
				end
			elseif tile.id == TILE_WATER or tile.id == TILE_WATER_TOP then
				hitWater = true
			end
		end
	end

	if hitWater == true and self.inWater == false then
		addSparkle(self.x,self.y+8,32,COLORS.darkblue)
		love.audio.play(snd.Water)
	end
	self.inWater = hitWater
end

function Player:keypressed(k, uni)
	if self.onGround == true then
		self.jump = MAX_JUMP
		addDust(self.x, self.y+20)
		love.audio.play(snd.Jump)
	elseif self.onWall == true then
		self.jump = MAX_JUMP
		if self.dir == 1 then
			self.dir = -1
			addDust(self.x+5.5, self.y+10)
		else
			self.dir = 1
			addDust(self.x-5.5, self.y+10)
		end
		love.audio.play(snd.Jump)
	end
end

function Player:keyreleased(k, uni)
	if self.jump > 0 then
		self.jump = 0
	end
end

function Player:moveY(dist)
	local bx, by
	local newy = self.y + dist
	local col = false

	for i=1, #COL_OFFSETS do
		bx = floor((self.x+COL_OFFSETS[i][1]) / TILEW)
		by = floor((newy+COL_OFFSETS[i][2]) / TILEW)

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
	if self.invul > 0 then
		if floor(self.invul*INVUL_TIME*20) % 2 == 1 then
			return
		end
	end

	if self.state == STATE_RUNNING then
		if self.onGround == true then
			if self.xspeed == 0 then
				love.graphics.drawq(self.img, quads.player, self.x, self.y, 0,self.dir,1, 6.5)
			else
				local frame = floor(self.frame % 6)
				love.graphics.drawq(self.img, quads.player_run[frame], self.x, self.y, 0,self.dir,1, 6.5)
			end
		else
			if self.onWall == true then
				love.graphics.drawq(self.img, quads.player_wall, self.x, self.y, 0,self.dir,1, 6.5)
			else
				love.graphics.drawq(self.img, quads.player_run[5], self.x, self.y, 0,self.dir,1, 6.5)
			end
		end
	
	elseif self.state == STATE_BURNING then
		local frame = floor(self.frame)
		love.graphics.drawq(self.img, quads.player_burn[frame], self.x, self.y, 0, self.dir, 1, 6.5)
	end
end
