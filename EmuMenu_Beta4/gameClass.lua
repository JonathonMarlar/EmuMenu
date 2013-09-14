--[[
	EMUMENU			Copyright 2013 by Cole Marlar
	gameClass.lua
	
	This file is part of EmuMenu.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.	
]]--


--[[ 
	This function acts as a class to create objects of Game type 
	All parameters are strings
]]--
function Game(name, dev, boxart, romlocation)
	local obj = { name = name, dev = dev, boxart = love.graphics.newImage(boxart), romlocation = romlocation }
	function obj:getName()
		return self.name
	end
	function obj:getDev()
		return self.dev
	end
	function obj:getBoxArt()
		return self.boxart
	end
	function obj:getRomLocale()
		return self.romlocation
	end
	return obj
end

--[[ 
	This function will add the emulator/games to the appropriate list(s) 
	filename is a string and listNumber is any positive integer from 1 to n
]]--
function addGame(filename, listNumber)
	tmpTitle = nil
	tmpDev = nil
	tmpImg = nil
	tmpDir = nil
	
	lineMode = -1
	
	for line in io.lines(filename) do
		if lineMode == 1 then
			tmpTitle = line
		elseif lineMode == 2 then
			tmpDev = line
		elseif lineMode == 3 then
			tmpImg = line
		elseif lineMode == 4 then
			tmpDir = line
			table.insert(gameList[listNumber], Game(tmpTitle, tmpDev, tmpImg, tmpDir))
			lineMode = 0
		elseif lineMode == -1 then
			table.insert(emulatorList, line)
			lineMode = 0
		end	
		lineMode = lineMode + 1
	end
end