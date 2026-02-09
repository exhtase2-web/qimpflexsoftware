-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService") -- Bypass ve IP Intelligence için

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- [BYPASS & PROTECT SYSTEM]
-- GUI'yi oyunun algılayamayacağı CoreGui'ye taşıyoruz.
local function GetSafeParent()
	local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
	if success then
		-- Bazı exploitler (Synapse, Wave vb.) için ekstra koruma
		if get_hidden_gui then return get_hidden_gui() end
		return coreGui:FindFirstChild("RobloxGui") or coreGui
	end
	return pGui
end

local SafeParent = GetSafeParent()
local RandomName = "RobloxSystem_" .. HttpService:GenerateGUID(false):sub(1,8)

-- Temizlik
if SafeParent:FindFirstChild(RandomName) then SafeParent[RandomName]:Destroy() end
if pGui:FindFirstChild("GeminiLoading") then pGui.GeminiLoading:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = RandomName
ScreenGui.Parent = SafeParent
ScreenGui.ResetOnSpawn = false

-- Renk Paleti
local COLORS = {
	BG = Color3.fromRGB(10, 10, 12),
	SIDE = Color3.fromRGB(16, 16, 18),
	ACCENT = Color3.fromRGB(0, 255, 140),
	ACCENT_DARK = Color3.fromRGB(0, 150, 80),
	TARGET = Color3.fromRGB(255, 45, 45),  
	WHITE = Color3.fromRGB(245, 245, 245),
	GRAY = Color3.fromRGB(150, 150, 150),
	DARK_GRAY = Color3.fromRGB(25, 25, 28)
}

-- [AIMLOCK CONFIG]
_G.Aimlock = false
_G.AimlockKey = Enum.UserInputType.MouseButton2
_G.LockedTarget = nil

