-- Carrega Obsidian UI

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()

local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- nooo

local Window = Library:CreateWindow({

Title = "NOT HUB",

Footer = "v7.40.39 [BETA HUB]",

Icon = 95816097006870,

NotifySide = "Right",

ShowCustomCursor = true,

})

-- principal

local MainTab = Window:AddTab("Main", "house")

-- Função de teleporte

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Workspace = game:GetService("Workspace")

local function teleportToCFrame(cframe)

if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

LocalPlayer.Character.HumanoidRootPart.CFrame = cframe

end

end

-- Criação de GroupBoxes 2x2

local GroupBoxes = {}

local names = {

"Auto Play","Random Features","F2P FEATURES","Red Light, Green Light",

"Dalgona","Lights Out / Special Game","Hide 'N' Seek","Tug Of War",

"JumpRope","Glass bridge","Mingle","Final Dinner",

"Sky Squid Game","Squid Game","Rebel Features"

}

-- Alternando entre left e right para layout 2x2

for i, name in ipairs(names) do

if i % 2 == 1 then

GroupBoxes[name] = MainTab:AddLeftGroupbox(name)

else

GroupBoxes[name] = MainTab:AddRightGroupbox(name)

end

end

-- ============================

-- Exemplo de botões e toggles

-- ============================

-- JumpRope

GroupBoxes["JumpRope"]:AddButton({

Text = "TP End",

Tooltip = "Quickly teleport to the end location.",

Func = function()

teleportToCFrame(CFrame.new(737.156372, 193.805084, 920.952515))

end

})

GroupBoxes["JumpRope"]:AddButton({

Text = "TP Start",

Tooltip = "Instantly teleport back to the start point.",

Func = function()

teleportToCFrame(CFrame.new(615.284424, 192.274277, 920.952515))

end

})

-- Glass bridge

GroupBoxes["Glass bridge"]:AddButton({

Text = "TP END",

Tooltip = "Teleport instantly to the END location.",

Func = function()

teleportToCFrame(CFrame.new(-211.855881, 517.039062, -1534.7373))

end

})

  

  -- Hide 'N' Seek: Auto Kill

GroupBoxes["Hide 'N' Seek"]:AddToggle("AUTO KILL HIDE", {

    Text = "AUTO KILL HIDE",

    Callback = function(Value)

        AutoKillEnabled = Value

        if FollowConnection then

            FollowConnection:Disconnect()

            FollowConnection = nil

        end

        if AutoKillEnabled then

            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                HRP = LocalPlayer.Character.HumanoidRootPart

                local targetPlayer = nil

                for _, player in ipairs(Players:GetPlayers()) do

                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("BlueVest") then

                        targetPlayer = player

                        break

                    end

                end

                if targetPlayer and targetPlayer.Character then

                    local targetTorso = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

                        or targetPlayer.Character:FindFirstChild("UpperTorso")

                    if targetTorso then

                        FollowConnection = RunService.RenderStepped:Connect(function()

                            if AutoKillEnabled and targetPlayer.Character and targetTorso and HRP and HRP.Parent then

                                local frontPos = targetTorso.CFrame * CFrame.new(0,0,-5)

                                HRP.CFrame = frontPos

                            end

                        end)

                    end

                end

            end

        end

    end

})

-- Hide 'N' Seek: TP Exit Door

GroupBoxes["Hide 'N' Seek"]:AddButton({

Text = "TP EXIT DOOR",

Tooltip = "Teleports to the nearest exit door.",

Func = function()

local player = LocalPlayer

if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

local hrp = player.Character.HumanoidRootPart

local map = Workspace:WaitForChild("HideAndSeekMap")

local newDoors = map:WaitForChild("NEWFIXEDDOORS")

local closestDoor = nil

local shortestDistance = math.huge

for _, floor in ipairs(newDoors:GetChildren()) do

local exitFolder = floor:FindFirstChild("EXITDOORS")

if exitFolder then

for _, door in ipairs(exitFolder:GetChildren()) do

if door:GetAttribute("ActuallyWorks") then

local primary = door.PrimaryPart or door:FindFirstChild("DoorRoot")

if primary then

local distance = (hrp.Position - primary.Position).Magnitude

if distance < shortestDistance then

shortestDistance = distance

closestDoor = primary

end

end

end

end

end

end

if closestDoor then

local targetCFrame = closestDoor.CFrame + closestDoor.CFrame.LookVector * 3

hrp.CFrame = CFrame.new(targetCFrame.Position, closestDoor.Position)

else

warn("Nenhuma porta funcional encontrada!")

end

end

})

-- Teleporte PERBET (Dropdown)

GroupBoxes["Random Features"]:AddDropdown("TeleportPerbetDropdown", {

  

    Text = "TP PERBET",

    Values = { "none", "PERBET 1", "PERBET 2", "PERBET 3", "PERBET 4", "PERBET 5", "PERBET 6" },

    Value = "none",

    Callback = function(option)

        local Positions = {

            ["none"] = nil,

            ["PERBET 1"] = "FREEPEABERT1",

            ["PERBET 2"] = "FREEPEABERT2",

            ["PERBET 3"] = "FREEPEABERT3",

            ["PERBET 4"] = "FREEPEABERT4",

            ["PERBET 5"] = "FREEPEABERT5",

            ["PERBET 6"] = "FREEPEABERT6",

        }

        local targetName = Positions[option]

        if targetName then

            local obj = workspace:FindFirstChild(targetName)

            local cframe = (obj and ((obj.PrimaryPart and obj.PrimaryPart.CFrame) or (obj:IsA("BasePart") and obj.CFrame))) or nil

            if cframe then

                LocalPlayer.Character.HumanoidRootPart.CFrame = cframe

                print("Teleported to: " .. option)

            else

                warn("❌ Não encontrei o objeto no workspace: " .. targetName)

            end

        else

            print("Nenhuma posição selecionada.")

        end

    end

})

