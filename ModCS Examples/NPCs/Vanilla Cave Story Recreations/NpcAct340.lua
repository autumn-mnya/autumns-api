-- Ballos
ModCS.Npc.Act[340] = function(npc)
    local i = 0
    local x = 0

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.cond = 0x80
        npc.exp = 1
        npc.direct = 0
        npc.y = npc.y - 6
        npc.damage = 0
        ModCS.Npc.Spawn3(341, npc.x, npc.y - 16, 0, 0, 0, npc)
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_no = 100
        end
    elseif (npc.act_no == 100) then
        npc.act_no = 110
        npc.act_wait = 0
        npc.ani_no = 1
        npc.ani_wait = 0
        npc.damage = 4
        npc:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (npc.act_no == 110) then
        npc.act_no = 111
        npc.damage = 3
        npc.tgt_x = npc.life
        -- Fallthrough
    end

    if (npc.act_no == 111) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 10) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end
        
        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end

        npc.act_wait = npc.act_wait + 1

        if (npc.life < npc.tgt_x - 50 or npc.act_wait > 150) then
            if (npc.count2 % 5 == 0 or npc.count2 % 5 == 1 or npc.count2 % 5 == 2 or npc.count2 % 5 == 3) then
                npc.act_no = 200
            elseif (npc.count2 % 5 == 4) then
                npc.act_no = 300
            end

            npc.count2 = npc.count2 + 1
        end

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
    elseif (npc.act_no == 200) then
        npc.act_no = 201
        npc.count1 = 0
        -- Fallthrough
    end

    if (npc.act_no == 201) then
        if (npc.xm == 0) then
            npc.act_no = 202
        else
            npc.act_no = 203
        end

        npc.act_wait = 0
        npc.ani_no = 3
        npc.damage = 3
        npc.count1 = npc.count1 + 1
        -- Fallthrough
    end

    if (npc.act_no == 202) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.xm = 8 * npc.xm / 9
        npc.ym = 8 * npc.ym / 9

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 210
        end
    elseif (npc.act_no == 203) then
        npc.xm = 8 * npc.xm / 9
        npc.ym = 8 * npc.ym / 9

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            if (npc.tgt_mc.y < npc.y + 12) then
                npc.act_no = 220
            else
                npc.act_no = 230
            end
        end
    elseif (npc.act_no == 210) then
        npc.act_no = 211
        npc.act_wait = 0
        npc.ani_no = 6
        npc.ani_wait = 0
        npc.ym = 0
        npc.damage = 10

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        ModCS.Sound.Play(25)
        -- Fallthrough
    end

    if (npc.act_no == 211) then
        if (npc.direct == 0) then
            npc.xm = -4
        else
            npc.xm = 4
        end

        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 6
        else
            npc.ani_no = 7
        end

        if (npc.direct == 0 and npc:TouchLeftWall()) then
            npc.act_no = 212
            npc.act_wait = 0
            npc.damage = 3
            ModCS.Camera.SetAltQuake(10)
            ModCS.Sound.Play(26)
        end

        if (npc.direct == 2 and npc:TouchRightWall()) then
            npc.act_no = 212
            npc.act_wait = 0
            npc.damage = 3
            ModCS.Camera.SetAltQuake(10)
            ModCS.Sound.Play(26)
        end

        if (npc.count1 < 4 and npc.tgt_mc.x > npc.x - 16 and npc.tgt_mc.x < npc.x + 16) then
            npc.act_no = 201
        end
    elseif (npc.act_no == 212) then
        npc.act_wait = npc.act_wait + 1
        npc.xm = 0
        npc.ani_no = 6

        if (npc.act_wait > 30) then
            if (npc.count1 > 3) then
                npc.act_no = 240
            else
                npc.act_no = 201
            end
        end
    elseif (npc.act_no == 220) then
        npc.act_no = 221
        npc.act_wait = 0
        npc.ani_no = 8
        npc.ani_wait = 0
        npc.xm = 0
        npc.damage = 10
        npc.direct = 0
        ModCS.Sound.Play(25)
        -- Fallthrough
    end

    if (npc.act_no == 221) then
        npc.ym = -4

        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 8
        else
            npc.ani_no = 9
        end

        if (npc.y < 48) then
            npc.y = 48
            npc.ym = 0
            npc.act_no = 222
            npc.act_wait = 0
            npc.damage = 3

            for i = 0, 7 do
                x = npc.x + ModCS.Game.Random2(-0x10, 0x10)
                ModCS.Npc.Spawn2(4, x, npc.y - 10, 0, 0, 0)
            end

            ModCS.Npc.Spawn2(332, npc.x - 12, npc.y - 12, 0, 0, 0)
            ModCS.Npc.Spawn2(332, npc.x + 12, npc.y - 12, 0, 0, 2)
            ModCS.Camera.SetAltQuake(10)
            ModCS.Sound.Play(26)
        end

        if (npc.count1 < 4 and npc.tgt_mc.y > npc.y - 16 and npc.tgt_mc.y < npc.y + 16) then
            npc.act_no = 201
        end
    elseif (npc.act_no == 222) then
        npc.act_wait = npc.act_wait + 1
        npc.xm = 0
        npc.ani_no = 8

        if (npc.act_wait > 30) then
            if (npc.count1 > 3) then
                npc.act_no = 240
            else
                npc.act_no = 201
            end
        end
    elseif (npc.act_no == 230) then
        npc.act_no = 231
        npc.act_wait = 0
        npc.ani_no = 8
        npc.ani_wait = 0
        npc.xm = 0
        npc.damage = 10
        npc.direct = 2
        ModCS.Sound.Play(25)
        -- Fallthrough
    end

    if (npc.act_no == 231) then
        npc.ym = 4

        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 8
        else
            npc.ani_no = 9
        end

        if (npc:TouchFloor()) then
            npc.act_no = 232
            npc.act_wait = 0
            npc.damage = 3

            if (npc.tgt_mc.x < npc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end

            for i = 0, 7 do
                x = npc.x + ModCS.Game.Random2(-0x10, 0x10)
                ModCS.Npc.Spawn2(4, x, npc.y + 10, 0, 0, 0)
            end

            ModCS.Npc.Spawn2(332, npc.x - 12, npc.y + 12, 0, 0, 0)
            ModCS.Npc.Spawn2(332, npc.x + 12, npc.y + 12, 0, 0, 2)
            ModCS.Camera.SetAltQuake(10)
            ModCS.Sound.Play(26)
        end

        if (npc.count1 < 4 and npc.tgt_mc.y > npc.y - 16 and npc.tgt_mc.y < npc.y + 16) then
            npc.act_no = 201
        end
    elseif (npc.act_no == 232) then
        npc.act_wait = npc.act_wait + 1
        npc.xm = 0
        npc.ani_no = 3

        if (npc.act_wait > 30) then
            if (npc.count1 > 3) then
                npc.act_no = 242
            else
                npc.act_no = 201
            end
        end
    elseif (npc.act_no == 240) then
        npc.act_no = 241
        npc.direct = 0
        -- Fallthrough
    end

    if (npc.act_no == 241) then
        npc.ym = npc.ym + 0.25
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc.ani_wait = npc.ani_wait + 1
        if (math.floor(npc.ani_wait / 2) % 2 == 1) then
            npc.ani_no = 4
        else
            npc.ani_no = 5
        end

        if (npc:TouchFloor()) then
            npc.act_no = 242
            npc.act_wait = 0
            npc.ani_no = 3

            if (npc.tgt_mc.x < npc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 242) then
        npc.xm = 3 * npc.xm / 4
        npc.ani_no = 3

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 110
        end
    elseif (npc.act_no == 300) then
        npc.act_no = 310
        npc.act_wait = 0
        npc.ym = -3

        if (npc.x > 320) then
            npc.direct = 2
            npc.tgt_x = npc.tgt_mc.x
            npc.tgt_y = 176
        else
            npc.direct = 0
            npc.tgt_x = npc.tgt_mc.x
            npc.tgt_y = 176
        end

        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 310) then
        npc.ani_wait = npc.ani_wait + 1
        
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 200 and npc.ani_wait < 20) then
            npc.direct = 2
        else
            npc.direct = 0
        end

        if (math.floor(npc.ani_wait / 2) % 2 == 1) then
            npc.ani_no = 4
        else
            npc.ani_no = 5
        end

        if (npc.x < npc.tgt_x) then
            npc.xm = npc.xm + 0.125
        else
            npc.xm = npc.xm - 0.125
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.125
        else
            npc.ym = npc.ym - 0.125
        end

        if (npc.xm > 2) then
            npc.xm = 2
        end

        if (npc.xm < -2) then
            npc.xm = -2
        end

        if (npc.ym > 2) then
            npc.ym = 2
        end

        if (npc.ym < -2) then
            npc.ym = -2
        end

        if (npc.act_wait > 200 and npc.act_wait % 40 == 1) then
            npc.ani_wait = 0
            ModCS.Npc.Spawn2(333, npc.tgt_mc.x, 304, 0, 0, 0)
        end

        if (npc.act_wait > 480) then
            npc.act_no = 320
            npc.act_wait = 0
        end
    elseif (npc.act_no == 320) then
        npc.xm = 0
        npc.ym = 0
        npc.direct = 2

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 40) then
            ModCS.Flash.Spawn()
        end

        if (npc.act_wait > 50 and npc.act_wait % 10 == 1) then
            x = ((4 * npc.act_wait - 200) / 10 + 2) * 0x10
            ModCS.Npc.Spawn2(333, x, 304, 0, 0, 0)
        end

        if (npc.act_wait > 140) then
            npc.act_no = 240
        end

        npc.ani_wait = npc.ani_wait + 1
        if (math.floor(npc.ani_wait / 2) % 2 == 1) then
            npc.ani_no = 4
        else
            npc.ani_no = 5
        end
    elseif (npc.act_no == 1000) then
        npc.act_no = 1001
        npc.act_wait = 0
        npc.ani_no = 10
        npc.tgt_x = npc.x
        npc.xm = 0
        npc:UnsetBit(5) -- Unset shootable bit
        ModCS.Npc.Explode(npc.x, npc.y, 0.03125, 0x10)
        ModCS.Sound.Play(72)
        -- Fallthrough
    end

    if (npc.act_no == 1001) then
        npc.ym = npc.ym + 0.0625
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x + 1
        else
            npc.x = npc.tgt_x - 1
        end

        if (npc:TouchFloor()) then
            npc.act_no = 1002
            npc.act_wait = 0
        end
    elseif (npc.act_no == 1002) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 150) then
            npc.act_wait = 0
            npc.act_no = 1003
            npc.ani_no = 3
        end

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x + 1
        else
            npc.x = npc.tgt_x - 1
        end
    elseif (npc.act_no == 1003) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_wait = 0
            npc.act_no = 1004
            npc.ani_no = 3
            npc.ym = npc.ym - 5
            npc.direct = 0
            npc:SetBit(3) -- Set ignore tile collision bit
        end
    elseif (npc.act_no == 1004) then
        if (npc.y < 0) then
            npc.xm = 0
            npc.ym = 0
            npc.act_no = 1005
            npc.act_wait = 0
            ModCS.Flash.Spawn()
            ModCS.Sound.Play(29)
        end

        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 8
        else
            npc.ani_no = 9
        end
    end

    npc:Move()

    local rcLeft = {
        ModCS.Rect.Create(0, 0, 48, 40),
        ModCS.Rect.Create(48, 0, 96, 40),
        ModCS.Rect.Create(96, 0, 144, 40),
        ModCS.Rect.Create(144, 0, 192, 40),
        ModCS.Rect.Create(192, 0, 240, 40),
        ModCS.Rect.Create(240, 0, 288, 40),
        ModCS.Rect.Create(0, 80, 48, 120),
        ModCS.Rect.Create(48, 80, 96, 120),
        ModCS.Rect.Create(96, 80, 144, 120),
        ModCS.Rect.Create(144, 80, 192, 120),
        ModCS.Rect.Create(192, 80, 240, 120),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 40, 48, 80),
        ModCS.Rect.Create(48, 40, 96, 80),
        ModCS.Rect.Create(96, 40, 144, 80),
        ModCS.Rect.Create(144, 40, 192, 80),
        ModCS.Rect.Create(192, 40, 240, 80),
        ModCS.Rect.Create(240, 40, 288, 80),
        ModCS.Rect.Create(0, 120, 48, 160),
        ModCS.Rect.Create(48, 120, 96, 160),
        ModCS.Rect.Create(96, 120, 144, 160),
        ModCS.Rect.Create(144, 120, 192, 160),
        ModCS.Rect.Create(192, 120, 240, 160),
    }

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end 

