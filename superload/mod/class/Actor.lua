local _M = loadPrevious(...)

local base_act = _M.act
function _M:act()
	print("ACTING!", self.name)
	return base_act(self)
end

return _M