-- AUTO SKIP

local autoSkipEnabled = false

GroupBoxes["Random Features"]:AddToggle("AutoSkipToggle", {

    Text = "AUTO SKIP",

    Callback = function(state)

        autoSkipEnabled = state

        if state then

            spawn(function()

                while autoSkipEnabled do

                    local args = {"Skipped"}

                    pcall(function()

                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DialogueRemote"):FireServer(unpack(args))

                    end)

                    wait(0.5)

                end

            end)

        end

    end

})

-- AUTO PULL

local AutoPullEnabled = false

local function AutoPull()

    local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TemporaryReachedBindable")

    Remote:FireServer({{ IHateYou = true }})

end

game:GetService("RunService").Heartbeat:Connect(function()

    if AutoPullEnabled then AutoPull() end

end)

GroupBoxes["Tug Of War"]:AddToggle("AutoPullToggle", {

    Text = "AUTO PULL",

    Callback = function(state) AutoPullEnabled = state end

})

-- Phantom Step

local originalPower = LocalPlayer:GetAttribute("_EquippedPower")

GroupBoxes["F2P FEATURES"]:AddToggle("PhantomStepToggle", {

    Text = "Phantom Step",

    Callback = function(state)

        if state then

            LocalPlayer:SetAttribute("_EquippedPower", "PHANTOM STEP")

            print("Phantom Step On")

        else

            LocalPlayer:SetAttribute("_EquippedPower", originalPower)

            print("Phantom Step Off")

        end

    end

})

-- Dash

local function toggleFasterSprint(state)

    local boostsFolder = LocalPlayer:FindFirstChild("Boosts")

    if not boostsFolder then return warn("Boosts not found") end

    local sprintBoost = boostsFolder:FindFirstChild("Faster Sprint")

    if not sprintBoost or not sprintBoost:IsA("NumberValue") then return warn("Faster Sprint not found") end

    sprintBoost.Value = state and 5 or 0

    print("Faster Sprint " .. (state and "On" or "Off"))

end

GroupBoxes["F2P FEATURES"]:AddToggle("DashToggle", {

    Text = "Dash",

    Callback = function(state) toggleFasterSprint(state) end

})

-- Parkour Artist

GroupBoxes["F2P FEATURES"]:AddToggle("ParkourArtistToggle", {

    Text = "Parkour Artist",

    Callback = function(state)

        if state then

            LocalPlayer:SetAttribute("_EquippedPower", "PARKOUR ARTIST")

            print("Parkour Artist On")

        else

            LocalPlayer:SetAttribute("_EquippedPower", originalPower)

            print("Parkour Artist Off")

        end

    end

})

-- Glass Platforms

local showGlassPlatforms = false

local glassPlatforms = {}

local function isFakeGlass(part) return part:GetAttribute("GlassPart") and part:GetAttribute("ActuallyKilling") ~= nil end

local function createPlatforms()

    for _, platform in ipairs(glassPlatforms) do if platform and platform.Parent then platform:Destroy() end end

    glassPlatforms = {}

    for _, part in ipairs(workspace:GetDescendants()) do

        if part:IsA("BasePart") and isFakeGlass(part) then

            local platform = Instance.new("Part")

            platform.Size = Vector3.new(10,0.5,10)

            platform.CFrame = part.CFrame * CFrame.new(0,2,0)

            platform.Anchored = true

            platform.CanCollide = true

            platform.Transparency = 0.3

            platform.Material = Enum.Material.Neon

            platform.Color = Color3.fromRGB(255,0,0)

            platform.Parent = workspace

            table.insert(glassPlatforms, platform)

        end

    end

end

local function removePlatforms()

    for _, platform in ipairs(glassPlatforms) do if platform and platform.Parent then platform:Destroy() end end

    glassPlatforms = {}

end

GroupBoxes["Glass bridge"]:AddToggle("GlassPlatformsToggle", {

    Text = "Glass Platforms",

    Callback = function(state)

        showGlassPlatforms = state

        if state then

            task.spawn(function()

                while showGlassPlatforms do

                    createPlatforms()

                    task.wait(1)

                end

            end)

        else

            removePlatforms()

        end

    end

})

-- Serviços necessários

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local RunService = game:GetService("RunService")

local Workspace = game:GetService("Workspace")

-- Variáveis globais

local showGlassESP = false

local BoxParts = {}

local BoxEnabled = false

-- Função para teleporte

local function teleportTo(cframe)

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    local hrp = character:WaitForChild("HumanoidRootPart")

    hrp.CFrame = cframe + Vector3.new(0, 10, 0)

end

-- ===============================

-- 🟩 GLASS BRIDGE

-- ===============================

GroupBoxes["Glass bridge"]:AddToggle("GlassVision", {

    Text = "Glass Vision",

    Default = false,

    Tooltip = "Show Fake Glass n Real Glass.",

    Callback = function(Value)

        showGlassESP = Value

        local function isRealGlass(part)

            if part:GetAttribute("GlassPart") then

                if part:GetAttribute("ActuallyKilling") ~= nil then

                    return false -- falso

                end

                return true -- real

            end

            return false

        end

        local function updateGlassColors()

            for _, part in ipairs(workspace:GetDescendants()) do

                if part:IsA("BasePart") and part:GetAttribute("GlassPart") then

                    if showGlassESP then

                        if isRealGlass(part) then

                            part.Color = Color3.fromRGB(0, 255, 0) -- verde real

                        else

                            part.Color = Color3.fromRGB(255, 0, 0) -- vermelho falso

                        end

                        part.Material = Enum.Material.Neon

                        part:SetAttribute("ExploitingIsEvil", true)

                    else

                        part.Color = Color3.fromRGB(163, 162, 165)

                        part.Material = Enum.Material.Glass

                        part:SetAttribute("ExploitingIsEvil", nil)

                    end

                end

            end

        end

        if Value then

            task.spawn(function()

                while showGlassESP do

                    updateGlassColors()

                    task.wait(0.5)

                end

            end)

        else

            updateGlassColors()

        end

    end

})

