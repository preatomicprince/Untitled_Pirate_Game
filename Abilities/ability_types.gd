class_name Ability_Types extends Node

enum {
	None = 0, 
	Silk_Sails, # +Speed
	Ornate_Cannons, # +Strength
	Munitions_Training, # +Fire-rate
	Grappling_Hooks, # +Boarding speed
	#Fireshot, #1.25x damage. Damage over time
	Grapeshot, #+25% dam against towns, -25% dam against ships
	Artillery, #+25% dam to ships, -25% dam against towns
	#Chainshot, #-25% damage, 10% chance to immobilise
	#Charismatic_Captain, #Restore 10hp when capturing enemy ship
	#Mouser, # Cat
	#Bribes	#Start with -50 gold, infamy increases 5% slower 
}
