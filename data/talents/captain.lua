newTalentType{ allow_random=true, type="cunning/captain", name = "captain", description = "captain things" }

captains_req1 = {
	stat = { wil=function(level) return 12 + (level-1) * 2 end },
	level = function(level) return 0 + (level-1)  end,
}
captains_req2 = {
	stat = { wil=function(level) return 20 + (level-1) * 2 end },
	level = function(level) return 4 + (level-1)  end,
}
captains_req3 = {
	stat = { wil=function(level) return 28 + (level-1) * 2 end },
	level = function(level) return 8 + (level-1)  end,
}
captains_req4 = {
	stat = { wil=function(level) return 36 + (level-1) * 2 end },
	level = function(level) return 12 + (level-1)  end,
}

local function makeSoldier(self)
	self:attr("summoned_times", 100)
	local g = require("mod.class.NPC").new{
		type = "humanoid", subtype = "human",
		display = '@', color=colors.BLUE, image = "npc/humanoid_human_townsfolk_pitiful_looking_beggar01_64.png",
		moddable_tile = "golem",
		moddable_tile_nude = 1,
		moddable_tile_base = resolvers.generic(function() return "base_0"..rng.range(1, 5)..".png" end),
		level_range = {self.level, self.level}, exp_worth=0,
		life_rating = 0,
		never_anger = true,
		combat = { dam=10, atk=10, apr=0, dammod={str=1} },
		body = { INVEN = 10, MAINHAND = 1, OFFHAND = 1, FINGER = 2, NECK = 1, LITE = 1, BODY = 1, HEAD = 1, CLOAK = 1, HANDS = 1, BELT = 1, FEET = 1},
		infravision = 10,
		rank = 3,
		size_category = 3,
		autolevel = "warrior",
		resolvers.talents{
			[Talents.T_ARMOUR_TRAINING]=3,
			[Talents.T_WEAPON_COMBAT]=1,
			[Talents.T_STAMINA_POOL]=1,
		},
		is_soldier = true,
		resolvers.equip{ id=true,
			{type="weapon", subtype="battleaxe", autoreq=true, id=true, ego_chance=75},
			{type="armor", subtype="heavy", autoreq=true, id=true, ego_chance=75},
			{type="armor", subtype="head", ego_chance=75, autoreq=true},
			{type="armor", subtype="feet", ego_chance=75, autoreq=true},
			{type="armor", subtype="cloak", ego_chance=75, autoreq=true},
			{type="jewelry", subtype="amulet", ego_chance=100, autoreq=true},
			{type="jewelry", subtype="ring", ego_chance=100, autoreq=true},
			{type="jewelry", subtype="ring", ego_chance=100, autoreq=true},
		},

		talents_types = {
			
		},
		talents_types_mastery = {
			["technique/combat-training"] = 0.3,

		},
		--resolvers.inscription("RUNE:_SHIELDING", {cooldown=14, dur=5, power=100}),
		--resolvers.inscriptions(3, "rune"),

		hotkey = {},
		hotkey_page = 1,
		move_others = true,

		ai = "tactical",
		ai_state = { talent_in=1, ai_move="move_astar", ally_compassion=10 },
		ai_tactic = resolvers.tactic"tank",
		stats = { str=14, dex=12, mag=12, con=12 },

		--unused_stats = 0,
		unused_talents = 0,
		unused_generics = 0,
		unused_talents_types = 0,

		open_door = false,
		
		can_change_level = true,
		--max_life = resolvers.rngavg(1,1),
		remove_from_party_on_death = true,
		
		ai_tactic = ai_tactic or {},
		--ai_tactic.escape = 0,
		
		--[[on_die = function(self)
			self:disappear()
		end,]]--
		
	}

	return g
end

newTalent{
	name = "Recruit",
	type = {"cunning/captain", 1},
--	autolearn_talent = "T_INTERACT_GOLEM", (Interact with crew)
	require = captains_req1,
	points = 5,
	random_ego = "summon",
	stamina = 20,
	cooldown = 10,
	--range = 10,
	requires_target = false,
	no_npc_use = true,
	no_unlearn_last = true,
	
	on_learn = function(self, t)
		self.max_squad = self:getTalentLevel(t)
	end,
	
	recruit_soldier = function(self, t)
		local merc_num = -1
		self.squad = self.squad or {}
		
		for i = 1,self.max_squad do
			if (not self.squad[i]) or self.squad[i].dead then
				merc_num = i
				break
			end
		end
		
		if merc_num == -1 then return end
		
		local new_merc = game.zone:finishEntity(game.level, "actor", makeSoldier(self))
		
		if not new_merc then 
			game.logPlayer(self, "Error : Could not create recruit.")
			return nil
		end
		
		new_merc.faction = self.faction
		new_merc.name = "Soldier (minion of "..self.name..")"
		new_merc.summoner = self
		new_merc.summoner_gain_exp = true

		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
		
		if not x then
			game.logPlayer(self, "Not enough space to recruit!")
			return nil
		end
		
		if game.party:hasMember(self) then
			game.party:addMember(new_merc, {
				type="human", title="Soldier",control = "full",
				orders = {target=true, leash=true, anchor=true, talents=true, behavior=true},
			})
		end
		
		self.squad[merc_num] = new_merc,
		
		game.zone:addEntity(game.level, new_merc, "actor", x, y)
	end,
	
	on_pre_use = function(self,t,silent)
		local cur_mercs = 0
		if not self.max_squad then self.max_squad = 0 end
		for i = 1, self.max_squad do
			if self.squad and self.squad[i] and not self.squad[i].dead then
				cur_mercs = cur_mercs + 1
			end
		end
		return (cur_mercs < self.max_squad)		
	end,
	
	action = function(self, t)
		t.recruit_soldier(self, t)
		return true
	end,
	info = function(self, t)
		return ([[Recruit up to %d soldiers.]]):
		format(math.floor(self:getTalentLevel(t)))
	end,
}