-- ===============================

-- 🟦 RANDOM FEATURES

-- ===============================

-- TP Bandage

GroupBoxes["Random Features"]:AddButton({

    Text = "TP Bandage",

    Tooltip = "TP BANDAGE and pick he.",

    Func = function()

        local function getClosestBandage()

            local character = LocalPlayer.Character

            if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

            local hrp = character.HumanoidRootPart

            local closest, minDistance = nil, math.huge

            for _, bandage in ipairs(Workspace.Effects:GetChildren()) do

                if bandage.Name == "DroppedBandage" and bandage:IsA("Model") then

                    local primary = bandage.PrimaryPart or bandage:FindFirstChildWhichIsA("BasePart")

                    if primary then

                        local distance = (hrp.Position - primary.Position).Magnitude

                        if distance < minDistance then

                            minDistance = distance

                            closest = bandage

                        end

                    end

                end

            end

            return closest

        end

        local character = LocalPlayer.Character

        if not character or not character:FindFirstChild("HumanoidRootPart") then return end

        local hrp = character.HumanoidRootPart

        local originalPosition = hrp.CFrame

        local bandage = getClosestBandage()

        if bandage then

            local primary = bandage.PrimaryPart or bandage:FindFirstChildWhichIsA("BasePart")

            if primary then

                hrp.CFrame = primary.CFrame + Vector3.new(0, 3, 0)

                task.wait(0.5)

                hrp.CFrame = originalPosition

            end

        else

            warn("No DroppedBandage found!")

        end

    end

})

-- Input Swing Speed

GroupBoxes["Random Features"]:AddInput("SwingSpeedInput", {

    Text = "Speed",

    Default = "10",

    Tooltip = "Bypassed speed unpatched. ",

    Placeholder = "Enter speed (0-50)...",

    Callback = function(input)

        local value = tonumber(input)

        if not value then

            warn("Invalid input, enter a number!")

            return

        end

        if value < 0 then

            value = 0

        elseif value > 50 then

            value = 50

        end

        local liveFolder = workspace:WaitForChild("Live")

        local playerModel = liveFolder:WaitForChild(LocalPlayer.Name)

        local swingSpeed = playerModel:FindFirstChild("SwingSpeed")

        if swingSpeed and swingSpeed:IsA("NumberValue") then

            swingSpeed.Value = value

            print("Swing Speed set to:", value)

        else

            warn("SwingSpeed not found or invalid for this player!")

        end

    end

})

-- ===============================

-- 🟥 RED LIGHT, GREEN LIGHT

-- ===============================

GroupBoxes["Red Light, Green Light"]:AddButton({

    Text = "TP START",

    Tooltip = "TP START of rlgl.",

    Func = function()

        teleportTo(CFrame.new(-49.8884354, 1020.104, -512.157776))

    end

})

GroupBoxes["Red Light, Green Light"]:AddButton({

    Text = "TP SAFE PLACE",

    Tooltip = "TP SAFE PLACE in rlgl.",

    Func = function()

        teleportTo(CFrame.new(197.452408, 51.3870239, -95.6055298))

    end

})

-- ===============================

-- 💡 LIGHTS OUT / SPECIAL GAME

-- ===============================

GroupBoxes["Lights Out / Special Game"]:AddButton({

    Text = "TP SAFE PLACE",

    Tooltip = "TP To a safe place.",

    Func = function()

        teleportTo(CFrame.new(195.255814, 112.202904, -85.3726807))

    end

})

-- ===============================

-- 🟧 MINGLE

-- ===============================

GroupBoxes["Mingle"]:AddButton({

    Text = "Bring Person Out",

    Tooltip = "Bring out a person.",

    Func = function()

        teleportTo(CFrame.new(1210.03967, 414.071106, -574.103088))

    end

})

-- ===============================

-- 🦑 SQUID GAME

-- ===============================

GroupBoxes["Squid Game"]:AddToggle("DontExitSquid", {

    Text = "DONT EXIT OF SQUID",

    Default = false,

    Callback = function(Value)

        BoxEnabled = Value

        for _, part in ipairs(BoxParts) do

            part:Destroy()

        end

        BoxParts = {}

        if Value then

            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

            local hrp = char:WaitForChild("HumanoidRootPart")

            local size = Vector3.new(50, 50, 50)

            local thickness = 3

            local function createWall(pos, size)

                local part = Instance.new("Part")

                part.Size = size

                part.Anchored = true

                part.CanCollide = true

                part.Transparency = 0.5

                part.Material = Enum.Material.ForceField

                part.Color = Color3.fromRGB(255, 0, 0)

                part.CFrame = hrp.CFrame:ToWorldSpace(CFrame.new(pos))

                part.Parent = Workspace

                table.insert(BoxParts, part)

            end

            createWall(Vector3.new(25, 0, 0), Vector3.new(thickness, size.Y, size.Z))

            createWall(Vector3.new(-25, 0, 0), Vector3.new(thickness, size.Y, size.Z))

            createWall(Vector3.new(0, 0, 25), Vector3.new(size.X, size.Y, thickness))

            createWall(Vector3.new(0, 0, -25), Vector3.new(size.X, size.Y, thickness))

            createWall(Vector3.new(0, 25, 0), Vector3.new(size.X, thickness, size.Z))

            createWall(Vector3.new(0, -25, 0), Vector3.new(size.X, thickness, size.Z))

        end

    end

})

