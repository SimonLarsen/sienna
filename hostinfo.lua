local mod = {}

local os_string = love.system.getOS()

function mod.isTouchDevice()
	return os_string == 'Android' or os_string == 'iOS'
end

return mod
