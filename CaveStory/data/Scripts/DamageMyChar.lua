function ModCS.Player.OnHit()
    local damage = ModCS.Player.GetHitDamage()

    if not (ModCS.Game.CanControl()) then
        return
    end

    if (ModCS.Player.shock ~= 0) then
        return
    end

    -- Damage player
    ModCS.Sound.Play(16)
    ModCS.Player.UnsetCond(1)
    ModCS.Player.shock = 128

    if (ModCS.Player.unit == 1) then
        -- nothing?
    else
        ModCS.Player.ym = -2
    end

    ModCS.Player.life = ModCS.Player.life - damage

    -- Lose a whimsical star
    if (ModCS.Player.HasEquipped(0x80) and ModCS.Player.star > 0) then
        ModCS.Player.star = ModCS.Player.star - 1
    end

    -- Lose experience
    if (ModCS.Player.HasEquipped(4)) then
        ModCS.Arms.RemoveExp(damage)
    else
        ModCS.Arms.RemoveExp(damage * 2)
    end

    -- Tell player how much damage was taken
    ModCS.ValueView.SetPlayer(-damage)

    -- Death
    if (ModCS.Player.life <= 0) then
        ModCS.Sound.Play(17)
        ModCS.Player.cond = 0
        ModCS.Npc.Explode(ModCS.Player.x, ModCS.Player.y, 10, 0x40)
        ModCS.Tsc.Run(40)
    end
end
