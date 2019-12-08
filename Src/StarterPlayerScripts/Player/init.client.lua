local player = game.Players.LocalPlayer
repeat
    wait()
until player.Character

local humanoid = player.Character.Humanoid

local touching

local scoreTxt = player.PlayerGui.ScreenGui.ScoreDisplay.ScoreTxt

humanoid.Touched:connect(function(other)
    if other.Name == 'GenPoint' and touching ~= other then
        touching = other
        game.ReplicatedStorage.Events.GenRoad:FireServer()
    end
end)

game.ReplicatedStorage.Events.UpdateScore.OnClientEvent:connect(
    function(newScore)
        scoreTxt.Text = string.format("Score %d", newScore)
    end)