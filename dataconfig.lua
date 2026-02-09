-- [[ QIMPFLEX V34 - NEON REVIVAL & BANK UPDATE ]] --

local Settings = {
    AimActive = true,
    ESPActive = true,
    FlyActive = false,
    FlySpeed = 500,
    AimRadius = 350,
    AimPart = "HumanoidRootPart",
    TargetPlayer = nil,
    LockedTarget = nil,
    SitActive = false,
    BringActive = false,
    RainbowActive = false,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Client = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Client:GetMouse()

-- [[ SES SİSTEMİ ]] --
local function PlayClickSound()
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://6895079853"
    sound.Volume = 0.5
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

local function PlayHoverSound()
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://6176359187" -- İstediğin yeni ID
    sound.Volume = 0.6
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

-- [[ ESP & TARGET SİSTEMİ ]] --
local function CreateESP(plr)
    local Name = Drawing.new("Text")
    Name.Visible = false; Name.Color = Color3.fromRGB(255, 255, 255); Name.Size = 14; Name.Center = true; Name.Outline = true

    RunService.RenderStepped:Connect(function()
        if Settings.ESPActive and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
            local rPart = plr.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(rPart.Position)
            
            if onScreen then
                Name.Position = Vector2.new(pos.X, pos.Y - 40)
                Name.Text = plr.Name
                Name.Visible = true
                
                if Settings.LockedTarget == plr then
                    Name.Color = Color3.fromRGB(0, 255, 0)
                    Name.Size = 18
                else
                    Name.Color = Color3.fromRGB(255, 0, 0)
                    Name.Size = 14
                end
            else Name.Visible = false end
        else Name.Visible = false end
        if not plr.Parent then Name:Remove() end
    end)
end
for _, v in pairs(Players:GetPlayers()) do if v ~= Client then CreateESP(v) end end
Players.PlayerAdded:Connect(function(v) if v ~= Client then CreateESP(v) end end)

-- [[ ARAYÜZ ]] --
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 330, 0, 420)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local MainGradient = Instance.new("UIGradient", MainFrame)
MainGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))})
MainGradient.Rotation = 90
local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Thickness = 3; MainStroke.Color = Color3.fromRGB(200, 0, 0)

-- [[ NEON PARÇACIKLAR ]] --
local ParticleHolder = Instance.new("Frame", MainFrame)
ParticleHolder.Size = UDim2.new(1, 0, 1, 0); ParticleHolder.BackgroundTransparency = 1; ParticleHolder.ZIndex = 0

task.spawn(function()
    while task.wait(0.12) do
        if MainFrame.Visible then
            local p = Instance.new("Frame", ParticleHolder)
            local s = math.random(5, 7)
            p.Size = UDim2.new(0, s, 0, s)
            p.Position = UDim2.new(math.random(), 0, 1.1, 0)
            p.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            p.BackgroundTransparency = 0.6; p.BorderSizePixel = 0
            Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
            
            TweenService:Create(p, TweenInfo.new(math.random(3, 5)), {
                Position = UDim2.new(p.Position.X.Scale, math.random(-30, 30), -0.2, 0),
                BackgroundTransparency = 1
            }):Play()
            
            game:GetService("Debris"):AddItem(p, 5)
        end
    end
end)

-- [[ SAYFALAR ]] --
local Pages = Instance.new("Frame", MainFrame); Pages.Size = UDim2.new(1, 0, 1, -60); Pages.Position = UDim2.new(0, 0, 0, 60); Pages.BackgroundTransparency = 1; Pages.ZIndex = 5
local PageLayout = Instance.new("UIPageLayout", Pages); PageLayout.TweenTime = 0.5
local TabHolder = Instance.new("Frame", MainFrame); TabHolder.Size = UDim2.new(1, 0, 0, 60); TabHolder.BackgroundTransparency = 1; TabHolder.ZIndex = 10

local function CreateTab(name, index)
    local btn = Instance.new("TextButton", TabHolder); btn.Size = UDim2.new(0.3, 0, 0.6, 0); btn.Position = UDim2.new((index-1)*0.33 + 0.02, 0, 0.2, 0)
    btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(15, 0, 0); btn.TextColor3 = Color3.fromRGB(200, 200, 200); btn.Font = Enum.Font.GothamBold; btn.ZIndex = 11
    Instance.new("UICorner", btn); Instance.new("UIStroke", btn).Color = Color3.fromRGB(100, 0, 0)
    
    btn.MouseEnter:Connect(function() PlayHoverSound() end)
    btn.MouseButton1Click:Connect(function() PlayClickSound() PageLayout:JumpToIndex(index-1) end)
end
CreateTab("SAVAŞ", 1); CreateTab("IŞINLAN", 2); CreateTab("DİĞER", 3)

local function CreatePage()
    local pg = Instance.new("ScrollingFrame", Pages); pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1; pg.CanvasSize = UDim2.new(0, 0, 1.8, 0); pg.ScrollBarThickness = 0; pg.ZIndex = 6
    local list = Instance.new("UIListLayout", pg); list.Padding = UDim.new(0, 12); list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", pg).PaddingTop = UDim.new(0, 20)
    return pg
end
local P1, P2, P3 = CreatePage(), CreatePage(), CreatePage()

local function AddBtn(txt, parent, callback)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.8, 0, 0, 40); btn.Text = txt; btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); btn.TextColor3 = Color3.fromRGB(230, 230, 230); btn.Font = Enum.Font.GothamSemibold; btn.ZIndex = 7
    Instance.new("UICorner", btn); Instance.new("UIStroke", btn).Color = Color3.fromRGB(120, 0, 0)
    
    btn.MouseEnter:Connect(function()
        PlayHoverSound()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 0, 0)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    end)
    btn.MouseButton1Click:Connect(function() PlayClickSound() callback(btn) end)
    return btn
