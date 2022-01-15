extends Node
#path to GameScene
var GameScene_Path

var enemy_data={
	1 : {
		"name"   :	"BlueTank",
		"health" :	20,
		"damage" :	1,
		"speed"  :	50,
		"scale"  :	1,
		"money"  :	100,
		"color"  :	"5b8cff"
	},
	2 : {
		"name"   :	"RedTank",
		"health" :	30,
		"damage" :	25,
		"speed"  :	75,
		"scale"  :	1.2,
		"money"  :	25,
		"color"  :	"f42828"
	},
		3 : {
		"name"   :	"YellowTank",
		"health" :	69,
		"damage" :	25,
		"speed"  :	15,
		"scale"  :	1.5,
		"money"  :	25,
		"color"  :	"faff5b"
	}
	
}

var tower_data={
	"GunTier1" : {
		"damage" : 1,
		"rate"   : 0.2,
		"range"  : 1.5,
		"category" : "instant",
		"price" : 100,
	},
	"MissileTier1":{
		"damage" : 5,
		"rate"   : 1,
		"range"  : 2.0,
		"category" : "projectile",
		"price" : 200,
		"shotspeed" : 400,
		"pierce" : 2,
		"projectile": "ProjectileMissile",
	}
	
	
}
# [NameOfEnemy,Tier of enemy, time between next enemy, amount of enemies]
var wave_data = {
	1:[["TieredEnemy",1,3,2],["TieredEnemy",2,3],["TieredEnemy",3,3],],
	
	2:[["TieredEnemy",3,1],["TieredEnemy",2,0.1],["TieredEnemy",2,0.1],["TieredEnemy",2,0.1,4],],
}
