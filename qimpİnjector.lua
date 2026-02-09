-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- [[ CORE GUI BYPASS - SADECE BURASI DEĞİŞTİ ]] --
local function GetSafeParent()
	local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
	if success then
		-- Eğer exploit destekliyorsa en güvenli yer RobloxGui içidir
		return coreGui:FindFirstChild("RobloxGui") or coreGui
	end
	return pGui -- Bypass başarısız olursa çökmemesi için geri dönüş yolu
end

local SafeParent = GetSafeParent()

-- Temizlik (Artık SafeParent içinde arıyor)
if SafeParent:FindFirstChild("qimpflex v2") then SafeParent['qimpflex v2']:Destroy() end
if pGui:FindFirstChild("GeminiLoading") then pGui.GeminiLoading:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "qimpflex v2"
ScreenGui.Parent = SafeParent -- GUI artık CoreGui içinde
ScreenGui.ResetOnSpawn = false

-- Renk Paleti (Premium Dark)
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
MainFrame.Visible = false -- Loading bitene kadar gizli
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- [LOADING SCREEN SYSTEM - FIXED]
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

	local BGGrad = Instance.new("UIGradient")
	BGGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 20)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10))
	})
	BGGrad.Rotation = 45
	BGGrad.Parent = LoadBG

	local LoadContent = Instance.new("Frame")
	LoadContent.AnchorPoint = Vector2.new(0.5, 0.5)
	LoadContent.Size = UDim2.new(0, 350, 0, 400)
	LoadContent.Position = UDim2.new(0.5, 0, 0.5, 0)
	LoadContent.BackgroundTransparency = 1
	LoadContent.Parent = LoadBG

	local BigRing = Instance.new("ImageLabel")
	BigRing.Size = UDim2.new(0, 400, 0, 400)
	BigRing.Position = UDim2.new(0.5, -200, 0.5, -200)
	BigRing.BackgroundTransparency = 1
	BigRing.Image = "rbxassetid://12124333113"
	BigRing.ImageColor3 = COLORS.ACCENT
	BigRing.ImageTransparency = 1 
	BigRing.Parent = LoadBG

	local RotateRing = Instance.new("ImageLabel")
	RotateRing.Size = UDim2.new(0, 130, 0, 130)
	RotateRing.Position = UDim2.new(0.5, -65, 0, 10)
	RotateRing.BackgroundTransparency = 1
	RotateRing.Image = "rbxassetid://12124333113"
	RotateRing.ImageColor3 = COLORS.ACCENT
	RotateRing.ImageTransparency = 1
	RotateRing.Parent = LoadContent

	local UserImg = Instance.new("ImageLabel")
	UserImg.Size = UDim2.new(0, 110, 0, 110)
	UserImg.Position = UDim2.new(0.5, -55, 0, 20)
	UserImg.BackgroundColor3 = COLORS.SIDE
	UserImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	UserImg.ImageTransparency = 1
	UserImg.ZIndex = 2
	UserImg.Parent = LoadContent
	Instance.new("UICorner", UserImg).CornerRadius = UDim.new(1, 0)
	local ImgStroke = Instance.new("UIStroke", UserImg)
	ImgStroke.Color = COLORS.ACCENT

	local hour = os.date("*t").hour
	local greeting = "Hoş geldin"
	if hour < 12 then greeting = "Günaydın"
	elseif hour < 18 then greeting = "Tünaydın"
	else greeting = "İyi Akşamlar" end

	local LoadTitle = Instance.new("TextLabel")
	LoadTitle.Text = greeting .. ", " .. player.DisplayName
	LoadTitle.Size = UDim2.new(1, 0, 0, 40)
	LoadTitle.Position = UDim2.new(0, 0, 0, 145)
	LoadTitle.TextColor3 = COLORS.WHITE
	LoadTitle.Font = Enum.Font.GothamBold
	LoadTitle.TextSize = 26
	LoadTitle.TextTransparency = 1
	LoadTitle.BackgroundTransparency = 1
	LoadTitle.Parent = LoadContent

	local PercentText = Instance.new("TextLabel")
	PercentText.Text = "0%"
	PercentText.Size = UDim2.new(1, 0, 0, 20)
	PercentText.Position = UDim2.new(0, 0, 0, 218)
	PercentText.TextColor3 = Color3.fromRGB(200, 200, 200)
	PercentText.Font = Enum.Font.Gotham
	PercentText.TextSize = 14
	PercentText.BackgroundTransparency = 1
	PercentText.TextTransparency = 1
	PercentText.Parent = LoadContent

	local TipText = Instance.new("TextLabel")
	local Tips = {"asset loading", "loading assets", "loading data", "data loading", "trying to ready", "ui preloading"}
	TipText.Text = Tips[math.random(1, #Tips)]
	TipText.Size = UDim2.new(1, 0, 0, 20)
	TipText.Position = UDim2.new(0, 0, 0, 245)
	TipText.TextColor3 = Color3.fromRGB(120, 120, 120)
	TipText.Font = Enum.Font.Gotham
	TipText.TextSize = 13
	TipText.TextTransparency = 1
	TipText.BackgroundTransparency = 1
	TipText.Parent = LoadContent

	local BarBack = Instance.new("Frame")
	BarBack.Size = UDim2.new(0, 220, 0, 4)
	BarBack.Position = UDim2.new(0.5, -110, 0, 210)
	BarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	BarBack.BackgroundTransparency = 1
	BarBack.Parent = LoadContent
	Instance.new("UICorner", BarBack)

	local BarFill = Instance.new("Frame")
	BarFill.Size = UDim2.new(0, 0, 1, 0)
	BarFill.BackgroundColor3 = COLORS.ACCENT
	BarFill.BorderSizePixel = 0
	BarFill.ClipsDescendants = true 
	BarFill.Parent = BarBack
	Instance.new("UICorner", BarFill)

	local BarGlow = Instance.new("Frame")
	BarGlow.Size = UDim2.new(0, 100, 1, 0)
	BarGlow.Position = UDim2.new(-1, 0, 0, 0)
	BarGlow.BackgroundColor3 = Color3.new(1, 1, 1)
	BarGlow.BackgroundTransparency = 0.7
	BarGlow.BorderSizePixel = 0
	BarGlow.Parent = BarFill

	local GGrad = Instance.new("UIGradient")
	GGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)})
	GGrad.Parent = BarGlow

	local function CreateParticle()
		local p = Instance.new("Frame")
		local size = math.random(2, 4)
		p.Size = UDim2.new(0, size, 0, size)
		p.Position = UDim2.new(math.random(), 0, 1.1, 0)
		p.BackgroundColor3 = COLORS.ACCENT
		p.BackgroundTransparency = 0.5
		p.Parent = LoadBG
		Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
		TweenService:Create(p, TweenInfo.new(math.random(3, 5)), {Position = UDim2.new(p.Position.X.Scale, 0, -0.1, 0), BackgroundTransparency = 1}):Play()
		task.delay(5, function() p:Destroy() end)
	end

	task.spawn(function()
		local active = true
		local mouse = player:GetMouse()

		task.spawn(function()
			while active do
				BarGlow.Position = UDim2.new(-1, 0, 0, 0)
				TweenService:Create(BarGlow, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Position = UDim2.new(1.5, 0, 0, 0)}):Play()
				task.wait(2)
			end
		end)

		local renderConn
		renderConn = RunService.RenderStepped:Connect(function()
			if not active then renderConn:Disconnect() return end
			local moveX = (mouse.X - (LoadBG.AbsoluteSize.X / 2)) / 120
			local moveY = (mouse.Y - (LoadBG.AbsoluteSize.Y / 2)) / 120
			LoadContent.Position = UDim2.new(0.5, moveX, 0.5, moveY)
			RotateRing.Rotation = RotateRing.Rotation + 2
			BigRing.Rotation = BigRing.Rotation - 0.2
			local progress = math.floor(BarFill.Size.X.Scale * 100)
			PercentText.Text = progress .. "%"
			if math.random(1, 10) == 1 then CreateParticle() end
		end)

		local startInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		UserImg.Position = UserImg.Position - UDim2.new(0, 0, 0, 50)
		LoadTitle.Position = LoadTitle.Position + UDim2.new(0, 0, 0, 30)

		TweenService:Create(UserImg, startInfo, {ImageTransparency = 0, Position = UDim2.new(0.5, -55, 0, 20)}):Play()
		TweenService:Create(RotateRing, startInfo, {ImageTransparency = 0.5}):Play()
		TweenService:Create(BigRing, startInfo, {ImageTransparency = 0.96}):Play()
		TweenService:Create(LoadTitle, startInfo, {TextTransparency = 0, Position = UDim2.new(0, 0, 0, 145)}):Play()
		TweenService:Create(BarBack, startInfo, {BackgroundTransparency = 0}):Play()
		TweenService:Create(PercentText, startInfo, {TextTransparency = 0}):Play()
		TweenService:Create(TipText, startInfo, {TextTransparency = 0}):Play()

		local pulse = TweenService:Create(UserImg, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Size = UDim2.new(0, 115, 0, 115), Position = UDim2.new(0.5, -57, 0, 17)})
		pulse:Play()

		local loader = TweenService:Create(BarFill, TweenInfo.new(4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
		loader:Play()
		loader.Completed:Wait()

		local successFlash = Instance.new("Frame")
		successFlash.Size = UDim2.new(0,0,0,0)
		successFlash.Position = UDim2.new(0.5,0,0,212)
		successFlash.BackgroundColor3 = Color3.new(1,1,1)
		successFlash.Parent = LoadContent
		Instance.new("UICorner", successFlash).CornerRadius = UDim.new(1,0)
		TweenService:Create(successFlash, TweenInfo.new(0.5), {Size = UDim2.new(0,300,0,10), Position = UDim2.new(0.5,-150,0,207), BackgroundTransparency = 1}):Play()

		PercentText.Text = "100%"
		task.wait(0.6)
		active = false
		pulse:Cancel()

		local closeInfo = TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		TweenService:Create(LoadBG, fadeInfo, {BackgroundTransparency = 1}):Play()
		TweenService:Create(Vignette, fadeInfo, {ImageTransparency = 1}):Play()
		TweenService:Create(BigRing, fadeInfo, {ImageTransparency = 1}):Play()

		local exitItems = {
			{obj = UserImg, delay = 0},
			{obj = RotateRing, delay = 0},
			{obj = LoadTitle, delay = 0.1},
			{obj = BarBack, delay = 0.2},
			{obj = PercentText, delay = 0.25},
			{obj = TipText, delay = 0.3}
		}

		for _, data in pairs(exitItems) do
			task.spawn(function()
				task.wait(data.delay)
				local targetPos = data.obj.Position + UDim2.new(0, 250, 0, 0)
				if data.obj:IsA("ImageLabel") then
					TweenService:Create(data.obj, closeInfo, {Position = targetPos, ImageTransparency = 1, BackgroundTransparency = 1}):Play()
					local stroke = data.obj:FindFirstChildOfClass("UIStroke")
					if stroke then TweenService:Create(stroke, fadeInfo, {Transparency = 1}):Play() end
				elseif data.obj:IsA("TextLabel") then
					TweenService:Create(data.obj, closeInfo, {Position = targetPos, TextTransparency = 1}):Play()
				elseif data.obj:IsA("Frame") then
					TweenService:Create(data.obj, closeInfo, {Position = targetPos, BackgroundTransparency = 1}):Play()
				end
			end)
		end

		task.wait(1.2)
		LoadingGui:Destroy()
		MainFrame.Visible = true
	end)
end

local function PlayClick()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://6895079853"
	sound.Volume = 0.3
	sound.Parent = ScreenGui
	sound:Play()
	sound.Ended:Connect(function() sound:Destroy() end)
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

-- [ESP SİSTEMİ]
local ESP_FOLDER = Instance.new("Folder", ScreenGui)
ESP_FOLDER.Name = "ESP_Storage"
_G.ESP_Enabled = false

local function CreateESP(p)
	if p == player then return end
	local function ApplyESP(char)
		if not _G.ESP_Enabled then return end
		for _, v in pairs(ESP_FOLDER:GetChildren()) do
			if v:GetAttribute("Target") == p.UserId then v:Destroy() end
		end

		local Highlight = Instance.new("Highlight")
		Highlight.Name = "GeminiESP"
		Highlight.Adornee = char
		Highlight.FillTransparency = 0.5
		Highlight.FillColor = COLORS.ACCENT
		Highlight.OutlineColor = COLORS.WHITE
		Highlight.Parent = ESP_FOLDER
		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		Highlight:SetAttribute("Target", p.UserId)

		local Billboard = Instance.new("BillboardGui")
		Billboard.Name = "GeminiESP_UI"
		Billboard.Adornee = char:WaitForChild("Head")
		Billboard.Size = UDim2.new(0, 120, 0, 35)
		Billboard.StudsOffset = Vector3.new(0, 3.5, 0)
		Billboard.AlwaysOnTop = true
		Billboard.Parent = ESP_FOLDER
		Billboard:SetAttribute("Target", p.UserId)

		local Container = Instance.new("Frame")
		Container.Size = UDim2.new(1, 0, 1, 0)
		Container.BackgroundTransparency = 1
		Container.Parent = Billboard

		local pImg = Instance.new("ImageLabel")
		pImg.Size = UDim2.new(0, 28, 0, 28)
		pImg.Position = UDim2.new(0, 0, 0.5, -14)
		pImg.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		pImg.Parent = Container
		Instance.new("UICorner", pImg).CornerRadius = UDim.new(1, 0)
		Instance.new("UIStroke", pImg).Color = COLORS.ACCENT

		local pName = Instance.new("TextLabel")
		pName.Size = UDim2.new(1, -35, 1, 0)
		pName.Position = UDim2.new(0, 35, 0, 0)
		pName.Text = p.DisplayName
		pName.TextColor3 = COLORS.WHITE
		pName.Font = Enum.Font.GothamBold
		pName.TextSize = 12
		pName.TextXAlignment = Enum.TextXAlignment.Left
		pName.BackgroundTransparency = 1
		pName.Parent = Container
	end
	p.CharacterAdded:Connect(ApplyESP)
	if p.Character then ApplyESP(p.Character) end
end

local function ToggleESP(state)
	_G.ESP_Enabled = state
	ESP_FOLDER:ClearAllChildren()
	if state then for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end end
end

-- Shadow/Glow Effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.new(0,0,0)
Shadow.ImageTransparency = 0.4
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = COLORS.SIDE
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

-- Sidebar Line
local Line = Instance.new("Frame")
Line.Size = UDim2.new(0, 2, 0, 320)
Line.Position = UDim2.new(1, -2, 0.5, -160)
Line.BackgroundColor3 = COLORS.ACCENT
Line.BackgroundTransparency = 0.8
Line.BorderSizePixel = 0
Line.Parent = Sidebar

-- [PROFIL]
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 45, 0, 45)
Avatar.Position = UDim2.new(0, 15, 0, 15)
Avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Avatar.Parent = Sidebar
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
local UIStroke = Instance.new("UIStroke", Avatar)
UIStroke.Color = COLORS.ACCENT
UIStroke.Thickness = 2

