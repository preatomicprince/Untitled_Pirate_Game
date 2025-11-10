class_name Ability_Types extends Node

enum {
	None = 0, 
	Silk_Sails, # +Speed
	Ornate_Cannons, # +Strength
	Munitions_Training, # +Fire-rate
	Grappling_Hooks, # +Boarding speed
	Fireshot, #0.75 base damage. Sets on fire (1 dam per sec for 5 secs)
	Grapeshot, #+25% dam against towns, -25% dam against ships
	Artillery, #+25% dam to ships, -25% dam against towns
	Chainshot, #-25% damage, +10% crit chance
	Charismatic_Captain, #Restore 10hp when capturing enemy ship
	#Mouser, # Cat
	MAX
}
