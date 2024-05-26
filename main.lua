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

	nodeRadius = 36  -- outer ring

	linkRadius = 7
	linkSpacing = 10


    nodeSelected = 0
    pointSelected = 0

    cutSource = {
    	--x = 5
    	-- y = 10
    }


    nodes = {
        {
            x = arenaWidth / 3,
            y = 100,
            team = 2,
            population = 30,
            tier = 1,
            regenDelay = 5,
            regenTimer = 5
        },
        {
            x = arenaWidth / 1.5, 
            y = 100,
            team = 1,
            population = 10,
            tier = 1,
            regenDelay = 5,
            regenTimer = 5
        },
        {
            x = 100,
            y = nodeMapHeight - 200,
            team = 1,
            population = 50,
            tier = 1,
            regenDelay = 5,
            regenTimer = 5
        },
        {
            x = arenaWidth / 2,
            y = nodeMapHeight - 100,
            team = 3,
            population = 3,
            tier = 1,
            regenDelay = 5,
            regenTimer = 5
        },
        {
            x = arenaWidth - 100,
            y = nodeMapHeight - 600,
            team = 3,
            population = 50,
            tier = 1,
            regenDelay = 5,
            regenTimer = 5
        },
    }

    connections = {
        {
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
            destination = 2,
        	opposedConnectionIndex = 0, -- 0 means no opposed connection
        	splitLink = 0
        }
    }

    teamColours = {
    	{0.7, 0.7, 0.7},
    	{0.1, 0.7, 0.1},
    	{0.7, 0.2, 0.2}
    }



    function isMouseInNode()
        
    	for nodeIndex, node in ipairs(nodes) do
	    	if distancebetween(love.mouse.getX(), love.mouse.getY(), node.x, node.y) < nodeRadius+10 then
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

	local shortHypot = nodeRadius
	local shortXOpposite = shortHypot * math.sin(sourceAngle)
	local shortYAdjacent = shortHypot * math.cos(sourceAngle)

	-- source
	if (nodes[sourceNode].x < nodes[targetNode].x) then
		sourceX = nodes[sourceNode].x + shortXOpposite
	else
		sourceX = nodes[sourceNode].x - shortXOpposite
	end

	if (nodes[sourceNode].y < nodes[targetNode].y) then
		sourceY = nodes[sourceNode].y + shortYAdjacent
	else
		sourceY = nodes[sourceNode].y - shortYAdjacent
	end


	-- target
	-- reverse of source
	if (nodes[sourceNode].x < nodes[targetNode].x) then
		targetX = nodes[targetNode].x - shortXOpposite
	else
		targetX = nodes[targetNode].x + shortXOpposite
	end

	if (nodes[sourceNode].y < nodes[targetNode].y) then
		targetY = nodes[targetNode].y - shortYAdjacent
	else
		targetY = nodes[targetNode].y + shortYAdjacent
	end



	print("targetX: ",targetX, "   targetY: ", targetY)

	return {sourceX = sourceX, sourceY = sourceY, targetX = targetX, targetY = targetY}



end


function love.update(dt)

	timer = timer + dt
	-- print(timer)

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
end


