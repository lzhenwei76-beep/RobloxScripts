debugX = true

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/lzhenwei76-beep/RayfieldCopy/refs/heads/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Super Ring Parts V6",
    Icon = 0,
    LoadingTitle = "Super Ring Parts V6",
    LoadingSubtitle = "by lukas",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SuperRingParts",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- ========== SOUND EFFECTS ==========
local SoundService = game:GetService("SoundService")

local function playSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- Play initial sound
playSound("2865227271")

-- ========== KONFIGURATION ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local config = {
    radius = 50,
    height = 100,
    rotationSpeed = 10,
    attractionStrength = 1000,
}

-- ========== SAVE/LOAD FUNKTIONEN ==========
local HttpService = game:GetService("HttpService")

local function saveConfig()
    local configStr = HttpService:JSONEncode(config)
    writefile("SuperRingPartsConfig.txt", configStr)
end

local function loadConfig()
    if isfile("SuperRingPartsConfig.txt") then
        local configStr = readfile("SuperRingPartsConfig.txt")
        config = HttpService:JSONDecode(configStr)
    end
end

loadConfig()

-- ========== RING PARTS LOGIK (Original) ==========
local Workspace = game:GetService("Workspace")
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
    }

    Network.RetainPart = function(Part)
        if typeof(Part) == "Instance" and Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, Part)
            Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            Part.CanCollide = false
        end
    end

    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            for _, Part in pairs(Network.BaseParts) do
                if Part:IsDescendantOf(Workspace) then
                    Part.Velocity = Network.Velocity
                end
            end
        end)
    end

    EnablePartControl()
end

local function ForcePart(v)
    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in next, v:GetChildren() do
            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        if v:FindFirstChild("Attachment") then
            v:FindFirstChild("Attachment"):Destroy()
        end
        if v:FindFirstChild("AlignPosition") then
            v:FindFirstChild("AlignPosition"):Destroy()
        end
        if v:FindFirstChild("Torque") then
            v:FindFirstChild("Torque"):Destroy()
        end
        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = 9999999999999999999999999999999
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 200
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

local ringPartsEnabled = false

local function RetainPart(Part)
    if Part:IsA("BasePart") and not Part.Anchored and Part:IsDescendantOf(workspace) then
        if Part.Parent == LocalPlayer.Character or Part:IsDescendantOf(LocalPlayer.Character) then
            return false
        end
        Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
        Part.CanCollide = false
        return true
    end
    return false
end

local parts = {}
local function addPart(part)
    if RetainPart(part) then
        if not table.find(parts, part) then
            table.insert(parts, part)
        end
    end
end

local function removePart(part)
    local index = table.find(parts, part)
    if index then
        table.remove(parts, index)
    end
end

for _, part in pairs(workspace:GetDescendants()) do
    addPart(part)
end

workspace.DescendantAdded:Connect(addPart)
workspace.DescendantRemoving:Connect(removePart)

RunService.Heartbeat:Connect(function()
    if not ringPartsEnabled then return end

    local humanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local tornadoCenter = humanoidRootPart.Position
        for _, part in pairs(parts) do
            if part.Parent and not part.Anchored then
                local pos = part.Position
                local distance = (Vector3.new(pos.X, tornadoCenter.Y, pos.Z) - tornadoCenter).Magnitude
                local angle = math.atan2(pos.Z - tornadoCenter.Z, pos.X - tornadoCenter.X)
                local newAngle = angle + math.rad(config.rotationSpeed)
                local targetPos = Vector3.new(
                    tornadoCenter.X + math.cos(newAngle) * math.min(config.radius, distance),
                    tornadoCenter.Y + (config.height * (math.abs(math.sin((pos.Y - tornadoCenter.Y) / config.height)))),
                    tornadoCenter.Z + math.sin(newAngle) * math.min(config.radius, distance)
                )
                local directionToTarget = (targetPos - part.Position).unit
                part.Velocity = directionToTarget * config.attractionStrength
            end
        end
    end
end)

-- ========== RAYFIELD GUI TABS ==========

-- Main Tab
local MainTab = Window:CreateTab("Tornado", 4483362458)

-- Tornado Section
local TornadoSection = MainTab:CreateSection("Tornado Control")

-- Toggle: Tornado On/Off
MainTab:CreateToggle({
    Name = "🌪️ Tornado Mode",
    CurrentValue = false,
    Flag = "TornadoToggle",
    Callback = function(Value)
        ringPartsEnabled = Value
        playSound("12221967")
    end,
})

-- Settings Section
local SettingsSection = MainTab:CreateSection("Tornado Settings")

-- Slider: Radius
MainTab:CreateSlider({
    Name = "Radius",
    Range = {0, 500},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = config.radius,
    Flag = "Radius",
    Callback = function(Value)
        config.radius = Value
        saveConfig()
        playSound("12221967")
    end,
})

-- Slider: Height
MainTab:CreateSlider({
    Name = "Height",
    Range = {0, 500},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = config.height,
    Flag = "Height",
    Callback = function(Value)
        config.height = Value
        saveConfig()
        playSound("12221967")
    end,
})