local NameLabel = Instance.new("TextLabel")
NameLabel.Text = player.DisplayName
NameLabel.Size = UDim2.new(1, -70, 0, 45)
NameLabel.Position = UDim2.new(0, 65, 0, 15)
NameLabel.TextColor3 = COLORS.WHITE
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 13
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.BackgroundTransparency = 1
NameLabel.Parent = Sidebar

local MiniDash = Instance.new("Frame")
MiniDash.Size = UDim2.new(1, -20, 0, 90)
MiniDash.Position = UDim2.new(0, 10, 1, -100)
MiniDash.BackgroundColor3 = COLORS.DARK_GRAY
MiniDash.Parent = Sidebar
Instance.new("UICorner", MiniDash).CornerRadius = UDim.new(0, 8)

local function CreateDashLabel(pos, icon)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, -15, 0, 22)
	l.Position = pos
	l.BackgroundTransparency = 1
	l.TextColor3 = COLORS.GRAY
	l.Font = Enum.Font.Code
	l.TextSize = 10
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Text = ""
	l.Parent = MiniDash
	return l
end

local AgeLabel = CreateDashLabel(UDim2.new(0, 10, 0, 10))
local ServerLabel = CreateDashLabel(UDim2.new(0, 10, 0, 35))
local PosLabel = CreateDashLabel(UDim2.new(0, 10, 0, 60))

