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
		"health" :	70,
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
		"price" : 200
	}
	
	
}

var wave_data = {
	1:[["TieredEnemy",10,1],["TieredEnemy",10,2],["TieredEnemy",10,3],],
	2:[["TieredEnemy",10,1],["TieredEnemy",10,2],["TieredEnemy",10,3],],
	3:[["TieredEnemy",10,1],["TieredEnemy",10,2],["TieredEnemy",10,3],],
	
	
	10 : [
		["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],
		["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],
		["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],
	]
	,
	12 : [
		["BlueTank", 0.5],["BlueTank", 0.4],["BlueTank", 0.3],["BlueTank", 0.2],["BlueTank", 5],
		["RedTank", 1],["RedTank", 0.5],["RedTank", 4],["RedTank", 0.3],["RedTank", 0.3],["RedTank", 0.3]
		]
	,
	13 : [
		["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],
		["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],
		["BlueTank", 0.1],["BlueTank", 0.1],["RedTank", 0.1],["BlueTank", 3],["RedTank", 0.1],
		["BlueTank", 1],["RedTank", 0.1],["BlueTank", 1],["RedTank", 0.1],["BlueTank", 0.1],
		["BlueTank", 1],["RedTank", 0.1],["RedTank", 1],["RedTank", 0.1],["RedTank", 0.1],
	]
	,
	14 : [
		["BlueTank", 1],["RedTank", 2],["RedTank", 0.1],["RedTank", 5],["GreenTank", 2]
		]
	,
	
	
}
