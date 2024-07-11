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
		        population =  60,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.775*arenaWidth,
				y =  0.31574074074074*arenaHeight,
				team =  3,
				population =  3,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},


		{	--level	2
			{ 
				x = 0.71388888888889*arenaWidth,
				y =  0.33425925925926*arenaHeight,
				team =  2,
				population =  60,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.30763888888889*arenaWidth,
				y =  0.60833333333333*arenaHeight,
				team =  3,
				population =  50,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.40763888888889*arenaWidth,
				y =  0.31944444444444*arenaHeight,
				team =  2,
				population =  10,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.50833333333333*arenaWidth,
				y =  0.4787037037037*arenaHeight,
				team =  2,
				population =  10,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.53541666666667*arenaWidth,
				y =  0.68333333333333*arenaHeight,
				team =  2,
				population =  10,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
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
			    effectTimer = 0, 
	            neutralPower = 30,
	            neutralTeam = 1  
		    },
		    {
		        x = arenaWidth/2.1, 
		        y = arenaHeight / 1.55,
		        team = 3,
		        population = 20,
		        tier = 2,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0, 
	            neutralPower = 30,
	            neutralTeam = 1  
		    },
		    {
		        x = arenaWidth/4, 
		        y = arenaHeight / 3,
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
		        x = arenaWidth/2.2, 
		        y = arenaHeight / 5,
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
		        x = arenaWidth/1.4, 
		        y = arenaHeight / 3,
		        team = 1,
		        population = 0,
		        tier = 2,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0, 
	            neutralPower = 30,
	            neutralTeam = 1  
		    },
		    {
		        x = arenaWidth/1.4, 
		        y = arenaHeight / 1.5,
		        team = 1,
		        population = 0,
		        tier = 2,
		        regenTimer = 5,
		        tentaclesUsed = 0,
			    effectTimer = 0, 
	            neutralPower = 30,
	            neutralTeam = 1  
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




































