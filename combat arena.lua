--[[
COMBAT ARENA - NATIVE UI (FINAL COMPATIBLE)
- Fix: Ganti semua 'continue' (tidak support Lua 5.1)
- Fix: Tambah pcall di fungsi kritis
- Fix: Kompatibel semua executor
--]]

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ========== CONFIG ==========
local Config = {
    ESP = { Enabled = false, Box = true, Line = true, Name = true },
    Aimbot = { 
        Enabled = false, FOV = 150, ShowFOV = true, MaxDist = 500, 
        Smoothness = 0.5, AimPart = "Head" 
    }
}

-- ========== NATIVE UI CREATION ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CombatArenaNative"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 380)
Main.Position = UDim2.new(0.5, -110, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Main

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main
local TBCorner = Instance.new("UICorner")
TBCorner.CornerRadius = UDim.new(0, 8)
TBCorner.Parent = TitleBar
local Fix1 = Instance.new("Frame")
Fix1.Siz-- Aimbot (FIXe = UDim2.new(1, 0, 0, 8)
Fix1.Position = UDim2.new(0, 0, 1, -8)
Fix1.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Fix1.BorderSizePixel = 0
Fix1.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Combat Arena"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 100)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -10, 1, -35)
Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 4)
Layout.Parent = Scroll

-- ========== UI HELPER FUNCTIONS ==========
local function CreateLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Scroll
end

local function CreateToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 25)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BorderSizePixel = 0
    frame.Parent = Scroll
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 18)
    btn.Position = UDim2.new(1, -45, 0.5, -9)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 4) bc.Parent = btn
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
        pcall(callback, state)
    end)
end

local function CreateAdjuster(text, currentVal, minVal, maxVal, step, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 25)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BorderSizePixel = 0
    frame.Parent = Scroll
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -90, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local valText = Instance.new("TextLabel")
    valText.Size = UDim2.new(0, 40, 1, 0)
    valText.Position = UDim2.new(1, -80, 0, 0)
    valText.BackgroundTransparency = 1
    valText.Text = tostring(currentVal)
    valText.TextColor3 = Color3.fromRGB(255, 200, 0)
    valText.TextSize = 12
    valText.Font = Enum.Font.GothamBold
    valText.Parent = frame
    
    local function makeBtn(pos, txt)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 20, 0, 18)
        b.Position = pos
        b.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        b.Text = txt
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 12
        b.Font = Enum.Font.GothamBold
        b.Parent = frame
        local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 4) bc.Parent = b
        return b
    end
    
    local minusBtn = makeBtn(UDim2.new(1, -40, 0.5, -9), "-")
    local plusBtn = makeBtn(UDim2.new(1, -18, 0.5, -9), "+")
    
    local val = currentVal
    local function update()
        valText.Text = tostring(val)
        pcall(callback, val)
    end
    
    minusBtn.MouseButton1Click:Connect(function()
        val = math.max(minVal, val - step)
        update()
    end)
    plusBtn.MouseButton1Click:Connect(function()
        val = math.min(maxVal, val + step)
        update()
    end)
end

local function CreateCycleButton(text, options, defaultIndex, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 25)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BorderSizePixel = 0
    frame.Parent = Scroll
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -80, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 18)
    btn.Position = UDim2.new(1, -75, 0.5, -9)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Text = options[defaultIndex]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0, 4) bc.Parent = btn
    
    local currentIndex = defaultIndex
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        btn.Text = options[currentIndex]
        pcall(callback, options[currentIndex])
    end)
    pcall(callback, options[defaultIndex])
end

-- ========== DRAGGING UI ==========
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ========== MINIMIZE & CLOSE LOGIC ==========
local isMinimized = false
local originalSize = Main.Size

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Scroll.Visible = false
        Main.Size = UDim2.new(0, 220, 0, 30)
        MinimizeBtn.Text = "+"
    else
        Scroll.Visible = true
        Main.Size = originalSize
        MinimizeBtn.Text = "_"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ========== BUILD UI ELEMENTS ==========
CreateLabel("--- ESP ---")
CreateToggle("Enable ESP", false, function(v) Config.ESP.Enabled = v end)
CreateToggle("Show Box", true, function(v) Config.ESP.Box = v end)
CreateToggle("Show Line", true, function(v) Config.ESP.Line = v end)
CreateToggle("Show Name", true, function(v) Config.ESP.Name = v end)

CreateLabel("--- AIMBOT ---")
CreateToggle("Enable Aimbot", false, function(v) Config.Aimbot.Enabled = v end)
CreateToggle("Show FOV Circle", true, function(v) Config.Aimbot.ShowFOV = v end)
CreateCycleButton("Target Part", {"Head", "Torso", "Root"}, 1, function(v) 
    if v == "Root" then v = "HumanoidRootPart" end
    Config.Aimbot.AimPart = v 
end)
CreateAdjuster("FOV Radius", 150, 50, 500, 10, function(v) Config.Aimbot.FOV = v end)
CreateAdjuster("Max Distance", 500, 100, 2000, 50, function(v) Config.Aimbot.MaxDist = v end)
CreateAdjuster("Smoothness", 5, 0, 9, 1, function(v) Config.Aimbot.Smoothness = v / 10 end)

-- ========== ESP & AIMBOT LOGIC ==========
local ESPData = {}
local fovCircle = pcall(function() return Drawing.new("Circle") end)

-- Fungsi cek team (hanya target enemy)
local function isEnemy(plr)
    if not LocalPlayer.Team or not plr.Team then
        return true
    end
    return LocalPlayer.Team ~= plr.Team
end

