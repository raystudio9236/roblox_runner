local FireManager = {}
FireManager.Bullet = game.ReplicatedStorage.Objects.IronBall

local function createBullet(target)
    local bullet = FireManager.Bullet:Clone()
    bullet.Parent = workspace

    local pos = FireManager.server.PlayerManager.Player.Character.Head.Position
    pos = Vector3.new(pos.x, pos.y, pos.z - 3.5)
    bullet.Position = pos
    bullet.Transparency = 1

    local direction = (target - pos).unit
    bullet.Velocity = direction * 500

    wait(0.1)

    bullet.Transparency = 0
end

function FireManager:Init(server)
    self.server = server
    self.fireCd = server.PlayerConfig.FireCd
    self.canFire = true
end

function FireManager:Fire(pos)
    if self.canFire then
        self.canFire = false
        createBullet(pos)

        delay(self.fireCd, function()
            self.canFire = true
        end)
    end
end

return FireManager