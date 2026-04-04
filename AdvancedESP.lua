-- Advanced ESP V5 - WORKING VERSION
-- Fix: ESP wird jetzt korrekt angezeigt

if getgenv().ESP_V5_LOADED then return end
getgenv().ESP_V5_LOADED = true

-- ========== LOAD RAYFIELD ==========
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/lzhenwei76-beep/RayfieldCopy/refs/heads/main/source.lua'))()

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ========== CREATE GUI PARENT ==========
local espGui = Instance.new("ScreenGui")
espGui.Name = "AdvancedESP"
espGui.ResetOnSpawn = false
espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
espGui.DisplayOrder = 999
pcall(function() espGui.Parent = CoreGui end)
if not espGui.Parent then
    espGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ========== ESP VARIABLES ==========
local espEnabled = false
local espMode = "All" -- "All", "Team", "Enemy", "Selected"
local selectedPlayer = nil
local selectedPlayerName = "None"

-- ESP Options
local showBox = true
local showName = true
local showDistance = true
local showHealth = true
local showTracer = false

-- Farben
local teamColor = Color3.fromRGB(0, 255, 0)
local enemyColor = Color3.fromRGB(255, 0, 0)
local tracerColor = Color3.fromRGB(255, 255, 255)
local boxTransparency = 0.5
local maxDistance = 2000

-- ESP Objects Storage
local espObjects = {}
local playerList = {}

-- ========== HELPER FUNCTIONS ==========
local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({Title = title, Content = content, Duration = duration or 2})
    end)
end

local function isTeammate(player)
    return player.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil
end

local function shouldShowESP(player)
    if player == LocalPlayer then return false end
    if not espEnabled then return false end
    
    if espMode == "All" then
        return true
    elseif espMode == "Team" then
        return isTeammate(player)
    elseif espMode == "Enemy" then
        return not isTeammate(player) and player.Team ~= nil
    elseif espMode == "Selected" then
        return selectedPlayer == player
    end
    return false
end

local function getESPColor(player)
    if isTeammate(player) then
        return teamColor
    else
        return enemyColor
    end
end

-- ========== CREATE ESP (WORKING VERSION) ==========
local function createESP(player)
    if espObjects[player] then return end
    
    local esp = {}
    
    -- Box Frame
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 100, 0, 100)
    box.Position = UDim2.new(0, 0, 0, 0)
    box.BackgroundColor3 = getESPColor(player)
    box.BackgroundTransparency = boxTransparency
    box.BorderSizePixel = 1
    box.BorderColor3 = getESPColor(player)
    box.Visible = false
    box.Parent = espGui
    
    -- Name Label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 120, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = getESPColor(player)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.Text = player.Name
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Visible = false
    nameLabel.Parent = espGui
    
    -- Distance Label
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(0, 80, 0, 16)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 10
    distanceLabel.Text = ""
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.Visible = false
    distanceLabel.Parent = espGui
    
    -- Health Bar Background
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(0, 100, 0, 6)
    healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthBg.BorderSizePixel = 0
    healthBg.Visible = false
    healthBg.Parent = espGui
    
    -- Health Bar Fill
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    
    -- Tracer Line
    local tracer = Instance.new("Frame")
    tracer.Size = UDim2.new(0, 100, 0, 2)
    tracer.BackgroundColor3 = tracerColor
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.Visible = false
    tracer.Parent = espGui
    
    espObjects[player] = {
        Box = box,
        NameLabel = nameLabel,
        DistanceLabel = distanceLabel,
        HealthBg = healthBg,
        HealthFill = healthFill,
        Tracer = tracer,
        Humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    }
    
    -- Health update
    local humanoid = espObjects[player].Humanoid
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if espObjects[player] and espObjects[player].HealthFill and humanoid then
                local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                espObjects[player].HealthFill.Size = UDim2.new(percent, 0, 1, 0)
                
                if percent > 0.6 then
                    espObjects[player].HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                elseif percent > 0.3 then
                    espObjects[player].HealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                else
                    espObjects[player].HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end)
    end
end