-- Serviços

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local RunService = game:GetService("RunService")

local Workspace = game:GetService("Workspace")

-- Variáveis de controle

local AutoKillAllEnabled = false

local FollowAllConnection

local ActiveHighlights = {}

-- ===============================

-- 🟨 LIGHT TAB: AUTO KILL PLAYERS

-- ===============================

GroupBoxes["Lights Out / Special Game"]:AddToggle("AutoKillAll", {

    Text = "AUTO KILL PLAYERS",

    Tooltip = "Auto kill randoms players.",

    Default = false,

    Callback = function(Value)

        AutoKillAllEnabled = Value

        if FollowAllConnection then

            FollowAllConnection:Disconnect()

            FollowAllConnection = nil

        end

        if AutoKillAllEnabled then

            local character = LocalPlayer.Character

            if character and character:FindFirstChild("HumanoidRootPart") then

                local HRP = character.HumanoidRootPart

                FollowAllConnection = RunService.RenderStepped:Connect(function()

                    if not AutoKillAllEnabled or not HRP or not HRP.Parent then return end

                    local closestPlayer, shortestDistance = nil, math.huge

                    for _, player in ipairs(Players:GetPlayers()) do

                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then

                            local torso = player.Character:FindFirstChild("HumanoidRootPart")

                            if torso then

                                local distance = (HRP.Position - torso.Position).Magnitude

                                if distance < shortestDistance then

                                    shortestDistance = distance

                                    closestPlayer = player

                                end

                            end

                        end

                    end

                    if closestPlayer and closestPlayer.Character then

                        local targetTorso = closestPlayer.Character:FindFirstChild("HumanoidRootPart")

                            or closestPlayer.Character:FindFirstChild("UpperTorso")

                            or closestPlayer.Character:FindFirstChild("Torso")

                        if targetTorso then

                            HRP.CFrame = targetTorso.CFrame * CFrame.new(0, 0, -5)

                        end

                    end

                end)

            end

        end

    end

})

-- ===============================

-- 🟦 HIDE AND SEEK TAB: ESP EXITDOOR

-- ===============================

local function createHighlight(door)

    if ActiveHighlights[door] then return end

    local highlight = Instance.new("Highlight")

    highlight.Adornee = door

    highlight.FillColor = Color3.fromRGB(255, 255, 0)

    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)

    highlight.FillTransparency = 0.3

    highlight.Parent = door

    ActiveHighlights[door] = highlight

end

local function enableESP()

    local Map = Workspace:FindFirstChild("HideAndSeekMap")

    if not Map then return warn("⚠️ HideAndSeekMap não encontrado!") end

    local DoorsFolder = Map:FindFirstChild("NEWFIXEDDOORS")

    if not DoorsFolder then return warn("⚠️ NEWFIXEDDOORS não encontrado!") end

    for _, floor in ipairs(DoorsFolder:GetChildren()) do

        local exitDoors = floor:FindFirstChild("EXITDOORS")

        if exitDoors then

            for _, door in ipairs(exitDoors:GetChildren()) do

                if door:IsA("Model") and door:GetAttribute("ActuallyWorks") then

                    createHighlight(door)

                end

            end

        end

    end

end

local function disableESP()

    for door, highlight in pairs(ActiveHighlights) do

        if highlight and highlight.Parent then

            highlight:Destroy()

        end

        ActiveHighlights[door] = nil

    end

end

GroupBoxes["Hide 'N' Seek"]:AddToggle("ESPExitDoor", {

    Text = "ESP EXITDOOR",

    Default = false,

    Callback = function(Value)

        if Value then

            enableESP()

        else

            disableESP()

        end

    end

})

-- OBSIDIAN UI Script

-- Glass Bridge GroupBox

GroupBoxes["Hide 'N' Seek"]:AddToggle("TP KEY", {

    Text = "TP KEY",

    Callback = function(Value)

        local Players = game:GetService("Players")

        local Workspace = game:GetService("Workspace")

        local LocalPlayer = Players.LocalPlayer

        local Effects = Workspace:WaitForChild("Effects")

        local Teleporting = Value

        local function getModelCFrame(model)

            if model.PrimaryPart then

                return model.PrimaryPart.CFrame

            end

            for _, part in ipairs(model:GetDescendants()) do

                if part:IsA("BasePart") then

                    return part.CFrame

                end

            end

            return nil

        end

        local function teleportKeys()

            while Teleporting do

                task.wait(0.5)

                local char = LocalPlayer.Character

                if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

                local hrp = char.HumanoidRootPart

                local originalCFrame = hrp.CFrame

                for _, obj in ipairs(Effects:GetChildren()) do

                    if obj:IsA("Model") and (obj.Name == "DroppedKeyCircle" or obj.Name == "DroppedKeySquare" or obj.Name == "DroppedKeyTriangle") then

                        local keyCFrame = getModelCFrame(obj)

                        if keyCFrame then

                            hrp.CFrame = keyCFrame + Vector3.new(0,3,0)

                            task.wait(0.25)

                            hrp.CFrame = originalCFrame

                            task.wait(0.15)

                        end

                    end

                end

            end

        end

        if Teleporting then

            task.spawn(teleportKeys)

        end

    end

})

-- Red Light GroupBox

