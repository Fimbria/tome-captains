newEffect{
	name = "CAPTAIN_FURY", image = "talents/captain_fury.png",
	desc = "Captain Fury",
	long_desc = function(self, eff) return ("500% more damage.") end,
	type = "physical",
	subtype = { captain=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return "#Target# is furious.", "+Captain Fury" end,
	on_lose = function(self, err) return "#Target# is less furious.", "-Captain Fury" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}

newEffect{
	name = "DIPLOMATIC_IMMUNITY", image = "talents/diplomatic_immunity.png",
	desc = "Diplomatic Immunity",
	long_desc = function(self, eff) return ("Invulnerable.") end,
	type = "physical",
	subtype = { captain=true },
	status = "beneficial",
	parameters = { },
	on_gain = function(self, err) return "#Target# is furious.", "+Diplomatic Immunity" end,
	on_lose = function(self, err) return "#Target# is less furious.", "-Diplomatic Immunity" end,
	activate = function(self, eff)
	end,
	deactivate = function(self, eff)
	end,
}
