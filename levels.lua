--this goes into the nodes table
function levelNodes(arenaWidth,arenaHeight)
--level 1	
	print("Levels ready... ")
	return
	{
		{ -- level 1
			{
		        x = arenaWidth / 2,
		        y = arenaHeight / 2,
		        team = 2,  -- team starts from 1 for teamColours[team] to make sense, 1 = grey, 2 = green, 3 = red
		        population = 60,
		        tier = 3,
		        regenTimer = 5,
		        tentaclesUsed = 0,
		    	effectTimer = 0  
		    },
		    {
		        x = arenaWidth -300, 
		        y = arenaHeight / 3,
		        team = 3,
		        population = 3,
		        tier = 1,
		        regenTimer = 5,
		        tentaclesUsed = 0,
		    	effectTimer = 0  
		    }
		},


		{ -- level 2
			{
		        x = arenaWidth / 2 -150,
		        y = arenaHeight / 3,
		        team = 2,  -- team starts from 1 for teamColours[team] to make sense, 1 = grey, 2 = green, 3 = red
		        population = 10,
		        tier = 1,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		    {
		        x = arenaWidth / 2 ,
		        y = arenaHeight / 2,
		        team = 2, 
		        population = 10,
		        tier = 1,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		    {
		        x = arenaWidth / 2+50,
		        y = arenaHeight / 1.4,
		        team = 2,
		        population = 10,
		        tier = 1,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		    {
		        x = arenaWidth / 3.2 ,
		        y = arenaHeight / 1.4-100,
		        team = 3, 
		        population = 50,
		        tier = 3,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		    {
		        x = arenaWidth / 1.4 ,
		        y = arenaHeight / 3+50,
		        team = 2, 
		        population = 60,
		        tier = 3,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		},

		{ -- level 3
			{
		        x = arenaWidth / 5,
		        y = arenaHeight / 1.45,
		        team = 2,  -- team starts from 1 for teamColours[team] to make sense, 1 = grey, 2 = green, 3 = red
		        population = 50,
		        tier = 3,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		    {
		        x = arenaWidth/2.1, 
		        y = arenaHeight / 1.55,
		        team = 3,
		        population = 20,
		        tier = 2,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		    {
		        x = arenaWidth/4, 
		        y = arenaHeight / 3,
		        team = 1,
		        population = 20,
		        tier = 2,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		    {
		        x = arenaWidth/2.2, 
		        y = arenaHeight / 5,
		        team = 1,
		        population = 20,
		        tier = 2,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		    {
		        x = arenaWidth/1.4, 
		        y = arenaHeight / 3,
		        team = 1,
		        population = 20,
		        tier = 2,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    },
		    {
		        x = arenaWidth/1.4, 
		        y = arenaHeight / 1.5,
		        team = 1,
		        population = 20,
		        tier = 2,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0  
		    }
		},
	}
end

function levelWalls(arenaWidth,arenaHeight)

	return
	{
		{ -- level 1
		},
		{ -- level 2
		},
		{ -- level 3
			{
	    		startX = arenaWidth/2.6,
	    		startY = arenaHeight/1.1, --lower
	    		endX = arenaWidth/3,
	    		endY = arenaHeight/1.6
    		},
    		{
	    		startX = arenaWidth/3,
	    		startY = arenaHeight/1.6, --lower
	    		endX = arenaWidth/2.5,
	    		endY = arenaHeight/2.2
    		},
    		{
	    		startX = arenaWidth/2.5,
	    		startY = arenaHeight/2.2, --lower
	    		endX = arenaWidth/1.9,
	    		endY = arenaHeight/2.3
    		}
		},


	}

end




































