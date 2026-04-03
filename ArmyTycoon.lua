debugX = true

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/lzhenwei76-beep/RayfieldCopy/refs/heads/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Army Tycoon GUI",
    Icon = 0,
    LoadingTitle = "Army Tycoon GUI",
    LoadingSubtitle = "By lzhenwei",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ArmyTycoon",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- ========== VARIABLEN ==========
local Lagging = false
local NukeBindActive = false
local NukeConnection = nil

-- ========== FUNKTIONEN ==========

-- Funktion: Kill All Units
local function KillAllUnits()
    for i, v in pairs(game.Workspace.Game.Units:GetChildren()) do
        if v.Name ~= game.Players.LocalPlayer.Name then
            for i, v2 in pairs(v:GetChildren()) do
                local Missile = "Cruise Missile"
                local Position = v2.Torso.Position
                game:GetService("ReplicatedStorage").RE.FireMissile:FireServer(Missile, Position)
            end
        end
    end
    Rayfield:Notify({
        Title = "Success",
        Content = "All enemy units destroyed!",
        Duration = 3
    })
end

-- Funktion: Get All Buildings (für den Spieler)
local function GetAllBuildings()
    -- Erst alle Buildings relinquish (freigeben)
    for i, v in pairs(game.Workspace.Game.Buttons:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            for i, v2 in pairs(v:GetChildren()) do
                game:GetService("ReplicatedStorage").RE.relinquish:FireServer(v2, true)
            end
        end
    end
    
    -- ObjectValues umbenennen
    for i, v in pairs(game.Workspace.Game.Buttons:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            for i, v2 in pairs(v:GetChildren()) do
                for i, v3 in pairs(v2:GetChildren()) do
                    if v3:IsA("ObjectValue") then
                        v3.Name = v3.Value.Name
                    end
                end
            end
        end
    end
    
    -- Buildings upgraden/erstellen
    for i, v in pairs(game.Workspace.Game.Buttons:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            for i, v2 in pairs(v:GetChildren()) do
                for i, v3 in pairs(v2:GetChildren()) do
                    if v3:IsA("ObjectValue") then
                        local Class = nil
                        local BuildingName = v3.Name
                        
                        if BuildingName == "Barracks" then
                            Class = game.ReplicatedStorage.Game.Buildings["Barracks"]["2"]
                        elseif BuildingName == "Greenhouse" then
                            Class = game.ReplicatedStorage.Game.Buildings["Greenhouse"]["2"]
                        elseif BuildingName == "Factory" then
                            Class = game.ReplicatedStorage.Game.Buildings["Factory"]["3"]
                        elseif BuildingName == "Oil Field" then
                            Class = game.ReplicatedStorage.Game.Buildings["Oil Field"]["2"]
                        elseif BuildingName == "Guard Tower" then
                            Class = game.ReplicatedStorage.Game.Buildings["Guard Tower"]["1"]
                        elseif BuildingName == "Wall" then
                            Class = game.ReplicatedStorage.Game.Buildings["Wall"]["2"]
                        elseif BuildingName == "Generator Powerplant" then
                            Class = game.ReplicatedStorage.Game.Buildings["Generator Powerplant"]["1"]
                        elseif BuildingName == "Missile Factory" then
                            Class = game.ReplicatedStorage.Game.Buildings["Missile Factory"]["1"]
                        elseif BuildingName == "Command Center" then
                            Class = game.ReplicatedStorage.Game.Buildings["Command Center"]["2"]
                        elseif BuildingName == "Drone Factory" then
                            Class = game.ReplicatedStorage.Game.Buildings["Drone Factory"]["1"]
                        elseif BuildingName == "Military" then
                            Class = game.ReplicatedStorage.Game.Buildings.Military["Tank Factory"]["2"]
                        elseif BuildingName == "Nuclear Powerplant" then
                            Class = game.ReplicatedStorage.Game.Buildings["Nuclear Powerplant"]["1"]
                        elseif BuildingName == "Airport" then
                            Class = game.ReplicatedStorage.Game.Buildings["Airport"]["1"]
                        elseif BuildingName == "Helicopter Bay" then
                            Class = game.ReplicatedStorage.Game.Buildings["Helicopter Bay"]["2"]
                        elseif BuildingName == "Main Base" then
                            Class = game.ReplicatedStorage.Game.Buildings["Main Base"]["2"]
                        end
                        
                        if Class then
                            local Target = game:GetService("ReplicatedStorage").RE.insertBuilding
                            Target:FireServer(Class, v2)
                        end
                    end
                end
            end
        end
    end
    
    Rayfield:Notify({
        Title = "Success",
        Content = "All buildings upgraded!",
        Duration = 3
    })
end

-- Funktion: Give All Players All Buildings
local function GiveAllPlayersAllBuildings()
    for i, v in pairs(game.Workspace.Game.Buttons:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            for i, v2 in pairs(v:GetChildren()) do
                game:GetService("ReplicatedStorage").RE.relinquish:FireServer(v2, true)
            end
        end
    end
    
    for i, v in pairs(game.Workspace.Game.Buttons:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            for i, v2 in pairs(v:GetChildren()) do
                for i, v3 in pairs(v2:GetChildren()) do
                    if v3:IsA("ObjectValue") then
                        v3.Name = v3.Value.Name
                    end
                end
            end
        end
    end
    
    for i, v in pairs(game.Workspace.Game.Buttons:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            for i, v2 in pairs(v:GetChildren()) do
                for i, v3 in pairs(v2:GetChildren()) do
                    if v3:IsA("ObjectValue") then
                        local Class = nil
                        local BuildingName = v3.Name
                        
                        if BuildingName == "Barracks" then
                            Class = game.ReplicatedStorage.Game.Buildings["Barracks"]["2"]
                        elseif BuildingName == "Greenhouse" then
                            Class = game.ReplicatedStorage.Game.Buildings["Greenhouse"]["2"]
                        elseif BuildingName == "Factory" then
                            Class = game.ReplicatedStorage.Game.Buildings["Factory"]["3"]
                        elseif BuildingName == "Oil Field" then
                            Class = game.ReplicatedStorage.Game.Buildings["Oil Field"]["2"]
                        elseif BuildingName == "Guard Tower" then
                            Class = game.ReplicatedStorage.Game.Buildings["Guard Tower"]["1"]
                        elseif BuildingName == "Wall" then
                            Class = game.ReplicatedStorage.Game.Buildings["Wall"]["2"]
                        elseif BuildingName == "Generator Powerplant" then
                            Class = game.ReplicatedStorage.Game.Buildings["Generator Powerplant"]["1"]
                        elseif BuildingName == "Missile Factory" then
                            Class = game.ReplicatedStorage.Game.Buildings["Missile Factory"]["1"]
                        elseif BuildingName == "Command Center" then
                            Class = game.ReplicatedStorage.Game.Buildings["Command Center"]["2"]
                        elseif BuildingName == "Drone Factory" then
                            Class = game.ReplicatedStorage.Game.Buildings["Drone Factory"]["1"]
                        elseif BuildingName == "Military" then
                            Class = game.ReplicatedStorage.Game.Buildings.Military["Tank Factory"]["2"]
                        elseif BuildingName == "Nuclear Powerplant" then
                            Class = game.ReplicatedStorage.Game.Buildings["Nuclear Powerplant"]["1"]
                        elseif BuildingName == "Airport" then
                            Class = game.ReplicatedStorage.Game.Buildings["Airport"]["1"]
                        elseif BuildingName == "Helicopter Bay" then
                            Class = game.ReplicatedStorage.Game.Buildings["Helicopter Bay"]["2"]
                        elseif BuildingName == "Main Base" then
                            Class = game.ReplicatedStorage.Game.Buildings["Main Base"]["2"]
                        end
                        
                        if Class then
                            local Target = game:GetService("ReplicatedStorage").RE.insertBuilding
                            Target:FireServer(Class, v2)
                        end
                    end
                end
            end
        end
    end
    
    Rayfield:Notify({
        Title = "Success",
        Content = "All buildings given to all players!",
        Duration = 3
    })
end

-- Funktion: Lag Players
local function StartLagPlayers()
    if Lagging then return end
    Lagging = true
    
    Rayfield:Notify({
        Title = "Lag Mode",
        Content = "Lagging all players! (Close GUI to stop)",
        Duration = 3
    })
    
    while Lagging do
        for i, v in pairs(game.Players:GetChildren()) do
            pcall(function()
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = v.Character.HumanoidRootPart.Position
                    game.ReplicatedStorage.RE.FireMissile:FireServer("Nuke", targetPos)
                end
            end)
        end
        task.wait(0.5)
    end
end

local function StopLagPlayers()
    Lagging = false
    Rayfield:Notify({
        Title = "Lag Mode",
        Content = "Lag mode stopped",
        Duration = 2
    })
end

-- Funktion: Send Nuke To Mouse (Q)
local function EnableNukeBind()
    if NukeBindActive then return end
    NukeBindActive = true
    
    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    
    NukeConnection = mouse.KeyDown:Connect(function(k)
        if k == "q" then
            pcall(function()
                local nukePos = Vector3.new(mouse.Hit.p.X, 48.6649132, mouse.Hit.p.Z)
                game:GetService("ReplicatedStorage").RE.FireMissile:FireServer("Nuke", nukePos)
                Rayfield:Notify({
                    Title = "Nuke Launched",
                    Content = "Nuke sent to mouse position!",
                    Duration = 1
                })
            end)
        end
    end)
    
    Rayfield:Notify({
        Title = "Nuke Bind",
        Content = "Press Q to launch nuke at mouse position!",
        Duration = 3
    })
end

local function DisableNukeBind()
    if NukeConnection then
        NukeConnection:Disconnect()
        NukeConnection = nil
    end
    NukeBindActive = false
    Rayfield:Notify({
        Title = "Nuke Bind",
        Content = "Nuke bind disabled",
        Duration = 2
    })
end

-- ========== RAYFIELD GUI TABS ==========

-- Haupt Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Attack Section
local AttackSection = MainTab:CreateSection("Attack")

-- Button: Kill All Units
MainTab:CreateButton({
    Name = "💀 Kill All Units",
    Callback = function()
        KillAllUnits()
    end,
})

-- Button: Lag Players (Toggle mit while loop)
MainTab:CreateToggle({
    Name = "🐌 Lag Players (Nuke Spam)",
    CurrentValue = false,
    Flag = "LagToggle",
    Callback = function(Value)
        if Value then
            StartLagPlayers()
        else
            StopLagPlayers()
        end
    end,
})

-- Buildings Section
local BuildingsSection = MainTab:CreateSection("Buildings")

-- Button: Get All Buildings
MainTab:CreateButton({
    Name = "🏗️ Get All Buildings (Upgrade All)",
    Callback = function()
        GetAllBuildings()
    end,
})

-- Button: Give All Players All Buildings
MainTab:CreateButton({
    Name = "🎁 Give All Players All Buildings",
    Callback = function()
        GiveAllPlayersAllBuildings()
    end,
})

-- Nuke Section
local NukeSection = MainTab:CreateSection("Nuke")

-- Button: Send Nuke To Mouse (Toggle)
MainTab:CreateToggle({
    Name = "💥 Send Nuke To Mouse (Press Q)",
    CurrentValue = false,
    Flag = "NukeBindToggle",
    Callback = function(Value)
        if Value then
            EnableNukeBind()
        else
            DisableNukeBind()
        end
    end,
})

-- Info Section
local InfoSection = MainTab:CreateSection("Information")

MainTab:CreateParagraph({
    Title = "Army Tycoon GUI",
    Content = "Features:\n• Kill All Enemy Units\n• Upgrade All Your Buildings\n• Give Buildings to All Players\n• Lag Players with Nuke Spam\n• Launch Nukes with Q Key\n\nPress INSERT to toggle menu"
})

-- ========== CLEANUP BEIM ENTLADEN ==========
local function Cleanup()
    if NukeConnection then
        NukeConnection:Disconnect()
    end
    Lagging = false
end

-- Verbinde Cleanup mit Rayfield Close (optional)
-- Rayfield hat keine native Unload-Funktion, aber wir können es im Hintergrund laufen lassen
-- Der Nutzer kann das Script einfach stoppen

print("Army Tycoon GUI loaded! Press INSERT to open menu")
print("Features: Kill Units | Upgrade Buildings | Nuke Spam | Q Key Nukes")
