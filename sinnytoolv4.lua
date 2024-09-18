local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

local GUI = Mercury:Create{
    Name = "Mercury",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/deeeity/mercury-lib"
}

-- Tab 1: Player (Aimbot and ESP)
local Tab1 = GUI:Tab{
    Name = "Player",
    Icon = "rbxassetid://8569322835"
}

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local targetPlayer = nil -- Store the current target player
local smoothness = 5 -- Default smoothness value (1 to 10)
local mouseDown = false
local aimbotConnection

function getClosestEnemyPlayer()
    local closestDistance = math.huge
    local closestPlayer = nil

    for _, enemyPlayer in pairs(game.Players:GetPlayers()) do
        if enemyPlayer ~= player and enemyPlayer.TeamColor ~= player.TeamColor and enemyPlayer.Character then
            local character = enemyPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")

            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                if distance < closestDistance and humanoidRootPart.Position.Y >= 0 then
                    closestDistance = distance
                    closestPlayer = enemyPlayer
                end
            end
        end
    end

    return closestPlayer
end

function startAimbot()
    aimbotConnection = runService.Stepped:Connect(function()
        if mouseDown and getgenv().AimbotEnabled then
            if not targetPlayer or not targetPlayer.Character or targetPlayer.Character:FindFirstChild("Humanoid").Health <= 0 then
                targetPlayer = getClosestEnemyPlayer()
            end
            
            if targetPlayer then
                local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local currentCFrame = camera.CFrame
                    local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
                    local newCFrame = currentCFrame:Lerp(targetCFrame, smoothness / 10)

                    camera.CFrame = newCFrame

                    if not mouseDown then
                        mouse1press()
                        mouseDown = true
                    end
                end
            else
                if mouseDown then
                    mouse1release()
                    mouseDown = false
                end
            end
        else
            if mouseDown then
                mouse1release()
                mouseDown = false
            end
        end
    end)
end

function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    if mouseDown then
        mouse1release()
        mouseDown = false
    end
end

-- Aimbot Toggle
Tab1:Toggle{
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(state)
        getgenv().AimbotEnabled = state
        if state then
            print("Aimbot Enabled")
            startAimbot()
        else
            print("Aimbot Disabled")
            stopAimbot()
        end
    end
}

-- ESP Toggle
Tab1:Toggle{
    Name = "Enable ESP",
    Default = false,
    Callback = function(state)
        if state then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/zzerexx/scripts/main/UniversalEsp.lua'))()
            print("ESP Enabled")
        else
            print("ESP Disabled")
            -- Logic to disable ESP if needed
        end
    end
}

-- Tab 2: Gun Mods
local Tab2 = GUI:Tab{
    Name = "Gun Mods",
    Icon = "rbxassetid://8569322835"
}

-- Example Gun Mods
Tab2:Button{
    Name = "Infinite Ammo",
    Callback = function()
        -- Logic to enable infinite ammo
        print("Infinite Ammo Activated")
    end
}

Tab2:Button{
    Name = "No Reload",
    Callback = function()
        -- Logic to enable no reload
        print("No Reload Activated")
    end
}

-- Tab 3: Movement
local Tab3 = GUI:Tab{
    Name = "Movement",
    Icon = "rbxassetid://8569322835"
}

Tab3:Toggle{
    Name = "Speed Boost",
    Default = false,
    Callback = function(state)
        if state then
            player.Character.Humanoid.WalkSpeed = 50 -- Adjust speed as needed
            print("Speed Boost Enabled")
        else
            player.Character.Humanoid.WalkSpeed = 16 -- Reset to default
            print("Speed Boost Disabled")
        end
    end
}

-- Tab 4: Credits
local Tab4 = GUI:Tab{
    Name = "Credits",
    Icon = "rbxassetid://8569322835"
}

Tab4:Label{
    Name = "Script created by YourName",
}

print("Script loaded successfully.")
