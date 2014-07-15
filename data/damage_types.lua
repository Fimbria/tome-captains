newDamageType{
	name = "pinning vine", type = "PINNING_VINE",
	projector = function(src, x, y, type, dam)
		DamageType:get(DamageType.NATURE).projector(src, x, y, DamageType.NATURE, dam.dam)
		local target = game.level.map(x, y, Map.ACTOR)
		if target then
			if target:canBe("pin") then
				target:setEffect(target.EFF_PINNED, dam.dur, {apply_power=src:combatPhysicalpower()})
			else
				game.logSeen(target, "%s resists!", target.name:capitalize())
			end
		end
	end,
}
