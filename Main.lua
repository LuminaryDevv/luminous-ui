-- Luminous-ui By LuminaryDevv
-- ANY MODIFICATION OR REUSE OF ASSETS IS STRICTLY PROHIBITED.
local GetService = game.GetService
local Clone = game.Clone 
local Destroy = game.Destroy 

if (not game:IsLoaded()) then
	local Loaded = game.Loaded
	Loaded.Wait(Loaded);
end

--// Important 
local Setup = {
	Keybind = Enum.KeyCode.LeftControl,
	Transparency = 0.2,
	ThemeMode = "Dark",
	Size = nil,
	ConfigFolder = nil,
}

-- Config system
local Config = {
	CurrentConfig = nil,
	SavedConfigs = {},
}

local function GetConfigFolder()
	if Setup.ConfigFolder then return Setup.ConfigFolder end
	local folder = Instance.new("Folder")
	folder.Name = "LuminousUIConfigs"
	folder.Parent = game:GetService("Players").LocalPlayer
	Setup.ConfigFolder = folder
	return folder
end

function Config:Save(name)
	local configData = {
		Name = name,
		Theme = Setup.ThemeMode,
		ThemeName = Setup.CurrentThemeName or "Dark",
		Transparency = Setup.Transparency,
		Keybind = Setup.Keybind,
		Size = Setup.Size,
		BlurEnabled = Setup.BlurEnabled or false,
		SavedAt = os.date("%Y-%m-%d %H:%M:%S"),
	}
	
	local configString = game:GetService("HttpService"):JSONEncode(configData)
	
	local configFile = Instance.new("StringValue")
	configFile.Name = name
	configFile.Value = configString
	configFile.Parent = GetConfigFolder()
	
	Config.SavedConfigs[name] = configData
	return configData
end

function Config:Load(name)
	local configFile = GetConfigFolder():FindFirstChild(name)
	if not configFile then return false end
	
	local success, data = pcall(function()
		return game:GetService("HttpService"):JSONDecode(configFile.Value)
	end)
	
	if not success or not data then return false end
	
	if data.ThemeName then
		Setup.CurrentThemeName = data.ThemeName
		if Options and Options.SetTheme then
			Options:SetTheme(data.ThemeName)
		end
	end
	
	if data.Transparency then
		Setup.Transparency = data.Transparency
	end
	
	if data.Keybind then
		Setup.Keybind = data.Keybind
	end
	
	if data.Size then
		Setup.Size = data.Size
	end
	
	return true
end

function Config:GetAll()
	local configs = {}
	for _, child in ipairs(GetConfigFolder():GetChildren()) do
		if child:IsA("StringValue") then
			local success, data = pcall(function()
				return game:GetService("HttpService"):JSONDecode(child.Value)
			end)
			if success and data then
				table.insert(configs, data)
			end
		end
	end
	return configs
end

function Config:Delete(name)
	local configFile = GetConfigFolder():FindFirstChild(name)
	if configFile then
		configFile:Destroy()
		return true
	end
	return false
end

local Theme = {
	Primary = Color3.fromRGB(30, 30, 30),
	Secondary = Color3.fromRGB(35, 35, 35),
	Component = Color3.fromRGB(40, 40, 40),
	Interactables = Color3.fromRGB(45, 45, 45),
	Tab = Color3.fromRGB(200, 200, 200),
	Title = Color3.fromRGB(240, 240, 240),
	Description = Color3.fromRGB(200, 200, 200),
	Shadow = Color3.fromRGB(0, 0, 0),
	Outline = Color3.fromRGB(40, 40, 40),
	Icon = Color3.fromRGB(220, 220, 220),
	Accent = Color3.fromRGB(153, 155, 255),
	Dynamic = false,
}

