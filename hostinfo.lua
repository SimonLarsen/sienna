local api = {}

local os_string = love.system.getOS()

function api.isTouchDevice()
	return os_string == 'Android' or os_string == 'iOS'
end

return api