-- Ballos 1 head
ModCS.Npc.Act[341] = function(npc)
    local rc = {
        ModCS.Rect.Create(288, 32, 320, 48),
        ModCS.Rect.Create(288, 48, 320, 64),
        ModCS.Rect.Create(288, 64, 320, 80),
    }

    if (npc.pNpc.act_no == 11 and npc.pNpc.act_wait > 50) then
        npc.ani_wait = npc.ani_wait + 1
    end

    if (npc.ani_wait > 4) then
        npc.ani_wait = 0

        if (npc.ani_no < 2) then
            npc.ani_no = npc.ani_no + 1
        end
    end

    if (npc.pNpc.ani_no ~= 0) then
        npc.cond = 0
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ballos 3 eye
local ballo3_eye_flash = 0
ModCS.Npc.Act[342] = function(npc)
    local rc = {
        ModCS.Rect.Create(240, 48, 280, 88),
        ModCS.Rect.Create(240, 88, 280, 128),
        ModCS.Rect.Create(280, 48, 320, 88),
    }

    local deg = 0

    if (npc.act_no < 1000 and npc.pNpc.act_no >= 1000) then
        npc.act_no = 1000
    end

    if (npc.act_no == 0) then
        npc.act_no = 10
        npc.count1 = math.floor((npc.direct % 256) * 2)
        npc.direct = math.floor(npc.direct / 256)
        npc.count2 = 0xC0
        npc.damage = 14
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        if (npc.count2 < 320) then
            npc.count2 = npc.count2 + 8
        else
            npc.act_no = 11
        end
    elseif (npc.act_no == 11) then
        if (npc.count2 > 304) then
            npc.count2 = npc.count2 - 4
        else
            npc.act_no = 12
        end
    elseif (npc.act_no == 12) then
        if (npc.pNpc.act_no == 311) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc:SetBit(5) -- Set shootable bit
        npc.life = 1000
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.count1 = npc.count1 - 2

        if (npc.count1 < 0) then
            npc.count1 = npc.count1 + 0x200
        end

        if (npc:IsHit()) then
            ballo3_eye_flash = ballo3_eye_flash + 1
            if (math.floor(ballo3_eye_flash / 2) % 2 == 1) then
                npc.ani_no = 1
            else
                npc.ani_no = 0
            end
        else
            npc.ani_no = 0
        end

        if (npc.life < 900) then
            npc.act_no = 22
            npc:UnsetBit(5) -- Unset shootable bit
            ModCS.Npc.Explode(npc.x, npc.y, 16, 0x20)
            ModCS.Sound.Play(71)
        end

        npc.pNpc.count1 = 4

        if (npc.pNpc.act_no == 401) then
            npc.act_no = 23
        end
    elseif (npc.act_no == 22) then
        npc.ani_no = 2
        npc.count1 = npc.count1 - 2

        if (npc.count1 < 0) then
            npc.count1 = npc.count1 + 0x200
        end

        if (npc.pNpc.act_no == 401) then
            npc.act_no = 23
        end
    elseif (npc.act_no == 23) then
        npc.ani_no = 2
        npc.count1 = npc.count1 - 4

        if (npc.count1 < 0) then
            npc.count1 = npc.count1 + 0x200
        end

        if (npc.pNpc.act_no == 420) then
            npc.act_no = 30
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.life = 1000
        npc.damage = 10

        if (npc.direct == 0) then
            npc:SetBit(5) -- Set shootable bit
        end

        npc.ym = 0
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.count1 = npc.count1 + 1
        npc.count1 = npc.count1 % 0x200

        if (npc.count2 > 0x100) then
            npc.count2 = npc.count2 - 1
        end

        if (npc:CheckBit(5)) then -- If shootable bit is true
            if (npc:IsHit()) then
                ballo3_eye_flash = ballo3_eye_flash + 1
                if (math.floor(ballo3_eye_flash / 2) % 2 == 1) then
                    npc.ani_no = 1
                else
                    npc.ani_no = 0
                end
            else
                npc.ani_no = 0
            end
        else
            npc.ani_no = 2
        end

        if (npc.life < 900) then
            npc.act_no = 40
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.xm = 0
        npc.ym = 0
        npc.ani_no = 2
        npc.damage = 5
        npc:UnsetBit(3) -- Unset ignore tile collision bit
        npc:UnsetBit(5) -- Unset shootable bit
        ModCS.Npc.Explode(npc.x, npc.y, 16, 0x20)
        ModCS.Sound.Play(71)
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        if (npc:TouchLeftWall()) then
            npc.xm = 0.5
        end

        if (npc:TouchRightWall()) then
            npc.xm = -0.5
        end

        if (npc:TouchFloor()) then
            if (npc.xm == 0) then
                if (npc.tgt_mc.x < npc.x) then
                    npc.xm = 0.5
                else
                    npc.xm = -0.5
                end
            end

            npc.ym = -4
            ModCS.Sound.Play(26)
        end

        npc.ym = npc.ym + 0.0625
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end
    elseif (npc.act_no == 1000) then
        npc.act_no = 1001
        npc.xm = 0
        npc.ym = 0
        npc.ani_no = 2
        npc:UnsetBit(3) -- Unset ignore tile collision bit
        npc:UnsetBit(5) -- Unset shootable bit
        npc.damage = 0
        npc.count1 = npc.count1 / 4
        npc.exp = 0
        -- Fallthrough
    end

    if (npc.act_no == 1001) then
        if (npc.count1 > 0) then
            npc.count1 = npc.count1 - 1
            if (math.floor(npc.count1 / 2) % 2 == 1) then
                npc.ani_no = 1
            else
                npc.ani_no = 0
            end
        else
            ModCS.Npc.Explode(npc.x, npc.y, 16, 0x20)
            ModCS.Sound.Play(71)
            npc:Vanish()
            return
        end
    end

    if (npc.act_no == 21 or npc.act_no == 22) then
        if (npc.pNpc.direct == 0) then
            if (npc.count1 == 140) then
                ModCS.Npc.Spawn2(4, npc.x + 8, npc.y + 12, 0, 0, 0)
                ModCS.Npc.Spawn2(4, npc.x - 8, npc.y + 12, 0, 0, 0)
                ModCS.Sound.Play(26)
            end
        elseif (npc.pNpc.direct == 1) then
            if (npc.count1 == 268) then
                ModCS.Npc.Spawn2(4, npc.x - 12, npc.y + 8, 0, 0, 0)
                ModCS.Npc.Spawn2(4, npc.x - 12, npc.y - 8, 0, 0, 0)
                ModCS.Sound.Play(26)
            end
        elseif (npc.pNpc.direct == 2) then
            if (npc.count1 == 396) then
                ModCS.Npc.Spawn2(4, npc.x + 8, npc.y - 12, 0, 0, 0)
                ModCS.Npc.Spawn2(4, npc.x - 8, npc.y - 12, 0, 0, 0)
                ModCS.Npc.Spawn2(345, npc.x - 8, npc.y - 12, 0, 0, 0)
                ModCS.Sound.Play(26)
            end
        elseif (npc.pNpc.direct == 3) then
            if (npc.count1 == 12) then
                ModCS.Npc.Spawn2(4, npc.x + 12, npc.y + 8, 0, 0, 0)
                ModCS.Npc.Spawn2(4, npc.x + 12, npc.y - 8, 0, 0, 0)
                ModCS.Sound.Play(26)
            end
        end
    end

    if (npc.act_no < 40) then
        deg = npc.count1 / 2

        npc.tgt_x = npc.pNpc.x + npc.count2 * ModCS.Triangle.GetCos(deg) / 4
        npc.tgt_y = npc.pNpc.y + npc.count2 * ModCS.Triangle.GetSin(deg) / 4

        npc.xm = npc.tgt_x - npc.x
        npc.ym = npc.tgt_y - npc.y
    end

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ballos 2 cutscene
ModCS.Npc.Act[343] = function(npc)
    local rc = ModCS.Rect.Create(0, 0, 120, 120)

    npc:SetRect(rc)

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 100) then
        npc.cond = 0
    end

    npc.x = npc.pNpc.x
    npc.y = npc.pNpc.y
