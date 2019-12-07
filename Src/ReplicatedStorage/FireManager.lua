local FireManager = {}
FireManager.Bullet = game.ReplicatedStorage.Objects.IronBall

local function createBullet(target)
    local bullet = FireManager.Bullet:Clone()
    bullet.Parent = workspace

    local pos = FireManager.server.PlayerManager.Player.Character.Head.Position
    pos = Vector3.new(pos.x, pos.y, pos.z - 2)
    bullet.Position = pos

    local direction = (target - pos).unit
    bullet.Velocity = direction * 300
end

function FireManager:Init(server)
    self.server = server
end

function FireManager:Fire(pos)
    spawn(function()
        createBullet(pos)
    end)
end

return FireManager