-- Fungsi cek visibilitas (Anti Tembok) - dengan pcall
local function isVisible(targetPart)
    local success, result = pcall(function()
        local origin = Camera.CFrame.Position
        local targetPos = targetPart.Position
        local direction = (targetPos - origin)
        
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
        params.FilterType = Enum.RaycastFilterType.Exclude
        
        local rayResult = workspace:Raycast(origin, direction, params)
        return not rayResult
    end)
    return success and result or true
end

local function InitESP(plr)
    if ESPData[plr] or plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end
    
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 1.5
    line.Color = Color3.fromRGB(255, 0, 0)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Size = UDim2.new(0, 120, 0, 35)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = char
    billboard.Parent = char
    
    local bgFrame = Instance.new("Frame")
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    bgFrame.BackgroundTransparency = 0.3
    bgFrame.BorderSizePixel = 0
    bgFrame.Parent = billboard
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 4)
    bgCorner.Parent = bgFrame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.6, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.GothamBold
    distLabel.Parent = billboard
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Box"
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0
    highlight.OutlineColor3 = Color3.fromRGB(255, 0, 0)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = char
    highlight.Parent = char
    
    ESPData[plr] = { 
        Line = line, 
        Billboard = billboard, 
        TextLabel = textLabel, 
        DistLabel = distLabel,
        Highlight = highlight 
    }
end

local function SetupPlayer(plr)
    if plr ~= LocalPlayer then
        if plr.Character then InitESP(plr) end
        plr.CharacterAdded:Connect(function() 
            task.wait(0.5) 
            InitESP(plr) 
        end)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do 
    pcall(SetupPlayer, plr) 
end
Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(function(plr)
    if ESPData[plr] then
        pcall(function() ESPData[plr].Line:Remove() end)
        ESPData[plr] = nil
    end
end)

local function GetClosestPlayer()
    local closest = nil
    local shortestDist = Config.Aimbot.FOV
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and isEnemy(plr) then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local part = plr.Character:FindFirstChild(Config.Aimbot.AimPart) or plr.Character:FindFirstChild("HumanoidRootPart")
            
            if hum and hum.Health > 0 and part then
                if isVisible(part) then
                    local success, screenPos = pcall(function()
                        return Camera:WorldToViewportPoint(part.Position)
                    end)
                    
                    if success and screenPos then
                        local onScreen = screenPos.Z > 0
                        if onScreen then
                            local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                            local dist = (targetPos - screenCenter).Magnitude
                            if dist < shortestDist then
                                if localRoot then
                                    local dist3D = (part.Position - localRoot.Position).Magnitude
                                    if dist3D <= Config.Aimbot.MaxDist then
                                        shortestDist = dist
                                        closest = plr
                                    end
                                else
                                    shortestDist = dist
                                    closest = plr
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- ========== MAIN LOOP ==========
RunService.RenderStepped:Connect(function()
    pcall(function()
        local localChar = LocalPlayer.Character
        local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

        -- FOV Circle
        if fovCircle then
            fovCircle.Visible = Config.Aimbot.ShowFOV and Config.Aimbot.Enabled
            fovCircle.Radius = Config.Aimbot.FOV
            fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        end

        -- ESP Update (HANYA ENEMY) - TANPA CONTINUE
        for plr, data in pairs(ESPData) do
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if char and hum and hum.Health > 0 and root then
                -- Cek apakah enemy
                if isEnemy(plr) then
                    if Config.ESP.Enabled then
                        if Config.ESP.Line and localRoot then
                            local p1 = Camera:WorldToViewportPoint(localRoot.Position)
                            local p2 = Camera:WorldToViewportPoint(root.Position)
                            data.Line.From = Vector2.new(p1.X, p1.Y)
                            data.Line.To = Vector2.new(p2.X, p2.Y)
                            data.Line.Visible = true
                        else
                            data.Line.Visible = false
                        end

                        if Config.ESP.Name then
                            data.Billboard.Enabled = true
                            data.TextLabel.Text = plr.Name
                            
                            local dist = math.floor((root.Position - (localRoot and localRoot.Position or root.Position)).Magnitude)
                            data.DistLabel.Text = dist .. "M"
                        else
                            data.Billboard.Enabled = false
                        end

                        if Config.ESP.Box then
                            data.Highlight.Adornee = char
                        else
                            data.Highlight.Adornee = nil
                        end
                    else
                        data.Line.Visible = false
                        data.Billboard.Enabled = false
                        data.Highlight.Adornee = nil
                    end
                else
                    -- Bukan enemy, sembunyikan
                    data.Line.Visible = false
                    data.Billboard.Enabled = false
                    data.Highlight.Adornee = nil
                end
            else
                -- Character mati/tidak ada
                data.Line.Visible = false
                data.Billboard.Enabled = false
                data.Highlight.Adornee = nil
            end
        end

        -- Aimbot (FIXED: Menggunakan Posisi Mouse Asli)
        if Config.Aimbot.Enabled then
            local target = GetClosestPlayer()
            if target then
                local part = target.Character:FindFirstChild(Config.Aimbot.AimPart) or target.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local screenPos = Camera:WorldToViewportPoint(part.Position)
                    
                    local mousePos = UIS:GetMouseLocation() 
                    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                    
                    local delta = targetPos - mousePos
                    local dist = delta.Magnitude
                    
                    local smoothFactor = math.min(Config.Aimbot.Smoothness, 0.9)
                    
                    if dist < 2 then
                        pcall(function() mousemoverel(delta.X, delta.Y) end)
                    else
                        local moveDelta = delta * (1 - smoothFactor)
                        pcall(function() mousemoverel(moveDelta.X, moveDelta.Y) end)
                    end
                end
            end
        end
    end)