-- Slider: Rotation Speed
MainTab:CreateSlider({
    Name = "Rotation Speed",
    Range = {0, 100},
    Increment = 5,
    Suffix = " deg/s",
    CurrentValue = config.rotationSpeed,
    Flag = "RotationSpeed",
    Callback = function(Value)
        config.rotationSpeed = Value
        saveConfig()
        playSound("12221967")
    end,
})

-- Slider: Attraction Strength
MainTab:CreateSlider({
    Name = "Attraction Strength",
    Range = {0, 5000},
    Increment = 50,
    Suffix = "",
    CurrentValue = config.attractionStrength,
    Flag = "AttractionStrength",
    Callback = function(Value)
        config.attractionStrength = Value
        saveConfig()
        playSound("12221967")
    end,
})

-- ========== UTILITIES TAB ==========
local UtilitiesTab = Window:CreateTab("Utilities", 4483362458)

local PlayerSection = UtilitiesTab:CreateSection("Player Mods")

-- Button: Fly GUI
UtilitiesTab:CreateButton({
    Name = "🕊️ Fly GUI",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/YSL3xKYU'))()
        playSound("12221967")
    end,
})

-- Button: No Fall Damage
UtilitiesTab:CreateButton({
    Name = "🪶 No Fall Damage",
    Callback = function()
        local runsvc = game:GetService("RunService")
        local heartbeat = runsvc.Heartbeat
        local rstepped = runsvc.RenderStepped
        local lp = game.Players.LocalPlayer
        local novel = Vector3.zero

        local function nofalldamage(chr)
            local root = chr:WaitForChild("HumanoidRootPart")
            if root then
                local con
                con = heartbeat:Connect(function()
                    if not root.Parent then
                        con:Disconnect()
                    end
                    local oldvel = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = novel
                    rstepped:Wait()
                    root.AssemblyLinearVelocity = oldvel
                end)
            end
        end

        nofalldamage(lp.Character)
        lp.CharacterAdded:Connect(nofalldamage)
        playSound("12221967")
    end,
})

-- Button: Noclip
local noclipActive = false
local noclipConnection = nil

UtilitiesTab:CreateButton({
    Name = "🔓 Noclip",
    Callback = function()
        if noclipActive then
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            noclipActive = false
            -- Clip wieder aktivieren
            if game.Players.LocalPlayer.Character then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA('BasePart') then
                        v.CanCollide = true
                    end
                end
            end
        else
            noclipActive = true
            local function Nocl()
                if game.Players.LocalPlayer.Character then
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA('BasePart') then
                            v.CanCollide = false
                        end
                    end
                end
            end
            noclipConnection = game:GetService('RunService').Stepped:Connect(Nocl)
        end
        playSound("12221967")
    end,
})

-- Button: Infinite Jump
local infiniteJumpEnabled = false
local jumpConnection = nil

UtilitiesTab:CreateButton({
    Name = "🦘 Infinite Jump",
    Callback = function()
        if infiniteJumpEnabled then
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
            infiniteJumpEnabled = false
        else
            infiniteJumpEnabled = true
            jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if infiniteJumpEnabled then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
                end
            end)
        end
        playSound("12221967")
    end,
})

-- ========== ADMIN SCRIPTS TAB ==========
local AdminTab = Window:CreateTab("Admin", 4483362458)

local AdminSection = AdminTab:CreateSection("Admin Scripts")

-- Button: Infinite Yield
AdminTab:CreateButton({
    Name = "⚡ Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        playSound("12221967")
    end,
})

-- Button: Nameless Admin
AdminTab:CreateButton({
    Name = "👑 Nameless Admin",
    Callback = function()
        loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Nameless-Admin-FE-11243"))()
        playSound("12221967")
    end,
})
-- Button: FPS Boost
AdminTab:CreateButton({
    Name = "📈 FPS Boost",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/ySHJdZpb", true))()
        playSound("12221967")
    end,
})

-- ========== INFO TAB ==========
local InfoTab = Window:CreateTab("Info", 4483362458)

local InfoSection = InfoTab:CreateSection("About")

InfoTab:CreateParagraph({
    Title = "Super Ring Parts V6",
    Content = "by lzhenwei\n\nFeatures:\n• Tornado that attracts parts\n• Customizable radius, height, speed\n• Fly GUI\n• No Fall Damage\n• Noclip\n• Infinite Jump\n• Admin Scripts\n• FPS Boost\n\nAll settings are automatically saved!"
})

-- ========== NOTIFICATION BEIM START ==========
local StarterGui = game:GetService("StarterGui")

-- Get player thumbnail for notifications
local userId = nil
pcall(function()
    userId = Players:GetUserIdFromNameAsync("Robloxlukasgames")
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    
    StarterGui:SetCore("SendNotification", {
        Title = "Super Ring Parts V6",
        Text = "Script loaded! Press INSERT to open menu",
        Icon = content,
        Duration = 5
    })
end)

-- Fallback notification
task.wait(1)
Rayfield:Notify({
    Title = "Super Ring Parts V6",
    Content = "Script loaded! Press INSERT to open menu",
    Duration = 3
})

print("Super Ring Parts V6 loaded! Press INSERT to open Rayfield menu")
print("Features: Tornado Mode | Fly GUI | No Fall Damage | Noclip | Infinite Jump | Admin Scripts")
