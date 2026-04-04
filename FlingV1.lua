-- Invis Fling Script - Rayfield GUI Version
-- Original by HilosHAX
-- Converted to Rayfield GUI

if getgenv().INVIS_FLING_LOADED then return end
getgenv().INVIS_FLING_LOADED = true

-- ========== LOAD RAYFIELD ==========
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/lzhenwei76-beep/RayfieldCopy/refs/heads/main/source.lua'))()

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- ========== VARIABLES ==========
local flingEnabled = false
local flingPower = 5000
local flySpeed = 100
local flyBodyVelocity = nil
local flyConnection = nil
local flingConnection = nil
local currentCamera = workspace.CurrentCamera

-- Power levels
local powerLevels = {5000, 10000, 20000, 30000, 50000}
local powerIndex = 1

-- ========== HELPER FUNCTIONS ==========
local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = duration or 2
        })
    end)
end

-- ========== INVISIBILITY FUNCTIONS ==========
local function makeInvisible(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 1
        end
    end
end

local function makeVisible(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.CanCollide = true
        elseif part:IsA("Decal") or part:IsA("Texture") then
            part.Transparency = 0
        end
    end
end

-- ========== FLY FUNCTIONS ==========
local function startFlying()
    if not hrp or not hrp.Parent then return end
    
    -- Remove existing BodyVelocity
    if hrp:FindFirstChild("FlyForce") then
        hrp.FlyForce:Destroy()
    end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Name = "FlyForce"
    flyBodyVelocity.Parent = hrp
    
    -- Flying movement
    flyConnection = RunService.Heartbeat:Connect(function()
        if flingEnabled and hrp and hrp.Parent and flyBodyVelocity then
            local moveVec = Vector3.new()
            local cam = workspace.CurrentCamera
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVec = moveVec + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVec = moveVec - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVec = moveVec - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVec = moveVec + cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                moveVec = moveVec + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                moveVec = moveVec - Vector3.new(0, 1, 0)
            end
            
            if moveVec.Magnitude > 0 then
                flyBodyVelocity.Velocity = moveVec.Unit * flySpeed
            else
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

local function stopFlying()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if hrp and hrp:FindFirstChild("FlyForce") then
        hrp.FlyForce:Destroy()
    end
    flyBodyVelocity = nil
end

-- ========== FLING FUNCTIONS ==========
local function startFling()
    if not hrp or not hrp.Parent then return end
    
    -- Fling rotation
    flingConnection = RunService.Heartbeat:Connect(function()
        if flingEnabled and hrp and hrp.Parent then
            hrp.AssemblyAngularVelocity = Vector3.new(0, flingPower, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function stopFling()
    if flingConnection then
        flingConnection:Disconnect()
        flingConnection = nil
    end
    if hrp then
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end

-- ========== TOGGLE FLING ==========
local function toggleFling()
    flingEnabled = not flingEnabled
    
    if flingEnabled then
        -- Make character invisible
        makeInvisible(character)
        
        -- Start flying and flinging
        startFlying()
        startFling()
        
        -- Handle character respawn
        LocalPlayer.CharacterAdded:Connect(function(newChar)
            character = newChar
            hrp = character:WaitForChild("HumanoidRootPart")
            if flingEnabled then
                task.wait(0.5)
                makeInvisible(character)
                startFlying()
                startFling()
            end
        end)
        
        notify("Invis Fling", "✓ ENABLED (Power: " .. flingPower .. ")", 2)
    else
        -- Make character visible
        makeVisible(character)
        
        -- Stop flying and flinging
        stopFlying()
        stopFling()
        
        notify("Invis Fling", "✗ DISABLED", 2)
    end
end

-- ========== SET FLING POWER ==========
local function setFlingPower(power)
    flingPower = power
    notify("Fling Power", "Set to " .. flingPower, 1)
end

local function cycleFlingPower()
    powerIndex = powerIndex % #powerLevels + 1
    flingPower = powerLevels[powerIndex]
    notify("Fling Power", "Set to " .. flingPower, 1)
    return flingPower
end

-- ========== SET FLY SPEED ==========
local function setFlySpeed(speed)
    flySpeed = speed
    notify("Fly Speed", "Set to " .. flySpeed, 1)
end

-- ========== BLUR EFFECT FUNCTIONS ==========
local blurEffect = nil

local function createBlurEffect()
    if not Lighting:FindFirstChild("InvisFlingBlur") then
        blurEffect = Instance.new("BlurEffect")
        blurEffect.Name = "InvisFlingBlur"
        blurEffect.Size = 0
        blurEffect.Parent = Lighting
    else
        blurEffect = Lighting.InvisFlingBlur
    end
end

local function setBlur(enabled)
    createBlurEffect()
    if enabled then
        blurEffect.Size = 10
    else
        blurEffect.Size = 0
    end
end

-- ========== RAYFIELD GUI ==========
local Window = Rayfield:CreateWindow({
    Name = "Invis Fling",
    Icon = 0,
    LoadingTitle = "Invis Fling",
    LoadingSubtitle = "By HilosHAX",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "InvisFling",
        FileName = "Config"
    },
    KeySystem = false
})

-- ========== MAIN TAB ==========
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Control")

-- Fling Toggle Button
MainTab:CreateButton({
    Name = flingEnabled and "🟢 DISABLE INVIS FLING" or "🔴 ENABLE INVIS FLING",
    Callback = function()
        toggleFling()
        local btn = Rayfield:GetButton("FlingToggle")
        if btn then
            btn:Set(flingEnabled and "🟢 DISABLE INVIS FLING" or "🔴 ENABLE INVIS FLING")
        end
    end,
    Flag = "FlingToggle"
})

-- Status Display
MainTab:CreateParagraph({
    Title = "Status",
    Content = string.format([[
Fling Status: %s
Fling Power: %d
Fly Speed: %d

Controls:
• WASD - Move
• Q - Fly Up
• E - Fly Down
]], flingEnabled and "✅ ACTIVE" or "❌ INACTIVE",
   flingPower,
   flySpeed)
})

-- ========== SETTINGS TAB ==========
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Fling Settings
SettingsTab:CreateSection("Fling Settings")

-- Power Slider
SettingsTab:CreateSlider({
    Name = "Fling Power",
    Range = {1000, 100000},
    Increment = 1000,
    CurrentValue = flingPower,
    Flag = "PowerSlider",
    Callback = setFlingPower
})

-- Power Presets
SettingsTab:CreateSection("Power Presets")

SettingsTab:CreateButton({
    Name = "💪 5,000 (Normal)",
    Callback = function()
        setFlingPower(5000)
        Rayfield:Set("PowerSlider", 5000)
    end
})

SettingsTab:CreateButton({
    Name = "⚡ 10,000 (Strong)",
    Callback = function()
        setFlingPower(10000)
        Rayfield:Set("PowerSlider", 10000)
    end
})

SettingsTab:CreateButton({
    Name = "🔥 20,000 (Mega)",
    Callback = function()
        setFlingPower(20000)
        Rayfield:Set("PowerSlider", 20000)
    end
})

SettingsTab:CreateButton({
    Name = "💥 30,000 (Ultra)",
    Callback = function()
        setFlingPower(30000)
        Rayfield:Set("PowerSlider", 30000)
    end
})

SettingsTab:CreateButton({
    Name = "🌪️ 50,000 (Insane)",
    Callback = function()
        setFlingPower(50000)
        Rayfield:Set("PowerSlider", 50000)
    end
})

SettingsTab:CreateButton({
    Name = "🔄 Cycle Power (Click)",
    Callback = function()
        local newPower = cycleFlingPower()
        Rayfield:Set("PowerSlider", newPower)
    end
})

-- Fly Settings
SettingsTab:CreateSection("Fly Settings")

SettingsTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = flySpeed,
    Flag = "FlySpeedSlider",
    Callback = setFlySpeed
})

-- ========== INFO TAB ==========
local InfoTab = Window:CreateTab("Info", 4483362458)

InfoTab:CreateSection("About")

InfoTab:CreateParagraph({
    Title = "Invis Fling Script",
    Content = [[
Version: 2.0 (Rayfield Edition)
Original by: HilosHAX

DESCRIPTION:
This script makes you invisible and allows you to fling yourself across the map at high speeds!

FEATURES:
✓ Invisibility (Parts + Decals)
✓ Fling with adjustable power
✓ Fly with WASD + Q/E
✓ Blur effect when hovering GUI (Original feature)
✓ Customizable fly speed

HOW TO USE:
1. Press "ENABLE INVIS FLING"
2. You become invisible and start flinging
3. Use WASD to fly around
4. Use Q/E to go up/down
5. Adjust power for more fling strength

CONTROLS:
• INSERT - Open/Close Menu
• WASD - Fly Movement
• Q - Fly Up
• E - Fly Down
]]
})

InfoTab:CreateSection("Credits")

InfoTab:CreateParagraph({
    Title = "Credits",
    Content = [[
Original Script: HilosHAX
Rayfield Conversion: Request
Version: 2.0

Sound effect included (click sound)
Blur effect on GUI hover
]]
})

-- ========== BLUR EFFECT ON HOVER (Original Feature) ==========
createBlurEffect()

-- Create a fake frame for hover detection (since Rayfield doesn't have direct hover)
local hoverFrame = Instance.new("Frame")
hoverFrame.Size = UDim2.new(0, 0, 0, 0)
hoverFrame.BackgroundTransparency = 1
hoverFrame.Parent = CoreGui

-- Track if mouse is over Rayfield window (approximate)
local function onWindowHover(isHovering)
    setBlur(isHovering)
end

-- Simple hover detection using mouse position
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        -- Check if mouse is over Rayfield window (approximate area)
        local rayfieldWindows = CoreGui:FindFirstChild("Rayfield")
        if rayfieldWindows then
            local window = rayfieldWindows:FindFirstChild("MainFrame")
            if window and window.AbsolutePosition then
                local pos = window.AbsolutePosition
                local size = window.AbsoluteSize
                local isOver = mousePos.X >= pos.X and mousePos.X <= pos.X + size.X and
                              mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y
                setBlur(isOver)
            end
        end
    end
end)

-- ========== CHARACTER RESPAWN HANDLER ==========
LocalPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    hrp = character:WaitForChild("HumanoidRootPart")
    
    if flingEnabled then
        task.wait(0.5)
        makeInvisible(character)
        startFlying()
        startFling()
    end
end)

-- ========== CLEANUP ON UNLOAD ==========
local function cleanup()
    flingEnabled = false
    
    stopFlying()
    stopFling()
    
    if character then
        makeVisible(character)
    end
    
    if blurEffect then
        blurEffect:Destroy()
    end
    
    if hrp then
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
    
    getgenv().INVIS_FLING_LOADED = false
    notify("Invis Fling", "Script unloaded!", 2)
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Home then
        cleanup()
    end
end)