GroupBoxes["Random Features"]:AddToggle("AutoDodge", {

    Text = "AUTO DODGE",

    Callback = function(Value)

        local Players = game:GetService("Players")

        local LocalPlayer = Players.LocalPlayer

        local Workspace = game:GetService("Workspace")

        local AutoDodge = Value

        local humanoidRootPart

        local humanoid

        local DODGE_RANGE = 4

        local TELEPORT_HEIGHT = 75

        local THREATS = { "BOTTLE", "KNIFE", "FORK" }

        local function hasDodgeItem()

            local backpack = LocalPlayer:FindFirstChild("Backpack")

            if backpack and backpack:FindFirstChild("DODGE!") then

                return backpack:FindFirstChild("DODGE!")

            end

            local character = LocalPlayer.Character

            if character and character:FindFirstChild("DODGE!") then

                return character:FindFirstChild("DODGE!")

            end

            return nil

        end

        local function useDodgeItem()

            local dodgeTool = hasDodgeItem()

            if dodgeTool and dodgeTool:FindFirstChild("RemoteEvent") then

                pcall(function()

                    dodgeTool.RemoteEvent:FireServer()

                end)

                return true

            end

            return false

        end

        local function teleportUp()

            if humanoidRootPart then

                humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, TELEPORT_HEIGHT, 0)

            end

        end

        local function detectThreats()

            for _, player in ipairs(Players:GetPlayers()) do

                if player ~= LocalPlayer and player.Character then

                    local char = player.Character

                    local hrp = char:FindFirstChild("HumanoidRootPart")

                    if hrp and (hrp.Position - humanoidRootPart.Position).Magnitude <= DODGE_RANGE then

                        for _, tool in ipairs(char:GetChildren()) do

                            if tool:IsA("Tool") and table.find(THREATS, tool.Name:upper()) then

                                return true

                            end

                        end

                    end

                end

            end

            return false

        end

        local function startAutoDodge()

            task.spawn(function()

                while AutoDodge do

                    task.wait(0.15)

                    local char = LocalPlayer.Character

                    humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")

                    humanoid = char and char:FindFirstChildOfClass("Humanoid")

                    if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then continue end

                    if detectThreats() then

                        if not useDodgeItem() then

                            teleportUp()

                        end

                    end

                end

            end)

        end

        if AutoDodge then

            startAutoDodge()

        end

    end

})



-- Red Light GroupBox: Teleport Final

GroupBoxes["Red Light, Green Light"]:AddButton({

    Text = "TP END",

    Func = function()

        local Players = game:GetService("Players")

        local LocalPlayer = Players.LocalPlayer

        local Character = LocalPlayer.Character

        if Character and Character:FindFirstChild("HumanoidRootPart") then

            local targetCFrame = CFrame.new(-41.7126923, 1021.32306, 134.34935, 0.811150551, 0.237830803, 0.534295142, -8.95559788e-06, 0.913583994, -0.406650066, -0.584837377, 0.32984966, 0.741056323) + Vector3.new(0, 10, 0)

            Character.HumanoidRootPart.CFrame = targetCFrame

        end

    end

})

-- Hide 'N' Seek GroupBox: ESP EXITDOOR

GroupBoxes["Hide 'N' Seek"]:AddToggle("ESPExitDoor", {

    Text = "ESP EXITDOOR",

    Callback = function(Value)

        local Workspace = game:GetService("Workspace")

        local ActiveHighlights = {}

        local function createHighlight(door)

            if ActiveHighlights[door] then return end

            local highlight = Instance.new("Highlight")

            highlight.Adornee = door

            highlight.FillColor = Color3.fromRGB(255,255,0)

            highlight.OutlineColor = Color3.fromRGB(255,255,0)

            highlight.FillTransparency = 0.3

            highlight.Parent = door

            ActiveHighlights[door] = highlight

        end

        local function enableESP()

            local Map = Workspace:FindFirstChild("HideAndSeekMap")

            if not Map then return warn("⚠️ HideAndSeekMap não encontrado!") end

            local DoorsFolder = Map:FindFirstChild("NEWFIXEDDOORS")

            if not DoorsFolder then return warn("⚠️ NEWFIXEDDOORS não encontrado!") end

            for _, floor in ipairs(DoorsFolder:GetChildren()) do

                local exitDoors = floor:FindFirstChild("EXITDOORS")

                if exitDoors then

                    for _, door in ipairs(exitDoors:GetChildren()) do

                        if door:IsA("Model") and door:GetAttribute("ActuallyWorks") then

                            createHighlight(door)

                        end

                    end

                end

            end

        end

        local function disableESP()

            for door, highlight in pairs(ActiveHighlights) do

                if highlight and highlight.Parent then highlight:Destroy() end

                ActiveHighlights[door] = nil

            end

        end

        if Value then

            enableESP()

        else

            disableESP()

        end

    end

})

--========================

-- OBSIDIAN UI - GROUPBOX VERSION

--========================

-- RANDOM FEATURES

GroupBoxes["Random Features"]:AddToggle("InfJump", {

    Text = "Inf Jump",

    Callback = function(state)

        local UserInputService = game:GetService("UserInputService")

        local player = game.Players.LocalPlayer

        local InfiniteJumpEnabled = state

        UserInputService.JumpRequest:Connect(function()

            if InfiniteJumpEnabled then

                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.Parent then

                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                end

            end

        end)

    end

})

GroupBoxes["Random Features"]:AddToggle("InstaInteract", {

    Text = "Insta Interact",

    Callback = function(state)

        local InstaInteractEnabled = state

        local Players = game:GetService("Players")

        local LocalPlayer = Players.LocalPlayer

        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        LocalPlayer.CharacterAdded:Connect(function(char)

            Character = char

            HumanoidRootPart = char:WaitForChild("HumanoidRootPart")

        end)

        local function tornarPromptInstantaneo(prompt)

            if prompt:IsA("ProximityPrompt") then

                prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()

                    if InstaInteractEnabled then

                        prompt.HoldDuration = 0

                    end

                end)

                if InstaInteractEnabled then

                    prompt.HoldDuration = 0

                end

            end

        end

        for _, obj in pairs(workspace:GetDescendants()) do

            if obj:IsA("ProximityPrompt") then

                tornarPromptInstantaneo(obj)

            end

        end

        workspace.DescendantAdded:Connect(function(obj)

            if obj:IsA("ProximityPrompt") then

                tornarPromptInstantaneo(obj)

            end

        end)

        task.spawn(function()

            while task.wait(0.1) do

                if InstaInteractEnabled then

                    for _, prompt in pairs(workspace:GetDescendants()) do

                        if prompt:IsA("ProximityPrompt") and prompt.HoldDuration ~= 0 then

                            prompt.HoldDuration = 0

                        end

                    end

                end

            end

        end)

    end

})

