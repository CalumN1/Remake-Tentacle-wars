io.stdout:setvbuf('no')

require "cards"  -- separate file, do this for each seperate file, not conf or main tho

function love.load()
	arenaWidth = 1200
    arenaHeight = 900 -- changing this doesnt do anything? need to at least change conf file too

    nodeMapWidth = 1200
	nodeMapHeight = 600

    love.graphics.setBackgroundColor( 0.3, 0.5, 0.3)

    font14 = love.graphics.newFont(14)
    font20 = love.graphics.newFont(20)
    font28 = love.graphics.newFont(28)

	nodeWidth = 40
    nodeHeight = 40

    cardWidth = 180
    cardHeight = 220
    
    round = 1
    nodeSelected = 0
    cardSelected = 0

    energy = 3
    maxHandSize = 4

    nodes = {
        {
            x = arenaWidth / 3,
            y = 100,
            team = 1,
            population = 10,
            block = 0
        },
        {
            x = arenaWidth / 1.5, 
            y = 100,
            team = 0,
            population = 10,
            block = 0
        },
        {
            x = 100,
            y = nodeMapHeight - 200,
            team = 0,
            population = 10,
            block = 0
        },
        {
            x = arenaWidth / 2,
            y = nodeMapHeight - 100,
            team = 2,
            population = 3,
            block = 0
        },
        {
            x = arenaWidth - 100,
            y = nodeMapHeight - 200,
            team = 2,
            population = 30,
            block = 0
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

    -- card.cx = centre base of card (because of setup in draw) and is -1 when not visible
    allCards = {
    	{
    		name = "Sabotage",
    		description = "deal 3 damage",
    		attack = 3,
    		cx = -1,
    		y = -1

    	},
    	{
    		name = "Fortify",
    		description = "give a node 3 block",
    		block = 3,
    		cx = -1,
    		y = -1
    	},
    	{
    		name = "Populate",
    		description = "give a node 4 more units",
    		generate = 2,
    		cx = -1,
    		y = -1
    	},
    	{
    		name = "Share",
    		description = "give all nodes 1 more units",
    		generate = 2,
    		cx = -1,
    		y = -1
    	}
    }

    drawPile = {
    	{
    		name = "Sabotage",
    		description = "deal 3 damage",
    		attack = 3,
    		cx = -1,
    		y = -1
    	},
    	{
    		name = "Fortify",
    		description = "give a node 3 block",
    		block = 3,
    		cx = -1,
    		y = -1
    	},
    	{
    		name = "Populate",
    		description = "give a node 4 more units",
    		generate = 2,
    		cx = -1,
    		y = -1
    	},
    	{
    		name = "Share",
    		description = "give all nodes 1 more units",
    		generate = 2,
    		cx = -1,
    		y = -1
    	}
    }

    hand = {
    }
    
    discardPile = {
    }


    function isMouseInNode()
        
    	for nodeIndex, node in ipairs(nodes) do
	    	if love.mouse.getX() >= node.x 
		        and love.mouse.getX() < node.x + nodeWidth
		        and love.mouse.getY() >= node.y
		        and love.mouse.getY() < node.y + nodeHeight 
		    then
				return nodeIndex
			end

		end

		return 0

        -- return nodeSelected
    end

    function isMouseInCard()
        
        for i = #hand, 1, -1 do
    	--for cardIndex, card in ipairs(hand) do
    		card = hand[i]
	    	if love.mouse.getX() >= card.cx - (cardWidth/2)
		        and love.mouse.getX() < card.cx + (cardWidth/2) 
		        and love.mouse.getY() >= card.y
		        and love.mouse.getY() < card.y + cardHeight 
		    then
				return i
			end

		end

		return 0

        -- return nodeSelected
    end

    fillHand()
end



function love.update(dt)


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
	


	-- trigger card
	elseif	
 	nodeSelected == 0 
	and releasenode > 0 
	and cardSelected > 0
	then
		print(hand[cardSelected].name, " > node: ", releasenode)
		triggerCard(releasenode)
	end
end

function triggerCard(releasenode)

	if hand[cardSelected].name == "Sabotage" then
		sabotage(releasenode)
	elseif hand[cardSelected].name == "Populate" then
		populate(releasenode)
	elseif hand[cardSelected].name == "Share" then
		share(releasenode)
	elseif hand[cardSelected].name == "Fortify" then
		fortify(releasenode)
	end

	table.insert(discardPile, hand[cardSelected])
	table.remove(hand, cardSelected)

	for cardIndex, card in ipairs(hand) do
		card.cx = (((cardIndex)/(#hand+1))*800) + 200   -- when drawn, cardwidth/2 is subtracted so that car.cx = the centre
		print(cardIndex, #hand, card.cx)
		card.y = nodeMapHeight+((arenaHeight - nodeMapHeight)/2)-cardHeight/2
	end

end




function love.keypressed(space)
	
	-- New round

	newRound()

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

	discardHand()

	fillHand()

	round = round +1

	-- regeneration
	for nodeIndex, node in ipairs(nodes) do
		if node.team > 0 then
			node.population = node.population + 1
		end
	end

end

function discardHand()
	-- move any cards in hand to discard pile 
	for cardIndex, card in ipairs(hand) do
		table.insert(discardPile, card)
	end
	hand = {}
end


function fillHand()
	-- fill hand with cards
	while #hand < maxHandSize do
		if #drawPile > 0 then
			drawnCardIndex = math.floor(love.math.random( 1, #drawPile ))
			table.insert(hand, drawPile[drawnCardIndex])
			print(drawPile[drawnCardIndex].name)
		    table.remove(drawPile, drawnCardIndex)
		else
			-- move all cards in discard to draw
			for cardIndex, card in ipairs(discardPile) do 
				table.insert(drawPile, card)     -- need to shuffle   (fisher  yates?)
			end
			discardPile = {}
			print("looping", #drawPile)
		end
			
	end

	-- space out cards

--pretend a card is on the furthest points and equally space them from there
	-- 1 , 300, 600, 900
-- so 0/2, 1/2, 2/2 
	-- 2 cards, 300- 500 - 700- 900
-- 0/3, 1/3, 2/3, 3/3
	-- 3, 	300 - 450 -600 -750 - 900
	--0/4, 1/4, 2/4, 3/4, 4/4

	-- 
	for cardIndex, card in ipairs(hand) do
		card.cx = (((cardIndex)/(#hand+1))*800) + 200   -- when drawn, cardwidth/2 is subtracted so that car.cx = the centre
		print(cardIndex, #hand, card.cx)
		card.y = nodeMapHeight+((arenaHeight - nodeMapHeight)/2)-cardHeight/2
	end
		--- need card borders
end



function love.mousepressed(mouseX, mouseY)
	
	nodeSelected = isMouseInNode() 

	cardSelected = isMouseInCard()


end



function love.draw(mouseX, mouseY)


	love.graphics.setFont(font14)

	-- draw line between linked nodes
	-- this is first so its underneath nodes
	love.graphics.setColor(0.9, 0.9, 0.2)
	for connectionIndex, connection in ipairs(connections) do
		love.graphics.line(nodes[connection.source].x+20, nodes[connection.source].y+20, nodes[connection.target].x+20, nodes[connection.target].y+20)
	end

	-- draw all nodes and population number
	for nodeIndex, node in ipairs(nodes) do
		-- draw node depending on team colour
		if node.team == 0 then
			love.graphics.setColor(0.7, 0.7, 0.7)
		elseif node.team == 1 then
		    love.graphics.setColor(0.2, 0.2, 1)
		elseif node.team == 2 then
		    love.graphics.setColor(0.7, 0.2, 0.2)
		else
			love.graphics.setColor(1, 1, 1)
		end
		-- draw node
		love.graphics.rectangle('fill', node.x, node.y, nodeWidth, nodeHeight)

		-- draw block
		if (node.block > 0) then
			love.graphics.setColor(0.5, 0.5, 1, 0.3)  
			love.graphics.setLineWidth( node.block/2 )   -- thickness grows depending on block, to-do
			love.graphics.circle( "line", node.x+(nodeWidth/2), node.y+(nodeHeight/2), nodeWidth*3/4 + node.block/4)

			--draw block number display
			love.graphics.setColor(0.3, 0.3, 1, 1)  
			love.graphics.printf(node.block, node.x, node.y-30, nodeWidth, "center")
		end

		-- draw population number
		love.graphics.setColor(0, 0, 0)
		love.graphics.printf(node.population, node.x, node.y+12, nodeWidth, "center")
	end
	-- round no display
	love.graphics.print(round, 20, 20)

	-- lower HUD background
	love.graphics.setColor(0.4, 0.4, 0.4, 0.8)
	love.graphics.rectangle('fill', 20, nodeMapHeight, nodeMapWidth - 40, arenaHeight - nodeMapHeight - 20, 25, 25)

	-- energy circle
	love.graphics.setColor(0.2, 0.5, 0.7)
	love.graphics.circle('fill', 100, nodeMapHeight + 50, 30)
	-- energy text
	love.graphics.setFont(font28)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(energy, 100-9, nodeMapHeight + 50-15)

	-- cards hand display
	for cardIndex, card in ipairs(hand) do    -- need to divide space by #hand (aka hand size) and spread cards evenly depending on number of cards
		love.graphics.setColor(0.9, 0.9, 0.4)
		love.graphics.rectangle('fill', card.cx -(cardWidth/2), card.y, cardWidth, cardHeight, 5, 5)
		-- border
		love.graphics.setLineWidth( 2 )
		love.graphics.setColor(0.8, 0.8, 0.3)
		love.graphics.rectangle('line', card.cx -(cardWidth/2), card.y, cardWidth, cardHeight, 5, 5)
		--card text
		love.graphics.setColor(0.4, 0, 0)
		love.graphics.printf(card.name, card.cx -(cardWidth/2), card.y, cardWidth,"center") -- needs centred, currently /4 (vs /2) is fine but needs fixed
	end

	-- draw line between mouse and NODE after node selected
	love.graphics.setColor(0.8, 0.8, 0)
	if love.mouse.isDown(1) and nodeSelected > 0 then
		love.graphics.line(nodes[nodeSelected].x+20, nodes[nodeSelected].y+20, love.mouse.getX(), love.mouse.getY())
	end

	-- draw line between mouse and CARD after card selected
	if love.mouse.isDown(1) and cardSelected > 0 then
		love.graphics.line(hand[cardSelected].cx, hand[cardSelected].y, love.mouse.getX(), love.mouse.getY())

		--arrow

	end

end
