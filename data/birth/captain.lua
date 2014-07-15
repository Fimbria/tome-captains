-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

newBirthDescriptor{
	type = "class",
	name = "Captain",
	desc = {
		"Captains like to command things.",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Captain = "allow",
		},
	},
	copy = {
		max_life = 100,
	},
}

newBirthDescriptor{
	innate_squad = true,
	resolvers.generic(function(self)self:birth_summon() end),
	birth_summon = function(self)
		local t= self:getTalentFromId(self.T_RECRUIT)
		t.recruit_soldier(self,t)
	end,
	type = "subclass",
	name = "Captain",
	desc = {
		"From the inspiring commanders of King Toknor's armies, to the thug in a bandit camp who shouts the loudest, leaders everywhere have united people in the pursuit of a common cause.",
		"Captains are warriors who lead small groups of soldiers into battle.",
		"Many of the Captain's skills focus on supporting their units, although they are capable of wielding a weapon themselves.",
		"A Captain's abiity to lead hinges on the morale of the party. Successful Captains must keep morale high.",
		"The Captain's main stats are Strength, Will, and Cunning.",
		"#GOLD#Stat modifiers:",
		"#LIGHT_BLUE# * +3 Strength, +0 Dexterity, +0 Constitution",
		"#LIGHT_BLUE# * +0 Magic, +3 Willpower, +3 Cunning",
		"#GOLD#Life per level:#LIGHT_BLUE# +2",
	},
	stats = {str = 3, wil = 3, cun = 3},
	talents_types = {
		["cunning/captain"]={true, 0},
		["technique/archery-bow"]={true, 0.3},
--		["technique/archery-training"]={false, 0.1},
		["technique/shield-offense"]={true, 0.3},
--		["technique/dualweapon-training"]={true, 0.3},
--		["technique/2hweapon-cripple"]={true, 0.1},
		["technique/combat-techniques-active"]={true, 0.3},
		["technique/combat-techniques-passive"]={true, 0.3},
		["technique/combat-training"]={true, 0.3},
		["technique/field-control"]={true, 0.3},
		["technique/combat-veteran"]={true, 0.1},
		["cunning/survival"]={false, 0},
		--["leadership/command"]={true, 0},
		--["leadership/presence"]={false, 0},
		--["leadership/teamwork"]={true, 0},
		--["technique/support"]={true, 0},
	},
	talents = {
		T_ARMOUR_TRAINING = 2,
		T_WEAPON_COMBAT = 1,
		T_RECRUIT = 3,
		T_SWARM = 5,
		T_MARK = 3,
	},
	copy = {
		resolvers.equip{ id=true,
			{type="weapon", subtype="longsword", name="iron longsword", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="shield", name="iron shield", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", autoreq=true, ego_chance=-1000, ego_chance=-1000},
		},
	},
	copy_add = {
		life_rating = 2,
	},
}

-- Allow it in Maj'Eyal campaign
getBirthDescriptor("world", "Maj'Eyal").descriptor_choices.class.Captain = "allow"
