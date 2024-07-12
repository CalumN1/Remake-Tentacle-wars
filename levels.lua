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

		{	--level	3
			{ 
				x = 0.20069444444444*arenaWidth,
				y =  0.3462962962963*arenaHeight,
				team =  1,
				population =  0,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  2
			},
			{ 
				x = 0.46805555555556*arenaWidth,
				y =  0.23240740740741*arenaHeight,
				team =  1,
				population =  0,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  2
			},
			{ 
				x = 0.72777777777778*arenaWidth,
				y =  0.34351851851852*arenaHeight,
				team =  1,
				population =  0,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  2
			},
			{ 
				x = 0.73541666666667*arenaWidth,
				y =  0.65277777777778*arenaHeight,
				team =  1,
				population =  0,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  2
			},
			{ 
				x = 0.49236111111111*arenaWidth,
				y =  0.66203703703704*arenaHeight,
				team =  3,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.14652777777778*arenaWidth,
				y =  0.67962962962963*arenaHeight,
				team =  2,
				population =  50,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	4
			{ 
				x = 0.43611111111111*arenaWidth,
				y =  0.51944444444444*arenaHeight,
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
				x = 0.72986111111111*arenaWidth,
				y =  0.50555555555556*arenaHeight,
				team =  3,
				population =  100,
				tier =  4,
				regenTimer = 3, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.37777777777778*arenaWidth,
				y =  0.21018518518519*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.39375*arenaWidth,
				y =  0.82222222222222*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.21805555555556*arenaWidth,
				y =  0.74537037037037*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.16041666666667*arenaWidth,
				y =  0.5212962962963*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.21736111111111*arenaWidth,
				y =  0.30092592592593*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	5
			{ 
				x = 0.47291666666667*arenaWidth,
				y =  0.4287037037037*arenaHeight,
				team =  1,
				population =  0,
				tier =  4,
				regenTimer = 3, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 90,
				neutralTeam =  2
			},
			{ 
				x = 0.82777777777778*arenaWidth,
				y =  0.21111111111111*arenaHeight,
				team =  5,
				population =  100,
				tier =  4,
				regenTimer = 3, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 90,
				neutralTeam =  1
			},
			{ 
				x = 0.17291666666667*arenaWidth,
				y =  0.32962962962963*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.20972222222222*arenaWidth,
				y =  0.58981481481481*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.33680555555556*arenaWidth,
				y =  0.80277777777778*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	6
			{ 
				x = 0.33333333333333*arenaWidth,
				y =  0.38981481481481*arenaHeight,
				team =  2,
				population =  10,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.64444444444444*arenaWidth,
				y =  0.39351851851852*arenaHeight,
				team =  2,
				population =  10,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.31319444444444*arenaWidth,
				y =  0.74351851851852*arenaHeight,
				team =  2,
				population =  10,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 6,
				neutralTeam =  1
			},
			{ 
				x = 0.67361111111111*arenaWidth,
				y =  0.74907407407407*arenaHeight,
				team =  1,
				population =  0,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 10,
				neutralTeam =  3
			},
			{ 
				x = 0.48819444444444*arenaWidth,
				y =  0.71759259259259*arenaHeight,
				team =  3,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.8875*arenaWidth,
				y =  0.66203703703704*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.098611111111111*arenaWidth,
				y =  0.64814814814815*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	7
			{ 
				x = 0.32430555555556*arenaWidth,
				y =  0.23333333333333*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.70277777777778*arenaWidth,
				y =  0.23518518518519*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.71527777777778*arenaWidth,
				y =  0.69259259259259*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.31458333333333*arenaWidth,
				y =  0.6962962962963*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.3125*arenaWidth,
				y =  0.47222222222222*arenaHeight,
				team =  3,
				population =  10,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.72083333333333*arenaWidth,
				y =  0.47962962962963*arenaHeight,
				team =  3,
				population =  10,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.51597222222222*arenaWidth,
				y =  0.22685185185185*arenaHeight,
				team =  3,
				population =  10,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.51041666666667*arenaWidth,
				y =  0.7*arenaHeight,
				team =  3,
				population =  10,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.5125*arenaWidth,
				y =  0.46944444444444*arenaHeight,
				team =  4,
				population =  60,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	8
			{ 
				x = 0.15277777777778*arenaWidth,
				y =  0.77685185185185*arenaHeight,
				team =  2,
				population =  70,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.32569444444444*arenaWidth,
				y =  0.65*arenaHeight,
				team =  1,
				population =  0,
				tier =  1,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 10,
				neutralTeam =  2
			},
			{ 
				x = 0.39166666666667*arenaWidth,
				y =  0.34907407407407*arenaHeight,
				team =  1,
				population =  0,
				tier =  1,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 10,
				neutralTeam =  2
			},
			{ 
				x = 0.56458333333333*arenaWidth,
				y =  0.69166666666667*arenaHeight,
				team =  1,
				population =  0,
				tier =  1,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 10,
				neutralTeam =  2
			},
			{ 
				x = 0.60972222222222*arenaWidth,
				y =  0.40277777777778*arenaHeight,
				team =  1,
				population =  0,
				tier =  1,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 10,
				neutralTeam =  2
			},
			{ 
				x = 0.83263888888889*arenaWidth,
				y =  0.19537037037037*arenaHeight,
				team =  3,
				population =  50,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 59,
				neutralTeam =  1
			}	
		},
		{	--level	9
			{ 
				x = 0.525*arenaWidth,
				y =  0.51*arenaHeight,
				team =  1,
				population =  0,
				tier =  6,
				regenTimer = 5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 200,
				neutralTeam =  1
			},
			{ 
				x = 0.81*arenaWidth,
				y =  0.51*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 200,
				neutralTeam =  1
			},
			{ 
				x = 0.24*arenaWidth,
				y =  0.51*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.7*arenaWidth,
				y =  0.74*arenaHeight,
				team =  5,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.35*arenaWidth,
				y =  0.28*arenaHeight,
				team =  5,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.35*arenaWidth,
				y =  0.74*arenaHeight,
				team =  5,
				population =  50,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.7*arenaWidth,
				y =  0.28*arenaHeight,
				team =  5,
				population =  50,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.525*arenaWidth,
				y =  0.17*arenaHeight,
				team =  2,
				population =  50,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.525*arenaWidth,
				y =  0.83*arenaHeight,
				team =  2,
				population =  50,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	10
			{ 
				x = 0.18*arenaWidth,
				y =  0.685*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.395*arenaWidth,
				y =  0.685*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.596*arenaWidth,
				y =  0.685*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.798*arenaWidth,
				y =  0.685*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.798*arenaWidth,
				y =  0.33*arenaHeight,
				team =  3,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.596*arenaWidth,
				y =  0.33*arenaHeight,
				team =  3,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.395*arenaWidth,
				y =  0.33*arenaHeight,
				team =  3,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.18*arenaWidth,
				y =  0.33*arenaHeight,
				team =  3,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	11
			{ 
				x = 0.75*arenaWidth,
				y =  0.22*arenaHeight,
				team =  4,
				population =  80,
				tier =  4,
				regenTimer = 3, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.75*arenaWidth,
				y =  0.78*arenaHeight,
				team =  5,
				population =  80,
				tier =  4,
				regenTimer = 3, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.50*arenaWidth,
				y =  0.50*arenaHeight,
				team =  1,
				population =  0,
				tier =  4,
				regenTimer = 3, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 80,
				neutralTeam =  1
			},
			{ 
				x = 0.25*arenaWidth,
				y =  0.22*arenaHeight,
				team =  2,
				population =  80,
				tier =  4,
				regenTimer = 3, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 80,
				neutralTeam =  1
			},
			{ 
				x = 0.25*arenaWidth,
				y =  0.78*arenaHeight,
				team =  3,
				population =  80,
				tier =  4,
				regenTimer = 3, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		}
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
				startX = 0.40486111111111*arenaWidth,
				startY =  0.89166666666667*arenaHeight,
				endX = 0.32291666666667*arenaWidth,
				endY =  0.62962962962963*arenaHeight 
			},
			{ 
				startX = 0.40694444444444*arenaWidth,
				startY =  0.4462962962963*arenaHeight,
				endX = 0.325*arenaWidth,
				endY =  0.61203703703704*arenaHeight 
			},
			{ 
				startX = 0.53888888888889*arenaWidth,
				startY =  0.4287037037037*arenaHeight,
				endX = 0.41805555555556*arenaWidth,
				endY =  0.44907407407407*arenaHeight 
			}
		},
		{ -- level 4
		},
		{ -- level 5
		},
		{	--level	6
			{ 
				startX = 0.19166666666667*arenaWidth,
				startY =  0.83055555555556*arenaHeight,
				endX = 0.23125*arenaWidth,
				endY =  0.63888888888889*arenaHeight 
			},
			{ 
				startX = 0.37916666666667*arenaWidth,
				startY =  0.60925925925926*arenaHeight,
				endX = 0.47916666666667*arenaWidth,
				endY =  0.48240740740741*arenaHeight 
			},
			{ 
				startX = 0.48194444444444*arenaWidth,
				startY =  0.26111111111111*arenaHeight,
				endX = 0.48402777777778*arenaWidth,
				endY =  0.46944444444444*arenaHeight 
			},
			{ 
				startX = 0.60347222222222*arenaWidth,
				startY =  0.6*arenaHeight,
				endX = 0.48958333333333*arenaWidth,
				endY =  0.47777777777778*arenaHeight 
			},
			{ 
				startX = 0.79652777777778*arenaWidth,
				startY =  0.83333333333333*arenaHeight,
				endX = 0.75763888888889*arenaWidth,
				endY =  0.63518518518519*arenaHeight 
			},
		},
		{ -- level 7
		},
		{ -- level 8
		},
		{	--level	9
			{ 
				startX = 0.64375*arenaWidth,
				startY =  0.44*arenaHeight,
				endX = 0.64375*arenaWidth,
				endY =  0.5722*arenaHeight 
			},
			{ 
				startX = 0.402*arenaWidth,
				startY =  0.44*arenaHeight,
				endX = 0.402*arenaWidth,
				endY =  0.5722*arenaHeight 
			},
			{ 
				startX = 0.5618*arenaWidth,
				startY =  0.66666666666667*arenaHeight,
				endX = 0.479*arenaWidth,
				endY =  0.66666666666667*arenaHeight 
			},
			{ 
				startX = 0.5618*arenaWidth,
				startY =  0.35*arenaHeight,
				endX = 0.479*arenaWidth,
				endY =  0.35*arenaHeight 
			},
		},
		{ -- level 10
		},
		{ -- level 11
		},
	}
end




































