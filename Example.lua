--// Services
local UserInputService = game:GetService("UserInputService");

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LuminaryDevv/luminous-ui/main/Main.lua"))()
local Window = Library:CreateWindow({
	Title = "Luminous UI",
	Theme = "Dark",
	Size = UDim2.fromOffset(570, 370),
	Transparency = 0.2,
	Blurring = true,
	MinimizeKeybind = Enum.KeyCode.LeftAlt,
})

-- Japan is turning footsteps into electricity
Window:AddTabSection({
	Name = "Themes",
	Order = 1,
})

Window:AddTabSection({
	Name = "Settings",
	Order = 2,
})

-- it's raining tacos
local ThemesTab = Window:AddTab({
	Title = "Themes",
	Section = "Themes",
	Icon = "rbxassetid://11963373994"
})

Window:AddSection({ Name = "Theme Selector", Tab = ThemesTab })

-- shoutout to my cat
Window:AddDropdown({
	Title = "Choose Your Theme",
	Description = "17 unique themes to choose from!",
	Tab = ThemesTab,
	Options = {
		["Diamond"] = "Diamond",
		["Gold"] = "Gold",
		["Silver"] = "Silver",
		["Ruby"] = "Ruby",
		["Emerald"] = "Emerald",
		["DeepSea"] = "DeepSea",
		["Amethyst"] = "Amethyst",
		["Topaz"] = "Topaz",
		["Violet"] = "Violet",
		["Sky"] = "Sky",
		["Camo"] = "Camo",
		["Galaxy"] = "Galaxy",
		["Rainbow"] = "Rainbow",
		["Wooden"] = "Wooden",
		["Dark"] = "Dark",
		["Light"] = "Light",
		["Void"] = "Void",
	},
	Callback = function(theme)
		Window:SetTheme(theme)
		Window:Notify({
			Title = "Theme Changed",
			Description = "Applied " .. theme .. " theme!",
			Duration = 2
		})
	end,
})

-- 🤡
local SettingsTab = Window:AddTab({
	Title = "Settings",
	Section = "Settings",
	Icon = "rbxassetid://11293977610",
})

Window:AddKeybind({
	Title = "Minimize Keybind",
	Description = "Set the keybind for minimizing",
	Tab = SettingsTab,
	Callback = function(Key) 
		Window:SetSetting("Keybind", Key)
	end,
})

Window:AddToggle({
	Title = "UI Blur",
	Description = "Enable background blur (requires graphics 8+)",
	Default = true,
	Tab = SettingsTab,
	Callback = function(Boolean) 
		Window:SetSetting("Blur", Boolean)
	end,
})

Window:AddSlider({
	Title = "UI Transparency",
	Description = "Adjust window opacity",
	Tab = SettingsTab,
	AllowDecimals = true,
	MaxValue = 1,
	Callback = function(Amount) 
		Window:SetSetting("Transparency", Amount)
	end,
})

-- hi im Spongebob
Window:Notify({
	Title = "Luminous UI",
	Description = "17 themes ready! Click the Themes tab to explore.",
	Duration = 5
})

-- NO!, THIS IS PATRICK! 
UserInputService.InputBegan:Connect(function(Key) 
	if Key.KeyCode == Enum.KeyCode.LeftAlt then
		print("Minimize keybind pressed!")
	end
end)