GroupBoxes["Random Features"]:AddToggle("Noclip", {

    Text = "Noclip",

    Callback = function(state)

        local Players = game:GetService("Players")

        local RunService = game:GetService("RunService")

        local LocalPlayer = Players.LocalPlayer

        -- Desconecta caso já exista

        if getgenv().NoclipConnection then

            getgenv().NoclipConnection:Disconnect()

            getgenv().NoclipConnection = nil

            getgenv().NoclipEnabled = false

        end

        if state then

            getgenv().NoclipEnabled = true

            getgenv().NoclipConnection = RunService.Heartbeat:Connect(function()

                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                    local hrp = LocalPlayer.Character.HumanoidRootPart

                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do

                        if part:IsA("BasePart") then

                            -- Calcula a distância entre cada parte e o HumanoidRootPart

                            local distance = (part.Position - hrp.Position).Magnitude

                            if distance <= 100 then

                                part.CanCollide = false

                            else

                                part.CanCollide = true

                            end

                        end

                    end

                end

            end)

            -- Atualiza a cada 2 segundos

            spawn(function()

                while getgenv().NoclipEnabled do

                    wait(2)

                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

                        local hrp = LocalPlayer.Character.HumanoidRootPart

                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do

                            if part:IsA("BasePart") then

                                local distance = (part.Position - hrp.Position).Magnitude

                                if distance <= 100 then

                                    part.CanCollide = false

                                else

                                    part.CanCollide = true

                                end

                            end

                        end

                    end

                end

            end)

        end

    end

})

GroupBoxes["Sky Squid Game"]:AddToggle("Safe Platform", {

    Text = "Safe Platform",

    Callback = function(state)

        local LocalPlayer = game:GetService("Players").LocalPlayer

        if state then

            if not workspace:FindFirstChild("SafePlatform") then

                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

                local HRP = Character:WaitForChild("HumanoidRootPart")

                local SafePlatform = Instance.new("Part")

                SafePlatform.Name = "SafePlatform"

                SafePlatform.Size = Vector3.new(1000, 1, 1000)

                SafePlatform.Anchored = true

                SafePlatform.CanCollide = true

                SafePlatform.Transparency = 0.5

                SafePlatform.Material = Enum.Material.Neon

                SafePlatform.Color = Color3.fromRGB(0, 255, 0)

                SafePlatform.Position = HRP.Position - Vector3.new(0, 6, 0)

                SafePlatform.Parent = workspace

            end

        else

            local existing = workspace:FindFirstChild("SafePlatform")

            if existing then

                existing:Destroy()

            end

        end

    end

})

GroupBoxes["Hide 'N' Seek"]:AddToggle("Spike Kill", {

    Text = "Spike Kill",

    Callback = function(state)

        _G.AutoKnifeTeleport = state

        task.spawn(function()

            while _G.AutoKnifeTeleport and task.wait(0.1) do

                local Character = game.Players.LocalPlayer.Character

                if not Character then continue end

                local Humanoid = Character:FindFirstChild("Humanoid")

                local root = Character:FindFirstChild("HumanoidRootPart")

                if not Humanoid or not root then continue end

                for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do

                    if track.Name == "KnifeSwingBackStabChar" then

                        local originalCFrame = root.CFrame

                        root.CFrame = CFrame.new(101.50161, 972.146851, -6.17441177)

                        task.wait(2)

                        if not _G.AutoKnifeTeleport then break end

                        root.CFrame = originalCFrame

                    end

                end

            end

        end)

    end

})

--========================

-- JUMP ROPE FEATURES (ENGLISH VERSION)

--========================

-- [1] REMOVE ROPE - simple button

GroupBoxes["JumpRope"]:AddButton("RemoveRope", {

    Text = "REMOVE ROPE",

    Tooltip = "Removes the rope from workspace (local only).",

    func = function()

        local rope = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("rope")

        if rope then

            rope:Destroy()

            print("[OBSIDIAN UI] Rope removed successfully (local).")

        else

            print("[OBSIDIAN UI] Rope not found.")

        end

    end

})

-- [2] FREEZE ROPE - toggle

GroupBoxes["JumpRope"]:AddToggle("FreezeRope", {

    Text = "FREEZE ROPE",

    Tooltip = "Freezes or unfreezes the rope physically.",

    Callback = function(state)

        local rope = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("rope")

        if not rope then

            print("[OBSIDIAN UI] Rope not found.")

            return

        end

        if state then

            -- Fully freeze rope

            for _, v in ipairs(rope:GetDescendants()) do

                if v:IsA("BasePart") then

                    v.Anchored = true

                    v.Velocity = Vector3.zero

                    v.RotVelocity = Vector3.zero

                elseif v:IsA("Constraint") or v:IsA("RopeConstraint") or v:IsA("Motor6D") then

                    v.Enabled = false

                end

            end

            print("[OBSIDIAN UI] Rope fully frozen.")

        else

            -- Unfreeze rope

            for _, v in ipairs(rope:GetDescendants()) do

                if v:IsA("BasePart") then

                    v.Anchored = false

                elseif v:IsA("Constraint") or v:IsA("RopeConstraint") or v:IsA("Motor6D") then

                    v.Enabled = true

                end

            end

            print("[OBSIDIAN UI] Rope unfrozen.")

        end

    end

})