end

-- Ballos 2 eyes
ModCS.Npc.Act[344] = function(npc)
    local rc = {
        ModCS.Rect.Create(272, 0, 296, 16),
        ModCS.Rect.Create(296, 0, 320, 16),
    }

    if (npc.direct == 0) then
        npc:SetRect(rc[1])
        npc.x = npc.pNpc.x - 24
    else
        npc:SetRect(rc[2])
        npc.x = npc.pNpc.x + 24
    end

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 100) then
        npc.cond = 0
    end

    npc.y = npc.pNpc.y - 36
end

-- Ballos skull projectile
ModCS.Npc.Act[345] = function(npc)
    local rc = {
        ModCS.Rect.Create(128, 176, 144, 192),
        ModCS.Rect.Create(144, 176, 160, 192),
        ModCS.Rect.Create(160, 176, 176, 192),
        ModCS.Rect.Create(176, 176, 192, 192),
    }

    local i = 0

    if (npc.act_no == 0) then
        npc.act_no = 100
        npc.ani_no = ModCS.Game.Random(0, 16) % 4
        -- Fallthrough
    end

    if (npc.act_no == 100) then
        npc.ym = npc.ym + 0.125
        if (npc.ym > 3.5) then
            npc.ym = 3.5
        end

        if (npc.y > 128) then
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
        end
        npc.act_wait = npc.act_wait + 1

        if (npc:TouchFloor()) then
            npc.ym = -1
            npc.act_no = 110
            npc:SetBit(3) -- Set ignore tile collision bit
            ModCS.Sound.Play(12)
            ModCS.Camera.SetQuake(10)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + 16, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end
    elseif (npc.act_no == 110) then
        npc.ym = npc.ym + 0.125

        if (npc.y > ModCS.Map.GetHeight() * 0x10 + (2 * 0x10)) then
            npc.cond = 0
            return
        end
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 8) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no +1
    end

    if (npc.ani_no > 3) then
        npc.ani_no = 0
    end

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ballos 4 orbiting platform
ModCS.Npc.Act[346] = function(npc)
    local rc = ModCS.Rect.Create(240, 0, 272, 16)
    local deg = 0

    if (npc.act_no < 1000 and npc.pNpc.act_no >= 1000) then
        npc.act_no = 1000
    end

    if (npc.act_no == 0) then
        npc.act_no = 10
        npc.count1 = npc.direct * 4
        npc.count2 = 192
        npc.ani_no = 0
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        if (npc.count2 < 448) then
            npc.count2 = npc.count2 + 8
        else
            npc.act_no = 11
        end
    elseif (npc.act_no == 11) then
        if (npc.pNpc.act_no == 411) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.count1 = npc.count1 - 1
        if (npc.count1 < 0) then
            npc.count1 = npc.count1 + 0x400
        end

        if (npc.pNpc.act_no == 421) then
            npc.act_no = 40
        end

        if (npc.pNpc.act_no == 423) then
            npc.act_no = 100
        end
    elseif (npc.act_no == 30) then
        npc.count1 = npc.count1 + 1
        npc.count1 = npc.count1 % 0x400

        if (npc.pNpc.act_no == 425) then
            npc.act_no = 50
        end

        if (npc.pNpc.act_no == 427) then
            npc.act_no = 100
        end
    elseif (npc.act_no == 40) then
        npc.count1 = npc.count1 - 2

        if (npc.count1 < 0) then
            npc.count1 = npc.count1 + 0x400
        end

        if (npc.pNpc.act_no == 422) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 50) then
        npc.count1 = npc.count1 + 2
        npc.count1 = npc.count1 % 0x400

        if (npc.pNpc.act_no == 426) then
            npc.act_no = 30
        end
    elseif (npc.act_no == 100) then
        npc.ani_no = 0

        if (npc.pNpc.act_no == 424) then
            npc.act_no = 30
        end

        if (npc.pNpc.act_no == 428) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 1000) then
        npc.act_no = 1001
        npc.xm = 0
        npc.ym = 0
        npc:UnsetBit(6) -- Unset solid collision bit
        -- Fallthrough
    end

    if (npc.act_no == 1001) then
        npc.ym = npc.ym + 0.125

        if (npc.y > ModCS.Map.GetHeight() * 0x10) then
            npc.cond = 0
        end
    end

    if (npc.act_no < 1000) then
        -- This check will definitely be very, very janky in multiplayer via CSE2LE.
        -- Thank goodness there's multiple platforms?
        if (npc.tgt_mc.y > npc.y - 8 and npc.tgt_mc.ym < 0) then
            npc:UnsetBit(6) -- Unset solid collision bit
        else
            npc:SetBit(6) -- Set solid collision bit
        end

        deg = npc.count1 / 4
        npc.tgt_x = npc.pNpc.x + npc.count2 * ModCS.Triangle.GetCos(deg) / 4
        npc.tgt_y = npc.pNpc.y + 16 + npc.count2 * ModCS.Triangle.GetSin(deg) / 4

        npc.xm = npc.tgt_x - npc.x

        if (npc.act_no == 20 or npc.act_no == 30) then
            if (npc.count1 % 4 == 0) then
                npc.ani_no = ((npc.tgt_y - npc.y) / 4)*512
            end
        elseif (npc.act_no == 40 or npc.act_no == 50) then
            if (math.floor(npc.count1 / 2) % 2 == 0) then
                npc.ani_no = ((npc.tgt_y - npc.y) / 2)*512
            end
        else
            npc.ani_no = (npc.tgt_y - npc.y)*512
        end

        npc.ym = (npc.ani_no/512)
    end

    npc:Move()

    npc:SetRect(rc)
