-- Touch Fling Script V2 - Rayfield GUI
-- Original by DuplexScripts
-- Added: Noclip, Fly, Player Teleport, ESP

if getgenv().TOUCH_FLING_V2_LOADED then return end
getgenv().TOUCH_FLING_V2_LOADED = true

-- ========== LOAD RAYFIELD ==========
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/lzhenwei76-beep/RayfieldCopy/refs/heads/main/source.lua'))()

-- ========== SERVICES ==========
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ========== CREATE DETECTION DECAL ==========
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- ========== VARIABLES ==========
-- Fling
local flingActive = false
local flingThread = nil
local flingStrength = 10000
local flingHeight = 10000
local flingPulse = 0.1

-- Noclip
local noclipActive = false
local noclipConnection = nil

-- Fly
local flyActive = false
local flySpeed = 50
local flyBodyVelocity = nil
local flyConnection = nil

-- ESP
local espActive = false
local espObjects = {}
local espColor = Color3.fromRGB(255, 0, 0)
local teamCheck = false

-- Player List
local playerList = {}
local selectedPlayer = nil

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

-- ========== NOTIFICATION HELPER ==========
local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({Title = title, Content = content, Duration = duration or 2})
    end)
end

-- ========== FLING FUNCTION ==========
local function fling()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, flingPulse

    while flingActive do
        RunService.Heartbeat:Wait()
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * flingStrength + Vector3.new(0, flingHeight, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

local function toggleFling()
    flingActive = not flingActive
    
    if flingActive then
        if flyActive then toggleFly() end
        flingThread = coroutine.create(fling)
        coroutine.resume(flingThread)
        notify("Fling", "✓ ENABLED", 2)
    else
        notify("Fling", "✗ DISABLED", 2)
    end
end

-- ========== NOCLIP FUNCTION ==========
local function setNoclip(state)
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

local function toggleNoclip()
    noclipActive = not noclipActive
    setNoclip(noclipActive)
    
    if noclipActive then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = LocalPlayer.CharacterAdded:Connect(function()
            if noclipActive then setNoclip(true) end
        end)
        notify("Noclip", "✓ ENABLED", 2)
    else
        if noclipConnection then noclipConnection:Disconnect() end
        notify("Noclip", "✗ DISABLED", 2)
    end
end

-- ========== FLY FUNCTION ==========
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = hrp
    
    humanoid.PlatformStand = true
    humanoid.AutoRotate = false
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyActive or not hrp or not hrp.Parent then return end
        
        local cam = Workspace.CurrentCamera
        local move = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then move = move - Vector3.new(0, 1, 0) end
        
        if move.Magnitude > 0 then
            flyBodyVelocity.Velocity = move.Unit * flySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function stopFly()
    if flyConnection then flyConnection:Disconnect() end
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
            humanoid.AutoRotate = true
        end
    end
end

local function toggleFly()
    if flingActive then toggleFling() end
    
    flyActive = not flyActive
    
    if flyActive then
        startFly()
        notify("Fly", "✓ ENABLED (WASD | Q/E)", 2)
    else
        stopFly()
        notify("Fly", "✗ DISABLED", 2)
    end
end

-- ========== TELEPORT FUNCTION ==========
local function teleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if not target then notify("Teleport", "Player not found!", 2); return end
    
    local targetChar = target.Character
    local localChar = LocalPlayer.Character
    if not targetChar or not localChar then notify("Teleport", "Character not found!", 2); return end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot or not localRoot then notify("Teleport", "Character not ready!", 2); return end
    
    localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 5)
    notify("Teleport", "Teleported to " .. target.Name, 2)
end