-- [3] NO BALANCE MINI GAME - simple button

GroupBoxes["JumpRope"]:AddButton("NoBalanceMiniGame", {

    Text = "NO BALANCE MINI GAME",

    Tooltip = "Removes the balance attribute to skip the mini-game.",

    func = function()

        local player = game:GetService("Players").LocalPlayer

        if player:FindFirstChild("PlayingJumpRope") then

            player.PlayingJumpRope:Destroy()

            print("[OBSIDIAN UI] Removed 'PlayingJumpRope' from player.")

        else

            print("[OBSIDIAN UI] Attribute 'PlayingJumpRope' not found.")

        end

    end

})

-- [4] AUTO JUMP NEAR ROPE - toggle

GroupBoxes["JumpRope"]:AddToggle("AutoJumpRope", {

    Text = "AUTO JUMP",

    Tooltip = "Automatically jumps every second when near the rope.",

    Callback = function(state)

        if not state then return end

        local playerService = game:FindService("Players") or game:GetService("Players")

        local player = playerService.LocalPlayer or playerService.PlayerAdded:Wait()

        local function getHumanoid()

            local char = player.Character or player.CharacterAdded:Wait()

            return char:WaitForChild("Humanoid")

        end

        task.spawn(function()

            while state do

                local rope = workspace:FindFirstChild("Effects") and workspace.Effects:FindFirstChild("rope")

                if rope and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

                    local HRP = player.Character.HumanoidRootPart

                    local distance = (HRP.Position - rope.Position).Magnitude

                    if distance <= 15 then

                        local humanoid = getHumanoid()

                        if humanoid and humanoid.Health > 0 then

                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                        end

                    end

                end

                task.wait(1)

            end

        end)

    end

})

-- [6] SAFE PLATFORM - toggle

GroupBoxes["JumpRope"]:AddToggle("JumpRopeSafePlatform", {

    Text = "SAFE PLATFORM",

    Tooltip = "Creates a static safe platform below the player.",

    Callback = function(state)

        local Players = game:GetService("Players")

        local LocalPlayer = Players.LocalPlayer

        if state then

            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

            local HRP = Character:WaitForChild("HumanoidRootPart")

            local platform = Instance.new("Part")

            platform.Name = "JumpRopePlatform"

            platform.Size = Vector3.new(500, 1, 500)

            platform.Anchored = true

            platform.CanCollide = true

            platform.Transparency = 0.6

            platform.Material = Enum.Material.Neon

            platform.Color = Color3.fromRGB(0, 255, 0)

            platform.Position = HRP.Position - Vector3.new(0, 3, 0)

            platform.Parent = workspace

            print("[OBSIDIAN UI] Safe platform created (local).")

        else

            local existing = workspace:FindFirstChild("JumpRopePlatform")

            if existing then

                existing:Destroy()

                print("[OBSIDIAN UI] Safe platform removed.")

            end

        end

    end

})

GroupBoxes["Dalgona"]:AddButton("FREE LIGHTER", {

	Text = "FREE LIGHTER",

  

    Tooltip = "Gives you a lighter permanently",

	Func = function()

		local Players = game:GetService("Players")

		local LocalPlayer = Players.LocalPlayer

		local function setAttributeSafe(instance, name, value)

			if instance:GetAttribute(name) == nil then

				instance:SetAttribute(name, value)

			else

				instance:SetAttribute(name, value)

			end

		end

		setAttributeSafe(LocalPlayer, "HasLighter", true)

	end

})

GroupBoxes["F2P FEATURES"]:AddButton("FREEVIP", {

	Text = "UNLOCK VIP FEATURES",	Tooltip = "Gives you all VIP attributes for free",

	Func = function()

		local Players = game:GetService("Players")

		local LocalPlayer = Players.LocalPlayer

		local function setAttributeSafe(instance, name, value)

			if instance:GetAttribute(name) == nil then

				instance:SetAttribute(name, value)

			else

				instance:SetAttribute(name, value)

			end

		end

		-- Atributos VIP

		setAttributeSafe(LocalPlayer, "__OwnsVIPGamepass", true)

		setAttributeSafe(LocalPlayer, "VIPChatTag", true)

		setAttributeSafe(LocalPlayer, "VIPJoinAlert", true)

		setAttributeSafe(LocalPlayer, "VIPHideWins", false)

		local vipSettingData = '{"Hide Wins":false,"Custom Clothing Colorpicker":"None","Custom Clothing Color":true}'

		setAttributeSafe(LocalPlayer, "_VIPSettingData", vipSettingData)

		setAttributeSafe(LocalPlayer, "ChloatingColor", Color3.fromRGB(255, 255, 255))

	end

})

local autoTeleportBelow = false

GroupBoxes["JumpRope"]:AddToggle("AutoTeleportBelow", {

	Text = "ANTI FALL",	Tooltip = "Teleports player back below a fixed position if they fall.",

	Callback = function(state)

		autoTeleportBelow = state -- atualiza flag

		local Players = game:GetService("Players")

		local LocalPlayer = Players.LocalPlayer

		local teleportPos = Vector3.new(615.284424, 192.274277, 920.952515)

		-- Apenas cria o loop se ativado

		if state then

			task.spawn(function()

				while autoTeleportBelow do -- usa a flag atual

					task.wait(0.2)

					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then

						local HRP = LocalPlayer.Character.HumanoidRootPart

						if HRP.Position.Y <= (teleportPos.Y - 3) then

							HRP.CFrame = CFrame.new(teleportPos)

						end

					end

				end

			end)

		end

	end

})