end

-- Hoppy
ModCS.Npc.Act[347] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0

        if (npc.tgt_mc.y < npc.y + 128 and npc.y > npc.tgt_mc.y - 128) then
            npc.act_no = 10
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 10) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 4) then
            npc.ani_no = 2
        end

        if (npc.act_wait > 12) then
            npc.act_no = 12
            npc.xm = 3.5
            ModCS.Sound.Play(6)
            npc.ani_no = 3
        end
    elseif (npc.act_no == 12) then
        local done = false

        if (npc.tgt_mc.y < npc.y) then
            npc.ym = -0.33203125
        else
            npc.ym = 0.33203125
        end

        if (npc:TouchLeftWall()) then
            npc.act_no = 13
            npc.act_wait = 0
            npc.ani_no = 2
            npc.xm = 0
            npc.ym = 0
            done = true
        end

        if not done then
            npc.xm = npc.xm - 0.08203125

            if (npc.xm < -2.998046875) then
                npc.xm = -2.998046875
            end

            npc:Move()
        end
    elseif (npc.act_no == 13) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 2) then
            npc.ani_no = 1
        end

        if (npc.act_wait == 6) then
            npc.ani_no = 0
        end

        if (npc.act_wait > 16) then
            npc.act_no = 1
        end
    end

    local rc = {
        ModCS.Rect.Create(256, 48, 272, 64),
        ModCS.Rect.Create(272, 48, 288, 64),
        ModCS.Rect.Create(288, 48, 304, 64),
        ModCS.Rect.Create(304, 48, 320, 64),
    }

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ballos 4 spikes
ModCS.Npc.Act[348] = function(npc)
    local rc = {
        ModCS.Rect.Create(128, 152, 160, 176),
        ModCS.Rect.Create(160, 152, 192, 176),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait < 0x80) then
            npc.y = npc.y - 0.25

            if (math.floor(npc.act_wait / 2) % 2 == 1) then
                npc.ani_no = 1
            else
                npc.ani_no = 0
            end
        else
            npc.act_no = 10
            npc.ani_no = 0
            npc.damage = 2
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Statue
ModCS.Npc.Act[349] = function(npc)
    local rect = ModCS.Rect.Create(0, 0, 16, 16)

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.x = npc.x + 8
        else
            npc.x = npc.x + 16
        end
    end

    npc:SetRect(rect)
