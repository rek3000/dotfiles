local M = {} -- menu
local _M = {} -- module


local terminal = RC.vars.terminal

local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor


M.awesome = {
	{ "Terminal", terminal },
	{ "Edit config", editor_cmd .. " " .. awesome.conffile },
	{ "Restart", awesome.restart },
	{ "Quit", function() awesome.quit() end },
}

function _M.get()
	local menu_items = {
		{ "Terminal", terminal },
		{ "Edit config", editor_cmd .. " " .. awesome.conffile },
		{ "Restart", awesome.restart },
		{ "Quit", function() awesome.quit() end },
	}
	
	return menu_items
end

return setmetatable(
	{},
	{ __call = function(_, ...) return _M.get(...) end }
)
