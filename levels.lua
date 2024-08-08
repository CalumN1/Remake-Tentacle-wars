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
				tier =  1,
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
				tier =  1,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.31319444444444*arenaWidth,
				y =  0.74351851851852*arenaHeight,
				team =  1,
				population =  0,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 10,
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
				neutralTeam =  1
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
		},
		{	--level	12
			{ 
				x = 0.65*arenaWidth,
				y =  0.275*arenaHeight,
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
				x = 0.65*arenaWidth,
				y =  0.475*arenaHeight,
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
				x = 0.65*arenaWidth,
				y =  0.675*arenaHeight,
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
				x = 0.44236111111111*arenaWidth,
				y =  0.475*arenaHeight,
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
				x = 0.278*arenaWidth,
				y =  0.295*arenaHeight,
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
				x = 0.278*arenaWidth,
				y =  0.655*arenaHeight,
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
		{	--level	13
			{ 
				x = 0.11458333333333*arenaWidth,
				y =  0.28518518518519*arenaHeight,
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
				x = 0.10972222222222*arenaWidth,
				y =  0.71296296296296*arenaHeight,
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
				x = 0.18541666666667*arenaWidth,
				y =  0.49814814814815*arenaHeight,
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
				x = 0.70902777777778*arenaWidth,
				y =  0.51388888888889*arenaHeight,
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
				x = 0.85069444444444*arenaWidth,
				y =  0.3*arenaHeight,
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
				x = 0.63333333333333*arenaWidth,
				y =  0.18611111111111*arenaHeight,
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
				x = 0.62777777777778*arenaWidth,
				y =  0.80925925925926*arenaHeight,
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
				x = 0.86041666666667*arenaWidth,
				y =  0.71944444444444*arenaHeight,
				team =  5,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	14
			{ 
				x = 0.49027777777778*arenaWidth,
				y =  0.23425925925926*arenaHeight,
				team =  5,
				population =  60,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.67222222222222*arenaWidth,
				y =  0.61018518518519*arenaHeight,
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
				x = 0.31736111111111*arenaWidth,
				y =  0.61296296296296*arenaHeight,
				team =  3,
				population =  60,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.24930555555556*arenaWidth,
				y =  0.26203703703704*arenaHeight,
				team =  3,
				population =  10,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.7625*arenaWidth,
				y =  0.27222222222222*arenaHeight,
				team =  5,
				population =  10,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.50486111111111*arenaWidth,
				y =  0.85833333333333*arenaHeight,
				team =  2,
				population =  10,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	15
			{ 
				x = 0.25277777777778*arenaWidth,
				y =  0.569*arenaHeight,
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
				x = 0.31458333333333*arenaWidth,
				y =  0.30462962962963*arenaHeight,
				team =  4,
				population =  50,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.65486111111111*arenaWidth,
				y =  0.815*arenaHeight,
				team =  1,
				population =  0,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 50,
				neutralTeam =  1
			},
			{ 
				x = 0.76111111111111*arenaWidth,
				y =  0.31574074074074*arenaHeight,
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
				x = 0.52847222222222*arenaWidth,
				y =  0.1712962962963*arenaHeight,
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
				x = 0.78333333333333*arenaWidth,
				y =  0.569*arenaHeight,
				team =  4,
				population =  10,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.39791666666667*arenaWidth,
				y =  0.815*arenaHeight,
				team =  3,
				population =  10,
				tier =  1,
				regenTimer = 2, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 0,
				neutralTeam =  1
			}	
		},
		{	--level	16
			{ 
				x = 0.13*arenaWidth,
				y =  0.31*arenaHeight,
				team =  2,
				population =  30,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 50,
				neutralTeam =  1
			},
			{ 
				x = 0.89*arenaWidth,
				y =  0.31*arenaHeight,
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
				x = 0.51*arenaWidth,
				y =  0.31*arenaHeight,
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
				x = 0.51*arenaWidth,
				y =  0.71388888888889*arenaHeight,
				team =  2,
				population =  100,
				tier =  4,
				regenTimer = 3, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.82*arenaWidth,
				y =  0.65555555555556*arenaHeight,
				team =  5,
				population =  70,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.20*arenaWidth,
				y =  0.65555555555556*arenaHeight,
				team =  5,
				population =  70,
				tier =  3,
				regenTimer = 2.5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	17
			{ 
				x = 0.31*arenaWidth,
				y =  0.168*arenaHeight,
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
				x = 0.31*arenaWidth,
				y =  0.37*arenaHeight,
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
				x = 0.113*arenaWidth,
				y =  0.168*arenaHeight,
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
				x = 0.496*arenaWidth,
				y =  0.168*arenaHeight,
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
				x = 0.872*arenaWidth,
				y =  0.168*arenaHeight,
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
				x = 0.688*arenaWidth,
				y =  0.168*arenaHeight,
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
				x = 0.688*arenaWidth,
				y =  0.37*arenaHeight,
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
				x = 0.496*arenaWidth,
				y =  0.37*arenaHeight,
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
				x = 0.872*arenaWidth,
				y =  0.37*arenaHeight,
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
				x = 0.113*arenaWidth,
				y =  0.37*arenaHeight,
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
				x = 0.688*arenaWidth,
				y =  0.596*arenaHeight,
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
				x = 0.31*arenaWidth,
				y =  0.596*arenaHeight,
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
				x = 0.496*arenaWidth,
				y =  0.596*arenaHeight,
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
				x = 0.872*arenaWidth,
				y =  0.596*arenaHeight,
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
				x = 0.113*arenaWidth,
				y =  0.596*arenaHeight,
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
				x = 0.31*arenaWidth,
				y =  0.822*arenaHeight,
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
				x = 0.688*arenaWidth,
				y =  0.822*arenaHeight,
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
				x = 0.872*arenaWidth,
				y =  0.822*arenaHeight,
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
				x = 0.496*arenaWidth,
				y =  0.822*arenaHeight,
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
				x = 0.113*arenaWidth,
				y =  0.822*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			}	
		},
		{	--level	18
			{ 
				x = 0.86111111111111*arenaWidth,
				y =  0.18333333333333*arenaHeight,
				team =  5,
				population =  160,
				tier =  6,
				regenTimer = 5, 
				tentaclesUsed = 0,
				effectTimer = 0,
				neutralPower = 30,
				neutralTeam =  1
			},
			{ 
				x = 0.29305555555556*arenaWidth,
				y =  0.57407407407407*arenaHeight,
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
				x = 0.50208333333333*arenaWidth,
				y =  0.73148148148148*arenaHeight,
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
				x = 0.33402777777778*arenaWidth,
				y =  0.85462962962963*arenaHeight,
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
				x = 0.15555555555556*arenaWidth,
				y =  0.79074074074074*arenaHeight,
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
				x = 0.088888888888889*arenaWidth,
				y =  0.56574074074074*arenaHeight,
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
				x = 0.13263888888889*arenaWidth,
				y =  0.3462962962963*arenaHeight,
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
				x = 0.29861111111111*arenaWidth,
				y =  0.28148148148148*arenaHeight,
				team =  2,
				population =  20,
				tier =  2,
				regenTimer = 2.4, 
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
		{ -- level 12
		},
		{ -- level 13
		},
		{	--level	14
			{ 
				startX = 0.65277777777778*arenaWidth,
				startY =  0.35277777777778*arenaHeight,
				endX = 0.50902777777778*arenaWidth,
				endY =  0.47037037037037*arenaHeight 
			},
			{ 
				startX = 0.50069444444444*arenaWidth,
				startY =  0.48888888888889*arenaHeight,
				endX = 0.49791666666667*arenaWidth,
				endY =  0.71203703703704*arenaHeight 
			},
			{ 
				startX = 0.36666666666667*arenaWidth,
				startY =  0.35648148148148*arenaHeight,
				endX = 0.49305555555556*arenaWidth,
				endY =  0.46944444444444*arenaHeight 
			},
		},
		{ -- level 15
		},
		{	--level	16
			{ 
				startX = 0.99*arenaWidth,
				startY =  0.17*arenaHeight,
				endX = 0.73*arenaWidth,
				endY =  0.17*arenaHeight 
			},
			{ 
				startX = 0.75*arenaWidth,
				startY =  0.39*arenaHeight,
				endX = 0.72*arenaWidth,
				endY =  0.2*arenaHeight 
			},
			{ 
				startX = 0.635*arenaWidth,
				startY =  0.837*arenaHeight,
				endX = 0.58*arenaWidth,
				endY =  0.59*arenaHeight 
			},
			{ 
				startX = 0.385*arenaWidth,
				startY =  0.837*arenaHeight,
				endX = 0.44*arenaWidth,
				endY =  0.59*arenaHeight 
			},
			{ 
				startX = 0.4*arenaWidth,
				startY =  0.855*arenaHeight,
				endX = 0.62*arenaWidth,
				endY =  0.855*arenaHeight 
			},
			{ 
				startX = 0.29*arenaWidth,
				startY =  0.17*arenaHeight,
				endX = 0.01*arenaWidth,
				endY =  0.17*arenaHeight 
			},
			{ 
				startX = 0.30*arenaWidth,
				startY =  0.2*arenaHeight,
				endX = 0.27*arenaWidth,
				endY =  0.39*arenaHeight 
			}	
		},
		{ -- level 17
		},
		{ -- level 18
		},

	}
end


function levelPowerLimits()
	return
	{
		60, -- level 1
		60, 
		100, --3
		100,
		100, -- 5
		60,
		80, --7
		80,
		200, --9
		100, --10
		200, 
		100, --12
		150,
		60, --14
		100,
		100, --16
		50,
		160, --18
		80,
		100 --20
	}
end


