-- ========== ESP FUNCTIONS ==========
local function createESP(player)
    if espObjects[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Box
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = hrp
    box.Size = Vector3.new(4, 5, 2)
    box.Color3 = espColor
    box.Transparency = 0.5
    box.ZIndex = 0
    box.AlwaysOnTop = true
    box.Parent = hrp
    
    -- Billboard for Name
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = hrp
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Text = player.Name
    nameLabel.Parent = billboard
    
    -- Health Bar
    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 0.2, 0)
    healthBar.Position = UDim2.new(0, 0, 1, 2)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = billboard
    
    espObjects[player] = {
        Box = box,
        Billboard = billboard,
        HealthBar = healthBar,
        NameLabel = nameLabel
    }
    
    -- Update health
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if espObjects[player] and espObjects[player].HealthBar and humanoid then
                local percent = humanoid.Health / humanoid.MaxHealth
                espObjects[player].HealthBar.Size = UDim2.new(percent, 0, 0.2, 0)
                espObjects[player].HealthBar.BackgroundColor3 = percent > 0.6 and Color3.fromRGB(0, 255, 0) or percent > 0.3 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end)
    end
end

local function removeESP(player)
    if espObjects[player] then
        pcall(function()
            espObjects[player].Box:Destroy()
            espObjects[player].Billboard:Destroy()
        end)
        espObjects[player] = nil
    end
end

local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if espActive then
                if teamCheck and player.Team == LocalPlayer.Team then
                    removeESP(player)
                else
                    createESP(player)
                end
            else
                removeESP(player)
            end
        end
    end
end

local function toggleESP()
    espActive = not espActive
    
    if espActive then
        updateESP()
        -- Connect character added event
        Players.PlayerAdded:Connect(function(player)
            if espActive then
                player.CharacterAdded:Connect(function()
                    task.wait(1)
                    updateESP()
                end)
            end
        end)
        notify("ESP", "✓ ENABLED", 2)
    else
        for player, _ in pairs(espObjects) do
            removeESP(player)
        end
        notify("ESP", "✗ DISABLED", 2)
    end
end

-- Update ESP when characters change
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    updateESP()
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(1)
            updateESP()
        end)
    end
end

-- ========== FLY SPEED SETTER ==========
local function setFlySpeed(speed)
    flySpeed = speed
    notify("Fly Speed", "Set to " .. flySpeed, 1)
end

-- ========== FLING STRENGTH SETTER ==========
local function setFlingStrength(strength)
    flingStrength = strength
    notify("Fling Strength", "Set to " .. flingStrength, 1)
end

local function setFlingHeight(height)
    flingHeight = height
    notify("Fling Height", "Set to " .. flingHeight, 1)
end

local function setFlingPulse(pulse)
    flingPulse = pulse
    notify("Fling Pulse", "Set to " .. flingPulse .. "s", 1)
end

-- ========== ESP COLOR SETTER ==========
local function setESPColor(colorName, colorValue)
    espColor = colorValue
    for player, esp in pairs(espObjects) do
        pcall(function()
            esp.Box.Color3 = espColor
        end)
    end
    notify("ESP Color", "Set to " .. colorName, 1)
end

-- ========== RAYFIELD GUI ==========
local Window = Rayfield:CreateWindow({
    Name = "Touch Fling V2",
    Icon = 0,
    LoadingTitle = "Touch Fling V2",
    LoadingSubtitle = "By DuplexScripts + Extras",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TouchFlingV2",
        FileName = "Config"
    },
    KeySystem = false
})

-- ========== MAIN TAB ==========
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Core Features")

MainTab:CreateButton({
    Name = flingActive and "🟢 FLING - ON" or "🔴 FLING - OFF",
    Callback = function()
        toggleFling()
        local btn = Rayfield:GetButton("FlingButton")
        if btn then btn:Set(flingActive and "🟢 FLING - ON" or "🔴 FLING - OFF") end
    end,
    Flag = "FlingButton"
})

MainTab:CreateButton({
    Name = noclipActive and "🟢 NOCLIP - ON" or "🔴 NOCLIP - OFF",
    Callback = function()
        toggleNoclip()
        local btn = Rayfield:GetButton("NoclipButton")
        if btn then btn:Set(noclipActive and "🟢 NOCLIP - ON" or "🔴 NOCLIP - OFF") end
    end,
    Flag = "NoclipButton"
})

