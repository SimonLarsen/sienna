LevelSelection = {selected = 1}

local positions = {
	{51,182},
	{101,172},
	{152,174},
	{221,167},
	{190,132},
	{140,115},
	{179,85},
	{235,73},
	{286,63}
}

local lg = love.graphics

function LevelSelection.draw()
	lg.drawq(imgLevels, quads.title, 0,0, 0, WIDTH/900)

	lg.setLineWidth(4)
	lg.setColor(0,0,0)
	for i=1,8 do
		lg.line(positions[i][1],positions[i][2], positions[i+1][1], positions[i+1][2])
	end

	lg.setLineWidth(2)
	lg.setColor(COLORS.darkblue)
	for i=1,unlocked-1 do
		lg.line(positions[i][1],positions[i][2], positions[i+1][1], positions[i+1][2])
	end
	lg.setColor(COLORS.yellow)
	for i=unlocked,8 do
		lg.line(positions[i][1],positions[i][2], positions[i+1][1], positions[i+1][2])
	end

	lg.setColor(0,0,0,200)
	lg.rectangle("fill",9,9, 95,55)

	lg.setColor(255,255,255)

	for i=1,9 do
		if i <= unlocked then
			lg.drawq(imgHUD, quads.level_unlocked, positions[i][1]-8, positions[i][2]-8)
		else
			lg.drawq(imgHUD, quads.level_locked, positions[i][1]-8, positions[i][2]-8)
		end
	end
	lg.drawq(imgHUD, quads.level_selected, positions[LevelSelection.selected][1]-10, positions[LevelSelection.selected][2]-10)

	lg.drawq(imgHUD, quads.hud_coin, 19,13)
	lg.print("2/5", 36,16)
	lg.drawq(imgHUD, quads.hud_skull, 15,30)
	lg.print("28", 36,33)
	lg.drawq(imgHUD, quads.hud_clock, 17,47)
	lg.print("1:23", 36,50)
end

function LevelSelection.keypressed(k, uni)
	if k == "right" or k == "up" then
		LevelSelection.selected = math.min(LevelSelection.selected + 1, unlocked)
		love.audio.play(snd.Blip)
	elseif k == "left" or k == "down" then
		LevelSelection.selected = math.max(LevelSelection.selected-1, 1)
		love.audio.play(snd.Blip)
	elseif k == "return" then
		loadMap(LevelSelection.selected)
	elseif k == "escape" then
		gamestate = STATE_MAINMENU
	end
end