local BuiltInThemes = {
	Dark = {
		Primary = Color3.fromRGB(30, 30, 30),
		Secondary = Color3.fromRGB(35, 35, 35),
		Component = Color3.fromRGB(40, 40, 40),
		Interactables = Color3.fromRGB(45, 45, 45),
		Tab = Color3.fromRGB(200, 200, 200),
		Title = Color3.fromRGB(240, 240, 240),
		Description = Color3.fromRGB(200, 200, 200),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(40, 40, 40),
		Icon = Color3.fromRGB(220, 220, 220),
		Dynamic = false,
	},
	Light = {
		Primary = Color3.fromRGB(232, 232, 232),
		Secondary = Color3.fromRGB(255, 255, 255),
		Component = Color3.fromRGB(245, 245, 245),
		Interactables = Color3.fromRGB(235, 235, 235),
		Tab = Color3.fromRGB(50, 50, 50),
		Title = Color3.fromRGB(0, 0, 0),
		Description = Color3.fromRGB(100, 100, 100),
		Shadow = Color3.fromRGB(255, 255, 255),
		Outline = Color3.fromRGB(210, 210, 210),
		Icon = Color3.fromRGB(100, 100, 100),
		Dynamic = false,
	},
	Void = {
		Primary = Color3.fromRGB(15, 15, 15),
		Secondary = Color3.fromRGB(20, 20, 20),
		Component = Color3.fromRGB(25, 25, 25),
		Interactables = Color3.fromRGB(30, 30, 30),
		Tab = Color3.fromRGB(200, 200, 200),
		Title = Color3.fromRGB(240, 240, 240),
		Description = Color3.fromRGB(200, 200, 200),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(40, 40, 40),
		Icon = Color3.fromRGB(220, 220, 220),
		Dynamic = false,
	},
	Diamond = {
		Primary = Color3.fromRGB(10, 25, 40),
		Secondary = Color3.fromRGB(15, 35, 55),
		Component = Color3.fromRGB(20, 45, 70),
		Interactables = Color3.fromRGB(30, 65, 95),
		Tab = Color3.fromRGB(0, 255, 255),
		Title = Color3.fromRGB(180, 255, 255),
		Description = Color3.fromRGB(120, 200, 220),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(0, 180, 200),
		Icon = Color3.fromRGB(0, 230, 255),
		Dynamic = false,
	},
	Gold = {
		Primary = Color3.fromRGB(50, 40, 20),
		Secondary = Color3.fromRGB(80, 65, 35),
		Component = Color3.fromRGB(110, 90, 50),
		Interactables = Color3.fromRGB(150, 125, 70),
		Tab = Color3.fromRGB(255, 220, 80),
		Title = Color3.fromRGB(255, 240, 150),
		Description = Color3.fromRGB(230, 200, 100),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(180, 145, 60),
		Icon = Color3.fromRGB(255, 210, 70),
		Dynamic = false,
	},
	DeepSea = {
		Primary = Color3.fromRGB(8, 18, 35),
		Secondary = Color3.fromRGB(12, 28, 48),
		Component = Color3.fromRGB(18, 38, 58),
		Interactables = Color3.fromRGB(28, 58, 88),
		Tab = Color3.fromRGB(100, 180, 255),
		Title = Color3.fromRGB(160, 210, 255),
		Description = Color3.fromRGB(120, 170, 220),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(40, 80, 120),
		Icon = Color3.fromRGB(80, 160, 255),
		Dynamic = false,
	},
	Emerald = {
		Primary = Color3.fromRGB(20, 55, 35),
		Secondary = Color3.fromRGB(25, 70, 45),
		Component = Color3.fromRGB(35, 90, 55),
		Interactables = Color3.fromRGB(50, 120, 75),
		Tab = Color3.fromRGB(80, 255, 140),
		Title = Color3.fromRGB(150, 255, 180),
		Description = Color3.fromRGB(120, 200, 150),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(50, 150, 80),
		Icon = Color3.fromRGB(100, 255, 150),
		Dynamic = false,
	},
	Ruby = {
		Primary = Color3.fromRGB(60, 20, 25),
		Secondary = Color3.fromRGB(80, 25, 30),
		Component = Color3.fromRGB(100, 35, 40),
		Interactables = Color3.fromRGB(140, 50, 55),
		Tab = Color3.fromRGB(255, 80, 100),
		Title = Color3.fromRGB(255, 150, 160),
		Description = Color3.fromRGB(220, 120, 130),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(180, 50, 60),
		Icon = Color3.fromRGB(255, 100, 120),
		Dynamic = false,
	},
	Camo = {
		Primary = Color3.fromRGB(45, 55, 35),
		Secondary = Color3.fromRGB(55, 65, 42),
		Component = Color3.fromRGB(65, 75, 48),
		Interactables = Color3.fromRGB(75, 85, 55),
		Tab = Color3.fromRGB(140, 170, 100),
		Title = Color3.fromRGB(200, 220, 150),
		Description = Color3.fromRGB(150, 170, 120),
		Shadow = Color3.fromRGB(20, 25, 15),
		Outline = Color3.fromRGB(70, 85, 50),
		Icon = Color3.fromRGB(120, 150, 80),
		Dynamic = false,
	},
	Galaxy = {
		Primary = Color3.fromRGB(15, 10, 35),
		Secondary = Color3.fromRGB(35, 18, 55),
		Component = Color3.fromRGB(55, 28, 80),
		Interactables = Color3.fromRGB(85, 45, 115),
		Tab = Color3.fromRGB(255, 100, 180),
		Title = Color3.fromRGB(255, 160, 220),
		Description = Color3.fromRGB(200, 120, 180),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(140, 70, 150),
		Icon = Color3.fromRGB(255, 120, 200),
		Dynamic = false,
	},
	Amethyst = {
		Primary = Color3.fromRGB(60, 35, 70),
		Secondary = Color3.fromRGB(85, 50, 95),
		Component = Color3.fromRGB(110, 70, 120),
		Interactables = Color3.fromRGB(145, 100, 155),
		Tab = Color3.fromRGB(220, 150, 255),
		Title = Color3.fromRGB(240, 190, 255),
		Description = Color3.fromRGB(190, 140, 215),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(130, 85, 150),
		Icon = Color3.fromRGB(215, 145, 245),
		Dynamic = false,
	},
	Topaz = {
		Primary = Color3.fromRGB(70, 45, 25),
		Secondary = Color3.fromRGB(95, 60, 35),
		Component = Color3.fromRGB(120, 80, 45),
		Interactables = Color3.fromRGB(155, 105, 60),
		Tab = Color3.fromRGB(255, 180, 80),
		Title = Color3.fromRGB(255, 210, 130),
		Description = Color3.fromRGB(220, 160, 90),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(170, 115, 55),
		Icon = Color3.fromRGB(255, 170, 70),
		Dynamic = false,
	},
	Rainbow = {
		Primary = Color3.fromRGB(30, 30, 40),
		Secondary = Color3.fromRGB(40, 35, 50),
		Component = Color3.fromRGB(55, 45, 65),
		Interactables = Color3.fromRGB(80, 65, 95),
		Tab = Color3.fromRGB(255, 100, 100),
		Title = Color3.fromRGB(255, 200, 100),
		Description = Color3.fromRGB(100, 255, 150),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(100, 200, 255),
		Icon = Color3.fromRGB(255, 150, 255),
		Dynamic = true,
	},
	Wooden = {
		Primary = Color3.fromRGB(65, 45, 30),
		Secondary = Color3.fromRGB(85, 60, 40),
		Component = Color3.fromRGB(105, 75, 50),
		Interactables = Color3.fromRGB(135, 100, 70),
		Tab = Color3.fromRGB(180, 130, 85),
		Title = Color3.fromRGB(220, 180, 130),
		Description = Color3.fromRGB(160, 120, 85),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(115, 80, 55),
		Icon = Color3.fromRGB(195, 145, 95),
		Dynamic = false,
	},
	Silver = {
		Primary = Color3.fromRGB(70, 75, 85),
		Secondary = Color3.fromRGB(95, 100, 110),
		Component = Color3.fromRGB(120, 125, 135),
		Interactables = Color3.fromRGB(150, 155, 165),
		Tab = Color3.fromRGB(200, 205, 215),
		Title = Color3.fromRGB(235, 240, 250),
		Description = Color3.fromRGB(170, 175, 185),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(100, 105, 115),
		Icon = Color3.fromRGB(190, 195, 210),
		Dynamic = false,
	},
	Sky = {
		Primary = Color3.fromRGB(100, 150, 200),
		Secondary = Color3.fromRGB(135, 180, 225),
		Component = Color3.fromRGB(170, 205, 240),
		Interactables = Color3.fromRGB(200, 225, 250),
		Tab = Color3.fromRGB(255, 245, 220),
		Title = Color3.fromRGB(255, 250, 235),
		Description = Color3.fromRGB(220, 235, 250),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(120, 170, 215),
		Icon = Color3.fromRGB(255, 235, 180),
		Dynamic = false,
	},
	Violet = {
		Primary = Color3.fromRGB(35, 25, 70),
		Secondary = Color3.fromRGB(50, 35, 95),
		Component = Color3.fromRGB(70, 50, 120),
		Interactables = Color3.fromRGB(100, 75, 155),
		Tab = Color3.fromRGB(150, 120, 255),
		Title = Color3.fromRGB(200, 180, 255),
		Description = Color3.fromRGB(145, 120, 210),
		Shadow = Color3.fromRGB(0, 0, 0),
		Outline = Color3.fromRGB(100, 70, 160),
		Icon = Color3.fromRGB(170, 120, 255),
		Dynamic = false,
	},
}