end

-- Flying Bute archer
ModCS.Npc.Act[350] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 160, 24, 184),
        ModCS.Rect.Create(24, 160, 48, 184),
        ModCS.Rect.Create(48, 160, 72, 184),
        ModCS.Rect.Create(72, 160, 96, 184),
        ModCS.Rect.Create(96, 160, 120, 184),
        ModCS.Rect.Create(120, 160, 144, 184),
        ModCS.Rect.Create(144, 160, 168, 184),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 184, 24, 208),
        ModCS.Rect.Create(24, 184, 48, 208),
        ModCS.Rect.Create(48, 184, 72, 208),
        ModCS.Rect.Create(72, 184, 96, 208),
        ModCS.Rect.Create(96, 184, 120, 208),
        ModCS.Rect.Create(120, 184, 144, 208),
        ModCS.Rect.Create(144, 184, 168, 208),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.tgt_x = npc.x - 128
        else
            npc.tgt_x = npc.x + 128
        end

        npc.tgt_y = npc.y

        npc.ym = ModCS.Game.Random2(-1, 1) * 2
        npc.xm = ModCS.Game.Random2(-1, 1) * 2
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 1) then
                npc.ani_no = 0
            end
        end

        if (npc.direct == 0) then
            if (npc.x < npc.tgt_x) then
                npc.act_no = 20
            end
        else
            if (npc.x > npc.tgt_x) then
                npc.act_no = 20
            end
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = ModCS.Game.Random(0, 150)
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 3) then
                npc.ani_no = 2
            end
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 300) then
            npc.act_no = 30
        end

        if (npc:TriggerBox(112, 16, 112, 16)) then
            npc.act_no = 30
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.ani_wait = npc.ani_wait + 1
        if (math.floor(npc.ani_wait / 2) % 2 == 1) then
            npc.ani_no = 3
        else
            npc.ani_no = 4
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 40
            npc.ani_no = 5

            if (npc.direct == 0) then
                ModCS.Npc.Spawn2(312, npc.x, npc.y, -4, 0, 0)
            else
                ModCS.Npc.Spawn2(312, npc.x, npc.y, 4, 0, 2)
            end
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.act_wait = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 6) then
                npc.ani_no = 5
            end
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_no = 50
            npc.ani_no = 0
            npc.xm = 0
            npc.ym = 0
        end
    elseif (npc.act_no == 50) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 1) then
                npc.ani_no = 0
            end
        end

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.0625
        else
            npc.xm = npc.xm + 0.0625
        end

        if (npc.x < 0 or npc.x > ModCS.Map.GetWidth() * 0x10) then
            npc:Vanish()
            return
        end
    end

    if (npc.act_no < 50) then
        if (npc.x < npc.tgt_x) then
            npc.xm = npc.xm + 0.08203125
        end

        if (npc.x > npc.tgt_x) then
            npc.xm = npc.xm - 0.08203125
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.08203125
        end

        if (npc.y > npc.tgt_y) then
            npc.ym = npc.ym - 0.08203125
        end

        if (npc.xm > 2) then
            npc.xm = 2
        end

        if (npc.xm < -2) then
            npc.xm = -2
        end

        if (npc.ym > 2) then
            npc.ym = 2
        end

        if (npc.ym < -2) then
            npc.ym = -2
        end
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Statue (shootable)
ModCS.Npc.Act[351] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 96, 32, 136),
        ModCS.Rect.Create(32, 96, 64, 136),
        ModCS.Rect.Create(64, 96, 96, 136),
        ModCS.Rect.Create(96, 96, 128, 136),
        ModCS.Rect.Create(128, 96, 160, 136),
        ModCS.Rect.Create(0, 176, 32, 216),
        ModCS.Rect.Create(32, 176, 64, 216),
        ModCS.Rect.Create(64, 176, 96, 216),
        ModCS.Rect.Create(96, 176, 128, 216),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = npc.direct / 10
        npc.x = npc.x + 8
        npc.y = npc.y + 12
    elseif (npc.act_no == 10) then
        if (ModCS.Flag.Get(npc.flag)) then
            npc.act_no = 20
        else
            npc.act_no = 11
            npc:SetBit(5) -- Set shootable bit
        end
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.life <= 900) then
            ModCS.Npc.Spawn2(351, npc.x - 8, npc.y - 12, 0, 0, (npc.ani_no + 4) * 10, 0)
            npc:KillOnNextFrame()
        end
    elseif (npc.act_no == 20) then
        npc.ani_no = npc.ani_no + 4
        npc.act_no = 1
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ending characters
ModCS.Npc.Act[352] = function(npc)
    local view = npc:GetViewbox()
    if (npc.act_no == 0) then
        -- Set state
        npc.act_no = 1
        npc.ani_no = 0
        npc.count1 = npc.direct / 100
        npc.direct = npc.direct % 100

        -- Set surfaces/offset

        if (npc.count1 == 7 or npc.count1 == 8 or npc.count1 == 9 or npc.count1 == 12 or npc.count1 == 13) then
            npc.surf = ModCS.Const.SURFACE_ID_LEVEL_SPRITESET_1
        end

        if (npc.count1 == 2 or npc.count1 == 4 or npc.count1 == 9 or npc.count1 == 12) then
            view.top = 16
        end

        -- Balrog
        if (npc.count1 == 9) then
            view.back = 20
            view.front = 20
            npc.x = npc.x - 1
        end

        -- Spawn King's sword
        if (npc.count1 == 0) then
            ModCS.Npc.Spawn3(145, 0, 0, 0, 0, 2, npc)
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ym = npc.ym + 0.125
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        if (npc:TouchFloor()) then
            npc.ym = 0
            npc.act_no = 2
            npc.ani_no = 1
        end

        npc:Move()
    end

    local rc = {
        ModCS.Rect.Create(304, 48, 320, 64),
        ModCS.Rect.Create(224, 48, 240, 64),
        ModCS.Rect.Create(32, 80, 48, 96),
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(224, 216, 240, 240),
        ModCS.Rect.Create(192, 216, 208, 240),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(112, 192, 128, 216),
        ModCS.Rect.Create(80, 192, 96, 216),
        ModCS.Rect.Create(304, 0, 320, 16),
        ModCS.Rect.Create(224, 0, 240, 16),
        ModCS.Rect.Create(176, 32, 192, 48),
        ModCS.Rect.Create(176, 32, 192, 48),
        ModCS.Rect.Create(240, 16, 256, 32),
        ModCS.Rect.Create(224, 16, 240, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
        ModCS.Rect.Create(192, 16, 208, 32),
        ModCS.Rect.Create(280, 128, 320, 152),
        ModCS.Rect.Create(280, 152, 320, 176),
        ModCS.Rect.Create(32, 112, 48, 128),
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(80, 0, 96, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
        ModCS.Rect.Create(16, 152, 32, 176),
        ModCS.Rect.Create(0, 152, 16, 176),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(48, 0, 64, 16),
    }

    npc:SetRect(rc[(npc.ani_no + (npc.count1 * 2))+1])

    npc:SetViewbox(view)
end

-- Bute with sword (flying)
ModCS.Npc.Act[353] = function(npc)
    local rc = {
        ModCS.Rect.Create(168, 160, 184, 184),
        ModCS.Rect.Create(184, 160, 200, 184),
        ModCS.Rect.Create(168, 184, 184, 208),
        ModCS.Rect.Create(184, 184, 200, 208),
    }

    local rcLeft = {
        ModCS.Rect.Create(200, 160, 216, 176),
        ModCS.Rect.Create(216, 160, 232, 176),
    }

    local rcRight = {
        ModCS.Rect.Create(200, 176, 216, 192),
        ModCS.Rect.Create(216, 176, 232, 192),
    }

    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.xm = -3
        elseif (npc.direct == 2) then
            npc.xm = 3
        elseif (npc.direct == 1) then
            npc.ym = -3
        elseif (npc.direct == 3) then
            npc.ym = 3
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1

        if (npc.act_wait == 8) then
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end

        npc:Move()

        if (npc.act_wait == 0x10) then
            npc.act_no = 10
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 3) then
                npc.ani_no = 0
            end
        end

        npc:SetRect(rc[npc.ani_no+1])
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 0
        npc:SetBit(5) -- Set shootable bit
        npc:UnsetBit(3) -- Unset ignore tile collision bit
        npc.damage = 5
        view.top = 8
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2    local rc = {
        ModCS.Rect.Create(304, 48, 320, 64),
        ModCS.Rect.Create(224, 48, 240, 64),
        ModCS.Rect.Create(32, 80, 48, 96),
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(224, 216, 240, 240),
        ModCS.Rect.Create(192, 216, 208, 240),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(112, 192, 128, 216),
        ModCS.Rect.Create(80, 192, 96, 216),
        ModCS.Rect.Create(304, 0, 320, 16),
        ModCS.Rect.Create(224, 0, 240, 16),
        ModCS.Rect.Create(176, 32, 192, 48),
        ModCS.Rect.Create(176, 32, 192, 48),
        ModCS.Rect.Create(240, 16, 256, 32),
        ModCS.Rect.Create(224, 16, 240, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
        ModCS.Rect.Create(192, 16, 208, 32),
        ModCS.Rect.Create(280, 128, 320, 152),
        ModCS.Rect.Create(280, 152, 320, 176),
        ModCS.Rect.Create(32, 112, 48, 128),
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(80, 0, 96, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
        ModCS.Rect.Create(16, 152, 32, 176),
        ModCS.Rect.Create(0, 152, 16, 176),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(48, 0, 64, 16),
    }

        end

        if (npc.tgt_mc.y - 24 > npc.y) then
            if (npc.direct == 0) then
                npc.xm2 = npc.xm2 + 0.03125
            else
                npc.xm2 = npc.xm2 - 0.03125
            end
        else
            if (npc.direct == 0) then
                npc.xm2 = npc.xm2 - 0.03125
            else
                npc.xm2 = npc.xm2 + 0.03125
            end
        end

        if (npc.y > npc.tgt_mc.y) then
            npc.ym2 = npc.ym2 - 0.03125
        else
            npc.ym2 = npc.ym2 + 0.03125
        end

        if (npc.xm2 < 0 and npc:TouchLeftWall()) then
            npc.xm2 = npc.xm2 * -1
        end

        if (npc.xm2 > 0 and npc:TouchRightWall()) then
            npc.xm2 = npc.xm2 * -1
        end

        if (npc.ym2 < 0 and npc:TouchCeiling()) then
            npc.ym2 = npc.ym2 * -1
        end

        if (npc.ym2 > 0 and npc:TouchFloor()) then
            npc.ym2 = npc.ym2 * -1
        end

        if (npc.xm2 < -2.998046875) then
            npc.xm2 = -2.998046875
        end

        if (npc.xm2 > 2.998046875) then
            npc.xm2 = 2.998046875
        end

        if (npc.ym2 < -2.998046875) then
            npc.ym2 = -2.998046875
        end

        if (npc.ym2 > 2.998046875) then
            npc.ym2 = 2.998046875
        end

        npc:Move2()

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            
            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 1) then
                npc.ani_no = 0
            end
        end

        if (npc.direct == 0) then
            npc:SetRect(rcLeft[npc.ani_no+1])
        else
            npc:SetRect(rcRight[npc.ani_no+1])
        end
    end

    npc:SetViewbox(view)
end

-- Invisible deathtrap wall
ModCS.Npc.Act[354] = function(npc)
    local i = 0
    local x = 0
    local y = 0

    local hit = npc:GetHitbox()

    if (npc.act_no == 0) then
        hit.bottom = 280
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0

        if (npc.direct == 0) then
            npc.x = npc.x + 16
        else
            npc.x = npc.x - 16
        end
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_wait = 0
            ModCS.Camera.SetQuake(20)
            ModCS.Sound.Play(26)
            ModCS.Sound.Play(12)

            if (npc.direct == 0) then
                npc.x = npc.x - 16
            else
                npc.x = npc.x + 16
            end

            for i = 0, 19 do
                x = (npc.x / 0x10)
                y = (npc.y / 0x10) + i
                ModCS.Map.ChangeTile(109, x, y)
            end
        end
    end

    npc:SetHitbox(hit)
end

-- Quote and Curly on Balrog's back
ModCS.Npc.Act[355] = function(npc)
    local rc = {
        ModCS.Rect.Create(80, 16, 96, 32),
        ModCS.Rect.Create(80, 96, 96, 112),
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(208, 96, 224, 112),
    }

    if (npc.act_no == 0) then
        if (npc.direct == 0) then
            npc.surf = ModCS.Const.SURFACE_ID_MY_CHAR
            npc.ani_no = 0
            npc.x = npc.pNpc.x - 14
            npc.y = npc.pNpc.y + 10
        elseif (npc.direct == 1) then
            npc.surf = ModCS.Const.SURFACE_ID_NPC_REGU
            npc.ani_no = 1
            npc.x = npc.pNpc.x + 14
            npc.y = npc.pNpc.y + 10
        elseif (npc.direct == 2) then
            npc.surf = ModCS.Const.SURFACE_ID_MY_CHAR
            npc.ani_no = 2
            npc.x = npc.pNpc.x - 7
            npc.y = npc.pNpc.y - 19
        elseif (npc.direct == 3) then
            npc.surf = ModCS.Const.SURFACE_ID_NPC_REGU
            npc.ani_no = 3
            npc.x = npc.pNpc.x + 4
            npc.y = npc.pNpc.y - 19
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Balrog rescue
ModCS.Npc.Act[356] = function(npc)
    local rcRight = {
        ModCS.Rect.Create(240, 128, 280, 152),
        ModCS.Rect.Create(240, 152, 280, 176),
    }

    if (npc.act_no == 0) then
        npc.act_no = 11
        npc.ani_wait = 0
        npc.tgt_y = npc.y - 16
        npc.tgt_x = npc.x - 6
        npc.ym = 0
        ModCS.Npc.Spawn3(355, 0, 0, 0, 0, 3, npc, 0xAA)
        ModCS.Npc.Spawn3(355, 0, 0, 0, 0, 2, npc, 0xAA)
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.x < npc.tgt_x) then
            npc.xm = npc.xm + 0.015625
        else
            npc.xm = npc.xm - 0.015625
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.015625
        else
            npc.ym = npc.ym - 0.015625
        end

        npc:Move()
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.xm = -2
        npc.ym = 1
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.ani_wait = npc.ani_wait + 1
        npc.xm = npc.xm + 0.03125
        npc.ym = npc.ym - 0.015625
        npc:Move()

        if (npc.x > 60 * 0x10) then
            npc.act_no = 22
        end
    elseif (npc.act_no == 22) then
        npc.xm = 0
        npc.ym = 0
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 4) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    npc:SetRect(rcRight[npc.ani_no+1])
end

