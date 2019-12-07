local player = game.Players.LocalPlayer

repeat
    wait()
until player.Character

local controlsEnabled = false

game.ReplicatedStorage.Events.EnableControls.OnClientEvent:connect(function(enabled)
	controlsEnabled = enabled
end)

game:GetService('RunService'):BindToRenderStep(
    'Controls',
    Enum.RenderPriority.Character.Value,
    function()
        if controlsEnabled then
            if player.Character and player.Character:FindFirstChild('Humanoid') then
                local moveDir = Vector3.new(0, 0, -1)
                player.Character.Humanoid:Move(moveDir, false)
            end
        end
    end)

print('Player Start Running')

game.ReplicatedStorage.Events.StartRunning:FireServer(player)