MainTab:CreateButton({
    Name = flyActive and "🟢 FLY - ON" or "🔴 FLY - OFF",
    Callback = function()
        toggleFly()
        local btn = Rayfield:GetButton("FlyButton")
        if btn then btn:Set(flyActive and "🟢 FLY - ON" or "🔴 FLY - OFF") end
    end,
    Flag = "FlyButton"
})

MainTab:CreateButton({
    Name = espActive and "🟢 ESP - ON" or "🔴 ESP - OFF",
    Callback = function()
        toggleESP()
        local btn = Rayfield:GetButton("ESPButton")
        if btn then btn:Set(espActive and "🟢 ESP - ON" or "🔴 ESP - OFF") end
    end,
    Flag = "ESPButton"
})

-- ========== TELEPORT TAB ==========
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateSection("Player Teleport")

-- Dynamic player buttons
local function refreshTeleportButtons()
    updatePlayerList()
    for _, playerName in ipairs(playerList) do
        TeleportTab:CreateButton({
            Name = "📍 Teleport to " .. playerName,
            Callback = function() teleportToPlayer(playerName) end
        })
    end
end

refreshTeleportButtons()

-- Refresh button
TeleportTab:CreateButton({
    Name = "🔄 Refresh Player List",
    Callback = function()
        refreshTeleportButtons()
        notify("Teleport", "Player list refreshed!", 1)
    end
})

-- ========== SETTINGS TAB ==========
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Fling Settings
SettingsTab:CreateSection("Fling Settings")

SettingsTab:CreateSlider({
    Name = "Fling Strength",
    Range = {1000, 100000},
    Increment = 1000,
    CurrentValue = flingStrength,
    Flag = "StrengthSlider",
    Callback = setFlingStrength
})

SettingsTab:CreateSlider({
    Name = "Fling Height",
    Range = {1000, 50000},
    Increment = 1000,
    CurrentValue = flingHeight,
    Flag = "HeightSlider",
    Callback = setFlingHeight
})

SettingsTab:CreateSlider({
    Name = "Pulse Speed",
    Range = {0.01, 1},
    Increment = 0.01,
    CurrentValue = flingPulse,
    Flag = "PulseSlider",
    Callback = setFlingPulse
})

-- Fly Settings
SettingsTab:CreateSection("Fly Settings")

SettingsTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 500},
    Increment = 10,
    CurrentValue = flySpeed,
    Flag = "FlySpeedSlider",
    Callback = setFlySpeed
})

-- ESP Settings
SettingsTab:CreateSection("ESP Settings")

SettingsTab:CreateToggle({
    Name = "Team Check (Hide Teammates)",
    CurrentValue = teamCheck,
    Flag = "TeamCheck",
    Callback = function(value)
        teamCheck = value
        if espActive then
            updateESP()
        end
        notify("ESP", "Team check " .. (value and "ON" or "OFF"), 1)
    end
})

SettingsTab:CreateButton({
    Name = "🔴 ESP Color: Red",
    Callback = function() setESPColor("Red", Color3.fromRGB(255, 0, 0)) end
})

SettingsTab:CreateButton({
    Name = "🟢 ESP Color: Green",
    Callback = function() setESPColor("Green", Color3.fromRGB(0, 255, 0)) end
})

SettingsTab:CreateButton({
    Name = "🔵 ESP Color: Blue",
    Callback = function() setESPColor("Blue", Color3.fromRGB(0, 100, 255)) end
})

SettingsTab:CreateButton({
    Name = "🟡 ESP Color: Yellow",
    Callback = function() setESPColor("Yellow", Color3.fromRGB(255, 255, 0)) end
})

SettingsTab:CreateButton({
    Name = "🟣 ESP Color: Purple",
    Callback = function() setESPColor("Purple", Color3.fromRGB(255, 0, 255)) end
})

-- Presets
SettingsTab:CreateSection("Presets")

SettingsTab:CreateButton({
    Name = "💪 Normal Fling (10k/10k)",
    Callback = function()
        setFlingStrength(10000)
        setFlingHeight(10000)
        Rayfield:Set("StrengthSlider", 10000)
        Rayfield:Set("HeightSlider", 10000)
        notify("Preset", "Normal Fling loaded!", 2)
    end
})