-- Serviços

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Variáveis de controle

local autoModeEnabled = false

local currentMode = "Save Mode" -- Padrão

-- Posições

local safeCFrame = CFrame.new(-41.7126923, 1021.32306, 134.34935, 0.811150551, 0.237830803, 0.534295142, -8.95559788e-06, 0.913583994, -0.406650066, -0.584837377, 0.32984966, 0.741056323) + Vector3.new(0, 10, 0)

local trollCFrame = CFrame.new(-49.8884354, 1020.104, -512.157776, 1, 0, 0, 0, 1, 0, 0, 0, 1)

-- Funções auxiliares

local function getNearestValidPlayer()

    local closestPlayer, shortestDistance = nil, math.huge

    for _, player in ipairs(Players:GetPlayers()) do

        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then

            if not player.Character:FindFirstChild("SafeRedLightGreenLight") then

                local prompt = player.Character:FindFirstChild("CarryPrompt", true)

                if prompt then

                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude

                    if distance < shortestDistance then

                        shortestDistance = distance

                        closestPlayer = player

                    end

                end

            end

        end

    end

    return closestPlayer

end

local function saveRandomPlayer()

    local target = getNearestValidPlayer()

    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end

    local prompt = target.Character:FindFirstChild("CarryPrompt", true)

    if prompt then

        local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if HRP then

            HRP.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)

            task.wait(0.15)

            fireproximityprompt(prompt)

            task.wait(0.25)

            HRP.CFrame = safeCFrame

        end

    end

end

local function trollRandomPlayer()

    local target = getNearestValidPlayer()

    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end

    local prompt = target.Character:FindFirstChild("CarryPrompt", true)

    if prompt then

        local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if HRP then

            HRP.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)

            task.wait(0.15)

            fireproximityprompt(prompt)

            task.wait(0.25)

            HRP.CFrame = trollCFrame

        end

    end

end

-- Loop automático

local function autoModeLoop()

    while autoModeEnabled do

        if currentMode == "Save Mode" then

            saveRandomPlayer()

        elseif currentMode == "Troll Mode" then

            trollRandomPlayer()

        end

        task.wait(0.5)

    end

end

-- ================================

-- UI: RED LIGHT, GREEN LIGHT TAB

-- ================================

-- Toggle

GroupBoxes["Red Light, Green Light"]:AddToggle("AutoMode", {

	Text = "AUTO MODE",	Tooltip = "Automatically performs the selected mode",

	Default = false,

	Callback = function(Value)

		autoModeEnabled = Value

		if autoModeEnabled then

			task.spawn(autoModeLoop)

		end

	end

})

-- Dropdown

GroupBoxes["Red Light, Green Light"]:AddDropdown("ModeDropdown", {

	Text = "MODE : ",

	Tooltip = "Select which mode to perform",

	Value = "Save Mode", -- valor inicial

	Values = {"Save Mode", "Troll Mode"}, -- lista de opções

	Callback = function(Option)

		currentMode = Option

	end

})

-- Click Button

GroupBoxes["Red Light, Green Light"]:AddButton({

	Text = "MODE RANDOM PLAYER",

	Tooltip = "Performs the selected mode once",

	Func = function()

		if currentMode == "Save Mode" then

			saveRandomPlayer()

		elseif currentMode == "Troll Mode" then

			trollRandomPlayer()

		end

	end

})

-- =========================================

-- RED LIGHT, GREEN LIGHT TAB

-- =========================================

-- DESTROY INJURED + STUN

GroupBoxes["Red Light, Green Light"]:AddButton("DestroyInjuredStun", {

	Text = "REMOVE INJURED/STUN",	Tooltip = "Destroys all InjuredWalking and Stun objects",

	Func = function()

		local count = 0

		for _, obj in ipairs(workspace:GetDescendants()) do

			local nameLower = obj.Name:lower()

			if nameLower == "injuredwalking" or nameLower == "stun" then

				obj:Destroy()

				count += 1

			end

		end

		print("[DESTROY] Destroyed", count, "InjuredWalking/Stun objects")

	end

})

-- =========================================

-- HIDE 'N' SEEK TAB

-- =========================================

-- REMOVE SPIKES

GroupBoxes["Hide 'N' Seek"]:AddButton("RemoveSpikes", {

	Text = "REMOVE SPIKE",

	Tooltip = "Destroys all KillingParts in HideAndSeekMap",

	Func = function()

		local count = 0

		for _, obj in ipairs(workspace:GetDescendants()) do

			if obj.Name:lower() == "killingparts" then

				obj:Destroy()

				count += 1

			end

		end

		if count > 0 then

			warn("[SUCCESS] Removed", count, "KillingParts")

		else

			warn("[INFO] No KillingParts found")

		end

	end

})

-- =========================================

-- DALGONA TAB

-- =========================================

-- REMOVE PHOTO WALL

GroupBoxes["Dalgona"]:AddButton("RemovePhotoWall", {

	Text = "REMOVE PHOTO WALL",

	Tooltip = "Destroys the photo wall object in StairWalkWay",

	Func = function()

		local stair = workspace:FindFirstChild("StairWalkWay")

		if not stair then return warn("[ERROR] StairWalkWay not found") end

		local custom = stair:FindFirstChild("Custom")

		if not custom then return warn("[ERROR] Custom folder not found") end

		local count = 0

		for _, obj in ipairs(custom:GetDescendants()) do

			if obj.Name:lower() == "startingcrossedovercollision" then

				obj:Destroy()

				count += 1

			end

		end

		if count > 0 then

			warn("[SUCCESS] Removed", count, "startingcrossedoverCOLLISION")

		else

			warn("[INFO] startingcrossedoverCOLLISION not found")

		end

	end

})
