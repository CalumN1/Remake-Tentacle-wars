io.stdout:setvbuf('no')

require "levels"  -- separate file, do this for each seperate file, not conf or main tho

--https://love2d.org/wiki/Optimising


-- This function gets called only once, when the game is started, and is usually where you would load resources, initialize variables and set specific settings. 
-- All those things can be done anywhere else as well, but doing them here means that they are done once only, saving a lot of system resources
function love.load()
	arenaWidth = 1440
	arenaHeight = 1080 -- changing this doesnt do anything? need to at least change conf file too

	levelNodesTable = levelNodes(arenaWidth,arenaHeight)
	levelWallsTable = levelWalls(arenaWidth,arenaHeight)
	levelPowerLimitsTable = levelPowerLimits()

	game_background = love.graphics.newImage('TwarsBackgroundClean.png')
	menu_background = love.graphics.newImage('TwarsMenuBackgroundClean.png')
	--preview_background = love.graphics.newImage('TwarsBackgroundClean.png',{false,false,5})

	current_background = game_background

	image_QuitMenuButton = love.graphics.newImage('QuitMenuButton.png')
	image_MuteButton = love.graphics.newImage('MuteButton.png')
	image_PauseButton = love.graphics.newImage('PauseButton.png')
	image_ResetButton = love.graphics.newImage('ResetButton.png')

	--love.filesystem.append("custom_levels", "hello" )

	customLevelContents, size = love.filesystem.read( 'custom_levels', 5000 )
	print(customLevelContents, love.filesystem.getIdentity( ), love.filesystem.getSaveDirectory( ))


	customLevels = {}
	loadMenu = false
	saveMenu = false
	levelDoneMenu = false

	error = {status = false, message = "no error yet"}
	
	love.keyboard.setTextInput( false )
	love.keyboard.setKeyRepeat(true)
	inputText = ""
	allowed_chars = "abcdefghijklmnopqrstuvwxyz 1234567890!#?:."


	cursor = love.mouse.getSystemCursor("hand")

	currentLevel = 100 -- 0 means menu, 100+ = custom level
	powerLimit = 200
	sessionTimer = 0
	timer = 0

	godModeON = false
	AION = true
	editor = false
	createMicrobe = true
	dragging = false --still used?
	pause = false

	editPower = 10
	editTeam = 2
	editorSelected = {node = true, index = 0}

	menuWigglerSeed = {}

	mousePosDelay = {x=0,y=0} --index = how many seconds ago it was there
	mouseDelayTimer = 0
	mouseEffectPoints = {{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0}}

	love.graphics.setBackgroundColor( 0., 0.1, 0.)

	font14 = love.graphics.newFont(14)
	nodefont27 = love.graphics.newFont('Fonts/editundo.ttf', 27, 'none',1)
	nodefont38 = love.graphics.newFont('Fonts/editundo.ttf', 38, 'none',1)
	titlefont = love.graphics.newFont('Fonts/Pulp Fiction M54.ttf', 120, 'none',1)
	levelDonefont = love.graphics.newFont('Fonts/Pulp Fiction M54.ttf', 50, 'none',1)
	monofont = love.graphics.newFont('Fonts/PWTHMSEG.ttf', 19, 'none',1)
	font21 = love.graphics.newFont(21)
	font30 = love.graphics.newFont(30)


	nodeCentreRadius = 26
	--nodeRadius = 36  -- outer ring, will vary, changing for nodeTiers[node.tier].radius

	linkRadius = 7
	linkSpacing = 10

	nodeSelected = 0
	pointSelected = {x = 0, y = 0}

	deliverySpeed = 0.1 --seconds before moving forward
	deliveryTimer = 0

	cutSource = {
		--x = 5
		-- y = 10
	}

	FPSlogicTarget = 160 --forced FPS otherwise speeds change, maybe adjust speeds relative to FPS later?
	FPSlogicActual = 0 --actual logic per second
	FPSlogicTimer = 0

	tickCount = 0

	tickPeriod = 1/50 -- seconds per tick
	accumulator = 0.0

	nodes = {
		{
			x = 50,
			y = 150,
			team = 2,  -- team starts from 1 for teamColours[team] to make sense, 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
			population = 180,
			tier = 1,
			regenTimer = 5,
			tentaclesUsed = 0,
			effectTimer = 0, 
			neutralPower = 20,
			neutralTeam = 1
			-- regen Delay comes from the tiers table now
		},
		{
			x = arenaWidth -50, 
			y = 150,
			team = 1,
			population = 0,
			tier = 2,
			regenTimer = 5,
			tentaclesUsed = 0,
			effectTimer = 0, 
			neutralPower = 20,
			neutralTeam = 1
		},
		{
			x = 50,
			y = arenaHeight - 200,
			team = 1,
			population = 0,
			tier = 3,
			regenTimer = 5,
			tentaclesUsed = 0,
			effectTimer = 0, 
			neutralPower = 20,
			neutralTeam = 1
		},
		{
			x = arenaWidth -50,
			y = arenaHeight - 200,
			team = 1,
			population = 0,
			tier = 4,
			regenTimer = 5,
			tentaclesUsed = 0,
			effectTimer = 0, 
			neutralPower = 20,
			neutralTeam = 1
		},
		{
			x = arenaWidth / 1.5,
			y = arenaHeight - 200,
			team = 3,
			population = 50,
			tier = 5,
			regenTimer = 5,
			tentaclesUsed = 0,
			effectTimer = 0, 
			neutralPower = 20,
			neutralTeam = 1
		},
		{
			x = arenaWidth - 200,
			y = arenaHeight - 500,
			team = 3,
			population = 20,
			tier = 6,
			regenTimer = 5,
			tentaclesUsed = 0,
			effectTimer = 0, 
			neutralPower = 20,
			neutralTeam = 1
		},
	}

	--[[nodes = {}
	for nodeIndex, node in ipairs(editorNodes) do 
		table.insert(nodes, node) 
	end]]
	editorSaveState = {
		--{
			--team, population, ?
		--}

	}

	walls = {
		{
			startX = arenaWidth/2,
			startY = 500,
			endX = 50,
			endY = arenaHeight/2
		},
		{
			startX = arenaWidth/3,
			startY = 900,
			endX = arenaWidth/2,
			endY = 600
		}


	}

	connections = {
	   --[[ {
			population = 2,
			team = 1,
			moving = false,
			source = 2,
			sourceEdge = {
				x = 200,
				y = 200
			},
			target = 3,
			targetEdge = {
				x = 200,
				y = 200
			},
			tentacleEnd = {
				x = 200,
				y = 200
			},
			connectionMidPoint = {
				x = 200,
				y = 200
			},
			linkXStep = 23,
			linkYStep = 10,
			links = {
				{
					x = 200,
					y = 200
				}
			},
			destination = 2,  -- 0 = source, 1 = mid point, 2 = target, 3 = split so source and target
			opposedConnectionIndex= 0, -- 0 means no opposed connection
			splitLink = 0, -- 0 means no split
			glowing = {},
			sendTimer
		}]]
	}

	previewNodes = {}
	previewWalls = {}

	teamColours = {
		{0.7, 0.7, 0.7, 1},
		{0.1, 0.7, 0.1, 1},
		{0.7, 0.2, 0.2, 1},
		{0, 0, 0, 1},
		{0.7, 0.2, 0.7, 1}
	}

	darkerTeamColours = { --not used
		{0.6, 0.6, 0.6, 1},
		{0.0, 0.6, 0.0, 1},
		{0.6, 0.1, 0.1, 1},
		{0,0,0, 1},
		{0.5, 0, 0.5, 1}
	}

	--used in node display
	nodeDisplayTeamColours = {
		{1, 1, 0.6, 1},
		{0.3, 1, 0.3, 1},
		{1, 0.3, 0.3, 1},
		{1, 1, 1, 1}, --white
		{0.7, 0, 0.7, 1}
	}


	nodeTiers = { --Tiers change when the population exceeds the min or max
		--node.tier is the index of the relevant ranges
		-- In the game, lower tiers generate faster
		{name = "SPORE", min = -20, max = 14, radius = 33, regenDelay =  2, sendDelay = 1.8, maxTentacles = 1}, -- spore regen 40s: 0 tents: 1/1.5	 1:	1/2	2:-		delivery:	23 in 40s  -delivery is the per tentacle rate and does not vary
		{name = "EMBRYO", min = 6, max = 39, radius = 36, regenDelay =  2.4, sendDelay = 1.2, maxTentacles = 2}, -- embryo				17			9		4				37
		{name = "PULSAR-A", min = 31, max = 79, radius = 43, regenDelay =  2.5, sendDelay = 1, maxTentacles = 2},	-- pulsar-A				15			7		3				49
		{name = "PULSAR-B", min = 61, max = 119, radius = 51, regenDelay =  3, sendDelay = 1, maxTentacles = 2},	-- pulsar-B				13			7		4				72
		{name = "ANT", min = 101, max = 159, radius = 60, regenDelay =  4, sendDelay = 0.5, maxTentacles = 3},	-- Ant				9			5		2				109
		{name = "PREDATOR", min = 141, max = 220, radius = 72, regenDelay = 5, sendDelay = 0.15, maxTentacles = 3}	-- Predator				7			5		1				260: ~66 in 10s, 130 in 20s -  delay per tents: 0=5, 1=10, 2=20
	}	-- regen halfs per tentacle roughly

	allButtons = {
		{name = "Menu", x=40,y=arenaHeight-30, width=20, height=20, shape = "circle" }, 
		{name = "Mute", x=95,y=arenaHeight-30, width=20, height=20, shape = "circle" },
		{name = "Pause", x=150,y=arenaHeight-30, width=20, height=20, shape = "circle" },
		{name = "Reset", x=205,y=arenaHeight-30, width=20, height=20, shape = "circle" },   -- circle
		{name = "God", x=arenaWidth*0.7,y=80, width=50, height=30, shape = "rectangle"},
		{name = "AI", x=arenaWidth*0.8,y=80, width=50, height=30, shape = "rectangle"},
		{name = "Complete", x=arenaWidth*0.5, y=20, width=80, height=30, shape = "rectangle"},
		{name = "Unlock", x=arenaWidth*0.5, y=20, width=80, height=30, shape = "rectangle"},
		{name = "Editor", x=arenaWidth/2-60,y=arenaHeight/2, width=130, height=33, shape = "text"}, 
		--10 vv
		{name = "CreateX", x=2,y=2, width=256, height=60, shape = "rectangle"}, 
		{name = "MicrobeTeam", x=80,y=170, width=200, height=30, shape = "rectangle"}, 
		{name = "PowerSlider", x=80,y=220, width=200, height=20, shape = "rectangle"}, 
		{name = "DeleteX", x=80,y=270, width=200, height=30, shape = "rectangle"}, 
		{name = "Test&Edit", x=arenaWidth*0.9, y=arenaHeight-30, width=80, height=30, shape = "rectangle"},
		{name = "Create Microbe", x=0,y=140, width=260, height=40, shape = "rectangle"}, 
		{name = "Create Wall", x=0,y=180, width=260, height=40, shape = "rectangle"}, 
		{name = "Green", x=80,y=200, width=200, height=30, shape = "rectangle"}, 
		{name = "Red", x=80,y=230, width=200, height=30, shape = "rectangle"},
		{name = "Black", x=80,y=260, width=200, height=30, shape = "rectangle"}, 
		--20vv
		{name = "Purple", x=80,y=290, width=200, height=30, shape = "rectangle"}, 
		{name = "Neutral", x=80,y=320, width=200, height=30, shape = "rectangle"}, 
		{name = "Overright", x=arenaWidth*0.8,y=arenaHeight-30, width=50, height=30, shape = "rectangle"},
		{name = "Save As", x=arenaWidth*0.7,y=arenaHeight-30, width=50, height=30, shape = "rectangle"},
		{name = "Load", x=arenaWidth*0.6,y=arenaHeight-30, width=50, height=30, shape = "rectangle"},
		{name = "Confirm", x=arenaWidth*0.4,y=arenaHeight*0.4, width=50, height=30, shape = "rectangle"}, 
		{name = "Menu", x=arenaWidth/2-35,y=arenaHeight/1.85, width=70, height=33, shape = "text"}, 
		{name = "Continue", x=arenaWidth/2-60,y=arenaHeight/1.7, width=120, height=33, shape = "text"},  

		{name = 1, x= arenaWidth/2+330*(math.sin(2*math.pi*0/20)),  y= arenaHeight/2+50-330*(math.cos(2*math.pi*0/20)), width=35, height=35, shape = "circle"}
	}
	--editor, unlock, and level 1, and adds the other levels later
	menuButtons = {allButtons[8], allButtons[9], allButtons[#allButtons]}



	-- all level buttons
	for i = 1, 19 do
		table.insert(allButtons , {name = i+1, x= arenaWidth/2+270*(math.sin(2*math.pi*i/20)),  y= arenaHeight/2+50-270*(math.cos(2*math.pi*i/20)), width=35, height=35, shape = "circle"})
		table.insert(menuButtons, allButtons[#allButtons])
	end

	-- 4 standard and my extra ones -complete, AI, God
	controlBarButtons = {allButtons[1], allButtons[2], allButtons[3],allButtons[4], allButtons[5], allButtons[6],allButtons[7]}

	editorButtons = {allButtons[1], allButtons[2], allButtons[3],allButtons[4], allButtons[10], allButtons[14], allButtons[22], allButtons[23], allButtons[24] } --allButtons[11], allButtons[12],allButtons[13],

	buttonsOnScreen = { 
		{name = "Menu", x=40,y=arenaHeight-30, width=20, height=20, shape = "circle" }, 
		{name = "Mute", x=95,y=arenaHeight-30, width=20, height=20, shape = "circle" },
		{name = "Pause", x=150,y=arenaHeight-30, width=20, height=20, shape = "circle" },
		{name = "Reset", x=205,y=arenaHeight-30, width=20, height=20, shape = "circle" }, 
		{name = "God", x=arenaWidth*0.7,y=30, width=50, height=30, shape = "rectangle"}, 
		{name = "AI", x=arenaWidth*0.8,y=80, width=50, height=30, shape = "rectangle"},
		{name = "Complete", x=arenaWidth*0.5, y=20, width=80, height=30, shape = "rectangle"} 
	}

	outerLevelPositions = {}

	for i = 0, 19 do
		table.insert(outerLevelPositions, {x = arenaWidth/2+330*(math.sin(2*math.pi*i/20)),  y = arenaHeight/2+50-330*(math.cos(2*math.pi*i/20)) } )
	end

	innerLevelPositions = {}

	for i = 0, 19 do
		table.insert(innerLevelPositions, {x = arenaWidth/2+270*(math.sin(2*math.pi*i/20)),  y = arenaHeight/2+50-270*(math.cos(2*math.pi*i/20)) } )
	end


	levelProgress = {1,3,3,3,3, 3,3,3,3,3, 3,3,3,3,3, 3,3,3,3,3} -- 1 = unlocked, 2 = completed, 3 = locked --to match team colours

	-- OLD:  -- distance between node 1 and 2 can be found as nodeDistances[1][2] or nodeDistances[2][1], [1][1] is always 0, walls will make it 7000

	-- NEW: table [1] is the distances from node 1 in order of distance, {distance, targetNode}. so when AI is looking at node 1's options look at if the distance: nodeDistances[1][1][2] is acceptable then create connection to node: nodeDistances[1][1][1]
	-- nodeDistances[1][1][2] means nodeDistances[the source node = 1] [1 = check the closest node] [2 = the distance]
	-- and nodeDistances[#nodeDistances] [#nodeDistances[1]] [1] means nodeDistances[the last node] [the furtherest away node from it] [that node's index]
	-- unreachable nodes including the node itself are simply not included here and thereffor never considered as a target
	nodeDistances = { 
			--[[ {  {2,261},{4,300},{3,500} },
		{  {1,261},{4,350},{3,400} },     etc    ]]
	}
	calculateNodeDistances()


	function isMouseInButton()
		
		for buttonIndex = #buttonsOnScreen, 1, -1 do
			local button = buttonsOnScreen[buttonIndex]
			if button.shape == "rectangle" or button.shape == "text" then
				if math.abs(love.mouse.getX() - (button.x+button.width/2)) < button.width/2 and math.abs(love.mouse.getY() - (button.y+button.height/2)) < button.height/2 then
					--print(button.name, " button pressed")
					return buttonIndex
				end
			else --circle
				if distancebetween(love.mouse.getX(), love.mouse.getY(), button.x, button.y) < button.width+5 then
					--print(button.name, " button pressed")
					--print(buttonIndex, distancebetween(love.mouse.getX(), love.mouse.getY(), button.x, button.y))
					return buttonIndex
				elseif loadMenu and type(button.name) ~= "string" then
					if distancebetween(love.mouse.getX(), love.mouse.getY(), outerLevelPositions[button.name].x, outerLevelPositions[button.name].y)  < button.width+5 then
						return buttonIndex
					end
				end
			end

		end

		return 0
		-- return button selected
	end


	function isMouseInNode()
		
		for nodeIndex, node in ipairs(nodes) do
			--print( node.x, node.y)
			if distancebetween(love.mouse.getX(), love.mouse.getY(), node.x, node.y) < nodeTiers[node.tier].radius+10 then
				return nodeIndex
			end

		end

		return 0

		-- return nodeSelected
	end

	function isMouseInWall()
		--for the editor, moving walls
		for wallIndex, wall in ipairs(walls) do
			--print( node.x, node.y)
			if distancebetween(love.mouse.getX(), love.mouse.getY(), wall.startX, wall.startY) < 70 then
				--print(button.name, " button pressed")
				return wallIndex, "start"
			elseif  distancebetween(love.mouse.getX(), love.mouse.getY(), wall.endX, wall.endY) < 70 then
				--print(button.name, " button pressed")
				return wallIndex, "end"
			end

		end
		return 0
	end



end

function distancebetween(x1,y1,x2,y2)

	return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)

end


function findIntersectionPoint(x1, y1, x2, y2, x3, y3, x4, y4)
	-- Calculate the differences
	local dx1 = x2 - x1
	local dy1 = y2 - y1
	local dx2 = x4 - x3
	local dy2 = y4 - y3
	
	-- Calculate the determinants
	local det = dx1 * dy2 - dy1 * dx2
	
	-- If the determinant is zero, the lines are parallel
	if det == 0 then
		return nil, nil -- No intersection
	end
	
	-- Calculate the parameters for the intersection point
	local u = ((x3 - x1) * dy2 - (y3 - y1) * dx2) / det
	local v = ((x3 - x1) * dy1 - (y3 - y1) * dx1) / det
	
	-- Check if the intersection point is within both line segments
	if u < 0 or u > 1 or v < 0 or v > 1 then
		return nil, nil -- No intersection within the bounds of the segments
	end
	
	-- Calculate the intersection point
	local ix = x1 + u * dx1
	local iy = y1 + u * dy1
	
	return ix, iy
end




function calculateSteps(x1,y1,x2,y2, extraSpacing)
	-- ratio of lengths: source to point vs source to end
	local ratio = (2*linkRadius+linkSpacing+extraSpacing)/(distancebetween(x1,y1,x2,y2)) -- e.g. 1/15
	print("ratio: ", ratio)
	local xStep = (x2 - x1)*ratio
	print("xStep: ", xStep)
	local yStep = (y2 - y1)*ratio

	return {x = xStep, y = yStep}


end


function calculateSourceYAngleAny(source, target)

	local longXOpposite = (source.x - target.x )
	local longYAdjacent = (source.y - target.y )

	local sourceAngle = math.atan(longXOpposite/longYAdjacent)+math.pi/2

	if longYAdjacent < 0 then
		sourceAngle = sourceAngle + math.pi
	end

	return sourceAngle

end

function calculateSourceYAngle(sourceNode, targetNode)

	local longXOpposite = (nodes[sourceNode].x - nodes[targetNode].x ) --this is the difference between above and  this, this one is for nodes: nodes[target] 
	local longYAdjacent = (nodes[sourceNode].y - nodes[targetNode].y )

	local sourceAngle = math.atan(longXOpposite/longYAdjacent)+math.pi/2

	if longYAdjacent < 0 then
		sourceAngle = sourceAngle + math.pi
	end

	return sourceAngle

end

function calculateNodeEdges(sourceNode, targetNode)

	-- triangles, trigonometry, hope it works!
	-- given 2 points with nodes

	local longHypot = distancebetween(nodes[sourceNode].x, nodes[sourceNode].y, nodes[targetNode].x, nodes[targetNode].y)
	local longXOpposite = math.abs(nodes[sourceNode].x - nodes[targetNode].x )
	local longYAdjacent = math.abs(nodes[sourceNode].y - nodes[targetNode].y )

	local sourceAngle = math.asin(longXOpposite/longHypot)

	local shortSourceHypot = nodeTiers[nodes[sourceNode].tier].radius
	local shortSourceXOpposite = shortSourceHypot * math.sin(sourceAngle)
	local shortSourceYAdjacent = shortSourceHypot * math.cos(sourceAngle)

	local shortTargetHypot = nodeTiers[nodes[targetNode].tier].radius
	local shortTargetXOpposite = shortTargetHypot * math.sin(sourceAngle)
	local shortTargetYAdjacent = shortTargetHypot * math.cos(sourceAngle)

	-- source
	if (nodes[sourceNode].x < nodes[targetNode].x) then
		sourceX = nodes[sourceNode].x + shortSourceXOpposite
	else
		sourceX = nodes[sourceNode].x - shortSourceXOpposite
	end

	if (nodes[sourceNode].y < nodes[targetNode].y) then
		sourceY = nodes[sourceNode].y + shortSourceYAdjacent
	else
		sourceY = nodes[sourceNode].y - shortSourceYAdjacent
	end


	-- target
	-- reverse of source
	if (nodes[sourceNode].x < nodes[targetNode].x) then
		targetX = nodes[targetNode].x - shortTargetXOpposite
	else
		targetX = nodes[targetNode].x + shortTargetXOpposite
	end

	if (nodes[sourceNode].y < nodes[targetNode].y) then
		targetY = nodes[targetNode].y - shortTargetYAdjacent
	else
		targetY = nodes[targetNode].y + shortTargetYAdjacent
	end



	--print("targetX: ",targetX, "   targetY: ", targetY)

	return {sourceX = sourceX, sourceY = sourceY, targetX = targetX, targetY = targetY}



end


function love.update(dt)

	 -- trying to force a locked logic rate e.g. 120 updates per second, as sometimes predator sends 3 or 1 instead of 2 in a row. turning off vsync gets fps to 500! not 165 and causes things like tentacles to move faster. tricky
	sessionTimer = sessionTimer + dt

	if not levelDoneMenu then
		timer = timer + dt
	end

	if FPSlogicTimer > 1 then
		FPSlogicTimer = 0
		tickCount = 0
	end
	FPSlogicTimer = FPSlogicTimer + dt

	
	
	accumulator = accumulator + dt  -- this will balance for lag spikes with a speed up afterwards, theres a check at the end for if the accumulator gets too high causing the game to be superfast for too long
	if accumulator > 1/FPSlogicTarget then --main program within this if, can only run target

		tickCount = tickCount + 1
		
		if FPSlogicTimer >0.6 then
			FPSlogicActual = math.floor(tickCount/FPSlogicTimer+0.5)
		end

		--print(tickCount, FPSlogicActual)

		--pause 
		if not pause and (#nodes > 0 or #walls > 0) and not loadMenu and not saveMenu then

			deliveryTimer = deliveryTimer - 1/FPSlogicActual

			for connectionIndex, connection in ipairs(connections) do
				if connection.moving == false and nodes[connection.source].population > 4 then
					connection.sendTimer = connection.sendTimer - 1/FPSlogicActual
				end
			end

			--mouse effects
			if FPSlogicTimer > 0.1*(mouseDelayTimer%10) then
				for timercounter = 10, 2 do
					mousePosDelay[timercounter] = mousePosDelay[timercounter-1]
				end
				mousePosDelay[1] = {x = love.mouse.getX(), y = love.mouse.getY()}
				mouseDelayTimer = mouseDelayTimer+1

				for pointIndex, points in ipairs(mouseEffectPoints) do
					points = {points.x + (mousePosDelay.x - points.x)/40 , points.y + (mousePosDelay.y - points.y)/40}
				end
			end



			-- regen

			--node regen timer and ping effect countdown
			for nodeIndex, node in ipairs(nodes) do
				if node.team > 1 and not editor then
					node.regenTimer = node.regenTimer - dt
				end
				if node.effectTimer > 0 then
					node.effectTimer = node.effectTimer - dt
				end
				
			end


			-- each node's regenTimer - counts down (above), and when at 0 gains 1 population. Then the Timer gets set to the regenDelay and counts down again
			for nodeIndex, node in ipairs(nodes) do
				if node.team > 1 then
					if node.regenTimer < 0 then --regentimer updates EVERY loop not every logic update
						if node.population < 5 then
							node.regenTimer = nodeTiers[node.tier].regenDelay
						else	
							node.regenTimer = nodeTiers[node.tier].regenDelay*(2^node.tentaclesUsed)
							--print(2^node.tentaclesUsed)
						end
						node.population = node.population +1
					end
				else
					--neutral occupation
					--[[if node.population >= math.floor(node.neutralPower/3) then
						node.team = node.neutralTeam
					end]]


				end

				tierChange(node)

				if node.population > powerLimit then
					node.population = powerLimit
				elseif node.population < -5 then
					node.population = 0
				end
			end

			-- editor moving a node
			if love.mouse.isDown(1) and nodeSelected > 0 and editor then
				nodes[nodeSelected].x = love.mouse.getX()
				nodes[nodeSelected].y = love.mouse.getY()

				pointSelected = {x = 0, y = 0}
			elseif nodeSelected == 0 then
				--pointSelected = {x = love.mouse.getX(), y = love.mouse.getY()}
			end

			--draggin
			--local buttonSelected = isMouseInButton()
			if editor and love.mouse.isDown(1) and dragging then
				--if buttonsOnScreen[buttonSelected].name == "PowerSlider" then
				
				editPower = love.mouse.getX()-88 -- 8 offset to centre the slider itself on the mouse
				if editPower < 0 then
					editPower = 0
				elseif editPower > powerLimit then
					editPower = powerLimit
				end
				if editorSelected.index > 0 and editorSelected.node then
					if nodes[editorSelected.index].team > 1 then
						nodes[editorSelected.index].population = editPower
					else
						nodes[editorSelected.index].neutralPower = editPower
						if nodeTiers[nodes[editorSelected.index].tier].max < editPower then
							nodes[editorSelected.index].tier = nodes[editorSelected.index].tier + 1
						elseif nodeTiers[nodes[editorSelected.index].tier].min > editPower then
							nodes[editorSelected.index].tier = nodes[editorSelected.index].tier - 1
						end
					end
				end
				--end
			end

			--editor wall moving, stops overlap from moving node and wall at once
			if editor and love.mouse.isDown(1) and nodeSelected < 1 then
				local wallSelected, pos = isMouseInWall()

				if wallSelected > 0 then
					if pos == "start" then
						walls[wallSelected].startX = love.mouse.getX()
						walls[wallSelected].startY = love.mouse.getY()
					else
						walls[wallSelected].endX = love.mouse.getX()
						walls[wallSelected].endY = love.mouse.getY()
					end
				end
			end

			
			
			-- move this to run only when a cut, node-loss, or new connection is made
			checkOpposedConnections()

			nodeRepulsion()

			if levelDoneMenu == false and not editor and not saveMenu and not loadMenu then
				checklevelDone()
			end

			if editor then
				love.keyboard.setTextInput( true )
			else
				love.keyboard.setTextInput( false )
			end
			
			updateMovingConnections() --main update processes

			if AION and not editor and timer > 5  and (timer-0.3) % 4.8  < 1/FPSlogicTarget then	--ie AI ON
				enemyAI()
			end

			glowDelivery()

		else -- i.e. paused
			--nothing? will unpause in the mouse pressed function
		end

		checkHover()


		accumulator = accumulator - 1/FPSlogicTarget
		if FPSlogicActual < FPSlogicTarget and timer > 5 then
			if love.timer.getFPS( ) > FPSlogicTarget/2 and love.timer.getFPS( ) < FPSlogicTarget and FPSlogicTarget > 20 then
				FPSlogicTarget = FPSlogicTarget/2
			end
		elseif love.timer.getFPS( ) >= FPSlogicTarget and timer % 10 < 0.2 and FPSlogicTarget < 90 then
			FPSlogicTarget = FPSlogicTarget *2
		end

		if accumulator > 1 then		--limit catchup
			accumulator = 1
		end
	end
end

function checklevelDone()

	local playerXEnemy = { 0,0 }
	local counter = 1
	--count all node teams
	while counter <= #nodes and (playerXEnemy[1] < 1 or playerXEnemy[2] < 1) do
		if nodes[counter].team > 2 then
			playerXEnemy[2] = playerXEnemy[2] + 1
		elseif nodes[counter].team == 2 then
			playerXEnemy[1] = playerXEnemy[1] + 1
		end
		counter = counter + 1
	end
	if playerXEnemy[1] < 1 or playerXEnemy[2] < 1 then
		-- mark level completed
		if playerXEnemy[2] < 1 then
			levelProgress[currentLevel] = 2
			--unlocks next level
			if levelProgress[currentLevel+1] == 3 then
				levelProgress[currentLevel+1] = 1
				menuButtons[#menuButtons-20+currentLevel+1].x = outerLevelPositions[currentLevel+1].x
				menuButtons[#menuButtons-20+currentLevel+1].y = outerLevelPositions[currentLevel+1].y
			end
			

		end

		table.insert(buttonsOnScreen, allButtons[26])
		table.insert(buttonsOnScreen, allButtons[27])
		

		levelDoneMenu = true
	end

end

function tierChange(node)
	-- tier change
	if node.population > nodeTiers[node.tier].max or (node.neutralPower > nodeTiers[node.tier].max and node.team == 1) then 
		node.tier = node.tier + 1
		node.effectTimer = 0.5
		--print("Tier UP!")
		--node
		adjustConnectionEdges()
	elseif (node.population < nodeTiers[node.tier].min and node.team ~= 1) or (node.neutralPower < nodeTiers[node.tier].min and node.team == 1) then
		node.tier = node.tier -1
		node.effectTimer = 0.5
		--print("Tier down")
		adjustConnectionEdges()
	end
end


function updateMovingConnections()

	
	for connectionIndex, connection in ipairs(connections) do
		--[[if #connection.links > 5 then
			print("link distance = " .. distancebetween(connection.links[3].x, connection.links[3].y, connection.links[4].x, connection.links[4].y))
		end]]
		if connection.moving == true then

			if #connection.links > 0 then
				connection.tentacleEnd.x = connection.links[1].x
				connection.tentacleEnd.y = connection.links[1].y
			end

			-- breaking a connection
			if connection.destination == 0 then 
				for linkIndex, link in ipairs(connection.links) do
					link.x = link.x - (connection.linkXStep/7*160/FPSlogicTarget)
					link.y = link.y - (connection.linkYStep/7*160/FPSlogicTarget)
					if distancebetween(link.x, link.y, nodes[connection.source].x, nodes[connection.source].y) < nodeTiers[nodes[connection.source].tier].radius-linkRadius then
						table.remove(connection.links, linkIndex)
						nodes[connection.source].population = nodes[connection.source].population + 1
					end
					if #connection.links == 0 then  -- could've also used tentacle end point
						connection.moving = false
						nodes[connection.source].population = nodes[connection.source].population - 1
						table.remove(connections, connectionIndex)
						adjustConnectionIndexes(connectionIndex)
						print("connection removed")
						--adjustConnectionEdges()
					end
					
				end

			-- moving a connection to midpoint 
			elseif connection.destination == 1 then
				--print(connection.moving)
				if distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connection.targetEdge.x, connection.targetEdge.y) < distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connection.sourceEdge.x, connection.sourceEdge.y) then
					-- closer to target, so its long and needs to move back
					--print(connection.opposedConnectionIndex)
					if distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connections[connection.opposedConnectionIndex].tentacleEnd.x, connections[connection.opposedConnectionIndex].tentacleEnd.y) < 5 or 
						distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connection.targetEdge.x, connection.targetEdge.y) < --tentacles passed each other, move back
						distancebetween(connections[connection.opposedConnectionIndex].tentacleEnd.x, connections[connection.opposedConnectionIndex].tentacleEnd.y, connection.targetEdge.x, connection.targetEdge.y) then

						--distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connection.targetEdge.x, connection.targetEdge.y) < 20 then   ----- if node is already locked in
						-- touching
						for linkIndex, link in ipairs(connection.links) do
							link.x = link.x - (connection.linkXStep/20*160/FPSlogicTarget) -- back
							link.y = link.y - (connection.linkYStep/20*160/FPSlogicTarget)

							if distancebetween(link.x, link.y, nodes[connection.source].x, nodes[connection.source].y) < nodeTiers[nodes[connection.source].tier].radius-linkRadius then
								table.remove(connection.links, linkIndex)
								nodes[connection.source].population = nodes[connection.source].population + 1
							end
						end

						
					else
						-- not touching
						-- keep moving but check if touching
						for linkIndex, link in ipairs(connection.links) do
							link.x = link.x + (connection.linkXStep/20*160/FPSlogicTarget)
							link.y = link.y + (connection.linkYStep/20*160/FPSlogicTarget)

								-- compare distance of potential link location to node centre vs node radius. i.e. if potential link is within radius
							if (distancebetween(connection.links[#connection.links].x - (connection.linkXStep), connection.links[#connection.links].y - (connection.linkYStep), nodes[connection.source].x, nodes[connection.source].y)) > nodeTiers[nodes[connection.source].tier].radius-linkRadius then
								table.insert(connection.links, {
								x = connection.links[#connection.links].x - (connection.linkXStep),
								y = connection.links[#connection.links].y - (connection.linkYStep)
								})
								nodes[connection.source].population = nodes[connection.source].population - 1
							end
						end
						
					end
				else
					-- closer to source, so its short and should move forward
					if distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connections[connection.opposedConnectionIndex].tentacleEnd.x, connections[connection.opposedConnectionIndex].tentacleEnd.y) < 2 then
						-- touching, set end point
						
					else
						-- not touching

						
					end
					-- keep moving either way
					for linkIndex, link in ipairs(connection.links) do
						link.x = link.x + (connection.linkXStep/20*160/FPSlogicTarget)
						link.y = link.y + (connection.linkYStep/20*160/FPSlogicTarget)

						-- compare distance of potential link location to node centre vs node radius. i.e. if potential link is within radius
						if (distancebetween(connection.links[#connection.links].x - (connection.linkXStep), connection.links[#connection.links].y - (connection.linkYStep), nodes[connection.source].x, nodes[connection.source].y)) > nodeTiers[nodes[connection.source].tier].radius-linkRadius then
							table.insert(connection.links, {
								x = connection.links[#connection.links].x - (connection.linkXStep),
								y = connection.links[#connection.links].y - (connection.linkYStep)
							})
							nodes[connection.source].population = nodes[connection.source].population - 1
						end
				
					end
				end

				-- reached target?
				--compare distance of tentacle end vs node radius. i.e. if potential link is within radius
				-- print(connection.connectionMidPoint.x )
				if ( distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connections[connection.opposedConnectionIndex].tentacleEnd.x, connections[connection.opposedConnectionIndex].tentacleEnd.y) < 2 and 
					math.abs(connection.tentacleEnd.x - connection.connectionMidPoint.x) < 2 and math.abs(connection.tentacleEnd.y - connection.connectionMidPoint.y) < 2 ) then
					print("Opposition locked")
					connection.moving = false
					connections[connection.opposedConnectionIndex].moving = false
					adjustConnectionEdges()
				end
			
			-- moving a connection to target 
			elseif connection.destination == 2 then
				for linkIndex, link in ipairs(connection.links) do
					link.x = link.x + (connection.linkXStep/20*160/FPSlogicTarget)
					link.y = link.y + (connection.linkYStep/20*160/FPSlogicTarget)
				end

				-- compare distance of potential link location to node centre vs node radius. i.e. if potential link is within radius
				if (distancebetween(connection.links[#connection.links].x - (connection.linkXStep), connection.links[#connection.links].y - (connection.linkYStep), nodes[connection.source].x, nodes[connection.source].y)) > nodeTiers[nodes[connection.source].tier].radius-linkRadius then
					table.insert(connection.links, {
						x = connection.links[#connection.links].x - (connection.linkXStep),
						y = connection.links[#connection.links].y - (connection.linkYStep)
					})
					nodes[connection.source].population = nodes[connection.source].population - 1
				end

				-- reached target?
				--compare distance of tentacle end vs node radius. i.e. if potential link is within radius
				if (distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, nodes[connection.target].x, nodes[connection.target].y)) < nodeTiers[nodes[connection.target].tier].radius+2 then
					connection.moving = false
					adjustConnectionEdges()
				end

			-- connection has been split, and splitLink is defined
			elseif connection.destination == 3 then
				for linkIndex, link in ipairs(connection.links) do
					if linkIndex > connection.splitLink then --send to source
						link.x = link.x - (connection.linkXStep/7*160/FPSlogicTarget)
						link.y = link.y - (connection.linkYStep/7*160/FPSlogicTarget)
						if distancebetween(link.x, link.y, nodes[connection.source].x, nodes[connection.source].y) < nodeTiers[nodes[connection.source].tier].radius-linkRadius then
							table.remove(connection.links, linkIndex)
							nodes[connection.source].population = nodes[connection.source].population + 1
						end
					else --send to target
						link.x = link.x + (connection.linkXStep/7*160/FPSlogicTarget)
						link.y = link.y + (connection.linkYStep/7*160/FPSlogicTarget)
						if distancebetween(link.x, link.y, nodes[connection.target].x, nodes[connection.target].y) < nodeTiers[nodes[connection.target].tier].radius-linkRadius then
							table.remove(connection.links, linkIndex)
							connection.splitLink = connection.splitLink -1
							if nodes[connection.target].team == connection.team then
								nodes[connection.target].population = nodes[connection.target].population + 1
							else
								if nodes[connection.target].team == 1 then
									if nodes[connection.target].neutralTeam ~= connection.team then
										nodes[connection.target].population = nodes[connection.target].population - 1
									else
										nodes[connection.target].population = nodes[connection.target].population + 1
									end
								else
									nodes[connection.target].population = nodes[connection.target].population - 1
								end

								if nodes[connection.target].population < 0 then
									if nodes[connection.target].team > 1 then
										nodes[connection.target].team = connection.team 
										nodes[connection.target].effectTimer = 0.5
										nodes[connection.target].tentaclesUsed = 0 
										nodes[connection.target].population = math.abs(nodes[connection.target].population)
										for connectionIndex2, connection2 in ipairs(connections) do
											if connection2.source == connection.target then
												connection2.moving = true
												if connection2.opposedConnectionIndex > 0 then
													connections[connection2.opposedConnectionIndex].opposedConnectionIndex = 0
													connections[connection2.opposedConnectionIndex].moving = true
													connections[connection2.opposedConnectionIndex].destination = 2
													connection2.opposedConnectionIndex = 0
												end
												connection2.destination = 0
											end
										end
									else
										--switch neutralTeam but keep main team as neutral
										nodes[connection.target].neutralTeam = connection.team
										nodes[connection.target].population = math.abs(nodes[connection.target].population)
									end
								end

								--convert team from neutral 
								if nodes[connection.target].team == 1 and nodes[connection.target].population >= math.floor(nodes[connection.target].neutralPower/3) then
									print("neutral converted",  nodes[connection.target].neutralPower)
									nodes[connection.target].team = connection.team
									nodes[connection.target].population = nodes[connection.target].neutralPower
								end
							end
						end
					end
					if #connection.links == 0 then  -- couldn't use tentacle end point
						connection.moving = false

						--nodes[connection.source].population = nodes[connection.source].population - 1
						table.remove(connections, connectionIndex)
						print("split connection removed")
						adjustConnectionEdges()

					end
				end


			end
			if #connection.links > 0 then
				connection.tentacleEnd.x = connection.links[1].x
				connection.tentacleEnd.y = connection.links[1].y
			end

			if nodes[connection.source].population == 0 and connection.moving == true and connection.destination ~= 0 and connection.destination ~= 3 then
				
				nodes[connection.source].tentaclesUsed = nodes[connection.source].tentaclesUsed - 1
				nodes[connection.source].population = nodes[connection.source].population + 1
				if connection.destination == 1 then
					connections[connection.opposedConnectionIndex].opposedConnectionIndex = 0
					connections[connection.opposedConnectionIndex].destination = 2
					connections[connection.opposedConnectionIndex].moving = true
					connection.opposedConnectionIndex = 0

				end
				connection.destination = 0
				print("not enough, recalling")
			end
		end
	end

	

	
end


function glowDelivery()

	--Glow delivery
	--print(#connection.glowing)

	if deliveryTimer < 0 then

		for connectionIndex, connection in ipairs(connections) do

			for glowerIndex, glower in ipairs(connection.glowing) do
				--print(glower)
				connection.glowing[glowerIndex] = glower - 1
				--print(glower)
				if glower < 1 then
					if nodes[connection.target].team ~= connection.team then
						if nodes[connection.target].team == 1 then
							if nodes[connection.target].neutralTeam ~= connection.team then
								nodes[connection.target].population = nodes[connection.target].population - 1
							else
								nodes[connection.target].population = nodes[connection.target].population + 1
							end
						else
							nodes[connection.target].population = nodes[connection.target].population - 1
						end
					else
						if nodes[connection.target].population < powerLimit then
							nodes[connection.target].population = nodes[connection.target].population + 1
						end
					end
					table.remove(connection.glowing, glowerIndex)

					-- convert team through glow delivery
					if nodes[connection.target].population < 0 then
						if nodes[connection.target].team > 1 then
							nodes[connection.target].team = connection.team
							nodes[connection.target].effectTimer = 0.5
							nodes[connection.target].tentaclesUsed = 0 
							nodes[connection.target].population = math.abs(nodes[connection.target].population)
							-- if dead node has other tentacles out, retract them
							for connectionIndex2, connection2 in ipairs(connections) do
								if connection2.source == connection.target then
									if connection2.opposedConnectionIndex > 0 then
										connections[connection2.opposedConnectionIndex].opposedConnectionIndex = 0
										connections[connection2.opposedConnectionIndex].moving = true
										connections[connection2.opposedConnectionIndex].destination = 2
									end
									connection2.opposedConnectionIndex = 0
									connection2.destination = 0
									connection2.moving = true
								end
							end
						else
							--switch neutralTeam but keep main team as neutral
							nodes[connection.target].neutralTeam = connection.team
							nodes[connection.target].population = math.abs(nodes[connection.target].population)
						end
					end

					--convert team from neutral 
					if nodes[connection.target].team == 1 and nodes[connection.target].population >= math.floor(nodes[connection.target].neutralPower/3) then
						print("neutral converted",  nodes[connection.target].neutralPower)
						nodes[connection.target].team = connection.team
						nodes[connection.target].population = nodes[connection.target].neutralPower
					end

				end
					
			end
			--print("____")

			if connection.moving ~= true then
				--print("check")
				if connection.sendTimer < 0 and nodes[connection.source].population > 4 then
					
					table.insert(connection.glowing, #connection.links)
					connection.sendTimer = nodeTiers[nodes[connection.source].tier].sendDelay + connection.sendTimer
				end

			end
				
		end
		-- print(deliveryTimer, " - ", timer % nodeTiers[nodes[connection.source].tier].sendDelay, " vs ", deliverySpeed)
		deliveryTimer = deliverySpeed
		
	end

end


function checkOpposedConnections()  -- need to fix rare opposed connection issue

	for connectionIndex1, connection1 in ipairs(connections) do
		if connection1.destination ~= 1 and connection1.opposedConnectionIndex > 0 then
			
			--connections[connection.opposedConnectionIndex].moving = true
			--connections[connection.opposedConnectionIndex].destination = 2
			--connections[connection.opposedConnectionIndex].opposedConnectionIndex = 0 
			connection1.opposedConnectionIndex = 0
			--print(connectionIndex, connection.opposedConnectionIndex)
		
		end
		if connection1.destination == 1 and connection1.opposedConnectionIndex > 0 and connection1.opposedConnectionIndex <= #connections then
			if connections[connection1.opposedConnectionIndex].destination ~= 1 or connections[connection1.opposedConnectionIndex].opposedConnectionIndex ~= connectionIndex1 then
				connection1.destination = 2 
				connection1.opposedConnectionIndex = 0
				connection1.moving = true
				print("dodgy connection caught")
			end
		elseif connection1.opposedConnectionIndex > #connections then
			connection1.destination = 2 
			connection1.opposedConnectionIndex = 0
			connection1.moving = true
		end


		for connectionIndex2, connection2 in ipairs(connections) do
			-- work out if a connection is opposed and set opposed
			if connection1.source == connection2.target and connection1.target == connection2.source and connectionIndex1 ~= connectionIndex2 and connection1.opposedConnectionIndex == 0 and 
				connection2.opposedConnectionIndex == 0 and connection1.destination > 0 and connection2.destination > 0 then 

				if connection1.team == connection2.team and connection1.destination ~= 3 then
					--same team
					if connectionIndex1 < connectionIndex2 then
						connection1.destination = 0
						connection2.destination = 2

						nodes[connection1.source].population = nodes[connection1.source].population + 1
						nodes[connection1.source].tentaclesUsed = nodes[connection1.source].tentaclesUsed - 1
					else
						--do nothing, the above will trigger in a later loop

					end
				elseif connection1.team ~= connection2.team and connection1.destination ~= 3 then

					connection1.opposedConnectionIndex= connectionIndex2
					connection2.opposedConnectionIndex= connectionIndex1
					print("OPPOSED! node,team - node,team",connections[connection1.opposedConnectionIndex].source, connections[connection1.opposedConnectionIndex].team, " - ", connections[connection2.opposedConnectionIndex].source, connections[connection2.opposedConnectionIndex].team)
					print()
					connection1.destination = 1
					connection2.destination = 1
					
				end
				connection1.moving = true
				connection2.moving = true
			end
		end
	end

end

function nodeRepulsion()

	--check distances between all nodes
	for nodeIndex1, node1 in ipairs(nodes) do 
		for nodeIndex2, node2 in ipairs(nodes) do 

			if distancebetween(node1.x, node1.y, node2.x, node2.y) < 80 + nodeTiers[node1.tier].radius + nodeTiers[node2.tier].radius then
				
				
				node1.x = node1.x+ (node1.x - node2.x)/80
				node1.y = node1.y+ (node1.y - node2.y)/80
				node2.x = node2.x+ (node2.x - node1.x)/80
				node2.y = node2.y+ (node2.y - node1.y)/80

				if node1.x < 10 then
					node1.x = 10
				elseif node1.x > arenaWidth-10 then
					node1.x = arenaWidth-10
				end

				if node1.y < 10 then
					node1.y = 10
				elseif node1.y > arenaHeight-10 then
					node1.y = arenaHeight-10
				end

				if node2.x < 10 then
					node2.x = 10
				elseif node2.x > arenaWidth-10 then
					node2.x = arenaWidth-10
				end

				if node2.y < 10 then
					node2.y = 10
				elseif node2.y > arenaHeight-10 then
					node2.y = arenaHeight-10
				end
				
			end



		end
	end

end



function love.textinput(t)
	for i = 1, #allowed_chars do -- sanitize input
        if allowed_chars :sub(i,i) == t:gsub("^%u", string.lower) and #inputText < 100 then-- if char is allowed 
            inputText = inputText ..t -- append what was typed
        elseif t == "BACKSPACE" then
        	print("backspace")
        end
    end
    print(inputText)
end

function love.keypressed(key)
    if key == "backspace" and inputText ~= "" then
    	inputText = string.sub(inputText, 1, #inputText-1)
    end
end


function adjustConnectionIndexes(deletedConnectionIndex)

	local totalConnections = #connections

	--print(totalConnections,"ConnectionIndex round up: ")
	for connectionIndex, connection in ipairs(connections) do
		--print("Index:", connectionIndex, ", ", connection.source, " -> ", connection.target, " opposed? = ", connection.opposedConnectionIndex, " moving? = ", connection.moving)
	end

	for i = 1, totalConnections do
		if connections[i].opposedConnectionIndex > deletedConnectionIndex then
			connections[i].opposedConnectionIndex = connections[i].opposedConnectionIndex -1
		end
	end


	--print(totalConnections,"POST - ConnectionIndex round up: ")
	for connectionIndex, connection in ipairs(connections) do
		--print("Index:", connectionIndex, ", ", connection.source, " -> ", connection.target, " opposed? = ", connection.opposedConnectionIndex, " moving? = ", connection.moving)
	end

end

function adjustConnectionEdges()

	--when nodes tier up the tentacles should adjust their length to match the change in distance between edges

	for connectionIndex, connection in ipairs(connections) do
		if not connection.moving then
			local edges = calculateNodeEdges(connection.source, connection.target)
			
			connection.targetEdge = { x = edges.targetX, y = edges.targetY }

			connection.sourceEdge = { x = edges.sourceX, y = edges.sourceY }

			--fix target side
			if connection.destination == 2 and distancebetween(edges.targetX, edges.targetY, connection.links[1].x, connection.links[1].y) > 5 then
				local differenceX = (edges.targetX - connection.links[1].x)
				local differenceY = (edges.targetY - connection.links[1].y)
				for linkIndex, link in ipairs(connection.links) do
					link.x = link.x + differenceX * (1 - (linkIndex-1)/#connection.links)
					link.y = link.y + differenceY * (1 - (linkIndex-1)/#connection.links)
				end
			end

			--fix source side
			if distancebetween(edges.sourceX, edges.sourceY, connection.links[#connection.links].x, connection.links[#connection.links].y) > 5 then
				local differenceX = (edges.sourceX - connection.links[#connection.links].x)
				local differenceY = (edges.sourceY - connection.links[#connection.links].y)
				for linkIndex, link in ipairs(connection.links) do
					link.x = link.x + differenceX * ( (linkIndex)/#connection.links)
					link.y = link.y + differenceY * ( (linkIndex)/#connection.links)
				end
			end

			--check if links are too bunched up then remove or add links, then adjust edges based on new link numbers
			local recheck = false
			if distancebetween(connection.links[2].x, connection.links[2].y, connection.links[3].x, connection.links[3].y) < 23.5 then
				table.remove(connection.links, #connection.links)
				recheck = true
			elseif distancebetween(connection.links[2].x, connection.links[2].y, connection.links[3].x, connection.links[3].y) > 26 then
				table.insert(connection.links, {
					x = connection.links[#connection.links].x - (connection.linkXStep),
					y = connection.links[#connection.links].y - (connection.linkYStep)
					})
				recheck = true
			end

			--adjust again
			if recheck then
				print("links ADJUSTED!!")
				--fix target side
				if connection.destination == 2 and distancebetween(edges.targetX, edges.targetY, connection.links[1].x, connection.links[1].y) > 5 then
					local differenceX = (edges.targetX - connection.links[1].x)
					local differenceY = (edges.targetY - connection.links[1].y)
					for linkIndex, link in ipairs(connection.links) do
						link.x = link.x + differenceX * (1 - (linkIndex-1)/#connection.links)
						link.y = link.y + differenceY * (1 - (linkIndex-1)/#connection.links)
					end
				end

				--fix source side
				if distancebetween(edges.sourceX, edges.sourceY, connection.links[#connection.links].x, connection.links[#connection.links].y) > 5 then
					local differenceX = (edges.sourceX - connection.links[#connection.links].x)
					local differenceY = (edges.sourceY - connection.links[#connection.links].y)
					for linkIndex, link in ipairs(connection.links) do
						link.x = link.x + differenceX * ( (linkIndex)/#connection.links)
						link.y = link.y + differenceY * ( (linkIndex)/#connection.links)
					end
				end
			end


		end
	end

end



function splitTentacle(connectionIndex, ix, iy)

	local connection = connections[connectionIndex]

	local ratio = distancebetween(connection.sourceEdge.x, connection.sourceEdge.y, ix, iy) / 
	distancebetween(connection.sourceEdge.x, connection.sourceEdge.y, connection.targetEdge.x, connection.targetEdge.y)

	connection.splitLink = #connection.links - math.floor((#connection.links-1) * ratio)

end

function createConnection(sourceNode, targetNode)

	local edges = calculateNodeEdges(sourceNode, targetNode)

	local numLinksToMake = 1+ math.floor((distancebetween(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY))/((2*linkRadius)+linkSpacing))
	local extraSpacing = (distancebetween(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY))%((2*linkRadius)+linkSpacing)
	extraSpacing = extraSpacing/numLinksToMake

	local linkSteps = calculateSteps(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY, extraSpacing)

	--print(calculateSourceYAngle(sourceNode, targetNode))

	-- connection creation with no links
	table.insert(connections, {	
		population = nodes[sourceNode].population, team = nodes[sourceNode].team, moving = true, source = sourceNode, 
		sourceEdge = { x = edges.sourceX, y = edges.sourceY }, 
		target = targetNode,
		targetEdge = {
			x = edges.targetX, 
			y = edges.targetY
		},
		tentacleEnd = {
			x = edges.sourceX, 
			y = edges.sourceY
		},
		connectionMidPoint = {
			x = (edges.sourceX + edges.targetX)/2,
			y = (edges.sourceY + edges.targetY)/2
		},
		linkXStep = linkSteps.x,
		linkYStep = linkSteps.y,
		links = {
		},
		destination = 2,
		opposedConnectionIndex= 0,
		splitLink = 0,
		glowing = {},
		sendTimer = nodeTiers[nodes[sourceNode].tier].sendDelay
	})

	-- link creation
		--loops from 1 to number of nodes that would fit in the distance 

	-- now this just creates the first node, slightly problematic as i think this is the reason we have to -1 from the added population when connection cut
	--for i = 1, 1 do numLinksToMake+1 do


	table.insert(connections[#connections].links, {
		x = edges.sourceX,
		y = edges.sourceY
	})
	nodes[sourceNode].population = nodes[sourceNode].population -1
	
	nodes[sourceNode].tentaclesUsed = nodes[sourceNode].tentaclesUsed + 1

	tentacleEnd = connections[#connections].links[1]
	
	-- print every current connection
	for connectionIndex, connection in ipairs(connections) do
		print(connection.source, " -> ", connection.target)
	end
	print(" ------------------- ")

	checkOpposedConnections()

	--trigger ping effect from connection creation
	nodes[sourceNode].effectTimer = 0.5

end

function checkHover()

	local mouseButton = isMouseInButton()

	if mouseButton > 0 then
		love.mouse.setCursor(cursor)
		if loadMenu and type(buttonsOnScreen[mouseButton].name) ~= "string" and #previewNodes == 0 then
			decodeLevelCode(customLevels[buttonsOnScreen[mouseButton].name].startIndex, false)
		end
	elseif #previewNodes > 0 then
		love.mouse.setCursor()
		previewNodes = {}
		previewWalls = {}
	else
		love.mouse.setCursor()
	end

end

function love.mousereleased(mouseX, mouseY)

	love.mouse.setCursor()

	if dragging then
		dragging = false
	end

	local releasenode = isMouseInNode()

	-- create connection, when mouse released on another node when selected > 0 
	if nodeSelected > 0 
	and releasenode > 0 
	and nodeSelected ~= releasenode   -- means not equal
	and nodes[nodeSelected].population > 0
	and nodes[nodeSelected].tentaclesUsed < nodeTiers[nodes[nodeSelected].tier].maxTentacles
	and (nodes[nodeSelected].team == 2 or godModeON) -- only control green nodes unless god mode is on
	then
		-- check for wall intersection
		local wallIntersection = false
		for wallIndex, wall in ipairs(walls) do 
			ix, iy = findIntersectionPoint(nodes[nodeSelected].x, nodes[nodeSelected].y, nodes[releasenode].x, nodes[releasenode].y, wall.startX, wall.startY, wall.endX, wall.endY)
			if ix ~= nil and iy ~= nil then -- intersection exists
				wallIntersection = true
			end
		end

		-- check for duplicate connection
		local connectionAlreadyExists = false
		for connectionIndex, connection in ipairs(connections) do
			if connection.source == nodeSelected and connection.target == releasenode then 
				connectionAlreadyExists = true
				print("ignored duplicate: ", connection.source, " -> ", connection.target)
			end

		end

		--create connection
		if wallIntersection == false and connectionAlreadyExists == false and editor == false then
			createConnection(nodeSelected, releasenode)
		end


	-- cutting a connection
	elseif (nodeSelected == 0 and pointSelected.x ~= 0) then
		local releaseMouseX = love.mouse.getX()
		local releaseMouseY = love.mouse.getY()
		-- check every connection for an intersection, allows multiple cut lines
		for connectionIndex, connection in ipairs(connections) do 
			ix, iy = findIntersectionPoint(connection.sourceEdge.x,connection.sourceEdge.y, connection.targetEdge.x,connection.targetEdge.y, pointSelected.x, pointSelected.y, releaseMouseX, releaseMouseY)
			if ix ~= nil and iy ~= nil and (connection.team == 2 or godModeON) then -- intersection exists
								
				cutConnection(connectionIndex, connection, ix, iy)

			end
		end
	end


	-- unpause
	if pause and isMouseInButton() == 0 then
		pause = false
	end


end

function cutConnection(connectionIndex, connection, ix, iy)

	if (connection.destination == 1 or (connection.moving == true and connection.destination ~= 0 and connection.destination ~= 3))  then 
		-- go home
		connection.destination = 0
		nodes[connection.source].tentaclesUsed = nodes[connection.source].tentaclesUsed - 1
		if connection.opposedConnectionIndex > 0 and connection.opposedConnectionIndex <= #connections and connection.opposedConnectionIndex ~= connectionIndex then
			connections[connection.opposedConnectionIndex].opposedConnectionIndex = 0 
			connections[connection.opposedConnectionIndex].destination = 2
			connections[connection.opposedConnectionIndex].moving = true
			connection.opposedConnectionIndex = 0
			--print(connectionIndex, connection.opposedConnectionIndex)
		end
		nodes[connection.source].population = nodes[connection.source].population +1
	elseif connection.destination == 2 then
		-- initiate split!
		connection.destination = 3 
		nodes[connection.source].tentaclesUsed = nodes[connection.source].tentaclesUsed - 1
		splitTentacle(connectionIndex, ix, iy) --updates connection.splitLink
		nodes[connection.target].population = nodes[connection.target].population + 1
		--print(connection.splitLink," links: ", #connection.links)
		if connection.splitLink < 1 then
			connection.splitLink = 1
		end
		--print(connection.splitLink)
		y = connection.links[connection.splitLink].x
		if distancebetween(connection.links[connection.splitLink].x, connection.links[connection.splitLink].y, connection.sourceEdge.x, connection.sourceEdge.y) < --splitLink is the index
			distancebetween(connection.links[connection.splitLink].x, connection.links[connection.splitLink].y, connection.targetEdge.x, connection.targetEdge.y) then
			if nodes[connection.target].team == connection.team then --close to source
				nodes[connection.source].population = nodes[connection.source].population +1
				nodes[connection.target].population = nodes[connection.target].population - 2
			else
				nodes[connection.source].population = nodes[connection.source].population +1
				nodes[connection.target].population = nodes[connection.target].population 
			end
		else
			if nodes[connection.target].team == connection.team then --close to target
				nodes[connection.source].population = nodes[connection.source].population +1
				nodes[connection.target].population = nodes[connection.target].population - 2
			else
				nodes[connection.source].population = nodes[connection.source].population +1
				nodes[connection.target].population = nodes[connection.target].population 
			end
		end
	end

	connection.moving = true --this triggers everything to start processing this tentacle again till resolved
	adjustConnectionIndexes(connectionIndex)
end




function love.mousepressed(mouseX, mouseY)

	love.mouse.setCursor(cursor)

	if not pause then
	
		nodeSelected = isMouseInNode() 

		local buttonSelected = isMouseInButton()

		local wallSelected = isMouseInWall()

		if nodeSelected < 1 and buttonSelected < 1 and (wallSelected < 1 or not editor) then
			--nothing selected

			--point selected for making cuts
			pointSelected = {x = mouseX, y = mouseY}

			--editor create node/wall 
			if editor then
				if createMicrobe then
					--create node of type specified 
					if editTeam > 1 then --not neutral
						table.insert(nodes, {x = mouseX,
							y = mouseY,
							team = editTeam,  -- team starts from 1 for teamColours[team] to make sense, 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
							population = editPower,
							tier = 3,
							regenTimer = 5,
							tentaclesUsed = 0,
							effectTimer = 0, 
							neutralPower = 30,
							neutralTeam = 1 
							})
					else--neutral
						table.insert(nodes, {x = mouseX,
							y = mouseY,
							team = editTeam,  -- team starts from 1 for teamColours[team] to make sense, 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
							population = 0,
							tier = 3,
							regenTimer = 5,
							tentaclesUsed = 0,
							effectTimer = 0, 
							neutralPower = editPower,
							neutralTeam = 1 
							})
					end
					pointSelected = {x = 0, y = 0}
					nodeSelected = isMouseInNode()
					editorSelected.node = true
					editorSelected.index = #nodes
					for b = 11, 13 do
						table.insert(buttonsOnScreen, allButtons[b])
					end	
					calculateNodeDistances()
				else
					--create wall
					table.insert(walls, {
						startX = mouseX,
			    		startY = mouseY, --lower
			    		endX = (arenaWidth/2+ 1.5*mouseX)/2.5,
			    		endY = (arenaHeight/2+ 1.5*mouseY)/2.5
			    	})
			    	editorSelected.node = false
					editorSelected.index = #walls
					table.insert(buttonsOnScreen, allButtons[13])
				end

			end
		elseif nodeSelected > 0 and buttonSelected < 1 and wallSelected < 1 then
			--node selected
			pointSelected = {x = 0, y = 0}

			if editor then
				editorSelected.node = true
				editorSelected.index = nodeSelected  

				local existsAlready = false
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Create Wall" or buttonsOnScreen[b].name == "Create Microbe" then
						table.remove(buttonsOnScreen, b)
						existsAlready = true
					end
				end
				if existsAlready == false then
					table.insert(buttonsOnScreen, allButtons[15])
					table.insert(buttonsOnScreen, allButtons[16])
				end

				if nodes[nodeSelected].team ~= 1 then
					editPower = nodes[nodeSelected].population
				else
					editPower = nodes[nodeSelected].neutralPower
				end
				editTeam = nodes[nodeSelected].team
			end
		elseif nodeSelected < 1 and buttonSelected < 1 and wallSelected > 0 and editor then
			--wall selected
			editorSelected.node = false
			editorSelected.index = wallSelected
		end

		--[[if #editorSaveState > 0 then
			print(editorSaveState[1].population)
		end]]

		--menu interactions
		if buttonSelected > 0 then
			pointSelected = {x = 0, y = 0}
			if type(buttonsOnScreen[buttonSelected].name) ~= "string" then --level number
				if loadMenu then
					--level selected from editor
					nodeSelected = 0
					editorSelected.index = 0
					nodes = {}
					walls = {}
					
					--local level = 
					decodeLevelCode(customLevels[buttonsOnScreen[buttonSelected].name].startIndex, true)

					currentLevel = buttonsOnScreen[buttonSelected].name+100

					buttonsOnScreen = {}
					for b = 1, #editorButtons do
						table.insert(buttonsOnScreen, editorButtons[b])
					end	

					--nodes, walls = level[1], level[2]
					
					--for nodeIndex, node in ipairs(nodes) do
					--	print(node.team)
					--end

					calculateNodeDistances() 
					loadMenu = false
				
					editor = true

				else
					--level selected from main menu
					connections = {}
					levelNodesTable = levelNodes(arenaWidth,arenaHeight) -- refresh table to re-set populations back to default
					currentLevel = buttonsOnScreen[buttonSelected].name
					current_background = game_background
					nodes = levelNodesTable[currentLevel] 
					walls = levelWallsTable[currentLevel] --walls dont change so no need to revert anything each time
					powerLimit = levelPowerLimitsTable[currentLevel]

					calculateNodeDistances()

					buttonsOnScreen = {}

					for b = 1, #controlBarButtons do
						table.insert(buttonsOnScreen, controlBarButtons[b])
					end	
					timer = 0
				end



			elseif buttonsOnScreen[buttonSelected].name == "Menu" then
				levelDoneMenu = false
				for i = 3 , #menuButtons do
					if levelProgress[i-2] == 3 then --locked
						menuButtons[i].x = innerLevelPositions[i-2].x
						menuButtons[i].y = innerLevelPositions[i-2].y
					else
						menuButtons[i].x = outerLevelPositions[i-2].x
						menuButtons[i].y = outerLevelPositions[i-2].y
					end
				end

				menuWigglerSeed = createSeed()
				loadMenu = false
				saveMenu = false
				currentLevel = 0
				editor = false
				--print("EDITOR MODE OFF")
				current_background = menu_background
				connections = {}
				nodes = {}
				walls = {}
				--print("buttons on screen: ", #buttonsOnScreen)
				buttonsOnScreen = {}
				for b = 1, #menuButtons do
					table.insert(buttonsOnScreen, menuButtons[b])
				end
				--print("buttons on screen: ", #buttonsOnScreen)

			elseif buttonsOnScreen[buttonSelected].name == "Continue" then
				levelDoneMenu = false

				if currentLevel < 20 then
					--next level 
					connections = {}
					levelNodesTable = levelNodes(arenaWidth,arenaHeight) -- refresh table to re-set populations back to default
					currentLevel = currentLevel + 1
					current_background = game_background
					nodes = levelNodesTable[currentLevel] 
					walls = levelWallsTable[currentLevel] 
					powerLimit = levelPowerLimitsTable[currentLevel]

					calculateNodeDistances()

					buttonsOnScreen = {}

					for b = 1, #controlBarButtons do
						table.insert(buttonsOnScreen, controlBarButtons[b])
					end	
					timer = 0
				end


			elseif buttonsOnScreen[buttonSelected].name == "God" then
				godModeON = not godModeON
			elseif buttonsOnScreen[buttonSelected].name == "AI" then
				AION = not AION
			elseif buttonsOnScreen[buttonSelected].name == "Complete" then
				levelProgress[currentLevel] = 2
				--unlocks next level
				levelProgress[currentLevel+1] = 1
				menuButtons[#menuButtons-20+currentLevel+1].x = outerLevelPositions[currentLevel+1].x
				menuButtons[#menuButtons-20+currentLevel+1].y = outerLevelPositions[currentLevel+1].y
			elseif buttonsOnScreen[buttonSelected].name == "Reset" then
				if currentLevel >= 1 and currentLevel < 100 then
					connections = {}

					levelNodesTable = levelNodes(arenaWidth,arenaHeight)
					nodes = levelNodesTable[currentLevel] 
				elseif currentLevel > 100 then --editor level
					connections = {}
					for nodeIndex, node in ipairs(nodes) do 
						node.team = editorSaveState[nodeIndex].team
						node.population = editorSaveState[nodeIndex].population
						node.tentaclesUsed = 0
					end
				end
				timer = 0
				calculateNodeDistances() -- necessary?

			elseif buttonsOnScreen[buttonSelected].name == "Pause" then
				pause = true


			elseif buttonsOnScreen[buttonSelected].name == "Unlock" then
				for level, progressNumber in ipairs(levelProgress) do
					if progressNumber == 3 then
						levelProgress[level] = 1
						menuButtons[#menuButtons-20+level].x = outerLevelPositions[level].x
						menuButtons[#menuButtons-20+level].y = outerLevelPositions[level].y
					end
				end

			elseif buttonsOnScreen[buttonSelected].name == "Editor" then
				current_background = game_background
				connections = {}
				nodes = {}
				walls = {}
				editor = true
				print("EDITOR MODE ON")
				buttonsOnScreen = {}
				for b = 1, #editorButtons do
					table.insert(buttonsOnScreen, editorButtons[b])
				end	
				--[[table.insert(buttonsOnScreen, allButtons[14])
				for b = 1, #controlBarButtons do
					table.insert(buttonsOnScreen, controlBarButtons[b])
				end	]]

				currentLevel = 100.5

			elseif buttonsOnScreen[buttonSelected].name == "Test&Edit" then
				


				if #nodes > 1 then
					local playerXEnemy = { 0,0 }
					local counter = 1
					--count all node teams
					while counter <= #nodes and (playerXEnemy[1] < 1 or playerXEnemy[2] < 1) do
						if nodes[counter].team > 2 then
							playerXEnemy[2] = playerXEnemy[2] + 1
						elseif nodes[counter].team == 2 then
							playerXEnemy[1] = playerXEnemy[1] + 1
						end
						counter = counter + 1
					end
					if playerXEnemy[1] > 0 and playerXEnemy[2] > 0 then -- enemy and player exists

						calculateNodeDistances() 

						connections = {}
						editor = not editor --switch editor mode
						--check what editor state we've just moved to
						if editor then	-- also set occupied number for neutral nodes
							--currentLevel = 0
							
							for nodeIndex, node in ipairs(nodes) do 
								node.team = editorSaveState[nodeIndex].team
								node.population = editorSaveState[nodeIndex].population
								node.tentaclesUsed = 0
							end
							--print ("enode1 pop: ", editorSaveState[1].population)
							--nodes = editorNodes 
							--editorNodes is the save state to revert nodes to when leaving testing

							buttonsOnScreen = editorButtons
						else --i.e. now in testing
							--currentLevel = 100.5
							--print ("enode1 pop: ", editorSaveState[1].population)
							editorSaveState = {}
							for nodeIndex, node in ipairs(nodes) do 
								table.insert(editorSaveState, {team = node.team, population = node.population}) 
							end
							--print ("saved - enode1 pop: ", editorSaveState[1].population)
							--editorNodes = nodes --set save state to current setup

							buttonsOnScreen = controlBarButtons
							table.insert(buttonsOnScreen, allButtons[14])

							timer = 0
						end
					
						print("TESTING, Testing the edit")
					end
				end

			elseif buttonsOnScreen[buttonSelected].name == "CreateX" then
				local existsAlready = false
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Create Wall" or buttonsOnScreen[b].name == "Create Microbe" then
						table.remove(buttonsOnScreen, b)
						existsAlready = true
					end
				end
				if existsAlready == false then
					table.insert(buttonsOnScreen, allButtons[15])
					table.insert(buttonsOnScreen, allButtons[16])
				end

			elseif buttonsOnScreen[buttonSelected].name == "Create Microbe" then
				createMicrobe = true
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Create Wall" or buttonsOnScreen[b].name == "Create Microbe" then
						table.remove(buttonsOnScreen, b)
					end
				end

			elseif buttonsOnScreen[buttonSelected].name == "Create Wall" then
				createMicrobe = false
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Create Wall" or buttonsOnScreen[b].name == "Create Microbe" then
						table.remove(buttonsOnScreen, b)
					end
				end

			elseif buttonsOnScreen[buttonSelected].name == "PowerSlider" then
				dragging = true

			elseif buttonsOnScreen[buttonSelected].name == "DeleteX" then
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "DeleteX"  then
						--table.remove(buttonsOnScreen, b)
						break
					end
				end
				if editorSelected.index > 0 then
					if editorSelected.node then
						table.remove(nodes, editorSelected.index)
					else
						table.remove(walls, editorSelected.index)
					end
					editorSelected.index = 0
				end
				
			elseif buttonsOnScreen[buttonSelected].name == "MicrobeTeam" then
				local existsAlready = false
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Green" or buttonsOnScreen[b].name == "Red" or buttonsOnScreen[b].name == "Neutral" or buttonsOnScreen[b].name == "Black" or buttonsOnScreen[b].name == "Purple" then
						table.remove(buttonsOnScreen, b)
						existsAlready = true
					end
				end

				if existsAlready == false then
					table.insert(buttonsOnScreen, allButtons[17])
					table.insert(buttonsOnScreen, allButtons[18])
					table.insert(buttonsOnScreen, allButtons[19])
					table.insert(buttonsOnScreen, allButtons[20])
					table.insert(buttonsOnScreen, allButtons[21])
				end

			elseif buttonsOnScreen[buttonSelected].name == "Green" then
				editTeam = 2
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Green" or buttonsOnScreen[b].name == "Red" or buttonsOnScreen[b].name == "Neutral" or buttonsOnScreen[b].name == "Black" or buttonsOnScreen[b].name == "Purple" then
						table.remove(buttonsOnScreen, b)
					end
				end

				if editorSelected.node and #nodes > 0 then
					if nodes[editorSelected.index].team == 1 and editTeam ~= 1 then
						nodes[editorSelected.index].population = editPower
					elseif nodes[editorSelected.index].team ~= 1 and editTeam == 1 then
						nodes[editorSelected.index].population = 0
						nodes[editorSelected.index].neutralPower = editPower
					end

					nodes[editorSelected.index].team = editTeam
				end

			elseif buttonsOnScreen[buttonSelected].name == "Red" then
				editTeam = 3
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Green" or buttonsOnScreen[b].name == "Red" or buttonsOnScreen[b].name == "Neutral" or buttonsOnScreen[b].name == "Black" or buttonsOnScreen[b].name == "Purple" then
						table.remove(buttonsOnScreen, b)
					end
				end
				if editorSelected.node and #nodes > 0 then
					if nodes[editorSelected.index].team == 1 and editTeam ~= 1 then
						nodes[editorSelected.index].population = editPower
					elseif nodes[editorSelected.index].team ~= 1 and editTeam == 1 then
						nodes[editorSelected.index].population = 0
						nodes[editorSelected.index].neutralPower = editPower
					end

					nodes[editorSelected.index].team = editTeam
				end

			elseif buttonsOnScreen[buttonSelected].name == "Black" then
				editTeam = 4
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Green" or buttonsOnScreen[b].name == "Red" or buttonsOnScreen[b].name == "Neutral" or buttonsOnScreen[b].name == "Black" or buttonsOnScreen[b].name == "Purple" then
						table.remove(buttonsOnScreen, b)
					end
				end
				if editorSelected.node and #nodes > 0 then
					if nodes[editorSelected.index].team == 1 and editTeam ~= 1 then
						nodes[editorSelected.index].population = editPower
					elseif nodes[editorSelected.index].team ~= 1 and editTeam == 1 then
						nodes[editorSelected.index].population = 0
						nodes[editorSelected.index].neutralPower = editPower
					end

					nodes[editorSelected.index].team = editTeam
				end

			elseif buttonsOnScreen[buttonSelected].name == "Purple" then
				editTeam = 5
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Green" or buttonsOnScreen[b].name == "Red" or buttonsOnScreen[b].name == "Neutral" or buttonsOnScreen[b].name == "Black" or buttonsOnScreen[b].name == "Purple" then
						table.remove(buttonsOnScreen, b)
					end
				end
				if editorSelected.node and #nodes > 0 then
					if nodes[editorSelected.index].team == 1 and editTeam ~= 1 then
						nodes[editorSelected.index].population = editPower
					elseif nodes[editorSelected.index].team ~= 1 and editTeam == 1 then
						nodes[editorSelected.index].population = 0
						nodes[editorSelected.index].neutralPower = editPower
					end

					nodes[editorSelected.index].team = editTeam
				end

			elseif buttonsOnScreen[buttonSelected].name == "Neutral" then
				editTeam = 1
				for b = #buttonsOnScreen, 1, -1 do
					if buttonsOnScreen[b].name == "Green" or buttonsOnScreen[b].name == "Red" or buttonsOnScreen[b].name == "Neutral" or buttonsOnScreen[b].name == "Black" or buttonsOnScreen[b].name == "Purple" then
						table.remove(buttonsOnScreen, b)
					end
				end
				if editorSelected.node and #nodes > 0 then
					if nodes[editorSelected.index].team == 1 and editTeam ~= 1 then
						nodes[editorSelected.index].population = editPower
					elseif nodes[editorSelected.index].team ~= 1 and editTeam == 1 then
						nodes[editorSelected.index].population = 0
						nodes[editorSelected.index].neutralPower = editPower
					end

					nodes[editorSelected.index].team = editTeam
				end
			elseif buttonsOnScreen[buttonSelected].name == "Overright" then
				if #nodes > 1 then
					--local levelCode, size = createLevelCode()
					--levelCode = "Heya"
					--size = #levelCode
					saveExistingLevel(currentLevel-100) --been working on this, a few issues like editor switching from true and false causes AI to start running. 
					
				else
					--error message not enough nodes
					error.status, error.message = true, "not enough nodes"
					print("not enough nodes, save cancelled")
				end


			elseif buttonsOnScreen[buttonSelected].name == "Save As" then 

				exportLevel()	--temporary for level making. uncomment the below to change back to normal Save As function

				--table.insert(buttonsOnScreen, allButtons[25])
				--saveMenu = true
				--editor = false
				

			elseif buttonsOnScreen[buttonSelected].name == "Load" then
				getLevelNames()

				for i = 3 , #menuButtons do
					menuButtons[i].x = outerLevelPositions[i-2].x
					menuButtons[i].y = outerLevelPositions[i-2].y
				end


				--table.insert(buttonsOnScreen, allButtons[25])
				loadMenu = true
				editor = false

				for levelIndex, level in ipairs(customLevels) do
					table.insert(buttonsOnScreen, menuButtons[2+levelIndex])
				end
				

				--decodeLevelCode()

			elseif buttonsOnScreen[buttonSelected].name == "Confirm" then
				--confirm save name
				if saveMenu then
					if #inputText > 0 then

						local levelCode, size = createLevelCode()
						love.filesystem.append("custom_levels", levelCode )
						saveMenu = false
						table.remove(buttonsOnScreen, #buttonsOnScreen)
					else
						error.status, error.message = true, "input a level name" -- add error display
					end

				--[[elseif loadMenu then

					nodeSelected = 0
					editorSelected.index = 0
					nodes = {}
					walls = {}
					--local level = 
					decodeLevelCode(customLevels[buttonSelected.name].startIndex)
					--nodes, walls = level[1], level[2]
					
					--for nodeIndex, node in ipairs(nodes) do
					--	print(node.team)
					--end

					calculateNodeDistances() 
					loadMenu = false]]
				end
				editor = true

			end
		end
	end
end

function createLevelCode()

	local levelCode = inputText .. ", "
	--local totalSum = 0

	--[[		x = arenaWidth / 2,
		        y = arenaHeight / 2,
		        team = 2,  -- team starts from 1 for teamColours[team] to make sense, 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
		        population = 60,
		        tier = 3,
		        regenTimer = 5,
		        tentaclesUsed = 0,
		    	effectTimer = 0, 
	            neutralPower = 20,
	            neutralTeam = 1
	    ]]


	for nodeIndex, node in ipairs(nodes) do
		--x and y is percentage of window to allow changes in window size
		levelCode = levelCode  .. node.x/arenaWidth .. ", ".. node.y/arenaHeight .. ", ".. node.team .. ", ".. node.population .. ", ".. node.neutralPower .. ", ".. node.neutralTeam .. ", "

		--levelCode = levelCode .. "hi"
	end

	levelCode = levelCode .. " W " .. ", "

	for wallIndex, wall in ipairs(walls) do

		levelCode = levelCode .. wall.startX/arenaWidth .. ", ".. wall.startY/arenaHeight .. ", ".. wall.endX/arenaWidth .. ", ".. wall.endY/arenaHeight .. ", "
		
	end

	levelCode = levelCode .. " | ,"

	return levelCode, #levelCode

end

function getLevelNames()
	customLevelContents, size = love.filesystem.read( 'custom_levels', 50000 )
	local splitContents = manualSplit(customLevelContents)
	local levelDetails = {  --[[ {name = bla, startIndex = 100} ]] }

	table.insert(levelDetails, {name = splitContents[3], startIndex = 4} )

	for index = 3, #splitContents-3 do
		if splitContents[index] == "|" then
			table.insert(levelDetails, {name = splitContents[index+1], startIndex = index+2} )
		end
	end

	customLevels = levelDetails

end

function saveExistingLevel(customLevelIndex)
	--This stores the data for your custom levels, | ,

	--customLevelContents, size = love.filesystem.read( 'custom_levels', 50000 )

	--customLevels[customLevelIndex].startIndex

	print("customLevelIndex = ".. customLevelIndex)
	inputText = customLevels[customLevelIndex].name

	local currentLevelCode, size = createLevelCode()

	local newsave = "This file stores the data for your Tentacle Wars -- Remade custom levels :), | ,"

	for levelIndex, level in ipairs(customLevels) do
		if levelIndex ~= customLevelIndex then
			decodeLevelCode(level.startIndex, true) --sets current level
			inputText = level.name
			local levelCode, size = createLevelCode() --uses current level to create code
			newsave = newsave .. levelCode
		end
	end

	newsave = newsave .. currentLevelCode

	success, message = love.filesystem.write( "custom_levels" ,newsave, #newsave )
	print("SAVE: ", success, ". message: ", message)
end


function decodeLevelCode(startIndex, fullsize) --not full size if used for editor load custom level preview

	--each node is split up by #
	--each detail in a node is split by a comma ,
	--nodes and walls are split up by a W between the nodes section and the walls section
	--the file ends with a | 

	customLevelContents, size = love.filesystem.read( 'custom_levels', 50000 )

	--local levels = {customLevelContents:match((customLevelContents:gsub("[^"..", ".."]*"..", ", "([^"..", ".."]*)"..", ")))} 

	local addingNodes = true


	--customLevelContents
	--local splitContents = {customLevelContents:match((customLevelContents:gsub("[^"..", ".."]*"..", ", "([^"..", ".."]*)"..", ")))}
	local splitContents = manualSplit(customLevelContents)
	--splitContents = customLevelContents:explode(",")
	--print(splitContents)
	local index = startIndex
	local scale = {x=arenaWidth, y=arenaHeight, extraX = 0, extraY = 0}
	if not fullsize then
		scale = {x=280, y=280, extraX= arenaWidth/2 - 140, extraY = arenaHeight/2 - 90}
	end
	while splitContents[index] ~= "|" do
		--print(splitContents[index])

		--local startingIndex = index - (#nodes*6) - (#walls*4)
		--print("index = ", index, splitContents[index])

		if splitContents[index] == "W" then
			addingNodes = false
			
			--startingIndex = startingIndex + 1
			--print("wall time")
			index = index + 1
		end

		--print(splitContents[index], splitContents[index] ~= "|", addingNodes) --true true
		if splitContents[index] ~= "|" then


			if fullsize then
				if addingNodes then
					local nodeDetails = {x = splitContents[index]*scale.x + scale.extraX, y = splitContents[index+1]*scale.y + scale.extraY, team = splitContents[index+2] , population = splitContents[index+3] ,
					 tier = 1, regenTimer = 5, tentaclesUsed = 0, effectTimer = 0, neutralPower = splitContents[index+4] , neutralTeam = splitContents[index+5] }
					table.insert(nodes, nodeDetails  )
					--print("team = ", nodeDetails.team, splitContents[index+2], "index = " ,index) --misaligned
					index = index + 5
				else
					table.insert(walls, {startX = splitContents[index]*scale.x + scale.extraX , startY = splitContents[index+1]*scale.y + scale.extraY , endX = splitContents[index+2]*scale.x + scale.extraX , endY = splitContents[index+3]*scale.y + scale.extraY } )
					index = index + 3
					--print("adding wall ", walls[#walls][4] )
				end
			else--preview
				if addingNodes then

					local nodeDetails = {x = splitContents[index]*scale.x + scale.extraX, y = splitContents[index+1]*scale.y + scale.extraY, team = splitContents[index+2] , population = splitContents[index+3] ,
					 tier = 1, regenTimer = 5, tentaclesUsed = 0, effectTimer = 0, neutralPower = splitContents[index+4] , neutralTeam = splitContents[index+5] }
					table.insert(previewNodes, nodeDetails  )
					--print("team = ", nodeDetails.team, splitContents[index+2], "index = " ,index) --misaligned
					index = index + 5
					for i = 0, 5 do
						tierChange(previewNodes[#previewNodes])
					end
					--print("tier = ", previewNodes[#previewNodes].tier)
				else
					print("problem: ", splitContents[index])
					print("index: ", index, " / ", #splitContents)
					table.insert(previewWalls, {startX = splitContents[index]*scale.x + scale.extraX , startY = splitContents[index+1]*scale.y + scale.extraY , endX = splitContents[index+2]*scale.x + scale.extraX , endY = splitContents[index+3]*scale.y + scale.extraY } )
					index = index + 3
					--print("adding wall ", previewWalls[#previewWalls][4] )
				end


			end
		else
			index = index - 1 --otherwise the next index++ skips over the | causing problems
		end

		index = index + 1
	end
	print("end load, ", #splitContents, splitContents[1])


	--return {customNodes, customWalls}
end

function manualSplit(aGivenString) -- or a:explode(b) ????? so a = "foo bar":explode(" ")  =>  tbl[1] --> foo

	local currentStringSegment = ""
	local outputTable = {}
	for index = 1, #aGivenString do
		local currentDigit = aGivenString:sub(index, index)
		if currentDigit == "," then
			--assert(type(currentStringSegment) == "string", "input must be a string")
			print("current segment : ", currentStringSegment:sub(-1, -1))
			while currentStringSegment:sub(-1, -1) == " " do --not working
				currentStringSegment = currentStringSegment:sub(0, #currentStringSegment-1)
				print("trailing spaces removed")
			end

			local currentNumberSegment = tonumber(currentStringSegment)
			if currentNumberSegment ~= nil then
				currentStringSegment = currentNumberSegment
			end
			print(currentStringSegment)
			--assert(type(currentStringSegment) == "number", "conversion failed!")
			table.insert(outputTable, currentStringSegment)
			
			currentStringSegment = ""
			
		elseif  currentDigit ~= " " or #currentStringSegment ~= 0 then --#currentStringSegment ~= 0 or
			currentStringSegment = currentStringSegment .. currentDigit
			
		end
		
	end



	--print(outputTable[1]..outputTable[2]..outputTable[3]..outputTable[4]..outputTable[5]..outputTable[6]..outputTable[7]..outputTable[8]..outputTable[9]..outputTable[10]..
		--outputTable[11]..outputTable[12]..outputTable[13]..outputTable[14]..outputTable[15]..outputTable[16]..outputTable[17]..outputTable[18]..outputTable[19]..outputTable[20])

	return outputTable
end


function exportLevel() 

	local exportDetails = "Level details to be copy pasted into levels file, not for use by players  \n\n Nodes Section: \n{	--level	\n"

	--[[
	{
		        x = arenaWidth / 2 -150,
		        y = arenaHeight / 3,
		        team = 2,  -- team starts from 1 for teamColours[team] to make sense, 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
		        population = 10,
		        tier = 1,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0, 
	            neutralPower = 20,
	            neutralTeam = 1  
		    },

		    {
	    		startX = arenaWidth/2.5,
	    		startY = arenaHeight/2.2, --lower
	    		endX = arenaWidth/1.9,
	    		endY = arenaHeight/2.3
    		}

	]]

	for nodeIndex, node in ipairs(nodes) do
		--x and y is percentage of window to allow changes in window size
		exportDetails = exportDetails  .. "	{ \n		x = " .. node.x/arenaWidth .. "*arenaWidth,\n		y =  ".. node.y/arenaHeight .. "*arenaHeight,\n		team =  " .. node.team .. ",\n		population =  " .. node.population .. 
		",\n		tier =  " .. node.tier .. ",\n		regenTimer = " .. nodeTiers[node.tier].regenDelay .. ", \n		tentaclesUsed = 0,\n		effectTimer = 0,\n		neutralPower = " .. node.neutralPower .. ",\n		neutralTeam =  " ..  node.neutralTeam .. "\n	}"

		if nodeIndex < #nodes then
			exportDetails = exportDetails  .. ",\n"
		else
		exportDetails = exportDetails  .. "	\n}\n"
		end
	end

	exportDetails = exportDetails .. "\nWalls section: \n {	--level	\n" 

	for wallIndex, wall in ipairs(walls) do

		exportDetails = exportDetails .. "	{ \n		startX = " .. wall.startX/arenaWidth .. "*arenaWidth,\n		startY =  ".. wall.startY/arenaHeight .. "*arenaHeight,\n		endX = " .. 
		wall.endX/arenaWidth .. "*arenaWidth,\n		endY =  ".. wall.endY/arenaHeight .. "*arenaHeight \n	}" 
		
		if wallIndex < #nodes then
			exportDetails = exportDetails  .. ",\n"
		else
			exportDetails = exportDetails  .. "	\n}\n"
		end
	end


	success, message = love.filesystem.write( "levelExportFile" , exportDetails, #exportDetails )
	print("SAVE: ", success, ". message: ", message)

end


function enemyAI()

	--wait 5 seconds before starting    -?

	-- attack closest node if it has at least half the targets population

	-- sends at 60 vs 30
	-- 60 vs 23 , opposes, recalls at 3
	-- vs 20 opposes
	-- vs 19 does not oppose
	-- halfway = 7/8

	-- distanced vs 24 opposes, half way = 10/11

	--further and max 40, 40vs40 no send, responds 

	-- 40 vs 10 close, sends at  20, opposes at 16, halfway =3or4
	--10v10 max 20 never sends
	-- close, 20vs20, sends at 22, opposes straight away 20, halfway =3/4
	--close 10vs10, sends at  21, opposes at 16

	--close 90vs20, sends at 22 aka 5 seconds, 
	--close 200vs10, sends at 21, halfway 2/3

	--far 200vs20, sends at 50, distance 32, opposes at 29
	--slightly less far, sends at 45, distance 28 

	-- 17 + distance?

	--40vs 20 close-ish, distance 10, sends at 24  	14
	--40vs20 further, distance 13 , sends at 29		15
	--40vs20 further. distance 18 , sends at 33		15
	--40vs30 further, distance 22, sends at 39		17

	-- enemies always go for closest enemy node grey or green
	-- then prioritises grey nodes over allies
	-- red never buffs allies
	-- purple buffs/attacks closest node, only buffs a node with less population
	-- calls back when around 2 or 3
	-- stays connected after taking over a node for a few (it varies) seconds then always splits, sometimes in the middle or at the end depending on population differences probably
	-- doesnt make many moves at once, slow, but 1 or 2 nodes can do 2 things in quick succession but not all at once

	
	-- NEW: table [1] is the distances from node 1 in order of distance, {distance, targetNode}. so when AI is looking at node 1's options look at if the distance: nodeDistances[1][1][2] is acceptable then create connection to node: nodeDistances[1][1][1]
	-- nodeDistances[1][1][2] means nodeDistances[the source node = 1] [1 = check the closest node] [2 = the distance]
	-- and nodeDistances[#nodeDistances] [#nodeDistances[1]] [1] means nodeDistances[the last node] [the furtherest away node from it] [that node's index]
	-- unreachable nodes including the node itself are simply not included here and therefor never considered as a target

	--print()
	--print("Check nodeDistances:")
	--print(#nodeDistances)
	--for c = 1, #nodeDistances do 
	--	print(#nodeDistances[c])
	--end

	--only make 1 action per call (for each enemy)
	local actionTaken = {false, false, false }

	--check nodes in a random order
	local randomizer = math.floor(love.math.random(0, (#nodes-0.1) ) )
	print("AI could do something?")
	for counter = #nodes, 1, -1 do
	--for nodeIndex, node in ipairs(nodes) do

		local nodeIndex = counter + randomizer
		

		
		if nodeIndex > #nodes then
			nodeIndex = nodeIndex - (#nodes)  -- 7 -> 1
		end
		
		
		
		local node = nodes[nodeIndex]
		--print(counter, nodeIndex, #nodes)
		
	
		
		--only act for enemy nodes
		if node.team > 2 and actionTaken[node.team-2] ~= true then 

			--only consider creating new tentacles for nodes with spare tentacles
			if node.tentaclesUsed < nodeTiers[node.tier].maxTentacles then
				--loop through each potential target node from closest to furthest away
				if #nodeDistances[nodeIndex] > 0 then
					for i = #nodeDistances[nodeIndex], 1, -1 do
						--print("looping: ", nodeIndex, i)
						local targetNodeAndDistance = nodeDistances[nodeIndex][i]
						--print("Node ", targetNodeAndDistance[1], ", Distance ", math.floor(targetNodeAndDistance[2]), "minimum population to move: ", math.floor(12 + 1.2* ((targetNodeAndDistance[2] - (2*nodeTiers[node.tier].radius))/(2*linkRadius+linkSpacing))))
						-- if there are enough population to reach the target and have at least 14,15,16,17 remaining     AND   not an ally with more population  
						--print(targetNodeAndDistance[1])
						--print(nodes[targetNodeAndDistance[1]].team)

						--issue here ######## - the code errors here, attempted to index a nil value or something


						if node.population > 12 + 1.2* ((targetNodeAndDistance[2] - (2*nodeTiers[node.tier].radius))/(2*linkRadius+linkSpacing))   and   
							(  nodes[targetNodeAndDistance[1]].team ~= node.team   or   nodes[targetNodeAndDistance[1]].population < node.population -30 ) then    -- adjust the +10, what population gap determines when purple helps an ally?

							-- check for duplicate connection
							local connectionAlreadyExists = false
							for connectionIndex, connection in ipairs(connections) do
								if connection.source == nodeIndex and connection.target == targetNodeAndDistance[1] then 
									connectionAlreadyExists = true
									--print("ignored duplicate: ", connection.source, " -> ", connection.target)
								end

							end



							-- check for wall intersection
							local wallIntersection = false
							for wallIndex, wall in ipairs(walls) do 
								ix, iy = findIntersectionPoint(nodes[nodeIndex].x, nodes[nodeIndex].y, nodes[targetNodeAndDistance[1]].x, nodes[targetNodeAndDistance[1]].y, wall.startX, wall.startY, wall.endX, wall.endY)
								if ix ~= nil and iy ~= nil then -- intersection exists
									wallIntersection = true
								end
							end



							if wallIntersection == false and connectionAlreadyExists == false then

								--create connection
								--print(targetNodeAndDistance[1])
								createConnection(nodeIndex, targetNodeAndDistance[1])
								actionTaken[node.team-2] = true
								print("AI doing a thing")
								--print("break!")
								break
							end
						end
					end
				end
			end

			for connectionIndex, connection in ipairs(connections) do 
				if connection.source == nodeIndex then

					--when to cut a tentacle

					--if same team 
					-- numbers should work for 200 vs 20 =stay, and 200 vs 140 = stay?, 20 vs 10=cut, 10 vs 20=cut, 50 vs 20=cut?
					if node.team == nodes[connection.target].team   and   node.population + 30  < nodes[connection.target].population then

						--if nodes[connection.target].population+30 > node.population

						ix, iy = connection.sourceEdge.x, connection.sourceEdge.y

						cutConnection(connectionIndex, connection, ix, iy)
						actionTaken[node.team-2] = true
						print("AI doing a thing - ", timer)
					end
				end
			end

		end
	end


end

function calculateNodeDistances()

	--works out the distances between all nodes and saves them to avoid being recalculated in future  sorted in order of closest to smallest { nodeIndex, dist}
	nodeDistances = {}
	for nodeIndex1, node1 in ipairs(nodes) do
		local eachNodesDistances = {}
		for nodeIndex2, node2 in ipairs(nodes) do
			if nodeIndex1 ~= nodeIndex2 then
				--check for walls and ignore distance if blocked
				if #walls > 0 then
					for wallIndex, wall in ipairs(walls) do
						ix, iy = findIntersectionPoint(wall.startX, wall.startY, wall.endX, wall.endY, node1.x, node1.y, node2.x, node2.y)
						if ix == nil and iy == nil then
							table.insert(eachNodesDistances, {nodeIndex2, distancebetween(node1.x, node1.y, node2.x, node2.y)})
						else
							--print("wall", nodeIndex1, " ", nodeIndex2)
						end
					end
				else
					table.insert(eachNodesDistances, {nodeIndex2, distancebetween(node1.x, node1.y, node2.x, node2.y)})
				end
			end
		end
		--sort			---- reverse order
		for distanceIndex1, distance1 in ipairs(eachNodesDistances) do
			for distanceIndex2, distance2 in ipairs(eachNodesDistances) do
				if distanceIndex1 ~= distanceIndex2 and distance1[2] > distance2[2] then
					eachNodesDistances[distanceIndex1], eachNodesDistances[distanceIndex2] = eachNodesDistances[distanceIndex2], eachNodesDistances[distanceIndex1] --swap places
				end
			end
		end
		table.insert(nodeDistances, eachNodesDistances)
	end

	print( "  __________  ")
	print(#nodeDistances, " - top parent, number of node distances")
	for ndIndex, nd in ipairs(nodeDistances) do
		print(#nd, " - number in this bracket")
		for xIndex, x in ipairs(nd) do
			print("contents: ",x[1], " & ", x[2])
		end
	end

end

function createSeed()
	-- 1 - 9 random numbers

	local seed = {}
	for r = 1, 20 do
		table.insert(seed, math.floor(math.random(1,9.9999 )))
	end
	return seed

end

function mouseEffect()

	for pointsIndex, points in ipairs(mouseEffectPoints) do 
		love.graphics.points(points.x +5*math.sin(timer%2*math.pi), points.y+5*math.cos(timer%2*math.pi))
	end
end



function love.draw(mouseX, mouseY)

	love.graphics.setBackgroundColor(1,1,1)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(current_background)

	love.graphics.setLineWidth(2)

	--grey control bar at the bottom
	if current_background == game_background then
		love.graphics.setColor(0,0,0,0.6)
		love.graphics.rectangle('fill', 0, arenaHeight-60, arenaWidth, arenaHeight)

		love.graphics.setFont(font30)
		love.graphics.setColor(1,1,1)
		love.graphics.printf("Tentacle Wars - Remake", arenaWidth/2-200, arenaHeight-50, 400 , 'center')
	end

	--editor bar
	if editor then
		love.graphics.setColor(0.1,0.2,0.2)
		love.graphics.rectangle('fill', 0, 0, arenaWidth, 60)

	end

	--love.graphics.print("hi", 200,200)

	--menu
	if current_background == menu_background then

		--title
		love.graphics.setFont(titlefont)
		--black outline:
		love.graphics.setColor(0,0,0)
		love.graphics.printf("Tentacle Wars", 0-5, 30, arenaWidth , 'center')
		love.graphics.printf("Tentacle Wars", 0+5, 30, arenaWidth , 'center')
		love.graphics.printf("Tentacle Wars", 0, 30+5, arenaWidth , 'center')
		love.graphics.printf("Tentacle Wars", 0, 30-5, arenaWidth , 'center')


		--title in white
		love.graphics.setColor(1,1,1)
		love.graphics.printf("Tentacle Wars", 0, 30, arenaWidth , 'center')
		
		--level display inner circle and lines
		love.graphics.setColor(1,1,1)
		love.graphics.circle('line',arenaWidth/2,arenaHeight/2+50,180)
		for i = 0, 19 do
			love.graphics.line(arenaWidth/2+180*(math.sin(2*math.pi*i/20)),   arenaHeight/2+50-180*(math.cos(2*math.pi*i/20)), 
				arenaWidth/2+ ((math.ceil((levelProgress[i+1]/3)%1))*60 + 235)*(math.sin(2*math.pi*i/20)),    arenaHeight/2+50- ((math.ceil((levelProgress[i+1]/3)%1))*60 + 235)*(math.cos(2*math.pi*i/20)) )
		end

		love.graphics.setFont(font14)
		--menu wigglers
		love.graphics.setLineWidth(1)

		local menuWigglerX, menuWigglerY = arenaWidth/2+180*(math.sin(2*math.pi*0)),   arenaHeight/2+50-180*(math.cos(2*math.pi*0))

		love.graphics.translate(arenaWidth/2,arenaHeight/2+50)
		love.graphics.rotate(math.pi/20) --half turn so that wigglers are not on level lines
		love.graphics.translate(-arenaWidth/2, -(arenaHeight/2+50))

		for seedIndex, number in ipairs(menuWigglerSeed) do
			love.graphics.setColor(1,1,1)
			--if seedIndex == 2 then
				--love.graphics.setColor(1,0,0)
			--end

			--1-3 = short, 4-6 = medium, 7-9 = long
			--1,4,7 = no bobble.  2,5,8 = grey bobble.   3,6,9 = black bobble.
			-- length ciel( number /3 ) == 1,2,3 = s,m,l
			-- bobble number%3 = 1,2,0 = /,g,b


			--local menuWigglerX, menuWigglerY = arenaWidth/2+180*(math.sin(2*math.pi*(seedIndex+0.5)/20)),   arenaHeight/2+50-180*(math.cos(2*math.pi*(seedIndex+0.5)/20))

			--love.graphics.print(seedIndex,menuWigglerX, menuWigglerY)
			love.graphics.line(
				menuWigglerX, 
				menuWigglerY,
				menuWigglerX + (((math.sin(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%1.6)*1.25*math.pi)*7))*(math.ceil(number/3)/30+0.2)), 
				menuWigglerY-(6+ 4*math.ceil(number/3)) - (((math.cos(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%0.8)*2.25*math.pi)*0.8))*1),
				menuWigglerX + (((math.sin(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%1.6)*1.25*math.pi)*7))*(math.ceil(number/3)/12+0.4)), 
				menuWigglerY-(8+ 7*math.ceil(number/3)) - (((math.cos(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%0.8)*2.25*math.pi)*0.8))*1),
				menuWigglerX + (((math.sin(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%1.6)*1.25*math.pi)*7))*(math.ceil(number/3)/6+0.8)), 
				menuWigglerY-(10+ 10*math.ceil(number/3))  -(((math.cos(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%0.8)*2.25*math.pi)*0.8))*1))
			--bobbles
			if number % 3 ~= 1 then
				if number % 3 == 2 then
					--grey
					love.graphics.setColor(teamColours[1])
				else
					--black
					love.graphics.setColor(0,0,0)
				end
				love.graphics.circle('fill',
					menuWigglerX + (((math.sin(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%1.6)*1.25*math.pi)*7))*(math.ceil(number/3)/6+0.8)), 
				menuWigglerY-(10+ 10*math.ceil(number/3)) - (((math.cos(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%0.8)*2.25*math.pi)*0.8))*1),   6)

				--border
				love.graphics.setColor(1,1,1)
				love.graphics.circle('line',
					menuWigglerX + (((math.sin(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%1.6)*1.25*math.pi)*7))*(math.ceil(number/3)/6+0.8)), 
				menuWigglerY-(10+ 10*math.ceil(number/3)) - (((math.cos(((timer+(seedIndex*number/2.5)+seedIndex/1.9)%0.8)*2.25*math.pi)*0.8))*1),   6)

			end



			--[[for looper = 1, 20 do
				love.graphics.points(
					50+menuWigglerX + 5*(((math.sin(((timer+(looper*number/2.5)+looper/1.9)%1.6)*1.25*math.pi)*6))*1), 
					50+menuWigglerY-14-10*(((math.cos(((timer+(looper*number/2.5)+looper/1.9)%0.8)*2.25*math.pi)*0.8))*1))
			end]]
					


			--[[love.graphics.line(node.x, node.y-nodeTiers[node.tier].radius - InnerWobblerRadius, 
							node.x+(((math.sin(((timer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*0.1), node.y-(nodeTiers[node.tier].radius)-(2+1.5*node.tier)+(((math.sin(((timer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.2) - InnerWobblerRadius,
							node.x+(((math.sin(((timer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*0.2), node.y-(nodeTiers[node.tier].radius)-(2+3*node.tier)+(((math.sin(((timer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.3) - InnerWobblerRadius,
							node.x+(((math.sin(((timer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*0.5), node.y-(nodeTiers[node.tier].radius)-(2+4.5*node.tier)+(((math.sin(((timer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.6) - InnerWobblerRadius,
							node.x+(((math.sin(((timer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*1), node.y-(nodeTiers[node.tier].radius)-(2+6*node.tier)+(((math.sin(((timer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1) - InnerWobblerRadius)
					]]

			--rotate the whole screen centred on the node, and draw another set of feeler and wobblers each loop
			love.graphics.translate(arenaWidth/2,arenaHeight/2+50)
			love.graphics.rotate(math.pi/10)
			love.graphics.translate(-arenaWidth/2, -(arenaHeight/2+50))

		end

		love.graphics.origin()
	end

	love.graphics.setFont(font14)


	--draw buttons original position was here


	love.graphics.setFont(font14)
	love.graphics.setColor(1,1,1,1)
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 60)

	love.graphics.print("Logic updates per second: "..FPSlogicActual.."/"..FPSlogicTarget, 120, 60)

	love.graphics.print(string.format("Average frame time: %.3f ms", 1000 * love.timer.getAverageDelta()), 420, 60)

	love.graphics.setFont(font21)

	love.graphics.print("ZONE: ".. currentLevel, 20,20)
	love.graphics.print("POWER LIMIT: ".. powerLimit, 160,20)
	love.graphics.print("TIME: ".. math.floor(timer), arenaWidth-170,70)

	love.graphics.setFont(font14)

	love.graphics.print("buttons On Screen: " .. #buttonsOnScreen, 250,90)
	love.graphics.print("editor: " .. tostring(editor), 430,90)
	love.graphics.print("nodes: " .. #nodes, 560,90)


	--draw total power ratio bar
	local totalTeamPowers = {0,0,0,0,0}
	local totalPower = 0
	--count power
	for nodeIndex, node in ipairs(nodes) do
		if node.team > 1 then
			totalTeamPowers[node.team] = totalTeamPowers[node.team] + node.population
			totalPower = totalPower + node.population
		end
	end
	--display power bar
	local powerProgress = 0
	for team, teamPower in ipairs(totalTeamPowers) do
		love.graphics.setColor(teamColours[team])
		love.graphics.rectangle('fill', arenaWidth-230+powerProgress, 30, 200*teamPower/totalPower,20)

		--border (per team to get the line between colours)
		love.graphics.setColor(1,1,1,1)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle('line', arenaWidth-230+powerProgress, 30, 200*teamPower/totalPower,20)

		powerProgress = powerProgress+(200*teamPower/totalPower)
	end


	--highlight
	local highlightedNode = isMouseInNode()
	if editor == false then
		
		if highlightedNode > 0 then
			love.graphics.setColor(0.9, 0.9, 0.2, 0.4)
			love.graphics.circle('fill', nodes[highlightedNode].x, nodes[highlightedNode].y, nodeTiers[nodes[highlightedNode].tier].radius+2)
		end
	--[[elseif nodeSelected > 0 then
		love.graphics.setColor(0.9, 0.9, 0.2, 0.3)
		love.graphics.circle('fill', nodes[nodeSelected].x, nodes[nodeSelected].y, nodeTiers[nodes[highlightedNode].tier].radius)]]
	else
		if editorSelected.index > 0 then
			if editorSelected.node and #nodes > 0 then --node
				love.graphics.setColor(0.9, 0.9, 0.2, 0.4)
				love.graphics.circle('fill', nodes[editorSelected.index].x, nodes[editorSelected.index].y, nodeTiers[nodes[editorSelected.index].tier].radius+2)
			end
			--wall highlight is done on wall creation as the shape is too complicated to redo again here
		end
	end

	


	mouseEffect()



	-- node ping affect on change
	-- effect timer counts down to 0 as the circle's radius increases and the circle fades out
	for nodeIndex, node in ipairs(nodes) do
		if node.effectTimer > 0 then
			--timer updates in love.update
			--print("EFFECT! ")
			love.graphics.setColor(1, 1, 1, 2*node.effectTimer)
			love.graphics.setLineWidth( (node.tier + 7/(node.effectTimer+0.5)) -4 ) --5-12
			love.graphics.circle('line',node.x, node.y, nodeTiers[node.tier].radius+60*(0.5-node.effectTimer)*((nodeTiers[node.tier].radius)/35))
		end

		-- node distances display
		--[[love.graphics.setColor(1, 1, 1)
		if #nodeDistances == #nodes then
			for x, nodeDistance in ipairs(nodeDistances[nodeIndex]) do
				love.graphics.print(nodeDistance[1].. " , ".. nodeDistance[2], node.x, node.y+50+(x*30))
			end
		end
		]]

	end



	--connection links, link wigglers
	for connectionIndex, connection in ipairs(connections) do 

		love.graphics.setColor(0.9, 0.9, 0.2)
		love.graphics.print("destination: "..connection.destination,connection.connectionMidPoint.x, connection.connectionMidPoint.y)
		love.graphics.print("opposing: "..connection.opposedConnectionIndex.."/"..#connections,connection.connectionMidPoint.x+nodes[connection.source].x%50, connection.connectionMidPoint.y+50+nodes[connection.source].y%50)


		-- link making and wobble:
				-- ((timer%2)*math.pi)  > this moves smoothly and linearly from 0 to 359.9
				-- the sin of that varies non linearly, like a sin wave from 0 to 1 to -1 to 0
				-- then that number is scaled up relative to the X or Y linkStep, 
				-- the bigger the X step the more it should wobble in Y, hence the flipped X or Y step for scaling
				-- /3 at the end so the wobble is less dramatic 
				-- first divide (/15) determines the difference between each link and therefore wavelength
				-- % mod determines wobble speed, frequency?
		local xWobble = 0
		local yWobble = 0
		--this is a link loop its just weird, starting early and calculating for the one ahead, to be assigned next loop, needed for link wiggler point direction
		for Index = 0, #connection.links  do
		
			-- this is a bit wierd, the first loop through creates the next wobble i.e. for link 1, then the next loop we set "next wobble" to current wobble and create the next wobble for link 2 then give link 1 the current wobble 
			local nextXWobble = 0
			local nextYWobble = 0
			if (Index+1 > 2 and Index < #connection.links -2) or (connection.moving == true and connection.destination ~= 3) then
				nextXWobble = (math.sin(((sessionTimer-((Index+1)/10))%1.6)*1.25*math.pi))*connection.linkYStep/2.5
				nextYWobble = (math.sin(((sessionTimer-((Index+1)/10))%1.6)*1.25*math.pi))*connection.linkXStep/2.5
			elseif Index+1 == 2 or Index == #connection.links -2 then
				nextXWobble = (math.sin(((sessionTimer-((Index+1)/10))%1.6)*1.25*math.pi))*connection.linkYStep/5
				nextYWobble = (math.sin(((sessionTimer-((Index+1)/10))%1.6)*1.25*math.pi))*connection.linkXStep/5

			end

			--bigger wobble when moving?
			--[[if connection.moving == true then
				nextXWobble = 1.5*nextXWobble
				nextYWobble = 1.5*nextYWobble
			end]]

			if Index > 0 then
				
				--linkWigglers
					-- links needs to be infront of node feelers, maybe redo this loop with just this bit, after node creation

				love.graphics.setColor(1, 1, 1)
				love.graphics.setLineWidth( 1 )
				for glowerIndex, glower in ipairs(connection.glowing) do
					if glower == Index then
						love.graphics.setColor(1, 1, 0)
						love.graphics.setLineWidth( 2 )
					end
				end


				if (connection.moving == true or Index+1 > 2) and Index < #connection.links  then  --- switching this to index+1 and removing the "-1" from lin

					local linkToTargetDist = 500
					if connection.destination == 1 then
						-- if something flags here its probably to do with tentacle end 
						--print(connection.opposedConnectionIndex, " & ", connectionIndex)
						--print(connection.opposedConnectionIndex, " / ", #connections, " & also ... ", connectionIndex, connection.source, connection.team )
						--print(connections[connection.opposedConnectionIndex].tentacleEnd.x) -- issues here, opposedconnection index
						if connection.opposedConnectionIndex <= #connections then
							linkToTargetDist = distancebetween(connection.links[Index].x, connection.links[Index].y, (connection.tentacleEnd.x + connections[connection.opposedConnectionIndex].tentacleEnd.x)/2, (connection.tentacleEnd.y + connections[connection.opposedConnectionIndex].tentacleEnd.y)/2) --ignores wobble
						end
					else
						linkToTargetDist = distancebetween(connection.links[Index].x, connection.links[Index].y, connection.targetEdge.x, connection.targetEdge.y) --ignores wobble
					end
					local linkToSourceDist = distancebetween(connection.links[Index].x, connection.links[Index].y, connection.sourceEdge.x, connection.sourceEdge.y) 

					if connection.moving == true and linkToTargetDist < 2*linkRadius + 2*linkSpacing + 10*linkRadius then -- 108 to 0 away, 2 was 59
						--reduce wobble when close, to avoid lock on jump
						xWobble = xWobble*linkToTargetDist/108
						yWobble = yWobble*linkToTargetDist/108
					end

					local wigglerShrink = 1
					if linkToTargetDist < 2*linkRadius + 2*linkSpacing + 10*linkRadius then --arbitrary numbers here to get desired effect
						wigglerShrink = (linkToTargetDist/108) * (linkToTargetDist/108)
					elseif linkToSourceDist < 2*linkRadius + 2*linkSpacing + 10*linkRadius then
						wigglerShrink = (linkToSourceDist/108) * (linkToSourceDist/108)
					end

					if (wigglerShrink < 0.14) then
						wigglerShrink = 0.14
					end


					local nextLinkCentre = {x = connection.links[Index+1].x-nextXWobble, y = connection.links[Index+1].y+nextYWobble}  
					local linkCentre = {x = connection.links[Index].x-xWobble, y = connection.links[Index].y+yWobble}
					local angleFromY = calculateSourceYAngleAny(nextLinkCentre,linkCentre)
					
					--drawing link wigglers, todo: add another line so its more curved
					--love.graphics.setColor(1,1,1)
					
					love.graphics.translate(linkCentre.x, linkCentre.y)
					love.graphics.rotate(-angleFromY)

					-- left side wigglers
					love.graphics.line(
						-linkRadius/2, 
						-linkRadius/1.15,
						-5 +(((math.cos(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2+0.5*math.pi)*5))*0.1), 
						-(1.6*linkRadius)+(((math.sin(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*0.2))

					love.graphics.line( -5 +(((math.cos(((math.abs(sessionTimer%00.625-0.3125))%0.3125)*6.4*math.pi/2+0.5*math.pi)*5))*0.1), 
						-(1.6*linkRadius)+(((math.sin(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*0.2),
						---20+(((math.cos(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*5))*0.3), 
						--6-(3*linkRadius)+(((math.sin(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*4),
						2/wigglerShrink-22+(((math.cos(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*5))*0.3), 
						1/wigglerShrink+2-(3*linkRadius)+(((math.sin(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*4))
					
					--flip coordinates along the rotated y axis
					love.graphics.scale(1,-1)

					-- right side wigglers
					love.graphics.line(
						-linkRadius/2, 
						-linkRadius/1.15,
						-5 +(((math.cos(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2+0.5*math.pi)*5))*0.1), 
						-(1.6*linkRadius)+(((math.sin(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*0.2))
					--love.graphics.setColor(teamColours[connection.team-1]) --green
					love.graphics.line( -5 +(((math.cos(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2+0.5*math.pi)*5))*0.1), 
						-(1.6*linkRadius)+(((math.sin(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*0.2),	
						2/wigglerShrink-22+(((math.cos(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*5))*0.3), 
						1/wigglerShrink+2-(3*linkRadius)+(((math.sin(((math.abs(sessionTimer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*4))

					--revert to normal
					love.graphics.scale(1,-1)
					love.graphics.rotate(angleFromY)
					love.graphics.translate(-linkCentre.x, -linkCentre.y)

				end


				-- link border
				love.graphics.circle('line', connection.links[Index].x-xWobble, connection.links[Index].y+yWobble, linkRadius)
	
				love.graphics.setColor(teamColours[connection.team])
				--link
				love.graphics.circle('fill', connection.links[Index].x-xWobble, connection.links[Index].y+yWobble, linkRadius-2)				-- when tentacles fighting at midpoint, the middle links gets the responder's colour (not the first attacker)

			end
			xWobble = nextXWobble
			yWobble = nextYWobble
		end

		if connection.destination == 1 and #connections >= connection.opposedConnectionIndex then
			if (connection.moving == false) then
				--create midpoint link
				love.graphics.setColor(teamColours[connection.team])
				-- animation spinning midpoint
				--love.graphics.arc( 'fill', 'pie', (connection.tentacleEnd.x +connections[connection.opposedConnectionIndex].tentacleEnd.x)/2, (connection.tentacleEnd.y + connections[connection.opposedConnectionIndex].tentacleEnd.y)/2, linkRadius, 2*(sessionTimer%math.pi), math.pi+ 2*(sessionTimer%math.pi))
				love.graphics.arc( 'fill', 'pie', connection.connectionMidPoint.x, connection.connectionMidPoint.y,linkRadius, 2*(sessionTimer%math.pi), math.pi+ 2*(sessionTimer%math.pi))

				love.graphics.setColor(teamColours[connections[connection.opposedConnectionIndex].team])
				--love.graphics.arc( 'fill', 'pie', (connection.tentacleEnd.x +connections[connection.opposedConnectionIndex].tentacleEnd.x)/2, (connection.tentacleEnd.y + connections[connection.opposedConnectionIndex].tentacleEnd.y)/2, linkRadius, math.pi+ 2*(sessionTimer%math.pi), 2*math.pi+ 2*(sessionTimer%math.pi))
				love.graphics.arc( 'fill', 'pie', connection.connectionMidPoint.x, connection.connectionMidPoint.y,linkRadius, math.pi+ 2*(sessionTimer%math.pi), 2*math.pi+ 2*(sessionTimer%math.pi))

				-- midpoint border
				love.graphics.setColor(1, 1, 1)
				love.graphics.setLineWidth( 1 )
				--love.graphics.circle('line', (connection.tentacleEnd.x +connections[connection.opposedConnectionIndex].tentacleEnd.x)/2, (connection.tentacleEnd.y + connections[connection.opposedConnectionIndex].tentacleEnd.y)/2, linkRadius+1)
				love.graphics.circle('line', connection.connectionMidPoint.x, connection.connectionMidPoint.y, linkRadius+1)
			elseif distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connections[connection.opposedConnectionIndex].tentacleEnd.x, connections[connection.opposedConnectionIndex].tentacleEnd.y) < 2 then


			end
		end
	end


	-- draw all nodes and population number
	for nodeIndex, node in ipairs(nodes) do

		love.graphics.setFont(font14 )
		love.graphics.setColor(1,1,1)
		love.graphics.print("node index: "..nodeIndex,node.x+100, node.y)

		--background
		love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
		love.graphics.circle('fill', node.x, node.y, nodeTiers[node.tier].radius)

		-- draw node depending on team colour
		love.graphics.setColor(teamColours[node.team])
		--darken the colour when weak
		if node.population < 5 and node.team ~= 1 then
			local weakColour = {}
			for i = 1, 3 do
				weakColour[i] = teamColours[node.team][i]*(0.5+node.population/10)
			end
			love.graphics.setColor(weakColour)
		end
		-- draw node
		--centre
		love.graphics.circle('fill', node.x, node.y, nodeCentreRadius)
		-- node border
		love.graphics.setColor(1, 1, 1)
		love.graphics.setLineWidth( 3 )
		love.graphics.circle('line', node.x, node.y, nodeCentreRadius)
		-- outer node ring
		love.graphics.circle('line', node.x, node.y, nodeTiers[node.tier].radius)

		--node feelers and wobblers
		love.graphics.setLineWidth( 1 )

		
			
		for i = 1, 8 do
			if editor then
				if nodeIndex == editorSelected.index  then
					love.graphics.setColor(1, 1, 0.8)
				end
			else
				if nodeIndex == highlightedNode then
					love.graphics.setColor(1, 1, 0.8)
				end
			end

			if node.tier > 1 then
				if node.tier == 2 then
					--node feelers
					love.graphics.line(node.x, node.y-(nodeTiers[node.tier].radius), 
						node.x+(((math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*0.1), node.y-(nodeTiers[node.tier].radius)+(((math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.1),
						node.x+(((math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*0.2), node.y-(nodeTiers[node.tier].radius)-5+(((math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.2),
						node.x+(((math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*0.5), node.y-(nodeTiers[node.tier].radius)-10+(((math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.5),
						node.x+(((math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*1), node.y-(nodeTiers[node.tier].radius)-15+(((math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1))
				elseif node.tier > 2 then

					--node first inner wobblers
					local InnerWobblerRadius = 3.4*(math.sin((sessionTimer+(3*nodeIndex+i*(3*(i+1.1))%1.38)%1)*2*math.pi)+2)
					love.graphics.setColor(teamColours[node.team])
					love.graphics.circle('fill', node.x, node.y-nodeTiers[node.tier].radius, InnerWobblerRadius)
					--print(sessionTimer)
					--border
					love.graphics.setColor(1, 1, 1)
					love.graphics.circle('line', node.x, node.y-nodeTiers[node.tier].radius, InnerWobblerRadius)

					if node.tier ~= 5 then
					--node feelers
						if editor then
							if nodeIndex == editorSelected.index  then
								love.graphics.setColor(1, 1, 0.8)
							end
						else
							if nodeIndex == highlightedNode then
								love.graphics.setColor(1, 1, 0.8)
							end
						end

						love.graphics.line(node.x, node.y-nodeTiers[node.tier].radius - InnerWobblerRadius, 
							node.x+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*0.1), node.y-(nodeTiers[node.tier].radius)-(2+1.5*node.tier)+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.2) - InnerWobblerRadius,
							node.x+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*0.2), node.y-(nodeTiers[node.tier].radius)-(2+3*node.tier)+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.3) - InnerWobblerRadius,
							node.x+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*0.5), node.y-(nodeTiers[node.tier].radius)-(2+4.5*node.tier)+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.6) - InnerWobblerRadius,
							node.x+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*1), node.y-(nodeTiers[node.tier].radius)-(2+6*node.tier)+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1) - InnerWobblerRadius)
					
						
						if node.tier > 3 then
							--outer wobblers
							love.graphics.setColor(teamColours[node.team])
							love.graphics.circle('fill', node.x+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*1), node.y-(nodeTiers[node.tier].radius)-(2+6*node.tier)+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1) - InnerWobblerRadius,
								linkRadius-2)
							--border
							love.graphics.setColor(1, 1, 1)
							love.graphics.circle('line',  node.x+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*1), node.y-(nodeTiers[node.tier].radius)-(2+6*node.tier)+(((math.sin(((sessionTimer+(i*nodeIndex/2.5)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1) - InnerWobblerRadius,
								linkRadius-2)
							
							--fix outer wobbler to follow this path:    --TODO
							--[[for a = 1, 24 do
								love.graphics.points(node.x-(math.sin(((a)%1.6)*1.25*math.pi))*0.9*10, node.y-(nodeTiers[node.tier].radius)-27-(((math.cos(((a)%0.8)*2.5*math.pi))*1)*1))
							end]]

							if node.tier == 6 then --Predator
								-- each wobbler gets 3 side wobblers around it
								for b = 1,3 do
									-- side wobbler
									love.graphics.setColor(teamColours[node.team])
									love.graphics.circle('fill',node.x-(math.sin(((sessionTimer+(2*b*i*nodeIndex/2.3)+b+i/1.9)%1)*2*math.pi))*(0.4+InnerWobblerRadius/20)*10, 
										node.y-(nodeTiers[node.tier].radius)-(((math.cos(((sessionTimer+(2*b*i*nodeIndex/2.3)+b+i/1.9)%0.5)*4*math.pi))*(2.5-InnerWobblerRadius/10))*1)- InnerWobblerRadius-8, 2.7*(math.sin(((sessionTimer+(2*b*i*nodeIndex/2.3)+b+i/1.9)%1)*2*math.pi)+2))
									-- border
									love.graphics.setColor(1, 1, 1)
									love.graphics.circle('line',node.x-(math.sin(((sessionTimer+(2*b*i*nodeIndex/2.3)+b+i/1.9)%1)*2*math.pi))*(0.4+InnerWobblerRadius/20)*10, 
										node.y-(nodeTiers[node.tier].radius)-(((math.cos(((sessionTimer+(2*b*i*nodeIndex/2.3)+b+i/1.9)%0.5)*4*math.pi))*(2.5-InnerWobblerRadius/10))*1)- InnerWobblerRadius-8, 2.7*(math.sin(((sessionTimer+(2*b*i*nodeIndex/2.3)+b+i/1.9)%1)*2*math.pi)+2))

									--rotate the whole screen centred on the wobbler
									love.graphics.translate(node.x, node.y-nodeTiers[node.tier].radius)
									love.graphics.rotate(math.pi/1.5)
									love.graphics.translate(-node.x, -(node.y-nodeTiers[node.tier].radius))
								end
							end
						end

					elseif node.tier == 5 then --ant - 2 feelers each and basic extra wobblers

						if editor then
							if nodeIndex == editorSelected.index  then
								love.graphics.setColor(1, 1, 0.8)
							end
						else
							if nodeIndex == highlightedNode then
								love.graphics.setColor(1, 1, 0.8)
							end
						end

						--rotate the whole screen centred on the node, redraw the feeler
						love.graphics.translate(node.x-2.5, node.y-(nodeTiers[node.tier].radius) - InnerWobblerRadius)
						love.graphics.rotate(-0.45)
						love.graphics.translate(-(node.x-2.5), -(node.y-(nodeTiers[node.tier].radius) - InnerWobblerRadius))

						love.graphics.line(node.x-2.5, node.y-nodeTiers[node.tier].radius - InnerWobblerRadius, 
						node.x-2-(math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi))*0.9*1, node.y-2-(nodeTiers[node.tier].radius)-(((math.cos(((sessionTimer+(i*nodeIndex/10)+i/1.9)%0.8)*2.5*math.pi))*1)*0.5) - InnerWobblerRadius,
						node.x-1-(math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi))*0.9*2, node.y-1-(nodeTiers[node.tier].radius)-9-(((math.cos(((sessionTimer+(i*nodeIndex/10)+i/1.9)%0.8)*2.5*math.pi))*1)*0.6) - InnerWobblerRadius,
						node.x-(math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi))*0.9*5, node.y-(nodeTiers[node.tier].radius)-18-(((math.cos(((sessionTimer+(i*nodeIndex/10)+i/1.9)%0.8)*2.5*math.pi))*1)*0.8) - InnerWobblerRadius,
						node.x-(math.sin(((sessionTimer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi))*0.9*10, node.y-(nodeTiers[node.tier].radius)-27-(((math.cos(((sessionTimer+(i*nodeIndex/10)+i/1.9)%0.8)*2.5*math.pi))*1)*1) - InnerWobblerRadius)

						love.graphics.translate(node.x-2.5, node.y-(nodeTiers[node.tier].radius) - InnerWobblerRadius)
						love.graphics.rotate(0.45)
						love.graphics.translate(-(node.x-2.5), -(node.y-(nodeTiers[node.tier].radius) - InnerWobblerRadius))

						love.graphics.translate(node.x+2.5, node.y-(nodeTiers[node.tier].radius) - InnerWobblerRadius)
						love.graphics.rotate(0.45)
						love.graphics.translate(-(node.x+2.5), -(node.y-(nodeTiers[node.tier].radius) - InnerWobblerRadius))

						love.graphics.line(node.x+2.5, node.y-(nodeTiers[node.tier].radius) - InnerWobblerRadius, 
						node.x+2+(math.sin(((sessionTimer+(3+i*nodeIndex/7)+i/0.9)%1.6)*1.25*math.pi))*0.9*1, node.y-2-(nodeTiers[node.tier].radius)-(((math.cos(((sessionTimer+(3+i*nodeIndex/7)+i/0.9)%0.8)*2.5*math.pi))*1)*0.5) - InnerWobblerRadius,
						node.x+1+(math.sin(((sessionTimer+(3+i*nodeIndex/7)+i/0.9)%1.6)*1.25*math.pi))*0.9*2, node.y-1-(nodeTiers[node.tier].radius)-9-(((math.cos(((sessionTimer+(3+i*nodeIndex/7)+i/0.9)%0.8)*2.5*math.pi))*1)*0.6) - InnerWobblerRadius,
						node.x+(math.sin(((sessionTimer+(3+i*nodeIndex/7)+i/0.9)%1.6)*1.25*math.pi))*0.9*5, node.y-(nodeTiers[node.tier].radius)-18-(((math.cos(((sessionTimer+(3+i*nodeIndex/7)+i/0.9)%0.8)*2.5*math.pi))*1)*0.8) - InnerWobblerRadius,
						node.x+(math.sin(((sessionTimer+(3+i*nodeIndex/7)+i/0.9)%1.6)*1.25*math.pi))*0.9*10, node.y-(nodeTiers[node.tier].radius)-27-(((math.cos(((sessionTimer+(3+i*nodeIndex/7)+i/0.9)%0.8)*2.5*math.pi))*1)*1) - InnerWobblerRadius)

						--rotate back to where we started this loop 
						love.graphics.translate(node.x+2.5, node.y-(nodeTiers[node.tier].radius) - InnerWobblerRadius)
						love.graphics.rotate(-0.45)
						love.graphics.translate(-(node.x+2.5), -(node.y-(nodeTiers[node.tier].radius) - InnerWobblerRadius))


						--outer wobblers
							love.graphics.setColor(teamColours[node.team])
							love.graphics.circle('fill', node.x+(11+InnerWobblerRadius*0.5), node.y-4-nodeTiers[node.tier].radius - (InnerWobblerRadius*0.5), 2.2*(math.sin((sessionTimer+(3*nodeIndex+i*(2.5*(i+1.1))%1.38)%1)*2*math.pi)+2))
							love.graphics.circle('fill', node.x-(11+InnerWobblerRadius*0.5), node.y-4-nodeTiers[node.tier].radius - (InnerWobblerRadius*0.5), 2.2*(math.sin((sessionTimer+(3*nodeIndex+i*(3.5*(i+1.1))%1.38)%1)*2*math.pi)+2))

							--border
							love.graphics.setColor(1, 1, 1)
							love.graphics.circle('line', node.x+(11+InnerWobblerRadius*0.5), node.y-4-nodeTiers[node.tier].radius - (InnerWobblerRadius*0.5), 2.2*(math.sin((sessionTimer+(3*nodeIndex+i*(2.5*(i+1.1))%1.38)%1)*2*math.pi)+2))
							love.graphics.circle('line', node.x-(11+InnerWobblerRadius*0.5), node.y-4-nodeTiers[node.tier].radius - (InnerWobblerRadius*0.5), 2.2*(math.sin((sessionTimer+(3*nodeIndex+i*(3.5*(i+1.1))%1.38)%1)*2*math.pi)+2))
						

					end

				end

				--rotate the whole screen centred on the node, and draw another set of feeler and wobblers each loop
				love.graphics.translate(node.x, node.y)
				love.graphics.rotate(math.pi/4)
				love.graphics.translate(-node.x, -node.y) -- I think this sets the origin back to 0,0 but with everything now rotated
			end
		end
		-- unrotates and resets origin  -- maybe not necessary since we should be back round 360 anyway but we'll play it safe
		love.graphics.origin()
		

		-- draw population number or occupation progress 
		if node.team > 1 then
			-- draw population number
			love.graphics.setFont(nodefont27)  -- To-Do: make font bold
			love.graphics.setColor(1, 1, 1)
			love.graphics.printf(node.population, node.x-nodeTiers[node.tier].radius, node.y-19, 2*nodeTiers[node.tier].radius, "center")
		else
			--draw occupation progress on neutral nodes
			love.graphics.setColor(teamColours[node.neutralTeam])
			love.graphics.circle('fill', node.x, node.y, (math.sin(sessionTimer%1*math.pi*2)/8+0.875) * (nodeCentreRadius* (node.population / math.floor(node.neutralPower/3))))
			--border
			love.graphics.setColor(1,1,1)
			love.graphics.circle('line', node.x, node.y, (math.sin(sessionTimer%1*math.pi*2)/8+0.875) * (nodeCentreRadius* (node.population / math.floor(node.neutralPower/3))))
		end

		--used and available tentacles
		if node.team > 1 then -- move this to include population number later, so it doesnt show on grey nodes either
			for i = 1, nodeTiers[node.tier].maxTentacles do


				if i <= node.tentaclesUsed then
					love.graphics.setColor(0,0,0)
				else
					love.graphics.setColor(teamColours[1])
				end

				-- 1/1 = 0  -   1/2 = -1,  2/2 = 1    -    1/3 = -2,  2/3 = 0,  3/3 = 2

				-- a-b=0 		-1 			0  				-2 			-1 			0

				-- (a-b) * 2 +b-1 - works!



				love.graphics.circle('fill', node.x + 3.8*((i-nodeTiers[node.tier].maxTentacles)*2 + nodeTiers[node.tier].maxTentacles -1)  , node.y+12, linkRadius-3)     


				--border
				love.graphics.setColor(1,1,1)
				love.graphics.circle('line', node.x + 3.8*((i-nodeTiers[node.tier].maxTentacles)*2 + nodeTiers[node.tier].maxTentacles -1)  , node.y+12, linkRadius-3)
			end
		end
	end

	-- draw all walls
	for wallIndex, wall in ipairs(walls) do

		--draw wall grip points editor guide
		if editor then
			love.graphics.setColor(1,1,1)
			for g = 1, 20 do
				love.graphics.points(wall.startX+math.sin(g/10*math.pi)*70, wall.startY+math.cos(g/10*math.pi)*70)
				love.graphics.points(wall.endX+math.sin(g/10*math.pi)*70, wall.endY+math.cos(g/10*math.pi)*70)
			end
		end


		local angle = calculateSourceYAngleAny({x = wall.endX, y = wall.endY}, {x = wall.startX, y = wall.startY} )
			
		--rotate the whole screen centred on the node, and draw another set of feeler and wobblers each loop
		love.graphics.translate(wall.startX, wall.startY)
		love.graphics.rotate(-angle)
		local distanceDiff = -distancebetween(wall.endX, wall.endY, wall.startX, wall.startY)

		local wallPoints = {

			4+(1+math.sin((1.4*wallIndex)+math.pi+sessionTimer%2*math.pi))*4,-2, --wall-end, start side
			4+(1+math.sin((1.4*wallIndex)+math.pi+sessionTimer%2*math.pi))*4,2,

			0,10, -- wall.startX, wall.startY
			distanceDiff/9 , 6+(1+math.sin((1.4*wallIndex)+sessionTimer%2*math.pi))*2, --long line
			distanceDiff/2 , 2+(1+math.sin((1.4*wallIndex)+sessionTimer%2*math.pi))*6,
			distanceDiff/1.1 , 6+(1+math.sin((1.4*wallIndex)+sessionTimer%2*math.pi))*2,
			distanceDiff, 10,

			distanceDiff-4-(1+math.sin((1.4*wallIndex)+math.pi+sessionTimer%2*math.pi))*4, --wall-end, end side
			2, distanceDiff-4-(1+math.sin((1.4*wallIndex)+math.pi+sessionTimer%2*math.pi))*4, 
			-2, distanceDiff, -10,

			
			distanceDiff/1.1 , -6-(1+math.sin((1.4*wallIndex)+sessionTimer%2*math.pi))*2, --long line
			distanceDiff/2 , -2-(1+math.sin((1.4*wallIndex)+sessionTimer%2*math.pi))*6,
			distanceDiff/9 , -6-(1+math.sin((1.4*wallIndex)+sessionTimer%2*math.pi))*2,
			0,-10
		}


		--wall highlight when using editor
		if editor and editorSelected.node == false and editorSelected.index == wallIndex then
			for w = 3, 1, -1 do
				love.graphics.setColor(0.9, 0.9, 0.2, w/9)
				love.graphics.setLineWidth( 16/w )
				love.graphics.polygon('line', wallPoints)
				--print("wall highlight")
			end
		end


		--draw wall
		love.graphics.setLineWidth( 2 )
		love.graphics.setColor(0.3,0.3,0.1)
		love.graphics.polygon('fill', wallPoints)
		--border
		love.graphics.setColor(1,1,1)
		love.graphics.polygon('line', wallPoints)






		love.graphics.translate(-wall.startX, -wall.startY)

		--love.graphics.line(wall.startX, wall.startY,-10,-10)

		-- unrotates and resets origin  
		love.graphics.origin()
	end
	



	
	-- draw arrow line between mouse and NODE after node selected, before release
	love.graphics.setColor(0.8, 0.8, 0)
	love.graphics.setLineWidth( 4 )
	if love.mouse.isDown(1) then
		if editor == false and levelDoneMenu == false then
			if nodeSelected > 0  then
				if (nodes[nodeSelected].team == 2 or godModeON) then -- and pointSelected.x == 0
					love.graphics.setColor(0.8, 0.8, 0)
					love.graphics.line(nodes[nodeSelected].x, nodes[nodeSelected].y, love.mouse.getX(), love.mouse.getY()) -- arrow on mouse

					local angle = calculateSourceYAngleAny({x = nodes[nodeSelected].x, y = nodes[nodeSelected].y}, {x = love.mouse.getX(), y = love.mouse.getY()} )
					--print(angle/(2*math.pi) )

					--rotate the whole screen centred on the node, and draw another set of feeler and wobblers each loop
					love.graphics.translate(love.mouse.getX(), love.mouse.getY())
					love.graphics.rotate(-angle)

					--love.graphics.line(0, 0,0,50) --perpendicular line

					love.graphics.line(0,0,-10,10)
					love.graphics.circle('fill',-10,10,2.5)
					love.graphics.line(0,0,-10,-10)
					love.graphics.circle('fill',-10,-10,2.5)

					love.graphics.translate(-love.mouse.getX(), -love.mouse.getY())

					-- unrotates and resets origin  
					love.graphics.origin()


					--love.graphics.line(500,0,500,500)
				end

			elseif (editor == false) and nodeSelected == 0 and pointSelected.x ~= 0 then --shouldnt need not editor again
				-- red line
				love.graphics.setColor(0.8, 0, 0)
				--print(pointSelected.x,pointSelected.y)
				love.graphics.line(pointSelected.x, pointSelected.y, love.mouse.getX(), love.mouse.getY()) 
				--get angle of red line
				--print(calculateSourceYAngleAny({x = pointSelected.x, y = pointSelected.y}, {x = love.mouse.getX(), y = love.mouse.getY()}))

			end

		elseif nodeSelected > 0 then -- this needs to move to update not draw
			--nodes[nodeSelected].x = mouseX
			--nodes[nodeSelected].y = mouseY

		end
	end

	--hover node display
	if not editor and not saveMenu and not loadMenu and not levelDoneMenu then
		local mouseNode = isMouseInNode()
		if mouseNode > 0 then
			local Xshift = 0
			local Yshift = 20 + (1.5*nodeTiers[nodes[mouseNode].tier].radius)

			--shift display depending on where the node is
			--shift if near edge
			if nodes[mouseNode].x < 100 then
				Xshift = Xshift+100
			elseif nodes[mouseNode].x > arenaWidth- 100 then
				Xshift = Xshift-100
			end
			--shift above or below
			if nodes[mouseNode].y > 100+arenaHeight/2 then
				Yshift = -Yshift-60
			end

			--hover node display
			love.graphics.setColor(0.1, 0.1, 0.1)
			love.graphics.rectangle('fill', nodes[mouseNode].x+Xshift-110, nodes[mouseNode].y+Yshift, 220, 80)

			--border
			love.graphics.setColor(0.7, 0.7, 0.7)
			love.graphics.setLineWidth( 1 )
			love.graphics.rectangle('line', nodes[mouseNode].x+Xshift-110, nodes[mouseNode].y+Yshift, 220, 80)



			love.graphics.setFont(font21)
			love.graphics.setColor(0.7, 0.7, 0.7)
			--love.graphics.printf(node.population, node.x-nodeTiers[node.tier].radius, node.y-19, 2*nodeTiers[node.tier].radius, "center")
			love.graphics.print("CLASS: ", 5+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift)
			love.graphics.setColor(nodeDisplayTeamColours[nodes[mouseNode].team])
			love.graphics.print(nodeTiers[nodes[mouseNode].tier].name, 90+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift)

			-- if neutral display progress, otherwise show used tentacles
			if nodes[mouseNode].team > 1 then

				love.graphics.setColor(0.7, 0.7, 0.7)
				love.graphics.print("POWER: ", 5+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+25)
				love.graphics.setColor(1,1,0.1)
				love.graphics.print(nodes[mouseNode].population, 100+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+25)
				love.graphics.setColor(0.7, 0.7, 0.7)
				--love.graphics.print(nodes[mouseNode].population, 100+nodes[mouseNode].x+Xshift-125, 2+nodes[mouseNode].y+Yshift+25)

				love.graphics.print("TENTACLES: ", 5+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+50)
				love.graphics.setColor(1,1,0.1)
				love.graphics.print(nodes[mouseNode].tentaclesUsed, 140+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+50)
				love.graphics.setColor(0.7, 0.7, 0.7)
				love.graphics.print("/"..nodeTiers[nodes[mouseNode].tier].maxTentacles, 153+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+50)
			else

				love.graphics.setColor(0.7, 0.7, 0.7)
				love.graphics.print("POWER: ", 5+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+25)
				love.graphics.setColor(1,1,0.1)
				love.graphics.print(nodes[mouseNode].neutralPower, 100+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+25)
				love.graphics.setColor(0.7, 0.7, 0.7)
				--love.graphics.print(nodes[mouseNode].population, 100+nodes[mouseNode].x+Xshift-125, 2+nodes[mouseNode].y+Yshift+25)

				love.graphics.print("OCCUPIED: ", 5+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+50)
				love.graphics.setColor(1,1,0.1)
				love.graphics.print(nodes[mouseNode].population, 140+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+50)
				love.graphics.setColor(0.7, 0.7, 0.7)
				love.graphics.print("/"..math.floor(nodes[mouseNode].neutralPower/3), 165+nodes[mouseNode].x+Xshift-110, 2+nodes[mouseNode].y+Yshift+50)

			end



		end
	end

	--save menu
	love.graphics.setFont(font14)
	love.graphics.setLineWidth( 3 )

	if saveMenu then

		local extension = 0
		if #inputText > 18 then
			extension = 13*(#inputText - 18)
		end

		--menu background square
		love.graphics.setColor(0.4,0.4,0.4)
		love.graphics.rectangle('fill', arenaWidth/2.5 - extension/2, arenaHeight/2.5, arenaWidth/5 + extension, arenaHeight/5, arenaWidth/50, arenaWidth/50)
		--border
		love.graphics.setColor(0.6,0.6,0.6)
		love.graphics.rectangle('line', arenaWidth/2.5 - extension/2, arenaHeight/2.5, arenaWidth/5 + extension, arenaHeight/5, arenaWidth/50, arenaWidth/50)
		--text field
		love.graphics.setColor(0.2,0.2,0.2)
		love.graphics.rectangle('fill', arenaWidth/2.4 - extension/2, arenaHeight/2.05, arenaWidth/6 + extension, 30) --+30*math.floor(math.abs(#inputText-1)/18)
		--button (again)
		love.graphics.setColor(0.3,0.3,0.3)
		local button = buttonsOnScreen[#buttonsOnScreen]
		love.graphics.rectangle('fill', button.x,button.y,button.width, button.height, button.height/5, button.height/5)
		--text
		love.graphics.setColor(1,1,1)
		love.graphics.printf("Save", arenaWidth/3,arenaHeight/2.5,arenaWidth/3, 'center')
		love.graphics.setFont(monofont)
		love.graphics.printf(inputText, 0 ,arenaHeight/2, arenaWidth, 'center') --+30*looper
		--[[local looper = 0
		while math.floor(#inputText/18) >= looper do
			segment = inputText:sub(1+looper*18, (looper+1)*18)
			love.graphics.printf(segment, arenaWidth/2.4,arenaHeight/2 +30*looper ,arenaWidth/6, 'center')
			looper = looper +1
		end]]
		love.graphics.setFont(font14)
	elseif loadMenu then
		--load menu background square
		love.graphics.setColor(0.4,0.4,0.4)
		love.graphics.rectangle('fill', arenaWidth/4.5, arenaHeight/7, arenaWidth*0.555, arenaHeight/1.3, arenaWidth/50, arenaWidth/50)

		-- background
		-- draw a rectangle as a stencil. Each pixel touched by the rectangle will have its stencil value set to 1. The rest will be 0.
	    love.graphics.stencil(loadMenuStencilFunction, "replace", 1)

	   -- Only allow rendering on pixels which have a stencil value greater than 0.
	    love.graphics.setStencilTest("greater", 0)

	    --love.graphics.setColor(0, 1, 0)
	    --love.graphics.rectangle("fill", arenaWidth/2, arenaHeight/2, 300, 300)

	    love.graphics.setColor(0.9, 0.9, 0.9)
	    love.graphics.draw(menu_background,0,0 , 0, 1, 1) --arenaWidth/4.5, arenaHeight/7 , 0, 0.7, 0.7
	    love.graphics.setColor(0.0, 0.0, 0.0,0.3)
	    love.graphics.circle('fill',arenaWidth/2,arenaHeight/2+50,180)

	    love.graphics.setStencilTest()



		--border
		love.graphics.setColor(0.6,0.6,0.6)
		love.graphics.rectangle('line', arenaWidth/4.5, arenaHeight/7, arenaWidth*0.555, arenaHeight/1.3, arenaWidth/50, arenaWidth/50)

		--level display inner circle and lines
		love.graphics.setColor(1,1,1)
		love.graphics.circle('line',arenaWidth/2,arenaHeight/2+50,180)
		for i = 0, 19 do --all levels are unlocked by default
			love.graphics.line(arenaWidth/2+180*(math.sin(2*math.pi*i/20)),   arenaHeight/2+50-180*(math.cos(2*math.pi*i/20)), 
				arenaWidth/2+ (60 + 235)*(math.sin(2*math.pi*i/20)),    arenaHeight/2+50- (60 + 235)*(math.cos(2*math.pi*i/20)) )
		end

		--hover level name display
		local mouseButton = isMouseInButton() 
		if mouseButton > 0 then
			if type(buttonsOnScreen[mouseButton].name) ~= "string" then
				local Xshift = (outerLevelPositions[buttonsOnScreen[mouseButton].name].x - arenaWidth/2 )/1.5
				local Yshift = (outerLevelPositions[buttonsOnScreen[mouseButton].name].y - arenaHeight/2)/2

				--hover display
				love.graphics.setColor(0.1, 0.1, 0.1)
				love.graphics.rectangle('fill', outerLevelPositions[buttonsOnScreen[mouseButton].name].x+Xshift-13*(#customLevels[buttonsOnScreen[mouseButton].name].name)/2-10, 
					outerLevelPositions[buttonsOnScreen[mouseButton].name].y+Yshift+70-30*math.ceil(#customLevels[buttonsOnScreen[mouseButton].name].name/18), 20+13*(#customLevels[buttonsOnScreen[mouseButton].name].name), 
					30*math.ceil(#customLevels[buttonsOnScreen[mouseButton].name].name/18) )

				--border
				love.graphics.setColor(0.7, 0.7, 0.7)
				love.graphics.setLineWidth( 1 )
				love.graphics.rectangle('line', outerLevelPositions[buttonsOnScreen[mouseButton].name].x+Xshift-13*(#customLevels[buttonsOnScreen[mouseButton].name].name)/2-10, 
					outerLevelPositions[buttonsOnScreen[mouseButton].name].y+Yshift+70-30*math.ceil(#customLevels[buttonsOnScreen[mouseButton].name].name/18), 20+13*(#customLevels[buttonsOnScreen[mouseButton].name].name), 
					30*math.ceil(#customLevels[buttonsOnScreen[mouseButton].name].name/18) )

				love.graphics.setColor(1,1,1)
				
				love.graphics.setFont(monofont)
				love.graphics.printf(customLevels[buttonsOnScreen[mouseButton].name].name, outerLevelPositions[buttonsOnScreen[mouseButton].name].x+Xshift-150, 
					outerLevelPositions[buttonsOnScreen[mouseButton].name].y+Yshift+10+70-30*math.ceil(#customLevels[buttonsOnScreen[mouseButton].name].name/18), 300, 'center')
				love.graphics.setFont(font14)

				--print(buttonsOnScreen[mouseButton].name, mouseButton)

				hoverLevelDisplayDRAW(buttonsOnScreen[mouseButton].name)
			end
		else
			previewNodes = {}
			previewWalls = {}
		end

	elseif levelDoneMenu then
		--menu background square
		love.graphics.setColor(0.1,0.15,0.15)
		love.graphics.rectangle('fill', arenaWidth/3, arenaHeight/3, arenaWidth/3 , arenaHeight/3)
		--border
		love.graphics.setLineWidth( 1 )
		love.graphics.setColor(0.5,0.5,0.5)
		love.graphics.rectangle('line', arenaWidth/3, arenaHeight/3, arenaWidth/3 , arenaHeight/3)
		local Win = nil
		local counter = 1
		while Win == nil do 
			if nodes[counter].team == 2 then
				Win = true
			elseif nodes[counter].team > 2 then
				Win = false
			end
			counter = counter + 1
		end

		love.graphics.setFont(levelDonefont)
		if Win then
			love.graphics.setColor(nodeDisplayTeamColours[2])
			love.graphics.printf("ZONE  OCCUPIED", arenaWidth*0.3, arenaHeight/2.6, arenaWidth*0.4 , 'center')
		else
			love.graphics.setColor(nodeDisplayTeamColours[3])
			love.graphics.printf("EXTERMINATION", arenaWidth*0.3, arenaHeight/2.6, arenaWidth*0.4 , 'center')
		end
		love.graphics.setFont(font21)
		love.graphics.setColor(nodeDisplayTeamColours[1])

		love.graphics.printf("TIME: " .. math.ceil(timer) .. " 		SCORE: " .. 1000 - math.ceil(timer * 20), arenaWidth*0.3, arenaHeight/2.1, arenaWidth*0.4 , 'center')
		--love.graphics.printf("Score: " .. 1000 - (timer * 20), arenaWidth*0.3, arenaHeight/3.5, arenaWidth*0.4 , 'center')

		love.graphics.setFont(font14)
	end

	--draw buttons
	for buttonIndex, button in ipairs(buttonsOnScreen) do
		--love.graphics.printf(button.name,button.x+button.width,button.y-16, 2*button.width,'center')	--display button name beside every button

		love.graphics.setColor(0.3,0.3,0.3)
		if button.name == "God" then
			if godModeON then
				love.graphics.setColor(0,0.5,0)
			end
		end
		if button.name == "AI" then
			if AION then
				love.graphics.setColor(0,0.5,0)
			end
		end
		if button.name == "test&Edit" then
			if editor then
				love.graphics.setColor(0,0.5,0)
			end
		end

		love.graphics.setLineWidth(3)

		if button.shape == "rectangle" then
			love.graphics.rectangle('fill',button.x,button.y,button.width, button.height,button.height/5,button.height/5)
			love.graphics.setColor(1,1,1)
			if button.name == "CreateX" then
				if createMicrobe then
					love.graphics.print("Create Microbe",button.x,button.y)
				else
					love.graphics.print("Create Wall",button.x,button.y)
				end

			elseif button.name == "MicrobeTeam" then
				if editTeam == 1 then -- 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
					love.graphics.print("Neutral",button.x,button.y)
				elseif editTeam == 2 then -- 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
					love.graphics.print("Green",button.x,button.y)
				elseif editTeam == 3 then -- 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
					love.graphics.print("Red",button.x,button.y)
				elseif editTeam == 4 then -- 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
					love.graphics.print("Black",button.x,button.y)
				elseif editTeam == 5 then -- 1 = grey, 2 = green, 3 = red, 4 = black, 5 = purple
					love.graphics.print("Purple",button.x,button.y)
				end

			elseif button.name == "PowerSlider" then
				love.graphics.rectangle('fill',editPower+80,button.y-2,16, button.height-4,button.height/5,button.height/5)
			else
				love.graphics.print(button.name,button.x,button.y)
			end
		elseif button.shape == "circle" then

			if type(button.name) ~= "string" then

				if not loadMenu then
					local displayColours = teamColours[levelProgress[button.name]]
					displayColours[4] = 0.5
					love.graphics.setColor(displayColours)
					love.graphics.circle('fill',button.x,button.y,button.height)
					--border
					love.graphics.setColor(1,1,1)
					love.graphics.circle('line',button.x,button.y,button.height)
				else
					--load menu
					love.graphics.setColor(teamColours[1])
					love.graphics.circle('fill', button.x,button.y, button.height)
					--border
					love.graphics.setColor(1,1,1)
					love.graphics.circle('line', button.x,button.y, button.height)
				end
				
				love.graphics.setColor(1,1,1)
				love.graphics.setFont(nodefont38)
				if loadMenu then 
					--print(#customLevels)
					if #customLevels > 1 then
						love.graphics.printf(string.sub(customLevels[button.name].name,1,1), outerLevelPositions[button.name].x-button.width, outerLevelPositions[button.name].y-16, 2*button.width,'center')
					end
				else
					love.graphics.printf(button.name,button.x-button.width,button.y-16, 2*button.width,'center')
				end
				
				love.graphics.setFont(font14)
				teamColours[levelProgress[button.name]][4] = 1
			end

			--black interior before image
			if button.name == "Menu" or button.name == "Mute" or button.name == "Pause" or button.name == "Reset" then
				love.graphics.setColor(0,0,0)
				--border
				love.graphics.setColor(1,1,1)
				love.graphics.circle('line',button.x,button.y,button.height)
			end

			love.graphics.setColor(1,1,1)
			if button.name == "Menu" then
				love.graphics.draw(image_QuitMenuButton, button.x-button.width+8, button.y-button.width+8 ,0,0.8,0.8)
			elseif button.name == "Mute" then
				love.graphics.draw(image_MuteButton, button.x-button.width+5, button.y-button.width+5 ,0,0.8,0.8)
			elseif button.name == "Pause" then
				love.graphics.draw(image_PauseButton, button.x-button.width+8, button.y-button.width+7 ,0,0.8,0.8)
			elseif button.name == "Reset" then
				love.graphics.draw(image_ResetButton, button.x-button.width+3, button.y-button.width+4 ,0,0.8,0.8)
			end

			

		elseif button.shape == "text" then
			if button.name == "Editor" then
				love.graphics.setFont(font30)
				love.graphics.setColor(1,1,1)
				love.graphics.printf(string.upper(button.name),button.x,button.y,button.width,'center')
			else
				love.graphics.setFont(font21)
				love.graphics.setColor(1,1,1)
				love.graphics.printf(string.upper(button.name),button.x,button.y,button.width,'center')

			end

		end
	end


	local highlightedButton = isMouseInButton()
	if highlightedButton > 0 then

		love.graphics.setColor(0.9, 0.9, 0.2, 0.3)
		if buttonsOnScreen[highlightedButton].shape == "circle" then
			love.graphics.circle('fill', buttonsOnScreen[highlightedButton].x, buttonsOnScreen[highlightedButton].y, buttonsOnScreen[highlightedButton].width)
			--print(buttonsOnScreen[highlightedButton].x)
		elseif buttonsOnScreen[highlightedButton].shape == "rectangle" then
			love.graphics.rectangle('fill', buttonsOnScreen[highlightedButton].x, buttonsOnScreen[highlightedButton].y, buttonsOnScreen[highlightedButton].width, buttonsOnScreen[highlightedButton].height,5,5)
		elseif buttonsOnScreen[highlightedButton].shape == "text" then -- so far just EDITOR button in menu
			if buttonsOnScreen[highlightedButton].name == "Editor" then
				love.graphics.setFont(font30)
			else
				love.graphics.setFont(font21)
			end
			love.graphics.setColor(0.9, 0.9, 0.2, 0.1)
			love.graphics.printf(string.upper(buttonsOnScreen[highlightedButton].name), buttonsOnScreen[highlightedButton].x-3, buttonsOnScreen[highlightedButton].y-3,buttonsOnScreen[highlightedButton].width,'center')
			love.graphics.printf(string.upper(buttonsOnScreen[highlightedButton].name), buttonsOnScreen[highlightedButton].x-3, buttonsOnScreen[highlightedButton].y+3,buttonsOnScreen[highlightedButton].width,'center')
			love.graphics.printf(string.upper(buttonsOnScreen[highlightedButton].name), buttonsOnScreen[highlightedButton].x+3, buttonsOnScreen[highlightedButton].y-3,buttonsOnScreen[highlightedButton].width,'center')
			love.graphics.printf(string.upper(buttonsOnScreen[highlightedButton].name), buttonsOnScreen[highlightedButton].x+3, buttonsOnScreen[highlightedButton].y+3,buttonsOnScreen[highlightedButton].width,'center')
			love.graphics.printf(string.upper(buttonsOnScreen[highlightedButton].name), buttonsOnScreen[highlightedButton].x-3, buttonsOnScreen[highlightedButton].y,buttonsOnScreen[highlightedButton].width,'center')
			love.graphics.printf(string.upper(buttonsOnScreen[highlightedButton].name), buttonsOnScreen[highlightedButton].x, buttonsOnScreen[highlightedButton].y+3,buttonsOnScreen[highlightedButton].width,'center')
			love.graphics.printf(string.upper(buttonsOnScreen[highlightedButton].name), buttonsOnScreen[highlightedButton].x, buttonsOnScreen[highlightedButton].y-3,buttonsOnScreen[highlightedButton].width,'center')
			love.graphics.printf(string.upper(buttonsOnScreen[highlightedButton].name), buttonsOnScreen[highlightedButton].x+3, buttonsOnScreen[highlightedButton].y,buttonsOnScreen[highlightedButton].width,'center')
			love.graphics.printf(string.upper(buttonsOnScreen[highlightedButton].name), buttonsOnScreen[highlightedButton].x, buttonsOnScreen[highlightedButton].y,buttonsOnScreen[highlightedButton].width,'center')
		end
	else
		
	end


	--pause goes on top of everything
	if pause then
		--darken everything
		love.graphics.setColor(0, 0, 0, 0.7)
		love.graphics.rectangle('fill', 0,0, arenaWidth, arenaHeight)
		
		-- pause title
		love.graphics.setFont(titlefont)
		--black outline:
		love.graphics.setColor(0,0,0)
		love.graphics.printf("Paused", 0-5, arenaHeight/2-80, arenaWidth , 'center')
		love.graphics.printf("Paused", 0+5, arenaHeight/2-80, arenaWidth , 'center')
		love.graphics.printf("Paused", 0, arenaHeight/2+5-80, arenaWidth , 'center')
		love.graphics.printf("Paused", 0, arenaHeight/2-5-80, arenaWidth , 'center')


		--title in white
		love.graphics.setColor(1,1,1,0.7)
		love.graphics.printf("Paused", 0, arenaHeight/2-80, arenaWidth , 'center')
	end
end


function hoverLevelDisplayDRAW(levelIndex)
	--  customLevelContents, size = love.filesystem.read( 'custom_levels', 50000 ) --should already be updated since getLevelNames() updates it on load button pressed

	--decodeLevelCode(customLevels[levelIndex].startIndex, false)

	--preview display

	--background
	-- draw a rectangle as a stencil. Each pixel touched by the rectangle will have its stencil value set to 1. The rest will be 0.
    love.graphics.stencil(previewStencilFunction, "replace", 1)

   -- Only allow rendering on pixels which have a stencil value greater than 0.
    love.graphics.setStencilTest("greater", 0)

    --love.graphics.setColor(0, 1, 0)
    --love.graphics.rectangle("fill", arenaWidth/2, arenaHeight/2, 300, 300)

    love.graphics.setColor(0.9, 0.9, 0.9)
    --love.graphics.draw(game_background,arenaWidth/2-180, arenaHeight/2-140 , 0, 0.3, 0.4)
    

    love.graphics.setStencilTest()
	

	-- draw all nodes and population number
	for nodeIndex, node in ipairs(previewNodes) do
		-- draw node depending on team colour
		love.graphics.setColor(teamColours[node.team])

		-- draw node
		love.graphics.circle('fill', node.x, node.y, node.tier+ nodeCentreRadius/4.7)
		-- outer node ring
		if node.tier > 1 then
			love.graphics.setLineWidth( (node.tier-1)*1.7 )
			love.graphics.circle('line', node.x, node.y, node.tier+nodeTiers[node.tier].radius/4.7)
		end
		-- node border
		love.graphics.setColor(1, 1, 1)
		love.graphics.setLineWidth( 1 )
		love.graphics.circle('line', node.x, node.y, node.tier+nodeCentreRadius/4.7)
		
	end

	--draw walls
	
	for wallIndex, wall in ipairs(previewWalls) do
		--border
		love.graphics.setColor(1,1,1)
		love.graphics.setLineWidth( 3 )
		love.graphics.line(wall.startX, wall.startY, wall.endX, wall.endY)

		love.graphics.setColor(0.3,0.3,0.1)
		love.graphics.setLineWidth( 1 )
		love.graphics.line(wall.startX, wall.startY, wall.endX, wall.endY)
	end

	--effect
	love.graphics.setLineWidth( 8 )
	love.graphics.setColor(1,1,1,1-(sessionTimer%1.5)/1.5)
	love.graphics.circle('line',arenaWidth/2,arenaHeight/2+50,180-30*(sessionTimer%1.5))

	love.graphics.setColor(1,1,1,1-((0.75+sessionTimer)%1.5)/1.5)
	love.graphics.circle('line',arenaWidth/2,arenaHeight/2+50,180-30*((0.75+sessionTimer)%1.5))

	--permenant wider circle
	love.graphics.setColor(1,1,1)
	love.graphics.circle('line',arenaWidth/2,arenaHeight/2+50,180)

	love.graphics.setColor(0.5, 0.5, 0.5,0.3)
    love.graphics.circle('fill',arenaWidth/2,arenaHeight/2+50,180)

end

function previewStencilFunction()
	love.graphics.circle('fill',arenaWidth/2,arenaHeight/2+50,180)
end

function loadMenuStencilFunction()
	love.graphics.rectangle('fill', arenaWidth/4.5, arenaHeight/7, arenaWidth*0.555, arenaHeight/1.3, arenaWidth/50, arenaWidth/50)
end