SettingsTab:CreateButton({
    Name = "🚀 Mega Fling (50k/30k)",
    Callback = function()
        setFlingStrength(50000)
        setFlingHeight(30000)
        Rayfield:Set("StrengthSlider", 50000)
        Rayfield:Set("HeightSlider", 30000)
        notify("Preset", "Mega Fling loaded!", 2)
    end
})

SettingsTab:CreateButton({
    Name = "💥 Ultra Fling (100k/50k)",
    Callback = function()
        setFlingStrength(100000)
        setFlingHeight(50000)
        Rayfield:Set("StrengthSlider", 100000)
        Rayfield:Set("HeightSlider", 50000)
        notify("Preset", "Ultra Fling loaded!", 2)
    end
})

-- ========== INFO TAB ==========
local InfoTab = Window:CreateTab("Info", 4483362458)

InfoTab:CreateSection("About")

InfoTab:CreateParagraph({
    Title = "Touch Fling V2",
    Content = [[
Version: 2.0 (Rayfield Edition)
Original by: DuplexScripts
Added Features: Noclip, Fly, Teleport, ESP

FEATURES:
✓ Touch Fling (Customizable)
✓ Noclip (Toggle)
✓ Fly (WASD + Q/E)
✓ Player Teleport
✓ ESP (Box + Name + Health)
✓ Color Customization

CONTROLS:
• INSERT - Open/Close Menu
• F - Toggle Fling
• WASD + Q/E - Fly (when enabled)

WARNING:
May cause lag on some devices
Use at your own risk
]]
})

InfoTab:CreateSection("Credits")

InfoTab:CreateParagraph({
    Title = "Credits",
    Content = [[
Original Script: DuplexScripts
Rayfield Conversion & Extras: Request
Version: 2.0

Subscribe to DuplexScripts!
]]
})

-- ========== KEYBINDS ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F key for Fling
    if input.KeyCode == Enum.KeyCode.F then
        toggleFling()
        local btn = Rayfield:GetButton("FlingButton")
        if btn then btn:Set(flingActive and "🟢 FLING - ON" or "🔴 FLING - OFF") end
    end
    
    -- N key for Noclip
    if input.KeyCode == Enum.KeyCode.N then
        toggleNoclip()
        local btn = Rayfield:GetButton("NoclipButton")
        if btn then btn:Set(noclipActive and "🟢 NOCLIP - ON" or "🔴 NOCLIP - OFF") end
    end
    
    -- X key for Fly
    if input.KeyCode == Enum.KeyCode.X then
        toggleFly()
        local btn = Rayfield:GetButton("FlyButton")
        if btn then btn:Set(flyActive and "🟢 FLY - ON" or "🔴 FLY - OFF") end
    end
    
    -- E key for ESP
    if input.KeyCode == Enum.KeyCode.End then
        toggleESP()
        local btn = Rayfield:GetButton("ESPButton")
        if btn then btn:Set(espActive and "🟢 ESP - ON" or "🔴 ESP - OFF") end
    end
end)

-- ========== CLEANUP ==========
local function cleanup()
    flingActive = false
    flyActive = false
    noclipActive = false
    espActive = false
    
    if flyConnection then flyConnection:Disconnect() end
    if noclipConnection then noclipConnection:Disconnect() end
    
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
    
    getgenv().TOUCH_FLING_V2_LOADED = false
    notify("Touch Fling V2", "Script unloaded!", 2)
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Home then
        cleanup()
    end
end)

-- ========== INIT ==========
notify("Touch Fling V2", "Loaded! Press INSERT for menu | F=Fling | N=Noclip | X=Fly", 5)
print("=== Touch Fling V2 Loaded ===")
print("Features: Fling, Noclip, Fly (WASD+Q/E), Teleport, ESP")
print("Press INSERT for Rayfield menu")
print("Keybinds: F=Fling | N=Noclip | X=Fly | End=ESP")
