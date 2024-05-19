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

	nodeRadius = 30


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
        --{
            --source = 2,
            --target = 3,
            --population = 2
        --}
    }


    units = {
    	--{
    	--	source = 1,
    	--	target = 1,
    	--	population = 10,
    	--	team = 1
    	--},
    }


    function isMouseInNode()
        
    	for nodeIndex, node in ipairs(nodes) do
	    	if math.sqrt((love.mouse.getX() - node.x)^2 + (love.mouse.getY() - node.y)^2) < nodeRadius+10 then
				return nodeIndex
			end

		end

		return 0

        -- return nodeSelected
    end


end



function love.update(dt)

	timer = timer + dt
	print(timer)

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
			table.insert(connections, {
			source = nodeSelected, target = releasenode, population = nodes[nodeSelected].population
			})
		
		-- print whenever a connection is made
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
	love.graphics.setColor(0.9, 0.9, 0.2)
	for connectionIndex, connection in ipairs(connections) do 
		-- start, 1/8th of the way to the end, 2/8ths, etc. abs timer part ranges linearly from 0.5 to 0 and back to 0.5
		-- to do: draw a circle at each of these points below then can have the colour change to show flow, and create a loop so size can vary
		love.graphics.line(nodes[connection.source].x, nodes[connection.source].y,
			(((7*nodes[connection.source].x) + (1*nodes[connection.target].x))/8)+(((math.abs(((timer+0.2)%1)-0.5))*20)-5), (((7*nodes[connection.source].y) + (1*nodes[connection.target].y))/8)+(((math.abs(((timer)%1)-0.5))*20)-5),
			(((6*nodes[connection.source].x) + (2*nodes[connection.target].x))/8)+(((math.abs(((timer+0.3)%1)-0.5))*20)-5), (((6*nodes[connection.source].y) + (2*nodes[connection.target].y))/8)+(((math.abs(((timer+0.1)%1)-0.5))*20)-5),
			(((5*nodes[connection.source].x) + (3*nodes[connection.target].x))/8)+(((math.abs(((timer+0.4)%1)-0.5))*20)-5), (((5*nodes[connection.source].y) + (3*nodes[connection.target].y))/8)+(((math.abs(((timer+0.2)%1)-0.5))*20)-5),
			(((4*nodes[connection.source].x) + (4*nodes[connection.target].x))/8)+(((math.abs(((timer+0.5)%1)-0.5))*20)-5), (((4*nodes[connection.source].y) + (4*nodes[connection.target].y))/8)+(((math.abs(((timer+0.3)%1)-0.5))*20)-5),
			(((3*nodes[connection.source].x) + (5*nodes[connection.target].x))/8)+(((math.abs(((timer+0.6)%1)-0.5))*20)-5), (((3*nodes[connection.source].y) + (5*nodes[connection.target].y))/8)+(((math.abs(((timer+0.4)%1)-0.5))*20)-5),
			(((2*nodes[connection.source].x) + (6*nodes[connection.target].x))/8)+(((math.abs(((timer+0.7)%1)-0.5))*20)-5), (((2*nodes[connection.source].y) + (6*nodes[connection.target].y))/8)+(((math.abs(((timer+0.5)%1)-0.5))*20)-5),
			(((1*nodes[connection.source].x) + (7*nodes[connection.target].x))/8)+(((math.abs(((timer+0.8)%1)-0.5))*20)-5), (((1*nodes[connection.source].y) + (7*nodes[connection.target].y))/8)+(((math.abs(((timer+0.6)%1)-0.5))*20)-5),



			nodes[connection.target].x, nodes[connection.target].y)
	end

	-- draw all nodes and population number
	for nodeIndex, node in ipairs(nodes) do
		-- draw node depending on team colour
		if node.team == 0 then
			love.graphics.setColor(0.7, 0.7, 0.7)
		elseif node.team == 1 then
		    love.graphics.setColor(0.1, 0.9, 0.2)
		elseif node.team == 2 then
		    love.graphics.setColor(0.7, 0.2, 0.2)
		else
			love.graphics.setColor(1, 1, 1)
		end
		-- draw node
		love.graphics.circle('fill', node.x, node.y, nodeRadius)
		-- border
		love.graphics.setColor(1, 1, 1)
		love.graphics.setLineWidth( 3 )
		love.graphics.circle('line', node.x, node.y, nodeRadius)
		-- outer ring
		love.graphics.circle('line', node.x, node.y, nodeRadius+10)

	 	--feelers
	 	love.graphics.setLineWidth( 1 )
	 	for i = 1, 8 do
			love.graphics.line(node.x, node.y-(nodeRadius+10), 
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
