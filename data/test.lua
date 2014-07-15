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

newEntity{
	define_as = "BASE_TEST",
	slot = "MAINHAND", dual_wieldable = true,
	type = "weapon", subtype="test",
	add_name = " (#COMBAT#)",
	display = "/", color=colors.SLATE, image = resolvers.image_material("axe", "metal"),
	moddable_tile = resolvers.moddable_tile("axe"),
	encumber = 3,
	rarity = 3,
	metallic = true,
	combat = { talented = "axe", damrange = 1.4, physspeed = 1, sound = {"actions/melee", pitch=0.6, vol=1.2}, sound_miss = {"actions/melee", pitch=0.6, vol=1.2}},
	desc = [[One-handed war axes.]],
	randart_able = { attack=40, physical=80, spell=20, def=10, misc=10 },
	egos = "/data/general/objects/egos/weapon.lua", egos_chance = { prefix=resolvers.mbonus(40, 5), suffix=resolvers.mbonus(40, 5) },
}

newEntity{ base = "BASE_TEST",
	name = "test", short_name = "iron",
	level_range = {1, 10},
	require = { stat = { str=11 }, },
	cost = 5,
	material_level = 1,
	combat = {
		dam = resolvers.rngavg(10,30),
		apr = 2,
		physcrit = 33.5,
		dammod = {str=5},
	},
}