-- ========== UPDATE ESP POSITIONS ==========
local function updateESP()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    for player, esp in pairs(espObjects) do
        -- Check if should show
        local show = shouldShowESP(player)
        
        if show then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                
                if hrp and head then
                    -- Get screen positions
                    local headPos, headOnScreen = camera:WorldToViewportPoint(head.Position)
                    local hrpPos, hrpOnScreen = camera:WorldToViewportPoint(hrp.Position)
                    
                    if headOnScreen and hrpOnScreen and headPos.Z > 0 then
                        -- Calculate box size based on distance
                        local dist = (hrp.Position - (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new())).Magnitude
                        
                        if dist <= maxDistance then
                            local boxHeight = 150 / headPos.Z
                            local boxWidth = boxHeight * 0.7
                            local boxX = headPos.X - boxWidth / 2
                            local boxY = headPos.Y - boxHeight
                            
                            -- Update Box
                            if showBox and esp.Box then
                                esp.Box.Size = UDim2.new(0, boxWidth, 0, boxHeight)
                                esp.Box.Position = UDim2.new(0, boxX, 0, boxY)
                                esp.Box.BackgroundColor3 = getESPColor(player)
                                esp.Box.BorderColor3 = getESPColor(player)
                                esp.Box.BackgroundTransparency = boxTransparency
                                esp.Box.Visible = true
                            elseif esp.Box then
                                esp.Box.Visible = false
                            end
                            
                            -- Update Name
                            if showName and esp.NameLabel then
                                esp.NameLabel.Position = UDim2.new(0, boxX + boxWidth/2 - 60, 0, boxY - 18)
                                esp.NameLabel.Text = player.Name
                                esp.NameLabel.TextColor3 = getESPColor(player)
                                esp.NameLabel.Visible = true
                            elseif esp.NameLabel then
                                esp.NameLabel.Visible = false
                            end
                            
                            -- Update Distance
                            if showDistance and esp.DistanceLabel then
                                esp.DistanceLabel.Position = UDim2.new(0, boxX + boxWidth/2 - 40, 0, boxY + boxHeight + 2)
                                esp.DistanceLabel.Text = math.floor(dist) .. "m"
                                esp.DistanceLabel.Visible = true
                            elseif esp.DistanceLabel then
                                esp.DistanceLabel.Visible = false
                            end
                            
                            -- Update Health Bar
                            if showHealth and esp.HealthBg then
                                esp.HealthBg.Size = UDim2.new(0, boxWidth, 0, 4)
                                esp.HealthBg.Position = UDim2.new(0, boxX, 0, boxY + boxHeight + 18)
                                esp.HealthBg.Visible = true
                                
                                if esp.HealthFill and esp.Humanoid then
                                    local percent = math.clamp(esp.Humanoid.Health / esp.Humanoid.MaxHealth, 0, 1)
                                    esp.HealthFill.Size = UDim2.new(percent, 0, 1, 0)
                                end
                            elseif esp.HealthBg then
                                esp.HealthBg.Visible = false
                            end
                            
                            -- Update Tracer
                            if showTracer and esp.Tracer then
                                local dx = headPos.X - center.X
                                local dy = headPos.Y - center.Y
                                local length = math.sqrt(dx * dx + dy * dy)
                                if length > 0 and length < 500 then
                                    local angle = math.atan2(dy, dx) * (180 / math.pi)
                                    esp.Tracer.Size = UDim2.new(0, length, 0, 2)
                                    esp.Tracer.Position = UDim2.new(0, center.X, 0, center.Y)
                                    esp.Tracer.Rotation = angle
                                    esp.Tracer.Visible = true
                                else
                                    esp.Tracer.Visible = false
                                end
                            elseif esp.Tracer then
                                esp.Tracer.Visible = false
                            end
                        else
                            -- Hide if too far
                            if esp.Box then esp.Box.Visible = false end
                            if esp.NameLabel then esp.NameLabel.Visible = false end
                            if esp.DistanceLabel then esp.DistanceLabel.Visible = false end
                            if esp.HealthBg then esp.HealthBg.Visible = false end
                            if esp.Tracer then esp.Tracer.Visible = false end
                        end
                    else
                        -- Hide if off screen
                        if esp.Box then esp.Box.Visible = false end
                        if esp.NameLabel then esp.NameLabel.Visible = false end
                        if esp.DistanceLabel then esp.DistanceLabel.Visible = false end
                        if esp.HealthBg then esp.HealthBg.Visible = false end
                        if esp.Tracer then esp.Tracer.Visible = false end
                    end
                else
                    -- Hide if no character
                    if esp.Box then esp.Box.Visible = false end
                    if esp.NameLabel then esp.NameLabel.Visible = false end
                    if esp.DistanceLabel then esp.DistanceLabel.Visible = false end
                    if esp.HealthBg then esp.HealthBg.Visible = false end
                    if esp.Tracer then esp.Tracer.Visible = false end
                end
            else
                -- Hide if no character
                if esp.Box then esp.Box.Visible = false end
                if esp.NameLabel then esp.NameLabel.Visible = false end
                if esp.DistanceLabel then esp.DistanceLabel.Visible = false end
                if esp.HealthBg then esp.HealthBg.Visible = false end
                if esp.Tracer then esp.Tracer.Visible = false end
            end
        else
            -- Hide if should not show
            if esp.Box then esp.Box.Visible = false end
            if esp.NameLabel then esp.NameLabel.Visible = false end
            if esp.DistanceLabel then esp.DistanceLabel.Visible = false end
            if esp.HealthBg then esp.HealthBg.Visible = false end
            if esp.Tracer then esp.Tracer.Visible = false end
        end
    end