--// Services & Functions
local Type, Blur = nil
local LocalPlayer = GetService(game, "Players").LocalPlayer
local Services = {
	Insert = GetService(game, "InsertService"),
	Tween = GetService(game, "TweenService"),
	Run = GetService(game, "RunService"),
	Input = GetService(game, "UserInputService"),
}

local Player = {
	Mouse = LocalPlayer:GetMouse(),
	GUI = LocalPlayer.PlayerGui,
}

local Tween = function(Object, Speed, Properties, Info)
	local Style, Direction
	if Info then
		Style, Direction = Info["EasingStyle"], Info["EasingDirection"]
	else
		Style, Direction = Enum.EasingStyle.Sine, Enum.EasingDirection.Out
	end
	return Services.Tween:Create(Object, TweenInfo.new(Speed, Style, Direction), Properties):Play()
end

local SetProperty = function(Object, Properties)
	for Index, Property in next, Properties do
		Object[Index] = Property
	end
	return Object
end

local Multiply = function(Value, Amount)
	local New = {
		Value.X.Scale * Amount,
		Value.X.Offset * Amount,
		Value.Y.Scale * Amount,
		Value.Y.Offset * Amount,
	}
	return UDim2.new(unpack(New))
end

local Color = function(Color, Factor, Mode)
	Mode = Mode or Setup.ThemeMode
	if Mode == "Light" then
		return Color3.fromRGB((Color.R * 255) - Factor, (Color.G * 255) - Factor, (Color.B * 255) - Factor)
	else
		return Color3.fromRGB((Color.R * 255) + Factor, (Color.G * 255) + Factor, (Color.B * 255) + Factor)
	end
end

local Drag = function(Canvas)
	if Canvas then
		local Dragging
		local DragInput
		local Start
		local StartPosition

		local function Update(input)
			local delta = input.Position - Start
			Canvas.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
		end

		Canvas.InputBegan:Connect(function(Input)
			if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) and not Type then
				Dragging = true
				Start = Input.Position
				StartPosition = Canvas.Position

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		Canvas.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch and not Type then
				DragInput = Input
			end
		end)

		Services.Input.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging and not Type then
				Update(Input)
			end
		end)
	end
end

Resizing = { 
	TopLeft = { X = Vector2.new(-1, 0),   Y = Vector2.new(0, -1)},
	TopRight = { X = Vector2.new(1, 0),    Y = Vector2.new(0, -1)},
	BottomLeft = { X = Vector2.new(-1, 0),   Y = Vector2.new(0, 1)},
	BottomRight = { X = Vector2.new(1, 0),    Y = Vector2.new(0, 1)},
}

Resizeable = function(Tab, Minimum, Maximum)
	task.spawn(function()
		local MousePos, Size, UIPos = nil, nil, nil
		if Tab and Tab:FindFirstChild("Resize") then
			local Positions = Tab:FindFirstChild("Resize")
			for Index, Types in next, Positions:GetChildren() do
				Types.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Type = Types
						MousePos = Vector2.new(Player.Mouse.X, Player.Mouse.Y)
						Size = Tab.AbsoluteSize
						UIPos = Tab.Position
					end
				end)
				Types.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Type = nil
					end
				end)
			end
		end
		local Resize = function(Delta)
			if Type and MousePos and Size and UIPos and Tab:FindFirstChild("Resize")[Type.Name] == Type then
				local Mode = Resizing[Type.Name]
				local NewSize = Vector2.new(Size.X + Delta.X * Mode.X.X, Size.Y + Delta.Y * Mode.Y.Y)
				NewSize = Vector2.new(math.clamp(NewSize.X, Minimum.X, Maximum.X), math.clamp(NewSize.Y, Minimum.Y, Maximum.Y))
				local AnchorOffset = Vector2.new(Tab.AnchorPoint.X * Size.X, Tab.AnchorPoint.Y * Size.Y)
				local NewAnchorOffset = Vector2.new(Tab.AnchorPoint.X * NewSize.X, Tab.AnchorPoint.Y * NewSize.Y)
				local DeltaAnchorOffset = NewAnchorOffset - AnchorOffset
				Tab.Size = UDim2.new(0, NewSize.X, 0, NewSize.Y)
				local NewPosition = UDim2.new(
					UIPos.X.Scale, 
					UIPos.X.Offset + DeltaAnchorOffset.X * Mode.X.X,
					UIPos.Y.Scale,
					UIPos.Y.Offset + DeltaAnchorOffset.Y * Mode.Y.Y
				)
				Tab.Position = NewPosition
			end
		end
		Player.Mouse.Move:Connect(function()
			if Type then
				Resize(Vector2.new(Player.Mouse.X, Player.Mouse.Y) - MousePos)
			end
		end)
	end)
end

--// Setup [UI]
if (identifyexecutor) then
	Screen = Services.Insert:LoadLocalAsset("rbxassetid://18490507748")
	Blur = loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Assets/Blur.lua"))()
else
	Screen = (script.Parent)
	Blur = require(script.Blur)
end

Screen.Main.Visible = false

xpcall(function()
	Screen.Parent = game.CoreGui
end, function() 
	Screen.Parent = Player.GUI
end)

--// Tables for Data
local Animations = {}
local Blurs = {}
local Components = (Screen:FindFirstChild("Components"))
local Library = {}
local StoredInfo = {
	["Sections"] = {},
	["Tabs"] = {}
}

--// Dynamic Rainbow variables
local rainbowHue = 0
local rainbowConnection = nil

--// Function to apply current theme colors
local function ApplyTheme()
	if not Screen then return end
	
	for Index, Descendant in next, Screen:GetDescendants() do
		local Name, Class = Themes.Names[Descendant.Name], Themes.Classes[Descendant.ClassName]
		if Name then
			Name(Descendant)
		elseif Class then
			Class(Descendant)
		end
	end
end

--// Animations [Window]
function Animations:Open(Window, Transparency, UseCurrentSize)
	local Original = (UseCurrentSize and Window.Size) or Setup.Size
	local Multiplied = Multiply(Original, 1.1)
	local Shadow = Window:FindFirstChildOfClass("UIStroke")
	
	if Shadow then
		SetProperty(Shadow, { Transparency = 1 })
	end
	SetProperty(Window, {
		Size = Multiplied,
		GroupTransparency = 1,
		Visible = true,
	})

	if Shadow then
		Tween(Shadow, .25, { Transparency = 0.5 })
	end
	Tween(Window, .25, {
		Size = Original,
		GroupTransparency = Transparency or 0,
	})
end

