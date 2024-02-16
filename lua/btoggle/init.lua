local M = {}

M._replacements = {
	["true"] = "false",
	["True"] = "False",
	["false"] = "true",
	["False"] = "True",
}

M.setup = function(replacements)
	if replacements and next(replacements) ~= nil then
		M._replacements = replacements
	end
end

M.toggle = function()
	local line = vim.api.nvim_get_current_line()
	local cursor = vim.api.nvim_win_get_cursor(0) -- 0 == current window
	local posInLine = cursor[2]

	local sow,eow,replacement = M._search_replacement(line, posInLine)
	local replaced = M._replace(line, sow,eow, replacement);

	if (line ~= replaced) then
		vim.api.nvim_set_current_line(replaced)
		return;
	end
end

--- Searches which word should be replaced
--- returns the start and end to be cut out of @param line and which replacement 
--- word should be inserted instead
---@param line string
---@param cursor_pos integer
---@return integer startIndex index of the beginning of the found word to replace
---@return integer endIndex index of the end of the found word to replace
---@return string  replacementString the replacement word
M._search_replacement = function (line, cursor_pos)
	local matches = {}
	for k,v in pairs(M._replacements) do
		local s,e;
		e = 0
		while e do
			s,e = string.find(line, k, e)
			if (s) then
				table.insert(matches, s, { e,k,v })
			end
		end;
	end

	if next(matches) == nil then
		return -1,-1,""
	end

	-- sort found word starts 
	local tkeys = {}
	for k in pairs(matches) do table.insert(tkeys, k) end
	table.sort(tkeys)

	-- search nearest match after cursor position
	-- or if none found use the last match before the cursor position
	local lastBefore
	for _,startOfWord in ipairs(tkeys) do
		local endOfWord = matches[startOfWord][1]
		if (endOfWord > cursor_pos) then
			return  startOfWord, endOfWord, matches[startOfWord][3]
		end
		lastBefore = startOfWord
	end

	return  lastBefore, matches[lastBefore][1], matches[lastBefore][3]
end

M._replace = function(line, sow, eow, replacement)
	if sow < 0 or sow == nil  then
		return line
	end

	local start = string.sub(line, 1, sow -1 )
	local endl  = string.sub(line,eow +1, string.len(line))
	return start .. replacement .. endl
end

return M
