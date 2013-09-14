--[[
	EMUMENU			Copyright 2013 by Cole Marlar
	animation.lua
	
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

local fadeDelay = 3
local alpha = 255

-- console animation variables
--local consoleX = love.graphics.getWidth() / 2
--local defaultX = consoleX
--local conLeft = false
--local conRight = false

local fadeY = love.graphics.getHeight()
local scale = 1

local backgroundX = 0

function resetAlpha()
	alpha = 0
	fadeY = love.graphics.getHeight()
end

function resetScale()
	scale = 1
end

function introFade()	
	fadeDelay = fadeDelay - love.timer.getDelta()
	if fadeDelay <= 0 then
		alpha = alpha - (300 * love.timer.getDelta())
	end
	
	love.graphics.setColor(255, 255, 255, alpha)
	love.graphics.draw(title, 0, 0)
	love.graphics.setColor(255, 255, 255, 255)
	
	return alpha
end

function menuSwitchingAnimation()
	fadeY = fadeY - ( 1800 * love.timer.getDelta() )
	
	return fadeY
end

function fadeInOut()
	alpha = alpha + (780 * love.timer.getDelta())
	
	return alpha
end

function gameZoom()
	if scale < 1.4 then
		scale = scale + (1.2 * love.timer.getDelta())
	end
	return scale
end

function loopBackground(image)
	backgroundX = backgroundX - (100 * love.timer.getDelta())
	if backgroundX <= -love.graphics.getWidth() then
		backgroundX = 0
	end
	
	love.graphics.setColor(255, 255, 255, 25)
	love.graphics.draw(image, backgroundX, 0)
	love.graphics.draw(image, backgroundX + love.graphics.getWidth(), 0)
	love.graphics.setColor(255, 255, 255, 255)
end