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

    cutSource = {
    	--x = 5
    	-- y = 10
    }


    nodes = {
        {
            x = arenaWidth / 3,
            y = 100,
            team = 1,
            population = 10,
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
            population = 10,
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
            source = 2,
            target = 3,
            population = 2,
            linkXStep = 23,
            linkYStep = 10,
            links = {
            	x = 200,
            	y = 200

            }
        
        }
    }

    edgesTemp = {
        
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

	table.insert(edgesTemp,{x = sourceX, y = sourceY})
	table.insert(edgesTemp,{x = targetX, y = targetY})

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
	

	
	-- print(love.mouse.getY())
end

function love.mousereleased(mouseX, mouseY)

	local releasenode = isMouseInNode()

	-- create connection, when mouse released on another node when selected > 0 
	if nodeSelected > 0 
	and releasenode > 0 
	and nodeSelected ~= releasenode   -- means not equal
	then
		local edges = calculateNodeEdges(nodeSelected, releasenode)
		print(edges.sourceX)

		local numLinksToMake = math.floor((distancebetween(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY))/((2*linkRadius)+linkSpacing))
		local extraSpacing = (distancebetween(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY))%((2*linkRadius)+linkSpacing)
		extraSpacing = extraSpacing/numLinksToMake

		local linkSteps = calculateSteps(edges.sourceX, edges.sourceY, edges.targetX, edges.targetY, extraSpacing)

		-- connection creation with no links
		table.insert(connections, {
		source = nodeSelected, target = releasenode, population = nodes[nodeSelected].population, linkXStep = linkSteps.x, linkYStep = linkSteps.y, links = {}
		})

		-- link creation
			--loops from 1 to number of nodes that would fit in the distance 
		for i = 1, numLinksToMake+1 do
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
		for linkIndex, link in ipairs(connection.links) do 
			local xwobble = 0
			local ywobble = 0
			if linkIndex > 2 and linkIndex < #connection.links -1 then
				xwobble = (math.sin(((timer+(linkIndex/6))%2)*math.pi))*connection.linkYStep/3
				ywobble = (math.sin(((timer+(linkIndex/6))%2)*math.pi))*connection.linkXStep/3
			elseif linkIndex == 2 or linkIndex == #connection.links -1 then
				xwobble = (math.sin(((timer+(linkIndex/6))%2)*math.pi))*connection.linkYStep/6
				ywobble = (math.sin(((timer+(linkIndex/6))%2)*math.pi))*connection.linkXStep/6
			end
			love.graphics.setColor(0.1, 0.7, 0.1)
			love.graphics.circle('fill', link.x-xwobble, link.y+ywobble, linkRadius)
			love.graphics.setColor(1, 1, 1)
			love.graphics.line(link.x, link.y, link.x-connection.linkYStep, link.y+connection.linkXStep)
			love.graphics.line(link.x, link.y, link.x+connection.linkYStep, link.y-connection.linkXStep)
			-- border
			love.graphics.setColor(1, 1, 1)
			love.graphics.setLineWidth( 1 )
			love.graphics.circle('line', link.x-xwobble, link.y+ywobble, linkRadius)

		end

		--[[for edgeIndex, edge in ipairs(edgesTemp) do 
			love.graphics.circle('fill', edge.x, edge.y, linkRadius)
		end]]
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
			love.graphics.translate(-node.x, -node.y)
		end
		-- reset origin
		love.graphics.origin()

		-- draw population number
		love.graphics.setFont(font20)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf(node.population, node.x-nodeRadius, node.y-18, 2*nodeRadius, "center")
	end

	
	-- draw line between mouse and NODE after node selected
	love.graphics.setColor(0.8, 0.8, 0)
	if love.mouse.isDown(1) and nodeSelected > 0 then
		love.graphics.line(nodes[nodeSelected].x, nodes[nodeSelected].y, love.mouse.getX(), love.mouse.getY())
		love.graphics.line(nodes[nodeSelected].x, nodes[nodeSelected].y, love.mouse.getX(), love.mouse.getY())
	end

end