-- Puppy ghost
ModCS.Npc.Act[357] = function(npc)
    local rc = ModCS.Rect.Create(224, 136, 240, 152)
    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc:SetRect(rc)
        npc.act_wait = npc.act_wait + 1
    elseif (npc.act_no == 10) then
        npc.act_wait = 0
        npc.act_no = 11
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        rect = rc

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            rect.right = rect.left
        end

        if (npc.act_wait > 50) then
            npc.cond = 0
        end

        npc:SetRect(rect)
    end

    if (npc.act_wait % 8 == 1) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_TINY_PARTICLES, npc.x + ModCS.Game.Random(-8, 8), npc.y + 8, 1)
    end
end

-- Misery (stood in the wind during the credits)
ModCS.Npc.Act[358] = function(npc)
    local rc = {
        ModCS.Rect.Create(208, 8, 224, 32),
        ModCS.Rect.Create(224, 8, 240, 32),
        ModCS.Rect.Create(240, 8, 256, 32),
        ModCS.Rect.Create(256, 8, 272, 32),
        ModCS.Rect.Create(272, 8, 288, 32),
    }

    if (npc.act_no == 0) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 6) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 6) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            npc.ani_no = 3
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Water droplet generator
ModCS.Npc.Act[359] = function(npc)
    local x = 0

    if (npc:TriggerBox((ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 200, (ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 200) and ModCS.Game.Random(0, 100) == 2) then
        x = npc.x + ModCS.Game.Random(-6, 6)
        ModCS.Npc.Spawn2(73, x, npc.y - 7, 0, 0, 0, 0)
    end
end

-- "Thank you" message at the end of the credits
ModCS.Npc.Act[360] = function(npc)
    local rc = ModCS.Rect.Create(0, 176, 48, 184)

    if (npc.act_no == 0) then
        npc.act_no = npc.act_no + 1
        npc.x = npc.x - 8
        npc.y = npc.y - 8
    end

    npc:SetRect(rc)
end