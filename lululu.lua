if _G.NoobWarConnection then
    _G.NoobWarConnection:Disconnect()
    _G.NoobWarConnection = nil
end
_G.NoobWarActive = false
task.wait(0.1)
_G.NoobWarActive = true

local Players = game:GetService("Players")
local lplayer = Players.LocalPlayer

local function applySafeHitbox(player)
    if not _G.NoobWarActive or player == lplayer then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and humanoid.Health > 0 and hrp and hrp:IsA("Part") then
        local isEnemy = true
        if _G.TeamCheck and lplayer.Team and player.Team then
            if player.Team == lplayer.Team then
                isEnemy = false
            end
        elseif _G.TeamCheck and not lplayer.Team and not player.Team then
            isEnemy = false
        end
        
        local currentTargetSize = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
        
        if isEnemy then
            if hrp.Size ~= currentTargetSize or hrp.Transparency ~= _G.BoxTransparency then
                hrp.Size = currentTargetSize
                hrp.Transparency = _G.BoxTransparency
                hrp.CanCollide = false
                hrp.Color = Color3.fromRGB(255, 0, 0) -- Красный цвет (виден только при Transparency < 1)
            end
        else
            if hrp.Size ~= Vector3.new(2, 2, 1) or hrp.Transparency ~= 1 then
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
                hrp.CanCollide = false
            end
        end
    end
end

_G.NoobWarConnection = game:GetService("RunService").Heartbeat:Connect(function()
    if not _G.NoobWarActive then return end
    for _, player in ipairs(Players:GetPlayers()) do
        pcall(function()
            applySafeHitbox(player)
        end)
    end
end)
