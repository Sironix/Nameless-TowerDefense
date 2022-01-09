extends Node
#path to GameScene
var GameScene_Path

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
	1 : [
		["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],
		["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],
		["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],["BlueTank", 1],
	]
	,
	2 : [
		["BlueTank", 0.5],["BlueTank", 0.4],["BlueTank", 0.3],["BlueTank", 0.2],["BlueTank", 5],
		["RedTank", 1],["RedTank", 0.5],["RedTank", 4],["RedTank", 0.3],["RedTank", 0.3],["RedTank", 0.3]
		]
	,
	3 : [
		["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],
		["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],["BlueTank", 0.1],
		["BlueTank", 0.1],["BlueTank", 0.1],["RedTank", 0.1],["BlueTank", 3],["RedTank", 0.1],
		["BlueTank", 1],["RedTank", 0.1],["BlueTank", 1],["RedTank", 0.1],["BlueTank", 0.1],
		["BlueTank", 1],["RedTank", 0.1],["RedTank", 1],["RedTank", 0.1],["RedTank", 0.1],
	]
	,
	4 : [
		["BlueTank", 1],["RedTank", 2],["RedTank", 0.1],["RedTank", 5],["GreenTank", 2]
		]
	,
	
	
}