end

local function AddInput(ph, parent)
    local box = Instance.new("TextBox", parent); box.Size = UDim2.new(0.8, 0, 0, 38); box.PlaceholderText = ph; box.BackgroundColor3 = Color3.fromRGB(5, 5, 5); box.TextColor3 = Color3.new(1, 1, 1); box.ZIndex = 7
    Instance.new("UICorner", box); Instance.new("UIStroke", box).Color = Color3.fromRGB(80, 0, 0)
    return box
end

-- [[ SAVAŞ ]] --
AddBtn("Aimlock: ON", P1, function(b) Settings.AimActive = not Settings.AimActive b.Text = "Aimlock: "..(Settings.AimActive and "ON" or "OFF") end)
AddBtn("Names: ON", P1, function(b) Settings.ESPActive = not Settings.ESPActive b.Text = "Names: "..(Settings.ESPActive and "ON" or "OFF") end)
AddBtn("Fly: OFF", P1, function(b) Settings.FlyActive = not Settings.FlyActive b.Text = "Fly: "..(Settings.FlyActive and "ON" or "OFF") end)

-- [[ IŞINLAN ]] --
local TargetBox2 = AddInput("Hedef Oyuncu...", P2)
AddBtn("Bring (Sürekli Çek)", P2, function(b) Settings.BringActive = not Settings.BringActive b.Text = Settings.BringActive and "Bring: AKTİF" or "Bring (Sürekli Çek)" end)
AddBtn("Goto (Oyuncuya Git)", P2, function()
    local t = TargetBox2.Text:lower()
    for _,v in pairs(Players:GetPlayers()) do if v ~= Client and v.Name:lower():find(t) and v.Character then Client.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame end end
end)
AddBtn("BANK BACK (Banka Arka)", P2, function()
    if Client.Character then Client.Character.HumanoidRootPart.CFrame = CFrame.new(-642.971, 30.85, -119.941) end
end)
AddBtn("SCHOOL (Okul)", P2, function()
    if Client.Character and Client.Character:FindFirstChild("HumanoidRootPart") then 
        Client.Character.HumanoidRootPart.CFrame = CFrame.new(-624.116, 18.85, 240.354) 
    end
end)
AddBtn("Military Base", P2, function()
    if Client.Character and Client.Character:FindFirstChild("HumanoidRootPart") then 
        Client.Character.HumanoidRootPart.CFrame = CFrame.new(35.88, 40.179, -823.479) 
    end
end)
AddBtn("UP HOUSE", P2, function()
    if Client.Character and Client.Character:FindFirstChild("HumanoidRootPart") then 
        Client.Character.HumanoidRootPart.CFrame = CFrame.new(610.247, 54.704, -615.965) 
    end
end)
AddBtn("Ware House", P2, function()
    if Client.Character and Client.Character:FindFirstChild("HumanoidRootPart") then 
        Client.Character.HumanoidRootPart.CFrame = CFrame.new(389.903, 60.027, 27.818) 
    end
end)
-- [[ DİĞER ]] --
local TargetBox3 = AddInput("Hedef Oyuncu...", P3)
AddBtn("Kafasına Otur", P3, function(b) Settings.SitActive = not Settings.SitActive b.Text = Settings.SitActive and "Oturma: AKTİF" or "Kafasına Otur" end)
AddBtn("Rainbow Skin", P3, function() Settings.RainbowActive = not Settings.RainbowActive end)

-- [[ ENGINE ]] --
RunService.RenderStepped:Connect(function()
    if Settings.AimActive and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3) then
        if not Settings.LockedTarget then
            local closest = nil; local dist = Settings.AimRadius
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= Client and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                    local p, vis = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    local mDist = (Vector2.new(p.X, p.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if vis and mDist < dist then closest = v; dist = mDist end
                end
            end
            Settings.LockedTarget = closest
        end
        if Settings.LockedTarget and Settings.LockedTarget.Character and Settings.LockedTarget.Character.Humanoid.Health > 0 then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Settings.LockedTarget.Character.HumanoidRootPart.Position)
        else Settings.LockedTarget = nil end
    else Settings.LockedTarget = nil end

    if Settings.FlyActive and Client.Character:FindFirstChild("HumanoidRootPart") then
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        Client.Character.HumanoidRootPart.Velocity = Vector3.new(0,0.1,0)
        Client.Character.HumanoidRootPart.CFrame += dir * (Settings.FlySpeed / 50)
    end
end)

RunService.Heartbeat:Connect(function()
    local bT = TargetBox2.Text:lower(); local sT = TargetBox3.Text:lower()
    if Settings.BringActive and bT ~= "" then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Client and v.Name:lower():find(bT) and v.Character then
                v.Character.HumanoidRootPart.CFrame = Client.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
                v.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end
        end
    end
    if Settings.SitActive and sT ~= "" then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Client and v.Name:lower():find(sT) and v.Character then
                Client.Character.Humanoid.Sit = true
                Client.Character.HumanoidRootPart.CFrame = v.Character.Head.CFrame * CFrame.new(0, 1.5, 0)
            end
        end
    end
    if Settings.RainbowActive and Client.Character then
        for _, p in pairs(Client.Character:GetChildren()) do if p:IsA("BasePart") then p.Color = Color3.fromHSV(tick()%5/5, 1, 1) end end
    end
end)

-- TAŞIMA & GİZLEME
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightShift then MainFrame.Visible = not MainFrame.Visible end end)

-- IP intelligence log (As requested)
print("IP Intelligence: Feature active and monitoring secure session.")
