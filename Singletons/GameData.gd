extends Node
#path to GameScene
var GameScene_Path

var enemy_data={
	1 : {
		"name"   :	"BlueTank",
		"health" :	1,
		"damage" :	1,
		"speed"  :	50,
		"scale"  :	1,
		"money"  :	1,
		"color"  :	"5b8cff"
	},
	2 : {
		"name"   :	"RedTank",
		"health" :	1,
		"damage" :	2,
		"speed"  :	75,
		"scale"  :	1.2,
		"money"  :	1,
		"color"  :	"f42828"
	},
		3 : {
		"name"   :	"YellowTank",
		"health" :	1,
		"damage" :	3,
		"speed"  :	100,
		"scale"  :	1.5,
		"money"  :	1,
		"color"  :	"faff5b"
	},
			4 : {
		"name"   :	"OrangeTank",
		"health" :	1,
		"damage" :	4,
		"speed"  :	125,
		"scale"  :	1.75,
		"money"  :	1,
		"color"  :	"fc8803"
	},
			5 : {
		"name"   :	"WhiteTank",
		"health" :	1,
		"damage" :	5,
		"speed"  :	155,
		"scale"  :	0.5,
		"money"  :	1,
		"color"  :	"ede9e4"
	},
}

var tower_data={
	"Gun" : {
		"damage" : 1,
		"rate_of_fire"   : 2,
		"range"  : 1.5,
		"category" : "instant",
		"price" : 100,
	},
	"Laser":{
		"damage" : 2,
		"rate_of_fire"   : 1,
		"range"  : 2.0,
		"category" : "projectile",
		"price" : 200,
		"shotspeed" : 400,
		"pierce" : 2,
		"projectile": "ProjectileLaser",
	}
	
	
}
# [NameOfEnemy,Tier of enemy, time between next enemy, amount of enemies]
var wave_data = {
	1:[["TieredEnemy",1,1,30],],
	
	2:[["TieredEnemy",1,1,15],["TieredEnemy",1,0.5,15]],
	
	3:[["TieredEnemy",2,1,15],["TieredEnemy",2,0.5,15],["TieredEnemy",3,1.5,10]],
	
	4:[["TieredEnemy",3,0.2,15],["TieredEnemy",4,0.1,10]],
}