function updateMovingConnections()

	tentacleEnd = connections[#connections].links[1]

	for connectionIndex, connection in ipairs(connections) do
		if connection.moving == true then
			-- breaking a connection
			if connection.destination == 0 then 
				for linkIndex, link in ipairs(connection.links) do
					link.x = link.x - (connection.linkXStep/7)
					link.y = link.y - (connection.linkYStep/7)
					if distancebetween(link.x, link.y, nodes[connection.source].x, nodes[connection.source].y) < nodeRadius-linkRadius then
						table.remove(connection.links, linkIndex)
						nodes[connection.source].population = nodes[connection.source].population + 1
					end
					if #connection.links == 0 then  -- could've also used tentacle end point
						connection.moving = false
						nodes[connection.source].population = nodes[connection.source].population - 1
						table.remove(connections, connectionIndex)
					end
					
				end

			-- moving a connection to midpoint 
			elseif connection.destination == 1 then
				if distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connection.targetEdge.x, connection.targetEdge.y) < distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, connection.sourceEdge.x, connection.sourceEdge.y) then
					-- closer to target, so its long and needs to move back
					if connection.tentacleEnd.x == connections[connection.opposedConnectionIndex].tentacleEnd.x then
						-- touching
						link.x = link.x - (connection.linkXStep/10)
						link.y = link.y - (connection.linkYStep/10)
					else
						-- not touching
						-- keep moving but check if touching
					end
				else
					-- closer to source, so its short and should move forward

				end
			
			-- moving a connection to target 
			elseif connection.destination == 2 then
				for linkIndex, link in ipairs(connection.links) do
					link.x = link.x + (connection.linkXStep/20)
					link.y = link.y + (connection.linkYStep/20)
				end

				-- compare distance of potential link location to node centre vs node radius. i.e. if potential link is within radius
				if (distancebetween(connection.links[#connection.links].x - (connection.linkXStep), connection.links[#connection.links].y - (connection.linkYStep), nodes[connection.source].x, nodes[connection.source].y)) > nodeRadius-linkRadius then
					table.insert(connection.links, {
						x = connection.links[#connection.links].x - (connection.linkXStep),
						y = connection.links[#connection.links].y - (connection.linkYStep)
					})
					nodes[connection.source].population = nodes[connection.source].population - 1
				end

				-- reached target?
				--compare distance of tentacle end vs node radius. i.e. if potential link is within radius
				if (distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, nodes[connection.target].x, nodes[connection.target].y)) < nodeRadius+2 then
					connection.moving = false
				end

			-- connection has been split, and splitLink is defined
			elseif connection.destination == 3 then
				for linkIndex, link in ipairs(connection.links) do
					if linkIndex > connection.splitLink then --send to source
						link.x = link.x - (connection.linkXStep/7)
						link.y = link.y - (connection.linkYStep/7)
						if distancebetween(link.x, link.y, nodes[connection.source].x, nodes[connection.source].y) < nodeRadius-linkRadius then
							table.remove(connection.links, linkIndex)
							nodes[connection.source].population = nodes[connection.source].population + 1
						end
					else --send to target
						link.x = link.x + (connection.linkXStep/7)
						link.y = link.y + (connection.linkYStep/7)
						if distancebetween(link.x, link.y, nodes[connection.target].x, nodes[connection.target].y) < nodeRadius-linkRadius then
							table.remove(connection.links, linkIndex)
							connection.splitLink = connection.splitLink -1
							if nodes[connection.target].team == connection.team then
								nodes[connection.target].population = nodes[connection.target].population + 1
							else
								nodes[connection.target].population = nodes[connection.target].population - 1
								if nodes[connection.target].population < 0 then
									nodes[connection.target].team = connection.team 
									nodes[connection.target].population = math.abs(nodes[connection.target].population)
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

			if nodes[connection.source].population == 0 and connection.moving == true and connection.destination ~= 0 then
				connection.destination = 0
			end
		end
	end
end


function checkOpposedConnections()

	for connectionIndex1, connection1 in ipairs(connections) do
		for connectionIndex2, connection2 in ipairs(connections) do
			-- work out if a connection is opposed and set opposed
			if connection1.source == connection2.target and connection1.target == connection2.source and connectionIndex1 ~= connectionIndex2 and connection1.opposedConnectionIndex == 0 and connection2.opposedConnectionIndex == 0 then 
				connection1.opposedConnectionIndex = connectionIndex2
				connection2.opposedConnectionIndex = connectionIndex1
				print("OPPOSED!")

				connection1.destination = 1
				connection2.destination = 1

			end
		end
	end

end



function splitTentacle(connectionIndex, ix, iy)

	local connection = connections[connectionIndex]

	local ratio = distancebetween(connection.sourceEdge.x, connection.sourceEdge.y, ix, iy) / 
	distancebetween(connection.sourceEdge.x, connection.sourceEdge.y, connection.targetEdge.x, connection.targetEdge.y)

	connection.splitLink = #connection.links - math.floor(#connection.links * ratio +0.5)-1

end



function love.mousereleased(mouseX, mouseY)

	local releasenode = isMouseInNode()

	-- create connection, when mouse released on another node when selected > 0 
	if nodeSelected > 0 
	and releasenode > 0 
	and nodeSelected ~= releasenode   -- means not equal
	and nodes[nodeSelected].population > 0
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
            	x = 200,
            	y = 200
            },
            linkXStep = linkSteps.x,
            linkYStep = linkSteps.y,
            links = {
            },
            destination = 2,
            opposedConnectionIndex = 0,
            splitLink = 0
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
		--end

		tentacleEnd = connections[#connections].links[1]
		
		-- print every current connection
		for connectionIndex, connection in ipairs(connections) do
			print(connection.source, " -> ", connection.target)
		end
		print(" ------------------- ")


	-- cutting a connection
	elseif (nodeSelected == 0 and pointSelected ~= 0) then
		-- check every connection for intersection
		for connectionIndex, connection in ipairs(connections) do 
			ix, iy = findIntersectionPoint(connection.sourceEdge.x,connection.sourceEdge.y, connection.targetEdge.x,connection.targetEdge.y, pointSelected.x, pointSelected.y, love.mouse.getX(), love.mouse.getY())
			if ix ~= nil and iy ~= nil then
				love.graphics.circle('line', ix, iy, linkRadius)
				
				if (connection.destination < 2 or connection.moving == true) and connection.destination ~= 3  then
					connection.destination = 0
				else
					connection.destination = 3 
					splitTentacle(connectionIndex, ix, iy) --updates connection.splitLink
					nodes[connection.target].population = nodes[connection.target].population + 1
					
					if distancebetween(connection.links[connection.splitLink+1].x, connection.links[connection.splitLink+1].y, connection.sourceEdge.x, connection.sourceEdge.y) < 
						distancebetween(connection.links[connection.splitLink+1].x, connection.links[connection.splitLink+1].y, connection.targetEdge.x, connection.targetEdge.y) then
						nodes[connection.target].population = nodes[connection.target].population - 1
					else
						nodes[connection.source].population = nodes[connection.source].population - 1
					end
				end

				connection.moving = true --this triggers everything to start processing this tentacle again till resolved

			end
		end
	end
end


function newRound() -- consider moving whole function into load function? like inNode() ?

	-- New round

	-- source node to unit calculations
	for connectionIndex, connection in ipairs(connections) do
		-- turn each connection into units
		table.insert(units, {
		source = connection.source, target = connection.target, population = connection.population, team = nodes[connection.source].team
		})
		-- remove the new unit's population from the source's population
		nodes[connection.source].population = nodes[connection.source].population - connection.population
	end

	-- remove connections, as they've all been turned into units
	connections = {}
	

	-- units to target calculations
	for unitsIndex, unit in ipairs(units) do
		if nodes[unit.target].team == unit.team then --friendly node
			nodes[unit.target].population = nodes[unit.target].population + unit.population
		else -- enemy node
			if nodes[unit.target].block > 0 then
				nodes[unit.target].block = nodes[unit.target].block - unit.population
				if nodes[unit.target].block < 0 then
					unit.population = -nodes[unit.target].block 
					nodes[unit.target].block = 0
				else
					unit.population = 0
				end
			end
			nodes[unit.target].population = nodes[unit.target].population - unit.population
			if nodes[unit.target].population < 0 then
				nodes[unit.target].team = unit.team
				nodes[unit.target].population = -nodes[unit.target].population
			end
		end
	end

	units = {}

	-- regeneration
	for nodeIndex, node in ipairs(nodes) do
		if node.team > 0 then
			node.population = node.population + 1
		end
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


	-- draw line between linked nodes
	-- this is first so its underneath nodes
	
	for connectionIndex, connection in ipairs(connections) do 
		love.graphics.setColor(0.9, 0.9, 0.2)
		-- start, 1/8th of the way to the end, 2/8ths, etc. abs timer part ranges linearly from 0.5 to 0 and back to 0.5
		-- to do: draw a circle at each of these points below then can have the colour change to show flow, and create a loop so size can vary
		-- also maybe need to add noderadius to start and end points? to look like how tentacle wars does it

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
			if (Index+1 > 2 and Index < #connection.links -2) or connection.moving == true then
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
				if (connection.moving == true or Index+1 > 2) and Index < #connection.links  then  --- switching this to index+1 and removing the "-1" from lin


					local linkToTargetDist = distancebetween(connection.links[Index].x, connection.links[Index].y, connection.targetEdge.x, connection.targetEdge.y) --ignores wobble
					local linkToSourceDist = distancebetween(connection.links[Index].x, connection.links[Index].y, connection.sourceEdge.x, connection.sourceEdge.y) 

					if connection.moving == true and linkToTargetDist < 2*linkRadius + 2*linkSpacing + 10*linkRadius then -- 108 to 0 away, 2 was 59
						--reduce wobble when close, to avoid lock on jump
						xWobble = xWobble*linkToTargetDist/108
						yWobble = yWobble*linkToTargetDist/108
					end

					local wigglerShrink = 1
					if linkToTargetDist < 2*linkRadius + 2*linkSpacing + 10*linkRadius then
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
					

					love.graphics.setColor(1,1,1)
					love.graphics.setLineWidth( 1 )

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
				love.graphics.setColor(1, 1, 1)

				if connection.destination == 3 and Index == connection.splitLink then
					
					love.graphics.setColor(0, 1, 1)

				end

				love.graphics.setLineWidth( 1 )
				love.graphics.circle('line', connection.links[Index].x-xWobble, connection.links[Index].y+yWobble, linkRadius)
	
				love.graphics.setColor(teamColours[connection.team])
				--link
				love.graphics.circle('fill', connection.links[Index].x-xWobble, connection.links[Index].y+yWobble, linkRadius-2)				-- when tentacles fighting at midpoint, the middle links gets the responder's colour (not the first attacker)

			end
			xWobble = nextXWobble
			yWobble = nextYWobble
		end
	end


	-- draw all nodes and population number
	for nodeIndex, node in ipairs(nodes) do
		-- draw node depending on team colour
		--[[if node.team == 0 then
			love.graphics.setColor(0.7, 0.7, 0.7)
		elseif node.team == 1 then
		    love.graphics.setColor(0.1, 0.7, 0.1)
		elseif node.team == 2 then
		    love.graphics.setColor(0.7, 0.2, 0.2)
		else
			love.graphics.setColor(1, 1, 1)
		end]]
		love.graphics.setColor(teamColours[node.team])
		-- draw node
		love.graphics.circle('fill', node.x, node.y, nodeRadius-10)
		-- border
		love.graphics.setColor(1, 1, 1)
		love.graphics.setLineWidth( 3 )
		love.graphics.circle('line', node.x, node.y, nodeRadius-10)
		-- outer ring
		love.graphics.circle('line', node.x, node.y, nodeRadius)

	 	--feelers
	 	love.graphics.setLineWidth( 1 )
	 	for i = 1, 8 do
			love.graphics.line(node.x, node.y-(nodeRadius), 
				node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*0.1), node.y-(nodeRadius)+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.1),
				node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*0.2), node.y-(nodeRadius)-5+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.2),
				node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*0.5), node.y-(nodeRadius)-10+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*0.5),
				node.x+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%1.6)*1.25*math.pi)*5))*1), node.y-(nodeRadius)-15+(((math.sin(((timer+(i*nodeIndex/10)+i/1.9)%0.8)*2.25*math.pi)*0.2))*1))

			--rotate the whole screen centred on the node, redraw the feeler
			love.graphics.translate(node.x, node.y)
			love.graphics.rotate(math.pi/4)
			love.graphics.translate(-node.x, -node.y) -- I think this sets the origin back to 0,0 but with everything now rotated
		end
		-- unrotates and resets origin
		love.graphics.origin()

		-- draw population number
		love.graphics.setFont(font20)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf(node.population, node.x-nodeRadius, node.y-18, 2*nodeRadius, "center")
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