function Animations:Close(Window)
	local Original = Window.Size
	local Multiplied = Multiply(Original, 1.1)
	local Shadow = Window:FindFirstChildOfClass("UIStroke")

	SetProperty(Window, {
		Size = Original,
	})

	if Shadow then
		Tween(Shadow, .25, { Transparency = 1 })
	end
	Tween(Window, .25, {
		Size = Multiplied,
		GroupTransparency = 1,
	})

	task.wait(.25)
	Window.Size = Original
	Window.Visible = false
end

function Animations:Component(Component, Custom)
	Component.InputBegan:Connect(function() 
		if Custom then
			Tween(Component, .25, { Transparency = .85 })
		else
			Tween(Component, .25, { BackgroundColor3 = Color(Theme.Component, 5, Setup.ThemeMode) })
		end
	end)

	Component.InputEnded:Connect(function() 
		if Custom then
			Tween(Component, .25, { Transparency = 1 })
		else
			Tween(Component, .25, { BackgroundColor3 = Theme.Component })
		end
	end)
end

function Library:CreateWindow(Settings)
	if not Screen then
		error("[Luminous UI] Screen not loaded. Asset ID may be invalid.")
	end
	
	local MainTemplate = Screen:FindFirstChild("Main")
	if not MainTemplate then
		error("[Luminous UI] Main UI template not found in loaded asset.")
	end
	
	local Window = Clone(MainTemplate)
	local Sidebar = Window:FindFirstChild("Sidebar")
	local Holder = Window:FindFirstChild("Main")
	local BG = Window:FindFirstChild("BackgroundShadow")
	local Tab = Sidebar:FindFirstChild("Tab")

	local Options = {}
	local Examples = {}
	local Opened = true
	local Maximized = false
	local BlurEnabled = false
	local MinimizedBar = nil

	for Index, Example in next, Window:GetDescendants() do
		if Example.Name:find("Example") and not Examples[Example.Name] then
			Examples[Example.Name] = Example
		end
	end

	--// UI Blur & More
	Drag(Window)
	Resizeable(Window, Vector2.new(411, 271), Vector2.new(9e9, 9e9))
	Setup.Transparency = Settings.Transparency or 0
	Setup.Size = Settings.Size or UDim2.new(0, 550, 0, 450)
	Setup.ThemeMode = Settings.Theme or "Dark"
	Setup.BlurEnabled = Settings.Blurring or false

	if Settings.Blurring then
		Blurs[Settings.Title] = Blur.new(Window, 5)
		BlurEnabled = true
	end

	if Settings.MinimizeKeybind then
		Setup.Keybind = Settings.MinimizeKeybind
	end

	--// TOPBAR (WindUI style - layout driven)
	local TopBar = Sidebar.Top
	
	for _, child in ipairs(TopBar:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("ImageButton") then
			child:Destroy()
		end
	end
	
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.ClipsDescendants = true
	TopBar.BackgroundTransparency = 0
	TopBar.BackgroundColor3 = Theme.Secondary
	
	-- MAIN LAYOUT (horizontal with space between)
	local mainLayout = Instance.new("UIListLayout")
	mainLayout.FillDirection = Enum.FillDirection.Horizontal
	mainLayout.HorizontalAlignment = Enum.HorizontalAlignment.SpaceBetween
	mainLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	mainLayout.Padding = UDim.new(0, 12)
	mainLayout.Parent = TopBar
	
	-- Left side: Title area
	local TitleFrame = Instance.new("Frame")
	TitleFrame.Name = "TitleFrame"
	TitleFrame.Size = UDim2.new(1, -100, 1, 0)
	TitleFrame.BackgroundTransparency = 1
	TitleFrame.Parent = TopBar
	
	-- Text layout (vertical)
	local textLayout = Instance.new("UIListLayout")
	textLayout.FillDirection = Enum.FillDirection.Vertical
	textLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	textLayout.Padding = UDim.new(0, 2)
	textLayout.Parent = TitleFrame
	
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, 0, 0, 18)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = Settings.Title or "Luminous UI"
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextTruncate = Enum.TextTruncate.None
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Parent = TitleFrame

	local SubLabel = Instance.new("TextLabel")
	SubLabel.Size = UDim2.new(1, 0, 0, 14)
	SubLabel.BackgroundTransparency = 1
	SubLabel.Text = "by LuminaryDevv"
	SubLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	SubLabel.TextSize = 10
	SubLabel.TextXAlignment = Enum.TextXAlignment.Left
	SubLabel.TextTruncate = Enum.TextTruncate.None
	SubLabel.Font = Enum.Font.Gotham
	SubLabel.Parent = TitleFrame

	-- Right side: Buttons container
	local buttonContainer = Instance.new("Frame")
	buttonContainer.Name = "Buttons"
	buttonContainer.Size = UDim2.new(0, 100, 1, 0)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = TopBar
	
	-- Button layout (horizontal, centered)
	local buttonLayout = Instance.new("UIListLayout")
	buttonLayout.FillDirection = Enum.FillDirection.Horizontal
	buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	buttonLayout.Padding = UDim.new(0, 6)
	buttonLayout.Parent = buttonContainer

	-- Button definitions
	local buttons = {
		{name = "Minimize", icon = "rbxassetid://103626408777602"},
		{name = "Maximize", icon = "rbxassetid://6031090978"},
		{name = "Close", icon = "rbxassetid://117747448917698"},
	}

	for _, btnData in ipairs(buttons) do
		local button = Instance.new("ImageButton")
		button.Name = btnData.name
		button.Size = UDim2.new(0, 30, 0, 30)
		button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		button.BackgroundTransparency = 0
		button.BorderSizePixel = 0
		button.Parent = buttonContainer
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = button
		
		local icon = Instance.new("ImageLabel")
		icon.Size = UDim2.new(0, 16, 0, 16)
		icon.Position = UDim2.new(0.5, -8, 0.5, -8)
		icon.BackgroundTransparency = 1
		icon.Image = btnData.icon
		icon.ScaleType = Enum.ScaleType.Fit
		icon.Parent = button
		
		button.MouseEnter:Connect(function()
			if btnData.name == "Close" then
				button.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
			else
				button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
			end
		end)
		button.MouseLeave:Connect(function()
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end)
		
		if btnData.name == "Close" then
			button.MouseButton1Click:Connect(function()
				local confirmFrame = Instance.new("Frame")
				confirmFrame.Size = UDim2.new(0, 300, 0, 140)
				confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -70)
				confirmFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				confirmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				confirmFrame.BackgroundTransparency = 0
				confirmFrame.Parent = Window
				
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(80, 80, 80)
				uiStroke.Thickness = 1
				uiStroke.Parent = confirmFrame
				
				local title = Instance.new("TextLabel")
				title.Size = UDim2.new(1, 0, 0, 35)
				title.Position = UDim2.new(0, 0, 0, 10)
				title.BackgroundTransparency = 1
				title.Text = "Close Confirmation"
				title.TextColor3 = Color3.fromRGB(255, 255, 255)
				title.TextSize = 16
				title.Font = Enum.Font.GothamBold
				title.Parent = confirmFrame
				
				local message = Instance.new("TextLabel")
				message.Size = UDim2.new(1, 0, 0, 40)
				message.Position = UDim2.new(0, 0, 0, 45)
				message.BackgroundTransparency = 1
				message.Text = "Are you sure you want to close?\nThis cannot be undone."
				message.TextColor3 = Color3.fromRGB(200, 200, 200)
				message.TextSize = 13
				message.TextWrapped = true
				message.Parent = confirmFrame
				
				local yesBtn = Instance.new("TextButton")
				yesBtn.Size = UDim2.new(0, 100, 0, 32)
				yesBtn.Position = UDim2.new(0.25, -55, 1, -42)
				yesBtn.AnchorPoint = Vector2.new(0.5, 0)
				yesBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
				yesBtn.Text = "Close"
				yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				yesBtn.TextSize = 13
				yesBtn.Parent = confirmFrame
				
				local noBtn = Instance.new("TextButton")
				noBtn.Size = UDim2.new(0, 100, 0, 32)
				noBtn.Position = UDim2.new(0.75, 55, 1, -42)
				noBtn.AnchorPoint = Vector2.new(0.5, 0)
				noBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
				noBtn.Text = "Cancel"
				noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				noBtn.TextSize = 13
				noBtn.Parent = confirmFrame
				
				yesBtn.MouseButton1Click:Connect(function()
					confirmFrame:Destroy()
					local TargetSize = UDim2.new(0, 50, 0, 30)
					Tween(Window, 0.2, { Size = TargetSize, GroupTransparency = 1 })
					task.wait(0.2)
					if BlurEnabled then
						Blurs[Settings.Title].root:Destroy()
						Blurs[Settings.Title] = nil
					end
					if MinimizedBar then MinimizedBar:Destroy() end
					Window:Destroy()
					Opened = false
				end)
				noBtn.MouseButton1Click:Connect(function()
					confirmFrame:Destroy()
				end)
			end)
		elseif btnData.name == "Maximize" then
			button.MouseButton1Click:Connect(function()
				if Maximized then
					Maximized = false
					Tween(Window, .15, { Size = Setup.Size, Position = UDim2.new(0.5, -Setup.Size.X.Offset/2, 0.5, -Setup.Size.Y.Offset/2) })
				else
					Maximized = true
					Tween(Window, .15, { Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0.5, 0.5) })
				end
			end)
		elseif btnData.name == "Minimize" then
			button.MouseButton1Click:Connect(function()
				if Opened then
					local TargetSize = UDim2.new(0, 50, 0, 30)
					Tween(Window, 0.2, { Size = TargetSize, GroupTransparency = 1 })
					task.wait(0.2)
					
					Opened = false
					Window.Visible = false
					if BlurEnabled then
						Blurs[Settings.Title].root.Parent = nil
					end
					
					if not MinimizedBar or not MinimizedBar.Parent then
						MinimizedBar = Instance.new("Frame")
						MinimizedBar.Name = "MinimizedBar"
						MinimizedBar.Size = UDim2.new(0, 200, 0, 36)
						MinimizedBar.Position = UDim2.new(0.5, -100, 0, 50)
						MinimizedBar.AnchorPoint = Vector2.new(0.5, 0)
						MinimizedBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
						MinimizedBar.BackgroundTransparency = 0
						MinimizedBar.BorderSizePixel = 0
						MinimizedBar.ZIndex = 100
						MinimizedBar.Parent = game.CoreGui
						
						local corner = Instance.new("UICorner")
						corner.CornerRadius = UDim.new(0, 8)
						corner.Parent = MinimizedBar
						
						local stroke = Instance.new("UIStroke")
						stroke.Color = Color3.fromRGB(80, 80, 80)
						stroke.Thickness = 1
						stroke.Parent = MinimizedBar
						
						local icon = Instance.new("ImageLabel")
						icon.Size = UDim2.new(0, 20, 0, 20)
						icon.Position = UDim2.new(0, 8, 0.5, -10)
						icon.BackgroundTransparency = 1
						icon.Image = "rbxassetid://11963373994"
						icon.Parent = MinimizedBar
						
						local titleText = Instance.new("TextLabel")
						titleText.Size = UDim2.new(1, -40, 1, 0)
						titleText.Position = UDim2.new(0, 32, 0, 0)
						titleText.BackgroundTransparency = 1
						titleText.Text = Settings.Title or "Luminous UI"
						titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
						titleText.TextSize = 13
						titleText.TextXAlignment = Enum.TextXAlignment.Left
						titleText.Font = Enum.Font.GothamMedium
						titleText.Parent = MinimizedBar
						
						local dragging = false
						local dragStart, barStart
						MinimizedBar.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								dragging = true
								dragStart = Vector2.new(input.Position.X, input.Position.Y)
								barStart = MinimizedBar.Position
							end
						end)
						Services.Input.InputChanged:Connect(function(input)
							if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
								local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
								MinimizedBar.Position = UDim2.new(barStart.X.Scale, barStart.X.Offset + delta.X, barStart.Y.Scale, barStart.Y.Offset + delta.Y)
							end
						end)
						Services.Input.InputEnded:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								dragging = false
							end
						end)
						
						MinimizedBar.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								MinimizedBar:Destroy()
								MinimizedBar = nil
								Window.Visible = true
								Window.Size = UDim2.new(0, 50, 0, 30)
								Window.GroupTransparency = 1
								Tween(Window, 0.25, { Size = Setup.Size, GroupTransparency = 0 })
								Opened = true
								if BlurEnabled then
									Blurs[Settings.Title].root.Parent = workspace.CurrentCamera
								end
							end
						end)
					else
						MinimizedBar.Visible = true
					end
				end
			end)
		end
	end

	--// Animate (Close/Restore function for keybind)
	local Close = function()
		if Opened then
			local TargetSize = UDim2.new(0, 50, 0, 30)
			Tween(Window, 0.2, { Size = TargetSize, GroupTransparency = 1 })
			task.wait(0.2)
			if BlurEnabled then
				Blurs[Settings.Title].root:Destroy()
				Blurs[Settings.Title] = nil
			end
			if MinimizedBar then MinimizedBar:Destroy() end
			Window:Destroy()
			Opened = false
		else
			Window.Size = UDim2.new(0, 50, 0, 30)
			Window.GroupTransparency = 1
			Window.Visible = true
			Tween(Window, 0.25, { Size = Setup.Size, GroupTransparency = 0 })
			Opened = true
			if BlurEnabled then
				Blurs[Settings.Title].root.Parent = workspace.CurrentCamera
			end
		end
	end

	-- Keybind to close/restore
	Services.Input.InputBegan:Connect(function(Input, Focused) 
		if (Input == Setup.Keybind or Input.KeyCode == Setup.Keybind) and not Focused then
			Close()
		end
	end)

	--// Tab Functions
	function Options:SetTab(Name)
		for Index, Button in next, Tab:GetChildren() do
			if Button:IsA("TextButton") then
				local Opened, SameName = Button.Value, (Button.Name == Name)
				local Padding = Button:FindFirstChildOfClass("UIPadding")

				if SameName and not Opened.Value then
					Tween(Padding, .25, { PaddingLeft = UDim.new(0, 25) })
					Tween(Button, .25, { BackgroundTransparency = 0.9, Size = UDim2.new(1, -15, 0, 30) })
					SetProperty(Opened, { Value = true })
				elseif not SameName and Opened.Value then
					Tween(Padding, .25, { PaddingLeft = UDim.new(0, 20) })
					Tween(Button, .25, { BackgroundTransparency = 1, Size = UDim2.new(1, -44, 0, 30) })
					SetProperty(Opened, { Value = false })
				end
			end
		end

		for Index, Main in next, Holder:GetChildren() do
			if Main:IsA("CanvasGroup") then
				local Opened, SameName = Main.Value, (Main.Name == Name)
				local Scroll = Main:FindFirstChild("ScrollingFrame")

				if SameName and not Opened.Value then
					Opened.Value = true
					Main.Visible = true

					Tween(Main, .3, { GroupTransparency = 0 })
					Tween(Scroll["UIPadding"], .3, { PaddingTop = UDim.new(0, 5) })

				elseif not SameName and Opened.Value then
					Tween(Main, .15, { GroupTransparency = 1 })
					Tween(Scroll["UIPadding"], .15, { PaddingTop = UDim.new(0, 15) })	

					task.delay(.2, function()
						Main.Visible = false
					end)
				end
			end
		end
	end

	function Options:AddTabSection(Settings)
		local Example = Examples["SectionExample"]
		local Section = Clone(Example)

		StoredInfo["Sections"][Settings.Name] = (Settings.Order)
		SetProperty(Section, { 
			Parent = Example.Parent,
			Text = Settings.Name,
			Name = Settings.Name,
			LayoutOrder = Settings.Order,
			Visible = true
		})
	end

	function Options:AddTab(Settings)
		if StoredInfo["Tabs"][Settings.Title] then 
			error("[UI LIB]: A tab with the same name has already been created") 
		end 

		local Example, MainExample = Examples["TabButtonExample"], Examples["MainExample"]
		local Section = StoredInfo["Sections"][Settings.Section]
		local Main = Clone(MainExample)
		local Tab = Clone(Example)

		if not Settings.Icon then
			Destroy(Tab["ICO"])
		else
			SetProperty(Tab["ICO"], { Image = Settings.Icon })
		end

		StoredInfo["Tabs"][Settings.Title] = { Tab }
		SetProperty(Tab["TextLabel"], { Text = Settings.Title })

		SetProperty(Main, { 
			Parent = MainExample.Parent,
			Name = Settings.Title
		})

		SetProperty(Tab, { 
			Parent = Example.Parent,
			LayoutOrder = Section or #StoredInfo["Sections"] + 1,
			Name = Settings.Title,
			Visible = true
		})

		Tab.MouseButton1Click:Connect(function()
			Options:SetTab(Tab.Name)
		end)

		return Main.ScrollingFrame
	end
	
	function Options:Notify(Settings) 
		local Notification = Clone(Components:FindFirstChild("Notification"))
		local Title, Description = Options:GetLabels(Notification)
		local Timer = Notification["Timer"]
		
		SetProperty(Title, { Text = Settings.Title })
		SetProperty(Description, { Text = Settings.Description })
		SetProperty(Notification, {
			Parent = Screen["Frame"],
		})
		
		task.spawn(function() 
			local Duration = Settings.Duration or 2
			local Wait = task.wait
			
			Animations:Open(Notification, Setup.Transparency, true); Tween(Timer, Duration, { Size = UDim2.new(0, 0, 0, 4) })
			Wait(Duration)
			Animations:Close(Notification)
			Wait(1)
			Notification:Destroy()
		end)
	end

	function Options:GetLabels(Component)
		local Labels = Component:FindFirstChild("Labels")
		return Labels.Title, Labels.Description
	end

	function Options:AddSection(Settings) 
		local Section = Clone(Components:FindFirstChild("Section"))
		SetProperty(Section, {
			Text = Settings.Name,
			Parent = Settings.Tab,
			Visible = true,
		})
	end
	
	function Options:AddButton(Settings) 
		local Button = Clone(Components:FindFirstChild("Button"))
		local Title, Description = Options:GetLabels(Button)

		Button.MouseButton1Click:Connect(Settings.Callback)
		Animations:Component(Button)
		SetProperty(Title, { Text = Settings.Title })
		SetProperty(Description, { Text = Settings.Description })
		SetProperty(Button, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end

	function Options:AddInput(Settings) 
		local Input = Clone(Components:FindFirstChild("Input"))
		local Title, Description = Options:GetLabels(Input)
		local TextBox = Input["Main"]["Input"]

		Input.MouseButton1Click:Connect(function() 
			TextBox:CaptureFocus()
		end)

		TextBox.FocusLost:Connect(function() 
			Settings.Callback(TextBox.Text)
		end)

		Animations:Component(Input)
		SetProperty(Title, { Text = Settings.Title })
		SetProperty(Description, { Text = Settings.Description })
		SetProperty(Input, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end

	function Options:AddToggle(Settings) 
		local Toggle = Clone(Components:FindFirstChild("Toggle"))
		local Title, Description = Options:GetLabels(Toggle)

		local On = Toggle["Value"]
		local Main = Toggle["Main"]
		local Circle = Main["Circle"]
		
		local Set = function(Value)
			if Value then
				local accentColor = Theme.Tab or Color3.fromRGB(153, 155, 255)
				Tween(Main, .2, { BackgroundColor3 = accentColor })
				Tween(Circle, .2, { BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(1, -16, 0.5, 0) })
			else
				Tween(Main, .2, { BackgroundColor3 = Theme.Interactables })
				Tween(Circle, .2, { BackgroundColor3 = Theme.Primary, Position = UDim2.new(0, 3, 0.5, 0) })
			end
			
			On.Value = Value
		end 

		Toggle.MouseButton1Click:Connect(function()
			local Value = not On.Value
			Set(Value)
			Settings.Callback(Value)
		end)

		Animations:Component(Toggle)
		Set(Settings.Default)
		SetProperty(Title, { Text = Settings.Title })
		SetProperty(Description, { Text = Settings.Description })
		SetProperty(Toggle, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end
	
	function Options:AddKeybind(Settings) 
		local Dropdown = Clone(Components:FindFirstChild("Keybind"))
		local Title, Description = Options:GetLabels(Dropdown)
		local Bind = Dropdown["Main"].Options
		
		local Mouse = { Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3 } 
		local Types = { 
			["Mouse"] = "Enum.UserInputType.MouseButton", 
			["Key"] = "Enum.KeyCode." 
		}
		
		Dropdown.MouseButton1Click:Connect(function()
			local Finished
			
			SetProperty(Bind, { Text = "..." })
			game.UserInputService.InputBegan:Connect(function(Key, Focused) 
				local InputType = (Key.UserInputType)
				
				if not Finished and not Focused then
					Finished = true
					
					if table.find(Mouse, InputType) then
						Settings.Callback(Key)
						SetProperty(Bind, {
							Text = tostring(InputType):gsub(Types.Mouse, "MB")
						})
					elseif InputType == Enum.UserInputType.Keyboard then
						Settings.Callback(Key)
						SetProperty(Bind, {
							Text = tostring(Key.KeyCode):gsub(Types.Key, "")
						})
					end
				end 
			end)
		end)

		Animations:Component(Dropdown)
		SetProperty(Title, { Text = Settings.Title })
		SetProperty(Description, { Text = Settings.Description })
		SetProperty(Dropdown, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end

	function Options:AddDropdown(Settings) 
		local Dropdown = Clone(Components:FindFirstChild("Dropdown"))
		local Title, Description = Options:GetLabels(Dropdown)
		local Text = Dropdown["Main"].Options

		Dropdown.MouseButton1Click:Connect(function()
			local Example = Clone(Examples["DropdownExample"])
			local Buttons = Example["Top"]["Buttons"]

			Tween(BG, .25, { BackgroundTransparency = 0.6 })
			SetProperty(Example, { Parent = Window })
			Animations:Open(Example, 0, true)

			for Index, Button in next, Buttons:GetChildren() do
				if Button:IsA("TextButton") then
					Animations:Component(Button, true)

					Button.MouseButton1Click:Connect(function()
						Tween(BG, .25, { BackgroundTransparency = 1 })
						Animations:Close(Example)
						task.wait(2)
						Destroy(Example)
					end)
				end
			end

			for Index, Option in next, Settings.Options do
				local Button = Clone(Examples["DropdownButtonExample"])
				local Title, Description = Options:GetLabels(Button)
				local Selected = Button["Value"]

				Animations:Component(Button)
				SetProperty(Title, { Text = Index })
				SetProperty(Button, { Parent = Example.ScrollingFrame, Visible = true })
				Destroy(Description)

				Button.MouseButton1Click:Connect(function() 
					local NewValue = not Selected.Value 

					if NewValue then
						Tween(Button, .25, { BackgroundColor3 = Theme.Interactables })
						Settings.Callback(Option)
						Text.Text = Index

						for _, Others in next, Example:GetChildren() do
							if Others:IsA("TextButton") and Others ~= Button then
								Others.BackgroundColor3 = Theme.Component
							end
						end
					else
						Tween(Button, .25, { BackgroundColor3 = Theme.Component })
					end

					Selected.Value = NewValue
					Tween(BG, .25, { BackgroundTransparency = 1 })
					Animations:Close(Example)
					task.wait(2)
					Destroy(Example)
				end)
			end
		end)

		Animations:Component(Dropdown)
		SetProperty(Title, { Text = Settings.Title })
		SetProperty(Description, { Text = Settings.Description })
		SetProperty(Dropdown, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end

	function Options:AddSlider(Settings) 
		local Slider = Clone(Components:FindFirstChild("Slider"))
		local Title, Description = Options:GetLabels(Slider)

		local Main = Slider["Slider"]
		local Amount = Main["Main"].Input
		local Slide = Main["Slide"]
		local Fire = Slide["Fire"]
		local Fill = Slide["Highlight"]

		local Active = false
		local Value = 0
		
		local SetNumber = function(Number)
			if Settings.AllowDecimals then
				local Power = 10 ^ (Settings.DecimalAmount or 2)
				Number = math.floor(Number * Power + 0.5) / Power
			else
				Number = math.round(Number)
			end
			return Number
		end

		local Update = function(Number)
			local Scale = (Player.Mouse.X - Slide.AbsolutePosition.X) / Slide.AbsoluteSize.X			
			Scale = (Scale > 1 and 1) or (Scale < 0 and 0) or Scale
			
			if Number then
				Number = (Number > Settings.MaxValue and Settings.MaxValue) or (Number < 0 and 0) or Number
			end
			
			Value = SetNumber(Number or (Scale * Settings.MaxValue))
			Amount.Text = Value
			local accentColor = Theme.Tab or Color3.fromRGB(153, 155, 255)
			Fill.BackgroundColor3 = accentColor
			Fill.Size = UDim2.fromScale((Number and Number / Settings.MaxValue) or Scale, 1)
			Settings.Callback(Value)
		end

		local Activate = function()
			Active = true
			repeat task.wait()
				Update()
			until not Active
		end
		
		Amount.FocusLost:Connect(function() 
			Update(tonumber(Amount.Text) or 0)
		end)

		Fire.MouseButton1Down:Connect(Activate)
		Services.Input.InputEnded:Connect(function(Input) 
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Active = false
			end
		end)

		Fill.Size = UDim2.fromScale(Value, 1)
		Fill.BackgroundColor3 = Theme.Tab or Color3.fromRGB(153, 155, 255)
		Animations:Component(Slider)
		SetProperty(Title, { Text = Settings.Title })
		SetProperty(Description, { Text = Settings.Description })
		SetProperty(Slider, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end

	function Options:AddParagraph(Settings) 
		local Paragraph = Clone(Components:FindFirstChild("Paragraph"))
		local Title, Description = Options:GetLabels(Paragraph)

		SetProperty(Title, { Text = Settings.Title })
		SetProperty(Description, { Text = Settings.Description })
		SetProperty(Paragraph, {
			Parent = Settings.Tab,
			Visible = true,
		})
	end
	
	function Options:SaveConfig(name)
		if not name or name == "" then
			name = "Config_" .. os.date("%Y%m%d_%H%M%S")
		end
		local configData = Config:Save(name)
		Options:Notify({
			Title = "Config Saved",
			Description = "Saved as: " .. name,
			Duration = 3
		})
		return configData
	end
	
	function Options:LoadConfig(name)
		if Config:Load(name) then
			Options:Notify({
				Title = "Config Loaded",
				Description = "Loaded: " .. name,
				Duration = 3
			})
			if Options.SetTheme and Setup.CurrentThemeName then
				Options:SetTheme(Setup.CurrentThemeName)
			end
			return true
		else
			Options:Notify({
				Title = "Config Not Found",
				Description = "Could not find: " .. name,
				Duration = 3
			})
			return false
		end
	end
	
	function Options:GetConfigs()
		return Config:GetAll()
	end
	
	function Options:DeleteConfig(name)
		if Config:Delete(name) then
			Options:Notify({
				Title = "Config Deleted",
				Description = "Deleted: " .. name,
				Duration = 2
			})
			return true
		end
		return false
	end

	local Themes = {
		Names = {	
			["Paragraph"] = function(Label)
				if Label:IsA("TextButton") then
					Label.BackgroundColor3 = Color(Theme.Component, 5, "Dark")
				end
			end,
			
			["Title"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Theme.Title
				end
			end,

			["Description"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Theme.Description
				end
			end,
			
			["Section"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Theme.Title
				end
			end,

			["Options"] = function(Label)
				if Label:IsA("TextLabel") and Label.Parent.Name == "Main" then
					Label.TextColor3 = Theme.Title
				end
			end,
			
			["Notification"] = function(Label)
				if Label:IsA("CanvasGroup") then
					Label.BackgroundColor3 = Theme.Primary
					Label.UIStroke.Color = Theme.Outline
				end
			end,

			["TextLabel"] = function(Label)
				if Label:IsA("TextLabel") and Label.Parent:FindFirstChild("List") then
					Label.TextColor3 = Theme.Tab
				end
			end,

			["Main"] = function(Label)
				if Label:IsA("Frame") then

					if Label.Parent == Window then
						Label.BackgroundColor3 = Theme.Secondary
					elseif Label.Parent:FindFirstChild("Value") then
						local Toggle = Label.Parent.Value 
						local Circle = Label:FindFirstChild("Circle")
						
						if not Toggle.Value then
							Label.BackgroundColor3 = Theme.Interactables
							Label.Circle.BackgroundColor3 = Theme.Primary
						end
					else
						Label.BackgroundColor3 = Theme.Interactables
					end
				elseif Label:FindFirstChild("Padding") then
					Label.TextColor3 = Theme.Title
				end
			end,

			["Amount"] = function(Label)
				if Label:IsA("Frame") then
					Label.BackgroundColor3 = Theme.Interactables
				end
			end,

			["Slide"] = function(Label)
				if Label:IsA("Frame") then
					Label.BackgroundColor3 = Theme.Interactables
				end
			end,

			["Input"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Theme.Title
				elseif Label:FindFirstChild("Labels") then
					Label.BackgroundColor3 = Theme.Component
				elseif Label:IsA("TextBox") and Label.Parent.Name == "Main" then
					Label.TextColor3 = Theme.Title
				end
			end,

			["Outline"] = function(Stroke)
				if Stroke:IsA("UIStroke") then
					Stroke.Color = Theme.Outline
				end
			end,

			["DropdownExample"] = function(Label)
				Label.BackgroundColor3 = Theme.Secondary
			end,

			["Underline"] = function(Label)
				if Label:IsA("Frame") then
					Label.BackgroundColor3 = Theme.Outline
				end
			end,
		},

		Classes = {
			["ImageLabel"] = function(Label)
				if Label.Image ~= "rbxassetid://6644618143" then
					Label.ImageColor3 = Theme.Icon
				end
			end,

			["TextLabel"] = function(Label)
				if Label:FindFirstChild("Padding") then
					Label.TextColor3 = Theme.Title
				end
			end,

			["TextButton"] = function(Label)
				if Label:FindFirstChild("Labels") then
					Label.BackgroundColor3 = Theme.Component
				end
			end,

			["ScrollingFrame"] = function(Label)
				Label.ScrollBarImageColor3 = Theme.Component
			end,
		},
	}

function Options:SetTheme(Info)
	if rainbowConnection then
		rainbowConnection:Disconnect()
		rainbowConnection = nil
	end
	
	if type(Info) == "string" then
		if BuiltInThemes[Info] then
			Theme = BuiltInThemes[Info]
			Setup.CurrentThemeName = Info
			
			if Theme.Dynamic then
				rainbowHue = 0
				rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
					rainbowHue = (rainbowHue + dt * 0.1) % 1
					
					local main = Color3.fromHSV(rainbowHue, 1, 1)
					local secondary = Color3.fromHSV((rainbowHue + 0.05) % 1, 0.9, 1)
					local accent = Color3.fromHSV((rainbowHue + 0.1) % 1, 1, 1)

					Theme.Tab = main
					Theme.Accent = accent
					Theme.Title = main
					Theme.Description = secondary
					Theme.Icon = accent
					Theme.Outline = main

					ApplyTheme()
				end)
			end
			Theme = Info or Theme
		end

		Window.BackgroundColor3 = Theme.Primary
		Holder.BackgroundColor3 = Theme.Secondary
		if Window:FindFirstChildOfClass("UIStroke") then
			Window:FindFirstChildOfClass("UIStroke").Color = Theme.Shadow
		end
		
		-- Update TopBar color if it exists
		local TopBar = Sidebar.Top
		if TopBar then
			TopBar.BackgroundColor3 = Theme.Secondary
		end

		ApplyTheme()
	end

	function Options:SetSetting(Setting, Value)
		if Setting == "Size" then
			Window.Size = Value
			Setup.Size = Value
		elseif Setting == "Transparency" then
			Window.GroupTransparency = Value
			Setup.Transparency = Value
			for Index, Notification in next, Screen:GetDescendants() do
				if Notification:IsA("CanvasGroup") and Notification.Name == "Notification" then
					Notification.GroupTransparency = Value
				end
			end
		elseif Setting == "Blur" then
			local AlreadyBlurred, Root = Blurs[Settings.Title], nil
			if AlreadyBlurred then
				Root = Blurs[Settings.Title]["root"]
			end
			if Value then
				BlurEnabled = true
				Setup.BlurEnabled = true
				if not AlreadyBlurred or not Root then
					Blurs[Settings.Title] = Blur.new(Window, 5)
				elseif Root and not Root.Parent then
					Root.Parent = workspace.CurrentCamera
				end
			elseif not Value and (AlreadyBlurred and Root and Root.Parent) then
				Root.Parent = nil
				BlurEnabled = false
				Setup.BlurEnabled = false
			end
		elseif Setting == "Theme" then
			Options:SetTheme(Value)
		elseif Setting == "Keybind" then
			Setup.Keybind = Value
		else
			warn("Tried to change a setting that doesn't exist or isn't available to change.")
		end
	end

	SetProperty(Window, { Size = Settings.Size, Visible = true, Parent = Screen })
	Animations:Open(Window, Settings.Transparency or 0)

	return Options
end
return Library