end

-- ========== CHECK FOR NEW PLAYERS ==========
local function checkNewPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not espObjects[player] then
            createESP(player)
        end
    end
end

-- ========== REMOVE ALL ESP ==========
local function removeAllESP()
    for player, esp in pairs(espObjects) do
        pcall(function()
            esp.Box:Destroy()
            esp.NameLabel:Destroy()
            esp.DistanceLabel:Destroy()
            esp.HealthBg:Destroy()
            esp.Tracer:Destroy()
        end)
        espObjects[player] = nil
    end
end

-- ========== UPDATE SETTINGS ==========
local function updateSettings()
    for player, esp in pairs(espObjects) do
        if esp.Box then
            esp.Box.BackgroundColor3 = getESPColor(player)
            esp.Box.BorderColor3 = getESPColor(player)
            esp.Box.BackgroundTransparency = boxTransparency
        end
        if esp.NameLabel then
            esp.NameLabel.TextColor3 = getESPColor(player)
        end
        if esp.Tracer then
            esp.Tracer.BackgroundColor3 = tracerColor
        end
    end
end

-- ========== UPDATE PLAYER LIST ==========
local function updatePlayerList()
    playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- ========== CHARACTER ADDED HANDLER ==========
local function onCharacterAdded(player)
    if espObjects[player] then
        pcall(function()
            espObjects[player].Box:Destroy()
            espObjects[player].NameLabel:Destroy()
            espObjects[player].DistanceLabel:Destroy()
            espObjects[player].HealthBg:Destroy()
            espObjects[player].Tracer:Destroy()
        end)
        espObjects[player] = nil
    end
    createESP(player)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            onCharacterAdded(player)
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    -- Recreate ESP for all players after respawn
    for player, esp in pairs(espObjects) do
        pcall(function()
            esp.Box:Destroy()
            esp.NameLabel:Destroy()
            esp.DistanceLabel:Destroy()
            esp.HealthBg:Destroy()
            esp.Tracer:Destroy()
        end)
        espObjects[player] = nil
        createESP(player)
    end
end)

-- ========== RAYFIELD GUI ==========
local Window = Rayfield:CreateWindow({
    Name = "Advanced ESP",
    Icon = 0,
    LoadingTitle = "Advanced ESP",
    LoadingSubtitle = "Working Version",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AdvancedESP",
        FileName = "Config"
    },
    KeySystem = false
})

-- ========== MAIN TAB ==========
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("ESP Control")

MainTab:CreateToggle({
    Name = "ESP Master Switch",
    CurrentValue = false,
    Flag = "ESPMaster",
    Callback = function(value)
        espEnabled = value
        if espEnabled then
            checkNewPlayers()
        else
            for player, esp in pairs(espObjects) do
                if esp.Box then esp.Box.Visible = false end
                if esp.NameLabel then esp.NameLabel.Visible = false end
                if esp.DistanceLabel then esp.DistanceLabel.Visible = false end
                if esp.HealthBg then esp.HealthBg.Visible = false end
                if esp.Tracer then esp.Tracer.Visible = false end
            end
        end
        notify("ESP", value and "ENABLED" or "DISABLED", 2)
    end
})

MainTab:CreateSection("ESP Mode")

MainTab:CreateButton({
    Name = "👥 ALL PLAYERS",
    Callback = function()
        espMode = "All"
        notify("Mode", "Showing ALL players", 2)
    end
})

MainTab:CreateButton({
    Name = "👥 TEAMMATES ONLY",
    Callback = function()
        espMode = "Team"
        notify("Mode", "Showing TEAMMATES only", 2)
    end
})

MainTab:CreateButton({
    Name = "⚔️ ENEMIES ONLY",
    Callback = function()
        espMode = "Enemy"
        notify("Mode", "Showing ENEMIES only", 2)
    end
})

MainTab:CreateButton({
    Name = "🎯 SPECIFIC PLAYER",
    Callback = function()
        espMode = "Selected"
        notify("Mode", "Showing SELECTED player only", 2)
    end
})

MainTab:CreateDropdown({
    Name = "Select Player",
    Options = {"None", unpack(playerList)},
    CurrentOption = "None",
    Flag = "PlayerSelect",
    Callback = function(option)
        if option == "None" then
            selectedPlayer = nil
            selectedPlayerName = "None"
        else
            selectedPlayer = Players:FindFirstChild(option)
            selectedPlayerName = option
        end
        notify("Selected Player", selectedPlayerName, 1)
    end
})

-- ========== VISUAL TAB ==========
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateSection("Display Toggles")