-- [TOP BAR INTEL]
local IntelBar = Instance.new("Frame")
IntelBar.Size = UDim2.new(0, 350, 0, 35)
IntelBar.Position = UDim2.new(0, 175, 0, 15)
IntelBar.BackgroundColor3 = COLORS.SIDE
IntelBar.Parent = MainFrame
Instance.new("UICorner", IntelBar).CornerRadius = UDim.new(0, 6)

local IntelText = Instance.new("TextLabel")
IntelText.Size = UDim2.new(1, -20, 1, 0)
IntelText.Position = UDim2.new(0, 10, 0, 0)
IntelText.BackgroundTransparency = 1
IntelText.TextColor3 = COLORS.ACCENT
IntelText.Font = Enum.Font.Code
IntelText.TextSize = 12
IntelText.TextXAlignment = Enum.TextXAlignment.Center
IntelText.Parent = IntelBar

-- [PAGES]
local Pages = Instance.new("Frame")
Pages.Position = UDim2.new(0, 175, 0, 65)
Pages.Size = UDim2.new(0, 350, 0, 320)
Pages.BackgroundTransparency = 1
Pages.Parent = MainFrame

local function CreatePage(name)
	local f = Instance.new("ScrollingFrame")
	f.Name = name
	f.Size = UDim2.new(1, 0, 1, 0)
	f.BackgroundTransparency = 1
	f.ScrollBarThickness = 2
	f.ScrollBarImageColor3 = COLORS.ACCENT
	f.Visible = false
	f.Parent = Pages
	Instance.new("UIListLayout", f).Padding = UDim.new(0, 8)
	return f
