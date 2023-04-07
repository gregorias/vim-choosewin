local M = {}

local function viml_spec_to_lua_spec(viml_spec)
	return {
		fg = viml_spec.gui[2],
		bg = viml_spec.gui[1],
		ctermfg = viml_spec.cterm[2],
		ctermbg = viml_spec.cterm[1],
		bold = viml_spec.gui[3] and viml_spec.gui[3]:find("bold") ~= nil,
		underline = viml_spec.gui[3] and viml_spec.gui[3]:find("underline") ~= nil,
	}
end

-- Returns the highlight groups for Choosewin.
local function get_colors()
	local config = vim.fn["choosewin#config#get"]()
	local colors = {
		ChooseWinLabel = config["color_label"],
		ChooseWinLabelCurrent = config["color_label_current"],
		ChooseWinOverlay = config["color_overlay"],
		ChooseWinOverlayCurrent = config["color_overlay_current"],
		ChooseWinShade = config["color_shade"],
		ChooseWinLand = config["color_land"],
		ChooseWinOther = config[config.label_fill and "color_label" or "color_other"],
	}
	for color, spec in pairs(colors) do
		colors[color] = viml_spec_to_lua_spec(spec)
	end
	return colors
end

-- Sets highlight groups.
function M.set()
	for color, spec in pairs(get_colors()) do
		vim.api.nvim_set_hl(0, color, spec)
	end
end

-- Clears highlight groups.
function M.clear()
	for color, _ in pairs(get_colors()) do
		vim.api.nvim_set_hl(0, color, {})
	end
end

return M
