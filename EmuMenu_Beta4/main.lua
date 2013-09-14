--[[
	EMUMENU			Copyright 2013 by Cole Marlar
	Music:
		Wii U Main Menu
	Images:
		Title Icons by deleket <http://deleket.deviantart.com>
		Box art from The Cover Project <http://www.thecoverproject.net>
		Consoles and logos from Wikipedia <http://www.wikipedia.org>
	
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

require "gameClass"
require "animation"

function love.load()
	gameList = {}
	emulatorList = {}

	-- NES
	gameList[1] = {}
	addGame("nesList.txt", 1)
	
	-- SNES
	gameList[2] = {}
	addGame("snesList.txt", 2)
	
	-- Genesis
	gameList[3] = {}
	addGame("genesisList.txt", 3)
	
	-- N64
	gameList[4] = {}
	addGame("n64List.txt", 4)
	
	--[[ 
		Mode 0 = Title
		Mode 1 = Console select
		Mode 2 = Game Select
	]]--
	curMode = 0
	
	centerConsole = 1
	maxConsole = table.getn(gameList)
	
	centerGame = nil
	prevGame = nil
	nextGame = nil
	
	inputDelay = 0
	
	-- animation
	menuTransition = false
	
	love.mouse.setVisible(false)
	
	button1 = love.graphics.newImage('images/Abutton.png')
	button2 = love.graphics.newImage('images/Bbutton.png')
	--button3 = love.graphics.newImage('images/XButton.png')
	button4 = love.graphics.newImage('images/Ybutton.png')
	enterKey = love.graphics.newImage('images/returnkey.png')
	backspKey = love.graphics.newImage('images/backspkey.png')
	buttonMode = 1
	arrows = love.graphics.newImage('images/arrows.png')

	consoleImage = {}
	nesConsole = love.graphics.newImage('images/nesConsole.png')	
	snesConsole = love.graphics.newImage('images/snesConsole.png')
	genConsole = love.graphics.newImage('images/genesisConsole.png')
	n64Console = love.graphics.newImage('images/n64Console.png')
	-- ps1Console = love.graphics.newImage('images/ps1Console.png')
	
	table.insert(consoleImage, nesConsole)
	table.insert(consoleImage, snesConsole)
	table.insert(consoleImage, genConsole)
	table.insert(consoleImage, n64Console)
	
	bg = love.graphics.newImage('images/background.jpg')
	title = love.graphics.newImage('images/Title.jpg')
	
	defaultFont = love.graphics.newFont('fonts/DidactGothic.ttf', 64)
	devFont = love.graphics.newFont('fonts/DidactGothic.ttf', 40)

	credits = love.graphics.newImage('images/credits.png')
	
	-- animation variables
	y = love.graphics.getHeight() / 2
	transp = 255
	
	-- music
	music = love.audio.newSource('sounds/BGmusic.ogg')
	music:setLooping(true)
	love.audio.play(music)
end
	
function love.update(dt)
	controlDir = love.joystick.getHat(1, 1)
	controlStick = love.joystick.getAxis(1, 1)

	if curMode == 1 then
		if (controlDir == "l" or controlStick <= -0.5 or love.keyboard.isDown("left")) and inputDelay >= 0.3 then
			if love.keyboard.isDown("left") then buttonMode = 2 else buttonMode = 1 end
			menuTransition = true
			if centerConsole > 1 then
				centerConsole = centerConsole - 1
				inputDelay = 0
			else
				centerConsole = maxConsole
				inputDelay = 0
			end
		end
		if (controlDir == "r" or controlStick >= 0.5 or love.keyboard.isDown("right")) and inputDelay >= 0.3 then
			if love.keyboard.isDown("right") then buttonMode = 2 else buttonMode = 1 end
			menuTransition = true
			if centerConsole < maxConsole then
				centerConsole = centerConsole + 1
				inputDelay = 0
			else
				centerConsole = 1
				inputDelay = 0
			end
		end
		if love.joystick.isDown(1,1) or love.keyboard.isDown("return") then
			if love.keyboard.isDown("return") then buttonMode = 2 else buttonMode = 1 end
			inputDelay = 0
			menuTransition = true
			resetAlpha()
			centerGame = 1
			curMode = 2
		end
		if (love.joystick.isDown(1, 2) or love.keyboard.isDown("backspace")) and inputDelay >= 0.4 then
			os.exit(0)
		end
	end
	
	if curMode == 2 then
		if centerGame == table.getn(gameList[centerConsole]) then
			prevGame = centerGame - 1
			nextGame = 1
		elseif centerGame == 1 then
			prevGame = table.getn(gameList[centerConsole])
			nextGame = centerGame + 1
		else
			prevGame = centerGame - 1
			nextGame = centerGame + 1
		end
		
		if (controlDir == "r" or controlStick >= 0.5 or love.keyboard.isDown("right")) and inputDelay >= 0.3 then
			if love.keyboard.isDown("right") then buttonMode = 2 else buttonMode = 1 end
			if centerGame < table.getn(gameList[centerConsole]) then
				centerGame = centerGame + 1
			else
				centerGame = 1
			end
			resetScale()
			inputDelay = 0
		elseif (controlDir == "l" or controlStick <= -0.5 or love.keyboard.isDown("left")) and inputDelay >= 0.3 then
			if love.keyboard.isDown("left") then buttonMode = 2 else buttonMode = 1 end
			if centerGame > 1 then
				centerGame = centerGame - 1
			else
				centerGame = table.getn(gameList[centerConsole])
			end
			resetScale()
			inputDelay = 0
		end
			
		if (love.joystick.isDown(1, 1) or love.keyboard.isDown("return")) and inputDelay >= 0.3 then
			if love.keyboard.isDown("return") then buttonMode = 2 else buttonMode = 1 end
			love.audio.pause()
			love.graphics.toggleFullscreen()
			os.execute(emulatorList[centerConsole].." "..gameList[centerConsole][centerGame]:getRomLocale())
			love.graphics.toggleFullscreen()
			love.audio.resume()
		end
		
		if love.joystick.isDown(1, 2) or love.keyboard.isDown("backspace") then
			if love.keyboard.isDown("backspace") then buttonMode = 2 else buttonMode = 1 end
			menuTransition = true
			resetAlpha()
			resetScale()
			inputDelay = 0
			curMode = 1
		end
	end
	
	if inputDelay < 1 then
		inputDelay = inputDelay + dt
	end
	
	if inputDelay > 0.3 then
		menuTransition = false
		y = love.graphics.getHeight() / 2
		transp = 255
		if curMode >= 1 then 
			resetAlpha()
		end
	end
end

function love.draw()
	love.graphics.draw(bg, 0, 0)
	
	if curMode == 0 or curMode == 1 then
		love.graphics.setFont(defaultFont)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("Select a Console", 100, 100)
		love.graphics.print("Exit", 270, love.graphics.getHeight() - 200)
		love.graphics.print("Select", love.graphics.getWidth() - 450, love.graphics.getHeight() - 200)
		love.graphics.setColor(255, 255, 255, 255)
		-- put animation transition call here
		if menuTransition == true then
			--y = menuSwitchingAnimation()
			transp = fadeInOut()
		end
		
		love.graphics.setColor(255, 255, 255, transp)
		drawCenteredImage(consoleImage[centerConsole], love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 1.4)
		love.graphics.setColor(255, 255, 255, 255)
		drawCenteredImage(arrows, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 1)
	end
	if curMode == 2 then
		-- text
		love.graphics.setFont(defaultFont)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print(gameList[centerConsole][centerGame]:getName(), 100, 100)
		love.graphics.setFont(devFont)
		love.graphics.print(gameList[centerConsole][centerGame]:getDev(), 100, 175)
		love.graphics.setFont(defaultFont)
		love.graphics.setColor(255, 255, 255, 255)
		
		-- the games
		drawCenteredImage(arrows, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 1)
		-- put animation transition call here
		if menuTransition == true then
			y = menuSwitchingAnimation()
			transp = fadeInOut()
		end
		love.graphics.setColor(255, 255, 255, transp)
		drawCenteredImage(gameList[centerConsole][prevGame]:getBoxArt(), (love.graphics.getWidth() / 2) - 400, y, 1)
		drawCenteredImage(gameList[centerConsole][nextGame]:getBoxArt(), (love.graphics.getWidth() / 2) + 400, y, 1)
		drawCenteredImage(gameList[centerConsole][centerGame]:getBoxArt(), love.graphics.getWidth() / 2, y, gameZoom())
		love.graphics.setColor(255, 255, 255, 255)	

		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.print("Back", 270, love.graphics.getHeight() - 200)
		love.graphics.print("Play", love.graphics.getWidth() - 400, love.graphics.getHeight() - 200)
		love.graphics.setColor(255, 255, 255, 255)
	end
	
	if buttonMode == 1 then
		drawCenteredImage(button1, love.graphics.getWidth() - 200, love.graphics.getHeight() - 150, 1)
		drawCenteredImage(button2, 200, love.graphics.getHeight() - 150, 1)
	elseif buttonMode == 2 then
		drawCenteredImage(enterKey, love.graphics.getWidth() - 200, love.graphics.getHeight() - 150, 1)
		drawCenteredImage(backspKey, 200, love.graphics.getHeight() - 150, 1)
	end
	
	if curMode == 0 then
		local a = introFade()
		if a <= 10 then
			resetAlpha()
			curMode = 1
		end
	end
end

function drawCenteredImage(image, x, y, scale)
	love.graphics.draw(image, x, y, 0, scale, scale, image:getWidth() / 2, image:getHeight() / 2)
end