end

local MainTab = CreatePage("Main")
local StuffTab = CreatePage("Stuff")

local TabContainer = Instance.new("Frame")
TabContainer.Position = UDim2.new(0, 10, 0, 75)
TabContainer.Size = UDim2.new(1, -20, 0, 200)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)

local function AddTab(name, page)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 40)
	b.BackgroundColor3 = COLORS.DARK_GRAY
	b.Text = name:upper()
	b.TextColor3 = COLORS.GRAY
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.Parent = TabContainer
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

	b.MouseButton1Click:Connect(function()
		PlayClick()
		for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
		for _, btn in pairs(TabContainer:GetChildren()) do if btn:IsA("TextButton") then TweenService:Create(btn, TweenInfo.new(0.3), {TextColor3 = COLORS.GRAY, BackgroundColor3 = COLORS.DARK_GRAY}):Play() end end
		page.Visible = true
		TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = COLORS.ACCENT, BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
	end)
end

AddTab("Main Features", MainTab)
AddTab("Stuff & Players", StuffTab)

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
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

	local Indicator = Instance.new("Frame")
	Indicator.Size = UDim2.new(0, 4, 0, 20)
	Indicator.Position = UDim2.new(1, -10, 0.5, -10)
	Indicator.BackgroundColor3 = COLORS.DARK_GRAY
	Indicator.Parent = b
	Instance.new("UICorner", Indicator)

	local active = false
	b.MouseButton1Click:Connect(function()
		PlayClick()
		active = not active
		TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = active and COLORS.ACCENT or COLORS.DARK_GRAY}):Play()
		TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = active and COLORS.ACCENT or COLORS.WHITE}):Play()
		callback(active)
	end)
