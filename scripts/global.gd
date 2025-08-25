class_name Global

enum Type { 
	BUG, 
	DARK, 
	DRAGON, 
	ELECTRIC, 
	FAIRY, 
	FIGHTING, 
	FIRE, 
	FLYING, 
	GHOST, 
	GRASS, 
	GROUND, 
	ICE, 
	NORMAL, 
	POISON, 
	PSYCHIC, 
	STEEL, 
	ROCK, 
	WATER,
	NONE,
}

# type_chart[ATTACKING_TYPE][DEFENDING_TYPE]
var type_chart: Dictionary = {
	Type.BUG: {
		Type.FIRE: 0.5,
		Type.GRASS: 2,
		Type.FIGHTING: 0.5,
		Type.POISON: 0.5,
		Type.FLYING: 0.5,
		Type.GHOST: 0.5,
		Type.DARK: 2,
		Type.STEEL: 0.5,
		Type.FAIRY: 0.5
	},
	Type.DARK: {
		Type.FIGHTING: 0.5,
		Type.PSYCHIC: 2,
		Type.GHOST: 2,
		Type.DARK: 0.5,
		Type.FAIRY: 0.5
	},
	Type.DRAGON: {
		Type.DRAGON: 2,
		Type.STEEL: 0.5,
		Type.FAIRY: 0
	},
	Type.ELECTRIC: {
		Type.WATER: 2,
		Type.GRASS: 0.5,
		Type.ELECTRIC: 0.5,
		Type.GROUND: 0,
		Type.FLYING: 2,
		Type.DRAGON: 0.5
	},
	Type.FAIRY: {
		Type.FAIRY: 0.5,
		Type.FIGHTING: 2,
		Type.POISON: 0.5,
		Type.DRAGON: 2,
		Type.DARK: 2,
		Type.STEEL: 0.5
	},
	Type.FIGHTING: {
		Type.NORMAL: 2,
		Type.ICE: 2,
		Type.POISON: 0.5,
		Type.FLYING: 0.5,
		Type.PSYCHIC: 0.5,
		Type.BUG: 0.5,
		Type.ROCK: 2,
		Type.GHOST: 0,
		Type.DARK: 2,
		Type.STEEL: 2,
		Type.FAIRY: 0.5
	},
	Type.FIRE: {
		Type.FIRE: 0.5,
		Type.WATER: 0.5,
		Type.GRASS: 2,
		Type.ICE: 2,
		Type.BUG: 2,
		Type.ROCK: 0.5,
		Type.DRAGON: 0.5,
		Type.STEEL: 2
	},
	Type.FLYING:{
		Type.GRASS: 2,
		Type.ELECTRIC: 0.5,
		Type.FIGHTING: 2,
		Type.BUG: 2,
		Type.ROCK: 0.5,
		Type.STEEL: 0.5
	},
	Type.GHOST:{
		Type.NORMAL: 0,
		Type.PSYCHIC: 2,
		Type.GHOST: 2,
		Type.DARK: 0.5
	},
	Type.GRASS: {
		Type.FIRE: 0.5,
		Type.WATER: 2,
		Type.GRASS: 0.5,
		Type.POISON: 0.5,
		Type.GROUND: 2,
		Type.BUG: 0.5,
		Type.ROCK: 2,
		Type.DRAGON: 0.5,
		Type.STEEL: 0.5
	},
	Type.GROUND: {
		Type.FIRE: 2,
		Type.GRASS: 0.5,
		Type.ELECTRIC: 2,
		Type.POISON: 2,
		Type.FLYING: 0,
		Type.BUG: 0.5,
		Type.ROCK: 2,
		Type.STEEL: 2
	},
	Type.ICE: {
		Type.FIRE: 0.5,
		Type.WATER: 0.5,
		Type.GRASS: 2,
		Type.ICE: 0.5,
		Type.GROUND: 2,
		Type.FLYING: 2,
		Type.DRAGON: 2,
		Type.STEEL: 0.5
	},
	Type.NORMAL: {
		Type.ROCK: 0.5,
		Type.GHOST: 0,
		Type.STEEL: 0.5
	},
	Type.POISON: {
		Type.GRASS: 2,
		Type.POISON: 0.5,
		Type.GROUND: 0.5,
		Type.ROCK: 0.5,
		Type.GHOST: 0.5,
		Type.STEEL: 0,
		Type.FAIRY: 2
	},
	Type.PSYCHIC: {
		Type.FIGHTING: 2,
		Type.POISON: 2,
		Type.PSYCHIC: 0.5,
		Type.DARK: 0,
		Type.STEEL: 0.5
	},
	Type.STEEL: {
		Type.FIRE: 0.5,
		Type.WATER: 0.5,
		Type.ELECTRIC: 0.5,
		Type.ICE: 2,
		Type.ROCK: 2,
		Type.STEEL: 0.5,
		Type.FAIRY: 2
	},
	Type.ROCK: {
		Type.FIRE: 2,
		Type.ICE: 2,
		Type.FIGHTING: 0.5,
		Type.GROUND: 0.5,
		Type.FLYING: 2,
		Type.BUG: 2,
		Type.STEEL: 0.5
	},
	Type.WATER: {
		Type.FIRE: 2,
		Type.WATER: 0.5,
		Type.GRASS: 0.5,
		Type.GROUND: 2,
		Type.ROCK: 2,
		Type.DRAGON: 0.5
	}
}