-- ========== KEYBINDS ==========
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F key to toggle fling
    if input.KeyCode == Enum.KeyCode.F then
        toggleFling()
        local btn = Rayfield:GetButton("FlingToggle")
        if btn then
            btn:Set(flingEnabled and "🟢 DISABLE INVIS FLING" or "🔴 ENABLE INVIS FLING")
        end
    end
    
    -- R key to cycle power
    if input.KeyCode == Enum.KeyCode.R then
        local newPower = cycleFlingPower()
        Rayfield:Set("PowerSlider", newPower)
    end
end)

-- ========== CLICK SOUND (Original Feature) ==========
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://9118828560"
clickSound.Volume = 2
clickSound.Parent = CoreGui

local function playClickSound()
    pcall(function()
        clickSound:Play()
    end)
end

-- Override button clicks to play sound (optional)
-- This will play sound when Rayfield buttons are clicked
local oldNotify = Rayfield.Notify
Rayfield.Notify = function(...)
    playClickSound()
    return oldNotify(...)
end

-- ========== INITIAL NOTIFICATION ==========
notify("Invis Fling", "Loaded! Press INSERT for menu | F = Toggle | R = Cycle Power", 5)
print("=== Invis Fling Script Loaded ===")
print("Original by: HilosHAX")
print("Press INSERT for Rayfield menu")
print("Keybinds: F = Toggle Fling | R = Cycle Power | WASD+Q/E = Fly")
