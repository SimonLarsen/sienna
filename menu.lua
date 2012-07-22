local lg = love.graphics

Menu = {}
Menu.__index = Menu

function Menu.create(names, functions, escape_function)
	local self = {}
	setmetatable(self, Menu)

	self.names = names
	self.functions = functions
	self.length = #names
	self.escape_function = escape_function

	self.width = 0
	for i,v in ipairs(names) do
		local w = fontBold:getWidth("* "..v.." *")
		self.width = math.max(self.width, w)
	end

	self.height = 16*self.length-9

	self.selected = 1

	return self
end

function Menu:keypressed(k,uni)
	if k == "down" then
		self.selected = self.selected + 1
		if self.selected > self.length then
			self.selected = 1
		end
	elseif k == "up" then
		self.selected = self.selected - 1
		if self.selected == 0 then
			self.selected = self.length
		end
	elseif k == "return" then
		if self.functions[self.selected] then
			self.functions[self.selected](self)
		end
	elseif k == "escape" then
		self.escape_function(self)
	end
end

function Menu:draw()
	local top = (HEIGHT-self.height)/2

	lg.setColor(0,0,0,200)
	lg.rectangle("fill",(WIDTH-self.width)/2-6, top-6, self.width+12, self.height+12)
	lg.setColor(255,255,255,255)

	lg.setFont(fontBold)
	for i=1,self.length do
		if i == self.selected then
			lg.printf("* "..self.names[i].." *", 0, top+(i-1)*16, WIDTH, "center")
		else
			lg.printf(self.names[i], 0, top+(i-1)*16, WIDTH, "center")
		end
	end
end

function createMenus()
	-- INGAME MENU
	ingame_menu = Menu.create(
		{"CONTINUE", "RESTART LEVEL", "OPTIONS", "EXIT LEVEL", "QUIT GAME"},
		{function() gamestate = STATE_INGAME end,
		 function() reloadMap() gamestate = STATE_INGAME end,
		 function() current_menu = options_menu end,
		 function() gamestate = STATE_MAINMENU current_menu = level_menu end,
		 function() love.event.quit() end},

		 function() gamestate = STATE_INGAME end
	)

	-- OPTIONS MENU
	options_menu = Menu.create(
		{"SCALE: X", "CAMERA SPEED: |=======|",
		"MUSIC VOLUME: |==========|", "SOUND VOLUME: |==========|", "BACK"},
		{nil,nil,nil,nil,
		function() if gamestate == STATE_INGAME_MENU then current_menu = ingame_menu
			else current_menu = main_menu end end},

		function() if gamestate == STATE_INGAME_MENU then current_menu = ingame_menu
			else current_menu = main_menu end end
	)

	function options_menu:update()
		self.names = {
			"SCALE: "..SCALE,
			"CAMERA SPEED: |"..string.rep("=",SCROLL_SPEED-2)..string.rep("-",9-SCROLL_SPEED).."|",
			"MUSIC VOLUME: |==========|",
			"SOUND VOLUME: |==========|",
			"BACK"
		}
	end
	options_menu:update()

	options_menu.metakeypressed = options_menu.keypressed
	function options_menu:keypressed(k,uni)
		if k == "left" then
			if self.selected == 1 then
				setScale(SCALE-1)
			elseif self.selected == 2 then
				SCROLL_SPEED = math.max(3,SCROLL_SPEED-1)
			end
			self:update()
		elseif k == "right" then
			if self.selected == 1 then
				setScale(SCALE+1)
			elseif self.selected == 2 then
				SCROLL_SPEED = math.min(9,SCROLL_SPEED+1)
			end
			self:update()
		else
			self:metakeypressed(k,uni)
		end
	end

	-- MAIN MENU
	main_menu = Menu.create(
		{"START GAME", "CHALLENGES", "OPTIONS", "CREDITS", "QUIT GAME"},
		{function() current_menu = level_menu end,
		 nil,
		 function() current_menu = options_menu end,
		 function() current_menu = credits_menu end,
		 function() love.event.quit() end},

		 function() love.event.quit() end
	)

	function main_menu:draw()
		lg.setFont(fontBold)
		lg.setColor(0,0,0,255)
		for i=1,self.length do
			if i == self.selected then
				lg.printf("* "..self.names[i].." *", 123, 60+(i-1)*12, 166, "center")
			else
				lg.printf(self.names[i], 123, 60+(i-1)*12, 166, "center")
			end
		end
		lg.setColor(255,255,255,255)
		for i=1,self.length do
			if i == self.selected then
				lg.printf("* "..self.names[i].." *", 123, 59+(i-1)*12, 166, "center")
			else
				lg.printf(self.names[i], 123, 59+(i-1)*12, 166, "center")
			end
		end
	end

	-- level menu
	level_menu = Menu.create(
		{"MINE.TMX","MINE2.TMX","MINE3.TMX",
		 "TEMPLE.TMX","TEMPLE2.TMX","TEMPLE3.TMX","TEMPLE4.TMX","TEMPLE5.TMX",
	 	 "BOXES.TMX"},
		{function() loadMap("mine.tmx") end,
		 function() loadMap("mine2.tmx") end,
		 function() loadMap("mine3.tmx") end,

		 function() loadMap("temple.tmx") end,
		 function() loadMap("temple2.tmx") end,
		 function() loadMap("temple3.tmx") end,
		 function() loadMap("temple4.tmx") end,
		 function() loadMap("temple5.tmx") end,

		 function() loadMap("boxes.tmx") end},

		 function() current_menu = main_menu end
	)

	-- credits menu
	credits_menu = Menu.create(
		{"GRAPHICS AND PROGRAMMING","SIMON LARSEN","TITLE SCREEN","LUKAS HANSEN","MUSIC","XXX"},
		nil,nil
	)
	function credits_menu:draw()
		local top = (HEIGHT-self.height)/2

		lg.setColor(0,0,0,200)
		lg.rectangle("fill",(WIDTH-self.width)/2-6, top-6, self.width+12, self.height+12)
		lg.setColor(255,255,255,255)

		lg.setFont(fontBold)
		local offset = top+8
		for i=1,self.length do
			lg.printf(self.names[i], 0, offset, WIDTH, "center")
			offset = offset + 10
			if (i%2) == 0 then offset = offset + 8 end
		end
	end

	function credits_menu:keypressed(k,uni)
		current_menu = main_menu
	end
end
