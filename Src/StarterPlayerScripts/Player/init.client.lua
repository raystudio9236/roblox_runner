local player = game.Players.LocalPlayer
repeat
    wait()
until player.Character

local humanoid = player.Character.Humanoid

local touching

humanoid.Touched:connect(function(other)
    if other.Name == 'GenPoint' and touching ~= other then
        touching = other
        game.ReplicatedStorage.Events.GenRoad:FireServer()
    end
end)