-- [UI BUILDER - MAIN FRAME]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 540, 0, 400)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -200)
MainFrame.BackgroundColor3 = COLORS.BG
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false 
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- [LOADING SCREEN SYSTEM]
local function StartLoading()
	local LoadingGui = Instance.new("ScreenGui")
	LoadingGui.Name = "GeminiLoading"
	LoadingGui.Parent = pGui
	LoadingGui.DisplayOrder = 999
	LoadingGui.IgnoreGuiInset = true 

	local LoadBG = Instance.new("Frame")
	LoadBG.Size = UDim2.new(1, 0, 1, 0)
	LoadBG.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
	LoadBG.BorderSizePixel = 0
	LoadBG.Parent = LoadingGui

	local Vignette = Instance.new("ImageLabel")
	Vignette.Size = UDim2.new(1, 0, 1, 0)
	Vignette.BackgroundTransparency = 1
	Vignette.Image = "rbxassetid://15264875382"
	Vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Vignette.ImageTransparency = 0.4
	Vignette.Parent = LoadBG

	local LoadContent = Instance.new("Frame")
	LoadContent.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadContent.Size = UDim2.new(0, 350, 0, 400)
	LoadContent.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoadContent.BackgroundTransparency = 1
	LoadContent.Parent = LoadBG

	local RotateRing = Instance.new("ImageLabel")
	RotateRing.Size = UDim2.new(0, 130, 0, 130)
	RotateRing.Position = UDim2.new(0.5, -65, 0, 10)
	RotateRing.BackgroundTransparency = 1
	RotateRing.Image = "rbxassetid://12124333113"
	RotateRing.ImageColor3 = COLORS.ACCENT
	RotateRing.Parent = LoadContent

	local UserImg = Instance.new("ImageLabel")
	UserImg.Size = UDim2.new(0, 110, 0, 110)
	UserImg.Position = UDim2.new(0.5, -55, 0, 20)
	UserImg.BackgroundColor3 = COLORS.SIDE
	UserImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	UserImg.ZIndex = 2
	UserImg.Parent = LoadContent
	Instance.new("UICorner", UserImg).CornerRadius = UDim.new(1, 0)

	local LoadTitle = Instance.new("TextLabel")
	LoadTitle.Text = "qimpflex Hub v2"
	LoadTitle.Size = UDim2.new(1, 0, 0, 40)
	LoadTitle.Position = UDim2.new(0, 0, 0, 145)
	LoadTitle.TextColor3 = COLORS.WHITE
	LoadTitle.Font = Enum.Font.GothamBold
	LoadTitle.TextSize = 24
	LoadTitle.BackgroundTransparency = 1
	LoadTitle.Parent = LoadContent

	local BarBack = Instance.new("Frame")
	BarBack.Size = UDim2.new(0, 220, 0, 4)
	BarBack.Position = UDim2.new(0.5, -110, 0, 210)
	BarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	BarBack.Parent = LoadContent
	Instance.new("UICorner", BarBack)

	local BarFill = Instance.new("Frame")
	BarFill.Size = UDim2.new(0, 0, 1, 0)
	BarFill.BackgroundColor3 = COLORS.ACCENT
	BarFill.Parent = BarBack
	Instance.new("UICorner", BarFill)

	task.spawn(function()
		local loader = TweenService:Create(BarFill, TweenInfo.new(3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
		loader:Play()
		
		local rot = 0
		while loader.PlaybackState ~= Enum.PlaybackState.Completed do
			rot = rot + 4
			RotateRing.Rotation = rot
			task.wait()
		end
		
		task.wait(0.5)
		LoadingGui:Destroy()
		MainFrame.Visible = true
	end)
end

-- [TARGET FINDER]
local function GetClosestPlayer()
	local closestDist = math.huge
	local target = nil
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= player and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
			local screenPos, onScreen = camera:WorldToViewportPoint(v.Character.Head.Position)
			if onScreen then
				local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
				if dist < closestDist then
					closestDist = dist
					target = v
				end
			end
		end
	end
	return target
end

-- [IP & INTEL FEATURE]
local function GetIPIntel()
	local data = "Fetching Intelligence..."
	pcall(function()
		data = HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json/")).query
	end)
	return data
end

-- [ESP SİSTEMİ]
local ESP_FOLDER = Instance.new("Folder", ScreenGui)
ESP_FOLDER.Name = "ESP_Data"
_G.ESP_Enabled = false

local function CreateESP(p)
	if p == player then return end
	local function ApplyESP(char)
		if not _G.ESP_Enabled then return end
		local Highlight = Instance.new("Highlight")
		Highlight.Adornee = char
		Highlight.FillTransparency = 0.5
		Highlight.FillColor = COLORS.ACCENT
		Highlight.OutlineColor = COLORS.WHITE
		Highlight.Parent = ESP_FOLDER
		Highlight:SetAttribute("Target", p.UserId)
	end
	p.CharacterAdded:Connect(ApplyESP)
	if p.Character then ApplyESP(p.Character) end
end

-- [SIDEBAR & PAGES]
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = COLORS.SIDE
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local IntelBar = Instance.new("Frame")
IntelBar.Size = UDim2.new(0, 350, 0, 35)
IntelBar.Position = UDim2.new(0, 175, 0, 15)
IntelBar.BackgroundColor3 = COLORS.SIDE
IntelBar.Parent = MainFrame
Instance.new("UICorner", IntelBar)

local IntelText = Instance.new("TextLabel")
IntelText.Size = UDim2.new(1, 0, 1, 0)
IntelText.BackgroundTransparency = 1
IntelText.TextColor3 = COLORS.ACCENT
IntelText.Font = Enum.Font.Code
IntelText.TextSize = 11
IntelText.Text = "IP INTEL: " .. GetIPIntel()
IntelText.Parent = IntelBar

local Pages = Instance.new("Frame")
Pages.Position = UDim2.new(0, 175, 0, 65)
Pages.Size = UDim2.new(0, 350, 0, 320)
Pages.BackgroundTransparency = 1
Pages.Parent = MainFrame

local MainTab = Instance.new("ScrollingFrame")
MainTab.Size = UDim2.new(1, 0, 1, 0)
MainTab.BackgroundTransparency = 1
MainTab.ScrollBarThickness = 0
MainTab.Parent = Pages
Instance.new("UIListLayout", MainTab).Padding = UDim.new(0, 8)

-- [TOGGLE BUILDER]
local function AddToggle(parent, text, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 45)
	b.BackgroundColor3 = COLORS.SIDE
	b.Text = "  " .. text
	b.TextColor3 = COLORS.WHITE
	b.TextXAlignment = Enum.TextXAlignment.Left
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 13
	b.Parent = parent
	Instance.new("UICorner", b)

	local active = false
	b.MouseButton1Click:Connect(function()
		active = not active
		b.TextColor3 = active and COLORS.ACCENT or COLORS.WHITE
		callback(active)
	end)
end

-- [CORE LOOPS]
AddToggle(MainTab, "Aimlock (HARD)", function(v) _G.Aimlock = v end)
AddToggle(MainTab, "ESP Visuals", function(v) 
	_G.ESP_Enabled = v 
	if not v then ESP_FOLDER:ClearAllChildren() else 
		for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end 
	end 
end)

RunService.RenderStepped:Connect(function()
	if _G.Aimlock and UserInputService:IsMouseButtonPressed(_G.AimlockKey) then
		if not _G.LockedTarget or not _G.LockedTarget.Character or _G.LockedTarget.Character.Humanoid.Health <= 0 then
			_G.LockedTarget = GetClosestPlayer()
		end
		if _G.LockedTarget and _G.LockedTarget.Character:FindFirstChild("Head") then
			camera.CFrame = CFrame.new(camera.CFrame.Position, _G.LockedTarget.Character.Head.Position)
		end
	else
		_G.LockedTarget = nil
	end
end)

-- [DRAG]
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true dragStart = input.Position startPos = MainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
MainFrame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightControl then MainFrame.Visible = not MainFrame.Visible end end)

StartLoading()
print("qimpflex')