end

-- [PLAYER LIST]
local function AddPlayerList(parent)
	local Holder = Instance.new("Frame")
	Holder.Size = UDim2.new(1, 0, 0, 200)
	Holder.BackgroundColor3 = COLORS.SIDE
	Holder.Parent = parent
	Instance.new("UICorner", Holder)

	local List = Instance.new("ScrollingFrame")
	List.Size = UDim2.new(1, -10, 1, -10)
	List.Position = UDim2.new(0, 5, 0, 5)
	List.BackgroundTransparency = 1
	List.ScrollBarThickness = 2
	List.Parent = Holder
	Instance.new("UIListLayout", List).Padding = UDim.new(0, 5)

	local function BringPlayer(targetPlr)
		if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local targetHRP = targetPlr.Character.HumanoidRootPart
				local myHRP = player.Character.HumanoidRootPart
				targetHRP.CFrame = myHRP.CFrame * CFrame.new(0, 0, -3)
			end
		end
	end

	local function Refresh()
		for _, v in pairs(List:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				local pFrame = Instance.new("Frame")
				pFrame.Size = UDim2.new(1, 0, 0, 40)
				pFrame.BackgroundColor3 = COLORS.DARK_GRAY
				pFrame.Parent = List
				Instance.new("UICorner", pFrame).CornerRadius = UDim.new(0, 4)

				local pIco = Instance.new("ImageLabel")
				pIco.Size = UDim2.new(0, 30, 0, 30)
				pIco.Position = UDim2.new(0, 5, 0.5, -15)
				pIco.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
				pIco.Parent = pFrame
				Instance.new("UICorner", pIco).CornerRadius = UDim.new(1, 0)

				local pName = Instance.new("TextLabel")
				pName.Size = UDim2.new(1, -180, 1, 0)
				pName.Position = UDim2.new(0, 45, 0, 0)
				pName.Text = p.DisplayName
				pName.TextColor3 = COLORS.WHITE
				pName.Font = Enum.Font.GothamMedium
				pName.TextSize = 10
				pName.TextXAlignment = Enum.TextXAlignment.Left
				pName.BackgroundTransparency = 1
				pName.Parent = pFrame

				local BringB = Instance.new("TextButton")
				BringB.Size = UDim2.new(0, 42, 0, 24)
				BringB.Position = UDim2.new(1, -135, 0.5, -12)
				BringB.BackgroundColor3 = Color3.fromRGB(200, 120, 0)
				BringB.Text = "BRING"
				BringB.TextColor3 = COLORS.WHITE
				BringB.Font = Enum.Font.GothamBold
				BringB.TextSize = 8
				BringB.Parent = pFrame
				Instance.new("UICorner", BringB)

				local TPB = Instance.new("TextButton")
				TPB.Size = UDim2.new(0, 40, 0, 24)
				TPB.Position = UDim2.new(1, -88, 0.5, -12)
				TPB.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
				TPB.Text = "TP"
				TPB.TextColor3 = COLORS.WHITE
				TPB.Font = Enum.Font.GothamBold
				TPB.TextSize = 9
				TPB.Parent = pFrame
				Instance.new("UICorner", TPB)

				local ViewB = Instance.new("TextButton")
				ViewB.Size = UDim2.new(0, 42, 0, 24)
				ViewB.Position = UDim2.new(1, -45, 0.5, -12)
				ViewB.BackgroundColor3 = COLORS.ACCENT
				ViewB.Text = "VIEW"
				ViewB.TextColor3 = COLORS.BG
				ViewB.Font = Enum.Font.GothamBold
				ViewB.TextSize = 9
				ViewB.Parent = pFrame
				Instance.new("UICorner", ViewB)

				BringB.MouseButton1Click:Connect(function() PlayClick(); BringPlayer(p) end)
				TPB.MouseButton1Click:Connect(function() PlayClick(); if p.Character then player.Character:MoveTo(p.Character.HumanoidRootPart.Position) end end)
				ViewB.MouseButton1Click:Connect(function() PlayClick(); camera.CameraSubject = (camera.CameraSubject == player.Character.Humanoid) and p.Character.Humanoid or player.Character.Humanoid end)
			end
		end
	end
	task.spawn(function() while task.wait(5) do Refresh() end end)
	Refresh()
end

-- [CORE FEATURES LOAD]
AddToggle(MainTab, "Aimlock (HARD-STICK)", function(v) _G.Aimlock = v end)
AddToggle(MainTab, "ESP Master (Visual)", function(state) ToggleESP(state) end)

AddPlayerList(StuffTab)
AddToggle(StuffTab, "Auto Clicker (Tool)", function(v) _G.AutoClick = v end)

-- [SYSTEM LOOPS]
RunService.RenderStepped:Connect(function()
	if _G.Aimlock and UserInputService:IsMouseButtonPressed(_G.AimlockKey) then
		if not _G.LockedTarget or not _G.LockedTarget.Character or not _G.LockedTarget.Character:FindFirstChild("Head") or _G.LockedTarget.Character.Humanoid.Health <= 0 then
			_G.LockedTarget = GetClosestPlayer()
		end
		if _G.LockedTarget and _G.LockedTarget.Character and _G.LockedTarget.Character:FindFirstChild("Head") then
			camera.CFrame = CFrame.new(camera.CFrame.Position, _G.LockedTarget.Character.Head.Position)
		end
	else
		_G.LockedTarget = nil
	end
	for _, item in pairs(ESP_FOLDER:GetChildren()) do
		local targetId = item:GetAttribute("Target")
		if targetId then
			local isTarget = (_G.LockedTarget and _G.LockedTarget.UserId == targetId)
			if item:IsA("Highlight") then item.FillColor = isTarget and COLORS.TARGET or COLORS.ACCENT end
		end
	end
end)

local start = os.time()
RunService.Heartbeat:Connect(function()
	local fps = math.floor(1/RunService.RenderStepped:Wait())
	local ping = math.floor(player:GetNetworkPing()*1000)
	IntelText.Text = string.format("PING: %dms  |  FPS: %d  |  UPTIME: %ds", ping, fps, os.time()-start)

	AgeLabel.Text = "🛡️ ACCOUNT AGE: " .. player.AccountAge .. "D"
	ServerLabel.Text = "👥 SERVER: " .. #Players:GetPlayers() .. " PLRS"
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local pos = player.Character.HumanoidRootPart.Position
		PosLabel.Text = string.format("📍 POS: %d, %d, %d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
	end

	if _G.AutoClick and player.Character then
		local tool = player.Character:FindFirstChildOfClass("Tool")
		if tool then tool:Activate() end
	end
end)

UserInputService.JumpRequest:Connect(function() if _G.InfJump and player.Character then local h = player.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)
UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightControl then MainFrame.Visible = not MainFrame.Visible end end)

-- [DRAG SYSTEM]
local d, ds, sp
MainFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = i.Position - ds MainFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
	end end)
MainFrame.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)

MainTab.Visible = true

-- [KODU BAŞLAT]
StartLoading()
print("qimpflex Hub v2 Loaded in CoreGui.")
print('inj')