VisualTab:CreateToggle({
    Name = "Show Box ESP",
    CurrentValue = showBox,
    Flag = "ShowBox",
    Callback = function(value)
        showBox = value
        notify("Box ESP", value and "ON" or "OFF", 1)
    end
})

VisualTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = showName,
    Flag = "ShowName",
    Callback = function(value)
        showName = value
        notify("Name Display", value and "ON" or "OFF", 1)
    end
})

VisualTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = showDistance,
    Flag = "ShowDistance",
    Callback = function(value)
        showDistance = value
        notify("Distance Display", value and "ON" or "OFF", 1)
    end
})

VisualTab:CreateToggle({
    Name = "Show Health Bar",
    CurrentValue = showHealth,
    Flag = "ShowHealth",
    Callback = function(value)
        showHealth = value
        notify("Health Bar", value and "ON" or "OFF", 1)
    end
})

VisualTab:CreateToggle({
    Name = "Show Tracer Line",
    CurrentValue = showTracer,
    Flag = "ShowTracer",
    Callback = function(value)
        showTracer = value
        notify("Tracer Line", value and "ON" or "OFF", 1)
    end
})

VisualTab:CreateSection("Colors")

VisualTab:CreateButton({
    Name = "🟢 Team: Green",
    Callback = function()
        teamColor = Color3.fromRGB(0, 255, 0)
        updateSettings()
        notify("Team Color", "Green", 1)
    end
})

VisualTab:CreateButton({
    Name = "🔵 Team: Blue",
    Callback = function()
        teamColor = Color3.fromRGB(0, 100, 255)
        updateSettings()
        notify("Team Color", "Blue", 1)
    end
})

VisualTab:CreateButton({
    Name = "🟣 Team: Purple",
    Callback = function()
        teamColor = Color3.fromRGB(255, 0, 255)
        updateSettings()
        notify("Team Color", "Purple", 1)
    end
})

VisualTab:CreateButton({
    Name = "🔴 Enemy: Red",
    Callback = function()
        enemyColor = Color3.fromRGB(255, 0, 0)
        updateSettings()
        notify("Enemy Color", "Red", 1)
    end
})

VisualTab:CreateButton({
    Name = "🟠 Enemy: Orange",
    Callback = function()
        enemyColor = Color3.fromRGB(255, 100, 0)
        updateSettings()
        notify("Enemy Color", "Orange", 1)
    end
})

VisualTab:CreateButton({
    Name = "⚪ Enemy: White",
    Callback = function()
        enemyColor = Color3.fromRGB(255, 255, 255)
        updateSettings()
        notify("Enemy Color", "White", 1)
    end
})

VisualTab:CreateButton({
    Name = "⚪ Tracer: White",
    Callback = function()
        tracerColor = Color3.fromRGB(255, 255, 255)
        updateSettings()
        notify("Tracer Color", "White", 1)
    end
})

VisualTab:CreateSection("Transparency")

VisualTab:CreateSlider({
    Name = "Box Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = boxTransparency,
    Flag = "BoxTransparency",
    Callback = function(value)
        boxTransparency = value
        updateSettings()
    end
})

-- ========== SETTINGS TAB ==========
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Distance")

SettingsTab:CreateSlider({
    Name = "Max ESP Distance",
    Range = {100, 5000},
    Increment = 100,
    Suffix = "m",
    CurrentValue = maxDistance,
    Flag = "MaxDistance",
    Callback = function(value)
        maxDistance = value
        notify("Max Distance", value .. "m", 1)
    end
})

-- ========== INFO TAB ==========
local InfoTab = Window:CreateTab("Info", 4483362458)

InfoTab:CreateSection("About")

InfoTab:CreateParagraph({
    Title = "Advanced ESP",
    Content = [[
Version: 5.0 (Working)

FEATURES:
✓ Box ESP
✓ Name Display
✓ Distance Display
✓ Health Bar
✓ Tracer Line
✓ Team/Enemy Colors
✓ Player Selection

MODES:
• All Players
• Teammates Only
• Enemies Only
• Selected Player

CONTROLS:
• INSERT - Open/Close Menu
• HOME - Unload Script
]]
})

-- ========== UPDATE LOOP ==========
RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- ========== CLEANUP ==========
local function cleanup()
    espEnabled = false
    removeAllESP()
    pcall(function() espGui:Destroy() end)
    getgenv().ESP_V5_LOADED = false
    notify("ESP", "Unloaded!", 2)
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Home then
        cleanup()
    end
end)

-- ========== INIT ==========
-- Create ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

notify("Advanced ESP", "Loaded! Press INSERT for menu", 3)
print("=== Advanced ESP Loaded ===")
print("ESP wird jetzt korrekt angezeigt!")
print("Press INSERT for Rayfield menu")
