local class = require"engine.class"
local ActorTalents = require "engine.interface.ActorTalents"
local ActorTemporaryEffects = require "engine.interface.ActorTemporaryEffects"
local DamageTypes = require "engine.DamageType"
local Birther = require "engine.Birther"


class:bindHook("ToME:load", function(self, data)
	ActorTalents:loadDefinition("/data-captains/talents/captain.lua")
	ActorTemporaryEffects:loadDefinition("/data-captains/timed_effects.lua")
	DamageTypes:loadDefinition("/data-captains/damage_types.lua")
	Birther:loadDefinition("/data-captains/birth/captain.lua")
	
end)
--[[class:bindHook("Entity:loadList", function(self, data)
	if data.file == "/data/general/objects/quest-artifacts.lua" then
	self:loadList("/data-captains/test.lua", data.no_default, data.res, data.mod, data.loaded)
	end
end)
class:bindHook("Actor:takeHit", function(self, data)
	if self:hasEffect(self.EFF_DIPLOMATIC_IMMUNITY) then data.value = 0 return true end
end)

class:bindHook("DamageProjector:base", function(self, data)
	if self:hasEffect(self.EFF_CAPTAIN_FURY) then data.dam = data.dam * 5 return true end
end)]]--