newTalent{
	name = "Swarm",
	type = {"cunning/captain", 2},
	require = captains_req2,
	points = 5,
	stamina = 8,
	cooldown = 10,
	--range = 100,
	--radius = function(self, t) return math.ceil(3 + self:getTalentLevel(t)) end,
	--requires_target = true,
	no_npc_use = true,
	swarmReq = function(self,t)
		if self:getTalentLevel(t) >= 5 then
			return 2
		end
		return 3
	end,
	damMultiplier = function(self,t)
		return self:combatTalentScale(t, .5, 2)
	end,
	action = function(self, t)
		if not self.squad then return nil end
		local enemies = {}
		local allies = {}
		for k,v in pairs(self.squad) do allies[k] = v end
		allies[0] = self
		for k,m in pairs(allies) do
			local grids = core.fov.circle_grids(m.x, m.y, 1, true)
			for x, yy in pairs(grids) do
				for y, _ in pairs(grids[x]) do
					local target = game.level.map(x, y, Map.ACTOR)
					if target and self:reactionToward(target) < 0 then
						contains = false
					
						for i,e in pairs(enemies) do
							if i and i == target then
									contains = true
								break
							end
						end
					
						if not contains then
							enemies[target] = {}
						end
					
						enemies[target][#enemies[target]+1] = m
					end
				end
			end
		end
		hitCount = 0
		for target,mercs in pairs(enemies) do
			if #mercs >= t.swarmReq(self,t) then
				for i,m in pairs(mercs) do
					--if not m == self then 
						m:attackTarget(target, nil, t.damMultiplier(self,t), true)
						hitCount = hitCount + 1
					--end
				end
			end
		end
		game.logPlayer(self, hitCount.." hits!")
		if hitCount == 0 then
			return nil
		end
		return true
	end,
	
	info = function(self, t)
		return ([[Each of your soldiers will attack each adjacent enemy at %d%% damage if there are at least %d soldiers adjacent to it.]]):
		format(t.damMultiplier(self,t)*100, t.swarmReq(self,t))
	end,
}

newTalent{
	name = "Mark",
	type = {"cunning/captain", 3},
	require = captains_req3,
	points = 5,
	stamina = 8,
	cooldown = 1,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	damMultiplier = function(self,t) return self:combatTalentScale(t, .5, 2) end,
	requires_target = true,
	no_npc_use = true,
	action = function(self, t)
		local allies = {}
		for k,v in pairs(self.squad) do allies[k] = v end
		allies[0] = self
	
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)	
		local target = game.level.map(x, y, Map.ACTOR)
		local hitCount = 0
		if not x or not y or not target then return nil end
		local grids = core.fov.circle_grids(x, y, 1, true)
		for x, yy in pairs(grids) do
			for y, _ in pairs(grids[x]) do
				local ally = game.level.map(x, y, Map.ACTOR)
				if ally and target then 
					game.logPlayer(self, ally.name.." hits!")

					for k,m in pairs(self.allies) do
						if m == ally then
							ally.attackTarget(target, nil, t.damMultiplier(self,t), true)
							hitCount = hitCount +1
							break
						end  
					end
				end
			end
		end
		game.logPlayer(self, hitCount.." hits!")
		if hitCount == 0 then
			return nil
		end
		return true
	end,
	info = function(self, t)
		return ([[Marks an enemy. Any adjacent soldiers get a free hit on them at %d%% damage.]]):
		format(t.damMultiplier(self,t)*100)
	end,
}

newTalent{
	name = "WIP3",
	type = {"cunning/captain", 4},
	require = captains_req4,
	points = 5,
	stamina = 8,
	cooldown = 10,
	range = 100,
	radius = function(self, t) return math.ceil(3 + self:getTalentLevel(t)) end,
	requires_target = true,
	no_npc_use = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[WIP]])
	end,
}
