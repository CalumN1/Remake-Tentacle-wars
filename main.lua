io.stdout:setvbuf('no')

-- require "cards"  -- separate file, do this for each seperate file, not conf or main tho

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

	nodeRadius = 40  -- outer ring

	linkRadius = 8
	linkSpacing = 6


    nodeSelected = 0
    pointSelected = {}

    cutSource = {
    	--x = 5
    	-- y = 10
    }


    nodes = {
        {
            x = arenaWidth / 3,
            y = 100,
            team = 1,
            population = 30,
            tier = 1,
            regenDelay = 5,
            regenTimer = 5
        },
        {
            x = arenaWidth / 1.5, 
            y = 100,
            team = 0,
            population = 10,
            tier = 1,
            regenDelay = 5,
            regenTimer = 5
        },
        {
            x = 100,
            y = nodeMapHeight - 200,
            team = 0,
            population = 50,
            tier = 1,
            regenDelay = 5,
            regenTimer = 5
        },
        {
            x = arenaWidth / 2,
            y = nodeMapHeight - 100,
            team = 2,
            population = 3,
            tier = 1,
            regenDelay = 5,
            regenTimer = 5
        },
        {
            x = arenaWidth - 100,
            y = nodeMapHeight - 200,
            team = 2,
            population = 30,
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
        	opposedConnectionIndex = 0 -- 0 means no opposed connection
        }
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

function calculateSteps(x1,y1,x2,y2, extraSpacing)
	-- ratio of lengths: source to point vs source to end
	local ratio = (2*linkRadius+linkSpacing+extraSpacing)/(distancebetween(x1,y1,x2,y2)) -- e.g. 1/15
	print("ratio: ", ratio)
	local xStep = (x2 - x1)*ratio
	print("xStep: ", xStep)
	local yStep = (y2 - y1)*ratio

	return {x = xStep, y = yStep}


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

	print(shortYOpposite)

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
				if (distancebetween(connection.tentacleEnd.x, connection.tentacleEnd.y, nodes[connection.target].x, nodes[connection.target].y)) < nodeRadius then
					connection.moving = false
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
			end
		end
	end

end


function love.mousereleased(mouseX, mouseY)

	local releasenode = isMouseInNode()

	-- create connection, when mouse released on another node when selected > 0 
	if nodeSelected > 0 
	and releasenode > 0 
	and nodeSelected ~= releasenode   -- means not equal
	then

		local edges = calculateNodeEdges(nodeSelected, releasenode)

		local numLinksToMake = math.floor((distancebetween(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY))/((2*linkRadius)+linkSpacing))
		local extraSpacing = (distancebetween(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY))%((2*linkRadius)+linkSpacing)
		extraSpacing = extraSpacing/numLinksToMake

		local linkSteps = calculateSteps(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY, extraSpacing)

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
            opposedConnectionIndex = 0
		})





		-- add to connections a "moving" boolean
		-- it ends when function istentaclemoving() confirms
		-- add to connections a "tentacle" X and Y
		-- add to connections a "tentacleSource" X and Y
		-- add to connections a "tentacleTarget" X and Y
		-- add to connections a "tentacleMidpoint" X and Y
		-- istentaclemoving() checks if tentacle equals tentacle target or midpoint

		-- tentacleLinkPlotting()


		-- link creation
			--loops from 1 to number of nodes that would fit in the distance 
		for i = 1, 1 do -- numLinksToMake+1 do
			table.insert(connections[#connections].links, {
				x = edges.sourceX + (connections[#connections].linkXStep*(i-1)),
				y = edges.sourceY + (connections[#connections].linkYStep*(i-1))
			})
		end
		
		-- print every current connection
		for connectionIndex, connection in ipairs(connections) do
			print(connection.source, " -> ", connection.target)
		end
		print(" ------------------- ")
	
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

	-- draw line between linked nodes
	-- this is first so its underneath nodes
	
	for connectionIndex, connection in ipairs(connections) do 
		love.graphics.setColor(0.9, 0.9, 0.2)
		-- start, 1/8th of the way to the end, 2/8ths, etc. abs timer part ranges linearly from 0.5 to 0 and back to 0.5
		-- to do: draw a circle at each of these points below then can have the colour change to show flow, and create a loop so size can vary
		-- also maybe need to add noderadius to start and end points? to look like how tentacle wars does it

		--this part is just the connection lin to remove once proper links added
		--love.graphics.line( nodes[connection.source].x, nodes[connection.source].y, nodes[connection.target].x, nodes[connection.target].y)
		--[[love.graphics.line( --nodes[connection.source].x, nodes[connection.source].y,
			(((7*nodes[connection.source].x) + (1*nodes[connection.target].x))/8)+(((math.abs(((timer+0.2)%1)-0.5))*20)-5), (((7*nodes[connection.source].y) + (1*nodes[connection.target].y))/8)+(((math.abs(((timer)%1)-0.5))*20)-5),
			(((6*nodes[connection.source].x) + (2*nodes[connection.target].x))/8)+(((math.abs(((timer+0.3)%1)-0.5))*20)-5), (((6*nodes[connection.source].y) + (2*nodes[connection.target].y))/8)+(((math.abs(((timer+0.1)%1)-0.5))*20)-5),
			(((5*nodes[connection.source].x) + (3*nodes[connection.target].x))/8)+(((math.abs(((timer+0.4)%1)-0.5))*20)-5), (((5*nodes[connection.source].y) + (3*nodes[connection.target].y))/8)+(((math.abs(((timer+0.2)%1)-0.5))*20)-5),
			(((4*nodes[connection.source].x) + (4*nodes[connection.target].x))/8)+(((math.abs(((timer+0.5)%1)-0.5))*20)-5), (((4*nodes[connection.source].y) + (4*nodes[connection.target].y))/8)+(((math.abs(((timer+0.3)%1)-0.5))*20)-5),
			(((3*nodes[connection.source].x) + (5*nodes[connection.target].x))/8)+(((math.abs(((timer+0.6)%1)-0.5))*20)-5), (((3*nodes[connection.source].y) + (5*nodes[connection.target].y))/8)+(((math.abs(((timer+0.4)%1)-0.5))*20)-5),
			(((2*nodes[connection.source].x) + (6*nodes[connection.target].x))/8)+(((math.abs(((timer+0.7)%1)-0.5))*20)-5), (((2*nodes[connection.source].y) + (6*nodes[connection.target].y))/8)+(((math.abs(((timer+0.5)%1)-0.5))*20)-5),
			(((1*nodes[connection.source].x) + (7*nodes[connection.target].x))/8)+(((math.abs(((timer+0.8)%1)-0.5))*20)-5), (((1*nodes[connection.source].y) + (7*nodes[connection.target].y))/8)+(((math.abs(((timer+0.6)%1)-0.5))*20)-5)


			)]]
			--nodes[connection.target].x, nodes[connection.target].y)

		-- link making and wobble:
				-- ((timer%2)*math.pi)  > this moves smoothly and linearly from 0 to 359.9
				-- the sin of that varies non linearly, like a sin wave from 0 to 1 to -1 to 0
				-- then that number is scaled up relative to the X or Y linkStep, 
				-- the bigger the X step the more it should wobble in Y, hence the flipped X or Y step for scaling
				-- /3 at the end so the wobble is less dramatic 
		local prevXWobble = 0
		local prevYWobble = 0
		for linkIndex, link in ipairs(connection.links) do 
			local xwobble = 0
			local ywobble = 0
			if (linkIndex > 2 and linkIndex < #connection.links -1) or connection.moving == true then
				xwobble = (math.sin(((timer-(linkIndex/6))%2)*math.pi))*connection.linkYStep/3
				ywobble = (math.sin(((timer-(linkIndex/6))%2)*math.pi))*connection.linkXStep/3
			elseif linkIndex == 2 or linkIndex == #connection.links -1 then
				xwobble = (math.sin(((timer-(linkIndex/6))%2)*math.pi))*connection.linkYStep/6
				ywobble = (math.sin(((timer-(linkIndex/6))%2)*math.pi))*connection.linkXStep/6
			end
			if connection.moving == true then
				xwobble = 1.5*xwobble
				ywobble = 1.5*ywobble
			end


			love.graphics.setColor(0.1, 0.7, 0.1)
			if linkIndex == 1 then
				love.graphics.setColor(0.1, 0.0, 0.1)
			end
			love.graphics.circle('fill', link.x-xwobble, link.y+ywobble, linkRadius)				-- when tentacles fighting at midpoint, the middle links gets the responder's colour (not the first attacker)



			--linkWigglers
				-- links needs to be infront of node feelers, maybe redo this loop with just this bit, after node creation
			love.graphics.setColor(1, 1, 1)
			if linkIndex > 1 and linkIndex < #connection.links  then
				local linkcentre = {x = link.x-xwobble, y = link.y+ywobble}  --  this whole bits wrong, I'm basing it off the straight link-wobble lines but the point must change so that they "face different ways"
				local prevLinkCentre = {x = connection.links[linkIndex-1].x-prevXWobble, y = connection.links[linkIndex-1].y+prevYWobble}

				-- left side wigglers
					--/1.5 = how far along the wiggler, 2 would be almost on the link and 1 would be the end of the wiggler, so this is the range
					--/6 = how small the bend i.e. /2 is the biggest bend
				love.graphics.line(linkcentre.x, linkcentre.y, 
					linkcentre.x-(linkcentre.y - prevLinkCentre.y)/1.5+(linkcentre.x - prevLinkCentre.x)/6, linkcentre.y+(linkcentre.x - prevLinkCentre.x)/1.5+ (linkcentre.y - prevLinkCentre.y)/6,
					linkcentre.x-(linkcentre.y - prevLinkCentre.y)+(linkcentre.x - prevLinkCentre.x)/2, linkcentre.y+(linkcentre.x - prevLinkCentre.x)+ (linkcentre.y - prevLinkCentre.y)/2) 

				--right? handside link wigglers
				-- to mirror the above once the first side looks good
				love.graphics.line(linkcentre.x, linkcentre.y, 
					linkcentre.x+(linkcentre.y - prevLinkCentre.y), linkcentre.y-(linkcentre.x - prevLinkCentre.x))

				--[[love.graphics.line(linkcentre.x-(connection.linkYStep/3), linkcentre.y+(connection.linkXStep/3), 
					((linkcentre.x + (connection.links[linkIndex-1].x-prevXWobble))/2-(connection.linkYStep)), (linkcentre.y + (connection.links[linkIndex-1].y+prevYWobble))/2+(connection.linkXStep))

				love.graphics.line(linkcentre.x+(connection.linkYStep/3), linkcentre.y-(connection.linkXStep/3), 
					((linkcentre.x + (connection.links[linkIndex-1].x-prevXWobble))/2+(connection.linkYStep)), (linkcentre.y + (connection.links[linkIndex-1].y+prevYWobble))/2-(connection.linkXStep))]]
			end

			-- straight link-wobble lines
			--[[love.graphics.setColor(1, 1, 1)
			love.graphics.line(link.x, link.y, link.x-connection.linkYStep, link.y+connection.linkXStep)
			love.graphics.line(link.x, link.y, link.x+connection.linkYStep, link.y-connection.linkXStep)]]
			-- border
			love.graphics.setColor(1, 1, 1)
			love.graphics.setLineWidth( 1 )
			love.graphics.circle('line', link.x-xwobble, link.y+ywobble, linkRadius)
			prevXWobble = xwobble
			prevYWobble = ywobble

		end

	end


	-- draw all nodes and population number
	for nodeIndex, node in ipairs(nodes) do
		-- draw node depending on team colour
		if node.team == 0 then
			love.graphics.setColor(0.7, 0.7, 0.7)
		elseif node.team == 1 then
		    love.graphics.setColor(0.1, 0.7, 0.1)
		elseif node.team == 2 then
		    love.graphics.setColor(0.7, 0.2, 0.2)
		else
			love.graphics.setColor(1, 1, 1)
		end
		-- draw node
		-- love.graphics.circle('fill', node.x, node.y, nodeRadius-10)
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
				node.x+((((math.abs(((timer+i/3)%1.5)-0.75))*10)-5)*0.1), node.y-(nodeRadius+10)-((20+((math.sin(((timer%5)/5)*math.pi))*4)-2)*0.25),
				node.x+((((math.abs(((timer+i/3)%1.5)-0.75))*10)-5)*0.3), node.y-(nodeRadius+10)-((20+((math.sin(((timer%5)/5)*math.pi))*4)-2)*0.5),
				node.x+((((math.abs(((timer+i/3)%1.5)-0.75))*10)-5)*0.6), node.y-(nodeRadius+10)-((20+((math.sin(((timer%5)/5)*math.pi))*4)-2)*0.75),
				node.x+((((math.abs(((timer+i/3)%1.5)-0.75))*10)-5)*1), node.y-(nodeRadius+10)-((20+((math.sin(((timer%5)/5)*math.pi))*4)-2)*1))

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
		end

		
	else

	end

end
