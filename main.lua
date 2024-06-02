io.stdout:setvbuf('no')

-- require "cards"  -- separate file, do this for each seperate file, not conf or main tho

--https://love2d.org/wiki/Optimising


-- This function gets called only once, when the game is started, and is usually where you would load resources, initialize variables and set specific settings. 
-- All those things can be done anywhere else as well, but doing them here means that they are done once only, saving a lot of system resources
function love.load()
	arenaWidth = 1200
    arenaHeight = 900 -- changing this doesnt do anything? need to at least change conf file too

    nodeMapWidth = 1200
	nodeMapHeight = 900

	timer = 0

    love.graphics.setBackgroundColor( 0., 0.1, 0.)

    font14 = love.graphics.newFont(14)
    font20 = love.graphics.newFont(20)
    font28 = love.graphics.newFont(28)



    nodeCentreRadius = 26
	--nodeRadius = 36  -- outer ring, will vary, changing for nodeTiers[node.tier].radius

	linkRadius = 7
	linkSpacing = 10

    nodeSelected = 0
    pointSelected = 0

    deliverySpeed = 0.1 --seconds before moving forward
    deliveryTimer = 0

    cutSource = {
    	--x = 5
    	-- y = 10
    }


    FPStarget = 160 --forced FPS otherwise speeds change, maybe adjust speeds relative to FPS later?

    tickCount = 0

    tickPeriod = 1/50 -- seconds per tick
	accumulator = 0.0

    nodes = {
        {
            x = arenaWidth / 3,
            y = 150,
            team = 2,  -- team starts from 0 for teamColours[team] to make sense, 1 = grey, 2 = green, 3 = red
            population = 10,
            tier = 1,
            regenTimer = 5,
            tentaclesUsed = 0
            -- regen Delay comes from the tiers table now
        },
        {
            x = arenaWidth / 1.5, 
            y = 150,
            team = 1,
            population = 20,
            tier = 2,
            regenTimer = 5,
            tentaclesUsed = 0
        },
        {
            x = 200,
            y = nodeMapHeight/ 3,
            team = 1,
            population = 40,
            tier = 3,
            regenTimer = 5,
            tentaclesUsed = 0
        },
        {
            x = 400,
            y = nodeMapHeight - 200,
            team = 1,
            population = 80,
            tier = 4,
            regenTimer = 5,
            tentaclesUsed = 0
        },
        {
            x = arenaWidth / 1.5,
            y = nodeMapHeight - 200,
            team = 3,
            population = 120,
            tier = 5,
            regenTimer = 5,
            tentaclesUsed = 0
        },
        {
            x = arenaWidth - 200,
            y = nodeMapHeight - 500,
            team = 3,
            population = 180,
            tier = 6,
            regenTimer = 5,
            tentaclesUsed = 0
        },
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

    teamColours = {
    	{0.7, 0.7, 0.7},
    	{0.1, 0.7, 0.1},
    	{0.7, 0.2, 0.2}
    }


    nodeTiers = { --Tiers change when the population exceeds the min or max
    	--node.tier is the index of the relevant ranges
    	-- In the game, lower tiers generate faster
    	{min = -20, max = 14, radius = 33, regenDelay =  2, sendDelay = 1, maxTentacles = 1}, -- spore regen: 0 tents:18 in 40s	1:8		2:-	delivery:	23 in 40s  -delivery is the per tentacle rate and does not vary
    	{min = 6, max = 39, radius = 36, regenDelay =  2.3, sendDelay = 1, maxTentacles = 2}, -- embryo					17			9		4				37
    	{min = 31, max = 79, radius = 43, regenDelay =  2.5, sendDelay = 1, maxTentacles = 2},	-- pulsar-A				15			7		3				49
    	{min = 61, max = 119, radius = 47, regenDelay =  3, sendDelay = 1, maxTentacles = 2},	-- pulsar-B				13			7		4				72
    	{min = 101, max = 159, radius = 60, regenDelay =  4, sendDelay = 0.5, maxTentacles = 3},	-- Ant				9			5		2				109
    	{min = 141, max = 220, radius = 72, regenDelay = 5, sendDelay = 0.15, maxTentacles = 3}	-- Predator				7			5		1				260: ~66 in 10s, 130 in 20s -  delay per tents: 0=5, 1=10, 2=20
    }	-- regen halfs per tentacle roughly



    function isMouseInNode()
        
    	for nodeIndex, node in ipairs(nodes) do
	    	if distancebetween(love.mouse.getX(), love.mouse.getY(), node.x, node.y) < nodeTiers[node.tier].radius+10 then
				return nodeIndex
			end

		end

		return 0

        -- return nodeSelected
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



	print("targetX: ",targetX, "   targetY: ", targetY)

	return {sourceX = sourceX, sourceY = sourceY, targetX = targetX, targetY = targetY}



end


function love.update(dt)

	  -- trying to force an FPS as sometimes predator sends 3 or 1 instead of 2 in a row. turning off vsync gets fps to 500! not 165 and causes things to tentacles to move faster. tricky
	timer = timer + dt
	accumulator = accumulator + dt--*6
  	if accumulator > 1/ FPStarget then

  		--print(accumulator, " ", dt, " ", tickPeriod)
    	-- Here be your fixed timestep.
    	tickCount = tickCount + 1

		--[[if timer > 3 then
			if tickCount < 360 then
				tickCount = 360
			end
			tickCount = tickCount + 1
		end

		--set game tick to match frames of 120
		if dt < 1/120 then
			love.timer.sleep(1/120 - dt)
			--print(dt, " -> ", 1/120)
			 --/120
		end

		if math.floor(tickCount) == math.floor(tickCount*100)/100 then
			print(tickCount/timer)
		end

		dt = 1/120]]

		
		--print(tickCount/timer)

		deliveryTimer = deliveryTimer - 1/FPStarget

		for connectionIndex, connection in ipairs(connections) do
			if connection.moving ~= true then
				connection.sendTimer = connection.sendTimer - 1/FPStarget
			end
		end

		-- print(timer)

		-- regen
		 	-- each node's regenTimer counts down, and when at 0 gains 1 population. Then the Timer gets set to the regenDelay and counts down again
		for nodeIndex, node in ipairs(nodes) do
			if node.team > 1 then
				node.regenTimer = node.regenTimer - dt
				if node.regenTimer < 0 then
					node.regenTimer = nodeTiers[node.tier].regenDelay
					node.population = node.population +1
				end
			end

			-- tier change
			if node.population > nodeTiers[node.tier].max then  -- add a white growing fading circle effect from edge when tiering up or down, or sending a tentacle, team changing, recalling as cant reach
				node.tier = node.tier + 1
				print("Tier UP!")
				--node
			elseif node.population < nodeTiers[node.tier].min then
				node.tier = node.tier -1
				print("Tier down")
			end

			if node.population > 200 then
				node.population = 200
			elseif node.population < -5 then
				node.population = 0
			end
		end





		-- remove duplicate connections
		for connectionIndex1, connection1 in ipairs(connections) do
			for connectionIndex2, connection2 in ipairs(connections) do

				if connection1.source == connection2.source and connection1.target == connection2.target and connectionIndex1 ~= connectionIndex2 then 
					table.remove(connections, connectionIndex2)
					print("removed duplicate: ", connection2.source, " -> ", connection2.target)
				end
			end
		end
		
		-- move this to run only when a cut, node-loss, or new connection is made
		checkOpposedConnections()
		
		updateMovingConnections()

		glowDelivery()


		accumulator = accumulator - 1/FPStarget
  	end
end


function updateMovingConnections()

	
	for connectionIndex, connection in ipairs(connections) do
		if connection.moving == true then

			if #connection.links > 0 then
				connection.tentacleEnd.x = connection.links[1].x
				connection.tentacleEnd.y = connection.links[1].y
			end

			-- breaking a connection
			if connection.destination == 0 then 
				for linkIndex, link in ipairs(connection.links) do
					link.x = link.x - (connection.linkXStep/7)
					link.y = link.y - (connection.linkYStep/7)
					if distancebetween(link.x, link.y, nodes[connection.source].x, nodes[connection.source].y) < nodeTiers[nodes[connection.source].tier].radius-linkRadius then
						table.remove(connection.links, linkIndex)
						nodes[connection.source].population = nodes[connection.source].population + 1
					end
					if #connection.links == 0 then  -- could've also used tentacle end point
						connection.moving = false
						nodes[connection.source].population = nodes[connection.source].population - 1
						table.remove(connections, connectionIndex)
						adjustConnectionIndexes(connectionIndex)
					end
					
				end

			-- moving a connection to midpoint 
			elseif connection.destination == 1 then
				--print(connection.moving)
				if distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connection.targetEdge.x, connection.targetEdge.y) < distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connection.sourceEdge.x, connection.sourceEdge.y) then
					-- closer to target, so its long and needs to move back
					--print(connection.opposedConnectionIndex)
					if distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connections[connection.opposedConnectionIndex].tentacleEnd.x, connections[connection.opposedConnectionIndex].tentacleEnd.y) < 2 or 
						distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connection.targetEdge.x, connection.targetEdge.y) < 10 then   ----- if node is already locked in, it doesnt move   TO-DO --------- also, wigglers
						-- touching
						for linkIndex, link in ipairs(connection.links) do
							link.x = link.x - (connection.linkXStep/20) -- back
							link.y = link.y - (connection.linkYStep/20)

							if distancebetween(link.x, link.y, nodes[connection.source].x, nodes[connection.source].y) < nodeTiers[nodes[connection.source].tier].radius-linkRadius then
								table.remove(connection.links, linkIndex)
								nodes[connection.source].population = nodes[connection.source].population + 1
							end
						end
						
					else
						-- not touching
						-- keep moving but check if touching
						for linkIndex, link in ipairs(connection.links) do
							link.x = link.x + (connection.linkXStep/20)
							link.y = link.y + (connection.linkYStep/20)

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
						link.x = link.x + (connection.linkXStep/20)
						link.y = link.y + (connection.linkYStep/20)

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
					math.abs(connection.tentacleEnd.x - connection.connectionMidPoint.x) < 2 and math.abs(connection.tentacleEnd.y - connection.connectionMidPoint.y) < 2  ) then
					print("Opposition locked")
					connection.moving = false
					connections[connection.opposedConnectionIndex].moving = false
				end
			
			-- moving a connection to target 
			elseif connection.destination == 2 then
				for linkIndex, link in ipairs(connection.links) do
					link.x = link.x + (connection.linkXStep/20)
					link.y = link.y + (connection.linkYStep/20)
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
				end

			-- connection has been split, and splitLink is defined
			elseif connection.destination == 3 then
				for linkIndex, link in ipairs(connection.links) do
					if linkIndex > connection.splitLink then --send to source
						link.x = link.x - (connection.linkXStep/7)
						link.y = link.y - (connection.linkYStep/7)
						if distancebetween(link.x, link.y, nodes[connection.source].x, nodes[connection.source].y) < nodeTiers[nodes[connection.source].tier].radius-linkRadius then
							table.remove(connection.links, linkIndex)
							nodes[connection.source].population = nodes[connection.source].population + 1
						end
					else --send to target
						link.x = link.x + (connection.linkXStep/7)
						link.y = link.y + (connection.linkYStep/7)
						if distancebetween(link.x, link.y, nodes[connection.target].x, nodes[connection.target].y) < nodeTiers[nodes[connection.target].tier].radius-linkRadius then
							table.remove(connection.links, linkIndex)
							connection.splitLink = connection.splitLink -1
							if nodes[connection.target].team == connection.team then
								nodes[connection.target].population = nodes[connection.target].population + 1
							else
								nodes[connection.target].population = nodes[connection.target].population - 1
								if nodes[connection.target].population < 0 then
									nodes[connection.target].team = connection.team 
									nodes[connection.target].population = math.abs(nodes[connection.target].population)
									for connectionIndex2, connection2 in ipairs(connections) do
										if connection2.source == connection.target then
											connection2.destination = 0
											connection2.moving = true
											connections[connection2.opposedConnectionIndex].opposedConnectionIndex = 0
											connections[connection2.opposedConnectionIndex].moving = true
											connections[connection2.opposedConnectionIndex].destination = 2
											connection2.opposedConnectionIndex = 0
										end
									end
								end
							end
						end
					end
					if #connection.links == 0 then  -- couldn't used tentacle end point
						connection.moving = false

						--nodes[connection.source].population = nodes[connection.source].population - 1
						table.remove(connections, connectionIndex)
					end
				end


			end
			if #connection.links > 0 then
				connection.tentacleEnd.x = connection.links[1].x
				connection.tentacleEnd.y = connection.links[1].y
			end

			if nodes[connection.source].population == 0 and connection.moving == true and connection.destination ~= 0 and connection.destination ~= 3 then
				connection.destination = 0
				nodes[connection.source].population = nodes[connection.source].population + 1
				if connection.destination == 1 then
					connections[connection.opposedConnectionIndex].destination = 2
					connections[connection.opposedConnectionIndex].moving = true
				end
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
						nodes[connection.target].population = nodes[connection.target].population - 1
					else
						nodes[connection.target].population = nodes[connection.target].population + 1
					end
					table.remove(connection.glowing, glowerIndex)

					if nodes[connection.target].population < 0 then
						nodes[connection.target].team = connection.team 
						nodes[connection.target].population = math.abs(nodes[connection.target].population)
						for connectionIndex2, connection2 in ipairs(connections) do
							if connection2.source == connection.target then
								connection2.destination = 0
								connection2.moving = true
								connections[connection2.opposedConnectionIndex].opposedConnectionIndex = 0
								connections[connection2.opposedConnectionIndex].moving = true
								connections[connection2.opposedConnectionIndex].destination = 2
								connection2.opposedConnectionIndex = 0
							end
						end
					end

				end
					
			end
			--print("____")

			if connection.moving ~= true then
				--print("check")
				if connection.sendTimer < 0 then
					
					table.insert(connection.glowing, #connection.links)
					connection.sendTimer = nodeTiers[nodes[connection.source].tier].sendDelay + connection.sendTimer
				end

			end
				
		end
		-- print(deliveryTimer, " - ", timer % nodeTiers[nodes[connection.source].tier].sendDelay, " vs ", deliverySpeed)
		deliveryTimer = deliverySpeed
		
	end



end


function checkOpposedConnections()

	for connectionIndex1, connection1 in ipairs(connections) do
		for connectionIndex2, connection2 in ipairs(connections) do
			-- work out if a connection is opposed and set opposed
			if connection1.source == connection2.target and connection1.target == connection2.source and connectionIndex1 ~= connectionIndex2 and connection1.opposedConnectionIndex == 0 and 
				connection2.opposedConnectionIndex == 0 and connection1.destination > 0 and connection2.destination > 0 then 

				if connection1.team == connection2.team then
					if connectionIndex1 < connectionIndex2 then
						connection1.destination = 0
						connection2.destination = 2

						nodes[connection1.source].population = nodes[connection1.source].population + 1
					else
						--do nothing, the above will trigger in a later loop

					end
				else

					connection1.opposedConnectionIndex= connectionIndex2
					connection2.opposedConnectionIndex= connectionIndex1
					print("OPPOSED!", connection1.opposedConnectionIndex, " - ", connection2.opposedConnectionIndex)

					connection1.destination = 1
					connection2.destination = 1
					
				end
				connection1.moving = true
				connection2.moving = true
			end
		end
	end

end


function adjustConnectionIndexes(deletedConnectionIndex)

	local totalConnections = #connections

	print(totalConnections,"ConnectionIndex round up: ")
	for connectionIndex, connection in ipairs(connections) do
		print("Index:", connectionIndex, ", ", connection.source, " -> ", connection.target, " opposed? = ", connection.opposedConnectionIndex, " moving? = ", connection.moving)
	end

	for i = 1, totalConnections do
		if connections[i].opposedConnectionIndex > deletedConnectionIndex then
			connections[i].opposedConnectionIndex = connections[i].opposedConnectionIndex -1
		end
	end


	print(totalConnections,"POST - ConnectionIndex round up: ")
	for connectionIndex, connection in ipairs(connections) do
		print("Index:", connectionIndex, ", ", connection.source, " -> ", connection.target, " opposed? = ", connection.opposedConnectionIndex, " moving? = ", connection.moving)
	end


end

function splitTentacle(connectionIndex, ix, iy)

	local connection = connections[connectionIndex]

	local ratio = distancebetween(connection.sourceEdge.x, connection.sourceEdge.y, ix, iy) / 
	distancebetween(connection.sourceEdge.x, connection.sourceEdge.y, connection.targetEdge.x, connection.targetEdge.y)

	connection.splitLink = #connection.links - math.floor((#connection.links-1) * ratio)

end



function love.mousereleased(mouseX, mouseY)

	local releasenode = isMouseInNode()

	-- create connection, when mouse released on another node when selected > 0 
	if nodeSelected > 0 
	and releasenode > 0 
	and nodeSelected ~= releasenode   -- means not equal
	and nodes[nodeSelected].population > 0
	and nodes[nodeSelected].tentaclesUsed < nodeTiers[nodes[nodeSelected].tier].maxTentacles
	then

		local edges = calculateNodeEdges(nodeSelected, releasenode)

		local numLinksToMake = 1+ math.floor((distancebetween(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY))/((2*linkRadius)+linkSpacing))
		local extraSpacing = (distancebetween(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY))%((2*linkRadius)+linkSpacing)
		extraSpacing = extraSpacing/numLinksToMake

		local linkSteps = calculateSteps(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY, extraSpacing)

		--print(calculateSourceYAngle(nodeSelected, releasenode))

		-- connection creation with no links
		table.insert(connections, {	
			population = nodes[nodeSelected].population, team = nodes[nodeSelected].team, moving = true, source = nodeSelected, 
			sourceEdge = { x = edges.sourceX, y = edges.sourceY }, 
			target = releasenode,
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
            sendTimer = nodeTiers[nodes[nodeSelected].tier].sendDelay
		})

		-- link creation
			--loops from 1 to number of nodes that would fit in the distance 

		-- now this just creates the first node, slightly problematic as i think this is the reason we have to -1 from the added population when connection cut
		--for i = 1, 1 do numLinksToMake+1 do


		table.insert(connections[#connections].links, {
			x = edges.sourceX,
			y = edges.sourceY
		})
		nodes[nodeSelected].population = nodes[nodeSelected].population -1
		
		nodes[nodeSelected].tentaclesUsed = nodes[nodeSelected].tentaclesUsed + 1

		tentacleEnd = connections[#connections].links[1]
		
		-- print every current connection
		for connectionIndex, connection in ipairs(connections) do
			print(connection.source, " -> ", connection.target)
		end
		print(" ------------------- ")

		checkOpposedConnections()

	-- cutting a connection
	elseif (nodeSelected == 0 and pointSelected ~= 0) then
		local releaseMouseX = love.mouse.getX()
		local releaseMouseY = love.mouse.getY()
		-- check every connection for an intersection, allows multiple cut lines
		for connectionIndex, connection in ipairs(connections) do 
			ix, iy = findIntersectionPoint(connection.sourceEdge.x,connection.sourceEdge.y, connection.targetEdge.x,connection.targetEdge.y, pointSelected.x, pointSelected.y, releaseMouseX, releaseMouseY)
			if ix ~= nil and iy ~= nil then -- intersection exists
								
				if (connection.destination == 1 or (connection.moving == true and connection.destination ~= 0 and connection.destination ~= 3))  then 
					-- go home
					connection.destination = 0
					if connection.opposedConnectionIndex > 0 then
						connection.opposedConnectionIndex = 0
						print(connectionIndex, connection.opposedConnectionIndex)
					end
					nodes[connection.source].population = nodes[connection.source].population +1
				elseif connection.destination == 2 then
					-- initiate split!
					connection.destination = 3 
					splitTentacle(connectionIndex, ix, iy) --updates connection.splitLink
					nodes[connection.target].population = nodes[connection.target].population + 1
					print(connection.splitLink," links: ", #connection.links)
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

			end
		end
	end
end


function newRound() -- consider moving whole function into load function? like inNode() ?

	-- New round

	

	-- regeneration
	for nodeIndex, node in ipairs(nodes) do
		
	end

end



function love.mousepressed(mouseX, mouseY)
	
	nodeSelected = isMouseInNode() 

	if nodeSelected < 1 then
		pointSelected = {x = mouseX, y = mouseY}
	else
		pointSelected = 0
	end


end



function love.draw(mouseX, mouseY)



	love.graphics.setFont(font20)

	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)

	love.graphics.print("Forced FPS:"..FPStarget, 150, 10)

	love.graphics.print(string.format("Average frame time: %.3f ms", 1000 * love.timer.getAverageDelta()), 350, 10)


	--highlight
	local highlightedNode = isMouseInNode()
	if highlightedNode > 0 then
		love.graphics.setColor(0.9, 0.9, 0.2, 0.3)
		love.graphics.circle('fill', nodes[highlightedNode].x, nodes[highlightedNode].y, nodeTiers[nodes[highlightedNode].tier].radius)
	end



	--connection links, link wigglers
	for connectionIndex, connection in ipairs(connections) do 
		love.graphics.setColor(0.9, 0.9, 0.2)

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
				nextXWobble = (math.sin(((timer-((Index+1)/10))%1.6)*1.25*math.pi))*connection.linkYStep/2.5
				nextYWobble = (math.sin(((timer-((Index+1)/10))%1.6)*1.25*math.pi))*connection.linkXStep/2.5
			elseif Index+1 == 2 or Index == #connection.links -2 then
				nextXWobble = (math.sin(((timer-((Index+1)/10))%1.6)*1.25*math.pi))*connection.linkYStep/5
				nextYWobble = (math.sin(((timer-((Index+1)/10))%1.6)*1.25*math.pi))*connection.linkXStep/5
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

					local linkToTargetDist
					if connection.destination == 1 then
						-- if something flags here its probably to do with tentacle end 
						--print(connections[connection.opposedConnectionIndex].tentacleEnd.x)
						linkToTargetDist = distancebetween(connection.links[Index].x, connection.links[Index].y, (connection.tentacleEnd.x + connections[connection.opposedConnectionIndex].tentacleEnd.x)/2, (connection.tentacleEnd.y + connections[connection.opposedConnectionIndex].tentacleEnd.y)/2) --ignores wobble
						
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
						-5 +(((math.cos(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2+0.5*math.pi)*5))*0.1), 
						-(1.6*linkRadius)+(((math.sin(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*0.2))

					love.graphics.line( -5 +(((math.cos(((math.abs(timer%00.625-0.3125))%0.3125)*6.4*math.pi/2+0.5*math.pi)*5))*0.1), 
						-(1.6*linkRadius)+(((math.sin(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*0.2),
						---20+(((math.cos(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*5))*0.3), 
						--6-(3*linkRadius)+(((math.sin(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*4),
						2/wigglerShrink-22+(((math.cos(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*5))*0.3), 
						1/wigglerShrink+2-(3*linkRadius)+(((math.sin(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*4))
					
					--flip coordinates along the rotated y axis
					love.graphics.scale(1,-1)

					-- right side wigglers
					love.graphics.line(
						-linkRadius/2, 
						-linkRadius/1.15,
						-5 +(((math.cos(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2+0.5*math.pi)*5))*0.1), 
						-(1.6*linkRadius)+(((math.sin(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*0.2))
					--love.graphics.setColor(teamColours[connection.team-1]) --green
					love.graphics.line( -5 +(((math.cos(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2+0.5*math.pi)*5))*0.1), 
						-(1.6*linkRadius)+(((math.sin(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*0.2),	
						2/wigglerShrink-22+(((math.cos(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*5))*0.3), 
						1/wigglerShrink+2-(3*linkRadius)+(((math.sin(((math.abs(timer%0.625-0.3125))%0.3125)*6.4*math.pi/2.2+0.7*math.pi)*1))*4))

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

		if connection.destination == 1 and (distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connections[connection.opposedConnectionIndex].tentacleEnd.x, connections[connection.opposedConnectionIndex].tentacleEnd.y) < 2 or connection.moving == false)then
			--create midpoint link
			love.graphics.setColor(teamColours[connection.team])
			-- animation spinning midpoint
			love.graphics.arc( 'fill', 'pie', (connection.tentacleEnd.x +connections[connection.opposedConnectionIndex].tentacleEnd.x)/2, (connection.tentacleEnd.y + connections[connection.opposedConnectionIndex].tentacleEnd.y)/2, linkRadius, 2*(timer%math.pi), math.pi+ 2*(timer%math.pi))
			love.graphics.setColor(teamColours[connections[connection.opposedConnectionIndex].team])
			love.graphics.arc( 'fill', 'pie', (connection.tentacleEnd.x +connections[connection.opposedConnectionIndex].tentacleEnd.x)/2, (connection.tentacleEnd.y + connections[connection.opposedConnectionIndex].tentacleEnd.y)/2, linkRadius, math.pi+ 2*(timer%math.pi), 2*math.pi+ 2*(timer%math.pi))

			-- midpoint border
			love.graphics.setColor(1, 1, 1)
			love.graphics.setLineWidth( 1 )
			love.graphics.circle('line', (connection.tentacleEnd.x +connections[connection.opposedConnectionIndex].tentacleEnd.x)/2, (connection.tentacleEnd.y + connections[connection.opposedConnectionIndex].tentacleEnd.y)/2, linkRadius+1)
		end
	end


	-- draw all nodes and population number
	for nodeIndex, node in ipairs(nodes) do
		-- draw node depending on team colour
		love.graphics.setColor(teamColours[node.team])
		-- draw node
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
		 	if node.tier > 1 then
		 		if node.tier == 2 then
			 		--node feelers
					love.graphics.line(node.x, node.y-(nodeTiers[node.tier].radius), 
						node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*0.1), node.y-(nodeTiers[node.tier].radius)+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.1),
						node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*0.2), node.y-(nodeTiers[node.tier].radius)-5+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.2),
						node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*0.5), node.y-(nodeTiers[node.tier].radius)-10+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.5),
						node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*1), node.y-(nodeTiers[node.tier].radius)-15+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1))
				elseif node.tier > 2 then

					--node first inner wobblers
					love.graphics.setColor(teamColours[node.team])
					love.graphics.circle('fill', node.x, node.y-nodeTiers[node.tier].radius, 3.3*(math.sin((timer+(nodeIndex*(i+1.1)%2.38)%1.1)*2*math.pi)+2))
					--border
					love.graphics.setColor(1, 1, 1)
					love.graphics.circle('line', node.x, node.y-nodeTiers[node.tier].radius, 3.3*(math.sin((timer+(nodeIndex*(i+1.1)%2.38)%1.1)*2*math.pi)+2))

					if node.tier ~= 5 then
					--node feelers
						love.graphics.line(node.x, node.y-nodeTiers[node.tier].radius - 3.3*(math.sin((timer+(nodeIndex*(i+1.1)%2.38)%1.1)*2*math.pi)+2), 
							node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*0.1), node.y-(nodeTiers[node.tier].radius)-(2+1.5*node.tier)+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.2) - 3.3*(math.sin((timer+(nodeIndex*(i+1.1)%2.38)%1.1)*2*math.pi)+2),
							node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*0.2), node.y-(nodeTiers[node.tier].radius)-(2+3*node.tier)+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.3) - 3.3*(math.sin((timer+(nodeIndex*(i+1.1)%2.38)%1.1)*2*math.pi)+2),
							node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*0.5), node.y-(nodeTiers[node.tier].radius)-(2+4.5*node.tier)+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.6) - 3.3*(math.sin((timer+(nodeIndex*(i+1.1)%2.38)%1.1)*2*math.pi)+2),
							node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*1), node.y-(nodeTiers[node.tier].radius)-(2+6*node.tier)+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1) - 3.3*(math.sin((timer+(nodeIndex*(i+1.1)%2.38)%1.1)*2*math.pi)+2))
					

						
						
						if node.tier > 3 then
							--outer wobblers
							love.graphics.setColor(teamColours[node.team])
							love.graphics.circle('fill', node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*1), node.y-(nodeTiers[node.tier].radius)-(2+6*node.tier)+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1) - 3.3*(math.sin((timer+(nodeIndex*(i+1.1)%2.38)%1)*2*math.pi)+2),
								linkRadius-2)
							--border
							love.graphics.setColor(1, 1, 1)
							love.graphics.circle('line',  node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*(3+1.5*node.tier)))*1), node.y-(nodeTiers[node.tier].radius)-(2+6*node.tier)+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1) - 3.3*(math.sin((timer+(nodeIndex*(i+1.1)%2.38)%1)*2*math.pi)+2),
								linkRadius-2)
							


						end

					elseif node.tier == 5 then --ant - 2 feelers each and basic extra wobblers

					end

				end

				--rotate the whole screen centred on the node, redraw the feeler
				love.graphics.translate(node.x, node.y)
				love.graphics.rotate(math.pi/4)
				love.graphics.translate(-node.x, -node.y) -- I think this sets the origin back to 0,0 but with everything now rotated
			end
		end
		-- unrotates and resets origin
		love.graphics.origin()
		

		-- draw population number
		love.graphics.setFont(font20)  -- To-Do: make font bold
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf(node.population, node.x-nodeTiers[node.tier].radius, node.y-18, 2*nodeTiers[node.tier].radius, "center")
	end

	
	-- draw line between mouse and NODE after node selected, before release
	love.graphics.setColor(0.8, 0.8, 0)
	if love.mouse.isDown(1) then
		if nodeSelected > 0 and pointSelected == 0 then
			love.graphics.setColor(0.8, 0.8, 0)
			love.graphics.line(nodes[nodeSelected].x, nodes[nodeSelected].y, love.mouse.getX(), love.mouse.getY())
			love.graphics.line(nodes[nodeSelected].x, nodes[nodeSelected].y, love.mouse.getX(), love.mouse.getY()) -- arrow on mouse
		else
			love.graphics.setColor(0.8, 0, 0)
			love.graphics.line(pointSelected.x, pointSelected.y, love.mouse.getX(), love.mouse.getY())
			--get angle of red line
			--print(calculateSourceYAngleAny({x = pointSelected.x, y = pointSelected.y}, {x = love.mouse.getX(), y = love.mouse.getY()}))

		end
	end

end
