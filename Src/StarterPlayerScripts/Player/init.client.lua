local player = game.Players.LocalPlayer

print('Player Start Running')

game.ReplicatedStorage.Events.StartRunning:FireServer()

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

game.ReplicatedStorage.Events.UpdateScore.OnClientEvent:connect(
    function(newScore)
        player.PlayerGui.ScreenGui.ScoreDisplay.ScoreTxt.Text = string.format("Score %d", newScore)
    end)