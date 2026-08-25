-- MacLib UI Library Engine Integration for MuscleLegends
local MacLib = { 
	Options = {}, 
	Folder = "Maclib", 
	GetService = function(service)
		return cloneref and cloneref(game:GetService(service)) or game:GetService(service)
	end
}

--// Services
local TweenService = MacLib.GetService("TweenService")
local RunService = MacLib.GetService("RunService")
local HttpService = MacLib.GetService("HttpService")
local ContentProvider = MacLib.GetService("ContentProvider")
local UserInputService = MacLib.GetService("UserInputService")
local Lighting = MacLib.GetService("Lighting")
local Players = MacLib.GetService("Players")

--// Variables
local isStudio = RunService:IsStudio()
local LocalPlayer = Players.LocalPlayer

local windowState
local acrylicBlur
local hasGlobalSetting

local tabs = {}
local currentTabInstance = nil
local tabIndex = 0
local unloaded = false

local assets = {
	interFont = "rbxassetid://12187365364",
	userInfoBlurred = "rbxassetid://18824089198",
	toggleBackground = "rbxassetid://18772190202",
	togglerHead = "rbxassetid://18772309008",
	buttonImage = "rbxassetid://10709791437",
	searchIcon = "rbxassetid://86737463322606",
	colorWheel = "rbxassetid://2849458409",
	colorTarget = "rbxassetid://73265255323268",
	grid = "rbxassetid://121484455191370",
	globe = "rbxassetid://108952102602834",
	transform = "rbxassetid://90336395745819",
	dropdown = "rbxassetid://18865373378",
	sliderbar = "rbxassetid://18772615246",
	sliderhead = "rbxassetid://18772834246",
}

--// Functions
local function GetGui()
	local newGui = Instance.new("ScreenGui")
	newGui.ScreenInsets = Enum.ScreenInsets.None
	newGui.ResetOnSpawn = false
	newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	newGui.DisplayOrder = 2147483647

	local parent = RunService:IsStudio() 
		and LocalPlayer:FindFirstChild("PlayerGui")
		or (gethui and gethui())
		or (cloneref and cloneref(MacLib.GetService("CoreGui")) or MacLib.GetService("CoreGui"))

	newGui.Parent = parent
	return newGui
end

local function Tween(instance, tweeninfo, propertytable)
	return TweenService:Create(instance, tweeninfo, propertytable)
end

--// Library Functions
function MacLib:Window(Settings)
	local WindowFunctions = {Settings = Settings}
	if Settings.AcrylicBlur ~= nil then
		acrylicBlur = Settings.AcrylicBlur
	else
		acrylicBlur = true
	end

	local macLib = GetGui()

	local notifications = Instance.new("Frame")
	notifications.Name = "Notifications"
	notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notifications.BackgroundTransparency = 1
	notifications.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notifications.BorderSizePixel = 0
	notifications.Size = UDim2.fromScale(1, 1)
	notifications.Parent = macLib
	notifications.ZIndex = 2

	local notificationsUIListLayout = Instance.new("UIListLayout")
	notificationsUIListLayout.Name = "NotificationsUIListLayout"
	notificationsUIListLayout.Padding = UDim.new(0, 10)
	notificationsUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notificationsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notificationsUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notificationsUIListLayout.Parent = notifications

	local notificationsUIPadding = Instance.new("UIPadding")
	notificationsUIPadding.Name = "NotificationsUIPadding"
	notificationsUIPadding.PaddingBottom = UDim.new(0, 10)
	notificationsUIPadding.PaddingLeft = UDim.new(0, 10)
	notificationsUIPadding.PaddingRight = UDim.new(0, 10)
	notificationsUIPadding.PaddingTop = UDim.new(0, 10)
	notificationsUIPadding.Parent = notifications

	local base = Instance.new("Frame")
	base.Name = "Base"
	base.AnchorPoint = Vector2.new(0.5, 0.5)
	base.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	base.BackgroundTransparency = Settings.AcrylicBlur and 0.05 or 0
	base.BorderColor3 = Color3.fromRGB(0, 0, 0)
	base.BorderSizePixel = 0
	base.Position = UDim2.fromScale(0.5, 0.5)
	base.Size = Settings.Size or UDim2.fromOffset(868, 650)

	local baseUIScale = Instance.new("UIScale")
	baseUIScale.Name = "BaseUIScale"
	baseUIScale.Parent = base

	local baseUICorner = Instance.new("UICorner")
	baseUICorner.Name = "BaseUICorner"
	baseUICorner.CornerRadius = UDim.new(0, 10)
	baseUICorner.Parent = base

	local baseUIStroke = Instance.new("UIStroke")
	baseUIStroke.Name = "BaseUIStroke"
	baseUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	baseUIStroke.Color = Color3.fromRGB(255, 255, 255)
	baseUIStroke.Transparency = 0.9
	baseUIStroke.Parent = base

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebar.BackgroundTransparency = 1
	sidebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebar.BorderSizePixel = 0
	sidebar.Position = UDim2.fromScale(-3.52e-08, 4.69e-08)
	sidebar.Size = UDim2.fromScale(0.325, 1)

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.AnchorPoint = Vector2.new(1, 0)
	divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider.BackgroundTransparency = 0.9
	divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider.BorderSizePixel = 0
	divider.Position = UDim2.fromScale(1, 0)
	divider.Size = UDim2.new(0, 1, 1, 0)
	divider.Parent = sidebar

	local dividerInteract = Instance.new("TextButton")
	dividerInteract.Name = "DividerInteract"
	dividerInteract.AnchorPoint = Vector2.new(0.5, 0)
	dividerInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dividerInteract.BackgroundTransparency = 1
	dividerInteract.BorderColor3 = Color3.fromRGB(0, 0, 0)
	dividerInteract.BorderSizePixel = 0
	dividerInteract.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	dividerInteract.Position = UDim2.fromScale(0.5, 0)
	dividerInteract.Size = UDim2.new(1, 6, 1, 0)
	dividerInteract.Text = ""
	dividerInteract.TextColor3 = Color3.fromRGB(0, 0, 0)
	dividerInteract.TextSize = 14
	dividerInteract.Parent = divider

	local windowControls = Instance.new("Frame")
	windowControls.Name = "WindowControls"
	windowControls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	windowControls.BackgroundTransparency = 1
	windowControls.BorderColor3 = Color3.fromRGB(0, 0, 0)
	windowControls.BorderSizePixel = 0
	windowControls.Size = UDim2.new(1, 0, 0, 31)

	local controls = Instance.new("Frame")
	controls.Name = "Controls"
	controls.BackgroundColor3 = Color3.fromRGB(119, 174, 94)
	controls.BackgroundTransparency = 1
	controls.BorderColor3 = Color3.fromRGB(0, 0, 0)
	controls.BorderSizePixel = 0
	controls.Size = UDim2.fromScale(1, 1)

	local uIListLayout = Instance.new("UIListLayout")
	uIListLayout.Name = "UIListLayout"
	uIListLayout.Padding = UDim.new(0, 5)
	uIListLayout.FillDirection = Enum.FillDirection.Horizontal
	uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uIListLayout.Parent = controls

	local uIPadding = Instance.new("UIPadding")
	uIPadding.Name = "UIPadding"
	uIPadding.PaddingLeft = UDim.new(0, 11)
	uIPadding.Parent = controls

	local windowControlSettings = {
		sizes = { enabled = UDim2.fromOffset(8, 8), disabled = UDim2.fromOffset(7, 7) },
		transparencies = { enabled = 0, disabled = 1 },
		strokeTransparency = 0.9,
	}

	local stroke = Instance.new("UIStroke")
	stroke.Name = "BaseUIStroke"
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = windowControlSettings.strokeTransparency

	local exit = Instance.new("TextButton")
	exit.Name = "Exit"
	exit.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	exit.Text = ""
	exit.TextColor3 = Color3.fromRGB(0, 0, 0)
	exit.TextSize = 14
	exit.AutoButtonColor = false
	exit.BackgroundColor3 = Color3.fromRGB(250, 93, 86)
	exit.BorderColor3 = Color3.fromRGB(0, 0, 0)
	exit.BorderSizePixel = 0

	local uICorner = Instance.new("UICorner")
	uICorner.Name = "UICorner"
	uICorner.CornerRadius = UDim.new(1, 0)
	uICorner.Parent = exit

	exit.Parent = controls

	local minimize = Instance.new("TextButton")
	minimize.Name = "Minimize"
	minimize.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	minimize.Text = ""
	minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
	minimize.TextSize = 14
	minimize.AutoButtonColor = false
	minimize.BackgroundColor3 = Color3.fromRGB(252, 190, 57)
	minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	minimize.BorderSizePixel = 0
	minimize.LayoutOrder = 1

	local uICorner1 = Instance.new("UICorner")
	uICorner1.Name = "UICorner"
	uICorner1.CornerRadius = UDim.new(1, 0)
	uICorner1.Parent = minimize

	minimize.Parent = controls

	local maximize = Instance.new("TextButton")
	maximize.Name = "Maximize"
	maximize.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	maximize.Text = ""
	maximize.TextColor3 = Color3.fromRGB(0, 0, 0)
	maximize.TextSize = 14
	maximize.AutoButtonColor = false
	maximize.BackgroundColor3 = Color3.fromRGB(119, 174, 94)
	maximize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	maximize.BorderSizePixel = 0
	maximize.LayoutOrder = 1

	local uICorner2 = Instance.new("UICorner")
	uICorner2.Name = "UICorner"
	uICorner2.CornerRadius = UDim.new(1, 0)
	uICorner2.Parent = maximize

	maximize.Parent = controls

	local function applyState(button, enabled)
		local size = enabled and windowControlSettings.sizes.enabled or windowControlSettings.sizes.disabled
		local transparency = enabled and windowControlSettings.transparencies.enabled or windowControlSettings.transparencies.disabled

		button.Size = size
		button.BackgroundTransparency = transparency
		button.Active = enabled
		button.Interactable = enabled

		for _, child in ipairs(button:GetChildren()) do
			if child:IsA("UIStroke") then
				child.Transparency = transparency
			end
		end
		if not enabled then
			stroke:Clone().Parent = button
		end
	end

	applyState(maximize, false)

	local controlsList = {exit, minimize}
	for _, button in pairs(controlsList) do
		local buttonName = button.Name
		local isEnabled = true

		if Settings.DisabledWindowControls and table.find(Settings.DisabledWindowControls, buttonName) then
			isEnabled = false
		end

		applyState(button, isEnabled)
	end

	controls.Parent = windowControls

	local divider1 = Instance.new("Frame")
	divider1.Name = "Divider"
	divider1.AnchorPoint = Vector2.new(0, 1)
	divider1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider1.BackgroundTransparency = 0.9
	divider1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider1.BorderSizePixel = 0
	divider1.Position = UDim2.fromScale(0, 1)
	divider1.Size = UDim2.new(1, 0, 0, 1)
	divider1.Parent = windowControls

	windowControls.Parent = sidebar

	local information = Instance.new("Frame")
	information.Name = "Information"
	information.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	information.BackgroundTransparency = 1
	information.BorderColor3 = Color3.fromRGB(0, 0, 0)
	information.BorderSizePixel = 0
	information.Position = UDim2.fromOffset(0, 31)
	information.Size = UDim2.new(1, 0, 0, 60)

	local divider2 = Instance.new("Frame")
	divider2.Name = "Divider"
	divider2.AnchorPoint = Vector2.new(0, 1)
	divider2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider2.BackgroundTransparency = 0.9
	divider2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider2.BorderSizePixel = 0
	divider2.Position = UDim2.fromScale(0, 1)
	divider2.Size = UDim2.new(1, 0, 0, 1)
	divider2.Parent = information

	local informationHolder = Instance.new("Frame")
	informationHolder.Name = "InformationHolder"
	informationHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	informationHolder.BackgroundTransparency = 1
	informationHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	informationHolder.BorderSizePixel = 0
	informationHolder.Size = UDim2.fromScale(1, 1)

	local informationHolderUIPadding = Instance.new("UIPadding")
	informationHolderUIPadding.Name = "InformationHolderUIPadding"
	informationHolderUIPadding.PaddingBottom = UDim.new(0, 10)
	informationHolderUIPadding.PaddingLeft = UDim.new(0, 23)
	informationHolderUIPadding.PaddingRight = UDim.new(0, 22)
	informationHolderUIPadding.PaddingTop = UDim.new(0, 10)
	informationHolderUIPadding.Parent = informationHolder

	local globalSettingsButton = Instance.new("ImageButton")
	globalSettingsButton.Name = "GlobalSettingsButton"
	globalSettingsButton.Image = assets.globe
	globalSettingsButton.ImageTransparency = 0.5
	globalSettingsButton.AnchorPoint = Vector2.new(1, 0.5)
	globalSettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	globalSettingsButton.BackgroundTransparency = 1
	globalSettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	globalSettingsButton.BorderSizePixel = 0
	globalSettingsButton.Position = UDim2.fromScale(1, 0.5)
	globalSettingsButton.Size = UDim2.fromOffset(16,16)
	globalSettingsButton.Parent = informationHolder

	local function ChangeGlobalSettingsButtonState(State)
		if State == "Default" then
			Tween(globalSettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.5
			}):Play()
		elseif State == "Hover" then
			Tween(globalSettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.3
			}):Play()
		end
	end

	globalSettingsButton.MouseEnter:Connect(function()
		ChangeGlobalSettingsButtonState("Hover")
	end)
	globalSettingsButton.MouseLeave:Connect(function()
		ChangeGlobalSettingsButtonState("Default")
	end)

	local titleFrame = Instance.new("Frame")
	titleFrame.Name = "TitleFrame"
	titleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleFrame.BackgroundTransparency = 1
	titleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	titleFrame.BorderSizePixel = 0
	titleFrame.Size = UDim2.fromScale(1, 1)

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	title.Text = Settings.Title
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.RichText = true
	title.TextSize = 18
	title.TextTransparency = 0.1
	title.TextTruncate = Enum.TextTruncate.SplitWord
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Top
	title.AutomaticSize = Enum.AutomaticSize.Y
	title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	title.BorderSizePixel = 0
	title.Size = UDim2.new(1, -20, 0, 0)
	title.Parent = titleFrame

	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	subtitle.RichText = true
	subtitle.Text = Settings.Subtitle
	subtitle.RichText = true
	subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	subtitle.TextSize = 12
	subtitle.TextTransparency = 0.7
	subtitle.TextTruncate = Enum.TextTruncate.SplitWord
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.TextYAlignment = Enum.TextYAlignment.Top
	subtitle.AutomaticSize = Enum.AutomaticSize.Y
	subtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	subtitle.BackgroundTransparency = 1
	subtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	subtitle.BorderSizePixel = 0
	subtitle.LayoutOrder = 1
	subtitle.Size = UDim2.new(1, -20, 0, 0)
	subtitle.Parent = titleFrame

	local titleFrameUIListLayout = Instance.new("UIListLayout")
	titleFrameUIListLayout.Name = "TitleFrameUIListLayout"
	titleFrameUIListLayout.Padding = UDim.new(0, 3)
	titleFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	titleFrameUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	titleFrameUIListLayout.Parent = titleFrame

	titleFrame.Parent = informationHolder

	informationHolder.Parent = information

	information.Parent = sidebar

	local sidebarGroup = Instance.new("Frame")
	sidebarGroup.Name = "SidebarGroup"
	sidebarGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebarGroup.BackgroundTransparency = 1
	sidebarGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebarGroup.BorderSizePixel = 0
	sidebarGroup.Position = UDim2.fromOffset(0, 91)
	sidebarGroup.Size = UDim2.new(1, 0, 1, -91)

	local userInfo = Instance.new("Frame")
	userInfo.Name = "UserInfo"
	userInfo.AnchorPoint = Vector2.new(0, 1)
	userInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userInfo.BackgroundTransparency = 1
	userInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	userInfo.BorderSizePixel = 0
	userInfo.Position = UDim2.fromScale(0, 1)
	userInfo.Size = UDim2.new(1, 0, 0, 107)

	local informationGroup = Instance.new("Frame")
	informationGroup.Name = "InformationGroup"
	informationGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	informationGroup.BackgroundTransparency = 1
	informationGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
	informationGroup.BorderSizePixel = 0
	informationGroup.Size = UDim2.fromScale(1, 1)

	local informationGroupUIPadding = Instance.new("UIPadding")
	informationGroupUIPadding.Name = "InformationGroupUIPadding"
	informationGroupUIPadding.PaddingBottom = UDim.new(0, 17)
	informationGroupUIPadding.PaddingLeft = UDim.new(0, 25)
	informationGroupUIPadding.Parent = informationGroup

	local informationGroupUIListLayout = Instance.new("UIListLayout")
	informationGroupUIListLayout.Name = "InformationGroupUIListLayout"
	informationGroupUIListLayout.FillDirection = Enum.FillDirection.Horizontal
	informationGroupUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	informationGroupUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	informationGroupUIListLayout.Parent = informationGroup

	local userId = LocalPlayer.UserId
	local thumbType = Enum.ThumbnailType.AvatarBust
	local thumbSize = Enum.ThumbnailSize.Size48x48
	local headshotImage, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

	local headshot = Instance.new("ImageLabel")
	headshot.Name = "Headshot"
	headshot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	headshot.BackgroundTransparency = 1
	headshot.BorderColor3 = Color3.fromRGB(0, 0, 0)
	headshot.BorderSizePixel = 0
	headshot.Size = UDim2.fromOffset(32, 32)
	headshot.Image = (isReady and headshotImage) or "rbxassetid://0"

	local uICorner3 = Instance.new("UICorner")
	uICorner3.Name = "UICorner"
	uICorner3.CornerRadius = UDim.new(1, 0)
	uICorner3.Parent = headshot

	local baseUIStroke2 = Instance.new("UIStroke")
	baseUIStroke2.Name = "BaseUIStroke"
	baseUIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	baseUIStroke2.Color = Color3.fromRGB(255, 255, 255)
	baseUIStroke2.Transparency = 0.9
	baseUIStroke2.Parent = headshot

	headshot.Parent = informationGroup

	local userAndDisplayFrame = Instance.new("Frame")
	userAndDisplayFrame.Name = "UserAndDisplayFrame"
	userAndDisplayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userAndDisplayFrame.BackgroundTransparency = 1
	userAndDisplayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	userAndDisplayFrame.BorderSizePixel = 0
	userAndDisplayFrame.LayoutOrder = 1
	userAndDisplayFrame.Size = UDim2.new(1, -42, 0, 32)

	local displayName = Instance.new("TextLabel")
	displayName.Name = "DisplayName"
	displayName.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	displayName.Text = LocalPlayer.DisplayName
	displayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	displayName.TextSize = 13
	displayName.TextTransparency = 0.1
	displayName.TextTruncate = Enum.TextTruncate.SplitWord
	displayName.TextXAlignment = Enum.TextXAlignment.Left
	displayName.TextYAlignment = Enum.TextYAlignment.Top
	displayName.AutomaticSize = Enum.AutomaticSize.XY
	displayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	displayName.BackgroundTransparency = 1
	displayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	displayName.BorderSizePixel = 0
	displayName.Parent = userAndDisplayFrame
	displayName.Size = UDim2.fromScale(1,0)

	local userAndDisplayFrameUIPadding = Instance.new("UIPadding")
	userAndDisplayFrameUIPadding.Name = "UserAndDisplayFrameUIPadding"
	userAndDisplayFrameUIPadding.PaddingLeft = UDim.new(0, 8)
	userAndDisplayFrameUIPadding.PaddingTop = UDim.new(0, 3)
	userAndDisplayFrameUIPadding.Parent = userAndDisplayFrame

	local userAndDisplayFrameUIListLayout = Instance.new("UIListLayout")
	userAndDisplayFrameUIListLayout.Name = "UserAndDisplayFrameUIListLayout"
	userAndDisplayFrameUIListLayout.Padding = UDim.new(0, 1)
	userAndDisplayFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	userAndDisplayFrameUIListLayout.Parent = userAndDisplayFrame

	local username = Instance.new("TextLabel")
	username.Name = "Username"
	username.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	username.Text = "@" .. LocalPlayer.Name
	username.TextColor3 = Color3.fromRGB(255, 255, 255)
	username.TextSize = 12
	username.TextTransparency = 0.7
	username.TextTruncate = Enum.TextTruncate.SplitWord
	username.TextXAlignment = Enum.TextXAlignment.Left
	username.TextYAlignment = Enum.TextYAlignment.Top
	username.AutomaticSize = Enum.AutomaticSize.XY
	username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	username.BackgroundTransparency = 1
	username.BorderColor3 = Color3.fromRGB(0, 0, 0)
	username.BorderSizePixel = 0
	username.LayoutOrder = 1
	username.Parent = userAndDisplayFrame
	username.Size = UDim2.fromScale(1,0)

	userAndDisplayFrame.Parent = informationGroup

	informationGroup.Parent = userInfo

	local userInfoUIPadding = Instance.new("UIPadding")
	userInfoUIPadding.Name = "UserInfoUIPadding"
	userInfoUIPadding.PaddingLeft = UDim.new(0, 10)
	userInfoUIPadding.PaddingRight = UDim.new(0, 10)
	userInfoUIPadding.Parent = userInfo

	userInfo.Parent = sidebarGroup

	local sidebarGroupUIPadding = Instance.new("UIPadding")
	sidebarGroupUIPadding.Name = "SidebarGroupUIPadding"
	sidebarGroupUIPadding.PaddingLeft = UDim.new(0, 10)
	sidebarGroupUIPadding.PaddingRight = UDim.new(0, 10)
	sidebarGroupUIPadding.PaddingTop = UDim.new(0, 31)
	sidebarGroupUIPadding.Parent = sidebarGroup

	local tabSwitchers = Instance.new("Frame")
	tabSwitchers.Name = "TabSwitchers"
	tabSwitchers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabSwitchers.BackgroundTransparency = 1
	tabSwitchers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabSwitchers.BorderSizePixel = 0
	tabSwitchers.Size = UDim2.new(1, 0, 1, -107)

	local tabSwitchersScrollingFrame = Instance.new("ScrollingFrame")
	tabSwitchersScrollingFrame.Name = "TabSwitchersScrollingFrame"
	tabSwitchersScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabSwitchersScrollingFrame.BottomImage = ""
	tabSwitchersScrollingFrame.CanvasSize = UDim2.new()
	tabSwitchersScrollingFrame.ScrollBarImageTransparency = 0.8
	tabSwitchersScrollingFrame.ScrollBarThickness = 1
	tabSwitchersScrollingFrame.TopImage = ""
	tabSwitchersScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabSwitchersScrollingFrame.BackgroundTransparency = 1
	tabSwitchersScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabSwitchersScrollingFrame.BorderSizePixel = 0
	tabSwitchersScrollingFrame.Size = UDim2.fromScale(1, 1)

	local tabSwitchersScrollingFrameUIListLayout = Instance.new("UIListLayout")
	tabSwitchersScrollingFrameUIListLayout.Name = "TabSwitchersScrollingFrameUIListLayout"
	tabSwitchersScrollingFrameUIListLayout.Padding = UDim.new(0, 17)
	tabSwitchersScrollingFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabSwitchersScrollingFrameUIListLayout.Parent = tabSwitchersScrollingFrame

	local tabSwitchersScrollingFrameUIPadding = Instance.new("UIPadding")
	tabSwitchersScrollingFrameUIPadding.Name = "TabSwitchersScrollingFrameUIPadding"
	tabSwitchersScrollingFrameUIPadding.PaddingTop = UDim.new(0, 2)
	tabSwitchersScrollingFrameUIPadding.Parent = tabSwitchersScrollingFrame

	tabSwitchersScrollingFrame.Parent = tabSwitchers

	tabSwitchers.Parent = sidebarGroup

	sidebarGroup.Parent = sidebar

	sidebar.Parent = base

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.AnchorPoint = Vector2.new(1, 0)
	content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	content.BackgroundTransparency = 1
	content.BorderColor3 = Color3.fromRGB(0, 0, 0)
	content.BorderSizePixel = 0
	content.Position = UDim2.fromScale(1, 4.69e-08)
	content.Size = UDim2.new(0, (base.AbsoluteSize.X - sidebar.AbsoluteSize.X), 1, 0)

	local resizingContent = false
	local defaultSidebarWidth = sidebar.AbsoluteSize.X
	local initialMouseX, initialSidebarWidth
	local snapRange = 20
	local minSidebarWidth = 107
	local maxSidebarWidth = base.AbsoluteSize.X - minSidebarWidth

	local TweenSettings = {
		DefaultTransparency = 0.9,
		HoverTransparency = 0.85,

		EasingStyle = Enum.EasingStyle.Sine
	}

	local function ChangeState(State)
		Tween(divider, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
			BackgroundTransparency = State == "Idle" and TweenSettings.DefaultTransparency or TweenSettings.HoverTransparency
		}):Play()  
	end

	dividerInteract.MouseEnter:Connect(function()
		ChangeState("Hover")
	end)
	dividerInteract.MouseLeave:Connect(function()
		ChangeState("Idle")
	end)

	dividerInteract.MouseButton1Down:Connect(function()
		resizingContent = true
		initialMouseX = UserInputService:GetMouseLocation().X
		initialSidebarWidth = sidebar.AbsoluteSize.X
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizingContent = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizingContent and input.UserInputType == Enum.UserInputType.MouseMovement then
			local deltaX = UserInputService:GetMouseLocation().X - initialMouseX
			local newSidebarWidth = initialSidebarWidth + deltaX

			if math.abs(newSidebarWidth - defaultSidebarWidth) < snapRange then
				newSidebarWidth = defaultSidebarWidth
			else
				newSidebarWidth = math.clamp(newSidebarWidth, minSidebarWidth, maxSidebarWidth)
			end

			sidebar.Size = UDim2.new(0, newSidebarWidth, 1, 0)
			content.Size = UDim2.new(0, base.AbsoluteSize.X - newSidebarWidth, 1, 0)
		end
	end)

	local topbar = Instance.new("Frame")
	topbar.Name = "Topbar"
	topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	topbar.BackgroundTransparency = 1
	topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	topbar.BorderSizePixel = 0
	topbar.Size = UDim2.new(1, 0, 0, 63)

	local divider4 = Instance.new("Frame")
	divider4.Name = "Divider"
	divider4.AnchorPoint = Vector2.new(0, 1)
	divider4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider4.BackgroundTransparency = 0.9
	divider4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider4.BorderSizePixel = 0
	divider4.Position = UDim2.fromScale(0, 1)
	divider4.Size = UDim2.new(1, 0, 0, 1)
	divider4.Parent = topbar

	local elements = Instance.new("Frame")
	elements.Name = "Elements"
	elements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	elements.BackgroundTransparency = 1
	elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
	elements.BorderSizePixel = 0
	elements.Size = UDim2.fromScale(1, 1)

	local uIPadding2 = Instance.new("UIPadding")
	uIPadding2.Name = "UIPadding"
	uIPadding2.PaddingLeft = UDim.new(0, 20)
	uIPadding2.PaddingRight = UDim.new(0, 20)
	uIPadding2.Parent = elements

	local moveIcon = Instance.new("ImageButton")
	moveIcon.Name = "MoveIcon"
	moveIcon.Image = assets.transform
	moveIcon.ImageTransparency = 0.7
	moveIcon.AnchorPoint = Vector2.new(1, 0.5)
	moveIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	moveIcon.BackgroundTransparency = 1
	moveIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	moveIcon.BorderSizePixel = 0
	moveIcon.Position = UDim2.fromScale(1, 0.5)
	moveIcon.Size = UDim2.fromOffset(15, 15)
	moveIcon.Parent = elements
	moveIcon.Visible = not Settings.DragStyle or Settings.DragStyle == 1

	local interact = Instance.new("TextButton")
	interact.Name = "Interact"
	interact.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	interact.Text = ""
	interact.TextColor3 = Color3.fromRGB(0, 0, 0)
	interact.TextSize = 14
	interact.AnchorPoint = Vector2.new(0.5, 0.5)
	interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	interact.BackgroundTransparency = 1
	interact.BorderColor3 = Color3.fromRGB(0, 0, 0)
	interact.BorderSizePixel = 0
	interact.Position = UDim2.fromScale(0.5, 0.5)
	interact.Size = UDim2.fromOffset(40, 40)
	interact.Parent = moveIcon

	local function ChangemoveIconState(State)
		if State == "Default" then
			Tween(moveIcon, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.7
			}):Play()
		elseif State == "Hover" then
			Tween(moveIcon, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.4
			}):Play()
		end
	end

	interact.MouseEnter:Connect(function()
		ChangemoveIconState("Hover")
	end)
	interact.MouseLeave:Connect(function()
		ChangemoveIconState("Default")
	end)

	local dragging_ = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		base.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	local function onDragStart(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging_ = true
			dragStart = input.Position
			startPos = base.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging_ = false
				end
			end)
		end
	end

	local function onDragUpdate(input)
		if dragging_ and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			dragInput = input
		end
	end

	if not Settings.DragStyle or Settings.DragStyle == 1 then
		interact.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				onDragStart(input)
			end
		end)

		interact.InputChanged:Connect(onDragUpdate)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging_ then
				update(input)
			end
		end)

		interact.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging_ = false
			end
		end)
	elseif Settings.DragStyle == 2 then
		base.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				onDragStart(input)
			end
		end)

		base.InputChanged:Connect(onDragUpdate)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging_ then
				update(input)
			end
		end)

		base.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging_ = false
			end
		end)
	end

	local currentTab = Instance.new("TextLabel")
	currentTab.Name = "CurrentTab"
	currentTab.FontFace = Font.new(assets.interFont)
	currentTab.RichText = true
	currentTab.Text = ""
	currentTab.RichText = true
	currentTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.TextSize = 15
	currentTab.TextTransparency = 0.5
	currentTab.TextTruncate = Enum.TextTruncate.SplitWord
	currentTab.TextXAlignment = Enum.TextXAlignment.Left
	currentTab.TextYAlignment = Enum.TextYAlignment.Top
	currentTab.AnchorPoint = Vector2.new(0, 0.5)
	currentTab.AutomaticSize = Enum.AutomaticSize.Y
	currentTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.BackgroundTransparency = 1
	currentTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	currentTab.BorderSizePixel = 0
	currentTab.Position = UDim2.fromScale(0, 0.5)
	currentTab.Size = UDim2.fromScale(0.9, 0)
	currentTab.Parent = elements

	elements.Parent = topbar

	topbar.Parent = content

	content.Parent = base

	local globalSettings = Instance.new("Frame")
	globalSettings.Name = "GlobalSettings"
	globalSettings.AutomaticSize = Enum.AutomaticSize.XY
	globalSettings.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	globalSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
	globalSettings.BorderSizePixel = 0
	globalSettings.Position = UDim2.fromScale(0.298, 0.104)

	local globalSettingsUIStroke = Instance.new("UIStroke")
	globalSettingsUIStroke.Name = "GlobalSettingsUIStroke"
	globalSettingsUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	globalSettingsUIStroke.Color = Color3.fromRGB(255, 255, 255)
	globalSettingsUIStroke.Transparency = 0.9
	globalSettingsUIStroke.Parent = globalSettings

	local globalSettingsUICorner = Instance.new("UICorner")
	globalSettingsUICorner.Name = "GlobalSettingsUICorner"
	globalSettingsUICorner.CornerRadius = UDim.new(0, 10)
	globalSettingsUICorner.Parent = globalSettings

	local globalSettingsUIPadding = Instance.new("UIPadding")
	globalSettingsUIPadding.Name = "GlobalSettingsUIPadding"
	globalSettingsUIPadding.PaddingBottom = UDim.new(0, 10)
	globalSettingsUIPadding.PaddingTop = UDim.new(0, 10)
	globalSettingsUIPadding.Parent = globalSettings

	local globalSettingsUIListLayout = Instance.new("UIListLayout")
	globalSettingsUIListLayout.Name = "GlobalSettingsUIListLayout"
	globalSettingsUIListLayout.Padding = UDim.new(0, 5)
	globalSettingsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	globalSettingsUIListLayout.Parent = globalSettings

	local globalSettingsUIScale = Instance.new("UIScale")
	globalSettingsUIScale.Name = "GlobalSettingsUIScale"
	globalSettingsUIScale.Scale = 1e-07
	globalSettingsUIScale.Parent = globalSettings
	globalSettings.Parent = base
	base.Parent = macLib

	function WindowFunctions:UpdateTitle(NewTitle)
		title.Text = NewTitle
	end

	function WindowFunctions:UpdateSubtitle(NewSubtitle)
		subtitle.Text = NewSubtitle
	end

	local hovering
	local toggled = globalSettingsUIScale.Scale == 1 and true or false
	local function toggle()
		if not toggled then
			local intween = Tween(globalSettingsUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 1
			})
			intween:Play()
			intween.Completed:Wait()
			toggled = true
		elseif toggled then
			local outtween = Tween(globalSettingsUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 0
			})
			outtween:Play()
			outtween.Completed:Wait()
			toggled = false
		end
	end
	globalSettingsButton.MouseButton1Click:Connect(function()
		if not hasGlobalSetting then return end
		toggle()
	end)
	globalSettings.MouseEnter:Connect(function()
		hovering = true
	end)
	globalSettings.MouseLeave:Connect(function()
		hovering = false
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 and toggled and not hovering then
			toggle()
		end
	end)

	local BlurTarget = base

	local HS = HttpService
	local camera = workspace.CurrentCamera
	local MTREL = "Glass"
	local binds = {}
	local wedgeguid = HS:GenerateGUID(true)

	local DepthOfField

	for _,v in pairs(Lighting:GetChildren()) do
		if not v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
			DepthOfField = Instance.new('DepthOfFieldEffect')
			DepthOfField.FarIntensity = 0
			DepthOfField.FocusDistance = 51.6
			DepthOfField.InFocusRadius = 50
			DepthOfField.NearIntensity = 1
			DepthOfField.Name = HS:GenerateGUID(true)
			DepthOfField:AddTag(".")
		elseif v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
			DepthOfField = v
		end
	end

	if not DepthOfField then
		DepthOfField = Instance.new('DepthOfFieldEffect')
		DepthOfField.FarIntensity = 0
		DepthOfField.FocusDistance = 51.6
		DepthOfField.InFocusRadius = 50
		DepthOfField.NearIntensity = 1
		DepthOfField.Name = HS:GenerateGUID(true)
		DepthOfField:AddTag(".")
	end

	local frame = Instance.new('Frame')
	frame.Parent = BlurTarget
	frame.Size = UDim2.new(0.97, 0, 0.97, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundTransparency = 1
	frame.Name = HS:GenerateGUID(true)

	do
		local function IsNotNaN(x)
			return x == x
		end
		local continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		while not continue do
			RunService.RenderStepped:Wait()
			continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		end
	end

	local DrawQuad; do
		local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
		local sz = 0.2

		local function DrawTriangle(v1, v2, v3, p0, p1)
			local s1 = (v1 - v2).magnitude
			local s2 = (v2 - v3).magnitude
			local s3 = (v3 - v1).magnitude
			local smax = max(s1, s2, s3)
			local A, B, C
			if s1 == smax then
				A, B, C = v1, v2, v3
			elseif s2 == smax then
				A, B, C = v2, v3, v1
			elseif s3 == smax then
				A, B, C = v3, v1, v2
			end

			local para = ( (B-A).x*(C-A).x + (B-A).y*(C-A).y + (B-A).z*(C-A).z ) / (A-B).magnitude
			local perp = sqrt((C-A).magnitude^2 - para*para)
			local dif_para = (A - B).magnitude - para

			local st = CFrame.new(B, A)
			local za = CFrame.Angles(pi/2,0,0)

			local cf0 = st

			local Top_Look = (cf0 * za).lookVector
			local Mid_Point = A + CFrame.new(A, B).lookVector * para
			local Needed_Look = CFrame.new(Mid_Point, C).lookVector
			local dot = Top_Look.x*Needed_Look.x + Top_Look.y*Needed_Look.y + Top_Look.z*Needed_Look.z

			local ac = CFrame.Angles(0, 0, acos(dot))

			cf0 = cf0 * ac
			if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf0 = cf0 * CFrame.Angles(0, 0, -2*acos(dot))
			end
			cf0 = cf0 * CFrame.new(0, perp/2, -(dif_para + para/2))

			local cf1 = st * ac * CFrame.Angles(0, pi, 0)
			if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf1 = cf1 * CFrame.Angles(0, 0, 2*acos(dot))
			end
			cf1 = cf1 * CFrame.new(0, perp/2, dif_para/2)

			if not p0 then
				p0 = Instance.new('Part')
				p0.FormFactor = 'Custom'
				p0.TopSurface = 0
				p0.BottomSurface = 0
				p0.Anchored = true
				p0.CanCollide = false
				p0.CastShadow = false
				p0.Material = MTREL
				p0.Size = Vector3.new(sz, sz, sz)
				p0.Name = HS:GenerateGUID(true)
				local mesh = Instance.new('SpecialMesh', p0)
				mesh.MeshType = 2
				mesh.Name = wedgeguid
			end
			p0[wedgeguid].Scale = Vector3.new(0, perp/sz, para/sz)
			p0.CFrame = cf0

			if not p1 then
				p1 = p0:clone()
			end
			p1[wedgeguid].Scale = Vector3.new(0, perp/sz, dif_para/sz)
			p1.CFrame = cf1

			return p0, p1
		end

		function DrawQuad(v1, v2, v3, v4, parts)
			parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
			parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
		end
	end

	if binds[frame] then
		return binds[frame].parts
	end

	local parts = {}

	local parents = {}
	do
		local function add(child)
			if child:IsA'GuiObject' then
				parents[#parents + 1] = child
				add(child.Parent)
			end
		end
		add(frame)
	end

	local function IsVisible(instance)
		while instance do
			if instance:IsA("GuiObject") then
				if not instance.Visible then
					return false
				end
			elseif instance:IsA("ScreenGui") then
				if not instance.Enabled then
					return false
				end
				break
			end
			instance = instance.Parent
		end
		return true
	end

	local function UpdateOrientation(fetchProps)
		if not IsVisible(frame) or not acrylicBlur or unloaded then
			for _, pt in pairs(parts) do
				pt.Parent = nil
				DepthOfField.Enabled = false
				DepthOfField.Parent = nil
			end
			return
		end
		if not DepthOfField.Parent then
			DepthOfField.Parent = Lighting
		end
		DepthOfField.Enabled = true
		local properties = {
			Transparency = 0.98;
			BrickColor = BrickColor.new('Institutional white');
		}
		local zIndex = 1 - 0.05*frame.ZIndex

		local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
		local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
		do
			local rot = 0;
			for _, v in ipairs(parents) do
				rot = rot + v.Rotation
			end
			if rot ~= 0 and rot%180 ~= 0 then
				local mid = tl:lerp(br, 0.5)
				local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
				local vec = tl
				tl = Vector2.new(c*(tl.x - mid.x) - s*(tl.y - mid.y), s*(tl.x - mid.x) + c*(tl.y - mid.y)) + mid
				tr = Vector2.new(c*(tr.x - mid.x) - s*(tr.y - mid.y), s*(tr.x - mid.x) + c*(tr.y - mid.y)) + mid
				bl = Vector2.new(c*(bl.x - mid.x) - s*(bl.y - mid.y), s*(bl.x - mid.x) + c*(bl.y - mid.y)) + mid
				br = Vector2.new(c*(br.x - mid.x) - s*(br.y - mid.y), s*(br.x - mid.x) + c*(br.y - mid.y)) + mid
			end
		end
		DrawQuad(
			camera:ScreenPointToRay(tl.x, tl.y, zIndex).Origin, 
			camera:ScreenPointToRay(tr.x, tr.y, zIndex).Origin, 
			camera:ScreenPointToRay(bl.x, bl.y, zIndex).Origin, 
			camera:ScreenPointToRay(br.x, br.y, zIndex).Origin, 
			parts
		)
		if fetchProps then
			for _, pt in pairs(parts) do
				pt.Parent = camera
			end
			for propName, propValue in pairs(properties) do
				for _, pt in pairs(parts) do
					pt[propName] = propValue
				end
			end
		end
	end

	UpdateOrientation(true)

	RunService.RenderStepped:Connect(UpdateOrientation)

	function WindowFunctions:GlobalSetting(Settings)
		hasGlobalSetting = true
		local GlobalSettingFunctions = {}
		local globalSetting = Instance.new("TextButton")
		globalSetting.Name = "GlobalSetting"
		globalSetting.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
		globalSetting.Text = ""
		globalSetting.TextColor3 = Color3.fromRGB(0, 0, 0)
		globalSetting.TextSize = 14
		globalSetting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		globalSetting.BackgroundTransparency = 1
		globalSetting.BorderColor3 = Color3.fromRGB(0, 0, 0)
		globalSetting.BorderSizePixel = 0
		globalSetting.Size = UDim2.fromOffset(200, 30)

		local globalSettingToggleUIPadding = Instance.new("UIPadding")
		globalSettingToggleUIPadding.Name = "GlobalSettingToggleUIPadding"
		globalSettingToggleUIPadding.PaddingLeft = UDim.new(0, 15)
		globalSettingToggleUIPadding.Parent = globalSetting

		local settingName = Instance.new("TextLabel")
		settingName.Name = "SettingName"
		settingName.FontFace = Font.new(assets.interFont)
		settingName.Text = Settings.Name
		settingName.RichText = true
		settingName.TextColor3 = Color3.fromRGB(255, 255, 255)
		settingName.TextSize = 13
		settingName.TextTransparency = 0.5
		settingName.TextTruncate = Enum.TextTruncate.SplitWord
		settingName.TextXAlignment = Enum.TextXAlignment.Left
		settingName.TextYAlignment = Enum.TextYAlignment.Top
		settingName.AnchorPoint = Vector2.new(0, 0.5)
		settingName.AutomaticSize = Enum.AutomaticSize.Y
		settingName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		settingName.BackgroundTransparency = 1
		settingName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		settingName.BorderSizePixel = 0
		settingName.Position = UDim2.fromScale(1.3e-07, 0.5)
		settingName.Size = UDim2.new(1,-40,0,0)
		settingName.Parent = globalSetting

		local globalSettingToggleUIListLayout = Instance.new("UIListLayout")
		globalSettingToggleUIListLayout.Name = "GlobalSettingToggleUIListLayout"
		globalSettingToggleUIListLayout.Padding = UDim.new(0, 10)
		globalSettingToggleUIListLayout.FillDirection = Enum.FillDirection.Horizontal
		globalSettingToggleUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		globalSettingToggleUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		globalSettingToggleUIListLayout.Parent = globalSetting

		local checkmark = Instance.new("TextLabel")
		checkmark.Name = "Checkmark"
		checkmark.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		checkmark.Text = "✓"
		checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
		checkmark.TextSize = 13
		checkmark.TextTransparency = 1
		checkmark.TextXAlignment = Enum.TextXAlignment.Left
		checkmark.TextYAlignment = Enum.TextYAlignment.Top
		checkmark.AnchorPoint = Vector2.new(0, 0.5)
		checkmark.AutomaticSize = Enum.AutomaticSize.Y
		checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		checkmark.BackgroundTransparency = 1
		checkmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
		checkmark.BorderSizePixel = 0
		checkmark.LayoutOrder = -1
		checkmark.Position = UDim2.fromScale(1.3e-07, 0.5)
		checkmark.Size = UDim2.fromOffset(-10, 0)
		checkmark.Parent = globalSetting

		globalSetting.Parent = globalSettings

		local tweensettings = {
			duration = 0.2,
			easingStyle = Enum.EasingStyle.Quint,
			transparencyIn = 0.2,
			transparencyOut = 0.5,
			checkSizeIncrease = 12,
			checkSizeDecrease = -globalSettingToggleUIListLayout.Padding.Offset,
			waitTime = 1
		}

		local tweens = {
			checkIn = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
				Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
			}),
			checkOut = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
			}),
			nameIn = Tween(settingName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				TextTransparency = tweensettings.transparencyIn
			}),
			nameOut = Tween(settingName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				TextTransparency = tweensettings.transparencyOut
			})
		}

		local function Toggle(State)
			if not State then
				tweens.checkOut:Play()
				tweens.nameOut:Play()
				checkmark:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if checkmark.AbsoluteSize.X <= 0 then
						checkmark.TextTransparency = 1
					end
				end)
			else
				tweens.checkIn:Play()
				tweens.nameIn:Play()
				checkmark:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if checkmark.AbsoluteSize.X > 0 then
						checkmark.TextTransparency = 0
					end
				end)
			end
		end

		local toggled = Settings.Default
		Toggle(toggled)

		globalSetting.MouseButton1Click:Connect(function()
			toggled = not toggled
			Toggle(toggled)

			task.spawn(function()
				if Settings.Callback then
					Settings.Callback(toggled)
				end
			end)
		end)

		function GlobalSettingFunctions:UpdateName(NewName)
			settingName.Text = NewName
		end

		function GlobalSettingFunctions:UpdateState(NewState)
			Toggle(NewState)
			toggled = NewState
		end

		return GlobalSettingFunctions
	end

	function WindowFunctions:TabGroup()
		local SectionFunctions = {}

		local tabGroup = Instance.new("Frame")
		tabGroup.Name = "Section"
		tabGroup.AutomaticSize = Enum.AutomaticSize.Y
		tabGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabGroup.BackgroundTransparency = 1
		tabGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabGroup.BorderSizePixel = 0
		tabGroup.Size = UDim2.fromScale(1, 0)

		local divider3 = Instance.new("Frame")
		divider3.Name = "Divider"
		divider3.AnchorPoint = Vector2.new(0.5, 1)
		divider3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		divider3.BackgroundTransparency = 0.9
		divider3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		divider3.BorderSizePixel = 0
		divider3.Position = UDim2.fromScale(0.5, 1)
		divider3.Size = UDim2.new(1, -21, 0, 1)
		divider3.Parent = tabGroup

		local sectionTabSwitchers = Instance.new("Frame")
		sectionTabSwitchers.Name = "SectionTabSwitchers"
		sectionTabSwitchers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		sectionTabSwitchers.BackgroundTransparency = 1
		sectionTabSwitchers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		sectionTabSwitchers.BorderSizePixel = 0
		sectionTabSwitchers.Size = UDim2.fromScale(1, 1)

		local uIListLayout1 = Instance.new("UIListLayout")
		uIListLayout1.Name = "UIListLayout"
		uIListLayout1.Padding = UDim.new(0, 15)
		uIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = sectionTabSwitchers

		local uIPadding1 = Instance.new("UIPadding")
		uIPadding1.Name = "UIPadding"
		uIPadding1.PaddingBottom = UDim.new(0, 15)
		uIPadding1.Parent = sectionTabSwitchers

		sectionTabSwitchers.Parent = tabGroup
		tabGroup.Parent = tabSwitchersScrollingFrame

		function SectionFunctions:Tab(Settings)
			local TabFunctions = {Settings = Settings}
			local tabSwitcher = Instance.new("TextButton")
			tabSwitcher.Name = "TabSwitcher"
			tabSwitcher.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			tabSwitcher.Text = ""
			tabSwitcher.TextColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcher.TextSize = 14
			tabSwitcher.AutoButtonColor = false
			tabSwitcher.AnchorPoint = Vector2.new(0.5, 0)
			tabSwitcher.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcher.BackgroundTransparency = 1
			tabSwitcher.BorderColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcher.BorderSizePixel = 0
			tabSwitcher.Position = UDim2.fromScale(0.5, 0)
			tabSwitcher.Size = UDim2.new(1, -21, 0, 40)

			tabIndex += 1
			tabSwitcher.LayoutOrder = tabIndex

			local tabSwitcherUICorner = Instance.new("UICorner")
			tabSwitcherUICorner.Name = "TabSwitcherUICorner"
			tabSwitcherUICorner.Parent = tabSwitcher

			local tabSwitcherUIStroke = Instance.new("UIStroke")
			tabSwitcherUIStroke.Name = "TabSwitcherUIStroke"
			tabSwitcherUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			tabSwitcherUIStroke.Color = Color3.fromRGB(255, 255, 255)
			tabSwitcherUIStroke.Transparency = 1
			tabSwitcherUIStroke.Parent = tabSwitcher

			local tabSwitcherUIListLayout = Instance.new("UIListLayout")
			tabSwitcherUIListLayout.Name = "TabSwitcherUIListLayout"
			tabSwitcherUIListLayout.Padding = UDim.new(0, 9)
			tabSwitcherUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			tabSwitcherUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabSwitcherUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			tabSwitcherUIListLayout.Parent = tabSwitcher

			local tabImage

			if Settings.Image then
				tabImage = Instance.new("ImageLabel")
				tabImage.Name = "TabImage"
				tabImage.Image = Settings.Image
				tabImage.ImageTransparency = 0.5
				tabImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				tabImage.BackgroundTransparency = 1
				tabImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
				tabImage.BorderSizePixel = 0
				tabImage.Size = UDim2.fromOffset(18, 18)
				tabImage.Parent = tabSwitcher
			end

			local tabSwitcherName = Instance.new("TextLabel")
			tabSwitcherName.Name = "TabSwitcherName"
			tabSwitcherName.FontFace = Font.new(
				assets.interFont,
				Enum.FontWeight.Medium,
				Enum.FontStyle.Normal
			)
			tabSwitcherName.Text = Settings.Name
			tabSwitcherName.RichText = true
			tabSwitcherName.TextColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.TextSize = 16
			tabSwitcherName.TextTransparency = 0.5
			tabSwitcherName.TextTruncate = Enum.TextTruncate.SplitWord
			tabSwitcherName.TextXAlignment = Enum.TextXAlignment.Left
			tabSwitcherName.TextYAlignment = Enum.TextYAlignment.Top
			tabSwitcherName.AutomaticSize = Enum.AutomaticSize.Y
			tabSwitcherName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.BackgroundTransparency = 1
			tabSwitcherName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcherName.BorderSizePixel = 0
			tabSwitcherName.Size = UDim2.fromScale(1, 0)
			tabSwitcherName.Parent = tabSwitcher
			tabSwitcherName.LayoutOrder = 1

			local tabSwitcherUIPadding = Instance.new("UIPadding")
			tabSwitcherUIPadding.Name = "TabSwitcherUIPadding"
			tabSwitcherUIPadding.PaddingLeft = UDim.new(0, 24)
			tabSwitcherUIPadding.PaddingRight = UDim.new(0, 35)
			tabSwitcherUIPadding.PaddingTop = UDim.new(0, 1)
			tabSwitcherUIPadding.Parent = tabSwitcher

			tabSwitcher.Parent = sectionTabSwitchers

			local elements1 = Instance.new("Frame")
			elements1.Name = "Elements"
			elements1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			elements1.BackgroundTransparency = 1
			elements1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			elements1.BorderSizePixel = 0
			elements1.Position = UDim2.fromOffset(0, 63)
			elements1.Size = UDim2.new(1, 0, 1, -63)
			elements1.ClipsDescendants = true

			local elementsUIPadding = Instance.new("UIPadding")
			elementsUIPadding.Name = "ElementsUIPadding"
			elementsUIPadding.PaddingRight = UDim.new(0, 5)
			elementsUIPadding.PaddingTop = UDim.new(0, 10)
			elementsUIPadding.PaddingBottom = UDim.new(0, 10)
			elementsUIPadding.Parent = elements1

			local elementsScrolling = Instance.new("ScrollingFrame")
			elementsScrolling.Name = "ElementsScrolling"
			elementsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
			elementsScrolling.BottomImage = ""
			elementsScrolling.CanvasSize = UDim2.new()
			elementsScrolling.ScrollBarImageTransparency = 0.5
			elementsScrolling.ScrollBarThickness = 1
			elementsScrolling.TopImage = ""
			elementsScrolling.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			elementsScrolling.BackgroundTransparency = 1
			elementsScrolling.BorderColor3 = Color3.fromRGB(0, 0, 0)
			elementsScrolling.BorderSizePixel = 0
			elementsScrolling.Size = UDim2.fromScale(1, 1)
			elementsScrolling.ClipsDescendants = false

			local elementsScrollingUIPadding = Instance.new("UIPadding")
			elementsScrollingUIPadding.Name = "ElementsScrollingUIPadding"
			elementsScrollingUIPadding.PaddingBottom = UDim.new(0, 5)
			elementsScrollingUIPadding.PaddingLeft = UDim.new(0, 11)
			elementsScrollingUIPadding.PaddingRight = UDim.new(0, 3)
			elementsScrollingUIPadding.PaddingTop = UDim.new(0, 5)
			elementsScrollingUIPadding.Parent = elementsScrolling

			local elementsScrollingUIListLayout = Instance.new("UIListLayout")
			elementsScrollingUIListLayout.Name = "ElementsScrollingUIListLayout"
			elementsScrollingUIListLayout.Padding = UDim.new(0, 15)
			elementsScrollingUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			elementsScrollingUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			elementsScrollingUIListLayout.Parent = elementsScrolling

			local left = Instance.new("Frame")
			left.Name = "Left"
			left.AutomaticSize = Enum.AutomaticSize.Y
			left.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			left.BackgroundTransparency = 1
			left.BorderColor3 = Color3.fromRGB(0, 0, 0)
			left.BorderSizePixel = 0
			left.Position = UDim2.fromScale(0.512, 0)
			left.Size = UDim2.new(0.5, -10, 0, 0)

			local leftUIListLayout = Instance.new("UIListLayout")
			leftUIListLayout.Name = "LeftUIListLayout"
			leftUIListLayout.Padding = UDim.new(0, 15)
			leftUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			leftUIListLayout.Parent = left

			left.Parent = elementsScrolling

			local right = Instance.new("Frame")
			right.Name = "Right"
			right.AutomaticSize = Enum.AutomaticSize.Y
			right.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			right.BackgroundTransparency = 1
			right.BorderColor3 = Color3.fromRGB(0, 0, 0)
			right.BorderSizePixel = 0
			right.LayoutOrder = 1
			right.Position = UDim2.fromScale(0.512, 0)
			right.Size = UDim2.new(0.5, -10, 0, 0)

			local rightUIListLayout = Instance.new("UIListLayout")
			rightUIListLayout.Name = "RightUIListLayout"
			rightUIListLayout.Padding = UDim.new(0, 15)
			rightUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			rightUIListLayout.Parent = right

			right.Parent = elementsScrolling

			elementsScrolling.Parent = elements1

			function TabFunctions:Section(Settings)
				local SectionFunctions = {}
				local section = Instance.new("Frame")
				section.Name = "Section"
				section.AutomaticSize = Enum.AutomaticSize.Y
				section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				section.BackgroundTransparency = 0.98
				section.BorderColor3 = Color3.fromRGB(0, 0, 0)
				section.BorderSizePixel = 0
				section.Position = UDim2.fromScale(0, 6.78e-08)
				section.Size = UDim2.fromScale(1, 0)
				section.ClipsDescendants = true
				section.Parent = Settings.Side == "Left" and left or right

				local sectionUICorner = Instance.new("UICorner")
				sectionUICorner.Name = "SectionUICorner"
				sectionUICorner.Parent = section

				local sectionUIStroke = Instance.new("UIStroke")
				sectionUIStroke.Name = "SectionUIStroke"
				sectionUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				sectionUIStroke.Color = Color3.fromRGB(255, 255, 255)
				sectionUIStroke.Transparency = 0.95
				sectionUIStroke.Parent = section

				local sectionUIListLayout = Instance.new("UIListLayout")
				sectionUIListLayout.Name = "SectionUIListLayout"
				sectionUIListLayout.Padding = UDim.new(0, 10)
				sectionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				sectionUIListLayout.Parent = section

				local sectionUIPadding = Instance.new("UIPadding")
				sectionUIPadding.Name = "SectionUIPadding"
				sectionUIPadding.PaddingBottom = UDim.new(0, 20)
				sectionUIPadding.PaddingLeft = UDim.new(0, 20)
				sectionUIPadding.PaddingRight = UDim.new(0, 18)
				sectionUIPadding.PaddingTop = UDim.new(0, 22)
				sectionUIPadding.Parent = section

				function SectionFunctions:Button(Settings, Flag)
					local ButtonFunctions = {Settings = Settings}
					local button = Instance.new("Frame")
					button.Name = "Button"
					button.AutomaticSize = Enum.AutomaticSize.Y
					button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					button.BackgroundTransparency = 1
					button.BorderColor3 = Color3.fromRGB(0, 0, 0)
					button.BorderSizePixel = 0
					button.Size = UDim2.new(1, 0, 0, 38)
					button.Parent = section

					local buttonInteract = Instance.new("TextButton")
					buttonInteract.Name = "ButtonInteract"
					buttonInteract.FontFace = Font.new(assets.interFont)
					buttonInteract.RichText = true
					buttonInteract.TextColor3 = Color3.fromRGB(255, 255, 255)
					buttonInteract.TextSize = 13
					buttonInteract.TextTransparency = 0.5
					buttonInteract.TextTruncate = Enum.TextTruncate.AtEnd
					buttonInteract.TextXAlignment = Enum.TextXAlignment.Left
					buttonInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					buttonInteract.BackgroundTransparency = 1
					buttonInteract.BorderColor3 = Color3.fromRGB(0, 0, 0)
					buttonInteract.BorderSizePixel = 0
					buttonInteract.Size = UDim2.fromScale(1, 1)
					buttonInteract.Parent = button
					buttonInteract.Text = ButtonFunctions.Settings.Name

					local buttonImage = Instance.new("ImageLabel")
					buttonImage.Name = "ButtonImage"
					buttonImage.Image = assets.buttonImage
					buttonImage.ImageTransparency = 0.5
					buttonImage.AnchorPoint = Vector2.new(1, 0.5)
					buttonImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					buttonImage.BackgroundTransparency = 1
					buttonImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
					buttonImage.BorderSizePixel = 0
					buttonImage.Position = UDim2.fromScale(1, 0.5)
					buttonImage.Size = UDim2.fromOffset(15, 15)
					buttonImage.Parent = button

					local TweenSettings = {
						DefaultTransparency = 0.5,
						HoverTransparency = 0.3,

						EasingStyle = Enum.EasingStyle.Sine
					}

					local function ChangeState(State)
						if State == "Idle" then
							Tween(buttonInteract, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
								TextTransparency = TweenSettings.DefaultTransparency
							}):Play()
							Tween(buttonImage, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
								ImageTransparency = TweenSettings.DefaultTransparency
							}):Play()
						elseif State == "Hover" then
							Tween(buttonInteract, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
								TextTransparency = TweenSettings.HoverTransparency
							}):Play()
							Tween(buttonImage, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
								ImageTransparency = TweenSettings.HoverTransparency
							}):Play()
						end
					end

					local function Callback()
						if ButtonFunctions.Settings.Callback then
							ButtonFunctions.Settings.Callback()
						end
					end

					buttonInteract.MouseEnter:Connect(function()
						ChangeState("Hover")
					end)
					buttonInteract.MouseLeave:Connect(function()
						ChangeState("Idle")
					end)

					buttonInteract.MouseButton1Click:Connect(Callback)
					function ButtonFunctions:UpdateName(Name)
						buttonInteract.Text = Name
					end
					function ButtonFunctions:SetVisibility(State)
						button.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = ButtonFunctions
					end
					return ButtonFunctions
				end

				function SectionFunctions:Toggle(Settings, Flag)
					local ToggleFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Toggle" }
					local toggle = Instance.new("Frame")
					toggle.Name = "Toggle"
					toggle.AutomaticSize = Enum.AutomaticSize.Y
					toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					toggle.BackgroundTransparency = 1
					toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
					toggle.BorderSizePixel = 0
					toggle.Size = UDim2.new(1, 0, 0, 38)
					toggle.Parent = section

					local toggleName = Instance.new("TextLabel")
					toggleName.Name = "ToggleName"
					toggleName.FontFace = Font.new(assets.interFont)
					toggleName.Text = ToggleFunctions.Settings.Name
					toggleName.RichText = true
					toggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
					toggleName.TextSize = 13
					toggleName.TextTransparency = 0.5
					toggleName.TextTruncate = Enum.TextTruncate.AtEnd
					toggleName.TextXAlignment = Enum.TextXAlignment.Left
					toggleName.TextYAlignment = Enum.TextYAlignment.Top
					toggleName.AnchorPoint = Vector2.new(0, 0.5)
					toggleName.AutomaticSize = Enum.AutomaticSize.Y
					toggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					toggleName.BackgroundTransparency = 1
					toggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					toggleName.BorderSizePixel = 0
					toggleName.Position = UDim2.fromScale(0, 0.5)
					toggleName.Size = UDim2.new(1, -50, 0, 0)
					toggleName.Parent = toggle

					local toggle1 = Instance.new("ImageButton")
					toggle1.Name = "Toggle"
					toggle1.Image = assets.toggleBackground
					toggle1.ImageColor3 = Color3.fromRGB(87, 86, 86)
					toggle1.AutoButtonColor = false
					toggle1.AnchorPoint = Vector2.new(1, 0.5)
					toggle1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					toggle1.BackgroundTransparency = 1
					toggle1.BorderColor3 = Color3.fromRGB(0, 0, 0)
					toggle1.BorderSizePixel = 0
					toggle1.Position = UDim2.fromScale(1, 0.5)
					toggle1.Size = UDim2.fromOffset(41, 21)
					toggle1.ImageTransparency = 0.5

					local toggleUIPadding = Instance.new("UIPadding")
					toggleUIPadding.Name = "ToggleUIPadding"
					toggleUIPadding.PaddingBottom = UDim.new(0, 1)
					toggleUIPadding.PaddingLeft = UDim.new(0, -2)
					toggleUIPadding.PaddingRight = UDim.new(0, 3)
					toggleUIPadding.PaddingTop = UDim.new(0, 1)
					toggleUIPadding.Parent = toggle1

					local togglerHead = Instance.new("ImageLabel")
					togglerHead.Name = "TogglerHead"
					togglerHead.Image = assets.togglerHead
					togglerHead.ImageColor3 = Color3.fromRGB(255, 255, 255)
					togglerHead.AnchorPoint = Vector2.new(1, 0.5)
					togglerHead.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					togglerHead.BackgroundTransparency = 1
					togglerHead.BorderColor3 = Color3.fromRGB(0, 0, 0)
					togglerHead.BorderSizePixel = 0
					togglerHead.Position = UDim2.fromScale(0.5, 0.5)
					togglerHead.Size = UDim2.fromOffset(15, 15)
					togglerHead.ZIndex = 2
					togglerHead.Parent = toggle1
					togglerHead.ImageTransparency = 0.8

					toggle1.Parent = toggle

					local toggle1Transparency = {Enabled = 0, Disabled = 0.5}
					local togglerHeadTransparency = {Enabled = 0, Disabled = 0.85}

					local TweenSettings = {
						Info = TweenInfo.new(0.15, Enum.EasingStyle.Quad),

						EnabledPosition = UDim2.new(1, 0, 0.5, 0),
						DisabledPosition = UDim2.new(0.5, 0, 0.5, 0),
					}

					local togglebool = ToggleFunctions.Settings.Default

					local function NewState(State, callback)
						local transparencyValues = State and {toggle1Transparency.Enabled, togglerHeadTransparency.Enabled}
							or {toggle1Transparency.Disabled, togglerHeadTransparency.Disabled}
						local position = State and TweenSettings.EnabledPosition or TweenSettings.DisabledPosition

						Tween(toggle1, TweenSettings.Info, {
							ImageTransparency = transparencyValues[1]
						}):Play()

						Tween(togglerHead, TweenSettings.Info, {
							ImageTransparency = transparencyValues[2]
						}):Play()

						Tween(togglerHead, TweenSettings.Info, {
							Position = position
						}):Play()

						ToggleFunctions.State = State
						if callback then
							callback(togglebool)
						end
					end

					NewState(togglebool)

					local function Toggle()
						togglebool = not togglebool
						NewState(togglebool, ToggleFunctions.Settings.Callback)
					end

					toggle1.MouseButton1Click:Connect(Toggle)

					function ToggleFunctions:Toggle()
						Toggle()
					end
					function ToggleFunctions:UpdateState(State)
						togglebool = State
						NewState(togglebool, ToggleFunctions.Settings.Callback)
					end
					function ToggleFunctions:GetState()
						return togglebool
					end
					function ToggleFunctions:UpdateName(Name)
						toggleName.Text = Name
					end
					function ToggleFunctions:SetVisibility(State)
						toggle.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = ToggleFunctions
					end
					return ToggleFunctions
				end

				function SectionFunctions:Slider(Settings, Flag)
					local SliderFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Slider" }
					local slider = Instance.new("Frame")
					slider.Name = "Slider"
					slider.AutomaticSize = Enum.AutomaticSize.Y
					slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					slider.BackgroundTransparency = 1
					slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
					slider.BorderSizePixel = 0
					slider.Size = UDim2.new(1, 0, 0, 38)
					slider.Parent = section

					local sliderName = Instance.new("TextLabel")
					sliderName.Name = "SliderName"
					sliderName.FontFace = Font.new(assets.interFont)
					sliderName.Text = SliderFunctions.Settings.Name
					sliderName.RichText = true
					sliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
					sliderName.TextSize = 13
					sliderName.TextTransparency = 0.5
					sliderName.TextTruncate = Enum.TextTruncate.AtEnd
					sliderName.TextXAlignment = Enum.TextXAlignment.Left
					sliderName.TextYAlignment = Enum.TextYAlignment.Top
					sliderName.AnchorPoint = Vector2.new(0, 0.5)
					sliderName.AutomaticSize = Enum.AutomaticSize.XY
					sliderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderName.BackgroundTransparency = 1
					sliderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderName.BorderSizePixel = 0
					sliderName.Position = UDim2.fromScale(1.3e-07, 0.5)
					sliderName.Parent = slider

					local sliderElements = Instance.new("Frame")
					sliderElements.Name = "SliderElements"
					sliderElements.AnchorPoint = Vector2.new(1, 0)
					sliderElements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderElements.BackgroundTransparency = 1
					sliderElements.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderElements.BorderSizePixel = 0
					sliderElements.Position = UDim2.fromScale(1, 0)
					sliderElements.Size = UDim2.fromScale(1, 1)

					local sliderValue = Instance.new("TextBox")
					sliderValue.Name = "SliderValue"
					sliderValue.FontFace = Font.new(assets.interFont)
					sliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
					sliderValue.TextSize = 12
					sliderValue.TextTransparency = 0.1
					--sliderValue.TextTruncate = Enum.TextTruncate.AtEnd
					sliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderValue.BackgroundTransparency = 0.95
					sliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderValue.BorderSizePixel = 0
					sliderValue.LayoutOrder = 1
					sliderValue.Position = UDim2.fromScale(-0.0789, 0.171)
					sliderValue.Size = UDim2.fromOffset(41, 21)
					sliderValue.ClipsDescendants = true

					local sliderValueUICorner = Instance.new("UICorner")
					sliderValueUICorner.Name = "SliderValueUICorner"
					sliderValueUICorner.CornerRadius = UDim.new(0, 4)
					sliderValueUICorner.Parent = sliderValue

					local sliderValueUIStroke = Instance.new("UIStroke")
					sliderValueUIStroke.Name = "SliderValueUIStroke"
					sliderValueUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					sliderValueUIStroke.Color = Color3.fromRGB(255, 255, 255)
					sliderValueUIStroke.Transparency = 0.9
					sliderValueUIStroke.Parent = sliderValue

					local sliderValueUIPadding = Instance.new("UIPadding")
					sliderValueUIPadding.Name = "SliderValueUIPadding"
					sliderValueUIPadding.PaddingLeft = UDim.new(0, 2)
					sliderValueUIPadding.PaddingRight = UDim.new(0, 2)
					sliderValueUIPadding.Parent = sliderValue

					sliderValue.Parent = sliderElements

					local sliderElementsUIListLayout = Instance.new("UIListLayout")
					sliderElementsUIListLayout.Name = "SliderElementsUIListLayout"
					sliderElementsUIListLayout.Padding = UDim.new(0, 20)
					sliderElementsUIListLayout.FillDirection = Enum.FillDirection.Horizontal
					sliderElementsUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
					sliderElementsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					sliderElementsUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
					sliderElementsUIListLayout.Parent = sliderElements

					local sliderBar = Instance.new("ImageLabel")
					sliderBar.Name = "SliderBar"
					sliderBar.Image = assets.sliderbar
					sliderBar.ImageColor3 = Color3.fromRGB(87, 86, 86)
					sliderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderBar.BackgroundTransparency = 1
					sliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderBar.BorderSizePixel = 0
					sliderBar.Position = UDim2.fromScale(0.219, 0.457)
					sliderBar.Size = UDim2.fromOffset(123, 3)

					local sliderHead = Instance.new("ImageButton")
					sliderHead.Name = "SliderHead"
					sliderHead.Image = assets.sliderhead
					sliderHead.AnchorPoint = Vector2.new(0.5, 0.5)
					sliderHead.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderHead.BackgroundTransparency = 1
					sliderHead.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderHead.BorderSizePixel = 0
					sliderHead.Position = UDim2.fromScale(1, 0.5)
					sliderHead.Size = UDim2.fromOffset(12, 12)
					sliderHead.Parent = sliderBar

					sliderBar.Parent = sliderElements

					local sliderElementsUIPadding = Instance.new("UIPadding")
					sliderElementsUIPadding.Name = "SliderElementsUIPadding"
					sliderElementsUIPadding.PaddingTop = UDim.new(0, 3)
					sliderElementsUIPadding.Parent = sliderElements

					sliderElements.Parent = slider

					local dragging = false

					local DisplayMethods = {
						Hundredths = function(sliderValue) -- Deprecated use Settings.Precision
							return string.format("%.2f", sliderValue)
						end,
						Tenths = function(sliderValue) -- Deprecated use Settings.Precision
							return string.format("%.1f", sliderValue)
						end,
						Round = function(sliderValue, precision)
							if precision then
								return string.format("%." .. precision .. "f", sliderValue)
							else
								return tostring(math.round(sliderValue))
							end
						end,
						Degrees = function(sliderValue, precision)
							local formattedValue = precision and string.format("%." .. precision .. "f", sliderValue) or tostring(sliderValue)
							return formattedValue .. "°"
						end,
						Percent = function(sliderValue, precision)
							local percentage = (sliderValue - SliderFunctions.Settings.Minimum) / (SliderFunctions.Settings.Maximum - SliderFunctions.Settings.Minimum) * 100
							return precision and string.format("%." .. precision .. "f", percentage) .. "%" or tostring(math.round(percentage)) .. "%"
						end,
						Value = function(sliderValue, precision)
							return precision and string.format("%." .. precision .. "f", sliderValue) or tostring(sliderValue)
						end
					}

					local ValueDisplayMethod = DisplayMethods[SliderFunctions.Settings.DisplayMethod] or DisplayMethods.Value
					local finalValue

					local function SetValue(val, ignorecallback)
						local posXScale

						if typeof(val) == "Instance" then
							local input = val
							posXScale = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
						else
							local value = val
							posXScale = (value - SliderFunctions.Settings.Minimum) / (SliderFunctions.Settings.Maximum - Settings.Minimum)
						end

						local pos = UDim2.new(posXScale, 0, 0.5, 0)
						sliderHead.Position = pos

						finalValue = posXScale * (SliderFunctions.Settings.Maximum - SliderFunctions.Settings.Minimum) + Settings.Minimum

						sliderValue.Text = (Settings.Prefix or "") .. ValueDisplayMethod(finalValue, SliderFunctions.Settings.Precision) .. (Settings.Suffix or "")

						if not ignorecallback then
							task.spawn(function()
								if SliderFunctions.Settings.Callback then
									SliderFunctions.Settings.Callback(finalValue)
								end
							end)
						end

						SliderFunctions.Value = finalValue
					end

					SetValue(SliderFunctions.Settings.Default, true)

					sliderHead.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = true
							SetValue(input)
						end
					end)

					sliderHead.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = false
							if SliderFunctions.Settings.onInputComplete then
								SliderFunctions.Settings.onInputComplete(finalValue)
							end
						end
					end)

					sliderValue.FocusLost:Connect(function(enterPressed)
						local inputText = sliderValue.Text
						local value, isPercent = inputText:match("^(%-?%d+%.?%d*)(%%?)$")

						if value then
							value = tonumber(value)
							isPercent = isPercent == "%"

							if isPercent then
								value = SliderFunctions.Settings.Minimum + (value / 100) * (SliderFunctions.Settings.Maximum - SliderFunctions.Settings.Minimum)
							end

							local newValue = math.clamp(value, SliderFunctions.Settings.Minimum, SliderFunctions.Settings.Maximum)
							SetValue(newValue)
						else
							sliderValue.Text = ValueDisplayMethod(sliderValue)
						end

						if SliderFunctions.Settings.onInputComplete then
							SliderFunctions.Settings.onInputComplete(finalValue)
						end
					end)

					UserInputService.InputChanged:Connect(function(input)
						if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
							SetValue(input)
						end
					end)

					local function updateSliderBarSize()
						local padding = sliderElementsUIListLayout.Padding.Offset
						local sliderValueWidth = sliderValue.AbsoluteSize.X
						local sliderNameWidth = sliderName.AbsoluteSize.X
						local totalWidth = sliderElements.AbsoluteSize.X

						local newBarWidth = (totalWidth - (padding + sliderValueWidth + sliderNameWidth + 20)) / baseUIScale.Scale
						sliderBar.Size = UDim2.new(sliderBar.Size.X.Scale, newBarWidth, sliderBar.Size.Y.Scale, sliderBar.Size.Y.Offset)
					end

					updateSliderBarSize()

					sliderName:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSliderBarSize)
					section:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSliderBarSize)

					function SliderFunctions:UpdateName(Name)
						sliderName = Name
					end
					function SliderFunctions:SetVisibility(State)
						slider.Visible = State
					end
					function SliderFunctions:UpdateValue(Value)
						SetValue(tonumber(Value), true)
					end
					function SliderFunctions:GetValue()
						return finalValue
					end

					if Flag then
						MacLib.Options[Flag] = SliderFunctions
					end
					return SliderFunctions
				end

				function SectionFunctions:Input(Settings, Flag)
					local InputFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Input" }
					local input = Instance.new("Frame")
					input.Name = "Input"
					input.AutomaticSize = Enum.AutomaticSize.Y
					input.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					input.BackgroundTransparency = 1
					input.BorderColor3 = Color3.fromRGB(0, 0, 0)
					input.BorderSizePixel = 0
					input.Size = UDim2.new(1, 0, 0, 38)
					input.Parent = section

					local inputName = Instance.new("TextLabel")
					inputName.Name = "InputName"
					inputName.FontFace = Font.new(assets.interFont)
					inputName.Text = InputFunctions.Settings.Name
					inputName.RichText = true
					inputName.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName.TextSize = 13
					inputName.TextTransparency = 0.5
					inputName.TextTruncate = Enum.TextTruncate.AtEnd
					inputName.TextXAlignment = Enum.TextXAlignment.Left
					inputName.TextYAlignment = Enum.TextYAlignment.Top
					inputName.AnchorPoint = Vector2.new(0, 0.5)
					inputName.AutomaticSize = Enum.AutomaticSize.XY
					inputName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName.BackgroundTransparency = 1
					inputName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName.BorderSizePixel = 0
					inputName.Position = UDim2.fromScale(0, 0.5)
					inputName.Parent = input

					local inputBox = Instance.new("TextBox")
					inputBox.Name = "InputBox"
					inputBox.FontFace = Font.new(assets.interFont)
					inputBox.Text = "Hello world!"
					inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.TextSize = 12
					inputBox.TextTransparency = 0.1
					inputBox.AnchorPoint = Vector2.new(1, 0.5)
					inputBox.AutomaticSize = Enum.AutomaticSize.X
					inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.BackgroundTransparency = 0.95
					inputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox.BorderSizePixel = 0
					inputBox.ClipsDescendants = true
					inputBox.LayoutOrder = 1
					inputBox.Position = UDim2.fromScale(1, 0.5)
					inputBox.Size = UDim2.fromOffset(21, 21)
					inputBox.TextXAlignment = Enum.TextXAlignment.Right

					local inputBoxUICorner = Instance.new("UICorner")
					inputBoxUICorner.Name = "InputBoxUICorner"
					inputBoxUICorner.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner.Parent = inputBox

					local inputBoxUIStroke = Instance.new("UIStroke")
					inputBoxUIStroke.Name = "InputBoxUIStroke"
					inputBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke.Transparency = 0.9
					inputBoxUIStroke.Parent = inputBox

					local inputBoxUIPadding = Instance.new("UIPadding")
					inputBoxUIPadding.Name = "InputBoxUIPadding"
					inputBoxUIPadding.PaddingLeft = UDim.new(0, 5)
					inputBoxUIPadding.PaddingRight = UDim.new(0, 5)
					inputBoxUIPadding.Parent = inputBox

					local inputBoxUISizeConstraint = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint.Parent = inputBox

					inputBox.Parent = input

					local Input = input
					local InputBox = inputBox
					local InputName = inputName
					local Constraint = inputBoxUISizeConstraint

					local function applyCharacterLimit(value)
						if InputFunctions.Settings.CharacterLimit then
							return value:sub(1, InputFunctions.Settings.CharacterLimit)
						end
						return value
					end

					local CharacterSubs = {
						All = function(value)
							return applyCharacterLimit(value)
						end,
						Numeric = function(value)
							local result = value:match("^%-?%d*$") and value or value:gsub("[^%d-]", ""):gsub("(%-)", function(match, pos)
								return pos == 1 and match or ""
							end)
							return applyCharacterLimit(result)
						end,
						Alphabetic = function(value)
							return applyCharacterLimit(value:gsub("[^a-zA-Z ]", ""))
						end,
						AlphaNumeric = function(value)
							return applyCharacterLimit(value:gsub("[^a-zA-Z0-9]", ""))
						end,
					}

					local AcceptedCharacters

					if type(InputFunctions.Settings.AcceptedCharacters) == "function" then
						AcceptedCharacters = InputFunctions.Settings.AcceptedCharacters
					else
						AcceptedCharacters = CharacterSubs[InputFunctions.Settings.AcceptedCharacters] or CharacterSubs.All
					end

					InputBox.AutomaticSize = Enum.AutomaticSize.X

					local function checkSize()
						local nameWidth = InputName.AbsoluteSize.X
						local totalWidth = Input.AbsoluteSize.X

						local maxWidth = (totalWidth - nameWidth - 20) / baseUIScale.Scale
						Constraint.MaxSize = Vector2.new(maxWidth, 9e9)
					end

					checkSize()
					InputName:GetPropertyChangedSignal("AbsoluteSize"):Connect(checkSize)

					InputBox.FocusLost:Connect(function()
						local inputText = InputBox.Text
						local filteredText = AcceptedCharacters(inputText)
						InputBox.Text = filteredText
						task.spawn(function()
							if InputFunctions.Settings.Callback then
								InputFunctions.Settings.Callback(filteredText)
							end
						end)
					end)
					InputBox.Text = InputFunctions.Settings.Default or ""
					InputBox.PlaceholderText = InputFunctions.Settings.Placeholder or ""

					InputBox:GetPropertyChangedSignal("Text"):Connect(function()
						InputBox.Text = AcceptedCharacters(InputBox.Text)
						if InputFunctions.Settings.onChanged then
							InputFunctions.Settings.onChanged(InputBox.Text)
						end
						InputFunctions.Text = InputBox.Text
					end)

					function InputFunctions:UpdateName(Name)
						inputName.Text = Name
					end
					function InputFunctions:SetVisibility(State)
						input.Visible = State
					end
					function InputFunctions:GetInput()
						return InputBox.Text
					end
					function InputFunctions:UpdatePlaceholder(Placeholder)
						inputBox.PlaceholderText = Placeholder
					end
					function InputFunctions:UpdateText(Text)
						local filteredText = AcceptedCharacters(Text)
						InputBox.Text = filteredText
						InputFunctions.Text = filteredText
						task.spawn(function()
							if InputFunctions.Settings.Callback then
								InputFunctions.Settings.Callback(filteredText)
							end
						end)
					end

					if Flag then
						MacLib.Options[Flag] = InputFunctions
					end
					return InputFunctions
				end

				function SectionFunctions:Keybind(Settings, Flag)
					local KeybindFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Keybind" }
					local keybind = Instance.new("Frame")
					keybind.Name = "Keybind"
					keybind.AutomaticSize = Enum.AutomaticSize.Y
					keybind.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					keybind.BackgroundTransparency = 1
					keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
					keybind.BorderSizePixel = 0
					keybind.Size = UDim2.new(1, 0, 0, 38)
					keybind.Parent = section

					local keybindName = Instance.new("TextLabel")
					keybindName.Name = "KeybindName"
					keybindName.FontFace = Font.new(assets.interFont)
					keybindName.Text = KeybindFunctions.Settings.Name
					keybindName.RichText = true
					keybindName.TextColor3 = Color3.fromRGB(255, 255, 255)
					keybindName.TextSize = 13
					keybindName.TextTransparency = 0.5
					keybindName.TextTruncate = Enum.TextTruncate.AtEnd
					keybindName.TextXAlignment = Enum.TextXAlignment.Left
					keybindName.TextYAlignment = Enum.TextYAlignment.Top
					keybindName.AnchorPoint = Vector2.new(0, 0.5)
					keybindName.AutomaticSize = Enum.AutomaticSize.XY
					keybindName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					keybindName.BackgroundTransparency = 1
					keybindName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					keybindName.BorderSizePixel = 0
					keybindName.Position = UDim2.fromScale(0, 0.5)
					keybindName.Parent = keybind

					local binderBox = Instance.new("TextBox")
					binderBox.Name = "BinderBox"
					binderBox.CursorPosition = -1
					binderBox.FontFace = Font.new(assets.interFont)
					binderBox.PlaceholderText = "..."
					binderBox.Text = ""
					binderBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					binderBox.TextSize = 12
					binderBox.TextTransparency = 0.1
					binderBox.AnchorPoint = Vector2.new(1, 0.5)
					binderBox.AutomaticSize = Enum.AutomaticSize.X
					binderBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					binderBox.BackgroundTransparency = 0.95
					binderBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					binderBox.BorderSizePixel = 0
					binderBox.ClipsDescendants = true
					binderBox.LayoutOrder = 1
					binderBox.Position = UDim2.fromScale(1, 0.5)
					binderBox.Size = UDim2.fromOffset(21, 21)

					local binderBoxUICorner = Instance.new("UICorner")
					binderBoxUICorner.Name = "BinderBoxUICorner"
					binderBoxUICorner.CornerRadius = UDim.new(0, 4)
					binderBoxUICorner.Parent = binderBox

					local binderBoxUIStroke = Instance.new("UIStroke")
					binderBoxUIStroke.Name = "BinderBoxUIStroke"
					binderBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					binderBoxUIStroke.Color = Color3.fromRGB(255, 255, 255)
					binderBoxUIStroke.Transparency = 0.9
					binderBoxUIStroke.Parent = binderBox

					local binderBoxUIPadding = Instance.new("UIPadding")
					binderBoxUIPadding.Name = "BinderBoxUIPadding"
					binderBoxUIPadding.PaddingLeft = UDim.new(0, 5)
					binderBoxUIPadding.PaddingRight = UDim.new(0, 5)
					binderBoxUIPadding.Parent = binderBox

					local binderBoxUISizeConstraint = Instance.new("UISizeConstraint")
					binderBoxUISizeConstraint.Name = "BinderBoxUISizeConstraint"
					binderBoxUISizeConstraint.Parent = binderBox

					binderBox.Parent = keybind

					local focused
					local isBinding = false
					local reset = false
					local binded = KeybindFunctions.Settings.Default

					local function resetFocusState()
						focused = false
						isBinding = false
						binderBox:ReleaseFocus()
					end

					if binded then
						binderBox.Text = binded.Name
					end

					binderBox.Focused:Connect(function()
						focused = true
					end)

					binderBox.FocusLost:Connect(function()
						focused = false
					end)

					UserInputService.InputBegan:Connect(function(inp)
						if focused and not isBinding then
							isBinding = true

							local Event
							Event = UserInputService.InputBegan:Connect(function(input)
								if KeybindFunctions.Settings.Blacklist and (table.find(KeybindFunctions.KeybindFunctions.Settings.Blacklist, input.KeyCode) or table.find(KeybindFunctions.Settings.Blacklist, input.UserInputType)) then
									binderBox:ReleaseFocus()
									resetFocusState()
									Event:Disconnect()
									return
								end

								if input.UserInputType == Enum.UserInputType.Keyboard then
									binded = input.KeyCode
									binderBox.Text = input.KeyCode.Name
								elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
									binded = input.UserInputType
									binderBox.Text = input.UserInputType.Name
								end

								if KeybindFunctions.Settings.onBinded then
									KeybindFunctions.Settings.onBinded(binded)
								end
								reset = true
								resetFocusState()
								Event:Disconnect()
							end)
						else
							if not reset and (inp.KeyCode == binded or inp.UserInputType == binded) then
								if KeybindFunctions.Settings.Callback then
									KeybindFunctions.Settings.Callback(binded)
								end
								if KeybindFunctions.Settings.onBindHeld then
									KeybindFunctions.Settings.onBindHeld(true, binded)
								end
							else
								reset = false
							end
						end
					end)

					UserInputService.InputEnded:Connect(function(inp)
						if not focused and not isBinding then
							if inp.KeyCode == binded or inp.UserInputType == binded then
								if Settings.onBindHeld then
									Settings.onBindHeld(false, binded)
								end
							end
						end
					end)

					function KeybindFunctions:Bind(Key)
						binded = Key
						binderBox.Text = Key.Name
					end

					function KeybindFunctions:Unbind()
						binded = nil
						binderBox.Text = ""
					end

					function KeybindFunctions:GetBind()
						return binded
					end

					function KeybindFunctions:UpdateName(Name)
						keybindName = Name
					end

					function KeybindFunctions:SetVisibility(State)
						keybind.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = KeybindFunctions
					end

					return KeybindFunctions
				end

				function SectionFunctions:Dropdown(Settings, Flag)
					local DropdownFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Dropdown" }
					local Selected = {}
					local OptionObjs = {}

					local dropdown = Instance.new("Frame")
					dropdown.Name = "Dropdown"
					dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdown.BackgroundTransparency = 0.985
					dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdown.BorderSizePixel = 0
					dropdown.Size = UDim2.new(1, 0, 0, 38)
					dropdown.Parent = section
					dropdown.ClipsDescendants = true

					local dropdownUIPadding = Instance.new("UIPadding")
					dropdownUIPadding.Name = "DropdownUIPadding"
					dropdownUIPadding.PaddingLeft = UDim.new(0, 15)
					dropdownUIPadding.PaddingRight = UDim.new(0, 15)
					dropdownUIPadding.Parent = dropdown

					local interact = Instance.new("TextButton")
					interact.Name = "Interact"
					interact.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					interact.Text = ""
					interact.TextColor3 = Color3.fromRGB(0, 0, 0)
					interact.TextSize = 14
					interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					interact.BackgroundTransparency = 1
					interact.BorderColor3 = Color3.fromRGB(0, 0, 0)
					interact.BorderSizePixel = 0
					interact.Size = UDim2.new(1, 0, 0, 38)
					interact.Parent = dropdown

					local dropdownName = Instance.new("TextLabel")
					dropdownName.Name = "DropdownName"
					dropdownName.FontFace = Font.new(assets.interFont)
					dropdownName.Text = Settings.Default and (DropdownFunctions.Settings.Name .. " • " .. table.concat(Selected, ", ")) or (DropdownFunctions.Settings.Name .. "...")
					dropdownName.RichText = true
					dropdownName.TextColor3 = Color3.fromRGB(255, 255, 255)
					dropdownName.TextSize = 13
					dropdownName.TextTransparency = 0.5
					dropdownName.TextTruncate = Enum.TextTruncate.SplitWord
					dropdownName.TextXAlignment = Enum.TextXAlignment.Left
					dropdownName.AutomaticSize = Enum.AutomaticSize.Y
					dropdownName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownName.BackgroundTransparency = 1
					dropdownName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownName.BorderSizePixel = 0
					dropdownName.Size = UDim2.new(1, -20, 0, 38)
					dropdownName.Parent = dropdown

					local dropdownUIStroke = Instance.new("UIStroke")
					dropdownUIStroke.Name = "DropdownUIStroke"
					dropdownUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					dropdownUIStroke.Color = Color3.fromRGB(255, 255, 255)
					dropdownUIStroke.Transparency = 0.95
					dropdownUIStroke.Parent = dropdown

					local dropdownUICorner = Instance.new("UICorner")
					dropdownUICorner.Name = "DropdownUICorner"
					dropdownUICorner.CornerRadius = UDim.new(0, 6)
					dropdownUICorner.Parent = dropdown

					local dropdownImage = Instance.new("ImageLabel")
					dropdownImage.Name = "DropdownImage"
					dropdownImage.Image = assets.dropdown
					dropdownImage.ImageTransparency = 0.5
					dropdownImage.AnchorPoint = Vector2.new(1, 0)
					dropdownImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownImage.BackgroundTransparency = 1
					dropdownImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownImage.BorderSizePixel = 0
					dropdownImage.Position = UDim2.new(1, 0, 0, 12)
					dropdownImage.Size = UDim2.fromOffset(14, 14)
					dropdownImage.Parent = dropdown

					local dropdownFrame = Instance.new("Frame")
					dropdownFrame.Name = "DropdownFrame"
					dropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownFrame.BackgroundTransparency = 1
					dropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownFrame.BorderSizePixel = 0
					dropdownFrame.ClipsDescendants = true
					dropdownFrame.Size = UDim2.fromScale(1, 1)
					dropdownFrame.Visible = false
					dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y

					local dropdownFrameUIPadding = Instance.new("UIPadding")
					dropdownFrameUIPadding.Name = "DropdownFrameUIPadding"
					dropdownFrameUIPadding.PaddingTop = UDim.new(0, 38)
					dropdownFrameUIPadding.PaddingBottom = UDim.new(0, 10)
					dropdownFrameUIPadding.Parent = dropdownFrame

					local dropdownFrameUIListLayout = Instance.new("UIListLayout")
					dropdownFrameUIListLayout.Name = "DropdownFrameUIListLayout"
					dropdownFrameUIListLayout.Padding = UDim.new(0, 5)
					dropdownFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					dropdownFrameUIListLayout.Parent = dropdownFrame

					local search = Instance.new("Frame")
					search.Name = "Search"
					search.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					search.BackgroundTransparency = 0.95
					search.BorderColor3 = Color3.fromRGB(0, 0, 0)
					search.BorderSizePixel = 0
					search.LayoutOrder = -1
					search.Size = UDim2.new(1, 0, 0, 30)
					search.Parent = dropdownFrame
					search.Visible = DropdownFunctions.Settings.Search

					local sectionUICorner = Instance.new("UICorner")
					sectionUICorner.Name = "SectionUICorner"
					sectionUICorner.Parent = search

					local searchIcon = Instance.new("ImageLabel")
					searchIcon.Name = "SearchIcon"
					searchIcon.Image = assets.searchIcon
					searchIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
					searchIcon.AnchorPoint = Vector2.new(0, 0.5)
					searchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					searchIcon.BackgroundTransparency = 1
					searchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
					searchIcon.BorderSizePixel = 0
					searchIcon.Position = UDim2.fromScale(0, 0.5)
					searchIcon.Size = UDim2.fromOffset(12, 12)
					searchIcon.Parent = search

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingLeft = UDim.new(0, 15)
					uIPadding.Parent = search

					local searchBox = Instance.new("TextBox")
					searchBox.Name = "SearchBox"
					searchBox.CursorPosition = -1
					searchBox.FontFace = Font.new(
						assets.interFont,
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
					searchBox.PlaceholderText = "Search..."
					searchBox.Text = ""
					searchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
					searchBox.TextSize = 14
					searchBox.TextXAlignment = Enum.TextXAlignment.Left
					searchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					searchBox.BackgroundTransparency = 1
					searchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					searchBox.BorderSizePixel = 0
					searchBox.Size = UDim2.fromScale(1, 1)

					local function CalculateDropdownSize()
						local totalHeight = 0
						local visibleChildrenCount = 0
						local padding = dropdownFrameUIPadding.PaddingTop.Offset + dropdownFrameUIPadding.PaddingBottom.Offset

						for _, v in pairs(dropdownFrame:GetChildren()) do
							if not v:IsA("UIComponent") and v.Visible then
								totalHeight += v.AbsoluteSize.Y
								visibleChildrenCount += 1
							end
						end

						local spacing = dropdownFrameUIListLayout.Padding.Offset * (visibleChildrenCount - 1)

						return totalHeight + spacing + padding
					end

					local function findOption()
						local searchTerm = searchBox.Text:lower()

						for _, v in pairs(OptionObjs) do
							local optionText = v.NameLabel.Text:lower()
							local isVisible = string.find(optionText, searchTerm) ~= nil

							if v.Button.Visible ~= isVisible then
								v.Button.Visible = isVisible
							end
						end

						dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
					end

					searchBox:GetPropertyChangedSignal("Text"):Connect(findOption)

					local uIPadding1 = Instance.new("UIPadding")
					uIPadding1.Name = "UIPadding"
					uIPadding1.PaddingLeft = UDim.new(0, 23)
					uIPadding1.Parent = searchBox

					searchBox.Parent = search

					local tweensettings = {
						duration = 0.2,
						easingStyle = Enum.EasingStyle.Quint,
						transparencyIn = 0.2,
						transparencyOut = 0.5,
						checkSizeIncrease = 12,
						checkSizeDecrease = -13,
						waitTime = 1
					}

					local function Toggle(optionName, State)
						local option = OptionObjs[optionName]

						if not option then return end

						local checkmark = option.Checkmark
						local optionNameLabel = option.NameLabel

						if State then
							if DropdownFunctions.Settings.Multi then
								if not table.find(Selected, optionName) then
									table.insert(Selected, optionName)
									DropdownFunctions.Value = Selected
								end
							else
								for name, opt in pairs(OptionObjs) do
									if name ~= optionName then
										Tween(opt.Checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
											Size = UDim2.new(opt.Checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, opt.Checkmark.Size.Y.Scale, opt.Checkmark.Size.Y.Offset)
										}):Play()
										Tween(opt.NameLabel, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
											TextTransparency = tweensettings.transparencyOut
										}):Play()
										opt.Checkmark.TextTransparency = 1
									end
								end
								Selected = {optionName}
								DropdownFunctions.Value = Selected[1]
							end
							Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}):Play()
							Tween(optionNameLabel, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								TextTransparency = tweensettings.transparencyIn
							}):Play()
							checkmark.TextTransparency = 0
						else
							if DropdownFunctions.Settings.Multi then
								local idx = table.find(Selected, optionName)
								if idx then
									table.remove(Selected, idx)
								end
							else
								Selected = {}
							end
							Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}):Play()
							Tween(optionNameLabel, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								TextTransparency = tweensettings.transparencyOut
							}):Play()
							checkmark.TextTransparency = 1
						end

						if Settings.Required and #Selected == 0 and not State then
							return
						end

						if #Selected > 0 then
							dropdownName.Text = DropdownFunctions.Settings.Name .. " • " .. table.concat(Selected, ", ")
						else
							dropdownName.Text = DropdownFunctions.Settings.Name .. "..."
						end
					end

					local dropped = false
					local db = false

					local function ToggleDropdown()
						if db then return end
						db = true
						local defaultDropdownSize = 38
						local isDropdownOpen = not dropped
						local targetSize = isDropdownOpen and UDim2.new(1, 0, 0, CalculateDropdownSize()) or UDim2.new(1, 0, 0, defaultDropdownSize)

						local dropTween = Tween(dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
							Size = targetSize
						})
						local iconTween = Tween(dropdownImage, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Rotation = isDropdownOpen and -90 or 0
						})

						dropTween:Play()
						iconTween:Play()

						if isDropdownOpen then
							dropdownFrame.Visible = true
							dropTween.Completed:Connect(function()
								db = false
							end)
						else
							dropTween.Completed:Connect(function()
								dropdownFrame.Visible = false
								db = false
							end)
						end

						dropped = isDropdownOpen
					end

					interact.MouseButton1Click:Connect(ToggleDropdown)

					local function addOption(i, v)
						local option = Instance.new("TextButton")
						option.Name = "Option"
						option.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
						option.Text = ""
						option.TextColor3 = Color3.fromRGB(0, 0, 0)
						option.TextSize = 14
						option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						option.BackgroundTransparency = 1
						option.BorderColor3 = Color3.fromRGB(0, 0, 0)
						option.BorderSizePixel = 0
						option.Size = UDim2.new(1, 0, 0, 30)

						local optionUIPadding = Instance.new("UIPadding")
						optionUIPadding.Name = "OptionUIPadding"
						optionUIPadding.PaddingLeft = UDim.new(0, 15)
						optionUIPadding.Parent = option

						local optionName = Instance.new("TextLabel")
						optionName.Name = "OptionName"
						optionName.FontFace = Font.new(assets.interFont)
						optionName.Text = v
						optionName.RichText = true
						optionName.TextColor3 = Color3.fromRGB(255, 255, 255)
						optionName.TextSize = 13
						optionName.TextTransparency = 0.5
						optionName.TextTruncate = Enum.TextTruncate.AtEnd
						optionName.TextXAlignment = Enum.TextXAlignment.Left
						optionName.TextYAlignment = Enum.TextYAlignment.Top
						optionName.AnchorPoint = Vector2.new(0, 0.5)
						optionName.AutomaticSize = Enum.AutomaticSize.XY
						optionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						optionName.BackgroundTransparency = 1
						optionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
						optionName.BorderSizePixel = 0
						optionName.Position = UDim2.fromScale(1.3e-07, 0.5)
						optionName.Parent = option

						local optionUIListLayout = Instance.new("UIListLayout")
						optionUIListLayout.Name = "OptionUIListLayout"
						optionUIListLayout.Padding = UDim.new(0, 10)
						optionUIListLayout.FillDirection = Enum.FillDirection.Horizontal
						optionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
						optionUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
						optionUIListLayout.Parent = option

						local checkmark = Instance.new("TextLabel")
						checkmark.Name = "Checkmark"
						checkmark.FontFace = Font.new(assets.interFont)
						checkmark.Text = "✓"
						checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
						checkmark.TextSize = 13
						checkmark.TextTransparency = 1
						checkmark.TextXAlignment = Enum.TextXAlignment.Left
						checkmark.TextYAlignment = Enum.TextYAlignment.Top
						checkmark.AnchorPoint = Vector2.new(0, 0.5)
						checkmark.AutomaticSize = Enum.AutomaticSize.Y
						checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						checkmark.BackgroundTransparency = 1
						checkmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
						checkmark.BorderSizePixel = 0
						checkmark.LayoutOrder = -1
						checkmark.Position = UDim2.fromScale(1.3e-07, 0.5)
						checkmark.Size = UDim2.fromOffset(-10, 0)
						checkmark.Parent = option

						option.Parent = dropdownFrame

						dropdownFrame.Parent = dropdown
						OptionObjs[v] = {
							Index = i,
							Button = option,
							NameLabel = optionName,
							Checkmark = checkmark
						}

						local tweensettings = {
							duration = 0.2,
							easingStyle = Enum.EasingStyle.Quint,
							transparencyIn = 0.2,
							transparencyOut = 0.5,
							checkSizeIncrease = 12,
							checkSizeDecrease = -optionUIListLayout.Padding.Offset,
							waitTime = 1
						}
						local tweens = {
							checkIn = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}),
							checkOut = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}),
							nameIn = Tween(optionName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
								TextTransparency = tweensettings.transparencyIn
							}),
							nameOut = Tween(optionName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
								TextTransparency = tweensettings.transparencyOut
							})
						}

						local isSelected = false
						if DropdownFunctions.Settings.Default then
							if DropdownFunctions.Settings.Multi then
								isSelected = table.find(DropdownFunctions.Settings.Default, v) and true or false
							else
								isSelected = (DropdownFunctions.Settings.Default == i) and true or false
							end
						end
						Toggle(v, isSelected)

						local option = OptionObjs[v].Button

						option.MouseButton1Click:Connect(function()
							local isSelected = table.find(Selected, v) and true or false
							local newSelected = not isSelected

							if DropdownFunctions.Settings.Required and not newSelected and #Selected <= 1 then
								return
							end

							Toggle(v, newSelected)

							task.spawn(function()
								if DropdownFunctions.Settings.Multi then
									local Return = {}
									for _, opt in ipairs(Selected) do
										Return[opt] = true
									end
									if DropdownFunctions.Settings.Callback then
										DropdownFunctions.Settings.Callback(Return)
									end

								else
									if newSelected and DropdownFunctions.Settings.Callback then
										DropdownFunctions.Settings.Callback(Selected[1] or nil)
									end
								end
							end)
						end)

						if dropped then
							dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
						end
					end

					if DropdownFunctions.Settings.Options then
						for i, v in pairs(DropdownFunctions.Settings.Options) do
							addOption(i, v)
						end
					end

					function DropdownFunctions:UpdateName(New)
						dropdownName.Text = New
					end
					function DropdownFunctions:SetVisibility(State)
						dropdown.Visible = State
					end
					function DropdownFunctions:UpdateSelection(newSelection)
						if not newSelection then return end

						for option, _ in pairs(OptionObjs) do
							Toggle(option, false)
						end

						local selectedOptions = {}
						if type(newSelection) == "number" then
							for option, data in pairs(OptionObjs) do
								local isSelected = data.Index == newSelection
								Toggle(option, isSelected)
								if isSelected then
									table.insert(selectedOptions, option)
								end
							end
						elseif type(newSelection) == "string" then
							for option, data in pairs(OptionObjs) do
								local isSelected = option == newSelection
								Toggle(option, isSelected)
								if isSelected then
									table.insert(selectedOptions, option)
								end
							end
						elseif type(newSelection) == "table" then
							for option, _ in pairs(OptionObjs) do
								local isSelected = table.find(newSelection, option) ~= nil
								Toggle(option, isSelected)
								if isSelected then
									table.insert(selectedOptions, option)
								end
							end
						end

						if DropdownFunctions.Settings.Callback then
							if DropdownFunctions.Settings.Multi then
								local Return = {}
								for _, opt in ipairs(selectedOptions) do
									Return[opt] = true
								end
								DropdownFunctions.Settings.Callback(Return)
							else
								DropdownFunctions.Settings.Callback(selectedOptions[1] or nil)
							end
						end
					end
					function DropdownFunctions:InsertOptions(newOptions)
						if not newOptions then return end
						DropdownFunctions.Settings.Options = newOptions
						for i, v in pairs(newOptions) do
							addOption(i, v)
						end
					end
					function DropdownFunctions:ClearOptions()
						for _, optionData in pairs(OptionObjs) do
							optionData.Button:Destroy()
						end
						OptionObjs = {}
						Selected = {}

						if dropped then
							dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
						end
					end
					function DropdownFunctions:GetOptions()
						local optionsStatus = {}

						for option, data in pairs(OptionObjs) do
							local isSelected = table.find(Selected, option) and true or false
							optionsStatus[option] = isSelected
						end

						return optionsStatus
					end

					function DropdownFunctions:RemoveOptions(remove)
						if not remove then return end
						for _, optionName in ipairs(remove) do
							local optionData = OptionObjs[optionName]

							if optionData then
								for i = #Selected, 1, -1 do
									if Selected[i] == optionName then
										table.remove(Selected, i)
									end
								end

								optionData.Button:Destroy()

								OptionObjs[optionName] = nil
							end
						end

						if dropped then
							dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
						end
					end
					function DropdownFunctions:IsOption(optionName)
						if not optionName then return end
						return OptionObjs[optionName] ~= nil
					end

					if Flag then
						MacLib.Options[Flag] = DropdownFunctions
					end

					return DropdownFunctions
				end

				function SectionFunctions:Colorpicker(Settings, Flag)
					local ColorpickerFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Colorpicker" }

					local isAlpha = ColorpickerFunctions.Settings.Alpha and true or false
					ColorpickerFunctions.Color = ColorpickerFunctions.Settings.Default
					ColorpickerFunctions.Alpha = isAlpha and ColorpickerFunctions.Settings.Alpha

					local colorpicker = Instance.new("Frame")
					colorpicker.Name = "Colorpicker"
					colorpicker.AutomaticSize = Enum.AutomaticSize.Y
					colorpicker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					colorpicker.BackgroundTransparency = 1
					colorpicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorpicker.BorderSizePixel = 0
					colorpicker.Size = UDim2.new(1, 0, 0, 38)
					colorpicker.Parent = section

					local colorpickerName = Instance.new("TextLabel")
					colorpickerName.Name = "KeybindName"
					colorpickerName.FontFace = Font.new(assets.interFont)
					colorpickerName.Text = Settings.Name
					colorpickerName.TextColor3 = Color3.fromRGB(255, 255, 255)
					colorpickerName.TextSize = 13
					colorpickerName.TextTransparency = 0.5
					colorpickerName.RichText = true
					colorpickerName.TextTruncate = Enum.TextTruncate.AtEnd
					colorpickerName.TextXAlignment = Enum.TextXAlignment.Left
					colorpickerName.TextYAlignment = Enum.TextYAlignment.Top
					colorpickerName.AnchorPoint = Vector2.new(0, 0.5)
					colorpickerName.AutomaticSize = Enum.AutomaticSize.XY
					colorpickerName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					colorpickerName.BackgroundTransparency = 1
					colorpickerName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorpickerName.BorderSizePixel = 0
					colorpickerName.Position = UDim2.fromScale(0, 0.5)
					colorpickerName.Parent = colorpicker

					local colorCbg = Instance.new("ImageLabel")
					colorCbg.Name = "NewColor"
					colorCbg.Image = assets.grid
					colorCbg.ScaleType = Enum.ScaleType.Tile
					colorCbg.TileSize = UDim2.fromOffset(500, 500)
					colorCbg.AnchorPoint = Vector2.new(1, 0.5)
					colorCbg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					colorCbg.BackgroundTransparency = 1
					colorCbg.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorCbg.BorderSizePixel = 0
					colorCbg.Position = UDim2.fromScale(1, 0.5)
					colorCbg.Size = UDim2.fromOffset(21, 21)

					local colorC = Instance.new("Frame")
					colorC.Name = "Color"
					colorC.AnchorPoint = Vector2.new(0.5, 0.5)
					colorC.BackgroundColor3 = ColorpickerFunctions.Color
					colorC.BorderSizePixel = 0
					colorC.Position = UDim2.fromScale(0.5, 0.5)
					colorC.Size = UDim2.fromScale(1, 1)
					colorC.BackgroundTransparency = ColorpickerFunctions.Alpha or 0

					local uICorner = Instance.new("UICorner")
					uICorner.Name = "UICorner"
					uICorner.CornerRadius = UDim.new(0, 6)
					uICorner.Parent = colorC

					local interact = Instance.new("TextButton")
					interact.Name = "Interact"
					interact.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					interact.Text = ""
					interact.TextColor3 = Color3.fromRGB(0, 0, 0)
					interact.TextSize = 14
					interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					interact.BackgroundTransparency = 1
					interact.BorderColor3 = Color3.fromRGB(0, 0, 0)
					interact.BorderSizePixel = 0
					interact.Size = UDim2.fromScale(1, 1)
					interact.Parent = colorC

					colorC.Parent = colorCbg

					local uICorner1 = Instance.new("UICorner")
					uICorner1.Name = "UICorner"
					uICorner1.CornerRadius = UDim.new(0, 8)
					uICorner1.Parent = colorCbg

					colorCbg.Parent = colorpicker

					local colorPicker = Instance.new("Frame")
					colorPicker.Name = "ColorPicker"
					colorPicker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					colorPicker.BackgroundTransparency = 0.5
					colorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorPicker.BorderSizePixel = 0
					colorPicker.Size = UDim2.fromScale(1, 1)
					colorPicker.Visible = false

					local baseUICorner = Instance.new("UICorner")
					baseUICorner.Name = "BaseUICorner"
					baseUICorner.CornerRadius = UDim.new(0, 10)
					baseUICorner.Parent = colorPicker

					local prompt = Instance.new("Frame")
					prompt.Name = "Prompt"
					prompt.AnchorPoint = Vector2.new(0.5, 0.5)
					prompt.AutomaticSize = Enum.AutomaticSize.Y
					prompt.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
					prompt.BorderColor3 = Color3.fromRGB(0, 0, 0)
					prompt.BorderSizePixel = 0
					prompt.Position = UDim2.fromScale(0.5, 0.5)
					prompt.Size = UDim2.fromOffset(420, 0)

					local promptUIScale = Instance.new("UIScale")
					promptUIScale.Name = "BaseUIScale"
					promptUIScale.Parent = prompt
					promptUIScale.Scale = 0.95

					local globalSettingsUIStroke = Instance.new("UIStroke")
					globalSettingsUIStroke.Name = "GlobalSettingsUIStroke"
					globalSettingsUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					globalSettingsUIStroke.Color = Color3.fromRGB(255, 255, 255)
					globalSettingsUIStroke.Transparency = 0.9
					globalSettingsUIStroke.Parent = prompt

					local globalSettingsUICorner = Instance.new("UICorner")
					globalSettingsUICorner.Name = "GlobalSettingsUICorner"
					globalSettingsUICorner.CornerRadius = UDim.new(0, 10)
					globalSettingsUICorner.Parent = prompt

					local uIListLayout = Instance.new("UIListLayout")
					uIListLayout.Name = "UIListLayout"
					uIListLayout.Padding = UDim.new(0, 10)
					uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
					uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout.Parent = prompt

					local colorOptions = Instance.new("Frame")
					colorOptions.Name = "ColorOptions"
					colorOptions.AutomaticSize = Enum.AutomaticSize.XY
					colorOptions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					colorOptions.BackgroundTransparency = 1
					colorOptions.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorOptions.BorderSizePixel = 0
					colorOptions.LayoutOrder = 1
					colorOptions.Size = UDim2.fromScale(1, 0)

					local value = Instance.new("TextButton")
					value.Name = "Value"
					value.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					value.Text = ""
					value.TextColor3 = Color3.fromRGB(0, 0, 0)
					value.TextSize = 14
					value.AutoButtonColor = false
					value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					value.BorderColor3 = Color3.fromRGB(0, 0, 0)
					value.BorderSizePixel = 0
					value.LayoutOrder = 1
					value.Position = UDim2.fromScale(0.092, 0.886)
					value.Size = UDim2.new(1, 0, 0, 15)

					local uIGradient = Instance.new("UIGradient")
					uIGradient.Name = "UIGradient"
					uIGradient.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
					})
					uIGradient.Parent = value

					local slide = Instance.new("Frame")
					slide.Name = "Slide"
					slide.AnchorPoint = Vector2.new(0, 0.5)
					slide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					slide.BorderColor3 = Color3.fromRGB(27, 42, 53)
					slide.BorderSizePixel = 0
					slide.Position = UDim2.fromScale(0, 0.5)
					slide.Size = UDim2.new(0, 13, 1, 8)

					local uICorner = Instance.new("UICorner")
					uICorner.Name = "UICorner"
					uICorner.CornerRadius = UDim.new(1, 0)
					uICorner.Parent = slide

					local uIStroke = Instance.new("UIStroke")
					uIStroke.Name = "UIStroke"
					uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					uIStroke.Transparency = 0.5
					uIStroke.Parent = slide

					slide.Parent = value

					local uICorner1 = Instance.new("UICorner")
					uICorner1.Name = "UICorner"
					uICorner1.CornerRadius = UDim.new(0, 6)
					uICorner1.Parent = value

					local uIStroke1 = Instance.new("UIStroke")
					uIStroke1.Name = "UIStroke"
					uIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					uIStroke1.Color = Color3.fromRGB(255, 255, 255)
					uIStroke1.Transparency = 0.9

					local uIGradient1 = Instance.new("UIGradient")
					uIGradient1.Name = "UIGradient"
					uIGradient1.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
					})
					uIGradient1.Rotation = 180
					uIGradient1.Parent = uIStroke1

					uIStroke1.Parent = value

					value.Parent = colorOptions

					local uIListLayout1 = Instance.new("UIListLayout")
					uIListLayout1.Name = "UIListLayout"
					uIListLayout1.Padding = UDim.new(0, 25)
					uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout1.Parent = colorOptions

					local wheel = Instance.new("Frame")
					wheel.Name = "Wheel"
					wheel.AutomaticSize = Enum.AutomaticSize.Y
					wheel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					wheel.BackgroundTransparency = 1
					wheel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					wheel.BorderSizePixel = 0
					wheel.Size = UDim2.new(1, 0, 0, 100)

					local wheel1 = Instance.new("ImageButton")
					wheel1.Name = "Wheel"
					wheel1.Image = assets.colorWheel
					wheel1.AutoButtonColor = false
					wheel1.Active = false
					wheel1.BackgroundColor3 = Color3.fromRGB(248, 248, 248)
					wheel1.BackgroundTransparency = 1
					wheel1.BorderColor3 = Color3.fromRGB(27, 42, 53)
					wheel1.Selectable = false
					wheel1.Size = UDim2.fromOffset(220, 220)
					wheel1.SizeConstraint = Enum.SizeConstraint.RelativeYY

					local target = Instance.new("ImageLabel")
					target.Name = "Target"
					target.Image = assets.colorTarget
					target.ImageColor3 = Color3.fromRGB(0, 0, 0)
					target.AnchorPoint = Vector2.new(0.5, 0.5)
					target.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					target.BackgroundTransparency = 1
					target.BorderColor3 = Color3.fromRGB(27, 42, 53)
					target.Position = UDim2.fromScale(0.5, 0.5)
					target.Size = UDim2.fromOffset(22, 22)
					target.SizeConstraint = Enum.SizeConstraint.RelativeYY
					target.Parent = wheel1

					wheel1.Parent = wheel

					local inputs = Instance.new("Frame")
					inputs.Name = "Inputs"
					inputs.AnchorPoint = Vector2.new(1, 0.5)
					inputs.AutomaticSize = Enum.AutomaticSize.XY
					inputs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputs.BackgroundTransparency = 1
					inputs.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputs.BorderSizePixel = 0
					inputs.LayoutOrder = 1
					inputs.Position = UDim2.fromScale(1, 0.5)

					local uIListLayout2 = Instance.new("UIListLayout")
					uIListLayout2.Name = "UIListLayout"
					uIListLayout2.Padding = UDim.new(0, 5)
					uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout2.Parent = inputs

					local red = Instance.new("Frame")
					red.Name = "Red"
					red.AutomaticSize = Enum.AutomaticSize.XY
					red.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					red.BackgroundTransparency = 1
					red.BorderColor3 = Color3.fromRGB(0, 0, 0)
					red.BorderSizePixel = 0
					red.LayoutOrder = 1
					red.Size = UDim2.fromOffset(0, 38)

					local inputName = Instance.new("TextLabel")
					inputName.Name = "InputName"
					inputName.FontFace = Font.new(assets.interFont)
					inputName.Text = "Red"
					inputName.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName.TextSize = 13
					inputName.TextTransparency = 0.5
					inputName.TextTruncate = Enum.TextTruncate.AtEnd
					inputName.TextXAlignment = Enum.TextXAlignment.Left
					inputName.TextYAlignment = Enum.TextYAlignment.Top
					inputName.AnchorPoint = Vector2.new(0, 0.5)
					inputName.AutomaticSize = Enum.AutomaticSize.XY
					inputName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName.BackgroundTransparency = 1
					inputName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName.BorderSizePixel = 0
					inputName.LayoutOrder = 2
					inputName.Position = UDim2.fromScale(0, 0.5)
					inputName.Parent = red

					local uIListLayout3 = Instance.new("UIListLayout")
					uIListLayout3.Name = "UIListLayout"
					uIListLayout3.Padding = UDim.new(0, 15)
					uIListLayout3.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout3.Parent = red

					local inputBox = Instance.new("TextBox")
					inputBox.Name = "InputBox"
					inputBox.ClearTextOnFocus = false
					inputBox.CursorPosition = -1
					inputBox.FontFace = Font.new(assets.interFont)
					inputBox.Text = "255"
					inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.TextSize = 12
					inputBox.TextTransparency = 0.1
					inputBox.TextXAlignment = Enum.TextXAlignment.Left
					inputBox.AnchorPoint = Vector2.new(1, 0.5)
					inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.BackgroundTransparency = 0.95
					inputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox.BorderSizePixel = 0
					inputBox.ClipsDescendants = true
					inputBox.LayoutOrder = 1
					inputBox.Position = UDim2.fromScale(1, 0.5)
					inputBox.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner = Instance.new("UICorner")
					inputBoxUICorner.Name = "InputBoxUICorner"
					inputBoxUICorner.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner.Parent = inputBox

					local inputBoxUIStroke = Instance.new("UIStroke")
					inputBoxUIStroke.Name = "InputBoxUIStroke"
					inputBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke.Transparency = 0.9
					inputBoxUIStroke.Parent = inputBox

					local inputBoxUISizeConstraint = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint.Parent = inputBox

					local inputBoxUIPadding = Instance.new("UIPadding")
					inputBoxUIPadding.Name = "InputBoxUIPadding"
					inputBoxUIPadding.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding.Parent = inputBox

					inputBox.Parent = red

					red.Parent = inputs

					local green = Instance.new("Frame")
					green.Name = "Green"
					green.AutomaticSize = Enum.AutomaticSize.XY
					green.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					green.BackgroundTransparency = 1
					green.BorderColor3 = Color3.fromRGB(0, 0, 0)
					green.BorderSizePixel = 0
					green.LayoutOrder = 2
					green.Size = UDim2.fromOffset(0, 38)

					local inputName1 = Instance.new("TextLabel")
					inputName1.Name = "InputName"
					inputName1.FontFace = Font.new(assets.interFont)
					inputName1.Text = "Green"
					inputName1.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName1.TextSize = 13
					inputName1.TextTransparency = 0.5
					inputName1.TextTruncate = Enum.TextTruncate.AtEnd
					inputName1.TextXAlignment = Enum.TextXAlignment.Left
					inputName1.TextYAlignment = Enum.TextYAlignment.Top
					inputName1.AnchorPoint = Vector2.new(0, 0.5)
					inputName1.AutomaticSize = Enum.AutomaticSize.XY
					inputName1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName1.BackgroundTransparency = 1
					inputName1.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName1.BorderSizePixel = 0
					inputName1.LayoutOrder = 2
					inputName1.Position = UDim2.fromScale(0, 0.5)
					inputName1.Parent = green

					local uIListLayout4 = Instance.new("UIListLayout")
					uIListLayout4.Name = "UIListLayout"
					uIListLayout4.Padding = UDim.new(0, 15)
					uIListLayout4.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout4.Parent = green

					local inputBox1 = Instance.new("TextBox")
					inputBox1.Name = "InputBox"
					inputBox1.ClearTextOnFocus = false
					inputBox1.FontFace = Font.new(assets.interFont)
					inputBox1.Text = "255"
					inputBox1.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox1.TextSize = 12
					inputBox1.TextTransparency = 0.1
					inputBox1.TextXAlignment = Enum.TextXAlignment.Left
					inputBox1.AnchorPoint = Vector2.new(1, 0.5)
					inputBox1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox1.BackgroundTransparency = 0.95
					inputBox1.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox1.BorderSizePixel = 0
					inputBox1.ClipsDescendants = true
					inputBox1.LayoutOrder = 1
					inputBox1.Position = UDim2.fromScale(1, 0.5)
					inputBox1.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner1 = Instance.new("UICorner")
					inputBoxUICorner1.Name = "InputBoxUICorner"
					inputBoxUICorner1.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner1.Parent = inputBox1

					local inputBoxUIStroke1 = Instance.new("UIStroke")
					inputBoxUIStroke1.Name = "InputBoxUIStroke"
					inputBoxUIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke1.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke1.Transparency = 0.9
					inputBoxUIStroke1.Parent = inputBox1

					local inputBoxUISizeConstraint1 = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint1.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint1.Parent = inputBox1

					local inputBoxUIPadding1 = Instance.new("UIPadding")
					inputBoxUIPadding1.Name = "InputBoxUIPadding"
					inputBoxUIPadding1.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding1.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding1.Parent = inputBox1

					inputBox1.Parent = green

					green.Parent = inputs

					local blue = Instance.new("Frame")
					blue.Name = "Blue"
					blue.AutomaticSize = Enum.AutomaticSize.XY
					blue.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					blue.BackgroundTransparency = 1
					blue.BorderColor3 = Color3.fromRGB(0, 0, 0)
					blue.BorderSizePixel = 0
					blue.LayoutOrder = 3
					blue.Size = UDim2.fromOffset(0, 38)

					local inputName2 = Instance.new("TextLabel")
					inputName2.Name = "InputName"
					inputName2.FontFace = Font.new(assets.interFont)
					inputName2.Text = "Blue"
					inputName2.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName2.TextSize = 13
					inputName2.TextTransparency = 0.5
					inputName2.TextTruncate = Enum.TextTruncate.AtEnd
					inputName2.TextXAlignment = Enum.TextXAlignment.Left
					inputName2.TextYAlignment = Enum.TextYAlignment.Top
					inputName2.AnchorPoint = Vector2.new(0, 0.5)
					inputName2.AutomaticSize = Enum.AutomaticSize.XY
					inputName2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName2.BackgroundTransparency = 1
					inputName2.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName2.BorderSizePixel = 0
					inputName2.LayoutOrder = 2
					inputName2.Position = UDim2.fromScale(0, 0.5)
					inputName2.Parent = blue

					local uIListLayout5 = Instance.new("UIListLayout")
					uIListLayout5.Name = "UIListLayout"
					uIListLayout5.Padding = UDim.new(0, 15)
					uIListLayout5.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout5.Parent = blue

					local inputBox2 = Instance.new("TextBox")
					inputBox2.Name = "InputBox"
					inputBox2.ClearTextOnFocus = false
					inputBox2.FontFace = Font.new(assets.interFont)
					inputBox2.Text = "255"
					inputBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox2.TextSize = 12
					inputBox2.TextTransparency = 0.1
					inputBox2.TextXAlignment = Enum.TextXAlignment.Left
					inputBox2.AnchorPoint = Vector2.new(1, 0.5)
					inputBox2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox2.BackgroundTransparency = 0.95
					inputBox2.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox2.BorderSizePixel = 0
					inputBox2.ClipsDescendants = true
					inputBox2.LayoutOrder = 1
					inputBox2.Position = UDim2.fromScale(1, 0.5)
					inputBox2.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner2 = Instance.new("UICorner")
					inputBoxUICorner2.Name = "InputBoxUICorner"
					inputBoxUICorner2.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner2.Parent = inputBox2

					local inputBoxUIStroke2 = Instance.new("UIStroke")
					inputBoxUIStroke2.Name = "InputBoxUIStroke"
					inputBoxUIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke2.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke2.Transparency = 0.9
					inputBoxUIStroke2.Parent = inputBox2

					local inputBoxUISizeConstraint2 = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint2.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint2.Parent = inputBox2

					local inputBoxUIPadding2 = Instance.new("UIPadding")
					inputBoxUIPadding2.Name = "InputBoxUIPadding"
					inputBoxUIPadding2.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding2.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding2.Parent = inputBox2

					inputBox2.Parent = blue

					blue.Parent = inputs

					local alpha = Instance.new("Frame")
					alpha.Name = "Alpha"
					alpha.AutomaticSize = Enum.AutomaticSize.XY
					alpha.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					alpha.BackgroundTransparency = 1
					alpha.BorderColor3 = Color3.fromRGB(0, 0, 0)
					alpha.BorderSizePixel = 0
					alpha.LayoutOrder = 4
					alpha.Size = UDim2.fromOffset(0, 38)
					alpha.Visible = isAlpha

					local inputName3 = Instance.new("TextLabel")
					inputName3.Name = "InputName"
					inputName3.FontFace = Font.new(assets.interFont)
					inputName3.Text = "Alpha"
					inputName3.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName3.TextSize = 13
					inputName3.TextTransparency = 0.5
					inputName3.TextTruncate = Enum.TextTruncate.AtEnd
					inputName3.TextXAlignment = Enum.TextXAlignment.Left
					inputName3.TextYAlignment = Enum.TextYAlignment.Top
					inputName3.AnchorPoint = Vector2.new(0, 0.5)
					inputName3.AutomaticSize = Enum.AutomaticSize.XY
					inputName3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName3.BackgroundTransparency = 1
					inputName3.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName3.BorderSizePixel = 0
					inputName3.LayoutOrder = 2
					inputName3.Position = UDim2.fromScale(0, 0.5)
					inputName3.Parent = alpha

					local uIListLayout6 = Instance.new("UIListLayout")
					uIListLayout6.Name = "UIListLayout"
					uIListLayout6.Padding = UDim.new(0, 15)
					uIListLayout6.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout6.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout6.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout6.Parent = alpha

					local inputBox3 = Instance.new("TextBox")
					inputBox3.Name = "InputBox"
					inputBox3.ClearTextOnFocus = false
					inputBox3.FontFace = Font.new(assets.interFont)
					inputBox3.Text = "0"
					inputBox3.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox3.TextSize = 12
					inputBox3.TextTransparency = 0.1
					inputBox3.TextXAlignment = Enum.TextXAlignment.Left
					inputBox3.AnchorPoint = Vector2.new(1, 0.5)
					inputBox3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox3.BackgroundTransparency = 0.95
					inputBox3.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox3.BorderSizePixel = 0
					inputBox3.ClipsDescendants = true
					inputBox3.LayoutOrder = 1
					inputBox3.Position = UDim2.fromScale(1, 0.5)
					inputBox3.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner3 = Instance.new("UICorner")
					inputBoxUICorner3.Name = "InputBoxUICorner"
					inputBoxUICorner3.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner3.Parent = inputBox3

					local inputBoxUIStroke3 = Instance.new("UIStroke")
					inputBoxUIStroke3.Name = "InputBoxUIStroke"
					inputBoxUIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke3.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke3.Transparency = 0.9
					inputBoxUIStroke3.Parent = inputBox3

					local inputBoxUISizeConstraint3 = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint3.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint3.Parent = inputBox3

					local inputBoxUIPadding3 = Instance.new("UIPadding")
					inputBoxUIPadding3.Name = "InputBoxUIPadding"
					inputBoxUIPadding3.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding3.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding3.Parent = inputBox3

					inputBox3.Parent = alpha

					alpha.Parent = inputs

					local hex = Instance.new("Frame")
					hex.Name = "Hex"
					hex.AutomaticSize = Enum.AutomaticSize.XY
					hex.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					hex.BackgroundTransparency = 1
					hex.BorderColor3 = Color3.fromRGB(0, 0, 0)
					hex.BorderSizePixel = 0
					hex.Size = UDim2.fromOffset(0, 38)

					local inputName4 = Instance.new("TextLabel")
					inputName4.Name = "InputName"
					inputName4.FontFace = Font.new(assets.interFont)
					inputName4.Text = "Hex"
					inputName4.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName4.TextSize = 13
					inputName4.TextTransparency = 0.5
					inputName4.TextTruncate = Enum.TextTruncate.AtEnd
					inputName4.TextXAlignment = Enum.TextXAlignment.Left
					inputName4.TextYAlignment = Enum.TextYAlignment.Top
					inputName4.AnchorPoint = Vector2.new(0, 0.5)
					inputName4.AutomaticSize = Enum.AutomaticSize.XY
					inputName4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName4.BackgroundTransparency = 1
					inputName4.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName4.BorderSizePixel = 0
					inputName4.LayoutOrder = 2
					inputName4.Position = UDim2.fromScale(0, 0.5)
					inputName4.Parent = hex

					local uIListLayout7 = Instance.new("UIListLayout")
					uIListLayout7.Name = "UIListLayout"
					uIListLayout7.Padding = UDim.new(0, 15)
					uIListLayout7.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout7.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout7.Parent = hex

					local inputBox4 = Instance.new("TextBox")
					inputBox4.Name = "InputBox"
					inputBox4.ClearTextOnFocus = false
					inputBox4.CursorPosition = -1
					inputBox4.FontFace = Font.new(assets.interFont)
					inputBox4.Text = "255"
					inputBox4.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox4.TextSize = 12
					inputBox4.TextTransparency = 0.1
					inputBox4.TextXAlignment = Enum.TextXAlignment.Left
					inputBox4.AnchorPoint = Vector2.new(1, 0.5)
					inputBox4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox4.BackgroundTransparency = 0.95
					inputBox4.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox4.BorderSizePixel = 0
					inputBox4.ClipsDescendants = true
					inputBox4.LayoutOrder = 1
					inputBox4.Position = UDim2.fromScale(1, 0.5)
					inputBox4.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner4 = Instance.new("UICorner")
					inputBoxUICorner4.Name = "InputBoxUICorner"
					inputBoxUICorner4.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner4.Parent = inputBox4

					local inputBoxUIStroke4 = Instance.new("UIStroke")
					inputBoxUIStroke4.Name = "InputBoxUIStroke"
					inputBoxUIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke4.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke4.Transparency = 0.9
					inputBoxUIStroke4.Parent = inputBox4

					local inputBoxUISizeConstraint4 = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint4.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint4.Parent = inputBox4

					local inputBoxUIPadding4 = Instance.new("UIPadding")
					inputBoxUIPadding4.Name = "InputBoxUIPadding"
					inputBoxUIPadding4.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding4.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding4.Parent = inputBox4

					inputBox4.Parent = hex

					hex.Parent = inputs

					inputs.Parent = wheel

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingRight = UDim.new(0, 5)
					uIPadding.Parent = wheel

					wheel.Parent = colorOptions

					local colorWells = Instance.new("Frame")
					colorWells.Name = "ColorWells"
					colorWells.AutomaticSize = Enum.AutomaticSize.Y
					colorWells.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					colorWells.BackgroundTransparency = 1
					colorWells.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorWells.BorderSizePixel = 0
					colorWells.LayoutOrder = 2
					colorWells.Size = UDim2.fromScale(1, 0)

					local uIGridLayout = Instance.new("UIGridLayout")
					uIGridLayout.Name = "UIGridLayout"
					uIGridLayout.CellPadding = UDim2.fromOffset(10, 0)
					uIGridLayout.CellSize = UDim2.new(0.5, -5, 0, 30)
					uIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIGridLayout.Parent = colorWells

					local newColor = Instance.new("ImageLabel")
					newColor.Name = "NewColor"
					newColor.Image = assets.grid
					newColor.ScaleType = Enum.ScaleType.Tile
					newColor.TileSize = UDim2.fromOffset(500, 500)
					newColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					newColor.BackgroundTransparency = 1
					newColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
					newColor.BorderSizePixel = 0
					newColor.Size = UDim2.fromOffset(100, 100)

					local uICorner2 = Instance.new("UICorner")
					uICorner2.Name = "UICorner"
					uICorner2.Parent = newColor

					local color = Instance.new("Frame")
					color.Name = "Color"
					color.AnchorPoint = Vector2.new(0.5, 0.5)
					color.BorderColor3 = Color3.fromRGB(27, 42, 53)
					color.BorderSizePixel = 0
					color.Position = UDim2.fromScale(0.5, 0.5)
					color.Size = UDim2.new(1, 1, 1, 1)

					local uICorner3 = Instance.new("UICorner")
					uICorner3.Name = "UICorner"
					uICorner3.Parent = color

					color.Parent = newColor

					newColor.Parent = colorWells

					local oldColor = Instance.new("ImageLabel")
					oldColor.Name = "OldColor"
					oldColor.Image = assets.grid
					oldColor.ScaleType = Enum.ScaleType.Tile
					oldColor.TileSize = UDim2.fromOffset(500, 500)
					oldColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					oldColor.BackgroundTransparency = 1
					oldColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
					oldColor.BorderSizePixel = 0
					oldColor.LayoutOrder = 1
					oldColor.Size = UDim2.fromOffset(100, 100)

					local uICorner4 = Instance.new("UICorner")
					uICorner4.Name = "UICorner"
					uICorner4.Parent = oldColor

					local color1 = Instance.new("Frame")
					color1.Name = "Color"
					color1.AnchorPoint = Vector2.new(0.5, 0.5)
					color1.BorderColor3 = Color3.fromRGB(27, 42, 53)
					color1.BorderSizePixel = 0
					color1.Position = UDim2.fromScale(0.5, 0.5)
					color1.Size = UDim2.new(1, 1, 1, 1)

					local uICorner5 = Instance.new("UICorner")
					uICorner5.Name = "UICorner"
					uICorner5.Parent = color1

					color1.Parent = oldColor

					oldColor.Parent = colorWells

					colorWells.Parent = colorOptions

					colorOptions.Parent = prompt

					local interactions = Instance.new("Frame")
					interactions.Name = "Interactions"
					interactions.AutomaticSize = Enum.AutomaticSize.Y
					interactions.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					interactions.BackgroundTransparency = 1
					interactions.BorderColor3 = Color3.fromRGB(0, 0, 0)
					interactions.BorderSizePixel = 0
					interactions.LayoutOrder = 2
					interactions.Size = UDim2.fromScale(1, 0)

					local uIListLayout8 = Instance.new("UIListLayout")
					uIListLayout8.Name = "UIListLayout"
					uIListLayout8.Padding = UDim.new(0, 10)
					uIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout8.Parent = interactions

					local confirm = Instance.new("TextButton")
					confirm.Name = "Confirm"
					confirm.FontFace = Font.new(
						"rbxassetid://12187365364",
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					confirm.Text = "Confirm"
					confirm.TextColor3 = Color3.fromRGB(255, 255, 255)
					confirm.TextSize = 15
					confirm.TextTransparency = 0.5
					confirm.TextTruncate = Enum.TextTruncate.AtEnd
					confirm.AutoButtonColor = false
					confirm.AutomaticSize = Enum.AutomaticSize.Y
					confirm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					confirm.BorderColor3 = Color3.fromRGB(0, 0, 0)
					confirm.BorderSizePixel = 0
					confirm.Size = UDim2.fromScale(1, 0)

					local uIPadding1 = Instance.new("UIPadding")
					uIPadding1.Name = "UIPadding"
					uIPadding1.PaddingBottom = UDim.new(0, 9)
					uIPadding1.PaddingLeft = UDim.new(0, 10)
					uIPadding1.PaddingRight = UDim.new(0, 10)
					uIPadding1.PaddingTop = UDim.new(0, 9)
					uIPadding1.Parent = confirm

					local baseUICorner = Instance.new("UICorner")
					baseUICorner.Name = "BaseUICorner"
					baseUICorner.CornerRadius = UDim.new(0, 10)
					baseUICorner.Parent = confirm

					confirm.Parent = interactions

					local cancel = Instance.new("TextButton")
					cancel.Name = "Cancel"
					cancel.FontFace = Font.new(
						"rbxassetid://12187365364",
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					cancel.Text = "Cancel"
					cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
					cancel.TextSize = 15
					cancel.TextTransparency = 0.5
					cancel.TextTruncate = Enum.TextTruncate.AtEnd
					cancel.AutoButtonColor = false
					cancel.AutomaticSize = Enum.AutomaticSize.Y
					cancel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					cancel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					cancel.BorderSizePixel = 0
					cancel.Size = UDim2.fromScale(1, 0)

					local baseUICorner1 = Instance.new("UICorner")
					baseUICorner1.Name = "BaseUICorner"
					baseUICorner1.CornerRadius = UDim.new(0, 10)
					baseUICorner1.Parent = cancel

					local uIPadding2 = Instance.new("UIPadding")
					uIPadding2.Name = "UIPadding"
					uIPadding2.PaddingBottom = UDim.new(0, 9)
					uIPadding2.PaddingLeft = UDim.new(0, 10)
					uIPadding2.PaddingRight = UDim.new(0, 10)
					uIPadding2.PaddingTop = UDim.new(0, 9)
					uIPadding2.Parent = cancel

					cancel.Parent = interactions

					local uIPadding3 = Instance.new("UIPadding")
					uIPadding3.Name = "UIPadding"
					uIPadding3.PaddingTop = UDim.new(0, 10)
					uIPadding3.Parent = interactions

					interactions.Parent = prompt

					local globalSettingsUIPadding = Instance.new("UIPadding")
					globalSettingsUIPadding.Name = "GlobalSettingsUIPadding"
					globalSettingsUIPadding.PaddingBottom = UDim.new(0, 20)
					globalSettingsUIPadding.PaddingLeft = UDim.new(0, 20)
					globalSettingsUIPadding.PaddingRight = UDim.new(0, 20)
					globalSettingsUIPadding.PaddingTop = UDim.new(0, 20)
					globalSettingsUIPadding.Parent = prompt

					local paragraph = Instance.new("Frame")
					paragraph.Name = "Paragraph"
					paragraph.AutomaticSize = Enum.AutomaticSize.Y
					paragraph.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BackgroundTransparency = 1
					paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BorderSizePixel = 0
					paragraph.Size = UDim2.fromScale(1, 0)

					local paragraphHeader = Instance.new("TextLabel")
					paragraphHeader.Name = "ParagraphHeader"
					paragraphHeader.FontFace = Font.new(
						"rbxassetid://12187365364",
						Enum.FontWeight.SemiBold,
						Enum.FontStyle.Normal
					)
					paragraphHeader.RichText = true
					paragraphHeader.Text = ColorpickerFunctions.Settings.Name
					paragraphHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.TextSize = 18
					paragraphHeader.TextTransparency = 0.4
					paragraphHeader.TextWrapped = true
					paragraphHeader.TextYAlignment = Enum.TextYAlignment.Top
					paragraphHeader.AutomaticSize = Enum.AutomaticSize.XY
					paragraphHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.BackgroundTransparency = 1
					paragraphHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraphHeader.BorderSizePixel = 0
					paragraphHeader.Size = UDim2.fromScale(1, 0)
					paragraphHeader.Parent = paragraph

					local uIListLayout9 = Instance.new("UIListLayout")
					uIListLayout9.Name = "UIListLayout"
					uIListLayout9.Padding = UDim.new(0, 15)
					uIListLayout9.HorizontalAlignment = Enum.HorizontalAlignment.Center
					uIListLayout9.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout9.Parent = paragraph

					local uIPadding4 = Instance.new("UIPadding")
					uIPadding4.Name = "UIPadding"
					uIPadding4.PaddingBottom = UDim.new(0, 15)
					uIPadding4.Parent = paragraph

					local line = Instance.new("Frame")
					line.Name = "Line"
					line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					line.BackgroundTransparency = 0.9
					line.BorderColor3 = Color3.fromRGB(0, 0, 0)
					line.BorderSizePixel = 0
					line.LayoutOrder = 1
					line.Size = UDim2.new(1, 0, 0, 1)
					line.Parent = paragraph

					paragraph.Parent = prompt

					prompt.Parent = colorPicker

					colorPicker.Parent = base

					local fromHSV, fromRGB, v2, udim2 = Color3.fromHSV, Color3.fromRGB, Vector2.new, UDim2.new

					local wheel = wheel1
					local ring = target
					local slider = value
					local colour = color

					local modifierInputs = {
						Hex = hex.InputBox,
						Red = red.InputBox,
						Green = green.InputBox,
						Blue = blue.InputBox,
						Alpha = alpha.InputBox
					}

					local Mouse = LocalPlayer:GetMouse()

					local WheelDown, SlideDown = false, false
					local hue, saturation, value = 0, 0, 1

					local function toPolar(v)
						return math.atan2(v.y, v.x), v.magnitude
					end

					local function radToDeg(x)
						return ((x + math.pi) / (2 * math.pi)) * 360
					end

					local function degToRad(degrees)
						return degrees * (math.pi / 180)
					end

					local function hexToRGB(hex)
						hex = hex:gsub("#","")
						if #hex ~= 6 then return 0, 0, 0 end
						local r = tonumber(hex:sub(1, 2), 16) or 0
						local g = tonumber(hex:sub(3, 4), 16) or 0
						local b = tonumber(hex:sub(5, 6), 16) or 0
						return r, g, b
					end

					local function clampInput(value, min, max)
						local num = tonumber(value)
						if num then
							return math.clamp(num, min, max)
						end
						return min
					end

					local function update()
						local c = fromHSV(hue, saturation, value)
						colour.BackgroundColor3 = c
						colour.BackgroundTransparency = clampInput(modifierInputs.Alpha.Text, 0, 1)

						modifierInputs.Red.Text = tostring(math.floor(c.r * 255 + 0.5))
						modifierInputs.Green.Text = tostring(math.floor(c.g * 255 + 0.5))
						modifierInputs.Blue.Text = tostring(math.floor(c.b * 255 + 0.5))
						modifierInputs.Alpha.Text = clampInput(modifierInputs.Alpha.Text, 0, 1)

						local hexColor = string.format("#%02X%02X%02X", 
							math.floor(c.r * 255 + 0.5),
							math.floor(c.g * 255 + 0.5),
							math.floor(c.b * 255 + 0.5))
						modifierInputs.Hex.Text = hexColor
					end

					local function UpdateSlide(iX)
						local rY = iX - slider.AbsolutePosition.X
						local cY = math.clamp(rY, 0, slider.AbsoluteSize.X - slide.AbsoluteSize.X)
						slide.Position = udim2(0, cY, 0.5, 0)
						value = 1 - (cY / (slider.AbsoluteSize.X - slide.AbsoluteSize.X))
						update()
					end

					local function UpdateRing(iX, iY)
						local r = wheel.AbsoluteSize.x / 2
						local d = v2(iX, iY) - wheel.AbsolutePosition - wheel.AbsoluteSize / 2

						if d:Dot(d) > r * r then
							d = d.unit * r
						end

						ring.Position = udim2(0.5, d.x, 0.5, d.y)
						local phi, len = toPolar(d * v2(1, -1))
						hue, saturation = radToDeg(phi) / 360, math.clamp(len / r, 0, 1)
						slider.BackgroundColor3 = fromHSV(hue, saturation, 1)
						update()
					end

					local function UpdateSlideFromValue(value)
						local cY = (1 - value) * (slider.AbsoluteSize.X - slide.AbsoluteSize.X)
						slide.Position = UDim2.new(0, cY, 0.5, 0)
					end

					local function UpdateRingFromHSV(hue, saturation)
						local r = wheel.AbsoluteSize.X / 2
						local phi = degToRad(hue * 360)
						local len = saturation * r
						local x = len * math.cos(phi)
						local y = len * math.sin(phi)

						ring.Position = UDim2.new(0.5, -x, 0.5, y)
						slider.BackgroundColor3 = fromHSV(hue, saturation, 1)
					end

					local function updateFromRGB()
						local r = clampInput(modifierInputs.Red.Text, 0, 255)
						local g = clampInput(modifierInputs.Green.Text, 0, 255)
						local b = clampInput(modifierInputs.Blue.Text, 0, 255)
						modifierInputs.Red.Text = r
						modifierInputs.Green.Text = g
						modifierInputs.Blue.Text = b

						hue, saturation, value = Color3.fromRGB(r, g, b):ToHSV()

						UpdateSlideFromValue(value)
						UpdateRingFromHSV(hue, saturation)
						update()
					end

					local function updateFromHex()
						local hex = modifierInputs.Hex.Text
						local r, g, b = hexToRGB(hex)

						r = clampInput(r, 0, 255)
						g = clampInput(g, 0, 255)
						b = clampInput(b, 0, 255)

						modifierInputs.Red.Text = r
						modifierInputs.Green.Text = g
						modifierInputs.Blue.Text = b

						hue, saturation, value = Color3.fromRGB(r, g, b):ToHSV()
						UpdateSlideFromValue(value)
						UpdateRingFromHSV(hue, saturation)
						update()
					end

					local function updateFromSettings()
						local r = math.floor(ColorpickerFunctions.Color.R * 255 + 0.5)
						local g = math.floor(ColorpickerFunctions.Color.G * 255 + 0.5)
						local b = math.floor(ColorpickerFunctions.Color.B * 255 + 0.5)
						modifierInputs.Red.Text = r
						modifierInputs.Green.Text = g
						modifierInputs.Blue.Text = b
						modifierInputs.Alpha.Text = isAlpha and ColorpickerFunctions.Alpha or 0

						local hexColor = string.format("#%02X%02X%02X", r,g,b)
						modifierInputs.Hex.Text = hexColor

						hue, saturation, value = Color3.fromRGB(r, g, b):ToHSV()

						color1.BackgroundColor3 = ColorpickerFunctions.Color
						color1.BackgroundTransparency = isAlpha and ColorpickerFunctions.Alpha or 0

						colour.BackgroundColor3 = Color3.fromRGB(r,g,b)
						colour.BackgroundTransparency = isAlpha and ColorpickerFunctions.Alpha or 0

						UpdateSlideFromValue(value)
						UpdateRingFromHSV(hue, saturation)
					end

					wheel.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							WheelDown = true
							UpdateRing(Mouse.X, Mouse.Y)
						end
					end)

					slider.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							SlideDown = true
							UpdateSlide(Mouse.X)
						end
					end)

					slider.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							SlideDown = false
						end
					end)

					wheel.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							WheelDown = false
						end
					end)

					UserInputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
							if SlideDown then
								UpdateSlide(Mouse.X)
							elseif WheelDown then
								UpdateRing(Mouse.X, Mouse.Y)
							end
						end
					end)

					local function onFocusEnter(instance)
						local placeholder = instance.Text
						instance.Text = ""
						instance.PlaceholderText = placeholder
					end

					modifierInputs.Hex.FocusLost:Connect(updateFromHex)
					modifierInputs.Red.FocusLost:Connect(updateFromRGB)
					modifierInputs.Green.FocusLost:Connect(updateFromRGB)
					modifierInputs.Blue.FocusLost:Connect(updateFromRGB)
					modifierInputs.Alpha.FocusLost:Connect(update)

					modifierInputs.Hex.Focused:Connect(function()
						onFocusEnter(modifierInputs.Hex)
					end)
					modifierInputs.Red.Focused:Connect(function()
						onFocusEnter(modifierInputs.Red)
					end)
					modifierInputs.Green.Focused:Connect(function()
						onFocusEnter(modifierInputs.Green)
					end)
					modifierInputs.Blue.Focused:Connect(function()
						onFocusEnter(modifierInputs.Blue)
					end)
					modifierInputs.Alpha.Focused:Connect(function()
						onFocusEnter(modifierInputs.Alpha)
					end)

					local function makeCanvas()
						local ColorPickerCanvas = Instance.new("CanvasGroup")
						ColorPickerCanvas.Name = "ColorPickerCanvas"
						ColorPickerCanvas.BackgroundTransparency = 1
						ColorPickerCanvas.BorderSizePixel = 0
						ColorPickerCanvas.Size = UDim2.fromScale(1, 1)
						ColorPickerCanvas.ZIndex = 5
						ColorPickerCanvas.GroupTransparency = 1
						ColorPickerCanvas.Parent = base
						ColorPickerCanvas.Visible = false
						return ColorPickerCanvas
					end

					local function transition(isIn)
						local canvas = makeCanvas()
						local tweenTransparency = isIn and 0 or 1
						local tweenScale = isIn and 1 or 0.95
						local stateTransparency = isIn and 1 or 0
						local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine)
						local canvasTween = Tween(canvas, tweenInfo, { GroupTransparency = tweenTransparency })
						local scaleTween = Tween(promptUIScale, tweenInfo, { Scale = tweenScale })

						colorPicker.Visible = true
						colorPicker.Parent = canvas
						canvas.Visible = true
						canvas.GroupTransparency = stateTransparency
						canvasTween:Play()
						scaleTween:Play()
						canvasTween.Completed:Wait()

						if not isIn then
							colorPicker.Visible = false
							canvas.Visible = false
						end

						colorPicker.Parent = base
						canvas:Destroy()
					end

					local function colorpickerIn()
						transition(true)
					end

					local function colorpickerOut()
						transition(false)
					end

					interact.MouseButton1Click:Connect(colorpickerIn)

					cancel.MouseButton1Click:Connect(colorpickerOut)
					confirm.MouseButton1Click:Connect(function()
						colorpickerOut()
						local c = fromHSV(hue, saturation, value)
						ColorpickerFunctions.Color = Color3.fromRGB(c.r * 255, c.g * 255, c.b * 255)
						ColorpickerFunctions.Alpha = isAlpha and clampInput(modifierInputs.Alpha.Text, 0, 1)

						color1.BackgroundColor3 = ColorpickerFunctions.Color
						color1.BackgroundTransparency = isAlpha and ColorpickerFunctions.Alpha or 0

						colorC.BackgroundColor3 = ColorpickerFunctions.Color
						colorC.BackgroundTransparency = isAlpha and ColorpickerFunctions.Alpha or 0

						if ColorpickerFunctions.Settings.Callback then
							task.spawn(function()
								ColorpickerFunctions.Settings.Callback(ColorpickerFunctions.Color, isAlpha and ColorpickerFunctions.Alpha)
							end)
						end
					end)

					updateFromSettings()

					function ColorpickerFunctions:UpdateName(New)
						colorpickerName.Text = New
					end
					function ColorpickerFunctions:SetVisibility(State)
						colorpicker.Visible = State
					end

					function ColorpickerFunctions:SetColor(color3)
						ColorpickerFunctions.Color = color3
						colorC.BackgroundColor3 = color3

						local r = math.floor(ColorpickerFunctions.Color.R * 255 + 0.5)
						local g = math.floor(ColorpickerFunctions.Color.G * 255 + 0.5)
						local b = math.floor(ColorpickerFunctions.Color.B * 255 + 0.5)
						modifierInputs.Red.Text = r
						modifierInputs.Green.Text = g
						modifierInputs.Blue.Text = b

						local hexColor = string.format("#%02X%02X%02X", r,g,b)
						modifierInputs.Hex.Text = hexColor

						hue, saturation, value = Color3.fromRGB(r, g, b):ToHSV()

						color1.BackgroundColor3 = ColorpickerFunctions.Color
						colour.BackgroundColor3 = Color3.fromRGB(r,g,b)

						UpdateSlideFromValue(value)
						UpdateRingFromHSV(hue, saturation)

						if ColorpickerFunctions.Settings.Callback then
							task.spawn(function()
								ColorpickerFunctions.Settings.Callback(ColorpickerFunctions.Color, isAlpha and ColorpickerFunctions.Alpha)
							end)
						end
					end

					function ColorpickerFunctions:SetAlpha(alpha)
						ColorpickerFunctions.Alpha = alpha
						colorC.Transparency = alpha
						updateFromSettings()
					end

					if Flag then
						MacLib.Options[Flag] = ColorpickerFunctions
					end
					return ColorpickerFunctions
				end

				function SectionFunctions:Header(Settings, Flag)
					local HeaderFunctions = {Settings = Settings}

					local header = Instance.new("Frame")
					header.Name = "Header"
					header.AutomaticSize = Enum.AutomaticSize.Y
					header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					header.BackgroundTransparency = 1
					header.BorderColor3 = Color3.fromRGB(0, 0, 0)
					header.BorderSizePixel = 0
					header.LayoutOrder = 0
					header.Size = UDim2.fromScale(1, 0)
					header.Parent = section

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingBottom = UDim.new(0, 5)
					uIPadding.Parent = header

					local headerText = Instance.new("TextLabel")
					headerText.Name = "HeaderText"
					headerText.FontFace = Font.new(
						assets.interFont,
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					headerText.RichText = true
					headerText.Text = HeaderFunctions.Settings.Text or HeaderFunctions.Settings.Name
					headerText.TextColor3 = Color3.fromRGB(255, 255, 255)
					headerText.TextSize = 16
					headerText.TextTransparency = 0.3
					headerText.TextWrapped = true
					headerText.TextXAlignment = Enum.TextXAlignment.Left
					headerText.AutomaticSize = Enum.AutomaticSize.Y
					headerText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					headerText.BackgroundTransparency = 1
					headerText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					headerText.BorderSizePixel = 0
					headerText.Size = UDim2.fromScale(1, 0)
					headerText.Parent = header

					function HeaderFunctions:UpdateName(New)
						headerText.Text = New
					end
					function HeaderFunctions:SetVisibility(State)
						header.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = HeaderFunctions
					end
					return HeaderFunctions
				end

				function SectionFunctions:Label(Settings, Flag)
					local LabelFunctions = {Settings = Settings}

					local label = Instance.new("Frame")
					label.Name = "Label"
					label.AutomaticSize = Enum.AutomaticSize.Y
					label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					label.BackgroundTransparency = 1
					label.BorderColor3 = Color3.fromRGB(0, 0, 0)
					label.BorderSizePixel = 0
					label.Size = UDim2.new(1, 0, 0, 38)
					label.Parent = section

					local labelText = Instance.new("TextLabel")
					labelText.Name = "LabelText"
					labelText.FontFace = Font.new(assets.interFont)
					labelText.RichText = true
					labelText.Text = LabelFunctions.Settings.Text or LabelFunctions.Settings.Name -- Settings.Name Deprecated use Settings.Text
					labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
					labelText.TextSize = 13
					labelText.TextTransparency = 0.5
					labelText.TextWrapped = true
					labelText.TextXAlignment = Enum.TextXAlignment.Left
					labelText.AutomaticSize = Enum.AutomaticSize.Y
					labelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					labelText.BackgroundTransparency = 1
					labelText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					labelText.BorderSizePixel = 0
					labelText.Size = UDim2.fromScale(1, 1)
					labelText.Parent = label

					function LabelFunctions:UpdateName(New)
						labelText.Text = New
					end
					function LabelFunctions:SetVisibility(State)
						label.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = LabelFunctions
					end
					return LabelFunctions
				end

				function SectionFunctions:SubLabel(Settings, Flag)
					local SubLabelFunctions = {Settings = Settings}

					local subLabel = Instance.new("Frame")
					subLabel.Name = "SubLabel"
					subLabel.AutomaticSize = Enum.AutomaticSize.Y
					subLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					subLabel.BackgroundTransparency = 1
					subLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					subLabel.BorderSizePixel = 0
					subLabel.Size = UDim2.new(1, 0, 0, 0)
					subLabel.Parent = section

					local subLabelText = Instance.new("TextLabel")
					subLabelText.Name = "SubLabelText"
					subLabelText.FontFace = Font.new(assets.interFont)
					subLabelText.RichText = true
					subLabelText.Text = SubLabelFunctions.Settings.Text or SubLabelFunctions.Settings.Name -- Settings.Name Deprecated use Settings.Text
					subLabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
					subLabelText.TextSize = 12
					subLabelText.TextTransparency = 0.7
					subLabelText.TextWrapped = true
					subLabelText.TextXAlignment = Enum.TextXAlignment.Left
					subLabelText.AutomaticSize = Enum.AutomaticSize.Y
					subLabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					subLabelText.BackgroundTransparency = 1
					subLabelText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					subLabelText.BorderSizePixel = 0
					subLabelText.Size = UDim2.fromScale(1, 1)
					subLabelText.Parent = subLabel

					function SubLabelFunctions:UpdateName(New)
						subLabelText.Text = New
					end
					function SubLabelFunctions:SetVisibility(State)
						subLabel.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = SubLabelFunctions
					end
					return SubLabelFunctions
				end

				function SectionFunctions:Paragraph(Settings, Flag)
					local ParagraphFunctions = {Settings = Settings}

					local paragraph = Instance.new("Frame")
					paragraph.Name = "Paragraph"
					paragraph.AutomaticSize = Enum.AutomaticSize.Y
					paragraph.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BackgroundTransparency = 1
					paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BorderSizePixel = 0
					paragraph.Size = UDim2.new(1, 0, 0, 38)
					paragraph.Parent = section

					local paragraphHeader = Instance.new("TextLabel")
					paragraphHeader.Name = "ParagraphHeader"
					paragraphHeader.FontFace = Font.new(
						assets.interFont,
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					paragraphHeader.RichText = true
					paragraphHeader.Text = ParagraphFunctions.Settings.Header
					paragraphHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.TextSize = 15
					paragraphHeader.TextTransparency = 0.4
					paragraphHeader.TextWrapped = true
					paragraphHeader.TextXAlignment = Enum.TextXAlignment.Left
					paragraphHeader.AutomaticSize = Enum.AutomaticSize.Y
					paragraphHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.BackgroundTransparency = 1
					paragraphHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraphHeader.BorderSizePixel = 0
					paragraphHeader.Size = UDim2.fromScale(1, 0)
					paragraphHeader.Parent = paragraph

					local uIListLayout = Instance.new("UIListLayout")
					uIListLayout.Name = "UIListLayout"
					uIListLayout.Padding = UDim.new(0, 5)
					uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout.Parent = paragraph

					local paragraphBody = Instance.new("TextLabel")
					paragraphBody.Name = "ParagraphBody"
					paragraphBody.FontFace = Font.new(assets.interFont)
					paragraphBody.RichText = true
					paragraphBody.Text = ParagraphFunctions.Settings.Body
					paragraphBody.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraphBody.TextSize = 13
					paragraphBody.TextTransparency = 0.5
					paragraphBody.TextWrapped = true
					paragraphBody.TextXAlignment = Enum.TextXAlignment.Left
					paragraphBody.AutomaticSize = Enum.AutomaticSize.Y
					paragraphBody.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphBody.BackgroundTransparency = 1
					paragraphBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraphBody.BorderSizePixel = 0
					paragraphBody.LayoutOrder = 1
					paragraphBody.Size = UDim2.fromScale(1, 0)
					paragraphBody.Parent = paragraph

					function ParagraphFunctions:UpdateHeader(New)
						paragraphHeader.Text = New
					end
					function ParagraphFunctions:UpdateBody(New)
						paragraphBody.Text = New
					end
					function ParagraphFunctions:SetVisibility(State)
						paragraph.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = ParagraphFunctions
					end
					return ParagraphFunctions
				end

				function SectionFunctions:Divider()
					local DividerFunctions = {}

					local divider = Instance.new("Frame")
					divider.Name = "Divider"
					divider.AnchorPoint = Vector2.new(0, 1)
					divider.AutomaticSize = Enum.AutomaticSize.Y
					divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					divider.BackgroundTransparency = 1
					divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
					divider.BorderSizePixel = 0
					divider.Position = UDim2.fromScale(0, 1)
					divider.Size = UDim2.new(1, 0, 0, 1)
					divider.Parent = section

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingBottom = UDim.new(0, 8)
					uIPadding.PaddingTop = UDim.new(0, 8)
					uIPadding.Parent = divider

					local uIListLayout = Instance.new("UIListLayout")
					uIListLayout.Name = "UIListLayout"
					uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout.Parent = divider

					local line = Instance.new("Frame")
					line.Name = "Line"
					line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					line.BackgroundTransparency = 0.9
					line.BorderColor3 = Color3.fromRGB(0, 0, 0)
					line.BorderSizePixel = 0
					line.Size = UDim2.new(1, 0, 0, 1)
					line.Parent = divider

					function DividerFunctions:Remove()
						divider:Destroy()
					end
					function DividerFunctions:SetVisibility(State)
						divider.Visible = State
					end

					return DividerFunctions
				end

				function SectionFunctions:Spacer()
					local SpacerFunctions = {}

					local spacer = Instance.new("Frame")
					spacer.Name = "Spacer"
					spacer.AnchorPoint = Vector2.new(0, 1)
					spacer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					spacer.BackgroundTransparency = 1
					spacer.BorderColor3 = Color3.fromRGB(0, 0, 0)
					spacer.BorderSizePixel = 0
					spacer.Position = UDim2.fromScale(0, 1)
					spacer.Parent = section

					function SpacerFunctions:Remove()
						spacer:Destroy()
					end
					function SpacerFunctions:SetVisibility(State)
						spacer.Visible = State
					end

					return SpacerFunctions
				end

				return SectionFunctions
			end

			local function SelectCurrentTab()
				local easetime = 0.15

				if currentTabInstance then
					currentTabInstance.Parent = nil
				end

				for i, tabInfo in pairs(tabs) do
					Tween(i, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
						BackgroundTransparency = (i == tabSwitcher and 0.98 or 1)
					}):Play()

					if tabInfo.tabStroke then
						Tween(tabInfo.tabStroke, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							Transparency = (i == tabSwitcher and 0.95 or 1)
						}):Play()
					end
					if tabInfo.switcherImage then
						Tween(tabInfo.switcherImage, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							ImageTransparency = (i == tabSwitcher and 0.1 or 0.5)
						}):Play()
					end
					if tabInfo.switcherName then
						Tween(tabInfo.switcherName, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							TextTransparency = (i == tabSwitcher and 0.1 or 0.5)
						}):Play()
					end
				end

				tabs[tabSwitcher].tabContent.Parent = content
				currentTabInstance = tabs[tabSwitcher].tabContent
				currentTab.Text = Settings.Name
			end

			tabSwitcher.MouseButton1Click:Connect(function()
				SelectCurrentTab()
			end)

			function TabFunctions:Select()
				SelectCurrentTab()
			end

			function TabFunctions:InsertConfigSection(Side)
				local configSection = TabFunctions:Section({ Side = "Left" })

				if isStudio then
					configSection:Label({Text = "Config system unavailable. (Environment isStudio)"})
					return "Config system unavailable." 
				end

				local inputPath = nil
				local selectedConfig = nil

				configSection:Input({
					Name = "Config Name",
					Placeholder = "Name",
					AcceptedCharacters = "All",
					Callback = function(input)
						inputPath = input
					end,
				})

				local configSelection = configSection:Dropdown({
					Name = "Select Config",
					Multi = false,
					Required = false,
					Options = MacLib:RefreshConfigList(),
					Callback = function(Value)
						selectedConfig = Value
					end,
				})

				configSection:Button({
					Name = "Create Config",
					Callback = function()
						if not inputPath or string.gsub(inputPath, " ", "") == "" then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Config name cannot be empty."
							})
							return
						end

						local success, returned = MacLib:SaveConfig(inputPath)
						if not success then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Unable to save config, return error: " .. returned
							})
						end

						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Created config %q", inputPath),
						})

						configSelection:ClearOptions()
						configSelection:InsertOptions(MacLib:RefreshConfigList())
					end,
				})

				configSection:Button({
					Name = "Load Config",
					Callback = function()
						local success, returned = MacLib:LoadConfig(configSelection.Value)
						if not success then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Unable to load config, return error: " .. returned
							})
							return
						end

						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Loaded config %q", configSelection.Value),
						})
					end,
				})

				configSection:Button({
					Name = "Overwrite Config",
					Callback = function()
						local success, returned = MacLib:SaveConfig(configSelection.Value)
						if not success then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Unable to overwrite config, return error: " .. returned
							})
							return
						end

						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Overwrote config %q", configSelection.Value),
						})
					end,
				})

				configSection:Button({
					Name = "Refresh Config List",
					Callback = function()
						configSelection:ClearOptions()
						configSelection:InsertOptions(MacLib:RefreshConfigList())
					end,
				})

				local autoloadLabel

				configSection:Button({
					Name = "Set as autoload",
					Callback = function()
						local name = configSelection.Value
						writefile(MacLib.Folder .. "/settings/autoload.txt", name)
						autoloadLabel:UpdateName("Autoload config: " .. name)
						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Set %q as autoload", name),
						})
					end,
				})

				autoloadLabel = configSection:Label({Text = "Autoload config: None"})

				if isfile(MacLib.Folder .. "/settings/autoload.txt") then
					local name = readfile(MacLib.Folder .. "/settings/autoload.txt")
					autoloadLabel:UpdateName("Autoload config: " .. name)
				end
			end

			tabs[tabSwitcher] = {
				tabContent = elements1,
				tabStroke = tabSwitcherUIStroke,
				switcherImage = tabImage,
				switcherName = tabSwitcherName,
			}

			return TabFunctions
		end

		return SectionFunctions
	end

	function WindowFunctions:Notify(Settings)
		local NotificationFunctions = {}

		local notification = Instance.new("Frame")
		notification.Name = "Notification"
		notification.AnchorPoint = Vector2.new(0.5, 0.5)
		notification.AutomaticSize = Enum.AutomaticSize.Y
		notification.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notification.BorderSizePixel = 0
		notification.Position = UDim2.fromScale(0.5, 0.5)
		notification.Size = UDim2.fromOffset(Settings.SizeX or 250, 0)

		notification.Parent = notifications

		local notificationUIStroke = Instance.new("UIStroke")
		notificationUIStroke.Name = "NotificationUIStroke"
		notificationUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		notificationUIStroke.Color = Color3.fromRGB(255, 255, 255)
		notificationUIStroke.Transparency = 0.9
		notificationUIStroke.Parent = notification

		local notificationUICorner = Instance.new("UICorner")
		notificationUICorner.Name = "NotificationUICorner"
		notificationUICorner.CornerRadius = UDim.new(0, 10)
		notificationUICorner.Parent = notification

		local notificationUIScale = Instance.new("UIScale")
		notificationUIScale.Name = "NotificationUIScale"
		notificationUIScale.Parent = notification
		notificationUIScale.Scale = 0

		local notificationInformation = Instance.new("Frame")
		notificationInformation.Name = "NotificationInformation"
		notificationInformation.AutomaticSize = Enum.AutomaticSize.Y
		notificationInformation.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationInformation.BackgroundTransparency = 1
		notificationInformation.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationInformation.BorderSizePixel = 0
		notificationInformation.Size = UDim2.fromScale(1, 1)

		local notificationTitle = Instance.new("TextLabel")
		notificationTitle.Name = "NotificationTitle"
		notificationTitle.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.SemiBold,
			Enum.FontStyle.Normal
		)
		notificationTitle.RichText = true
		notificationTitle.Text = Settings.Title
		notificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationTitle.TextSize = 13
		notificationTitle.TextTransparency = 0.2
		notificationTitle.TextTruncate = Enum.TextTruncate.SplitWord
		notificationTitle.TextXAlignment = Enum.TextXAlignment.Left
		notificationTitle.TextYAlignment = Enum.TextYAlignment.Top
		notificationTitle.AutomaticSize = Enum.AutomaticSize.XY
		notificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationTitle.BackgroundTransparency = 1
		notificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationTitle.BorderSizePixel = 0
		notificationTitle.Size = UDim2.new(1, -12, 0, 0)

		local notificationTitleUIPadding = Instance.new("UIPadding")
		notificationTitleUIPadding.Name = "NotificationTitleUIPadding"
		notificationTitleUIPadding.PaddingRight = UDim.new(0, 25)
		notificationTitleUIPadding.Parent = notificationTitle

		notificationTitle.Parent = notificationInformation

		local notificationDescription = Instance.new("TextLabel")
		notificationDescription.Name = "NotificationDescription"
		notificationDescription.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		notificationDescription.Text = Settings.Description
		notificationDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationDescription.TextSize = 11
		notificationDescription.TextTransparency = 0.5
		notificationDescription.TextWrapped = true
		notificationDescription.RichText = true
		notificationDescription.TextXAlignment = Enum.TextXAlignment.Left
		notificationDescription.TextYAlignment = Enum.TextYAlignment.Top
		notificationDescription.AutomaticSize = Enum.AutomaticSize.XY
		notificationDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationDescription.BackgroundTransparency = 1
		notificationDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationDescription.BorderSizePixel = 0
		notificationDescription.Size = UDim2.new(1, -12, 0, 0)

		local notificationDescriptionUIPadding = Instance.new("UIPadding")
		notificationDescriptionUIPadding.Name = "NotificationDescriptionUIPadding"
		notificationDescriptionUIPadding.PaddingRight = UDim.new(0, 25)
		notificationDescriptionUIPadding.PaddingTop = UDim.new(0, 17)
		notificationDescriptionUIPadding.Parent = notificationDescription

		notificationDescription.Parent = notificationInformation

		local notificationUIPadding = Instance.new("UIPadding")
		notificationUIPadding.Name = "NotificationUIPadding"
		notificationUIPadding.PaddingBottom = UDim.new(0, 12)
		notificationUIPadding.PaddingLeft = UDim.new(0, 10)
		notificationUIPadding.PaddingRight = UDim.new(0, 10)
		notificationUIPadding.PaddingTop = UDim.new(0, 10)
		notificationUIPadding.Parent = notificationInformation

		notificationInformation.Parent = notification

		local notificationControls = Instance.new("Frame")
		notificationControls.Name = "NotificationControls"
		notificationControls.AutomaticSize = Enum.AutomaticSize.Y
		notificationControls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationControls.BackgroundTransparency = 1
		notificationControls.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationControls.BorderSizePixel = 0
		notificationControls.Size = UDim2.fromScale(1, 1)

		local interactable = Instance.new("TextButton")
		interactable.Name = "Interactable"
		interactable.FontFace = Font.new(assets.interFont)
		interactable.Text = "✓"
		interactable.TextColor3 = Color3.fromRGB(255, 255, 255)
		interactable.TextSize = 17
		interactable.TextTransparency = 0.2
		interactable.AnchorPoint = Vector2.new(1, 0.5)
		interactable.AutomaticSize = Enum.AutomaticSize.XY
		interactable.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		interactable.BackgroundTransparency = 1
		interactable.BorderColor3 = Color3.fromRGB(0, 0, 0)
		interactable.BorderSizePixel = 0
		interactable.LayoutOrder = 1
		interactable.Position = UDim2.fromScale(1, 0.5)
		interactable.Parent = notificationControls

		local uIPadding = Instance.new("UIPadding")
		uIPadding.Name = "UIPadding"
		uIPadding.PaddingBottom = UDim.new(0, 6)
		uIPadding.PaddingRight = UDim.new(0, 13)
		uIPadding.PaddingTop = UDim.new(0, 6)
		uIPadding.Parent = notificationControls

		notificationControls.Parent = notification

		local tweens = {
			In = Tween(notificationUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = Settings.Scale or 1
			}),
			Out = Tween(notificationUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 0
			}),
		}

		local styles = {
			None = function() interactable:Destroy() end,
			Confirm = function() interactable.Text = "✓" end,
			Cancel = function() interactable.Text = "✗" end
		}

		local style = styles[Settings.Style] or function() interactable:Destroy() end
		style()

		if interactable then
			interactable.MouseButton1Click:Connect(function()
				NotificationFunctions:Cancel()
				if Settings.Callback then
					task.spawn(Settings.Callback)
				end
			end)
		end

		local AnimateNotification = task.spawn(function()
			tweens.In:Play()

			Settings.Lifetime = Settings.Lifetime or 3

			if Settings.Lifetime ~= 0 then
				task.wait(Settings.Lifetime)

				local out = tweens.Out
				out:Play()
				out.Completed:Wait()
				notification:Destroy()
			end
		end)

		function NotificationFunctions:UpdateTitle(New)
			notificationTitle.Text = New
		end

		function NotificationFunctions:UpdateDescription(New)
			notificationDescription.Text = New
		end

		function NotificationFunctions:Resize(X)
			local targ = X or 250
			notification.Size = UDim2.fromOffset(targ, 0)
		end

		function NotificationFunctions:Cancel()
			task.cancel(AnimateNotification)

			local out = tweens.Out
			out:Play()
			out.Completed:Wait()
			notification:Destroy()
		end

		return NotificationFunctions
	end

	function WindowFunctions:Dialog(Settings)
		local DialogFunctions = {}

		local dialogCanvas = Instance.new("CanvasGroup")
		dialogCanvas.Name = "DialogCanvas"
		dialogCanvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		dialogCanvas.BackgroundTransparency = 1
		dialogCanvas.BorderColor3 = Color3.fromRGB(0, 0, 0)
		dialogCanvas.BorderSizePixel = 0
		dialogCanvas.Size = UDim2.fromScale(1, 1)
		dialogCanvas.GroupTransparency = 1
		dialogCanvas.Parent = base

		local dialog = Instance.new("Frame")
		dialog.Name = "Dialog"
		dialog.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		dialog.BackgroundTransparency = 0.5
		dialog.BorderColor3 = Color3.fromRGB(0, 0, 0)
		dialog.BorderSizePixel = 0
		dialog.Size = UDim2.fromScale(1, 1)

		local dialogUICorner = Instance.new("UICorner")
		dialogUICorner.Name = "BaseUICorner"
		dialogUICorner.CornerRadius = UDim.new(0, 10)
		dialogUICorner.Parent = dialog

		local prompt = Instance.new("Frame")
		prompt.Name = "Prompt"
		prompt.AnchorPoint = Vector2.new(0.5, 0.5)
		prompt.AutomaticSize = Enum.AutomaticSize.Y
		prompt.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		prompt.BorderColor3 = Color3.fromRGB(0, 0, 0)
		prompt.BorderSizePixel = 0
		prompt.Position = UDim2.fromScale(0.5, 0.5)
		prompt.Size = UDim2.fromOffset(280, 0)

		local promptUIScale = Instance.new("UIScale")
		promptUIScale.Name = "BaseUIScale"
		promptUIScale.Parent = prompt
		promptUIScale.Scale = 0.95

		local globalSettingsUIStroke = Instance.new("UIStroke")
		globalSettingsUIStroke.Name = "GlobalSettingsUIStroke"
		globalSettingsUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		globalSettingsUIStroke.Color = Color3.fromRGB(255, 255, 255)
		globalSettingsUIStroke.Transparency = 0.9
		globalSettingsUIStroke.Parent = prompt

		local globalSettingsUICorner = Instance.new("UICorner")
		globalSettingsUICorner.Name = "GlobalSettingsUICorner"
		globalSettingsUICorner.CornerRadius = UDim.new(0, 10)
		globalSettingsUICorner.Parent = prompt

		local globalSettingsUIPadding = Instance.new("UIPadding")
		globalSettingsUIPadding.Name = "GlobalSettingsUIPadding"
		globalSettingsUIPadding.PaddingBottom = UDim.new(0, 20)
		globalSettingsUIPadding.PaddingLeft = UDim.new(0, 20)
		globalSettingsUIPadding.PaddingRight = UDim.new(0, 20)
		globalSettingsUIPadding.PaddingTop = UDim.new(0, 20)
		globalSettingsUIPadding.Parent = prompt

		local paragraph = Instance.new("Frame")
		paragraph.Name = "Paragraph"
		paragraph.AutomaticSize = Enum.AutomaticSize.Y
		paragraph.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		paragraph.BackgroundTransparency = 1
		paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
		paragraph.BorderSizePixel = 0
		paragraph.Size = UDim2.new(1, 0, 0, 38)

		local paragraphHeader = Instance.new("TextLabel")
		paragraphHeader.Name = "ParagraphHeader"
		paragraphHeader.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		paragraphHeader.RichText = true
		paragraphHeader.Text = Settings.Title
		paragraphHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
		paragraphHeader.TextSize = 18
		paragraphHeader.TextTransparency = 0.4
		paragraphHeader.TextWrapped = true
		paragraphHeader.AutomaticSize = Enum.AutomaticSize.Y
		paragraphHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		paragraphHeader.BackgroundTransparency = 1
		paragraphHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
		paragraphHeader.BorderSizePixel = 0
		paragraphHeader.Size = UDim2.fromScale(1, 0)
		paragraphHeader.Parent = paragraph

		local uIListLayout = Instance.new("UIListLayout")
		uIListLayout.Name = "UIListLayout"
		uIListLayout.Padding = UDim.new(0, 15)
		uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout.Parent = paragraph

		local paragraphBody = Instance.new("TextLabel")
		paragraphBody.Name = "ParagraphBody"
		paragraphBody.FontFace = Font.new(assets.interFont)
		paragraphBody.RichText = true
		paragraphBody.Text = Settings.Description
		paragraphBody.TextColor3 = Color3.fromRGB(255, 255, 255)
		paragraphBody.TextSize = 14
		paragraphBody.TextTransparency = 0.5
		paragraphBody.TextWrapped = true
		paragraphBody.AutomaticSize = Enum.AutomaticSize.Y
		paragraphBody.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		paragraphBody.BackgroundTransparency = 1
		paragraphBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
		paragraphBody.BorderSizePixel = 0
		paragraphBody.LayoutOrder = 1
		paragraphBody.Size = UDim2.fromScale(1, 0)
		paragraphBody.Parent = paragraph

		paragraph.Parent = prompt

		local interactions = Instance.new("Frame")
		interactions.Name = "Interactions"
		interactions.AutomaticSize = Enum.AutomaticSize.Y
		interactions.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		interactions.BackgroundTransparency = 1
		interactions.BorderColor3 = Color3.fromRGB(0, 0, 0)
		interactions.BorderSizePixel = 0
		interactions.LayoutOrder = 1
		interactions.Size = UDim2.fromScale(1, 0)

		local uIListLayout1 = Instance.new("UIListLayout")
		uIListLayout1.Name = "UIListLayout"
		uIListLayout1.Padding = UDim.new(0, 10)
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = interactions

		local uIPadding = Instance.new("UIPadding")
		uIPadding.Name = "UIPadding"
		uIPadding.PaddingTop = UDim.new(0, 20)
		uIPadding.Parent = interactions

		interactions.Parent = prompt

		local uIListLayout2 = Instance.new("UIListLayout")
		uIListLayout2.Name = "UIListLayout"
		uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout2.Parent = prompt

		prompt.Parent = dialog

		dialog.Parent = dialogCanvas

		local canvasIn = Tween(dialogCanvas, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { GroupTransparency = 0 })
		local canvasOut = Tween(dialogCanvas, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { GroupTransparency = 1 })

		local scaleIn = Tween(promptUIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { Scale = 1 })
		local scaleOut = Tween(promptUIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { Scale = 0.95 })

		local function dialogIn()
			canvasIn:Play()
			scaleIn:Play()
			canvasIn.Completed:Wait()
			dialog.Parent = base
		end

		local function dialogOut()
			if not dialog.Parent then return end
			dialog.Parent = dialogCanvas
			canvasOut:Play()
			scaleOut:Play()
			canvasOut.Completed:Wait()
			dialogCanvas:Destroy()
		end

		for _, v in pairs(Settings.Buttons) do
			local button = Instance.new("TextButton")
			button.Name = "Button"
			button.FontFace = Font.new(assets.interFont)
			button.Text = v.Name
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
			button.TextSize = 15
			button.TextTransparency = 0.5
			button.TextTruncate = Enum.TextTruncate.AtEnd
			button.AutoButtonColor = false
			button.AutomaticSize = Enum.AutomaticSize.Y
			button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			button.BorderColor3 = Color3.fromRGB(0, 0, 0)
			button.BorderSizePixel = 0
			button.Size = UDim2.fromScale(1, 0)

			local uIPadding1 = Instance.new("UIPadding")
			uIPadding1.Name = "UIPadding"
			uIPadding1.PaddingBottom = UDim.new(0, 9)
			uIPadding1.PaddingLeft = UDim.new(0, 10)
			uIPadding1.PaddingRight = UDim.new(0, 10)
			uIPadding1.PaddingTop = UDim.new(0, 9)
			uIPadding1.Parent = button

			local baseUICorner1 = Instance.new("UICorner")
			baseUICorner1.Name = "BaseUICorner"
			baseUICorner1.CornerRadius = UDim.new(0, 10)
			baseUICorner1.Parent = button

			button.Parent = interactions

			local TweenSettings = {
				DefaultTransparency = 0,
				DefaultTransparency2 = 0.5,
				HoverTransparency = 0.3,
				HoverTransparency2 = 0.6,

				EasingStyle = Enum.EasingStyle.Sine
			}

			local function ChangeState(State)
				if State == "Idle" then
					Tween(button, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
						BackgroundTransparency = TweenSettings.DefaultTransparency,
						TextTransparency = TweenSettings.DefaultTransparency2
					}):Play()
				elseif State == "Hover" then
					Tween(button, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
						BackgroundTransparency = TweenSettings.HoverTransparency,
						TextTransparency = TweenSettings.HoverTransparency2
					}):Play()
				end
			end

			button.MouseButton1Click:Connect(function()
				if dialogCanvas.GroupTransparency ~= 0 then return end
				if v.Callback then
					v.Callback()
				end

				dialogOut()
			end)

			button.MouseEnter:Connect(function()
				ChangeState("Hover")
			end)
			button.MouseLeave:Connect(function()
				ChangeState("Idle")
			end)
		end

		dialogIn()

		function DialogFunctions:UpdateTitle(New)
			paragraphHeader.Text = New
		end
		function DialogFunctions:UpdateDescription(New)
			paragraphBody.Text = New
		end

		function DialogFunctions:Cancel()
			dialogOut()
		end

		return DialogFunctions
	end

	function WindowFunctions:SetNotificationsState(State)
		notifications.Visible = State
	end

	function WindowFunctions:GetNotificationsState(State)
		return notifications.Visible
	end

	function WindowFunctions:SetState(State)
		windowState = State
		base.Visible = State
	end

	function WindowFunctions:GetState()
		return windowState
	end

	local onUnloadCallback

	function WindowFunctions:Unload()
		if onUnloadCallback then
			onUnloadCallback()  
		end
		macLib:Destroy()
		unloaded = true
	end

	function WindowFunctions.onUnloaded(callback)
		onUnloadCallback = callback
	end

	local MenuKeybind = Settings.Keybind or Enum.KeyCode.RightControl

	local function ToggleMenu()
		local state = not WindowFunctions:GetState()
		WindowFunctions:SetState(state)
		WindowFunctions:Notify({
			Title = Settings.Title,
			Description = (state and "Maximized " or "Minimized ") .. "the menu. Use " .. tostring(MenuKeybind.Name) .. " to toggle it.",
			Lifetime = 5
		})
	end

	UserInputService.InputEnded:Connect(function(inp, gpe)
		if gpe then return end
		if inp.KeyCode == MenuKeybind then
			ToggleMenu()
		end
	end)

	minimize.MouseButton1Click:Connect(ToggleMenu)
	exit.MouseButton1Click:Connect(function()
		WindowFunctions:Dialog({
			Title = Settings.Title,
			Description = "Are you sure you want to exit the menu? You will lose any unsaved configurations.",
			Buttons = {
				{
					Name = "Confirm",
					Callback = function()
						WindowFunctions:Unload()
					end,
				},
				{
					Name = "Cancel"
				}
			}
		})
	end)

	function WindowFunctions:SetKeybind(Keycode)
		MenuKeybind = Keycode
	end

	function WindowFunctions:SetAcrylicBlurState(State)
		acrylicBlur = State
		base.BackgroundTransparency = State and 0.05 or 0
	end

	function WindowFunctions:GetAcrylicBlurState()
		return acrylicBlur
	end

	local function _SetUserInfoState(State)
		if State then
			headshot.Image = (isReady and headshotImage) or "rbxassetid://0"
			username.Text = "@" .. LocalPlayer.Name
			displayName.Text = LocalPlayer.DisplayName
		else
			headshot.Image = assets.userInfoBlurred
			local nameLength = #LocalPlayer.Name
			local displayNameLength = #LocalPlayer.DisplayName
			username.Text = "@" .. string.rep(".", nameLength)
			displayName.Text = string.rep(".", displayNameLength)
		end
	end

	local showUserInfo
	if Settings.ShowUserInfo ~= nil then
		showUserInfo = Settings.ShowUserInfo
	else
		showUserInfo = true
	end

	_SetUserInfoState(showUserInfo)

	function WindowFunctions:SetUserInfoState(State)
		_SetUserInfoState(State)
	end
	function WindowFunctions:GetUserInfoState(State)
		return showUserInfo
	end

	function WindowFunctions:SetSize(Size)
		base.Size = Size
	end
	function WindowFunctions:GetSize(Size)
		return base.Size
	end

	function WindowFunctions:SetScale(Scale)
		baseUIScale.Scale = Scale
	end
	function WindowFunctions:GetScale()
		return baseUIScale.Scale
	end

	local ClassParser = {
		["Toggle"] = {
			Save = function(Flag, data)
				return {
					type = "Toggle", 
					flag = Flag, 
					state = data.State or false
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.state then
					MacLib.Options[Flag]:UpdateState(data.state)
				end
			end
		},
		["Slider"] = {
			Save = function(Flag, data)
				return {
					type = "Slider", 
					flag = Flag, 
					value = (data.Value and tostring(data.Value)) or false
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.value then
					MacLib.Options[Flag]:UpdateValue(data.value)
				end
			end
		},
		["Input"] = {
			Save = function(Flag, data)
				return {
					type = "Input", 
					flag = Flag, 
					text = data.Text
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.text and type(data.text) == "string" then
					MacLib.Options[Flag]:UpdateText(data.text)
				end
			end
		},
		["Keybind"] = {
			Save = function(Flag, data)
				return {
					type = "Keybind", 
					flag = Flag, 
					bind = (typeof(data.Bind) == "EnumItem" and data.Bind.Name) or nil
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.bind then
					MacLib.Options[Flag]:Bind(Enum.KeyCode[data.bind])
				end
			end
		},
		["Dropdown"] = {
			Save = function(Flag, data)
				return {
					type = "Dropdown", 
					flag = Flag, 
					value = data.Value
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.value then
					MacLib.Options[Flag]:UpdateSelection(data.value)
				end
			end
		},
		["Colorpicker"] = {
			Save = function(Flag, data)
				local function Color3ToHex(color)
					return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
				end

				return {
					type = "Colorpicker", 
					flag = Flag, 
					color = Color3ToHex(data.Color) or nil,
					alpha = data.Alpha
				}
			end,
			Load = function(Flag, data)
				local function HexToColor3(hex)
					local r = tonumber(hex:sub(2, 3), 16) / 255
					local g = tonumber(hex:sub(4, 5), 16) / 255
					local b = tonumber(hex:sub(6, 7), 16) / 255
					return Color3.new(r, g, b)
				end

				if MacLib.Options[Flag] and data.color then
					MacLib.Options[Flag]:SetColor(HexToColor3(data.color)) 
					if data.alpha then
						MacLib.Options[Flag]:SetAlpha(data.alpha)
					end
				end
			end
		}
	}

	local function BuildFolderTree()
		if isStudio or not (isfolder and makefolder) then return "Config system unavailable." end

		local paths = {
			MacLib.Folder,
			MacLib.Folder .. "/settings"
		}

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function MacLib:LoadAutoLoadConfig()
		if isStudio or not (isfile and readfile) then return "Config system unavailable." end

		if isfile(MacLib.Folder .. "/settings/autoload.txt") then
			local name = readfile(MacLib.Folder .. "/settings/autoload.txt")

			local suc, err = MacLib:LoadConfig(name)
			if not suc then
				WindowFunctions:Notify({
					Title = "Interface",
					Description = "Error loading autoload config: " .. err
				})
			end

			WindowFunctions:Notify({
				Title = "Interface",
				Description = string.format("Autoloaded config: %q", name),
			})
		end
	end

	function MacLib:SetFolder(Folder)
		if isStudio then return "Config system unavailable." end

		MacLib.Folder = Folder;
		BuildFolderTree()
	end

	function MacLib:SaveConfig(Path)
		if isStudio or not writefile then return "Config system unavailable." end

		if (not Path) then
			return false, "Please select a config file."
		end

		local fullPath = MacLib.Folder .. "/settings/" .. Path .. ".json"

		local data = {
			objects = {}
		}

		for flag, option in next, MacLib.Options do
			if not ClassParser[option.Class] then continue end
			if option.IgnoreConfig then continue end

			table.insert(data.objects, ClassParser[option.Class].Save(flag, option))
		end	

		local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
		if not success then
			return false, "Unable to encode into JSON data"
		end

		writefile(fullPath, encoded)
		return true
	end

	function MacLib:LoadConfig(Path)
		if isStudio or not (isfile and readfile) then return "Config system unavailable." end

		if (not Path) then
			return false, "Please select a config file."
		end

		local file = MacLib.Folder .. "/settings/" .. Path .. ".json"
		if not isfile(file) then return false, "Invalid file" end

		local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
		if not success then return false, "Unable to decode JSON data." end

		for _, option in next, decoded.objects do
			if ClassParser[option.type] then
				task.spawn(function() 
					ClassParser[option.type].Load(option.flag, option) 
				end)
			end
		end

		return true
	end

	function MacLib:RefreshConfigList()
		if isStudio or not (isfolder and listfiles) then return "Config system unavailable." end

		local list = (isfolder(MacLib.Folder) and isfolder(MacLib.Folder .. "/settings")) and listfiles(MacLib.Folder .. "/settings") or {}

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == ".json" then
				local pos = file:find(".json", 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= "/" and char ~= "\\" and char ~= "" do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == "/" or char == "\\" then
					local name = file:sub(pos + 1, start - 1)
					if name ~= "options" then
						table.insert(out, name)
					end
				end
			end
		end

		return out
	end

	macLib.Enabled = false

	local assetList = {}
	for _, assetId in pairs(assets) do
		table.insert(assetList, assetId)
	end

	ContentProvider:PreloadAsync(assetList)
	macLib.Enabled = true
	windowState = true

	return WindowFunctions
end

function MacLib:Demo()
	local Window = MacLib:Window({
		Title = "Maclib Demo",
		Subtitle = "This is a subtitle.",
		Size = UDim2.fromOffset(868, 650),
		DragStyle = 1,
		DisabledWindowControls = {},
		ShowUserInfo = true,
		Keybind = Enum.KeyCode.RightControl,
		AcrylicBlur = true,
	})

	local globalSettings = {
		UIBlurToggle = Window:GlobalSetting({
			Name = "UI Blur",
			Default = Window:GetAcrylicBlurState(),
			Callback = function(bool)
				Window:SetAcrylicBlurState(bool)
				Window:Notify({
					Title = Window.Settings.Title,
					Description = (bool and "Enabled" or "Disabled") .. " UI Blur",
					Lifetime = 5
				})
			end,
		}),
		NotificationToggler = Window:GlobalSetting({
			Name = "Notifications",
			Default = Window:GetNotificationsState(),
			Callback = function(bool)
				Window:SetNotificationsState(bool)
				Window:Notify({
					Title = Window.Settings.Title,
					Description = (bool and "Enabled" or "Disabled") .. " Notifications",
					Lifetime = 5
				})
			end,
		}),
		ShowUserInfo = Window:GlobalSetting({
			Name = "Show User Info",
			Default = Window:GetUserInfoState(),
			Callback = function(bool)
				Window:SetUserInfoState(bool)
				Window:Notify({
					Title = Window.Settings.Title,
					Description = (bool and "Showing" or "Redacted") .. " User Info",
					Lifetime = 5
				})
			end,
		})
	}

	local tabGroups = {
		TabGroup1 = Window:TabGroup()
	}

	local tabs = {
		Main = tabGroups.TabGroup1:Tab({ Name = "Demo", Image = "rbxassetid://18821914323" }),
		Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" })
	}

	local sections = {
		MainSection1 = tabs.Main:Section({ Side = "Left" }),
	}

	sections.MainSection1:Header({
		Name = "Header #1"
	})

	sections.MainSection1:Button({
		Name = "Button",
		Callback = function()
			Window:Dialog({
				Title = Window.Settings.Title,
				Description = "Lorem ipsum odor amet, consectetuer adipiscing elit. Eros vestibulum aliquet mattis, ex platea nunc.",
				Buttons = {
					{
						Name = "Confirm",
						Callback = function()
							print("Confirmed!")
						end,
					},
					{
						Name = "Cancel"
					}
				}
			})
		end,
	})

	sections.MainSection1:Input({
		Name = "Input",
		Placeholder = "Input",
		AcceptedCharacters = "All",
		Callback = function(input)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = "Successfully set input to " .. input
			})
		end,
		onChanged = function(input)
			print("Input is now " .. input)
		end,
	}, "Input")

	sections.MainSection1:Slider({
		Name = "Slider",
		Default = 50,
		Minimum = 0,
		Maximum = 100,
		DisplayMethod = "Percent",
		Precision = 0,
		Callback = function(Value)
			print("Changed to ".. Value)
		end
	}, "Slider")

	sections.MainSection1:Toggle({
		Name = "Toggle",
		Default = false,
		Callback = function(value)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (value and "Enabled " or "Disabled ") .. "Toggle"
			})
		end,
	}, "Toggle")

	sections.MainSection1:Keybind({
		Name = "Keybind",
		Blacklist = false,
		Callback = function(binded)
			Window:Notify({
				Title = "Demo Window",
				Description = "Pressed keybind - "..tostring(binded.Name),
				Lifetime = 3
			})
		end,
		onBinded = function(bind)
			Window:Notify({
				Title = "Demo Window",
				Description = "Successfully Binded Keybind to - "..tostring(bind.Name),
				Lifetime = 3
			})
		end,
	}, "Keybind")

	sections.MainSection1:Colorpicker({
		Name = "Colorpicker",
		Default = Color3.fromRGB(0, 255, 255),
		Callback = function(color)
			print("Color: ", color)
		end,
	}, "Colorpicker")

	local alphaColorPicker = sections.MainSection1:Colorpicker({
		Name = "Transparency Colorpicker",
		Default = Color3.fromRGB(255,0,0),
		Alpha = 0,
		Callback = function(color, alpha)
			print("Color: ", color, " Alpha: ", alpha)
		end,
	}, "TransparencyColorpicker")

	local rainbowActive
	local rainbowConnection
	local hue = 0

	sections.MainSection1:Toggle({
		Name = "Rainbow",
		Default = false,
		Callback = function(value)
			rainbowActive = value

			if rainbowActive then
				rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
					hue = (hue + deltaTime * 0.1) % 1
					alphaColorPicker:SetColor(Color3.fromHSV(hue, 1, 1))
				end)
			elseif rainbowConnection then
				rainbowConnection:Disconnect()
				rainbowConnection = nil
			end
		end,
	}, "RainbowToggle")

	local optionTable = {
		"Apple",
		"Banana",
		"Orange",
		"Grapes",
		"Pineapple",
		"Mango",
		"Strawberry",
		"Blueberry",
		"Watermelon",
		"Peach"
	}

	local Dropdown = sections.MainSection1:Dropdown({
		Name = "Dropdown",
		Multi = false,
		Required = true,
		Options = optionTable,
		Default = 1,
		Callback = function(Value)
			print("Dropdown changed: ".. Value)
		end,
	}, "Dropdown")

	local MultiDropdown = sections.MainSection1:Dropdown({
		Name = "Multi Dropdown",
		Search = true,
		Multi = true,
		Required = false,
		Options = optionTable,
		Default = {"Apple", "Orange"},
		Callback = function(Value)
			local Values = {}
			for Value, State in next, Value do
				table.insert(Values, Value)
			end
			print("Mutlidropdown changed:", table.concat(Values, ", "))
		end,
	}, "MultiDropdown")

	sections.MainSection1:Button({
		Name = "Update Selection",
		Callback = function()
			Dropdown:UpdateSelection("Grapes")
			MultiDropdown:UpdateSelection({"Banana", "Pineapple"})
		end,
	})

	sections.MainSection1:Divider()

	sections.MainSection1:Header({
		Text = "Header #2"
	})

	sections.MainSection1:Paragraph({
		Header = "Paragraph",
		Body = "Paragraph body. Lorem ipsum odor amet, consectetuer adipiscing elit. Morbi tempus netus aliquet per velit est gravida."
	})

	sections.MainSection1:Label({
		Text = "Label. Lorem ipsum odor amet, consectetuer adipiscing elit."
	})

	sections.MainSection1:SubLabel({
		Text = "Sub-Label. Lorem ipsum odor amet, consectetuer adipiscing elit."
	})

	MacLib:SetFolder("Maclib")
	tabs.Settings:InsertConfigSection("Left")

	Window.onUnloaded(function()
		print("Unloaded!")
	end)

	tabs.Main:Select()
	MacLib:LoadAutoLoadConfig()
end

return MacLib


-- RawExploit Key System Integration
local SavedKeyFile = "RawExploit_MuscleLegends_Key.txt"
local TargetKey = "PrivateForSelf"

local function HasValidSavedKey()
    if isfile and readfile and isfile(SavedKeyFile) then
        local ok, data = pcall(function() return readfile(SavedKeyFile) end)
        return ok and data == TargetKey
    end
    return false
end

local function SaveKeyLocally()
    if writefile then
        pcall(function() writefile(SavedKeyFile, TargetKey) end)
    end
end

if not HasValidSavedKey() then
    local KeyVerified = false
    repeat
        if HasValidSavedKey() then
            KeyVerified = true
        else
            task.wait(0.5)
        end
    until KeyVerified
end


local players = game:GetService("Players")

-- RawExploit Key System
-- Saved authorization for this executor environment
local RawExploitKey = "R4W-3XPL01TS-P4ID"
local RawExploitKeyFile = "RawExploit_Key_Save.txt"

local function RawExploitHasSavedKey()
    if isfile and readfile then
        local ok, data = pcall(function()
            return readfile(RawExploitKeyFile)
        end)
        return ok and data == RawExploitKey
    end
    return false
end

local function RawExploitSaveKey()
    if writefile then
        pcall(function()
            writefile(RawExploitKeyFile, RawExploitKey)
        end)
    end
end

if not RawExploitHasSavedKey() then
    local inputGui = Instance.new("ScreenGui")
    inputGui.Name = "RawExploitKeySystem"
    inputGui.ResetOnSpawn = false
    inputGui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 460, 0, 250)
    frame.Position = UDim2.new(0.5, -230, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(10, 12, 28)
    frame.BackgroundTransparency = 0.05
    frame.Parent = inputGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 18)
    frameCorner.Parent = frame

    local frameStroke = Instance.new("UIStroke")
    frameStroke.Thickness = 2
    frameStroke.Transparency = 0.15
    frameStroke.Color = Color3.fromRGB(140, 80, 255)
    frameStroke.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 25, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 35, 150))
    })
    gradient.Rotation = 45
    gradient.Parent = frame

    frame.Size = UDim2.new(0, 20, 0, 20)
    game:GetService("TweenService"):Create(frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 460, 0, 250)
    }):Play()

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,50)
    title.BackgroundTransparency = 1
    title.Text = "RAW3XPLOITS  |  PREMIUM KEY SYSTEM\nMuscle Legends Menu"
    title.TextWrapped = true
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.8,0,0,45)
    box.Position = UDim2.new(0.1,0,0.35,0)
    box.PlaceholderText = "Enter Key"
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(25, 30, 65)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Parent = frame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 12)
    boxCorner.Parent = box

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5,0,0,40)
    button.Position = UDim2.new(0.25,0,0.65,0)
    button.Text = "Verify Key"
    button.BackgroundColor3 = Color3.fromRGB(145, 70, 255)
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Font = Enum.Font.GothamBold
    button.Parent = frame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 12)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Thickness = 1.5
    buttonStroke.Color = Color3.fromRGB(220, 190, 255)
    buttonStroke.Parent = button

    button.MouseButton1Click:Connect(function()
        if box.Text == RawExploitKey then
            RawExploitSaveKey()
            inputGui:Destroy()
        else
            box.Text = "Wrong Key"
        end
    end)

    repeat task.wait() until not inputGui.Parent
end

local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local virtualInputManager = game:GetService("VirtualInputManager")
local virtualUser = game:GetService("VirtualUser")
local stats = game:GetService("Stats")
local lighting = game:GetService("Lighting")
local number = 3623096087
local backpackContainer = players.LocalPlayer
local parent = backpackContainer:WaitForChild("PlayerGui")
local option = getgenv and getgenv() or _G
if
	not ({
		[4473738491] = true,
		[2955289715] = true,
		[1620672820] = true,
		[2500188617] = true,
		[3845958096] = true,
		[10986230819] = true,
		[5486738320] = true,
		[9879123031] = true,
		[11395285875] = true,
		[10886140154] = true,
		[3039550957] = true,
		[1835330458] = true,
	})[backpackContainer.UserId]
then end
do
	local connectionData = option.RawExploitPersistentAntiAfk
	if type(connectionData) ~= "table" then
		connectionData = {}
		option.RawExploitPersistentAntiAfk = connectionData
	end
	if not connectionData.connection or not connectionData.connection.Connected then
		connectionData.connection = backpackContainer.Idled:Connect(function(...)
			pcall(function(...)
				virtualUser:CaptureController()
				local currentCamera = workspace.CurrentCamera
				local option = currentCamera and currentCamera.CFrame or CFrame.new()
				virtualUser:Button2Down(Vector2.new(0, 0), option)
				task.wait(0.05)
				virtualUser:Button2Up(Vector2.new(0, 0), option)
			end)
		end)
	end
end
local public = {
	["Title"] = "\226\154\161  \194\161RawExploits Muscle Legends Menu  \226\154\161",
	["Discord"] = "https://2zvh.xyz/",
	["YouTube"] = "https://www.youtube.com/@Real_RawExploit",
	["Size"] = {
		["DesktopWidth"] = 520,
		["DesktopHeight"] = 338,
		["MobileWidthScale"] = 0.86,
		["MobileHeightScale"] = 0.5,
		["MinWidth"] = 276,
		["MinHeight"] = 232,
		["MaxMobileWidth"] = 455,
		["MaxMobileHeight"] = 305,
	},
	["Colors"] = {
		["base"] = Color3.fromRGB(8, 10, 24),
		["panel"] = Color3.fromRGB(18, 20, 45),
		["row"] = Color3.fromRGB(26, 30, 65),
		["rowHover"] = Color3.fromRGB(45, 55, 120),
		["tab"] = Color3.fromRGB(4, 27, 52),
		["tabOn"] = Color3.fromRGB(124, 58, 237),
		["cyan"] = Color3.fromRGB(168, 85, 247),
		["blue"] = Color3.fromRGB(26, 139, 255),
		["green"] = Color3.fromRGB(65, 239, 157),
		["orange"] = Color3.fromRGB(255, 185, 64),
		["red"] = Color3.fromRGB(255, 83, 111),
		["white"] = Color3.fromRGB(255, 255, 255),
		["soft"] = Color3.fromRGB(220, 247, 255),
		["dim"] = Color3.fromRGB(153, 207, 231),
		["black"] = Color3.fromRGB(0, 0, 0),
	},
	["Tabs"] = {
		{ "Info", 62 },
		{ "Main", 62 },
		{ "Fast Glitch 100%", 120 },
		{ "Glitch Timer", 92 },
		{ "Auto Farm", 88 },
		{ "Fast Farm", 84 },
		{ "Rebirths", 78 },
		{ "Kills", 62 },
		{ "Pet Shop", 86 },
		{ "Gifts", 60 },
		{ "Fast Trade", 88 },
		{ "Teleports", 84 },
		{ "Stats", 62 },
		{ "Misc", 60 },
	},
	["Rocks"] = {
		{ ["name"] = "Ancient Rock", ["durability"] = 10000000 },
		{ ["name"] = "Muscle King Rock", ["durability"] = 5000000 },
		{ ["name"] = "Legend Rock", ["durability"] = 1000000 },
		{ ["name"] = "Eternal Rock", ["durability"] = 750000 },
		{ ["name"] = "Mythical Rock", ["durability"] = 400000 },
		{ ["name"] = "Frost Rock", ["durability"] = 150000 },
		{ ["name"] = "Beach Rock", ["durability"] = 5000 },
		{ ["name"] = "Starter Rock", ["durability"] = 100 },
		{ ["name"] = "Tiny Rock", ["durability"] = 0 },
	},
	["Machines"] = {
		{ ["label"] = "Jungle Bench", ["object"] = "Jungle Bench", ["fallback"] = CFrame.new(-8173, 64, 1898) },
		{
			["label"] = "Jungle Lift",
			["object"] = "Jungle Bar Lift",
			["fallback"] = CFrame.new(-8652.8672, 29.2667, 2089.2617),
		},
		{ ["label"] = "Jungle Squat", ["object"] = "Jungle Squat", ["fallback"] = CFrame.new(-8352, 34, 2878) },
	},
	["Teleports"] = {
		{ "Jungle Gym", Vector3.new(-7894, 6, 2386) },
		{ "Muscle King", Vector3.new(-8799, 17, -5798) },
		{ "Legends Gym", Vector3.new(4429, 991, -3880) },
		{ "Eternal Gym", Vector3.new(-6768, 7, -1287) },
		{ "Mythical Gym", Vector3.new(2255, 7, 1071) },
		{ "Frost Gym", Vector3.new(-2650, 7, -393) },
		{ "Tiny Gym", Vector3.new(50, 7, 1918) },
		{ "Beach", Vector3.new(9, 7, 100) },
		{ "Secret Area", Vector3.new(1947, 2, 6191) },
		{ "Desert Brawl", Vector3.new(960, 17, -7398) },
		{ "Lava Brawl", Vector3.new(4471, 119, -8836) },
	},
	["UniqueAuras"] = { "Muscle King", "Entropic Blast" },
	["UniquePets"] = {
		"Neon Guardian",
		"Cybernetic Showdown Dragon",
		"Darkstar Hunter",
		"Muscle Sensei",
		"Infernal Dragon",
		"Aether Spirit Bunny",
		"Magic Butterfly",
		"Ultra Birdie",
	},
	["AutoEgg"] = { ["Interval"] = 1800, ["Names"] = { "ProteinEgg", "Protein Egg" } },
	["FastFarm"] = {
		["StrengthPet"] = "Swift Samurai",
		["RebirthPet"] = "Tribal Overlord",
		["MaxPets"] = 8,
		["RepsPerCycle"] = 70,
		["RepDelay"] = 0.005,
		["PingSoft"] = 180,
		["PingMedium"] = 300,
		["PingHigh"] = 450,
		["PingCritical"] = 600,
		["PingPause"] = 999,
		["PingResume"] = 400,
		["StrengthStartBatch"] = 14,
		["StrengthMaxBatch"] = 42,
		["StrengthRampPing"] = 140,
		["StrengthRampInterval"] = 4,
		["StrengthDelay"] = 0.02,
		["SizeInvokeInterval"] = 0.75,
		["SizeReleaseDuration"] = 5,
		["FramesReleaseDuration"] = 10,
		["RockName"] = "Rock5M",
		["RockInterval"] = 5,
		["RebirthCycleDelay"] = 0.2,
		["RebirthRequestWindow"] = 0.75,
	},
	["ServerHop"] = {
		["Interval"] = 120,
		["LoaderUrl"] = "https://raw.githubusercontent.com/anjaykiki12345678910-ctrl/YUPIMAS/refs/heads/main/loader.lua",
		["ServerApi"] = "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100",
		["PreferredPlayers"] = 18,
		["MinimumPlayers"] = 16,
		["NoTargetsDelay"] = 10,
		["RetryDelay"] = 5,
		["HistoryLimit"] = 60,
	},
	["Kills"] = { ["ProtectedPrivateServerIds"] = {} },
}
local colors = public.Colors
do
	local flag = option.RawExploitFG100
	if flag and type(flag.Shutdown) == "function" then
		pcall(flag.Shutdown, true)
	end
end
local pState = {
	["running"] = true,
	["resume"] = type(option.RawExploitFG100Resume) == "table" and option.RawExploitFG100Resume or nil,
	["fastPunch"] = false,
	["selectedRock"] = nil,
	["rockGeneration"] = 0,
	["rockSessionStartedAt"] = nil,
	["autoWeight"] = false,
	["autoHandstands"] = false,
	["autoLift"] = false,
	["autoSitups"] = false,
	["autoEgg"] = false,
	["exerciseMovement"] = {
		["active"] = {},
		["humanoid"] = nil,
		["walkSpeed"] = nil,
		["jumpValue"] = nil,
		["usesJumpPower"] = true,
	},
	["hideFrames"] = false,
	["hideDurability"] = false,
	["fastFarmMode"] = nil,
	["machine"] = nil,
	["autoPet"] = false,
	["autoAura"] = false,
	["antiLag"] = false,
	["antiLagGeneration"] = 0,
	["walkWater"] = false,
	["autoSpinWheel"] = false,
	["autoClaimChests"] = false,
	["mainAutoSize"] = false,
	["mainAutoSpeed"] = false,
	["mainSize"] = 2,
	["mainSpeed"] = 125,
	["infiniteJump"] = false,
	["removePortals"] = false,
	["fastSpeed"] = false,
	["fly"] = false,
	["flyLevel"] = 10,
	["antiKnockback"] = false,
	["noclip"] = false,
	["spin"] = false,
	["spy"] = false,
	["spyTarget"] = nil,
	["kill"] = {
		["auto"] = false,
		["karmaMode"] = nil,
		["protectFriends"] = false,
		["targetMode"] = false,
		["target"] = nil,
		["serverHop"] = false,
		["friendCache"] = {},
		["serverHistory"] = {},
		["serversVisited"] = 1,
		["hopNow"] = false,
		["noTargetsSince"] = nil,
		["lockCFrame"] = nil,
		["lockCharacter"] = nil,
	},
	["trade"] = { ["busy"] = false, ["requestGeneration"] = 0, ["delivered"] = 0, ["total"] = 0 },
	["rebirth"] = {
		["target"] = nil,
		["autoTarget"] = false,
		["infinite"] = false,
		["sizeOne"] = false,
		["fastWeight"] = false,
		["king"] = false,
		["lockPosition"] = false,
		["lockCFrame"] = nil,
		["ultimateRunning"] = false,
	},
}
if pState.resume and type(pState.resume.serverHistory) == "table" then
	pState.kill.serverHistory = pState.resume.serverHistory
end
if pState.resume then
	pState.kill.serversVisited = math.max(1, tonumber(pState.resume.serversVisited) or 1)
end
if game.JobId ~= "" and not table.find(pState.kill.serverHistory, game.JobId) then
	pState.kill.serverHistory[#pState.kill.serverHistory + 1] = game.JobId
end
option.RawExploitFG100Resume = nil
local frameData = {}
local valueData = {}
local data = {}
local tabsData = {}
local modeData = {}
local function handleFrame(frameArgument, ...)
	frameData[#frameData + 1] = frameArgument
	return frameArgument
end
local function handler(argument, ...)
	data[#data + 1] = argument
end
local function handleValue(valueText, ...)
	local valueCondition = valueData[valueText]
	if valueCondition then
		pcall(task.cancel, valueCondition)
		valueData[valueText] = nil
	end
end
local function handleSendGiftRemote(valueText, secondaryArgument, ...)
	handleValue(valueText)
	valueData[valueText] = task.spawn(function(...)
		pcall(secondaryArgument)
		valueData[valueText] = nil
	end)
	return valueData[valueText]
end
local function secondaryHandler(...)
	for index, item in ipairs(frameData) do
		pcall(function(...)
			item:Disconnect()
		end)
	end
	table.clear(frameData)
	for key in pairs(valueData) do
		handleValue(key)
	end
end
local function getValueCharacter(...)
	return backpackContainer.Character
end
local function isUseToolValid(...)
	local isUpdateValidFlag = getValueCharacter()
	return isUpdateValidFlag and isUpdateValidFlag:FindFirstChildWhichIsA("Humanoid")
end
local function isSendHitEventValid(...)
	local humanoidRootPartContainer = getValueCharacter()
	return humanoidRootPartContainer and humanoidRootPartContainer:FindFirstChild("HumanoidRootPart")
end
local function alternateHandler(searchableText, ...)
	searchableText = (tostring(searchableText or "")):lower()
	if searchableText == "" then
		return nil
	end
	for index, item in ipairs(players:GetPlayers()) do
		if item.Name:lower() == searchableText or item.DisplayName:lower() == searchableText then
			return item
		end
	end
	for index, item in ipairs(players:GetPlayers()) do
		if
			(item.Name:lower()):find(searchableText, 1, true)
			or (item.DisplayName:lower()):find(searchableText, 1, true)
		then
			return item
		end
	end
	return nil
end
local function handleIsValid(isValidFlag, data, ...)
	if not isValidFlag then
		return nil
	end
	local isValidData = {}
	for index, item in ipairs(data) do
		isValidData[(item:lower()):gsub("%s+", "")] = true
	end
	for index, item in ipairs(isValidFlag:GetChildren()) do
		local gsub = (item.Name:lower()):gsub("%s+", "")
		if isValidData[gsub] and item:IsA("ValueBase") then
			return item
		end
	end
	return nil
end
local function isUpdateInstancePropertiesValid(leaderstatsContainer, isValidData, ...)
	local option = leaderstatsContainer and leaderstatsContainer:FindFirstChild("leaderstats")
	return handleIsValid(option, isValidData) or handleIsValid(leaderstatsContainer, isValidData)
end
local function handleValueLabelText(numberText, ...)
	local number = tonumber(numberText) or 0
	local flag = number < 0
	local formatResult = string.format("%.0f", math.abs(number))
	local text = (((formatResult:reverse()):gsub("(%d%d%d)", "%1.")):reverse()):gsub("^%.", "")
	return (flag and "-" or "") .. text
end
local function secondaryHandleValueLabelText(number, ...)
	local numberText = tonumber(number) or 0
	return (numberText >= 0 and "+" or "") .. handleValueLabelText(numberText)
end
local function isSendGiftRemoteCachedPingValid(...)
	local success, result = pcall(function(...)
		return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	return success and math.floor((tonumber(result) or 0) + 0.5) or 0
end
local function clock(...)
	local success, result = pcall(workspace.GetServerTimeNow, workspace)
	if success and type(result) == "number" then
		return result
	end
	return os.clock()
end
local function additionalHandler(displayValue, ...)
	local option = getgenv and getgenv() or _G
	local secondaryOption = option.setclipboard or option.toclipboard or option.writeclipboard
	if type(secondaryOption) == "function" then
		pcall(secondaryOption, tostring(displayValue))
		return true
	end
	return false
end
local function useTool(useToolData, ...)
	local useToolFlag = getValueCharacter()
	local flag = isUseToolValid()
	if not useToolFlag or not flag then
		return nil
	end
	local lowerData = {}
	for index, item in ipairs(useToolData) do
		lowerData[item:lower()] = true
	end
	for index, item in ipairs({ useToolFlag, backpackContainer:FindFirstChild("Backpack") }) do
		if item then
			for index, item in ipairs(item:GetChildren()) do
				if item:IsA("Tool") and lowerData[item.Name:lower()] then
					if item.Parent ~= useToolFlag then
						flag:EquipTool(item)
					end
					return item
				end
			end
		end
	end
	return nil
end
local function secondaryUseTool(...)
	return useTool({ "Punch" })
end
local options = {}
local updateCFrameData = {}
local capturedRockGuiContainer = nil
local function secondaryHandleInstanceProperties(touchPartContainer, ...)
	if not touchPartContainer or updateCFrameData[touchPartContainer] then
		return
	end
	local touchPart = touchPartContainer:FindFirstChild("TouchPart")
	updateCFrameData[touchPartContainer] = {
		["rockCFrame"] = touchPartContainer.CFrame,
		["touchCFrame"] = touchPart and (touchPart:IsA("BasePart") and touchPart.CFrame) or nil,
	}
end
local function updateCFrame(touchPartContainer, ...)
	if not touchPartContainer or not touchPartContainer.Parent then
		return
	end
	local leftHandContainer = getValueCharacter()
	local updateCFrameCondition = leftHandContainer and leftHandContainer:FindFirstChild("LeftHand")
	local updateCFrameOption = leftHandContainer and leftHandContainer:FindFirstChild("RightHand")
	if type(firetouchinterest) == "function" then
		if updateCFrameOption then
			pcall(firetouchinterest, touchPartContainer, updateCFrameOption, 1)
		end
		if updateCFrameCondition then
			pcall(firetouchinterest, touchPartContainer, updateCFrameCondition, 1)
		end
	end
	local cFrameCondition = updateCFrameData[touchPartContainer]
	if cFrameCondition then
		pcall(function(...)
			touchPartContainer.CFrame = cFrameCondition.rockCFrame
			local touchPart = touchPartContainer:FindFirstChild("TouchPart")
			if touchPart and cFrameCondition.touchCFrame then
				touchPart.CFrame = cFrameCondition.touchCFrame
			end
		end)
	end
end
local function alternateHandleInstanceProperties(...)
	local capturedTouchPartContainer = capturedRockGuiContainer
	capturedRockGuiContainer = nil
	if capturedTouchPartContainer then
		updateCFrame(capturedTouchPartContainer)
	end
end
local function updateInstanceProperties(...)
	pState.rockGeneration = pState.rockGeneration + 1
	pState.selectedRock = nil
	pState.rockSessionStartedAt = nil
	alternateHandleInstanceProperties()
end
local function secondaryUpdateInstanceProperties(rockGuiContainer, updateInstancePropertiesFlag, ...)
	if not rockGuiContainer or not updateInstancePropertiesFlag then
		return
	end
	secondaryHandleInstanceProperties(rockGuiContainer)
	pcall(function(...)
		rockGuiContainer.Size = Vector3.new(2, 1, 1)
		rockGuiContainer.Transparency = 1
		rockGuiContainer.CanCollide = false
		if rockGuiContainer:FindFirstChild("rockGui") then
			for key, item in pairs(rockGuiContainer.rockGui:GetChildren()) do
				item.Visible = false
			end
		end
		for index, item in ipairs({ "rockEmitter", "hoopParticle", "lavaParticle" }) do
			if rockGuiContainer:FindFirstChild(item) then
				rockGuiContainer[item]:Destroy()
			end
		end
		rockGuiContainer.CFrame = updateInstancePropertiesFlag.CFrame
		local touchPart = rockGuiContainer:FindFirstChild("TouchPart")
		if touchPart then
			touchPart.CFrame = updateInstancePropertiesFlag.CFrame
		end
	end)
end
local function additionalHandleInstanceProperties(instancePropertiesArgument, ...)
	local instancePropertiesFlag = options[instancePropertiesArgument]
	if instancePropertiesFlag and instancePropertiesFlag.Parent then
		return instancePropertiesFlag
	end
	local machinesFolder = workspace:FindFirstChild("machinesFolder")
	if not machinesFolder then
		return nil
	end
	for key, item in pairs(machinesFolder:GetDescendants()) do
		if
			item.Name == "neededDurability"
			and (item:IsA("ValueBase") and tonumber(item.Value) == instancePropertiesArgument)
		then
			local touchPartContainer = item.Parent and item.Parent:FindFirstChild("Rock")
			if touchPartContainer and touchPartContainer:IsA("BasePart") then
				secondaryHandleInstanceProperties(touchPartContainer)
				options[instancePropertiesArgument] = touchPartContainer
				return touchPartContainer
			end
		end
	end
	return nil
end
local function fallbackHandleInstanceProperties(...)
	local selectedRock = pState.selectedRock
	local rockGeneration = pState.rockGeneration
	if not selectedRock then
		return
	end
	local durability = backpackContainer:FindFirstChild("Durability")
	if durability and tonumber(durability.Value) < selectedRock.durability then
		return
	end
	local leftHandContainer = getValueCharacter()
	local instancePropertiesOption = leftHandContainer and leftHandContainer:FindFirstChild("LeftHand")
	local instancePropertiesFlag = leftHandContainer and leftHandContainer:FindFirstChild("RightHand")
	if not instancePropertiesOption or not instancePropertiesFlag then
		return
	end
	local rockGuiContainer = additionalHandleInstanceProperties(selectedRock.durability)
	if not rockGuiContainer then
		return
	end
	if pState.rockGeneration ~= rockGeneration or pState.selectedRock ~= selectedRock then
		return
	end
	if capturedRockGuiContainer ~= rockGuiContainer then
		alternateHandleInstanceProperties()
		if pState.rockGeneration ~= rockGeneration or pState.selectedRock ~= selectedRock then
			return
		end
		capturedRockGuiContainer = rockGuiContainer
	end
	secondaryUpdateInstanceProperties(rockGuiContainer, instancePropertiesOption)
	if pState.rockGeneration ~= rockGeneration or pState.selectedRock ~= selectedRock then
		return
	end
	if type(firetouchinterest) == "function" then
		pcall(firetouchinterest, rockGuiContainer, instancePropertiesFlag, 0)
		if
			pState.rockGeneration ~= rockGeneration
			or pState.selectedRock ~= selectedRock
			or capturedRockGuiContainer ~= rockGuiContainer
		then
			pcall(firetouchinterest, rockGuiContainer, instancePropertiesFlag, 1)
			return
		end
		pcall(firetouchinterest, rockGuiContainer, instancePropertiesFlag, 1)
		if
			pState.rockGeneration ~= rockGeneration
			or pState.selectedRock ~= selectedRock
			or capturedRockGuiContainer ~= rockGuiContainer
		then
			return
		end
		pcall(firetouchinterest, rockGuiContainer, instancePropertiesOption, 0)
		if
			pState.rockGeneration ~= rockGeneration
			or pState.selectedRock ~= selectedRock
			or capturedRockGuiContainer ~= rockGuiContainer
		then
			pcall(firetouchinterest, rockGuiContainer, instancePropertiesOption, 1)
			return
		end
		pcall(firetouchinterest, rockGuiContainer, instancePropertiesOption, 1)
	end
	secondaryUseTool()
end
local function alternateUpdateInstanceProperties(updateInstancePropertiesFlag, ...)
	pState.fastPunch = updateInstancePropertiesFlag == true
	if not pState.fastPunch then
		updateInstanceProperties()
		handleValue("fastPunchEquip")
		handleValue("fastPunchHit")
		handleValue("fastPunchRock")
		pcall(function(...)
			local attackTimeContainer = getValueCharacter() and (getValueCharacter()):FindFirstChild("Punch")
			local updateInstancePropertiesCondition = attackTimeContainer
				and attackTimeContainer:FindFirstChild("attackTime")
			if updateInstancePropertiesCondition then
				updateInstancePropertiesCondition.Value = 0.3
			end
		end)
		return
	end
	handleSendGiftRemote("fastPunchEquip", function(...)
		while pState.running and pState.fastPunch do
			pcall(function(...)
				local attackTimeContainer = secondaryUseTool()
				if attackTimeContainer then
					local attackTime = attackTimeContainer:FindFirstChild("attackTime")
					if attackTime then
						attackTime.Value = 0
					end
				end
			end)
			task.wait(0.05)
		end
	end)
	handleSendGiftRemote("fastPunchHit", function(...)
		while pState.running and pState.fastPunch do
			local muscleEvent = backpackContainer:FindFirstChild("muscleEvent")
			local punchContainer = getValueCharacter()
			local updateInstancePropertiesCondition = punchContainer and punchContainer:FindFirstChild("Punch")
			if muscleEvent then
				pcall(muscleEvent.FireServer, muscleEvent, "punch", "rightHand")
				pcall(muscleEvent.FireServer, muscleEvent, "punch", "leftHand")
			end
			if updateInstancePropertiesCondition then
				pcall(updateInstancePropertiesCondition.Activate, updateInstancePropertiesCondition)
			end
			task.wait(0.01)
		end
	end)
	handleSendGiftRemote("fastPunchRock", function(...)
		while pState.running and pState.fastPunch do
			if pState.selectedRock then
				pcall(fallbackHandleInstanceProperties)
				local muscleEvent = backpackContainer:FindFirstChild("muscleEvent")
				if muscleEvent then
					pcall(muscleEvent.FireServer, muscleEvent, "punch", "rightHand")
					pcall(muscleEvent.FireServer, muscleEvent, "punch", "leftHand")
				end
			end
			task.wait()
		end
	end)
end
local updateValueData = {}
local function updateSendMuscleEvent(sendMuscleEventText, repTimeContainer, ...)
	if not repTimeContainer then
		return
	end
	local repTime = repTimeContainer:FindFirstChild("repTime")
	if not repTime or not repTime:IsA("ValueBase") then
		return
	end
	updateValueData[sendMuscleEventText] = updateValueData[sendMuscleEventText] or {}
	if updateValueData[sendMuscleEventText][repTime] == nil then
		updateValueData[sendMuscleEventText][repTime] = repTime.Value
	end
	repTime.Value = 0
end
local function updateValue(sendMuscleEventText, ...)
	local data = updateValueData[sendMuscleEventText]
	if not data then
		return
	end
	for key, value in pairs(data) do
		if key and key.Parent then
			pcall(function(...)
				key.Value = value
			end)
		end
	end
	updateValueData[sendMuscleEventText] = nil
end
local function handleSendMuscleEvent(data, ...)
	local flag = getValueCharacter()
	local parent = backpackContainer:FindFirstChild("Backpack")
	if not flag or not parent or not data then
		return
	end
	local lowerData = {}
	for index, item in ipairs(data) do
		lowerData[item:lower()] = true
	end
	for index, item in ipairs(flag:GetChildren()) do
		if item:IsA("Tool") and lowerData[item.Name:lower()] then
			pcall(function(...)
				item.Parent = parent
			end)
		end
	end
end
local function sendMuscleEvent(text, sendMuscleEventCondition, useToolData, sendMuscleEventFlag, ...)
	pState[text] = sendMuscleEventCondition == true
	local exerciseMovement = pState.exerciseMovement
	exerciseMovement.active[text] = pState[text] or nil
	local sendMuscleEventText = "rep_" .. text
	if not pState[text] then
		handleValue(sendMuscleEventText)
		updateValue(text)
		handleSendMuscleEvent(useToolData)
		local sendMuscleEventFlag = false
		for key in pairs(exerciseMovement.active) do
			sendMuscleEventFlag = true
			break
		end
		if not sendMuscleEventFlag then
			handleValue("exerciseMovement")
			local humanoid = exerciseMovement.humanoid
			if humanoid and humanoid.Parent then
				pcall(function(...)
					if not pState.fastSpeed and exerciseMovement.walkSpeed then
						humanoid.WalkSpeed = exerciseMovement.walkSpeed
					end
					if exerciseMovement.jumpValue then
						if exerciseMovement.usesJumpPower then
							humanoid.JumpPower = exerciseMovement.jumpValue
						else
							humanoid.JumpHeight = exerciseMovement.jumpValue
						end
					end
				end)
			end
			exerciseMovement.humanoid = nil
			exerciseMovement.walkSpeed = nil
			exerciseMovement.jumpValue = nil
		end
		return
	end
	local humanoid = isUseToolValid()
	if humanoid and exerciseMovement.humanoid ~= humanoid then
		exerciseMovement.humanoid = humanoid
		exerciseMovement.walkSpeed = humanoid.WalkSpeed > 0 and humanoid.WalkSpeed or 16
		exerciseMovement.usesJumpPower = humanoid.UseJumpPower
		exerciseMovement.jumpValue = exerciseMovement.usesJumpPower and humanoid.JumpPower or humanoid.JumpHeight
	end
	handleSendGiftRemote("exerciseMovement", function(...)
		while pState.running and next(exerciseMovement.active) do
			local humanoid = isUseToolValid()
			local anchoredCondition = isSendHitEventValid()
			if humanoid then
				if exerciseMovement.humanoid ~= humanoid then
					exerciseMovement.humanoid = humanoid
					exerciseMovement.walkSpeed = humanoid.WalkSpeed > 0 and humanoid.WalkSpeed or 16
					exerciseMovement.usesJumpPower = humanoid.UseJumpPower
					exerciseMovement.jumpValue = exerciseMovement.usesJumpPower and humanoid.JumpPower
						or humanoid.JumpHeight
				end
				if not pState.machine and not pState.fly then
					if anchoredCondition then
						anchoredCondition.Anchored = false
					end
					humanoid.PlatformStand = false
					humanoid.Sit = false
					local walkSpeed = pState.fastSpeed and 1000 or exerciseMovement.walkSpeed
					if walkSpeed and humanoid.WalkSpeed < walkSpeed then
						humanoid.WalkSpeed = walkSpeed
					end
					if exerciseMovement.jumpValue then
						if exerciseMovement.usesJumpPower and humanoid.JumpPower < exerciseMovement.jumpValue then
							humanoid.JumpPower = exerciseMovement.jumpValue
						elseif
							not exerciseMovement.usesJumpPower and humanoid.JumpHeight < exerciseMovement.jumpValue
						then
							humanoid.JumpHeight = exerciseMovement.jumpValue
						end
					end
				end
			end
			runService.Heartbeat:Wait()
		end
	end)
	handleSendGiftRemote(sendMuscleEventText, function(...)
		while pState.running and pState[text] do
			pcall(function(...)
				local repTimeContainer
				if useToolData and #useToolData > 0 then
					repTimeContainer = useTool(useToolData)
					updateSendMuscleEvent(text, repTimeContainer)
				end
				local muscleEvent = backpackContainer:FindFirstChild("muscleEvent")
				if muscleEvent then
					muscleEvent:FireServer("rep")
				end
				if repTimeContainer then
					repTimeContainer:Activate()
				end
			end)
			task.wait(sendMuscleEventFlag or 0.01)
		end
	end)
end
pState.eatProteinEgg = function(...)
	local parent = getValueCharacter()
	local backpack = backpackContainer:FindFirstChild("Backpack")
	local rEvents = replicatedStorage:FindFirstChild("rEvents")
	for index, item in ipairs({ backpack, parent, backpackContainer:FindFirstChild("consumablesFolder") }) do
		if item then
			for index, secondaryItem in ipairs(public.AutoEgg.Names) do
				local firstChild = item:FindFirstChild(secondaryItem)
				if firstChild then
					pcall(function(...)
						local remoteEvent = rEvents and rEvents:FindFirstChild("eatEvent")
						if remoteEvent then
							remoteEvent:FireServer("eat", firstChild)
						end
					end)
					pcall(function(...)
						if backpack and (parent and firstChild.Parent == backpack) then
							firstChild.Parent = parent
							task.wait(0.05)
						end
						if firstChild.Activate then
							firstChild:Activate()
						end
					end)
					return true
				end
			end
		end
	end
	return false
end
do
	local function isValid(isValidText, ...)
		isValidText = tostring(isValidText or "")
		local isValidNumber = tonumber(isValidText:match("(%d+)%s*[hH]")) or 0
		local number = tonumber(isValidText:match("(%d+)%s*[mM]")) or 0
		local isValidOption = tonumber(isValidText:match("(%d+)%s*[sS]")) or 0
		local sum = (isValidNumber * 3600 + number * 60) + isValidOption
		return sum > 0 and sum or nil
	end
	local function handler(...)
		for index, item in ipairs(parent:GetDescendants()) do
			if item:IsA("TextLabel") or item:IsA("TextButton") then
				local text = tostring(item.Text or "")
				local lower = text:lower()
				local condition = (lower:find("fuerza", 1, true) or lower:find("strength", 1, true))
					and (lower:find("x2", 1, true) or lower:find("2x", 1, true))
				if condition then
					local parent = item.Parent
					for index = 1, 4, 1 do
						if not parent then
							break
						end
						for index, item in ipairs(parent:GetDescendants()) do
							if item:IsA("TextLabel") or item:IsA("TextButton") then
								local condition = isValid(item.Text)
								if condition then
									return condition
								end
							end
						end
						parent = parent.Parent
					end
				end
			end
		end
		for index, item in ipairs(backpackContainer:GetDescendants()) do
			if item:IsA("ValueBase") then
				local lower = item.Name:lower()
				if
					lower:find("strength", 1, true) and (lower:find("boost", 1, true) or lower:find("timer", 1, true))
				then
					local number = tonumber(item.Value)
					if number and (number > 0 and number <= public.AutoEgg.Interval) then
						return number
					end
				end
			end
		end
		return 0
	end
	pState.autoEggSources = { ["manual"] = false, ["fastFarm"] = false, ["rebirth"] = false }
	pState.autoEggNextAt = 0
	pState.setAutoEgg = function(argument, option, ...)
		option = option or "manual"
		pState.autoEggSources[option] = argument == true
		local autoEgg = false
		for key, item in pairs(pState.autoEggSources) do
			if item then
				autoEgg = true
				break
			end
		end
		if pState.autoEgg == autoEgg then
			return
		end
		pState.autoEgg = autoEgg
		if not autoEgg then
			handleValue("autoEgg")
			return
		end
		handleSendGiftRemote("autoEgg", function(...)
			while pState.running and pState.autoEgg do
				local autoEggNextAtNumber = time()
				local number = handler()
				if number > 0 then
					pState.autoEggNextAt = math.max(pState.autoEggNextAt, autoEggNextAtNumber + number)
				end
				if autoEggNextAtNumber >= pState.autoEggNextAt then
					if pState.eatProteinEgg() then
						pState.autoEggNextAt = autoEggNextAtNumber + public.AutoEgg.Interval
					else
						pState.autoEggNextAt = autoEggNextAtNumber + 10
					end
				end
				task.wait(1)
			end
		end)
	end
end
local createNameFlag = false
local function createName(...)
	local parent = backpackContainer:FindFirstChild("ownedGamepasses")
	local gamepassIds = replicatedStorage:FindFirstChild("gamepassIds")
	if not parent or not gamepassIds then
		return false
	end
	for index, item in ipairs(gamepassIds:GetChildren()) do
		if item:IsA("ValueBase") and not parent:FindFirstChild(item.Name) then
			local intValue = Instance.new("IntValue")
			intValue.Name = item.Name
			intValue.Value = tonumber(item.Value) or 0
			intValue.Parent = parent
		end
	end
	createNameFlag = true
	return true
end
local updateVisibleData = {}
local connection = nil
local secondaryUpdateVisibleData = {}
local secondaryData = {}
local function updateVisible(updateVisibleFlag, ...)
	if
		updateVisibleFlag
		and (
			updateVisibleFlag:IsA("GuiObject")
			and (updateVisibleFlag.Name == "durabilityFrame" and secondaryUpdateVisibleData[updateVisibleFlag] == nil)
		)
	then
		secondaryUpdateVisibleData[updateVisibleFlag] = updateVisibleFlag.Visible
		updateVisibleFlag.Visible = false
	end
end
local function updateChildAddedConnection(argument, ...)
	pState.hideDurability = argument == true
	for index, item in ipairs(secondaryData) do
		item:Disconnect()
	end
	table.clear(secondaryData)
	if pState.hideDurability then
		for index, item in ipairs(replicatedStorage:GetChildren()) do
			pcall(updateVisible, item)
		end
		for index, item in ipairs(parent:GetDescendants()) do
			pcall(updateVisible, item)
		end
		secondaryData[#secondaryData + 1] = replicatedStorage.ChildAdded:Connect(function(argument, ...)
			if pState.hideDurability then
				task.defer(updateVisible, argument)
			end
		end)
		secondaryData[#secondaryData + 1] = parent.DescendantAdded:Connect(function(argument, ...)
			if pState.hideDurability then
				task.defer(updateVisible, argument)
			end
		end)
	else
		for key, visible in pairs(secondaryUpdateVisibleData) do
			if key and key.Parent then
				pcall(function(...)
					key.Visible = visible
				end)
			end
		end
		table.clear(secondaryUpdateVisibleData)
	end
end
local function taskCallback(instance, ...)
	if
		instance.Parent == replicatedStorage
		and (
			instance:IsA("GuiObject")
			and ((instance.Name:lower()):match("frame$") and updateVisibleData[instance] == nil)
		)
	then
		updateVisibleData[instance] = instance.Visible
		instance.Visible = false
	end
end
local function secondaryUpdateChildAddedConnection(argument, ...)
	pState.hideFrames = argument == true
	if connection then
		connection:Disconnect()
		connection = nil
	end
	if pState.hideFrames then
		for index, item in ipairs(replicatedStorage:GetChildren()) do
			pcall(taskCallback, item)
		end
		connection = replicatedStorage.ChildAdded:Connect(function(argument, ...)
			if pState.hideFrames then
				task.defer(taskCallback, argument)
			end
		end)
	else
		for key, visible in pairs(updateVisibleData) do
			if key and key.Parent then
				pcall(function(...)
					key.Visible = visible
				end)
			end
		end
		table.clear(updateVisibleData)
	end
end
local updateInstancePropertiesNumber = 0
local function fallbackHandler(...)
	pcall(function(...)
		virtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
		task.wait(0.045)
		virtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
	end)
end
local function sendMachineInteractRemote(machine, ...)
	local instance = isSendHitEventValid()
	local flag = isUseToolValid()
	if not instance or not flag then
		return false
	end
	local machinesFolder = workspace:FindFirstChild("machinesFolder")
	local interactSeatContainer = machinesFolder and machinesFolder:FindFirstChild(machine.object)
	local cFrameOption = interactSeatContainer and interactSeatContainer:FindFirstChild("interactSeat", true)
	if machine.object == "Jungle Squat" and (cFrameOption and cFrameOption:IsA("BasePart")) then
		instance.CFrame = cFrameOption.CFrame * CFrame.new(0, 2.25, 0)
	else
		instance.CFrame = machine.fallback
	end
	task.wait(0.22)
	fallbackHandler()
	task.wait(0.45)
	if cFrameOption and not flag.SeatPart then
		pcall(function(...)
			replicatedStorage.rEvents.machineInteractRemote:InvokeServer("useMachine", cFrameOption)
		end)
	end
	return true
end
local function additionalUpdateInstanceProperties(secondaryMachine, updateInstancePropertiesFlag, ...)
	local machine = pState.machine
	updateInstancePropertiesNumber = updateInstancePropertiesNumber + 1
	local capturedSum = updateInstancePropertiesNumber
	handleValue("machine")
	if not updateInstancePropertiesFlag then
		pState.machine = nil
		local updateInstancePropertiesFlag = isUseToolValid()
		if updateInstancePropertiesFlag and updateInstancePropertiesFlag.SeatPart then
			updateInstancePropertiesFlag.Sit = false
			updateInstancePropertiesFlag:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		return
	end
	pState.machine = secondaryMachine
	handleSendGiftRemote("machine", function(...)
		if machine and machine ~= secondaryMachine then
			local updateInstancePropertiesCondition = isUseToolValid()
			if updateInstancePropertiesCondition then
				updateInstancePropertiesCondition.Sit = false
				updateInstancePropertiesCondition:ChangeState(Enum.HumanoidStateType.Jumping)
			end
			for index = 1, 30, 1 do
				if
					not pState.running
					or pState.machine ~= secondaryMachine
					or updateInstancePropertiesNumber ~= capturedSum
				then
					return
				end
				task.wait(0.1)
			end
		end
		sendMachineInteractRemote(secondaryMachine)
		while
			pState.running and (pState.machine == secondaryMachine and updateInstancePropertiesNumber == capturedSum)
		do
			local updateInstancePropertiesFlag = isUseToolValid()
			local input = isSendHitEventValid()
			local machinesFolder = workspace:FindFirstChild("machinesFolder")
			local interactSeatContainer = machinesFolder and machinesFolder:FindFirstChild(secondaryMachine.object)
			local updateInstancePropertiesOption = interactSeatContainer
				and interactSeatContainer:FindFirstChild("interactSeat", true)
			local flag = not updateInstancePropertiesFlag or not updateInstancePropertiesFlag.SeatPart
			if
				updateInstancePropertiesOption
				and (input and (input.Position - updateInstancePropertiesOption.Position).Magnitude > 14)
			then
				flag = true
			end
			if flag then
				sendMachineInteractRemote(secondaryMachine)
			end
			task.wait(3.1)
		end
	end)
end
do
	modeData.generation = 0
	modeData.warningAccepted = false
	modeData.mode = nil
	modeData.startedAt = nil
	modeData.startStats = nil
	modeData.lockCFrame = nil
	modeData.lockCharacter = nil
	modeData.hideFramesOwned = false
	modeData.packCount = 0
	modeData.cachedPing = 0
	modeData.pingCheckedAt = 0
	modeData.pingPaused = false
	modeData.resumeSamples = 0
	modeData.strengthBatch = public.FastFarm.StrengthStartBatch
	modeData.lastBatchAdjust = 0
	modeData.sizeInvokeBusy = false
	modeData.lastSizeInvoke = 0
	modeData.sizeReleaseGeneration = 0
	modeData.frameReleaseGeneration = 0
	local function handleStartStats(isStartStatsValidData, ...)
		local startStatsFlag = isUpdateInstancePropertiesValid(backpackContainer, isStartStatsValidData)
		return startStatsFlag and tonumber(startStatsFlag.Value) or 0, startStatsFlag
	end
	local function handler(...)
		local startStatsResult = handleStartStats({ "Rebirths", "Rebirth" })
		local secondaryStartStatsResult = handleStartStats({ "Strength", "Fuerza" })
		local alternateStartStatsResult = handleStartStats({ "Durability", "Resistencia" })
		return {
			["rebirths"] = startStatsResult,
			["strength"] = secondaryStartStatsResult,
			["durability"] = alternateStartStatsResult,
		}
	end
	local function findFirstChild(...)
		return replicatedStorage:FindFirstChild("rEvents")
	end
	local function secondaryHandler(...)
		local equipPetEventContainer = findFirstChild()
		local option = equipPetEventContainer and equipPetEventContainer:FindFirstChild("equipPetEvent")
		local petsFolder = backpackContainer:FindFirstChild("petsFolder")
		if not option or not petsFolder then
			return
		end
		for index, item in ipairs(petsFolder:GetChildren()) do
			if item:IsA("Folder") then
				for index, item in ipairs(item:GetChildren()) do
					pcall(option.FireServer, option, "unequipPet", item)
				end
			end
		end
		task.wait(0.035)
	end
	local function handlePackCount(packCountArgument, ...)
		local equipPetEventContainer = findFirstChild()
		local packCountOption = equipPetEventContainer and equipPetEventContainer:FindFirstChild("equipPetEvent")
		local petsFolder = backpackContainer:FindFirstChild("petsFolder")
		if not packCountOption or not petsFolder then
			return 0
		end
		local packCountNumber = 0
		for index, item in ipairs(petsFolder:GetChildren()) do
			if item:IsA("Folder") then
				for index, item in ipairs(item:GetChildren()) do
					if item.Name == packCountArgument then
						pcall(packCountOption.FireServer, packCountOption, "equipPet", item)
						packCountNumber = packCountNumber + 1
						if packCountNumber >= public.FastFarm.MaxPets then
							return packCountNumber
						end
					end
				end
			end
		end
		return packCountNumber
	end
	local function handleInstanceProperties(instancePropertiesFlag, ...)
		local muscleEvent = backpackContainer:FindFirstChild("muscleEvent")
		if not muscleEvent then
			return false
		end
		for index = 1, instancePropertiesFlag or public.FastFarm.RepsPerCycle, 1 do
			pcall(muscleEvent.FireServer, muscleEvent, "rep")
		end
		return true
	end
	local function updateInstanceProperties(updateInstancePropertiesArgument, ...)
		local pingCheckedAt = time()
		local updateInstancePropertiesFlag = false
		if pingCheckedAt - modeData.pingCheckedAt >= 0.25 then
			modeData.cachedPing = isSendGiftRemoteCachedPingValid()
			modeData.pingCheckedAt = pingCheckedAt
			updateInstancePropertiesFlag = true
		end
		local cachedPing = modeData.cachedPing
		if not modeData.pingPaused and cachedPing >= public.FastFarm.PingPause then
			modeData.pingPaused = true
			modeData.resumeSamples = 0
			modeData.strengthBatch = public.FastFarm.StrengthStartBatch
			modeData.lastBatchAdjust = pingCheckedAt
		end
		if modeData.pingPaused then
			if updateInstancePropertiesFlag then
				if cachedPing <= public.FastFarm.PingResume then
					modeData.resumeSamples = modeData.resumeSamples + 1
				else
					modeData.resumeSamples = 0
				end
				if modeData.resumeSamples >= 4 then
					modeData.pingPaused = false
					modeData.resumeSamples = 0
				end
			end
			if modeData.pingPaused then
				return 0.25, false
			end
		end
		if updateInstancePropertiesArgument == "strength" then
			if updateInstancePropertiesFlag then
				if cachedPing >= public.FastFarm.PingSoft and pingCheckedAt - modeData.lastBatchAdjust >= 0.75 then
					modeData.strengthBatch = math.max(public.FastFarm.StrengthStartBatch, modeData.strengthBatch - 4)
					modeData.lastBatchAdjust = pingCheckedAt
				elseif
					cachedPing <= public.FastFarm.StrengthRampPing
					and pingCheckedAt - modeData.lastBatchAdjust >= public.FastFarm.StrengthRampInterval
				then
					modeData.strengthBatch = math.min(public.FastFarm.StrengthMaxBatch, modeData.strengthBatch + 2)
					modeData.lastBatchAdjust = pingCheckedAt
				end
			end
			if cachedPing >= public.FastFarm.PingCritical then
				handleInstanceProperties(2)
				return 0.2, true
			elseif cachedPing >= public.FastFarm.PingHigh then
				handleInstanceProperties(3)
				return 0.13, true
			elseif cachedPing >= public.FastFarm.PingMedium then
				handleInstanceProperties(math.max(4, math.floor(modeData.strengthBatch * 0.3)))
				return 0.07, true
			elseif cachedPing >= public.FastFarm.PingSoft then
				handleInstanceProperties(math.max(6, math.floor(modeData.strengthBatch * 0.5)))
				return 0.04, true
			end
			handleInstanceProperties(modeData.strengthBatch)
			return public.FastFarm.StrengthDelay, true
		end
		if cachedPing >= public.FastFarm.PingCritical then
			return 0.7, true
		elseif cachedPing >= public.FastFarm.PingHigh then
			handleInstanceProperties(10)
			return 0.18, true
		elseif cachedPing >= public.FastFarm.PingMedium then
			handleInstanceProperties(24)
			return 0.075, true
		elseif cachedPing >= public.FastFarm.PingSoft then
			handleInstanceProperties(45)
			return 0.025, true
		end
		handleInstanceProperties(public.FastFarm.RepsPerCycle)
		return public.FastFarm.RepDelay, true
	end
	local function isFloorValid(...)
		local ultimatesFolder = backpackContainer:FindFirstChild("ultimatesFolder")
		local isFloorValidOption = ultimatesFolder and ultimatesFolder:FindFirstChild("Golden Rebirth")
		return isFloorValidOption and tonumber(isFloorValidOption.Value) or 0
	end
	local function floor(numberText, ...)
		local sum = 10000 + 5000 * (tonumber(numberText) or 0)
		local floorNumber = isFloorValid()
		if floorNumber >= 1 and floorNumber <= 5 then
			sum = sum * (1 - floorNumber * 0.1)
		end
		return math.floor(sum)
	end
	local function alternateHandler(...)
		local rebirthRemoteContainer = findFirstChild()
		local condition = rebirthRemoteContainer and rebirthRemoteContainer:FindFirstChild("rebirthRemote")
		if condition then
			pcall(condition.InvokeServer, condition, "rebirthRequest")
		end
	end
	local function updateSizeOne(...)
		local updateSizeOneFlag = isUseToolValid()
		if not updateSizeOneFlag then
			return
		end
		for index, item in ipairs({ "BodyDepthScale", "BodyHeightScale", "BodyWidthScale", "HeadScale" }) do
			local firstChild = updateSizeOneFlag:FindFirstChild(item)
			if firstChild and firstChild:IsA("NumberValue") then
				pcall(function(...)
					firstChild.Value = 1
				end)
			end
		end
	end
	local function setSizeOne(...)
		updateSizeOne()
		local lastSizeInvoke = time()
		if modeData.sizeInvokeBusy or lastSizeInvoke - modeData.lastSizeInvoke < public.FastFarm.SizeInvokeInterval then
			return
		end
		local changeSpeedSizeRemoteContainer = findFirstChild()
		local setSizeOneCondition = changeSpeedSizeRemoteContainer
			and changeSpeedSizeRemoteContainer:FindFirstChild("changeSpeedSizeRemote")
		if setSizeOneCondition then
			modeData.sizeInvokeBusy = true
			modeData.lastSizeInvoke = lastSizeInvoke
			task.spawn(function(...)
				pcall(setSizeOneCondition.InvokeServer, setSizeOneCondition, "changeSize", 1)
				modeData.sizeInvokeBusy = false
			end)
		end
	end
	modeData.SetSizeOne = setSizeOne
	local function updateSizeReleaseGeneration(flag, ...)
		modeData.sizeReleaseGeneration = modeData.sizeReleaseGeneration + 1
		local sizeReleaseGeneration = modeData.sizeReleaseGeneration
		task.spawn(function(...)
			local sum = time() + (flag or public.FastFarm.SizeReleaseDuration)
			while
				pState.running
				and (
					modeData.mode == nil and (modeData.sizeReleaseGeneration == sizeReleaseGeneration and time() < sum)
				)
			do
				setSizeOne()
				task.wait(0.1)
			end
		end)
	end
	local function secondaryHandleInstanceProperties(instancePropertiesArgument, ...)
		for index, item in ipairs(public.Machines) do
			if item.object == instancePropertiesArgument then
				return item
			end
		end
		return nil
	end
	local function secondaryUpdateInstanceProperties(generation, ...)
		local updateInstancePropertiesFlag = secondaryHandleInstanceProperties("Jungle Bar Lift")
		if not updateInstancePropertiesFlag then
			return false
		end
		for index = 1, 3, 1 do
			if modeData.generation ~= generation or modeData.mode ~= "rebirth" then
				return false
			end
			sendMachineInteractRemote(updateInstancePropertiesFlag)
			local updateInstancePropertiesNumber = time() + 1.4
			repeat
				local updateInstancePropertiesFlag = isUseToolValid()
				if updateInstancePropertiesFlag and updateInstancePropertiesFlag.SeatPart then
					local updateInstancePropertiesCondition = isSendHitEventValid()
					if updateInstancePropertiesCondition then
						modeData.lockCharacter = getValueCharacter()
						modeData.lockCFrame = updateInstancePropertiesCondition.CFrame
						return true
					end
				end
				task.wait(0.08)
			until time() >= updateInstancePropertiesNumber
		end
		local input = isSendHitEventValid()
		if input and (input.Position - updateInstancePropertiesFlag.fallback.Position).Magnitude <= 20 then
			modeData.lockCharacter = getValueCharacter()
			modeData.lockCFrame = input.CFrame
			return true
		end
		return false
	end
	local function sendHitEvent(...)
		setSizeOne()
		local firstChild = workspace:FindFirstChild(public.FastFarm.RockName)
		local sendHitEventFlag = isSendHitEventValid()
		local hitEventContainer = findFirstChild()
		local remoteEvent = hitEventContainer and hitEventContainer:FindFirstChild("hitEvent")
		if firstChild and (sendHitEventFlag and remoteEvent) then
			pcall(function(...)
				sendHitEventFlag.CFrame = firstChild.CFrame * CFrame.new(0, 0, -5)
				remoteEvent:FireServer("hit", firstChild)
			end)
			task.delay(0.08, setSizeOne)
		end
	end
	local function additionalHandler(argument, ...)
		if modeData.HideFramesToggle then
			modeData.HideFramesToggle:Set(argument)
		else
			secondaryUpdateChildAddedConnection(argument)
		end
	end
	local function fallbackHandler(...)
		for index, item in ipairs(modeData.RepToggles or {}) do
			item:Set(false)
		end
		for index, item in ipairs(modeData.MachineToggles or {}) do
			item:Set(false)
		end
	end
	function modeData.ReadStats(argument, ...)
		return handler()
	end
	function modeData.FormatCompact(argument, numberText, ...)
		local number = tonumber(numberText) or 0
		local expectedMembership = math.abs(number)
		local data = {
			{ 1e+18, "Qi" },
			{ 1e+15, "Qa" },
			{ 1000000000000, "T" },
			{ 1000000000, "B" },
			{ 1000000, "M" },
			{ 1000, "K" },
		}
		for index, item in ipairs(data) do
			if expectedMembership >= item[1] then
				return string.format("%.2f%s", number / item[1], item[2])
			end
		end
		return handleValueLabelText(number)
	end
	function modeData.Stop(self, flag, ...)
		local isMode = self.mode ~= nil
		self.generation = self.generation + 1
		self.mode = nil
		pState.fastFarmMode = nil
		self.lockCFrame = nil
		self.lockCharacter = nil
		self.startedAt = nil
		self.startStats = nil
		for index, item in ipairs({
			"fastFarmSize",
			"fastFarmLock",
			"fastFarmMachine",
			"fastFarmRebirth",
			"fastFarmStrength",
		}) do
			handleValue(item)
		end
		local sitFlag = isUseToolValid()
		if sitFlag and sitFlag.SeatPart then
			sitFlag.Sit = false
			sitFlag:ChangeState(Enum.HumanoidStateType.Jumping)
		end
		if isMode then
			updateSizeReleaseGeneration(public.FastFarm.SizeReleaseDuration)
			pState.setAutoEgg(false, "fastFarm")
		end
		if flag and self.hideFramesOwned then
			self.frameReleaseGeneration = self.frameReleaseGeneration + 1
			local frameReleaseGeneration = self.frameReleaseGeneration
			task.delay(public.FastFarm.FramesReleaseDuration, function(...)
				if
					pState.running
					and (
						self.mode == nil
						and (self.frameReleaseGeneration == frameReleaseGeneration and self.hideFramesOwned)
					)
				then
					additionalHandler(false)
					self.hideFramesOwned = false
				end
			end)
		end
	end
	function modeData.Start(self, mode, ...)
		if mode ~= "rebirth" and mode ~= "strength" then
			return false
		end
		if self.mode == mode then
			return true
		end
		self:Stop(false)
		self.frameReleaseGeneration = self.frameReleaseGeneration + 1
		self.sizeReleaseGeneration = self.sizeReleaseGeneration + 1
		fallbackHandler()
		self.mode = mode
		pState.fastFarmMode = mode
		self.generation = self.generation + 1
		local generation = self.generation
		self.startedAt = mode == "rebirth" and clock() or nil
		self.startStats = mode == "rebirth" and handler() or nil
		self.packCount = 0
		self.cachedPing = isSendGiftRemoteCachedPingValid()
		self.pingCheckedAt = time()
		self.pingPaused = false
		self.resumeSamples = 0
		self.strengthBatch = public.FastFarm.StrengthStartBatch
		self.lastBatchAdjust = time()
		if not pState.hideFrames then
			self.hideFramesOwned = true
		end
		additionalHandler(true)
		pState.setAutoEgg(true, "fastFarm")
		setSizeOne()
		handleSendGiftRemote("fastFarmSize", function(...)
			while pState.running and (self.mode == mode and self.generation == generation) do
				setSizeOne()
				task.wait(0.1)
			end
		end)
		if mode == "rebirth" then
			handleSendGiftRemote("fastFarmLock", function(...)
				while pState.running and (self.mode == mode and self.generation == generation) do
					local instance = isSendHitEventValid()
					if instance and (self.lockCFrame and self.lockCharacter == getValueCharacter()) then
						instance.CFrame = self.lockCFrame
						instance.AssemblyLinearVelocity = Vector3.zero
						instance.AssemblyAngularVelocity = Vector3.zero
					end
					runService.Heartbeat:Wait()
				end
			end)
			handleSendGiftRemote("fastFarmMachine", function(...)
				while pState.running and (self.mode == mode and self.generation == generation) do
					if not self.lockCFrame or self.lockCharacter ~= getValueCharacter() then
						self.lockCFrame = nil
						secondaryUpdateInstanceProperties(generation)
					end
					task.wait(0.8)
				end
			end)
			handleSendGiftRemote("fastFarmRebirth", function(...)
				while self.mode == mode and (self.generation == generation and not self.lockCFrame) do
					task.wait(0.1)
				end
				while pState.running and (self.mode == mode and self.generation == generation) do
					while self.mode == mode and (self.generation == generation and not self.lockCFrame) do
						task.wait(0.1)
					end
					if self.mode ~= mode or self.generation ~= generation then
						break
					end
					local number = time()
					local numberText, flag = handleStartStats({ "Rebirths", "Rebirth" })
					local result, valueFlag = handleStartStats({ "Strength", "Fuerza" })
					local secondaryResult = floor(numberText)
					secondaryHandler()
					self.packCount = handlePackCount(public.FastFarm.StrengthPet)
					while
						pState.running
						and (
							self.mode == mode
							and (
								self.generation == generation
								and (valueFlag and tonumber(valueFlag.Value) < secondaryResult)
							)
						)
					do
						local result = updateInstanceProperties("rebirth")
						task.wait(result)
					end
					if self.mode == mode and self.generation == generation then
						secondaryHandler()
						self.packCount = handlePackCount(public.FastFarm.RebirthPet)
						local option = flag and tonumber(flag.Value) or numberText
						local number = time()
						repeat
							alternateHandler()
							task.wait(0.025)
						until self.mode ~= mode
							or self.generation ~= generation
							or flag and tonumber(flag.Value) > option
							or time() - number >= public.FastFarm.RebirthRequestWindow
					end
					local difference = public.FastFarm.RebirthCycleDelay - (time() - number)
					task.wait(math.max(difference, 0))
				end
			end)
		else
			handleSendGiftRemote("fastFarmStrength", function(...)
				setSizeOne()
				task.wait(0.3)
				secondaryHandler()
				self.packCount = handlePackCount(public.FastFarm.StrengthPet)
				local startStats = handler()
				local condition = secondaryHandleInstanceProperties("Jungle Bench")
				if condition then
					sendMachineInteractRemote(condition)
					setSizeOne()
				end
				local number = 0
				local secondaryNumber = 0
				local timeResult = time()
				local result = getValueCharacter()
				while pState.running and (self.mode == mode and self.generation == generation) do
					if result ~= getValueCharacter() then
						result = getValueCharacter()
						self.startedAt = nil
						self.startStats = nil
						setSizeOne()
						task.wait(0.3)
						secondaryHandler()
						self.packCount = handlePackCount(public.FastFarm.StrengthPet)
						startStats = handler()
						if condition then
							sendMachineInteractRemote(condition)
							setSizeOne()
							timeResult = time()
						end
					end
					if not self.startedAt and (condition and time() - timeResult >= 3.2) then
						setSizeOne()
						sendMachineInteractRemote(condition)
						setSizeOne()
						timeResult = time()
					end
					local secondaryResult, flag = updateInstanceProperties("strength")
					if flag and time() - number >= public.FastFarm.RockInterval then
						sendHitEvent()
						number = time()
					end
					if not self.startedAt and time() - secondaryNumber >= 0.15 then
						secondaryNumber = time()
						local strengthResult = handler()
						if strengthResult.strength > startStats.strength then
							self.startedAt = clock()
							self.startStats = startStats
						end
					end
					task.wait(secondaryResult)
				end
			end)
		end
		return true
	end
end
local updateInstancePropertiesData = {}
local secondaryConnection = nil
local handleInstanceProperties = function(...) end
local effectSettings = nil
local qualityLevel = nil
local function nestedHandler(data, secondaryArgument, ...)
	updateInstancePropertiesData[data] = updateInstancePropertiesData[data] or {}
	if updateInstancePropertiesData[data][secondaryArgument] == nil then
		local success, result = pcall(function(...)
			return data[secondaryArgument]
		end)
		if success then
			updateInstancePropertiesData[data][secondaryArgument] = result
		end
	end
end
local function innerHandler(terrain, secondaryArgument, tertiaryArgument, ...)
	nestedHandler(terrain, secondaryArgument)
	pcall(function(...)
		terrain[secondaryArgument] = tertiaryArgument
	end)
end
local function outerHandler(terrain, ...)
	if terrain:IsA("BasePart") then
		innerHandler(terrain, "Material", Enum.Material.SmoothPlastic)
		innerHandler(terrain, "Reflectance", 0)
		innerHandler(terrain, "CastShadow", false)
		if terrain:IsA("MeshPart") then
			innerHandler(terrain, "TextureID", "")
		end
	elseif terrain:IsA("Decal") or terrain:IsA("Texture") then
		innerHandler(terrain, "Transparency", 1)
	elseif
		terrain:IsA("ParticleEmitter")
		or terrain:IsA("Trail")
		or terrain:IsA("Beam")
		or terrain:IsA("Smoke")
		or terrain:IsA("Fire")
		or terrain:IsA("Sparkles")
	then
		innerHandler(terrain, "Enabled", false)
	elseif terrain:IsA("PointLight") or terrain:IsA("SpotLight") or terrain:IsA("SurfaceLight") then
		innerHandler(terrain, "Enabled", false)
	elseif
		terrain:IsA("BloomEffect")
		or terrain:IsA("BlurEffect")
		or terrain:IsA("ColorCorrectionEffect")
		or terrain:IsA("DepthOfFieldEffect")
		or terrain:IsA("SunRaysEffect")
	then
		innerHandler(terrain, "Enabled", false)
	elseif terrain:IsA("Explosion") then
		innerHandler(terrain, "BlastPressure", 0)
		innerHandler(terrain, "BlastRadius", 0)
	end
end
local function fallbackUpdateInstanceProperties(antiLagGeneration, updateInstancePropertiesFlag, ...)
	local updateInstancePropertiesNumber = 0
	for key, item in pairs(updateInstancePropertiesData) do
		if pState.antiLagGeneration ~= antiLagGeneration then
			return false
		end
		if key and key.Parent then
			for secondaryKey, item in pairs(item) do
				pcall(function(...)
					key[secondaryKey] = item
				end)
			end
		end
		updateInstancePropertiesNumber = updateInstancePropertiesNumber + 1
		if updateInstancePropertiesFlag and updateInstancePropertiesNumber % 260 == 0 then
			runService.Heartbeat:Wait()
		end
	end
	updateInstancePropertiesData = {}
	if effectSettings then
		lighting.GlobalShadows = effectSettings.GlobalShadows
		lighting.FogEnd = effectSettings.FogEnd
		lighting.Brightness = effectSettings.Brightness
	end
	pcall(function(...)
		if qualityLevel then
			(settings()).Rendering.QualityLevel = qualityLevel
		end
	end)
	handleInstanceProperties("Desactivado")
	return true
end
local function updateDescendantAddedConnection(argument, condition, ...)
	pState.antiLag = argument == true
	pState.antiLagGeneration = pState.antiLagGeneration + 1
	local antiLagGeneration = pState.antiLagGeneration
	handleValue("antiLag")
	if secondaryConnection then
		secondaryConnection:Disconnect()
		secondaryConnection = nil
	end
	if pState.antiLag then
		handleInstanceProperties("Optimizando...")
		effectSettings = effectSettings
			or {
				["GlobalShadows"] = lighting.GlobalShadows,
				["FogEnd"] = lighting.FogEnd,
				["Brightness"] = lighting.Brightness,
			}
		lighting.GlobalShadows = false
		lighting.FogEnd = 1000000000
		lighting.Brightness = 0
		pcall(function(...)
			qualityLevel = qualityLevel or (settings()).Rendering.QualityLevel;
			(settings()).Rendering.QualityLevel = Enum.QualityLevel.Level01
		end)
		local terrain = workspace:FindFirstChildOfClass("Terrain")
		if terrain then
			innerHandler(terrain, "WaterWaveSize", 0)
			innerHandler(terrain, "WaterWaveSpeed", 0)
			innerHandler(terrain, "WaterReflectance", 0)
			innerHandler(terrain, "WaterTransparency", 1)
		end
		secondaryConnection = workspace.DescendantAdded:Connect(function(argument, ...)
			if pState.antiLag then
				task.defer(function(...)
					pcall(outerHandler, argument)
				end)
			end
		end)
		handleSendGiftRemote("antiLag", function(...)
			local data = { workspace, lighting }
			local sum = 1
			local number = 0
			while
				sum <= #data and (pState.running and (pState.antiLag and pState.antiLagGeneration == antiLagGeneration))
			do
				local container = data[sum]
				sum = sum + 1
				local success, result = pcall(function(...)
					return container:GetChildren()
				end)
				if success then
					for index, item in ipairs(result) do
						data[#data + 1] = item
						pcall(outerHandler, item)
						number = number + 1
						if number % 260 == 0 then
							runService.Heartbeat:Wait()
						end
					end
				end
			end
			if pState.antiLag and pState.antiLagGeneration == antiLagGeneration then
				handleInstanceProperties("100% Optimizado")
			end
		end)
	else
		handleInstanceProperties("Restaurando...")
		if condition then
			fallbackUpdateInstanceProperties(antiLagGeneration, true)
		else
			handleSendGiftRemote("antiLag", function(...)
				fallbackUpdateInstanceProperties(antiLagGeneration, true)
			end)
		end
	end
end
local createPartData = {}
local function createPart(createPartArgument, ...)
	pState.walkWater = createPartArgument == true
	for index, item in ipairs(createPartData) do
		if item and item.Parent then
			item:Destroy()
		end
	end
	table.clear(createPartData)
	if not pState.walkWater then
		return
	end
	local createPartNumber = Vector3.new(-3072, -9.5, -3072)
	for index = -4, 4, 1 do
		for secondaryIndex = -4, 4, 1 do
			local part = Instance.new("Part")
			part.Name = "RawExploitWaterFloor"
			part.Size = Vector3.new(2048, 1, 2048)
			part.Position = createPartNumber + Vector3.new(index * 2048, 0, secondaryIndex * 2048)
			part.Anchored = true
			part.CanCollide = true
			part.Transparency = 1
			part.CastShadow = false
			part.Parent = workspace
			createPartData[#createPartData + 1] = part
		end
		runService.Heartbeat:Wait()
	end
end
local function sendOpenFortuneWheelRemote(argument, ...)
	pState.autoSpinWheel = argument == true
	if not pState.autoSpinWheel then
		handleValue("fortuneWheel")
		return
	end
	handleSendGiftRemote("fortuneWheel", function(...)
		while pState.running and pState.autoSpinWheel do
			pcall(function(...)
				local rEvents = replicatedStorage:FindFirstChild("rEvents")
				local remoteFunction = rEvents and rEvents:FindFirstChild("openFortuneWheelRemote")
				local fortuneWheelChances = replicatedStorage:FindFirstChild("fortuneWheelChances")
				local option = fortuneWheelChances and fortuneWheelChances:FindFirstChild("Fortune Wheel")
				if remoteFunction and option then
					remoteFunction:InvokeServer("openFortuneWheel", option)
				end
			end)
			task.wait(1)
		end
	end)
end
local alternateData = { "Magma Chest", "Mythical Chest", "Golden Chest", "Enchanted Chest", "Legends Chest" }
local function updateAutoClaimChests(argument, ...)
	pState.autoClaimChests = argument == true
	if not pState.autoClaimChests then
		handleValue("autoClaimChests")
		return
	end
	handleSendGiftRemote("autoClaimChests", function(...)
		while pState.running and pState.autoClaimChests do
			local rEvents = replicatedStorage:FindFirstChild("rEvents")
			local condition = rEvents and rEvents:FindFirstChild("checkChestRemote")
			if condition then
				for index, item in ipairs(alternateData) do
					if not pState.running or not pState.autoClaimChests then
						break
					end
					pcall(condition.InvokeServer, condition, item)
					task.wait(0.15)
				end
			end
			task.wait(15)
		end
	end)
end
local alternateConnection = nil
local additionalData = {}
local function onDescendantAdded(item, ...)
	if item and (item.Name == "RobloxForwardPortals" and item.Parent) then
		additionalData[#additionalData + 1] = { ["object"] = item, ["parent"] = item.Parent }
		item.Parent = nil
	end
end
local function updateRemovePortals(argument, ...)
	pState.removePortals = argument == true
	handleValue("removePortals")
	if alternateConnection then
		alternateConnection:Disconnect()
		alternateConnection = nil
	end
	if not pState.removePortals then
		for index, item in ipairs(additionalData) do
			if item.object and not item.object.Parent then
				pcall(function(...)
					item.object.Parent = item.parent and (item.parent.Parent and item.parent) or workspace
				end)
			end
		end
		table.clear(additionalData)
		return
	end
	if pState.removePortals then
		alternateConnection = game.DescendantAdded:Connect(onDescendantAdded)
		handleSendGiftRemote("removePortals", function(...)
			local data = { workspace }
			local sum = 1
			local number = 0
			while sum <= #data and (pState.running and pState.removePortals) do
				local container = data[sum]
				sum = sum + 1
				local success, result = pcall(function(...)
					return container:GetChildren()
				end)
				if success then
					for index, item in ipairs(result) do
						data[#data + 1] = item
						onDescendantAdded(item)
						number = number + 1
						if number % 300 == 0 then
							runService.Heartbeat:Wait()
						end
					end
				end
			end
		end)
	end
end
local walkSpeed = nil
local function updateWalkSpeed(...)
	local updateWalkSpeedCondition = isUseToolValid()
	if updateWalkSpeedCondition then
		if pState.fastSpeed then
			updateWalkSpeedCondition.WalkSpeed = 1000
		elseif walkSpeed ~= nil then
			updateWalkSpeedCondition.WalkSpeed = walkSpeed
		end
	end
end
local function updateFastSpeed(fastSpeedFlag, ...)
	local updateFastSpeedFlag = isUseToolValid()
	if fastSpeedFlag and (updateFastSpeedFlag and not pState.fastSpeed) then
		walkSpeed = updateFastSpeedFlag.WalkSpeed
	end
	local fastSpeed = pState.fastSpeed
	pState.fastSpeed = fastSpeedFlag == true
	if pState.fastSpeed or fastSpeed then
		updateWalkSpeed()
	end
	if fastSpeed and not pState.fastSpeed then
		walkSpeed = nil
	end
end
local bodyGyro = nil
local bodyVelocity = nil
local flag = false
local secondaryFlag = false
local frame = nil
pState.clearAntiKnockback = function(...)
	if pState.antiKnockbackVelocity then
		pState.antiKnockbackVelocity:Destroy()
		pState.antiKnockbackVelocity = nil
	end
end
pState.setAntiKnockback = function(argument, ...)
	pState.antiKnockback = argument == true
	if not pState.antiKnockback then
		pState.clearAntiKnockback()
	end
end
local function updatePlatformStand(...)
	if bodyGyro then
		bodyGyro:Destroy()
		bodyGyro = nil
	end
	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end
	local updatePlatformStandCondition = isUseToolValid()
	if updatePlatformStandCondition then
		updatePlatformStandCondition.PlatformStand = false
	end
end
local function nestedUpdateInstanceProperties(updateInstancePropertiesArgument, ...)
	pState.fly = updateInstancePropertiesArgument == true
	if frame then
		frame.Visible = pState.fly and userInputService.TouchEnabled
	end
	if not pState.fly then
		updatePlatformStand()
	end
end
local updateCanCollideData = {}
local additionalConnection = nil
local function updateCanCollide(...)
	for key, canCollide in pairs(updateCanCollideData) do
		if key and key.Parent then
			pcall(function(...)
				key.CanCollide = canCollide
			end)
		end
	end
	table.clear(updateCanCollideData)
end
local function updateSteppedConnection(updateSteppedConnectionArgument, ...)
	pState.noclip = updateSteppedConnectionArgument == true
	if additionalConnection then
		additionalConnection:Disconnect()
		additionalConnection = nil
	end
	if pState.noclip then
		additionalConnection = runService.Stepped:Connect(function(...)
			if not pState.running or not pState.noclip then
				return
			end
			local updateSteppedConnectionCondition = getValueCharacter()
			if updateSteppedConnectionCondition then
				for index, item in ipairs(updateSteppedConnectionCondition:GetDescendants()) do
					if item:IsA("BasePart") then
						if updateCanCollideData[item] == nil then
							updateCanCollideData[item] = item.CanCollide
						end
						item.CanCollide = false
					end
				end
			end
		end)
	end
	if not pState.noclip then
		updateCanCollide()
	end
end
local bodyAngularVelocity = nil
local capturedInstanceFlag = nil
local autoRotate = true
local function updateSpin(...)
	if bodyAngularVelocity then
		local parent = bodyAngularVelocity.Parent
		if parent and parent:IsA("BasePart") then
			parent.AssemblyAngularVelocity = Vector3.zero
		end
		bodyAngularVelocity:Destroy()
		bodyAngularVelocity = nil
	end
	if capturedInstanceFlag and capturedInstanceFlag.Parent then
		capturedInstanceFlag.AutoRotate = autoRotate
	end
	capturedInstanceFlag = nil
end
local function secondaryUpdateSpin(updateSpinArgument, ...)
	pState.spin = updateSpinArgument == true
	if not pState.spin then
		updateSpin()
	end
end
local function updateCameraSubject(...)
	local cameraSubject = isUseToolValid()
	if workspace.CurrentCamera and cameraSubject then
		workspace.CurrentCamera.CameraSubject = cameraSubject
	end
end
local function updateSpy(updateSpyFlag, ...)
	pState.spy = updateSpyFlag == true
	if not pState.spy then
		updateCameraSubject()
	end
end
do
	local function handleInstanceProperties(...)
		pcall(function(...)
			local punchContainer = getValueCharacter()
			local parent = backpackContainer:FindFirstChild("Backpack")
			local parentOption = punchContainer and punchContainer:FindFirstChild("Punch")
			if parentOption and parent then
				parentOption.Parent = parent
			end
		end)
	end
	local function usePunch(...)
		local punchContainer = getValueCharacter()
		local usePunchFlag = isUseToolValid()
		local backpack = backpackContainer:FindFirstChild("Backpack")
		if not punchContainer or not usePunchFlag then
			return nil
		end
		local usePunchOption = punchContainer:FindFirstChild("Punch") or backpack and backpack:FindFirstChild("Punch")
		if usePunchOption and usePunchOption.Parent == backpack then
			usePunchFlag:EquipTool(usePunchOption)
		end
		local muscleEvent = backpackContainer:FindFirstChild("muscleEvent")
		if muscleEvent then
			pcall(muscleEvent.FireServer, muscleEvent, "punch", "leftHand")
			pcall(muscleEvent.FireServer, muscleEvent, "punch", "rightHand")
		end
		return punchContainer
	end
	local function isValid(...)
		if #public.Kills.ProtectedPrivateServerIds == 0 then
			return false
		end
		local isValidOption = getgenv and getgenv() or _G
		local option = isValidOption.gethiddenproperty or isValidOption.gethiddenprop
		if type(option) ~= "function" then
			return false
		end
		local success, result = pcall(option, game, "PrivateServerId")
		local searchQuery = success and tostring(result or "") or ""
		return searchQuery ~= "" and table.find(public.Kills.ProtectedPrivateServerIds, searchQuery) ~= nil
	end
	local function getUserId(player, ...)
		local lower = (tostring(player and player.DisplayName or "")):lower()
		if lower:find("0x", 1, true) then
			return true
		end
		if not pState.kill.protectFriends then
			return false
		end
		local userId = pState.kill.friendCache[player.UserId]
		if userId ~= nil then
			return userId
		end
		local success, result = pcall(backpackContainer.IsFriendsWith, backpackContainer, player.UserId)
		if success then
			pState.kill.friendCache[player.UserId] = result == true
		else
			pState.kill.friendCache[player.UserId] = true
		end
		return pState.kill.friendCache[player.UserId]
	end
	local function updateInstanceProperties(player, ...)
		if not player or player == backpackContainer or getUserId(player) then
			return false
		end
		local humanoidRootPartContainer = player.Character
		local updateInstancePropertiesOption = humanoidRootPartContainer
			and humanoidRootPartContainer:FindFirstChildWhichIsA("Humanoid")
		local cFrameOption = humanoidRootPartContainer and humanoidRootPartContainer:FindFirstChild("HumanoidRootPart")
		if not updateInstancePropertiesOption or updateInstancePropertiesOption.Health <= 0 or not cFrameOption then
			return false
		end
		local leftArmContainer = usePunch()
		if not leftArmContainer or type(firetouchinterest) ~= "function" then
			return false
		end
		local updateInstancePropertiesFlag = leftArmContainer:FindFirstChild("LeftHand")
			or leftArmContainer:FindFirstChild("Left Arm")
			or leftArmContainer:FindFirstChild("RightHand")
			or leftArmContainer:FindFirstChild("Right Arm")
		if not updateInstancePropertiesFlag then
			return false
		end
		local cFrame = cFrameOption.CFrame
		local assemblyLinearVelocity = cFrameOption.AssemblyLinearVelocity
		local assemblyAngularVelocity = cFrameOption.AssemblyAngularVelocity
		local function updateInstanceProperties(...)
			if cFrameOption and cFrameOption.Parent then
				cFrameOption.CFrame = cFrame
				cFrameOption.AssemblyLinearVelocity = assemblyLinearVelocity
				cFrameOption.AssemblyAngularVelocity = assemblyAngularVelocity
			end
		end
		pcall(firetouchinterest, cFrameOption, updateInstancePropertiesFlag, 0)
		pcall(updateInstanceProperties)
		pcall(firetouchinterest, cFrameOption, updateInstancePropertiesFlag, 1)
		pcall(updateInstanceProperties)
		return true
	end
	local function secondaryUpdateInstancePropertiesValid(leaderstatsContainer, secondaryFlag, ...)
		if not secondaryFlag then
			return true
		end
		local flag = isUpdateInstancePropertiesValid(leaderstatsContainer, { "goodKarma", "Good Karma" })
		local valueFlag = isUpdateInstancePropertiesValid(leaderstatsContainer, { "evilKarma", "Evil Karma" })
		local option = tonumber(flag and flag.Value) or 0
		local secondaryOption = tonumber(valueFlag and valueFlag.Value) or 0
		if secondaryFlag == "evil" then
			return option > secondaryOption
		elseif secondaryFlag == "good" then
			return secondaryOption > option
		end
		return false
	end
	local function alternateUpdateInstancePropertiesValid(...)
		return pState.kill.auto or pState.kill.karmaMode ~= nil
	end
	local function secondaryUpdateInstanceProperties(...)
		handleValue("killFarm")
		if not alternateUpdateInstancePropertiesValid() and not pState.kill.targetMode then
			handleInstanceProperties()
			return
		end
		handleSendGiftRemote("killFarm", function(...)
			while pState.running and (alternateUpdateInstancePropertiesValid() or pState.kill.targetMode) do
				if pState.kill.targetMode then
					updateInstanceProperties(pState.kill.target and players:FindFirstChild(pState.kill.target))
				else
					local updateInstancePropertiesNumber = 0
					for index, item in ipairs(players:GetPlayers()) do
						if not pState.running or not alternateUpdateInstancePropertiesValid() then
							break
						end
						if
							secondaryUpdateInstancePropertiesValid(item, pState.kill.karmaMode)
							and updateInstanceProperties(item)
						then
							updateInstancePropertiesNumber = updateInstancePropertiesNumber + 1
						end
					end
					if pState.kill.serverHop then
						if updateInstancePropertiesNumber == 0 then
							pState.kill.noTargetsSince = pState.kill.noTargetsSince or time()
							if time() - pState.kill.noTargetsSince >= public.ServerHop.NoTargetsDelay then
								pState.kill.hopNow = true
							end
						else
							pState.kill.noTargetsSince = nil
						end
					end
				end
				task.wait(0.05)
			end
			handleInstanceProperties()
		end)
	end
	local function getQueueOnTeleport(...)
		local option = getgenv and getgenv() or _G
		local secondaryOption = option.queue_on_teleport
			or option.queueonteleport
			or queue_on_teleport
			or queueonteleport
		if type(secondaryOption) == "function" then
			return secondaryOption
		end
		local syn = option.syn
		if type(syn) == "table" and type(syn.queue_on_teleport) == "function" then
			return syn.queue_on_teleport
		end
		local fluxus = option.fluxus
		if type(fluxus) == "table" and type(fluxus.queue_on_teleport) == "function" then
			return fluxus.queue_on_teleport
		end
		return nil
	end
	local function isGetIdValid(searchQuery, ...)
		return table.find(pState.kill.serverHistory, searchQuery) ~= nil
	end
	local function handler(searchQuery, ...)
		if not isGetIdValid(searchQuery) then
			pState.kill.serverHistory[#pState.kill.serverHistory + 1] = searchQuery
		end
		while #pState.kill.serverHistory > public.ServerHop.HistoryLimit do
			table.remove(pState.kill.serverHistory, 1)
		end
	end
	local function getId(secondaryGetIdFlag, getIdFlag, flag, ...)
		local httpService = game:GetService("HttpService")
		local getIdData = {}
		local data = {}
		local secondaryGetIdData = {}
		local nextPageCursor = nil
		for index = 1, 6, 1 do
			local url = string.format(public.ServerHop.ServerApi, game.PlaceId)
			if nextPageCursor then
				url = url .. ("&cursor=" .. httpService:UrlEncode(nextPageCursor))
			end
			local success, result = pcall(game.HttpGet, game, url, true)
			if not success or type(result) ~= "string" then
				break
			end
			local secondarySuccess, dataResult = pcall(httpService.JSONDecode, httpService, result)
			if not secondarySuccess or type(dataResult) ~= "table" then
				break
			end
			for index, item in ipairs(dataResult.data or {}) do
				if
					type(item) == "table"
					and (
						type(item.id) == "string"
						and (
							item.id ~= game.JobId
							and (
								(flag or not isGetIdValid(item.id))
								and (
									tonumber(item.playing)
									and (
										tonumber(item.maxPlayers)
										and (
											(not secondaryGetIdFlag or tonumber(item.playing) <= secondaryGetIdFlag)
											and tonumber(item.playing) < tonumber(item.maxPlayers)
										)
									)
								)
							)
						)
					)
				then
					local getIdNumber = tonumber(item.playing)
					secondaryGetIdData[#secondaryGetIdData + 1] = item
					if getIdNumber >= public.ServerHop.PreferredPlayers then
						getIdData[#getIdData + 1] = item
					elseif getIdNumber >= public.ServerHop.MinimumPlayers then
						data[#data + 1] = item
					end
				end
			end
			nextPageCursor = dataResult.nextPageCursor
			if not nextPageCursor or #getIdData >= (getIdFlag and 1 or 12) then
				break
			end
		end
		local getIdOption = #getIdData > 0 and getIdData or data
		if #getIdOption == 0 and getIdFlag then
			getIdOption = secondaryGetIdData
		end
		if #getIdOption == 0 then
			return nil
		end
		table.sort(getIdOption, function(getIdArgument, secondaryArgument, ...)
			return tonumber(getIdArgument.playing) > tonumber(secondaryArgument.playing)
		end)
		local getIdNumber = math.min(#getIdOption, 8)
		return getIdOption[math.random(1, getIdNumber)].id
	end
	local function alternateUpdateInstanceProperties(
		updateInstancePropertiesFlag,
		searchQuery,
		updateInstancePropertiesOption,
		...
	)
		local httpService = game:GetService("HttpService")
		handler(searchQuery)
		updateInstancePropertiesOption = updateInstancePropertiesOption or {}
		updateInstancePropertiesOption.script = "fg100.lua"
		updateInstancePropertiesOption.serverHistory = pState.kill.serverHistory
		updateInstancePropertiesOption.serversVisited = pState.kill.serversVisited + 1
		local encodedData = httpService:JSONEncode(updateInstancePropertiesOption)
		local concatResult = table.concat(
			{
				"repeat task.wait() until game:IsLoaded()",
				"local env = getgenv and getgenv() or _G",
				"env.RawExploitFG100Resume = game:GetService('HttpService'):JSONDecode("
					.. (string.format("%q", encodedData) .. ")"),
				"loadstring(game:HttpGet(" .. (string.format("%q", public.ServerHop.LoaderUrl) .. ", true))()"),
			},
			"\n"
		)
		return pcall(updateInstancePropertiesFlag, concatResult)
	end
	local function additionalUpdateInstanceProperties(updateInstancePropertiesFlag, searchQuery, ...)
		return alternateUpdateInstanceProperties(
			updateInstancePropertiesFlag,
			searchQuery,
			{
				["tab"] = "Kills",
				["autoKill"] = pState.kill.auto,
				["karmaMode"] = pState.kill.karmaMode,
				["protectFriends"] = pState.kill.protectFriends,
				["serverHop"] = true,
			}
		)
	end
	local function secondaryHandler(...)
		local flag = getQueueOnTeleport()
		if not flag then
			return false
		end
		local searchQuery = getId()
		if not searchQuery or not additionalUpdateInstanceProperties(flag, searchQuery) then
			return false
		end
		local success = pcall(function(...)
			(game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, searchQuery, backpackContainer)
		end)
		return success
	end
	local function alternateHandler(number, secondaryArgument, ...)
		if type(pState.kill.updateHopStatus) == "function" then
			pcall(pState.kill.updateHopStatus, number, secondaryArgument)
		end
	end
	pState.setServerHop = function(serverHopFlag, ...)
		if serverHopFlag and (pState.kill.targetMode or isValid() or not getQueueOnTeleport()) then
			return false
		end
		pState.kill.serverHop = serverHopFlag == true
		pState.kill.hopNow = false
		pState.kill.noTargetsSince = nil
		handleValue("killServerHop")
		if pState.kill.serverHop then
			handleSendGiftRemote("killServerHop", function(...)
				while pState.running and pState.kill.serverHop do
					local interval = public.ServerHop.Interval
					while interval > 0 and not pState.kill.hopNow do
						if not pState.running or not pState.kill.serverHop then
							return
						end
						alternateHandler(interval)
						task.wait(1)
						interval = interval - 1
					end
					pState.kill.hopNow = false
					if not pState.running or not pState.kill.serverHop then
						return
					end
					alternateHandler(0, "Buscando servidor...")
					if secondaryHandler() then
						alternateHandler(0, "Conectando...")
						task.wait(12)
						if pState.running and pState.kill.serverHop then
							alternateHandler(0, "Reintentando...")
							task.wait(public.ServerHop.RetryDelay)
							pState.kill.hopNow = true
						end
					else
						alternateHandler(0, "Reintentando...")
						task.wait(public.ServerHop.RetryDelay)
						pState.kill.hopNow = true
					end
				end
			end)
		else
			alternateHandler(nil)
		end
		return true
	end
	local function fallbackUpdateInstanceProperties(...)
		handleValue("killPositionLock")
		pState.kill.lockCFrame = nil
		pState.kill.lockCharacter = nil
	end
	local function updateValue(...)
		handleValue("killPunchAnimation")
		if pState.fastPunch then
			return
		end
		pcall(function(...)
			local punchContainer = getValueCharacter()
			local backpack = backpackContainer:FindFirstChild("Backpack")
			local attackTimeContainer = punchContainer and punchContainer:FindFirstChild("Punch")
				or backpack and backpack:FindFirstChild("Punch")
			local updateValueCondition = attackTimeContainer and attackTimeContainer:FindFirstChild("attackTime")
			if updateValueCondition then
				updateValueCondition.Value = 0.3
			end
		end)
	end
	local function secondaryUpdateValue(...)
		updateValue()
		handleSendGiftRemote("killPunchAnimation", function(...)
			while pState.running and pState.kill.auto do
				if not pState.fastPunch then
					pcall(function(...)
						local attackTimeContainer = secondaryUseTool()
						if attackTimeContainer then
							local attackTime = attackTimeContainer:FindFirstChild("attackTime")
							if attackTime then
								attackTime.Value = 0
							end
							attackTimeContainer:Activate()
						end
					end)
				end
				task.wait(0.01)
			end
		end)
	end
	local function nestedUpdateInstanceProperties(...)
		fallbackUpdateInstanceProperties()
		local lockCharacter = getValueCharacter()
		local updateInstancePropertiesFlag = isSendHitEventValid()
		if lockCharacter and updateInstancePropertiesFlag then
			pState.kill.lockCharacter = lockCharacter
			pState.kill.lockCFrame = updateInstancePropertiesFlag.CFrame
		end
		handleSendGiftRemote("killPositionLock", function(...)
			while pState.running and alternateUpdateInstancePropertiesValid() do
				local lockCharacter = getValueCharacter()
				local updateInstancePropertiesFlag = isSendHitEventValid()
				if lockCharacter and updateInstancePropertiesFlag then
					if pState.kill.lockCharacter ~= lockCharacter or not pState.kill.lockCFrame then
						pState.kill.lockCharacter = lockCharacter
						pState.kill.lockCFrame = updateInstancePropertiesFlag.CFrame
					end
					updateInstancePropertiesFlag.CFrame = pState.kill.lockCFrame
					updateInstancePropertiesFlag.AssemblyLinearVelocity = Vector3.zero
					updateInstancePropertiesFlag.AssemblyAngularVelocity = Vector3.zero
				end
				runService.Heartbeat:Wait()
			end
		end)
	end
	pState.setAutoKill = function(autoFlag, ...)
		if autoFlag and (isValid() or type(firetouchinterest) ~= "function") then
			return false
		end
		pState.kill.auto = autoFlag == true
		if pState.kill.auto then
			pState.kill.targetMode = false
			pState.kill.karmaMode = nil
			nestedUpdateInstanceProperties()
			secondaryUpdateValue()
			if type(modeData.SetSizeOne) == "function" then
				modeData.SetSizeOne()
			end
			handleSendGiftRemote("killSizeOne", function(...)
				while pState.running and pState.kill.auto do
					if type(modeData.SetSizeOne) == "function" then
						modeData.SetSizeOne()
					end
					task.wait(0.5)
				end
			end)
		else
			handleValue("killSizeOne")
			fallbackUpdateInstanceProperties()
			updateValue()
		end
		secondaryUpdateInstanceProperties()
		return true
	end
	pState.setTargetKill = function(targetModeFlag, ...)
		if targetModeFlag and (isValid() or type(firetouchinterest) ~= "function" or not pState.kill.target) then
			return false
		end
		pState.kill.targetMode = targetModeFlag == true
		if pState.kill.targetMode then
			pState.kill.auto = false
			pState.kill.karmaMode = nil
			fallbackUpdateInstanceProperties()
			updateValue()
			pState.setServerHop(false)
			handleValue("killSizeOne")
		end
		secondaryUpdateInstanceProperties()
		return true
	end
	pState.setKarmaKill = function(karmaMode, condition, ...)
		if karmaMode ~= "evil" and karmaMode ~= "good" then
			return false
		end
		if condition and (isValid() or type(firetouchinterest) ~= "function") then
			return false
		end
		if condition then
			pState.kill.karmaMode = karmaMode
		elseif pState.kill.karmaMode == karmaMode then
			pState.kill.karmaMode = nil
		end
		if pState.kill.karmaMode then
			pState.kill.auto = false
			updateValue()
			pState.kill.targetMode = false
			nestedUpdateInstanceProperties()
			if type(modeData.SetSizeOne) == "function" then
				modeData.SetSizeOne()
			end
			handleSendGiftRemote("killSizeOne", function(...)
				while pState.running and pState.kill.karmaMode do
					if type(modeData.SetSizeOne) == "function" then
						modeData.SetSizeOne()
					end
					task.wait(0.5)
				end
			end)
		else
			handleValue("killSizeOne")
			fallbackUpdateInstanceProperties()
			updateValue()
		end
		secondaryUpdateInstanceProperties()
		return true
	end
	pState.setProtectFriends = function(argument, ...)
		pState.kill.protectFriends = argument == true
		if not pState.kill.protectFriends then
			table.clear(pState.kill.friendCache)
		end
		return true
	end
	pState.clearKillFriend = function(player, ...)
		if player then
			pState.kill.friendCache[player.UserId] = nil
		end
	end
	pState.stopKills = function(...)
		pState.kill.auto = false
		pState.kill.karmaMode = nil
		pState.kill.targetMode = false
		pState.kill.serverHop = false
		handleValue("killFarm")
		handleValue("killSizeOne")
		fallbackUpdateInstanceProperties()
		updateValue()
		handleValue("killServerHop")
		alternateHandler(nil)
		handleInstanceProperties()
	end
end
handler(function(...)
	modeData:Stop(true)
	alternateUpdateInstanceProperties(false)
	sendMuscleEvent("autoWeight", false)
	sendMuscleEvent("autoHandstands", false)
	sendMuscleEvent("autoLift", false)
	sendMuscleEvent("autoSitups", false)
	pState.setAutoEgg(false)
	updateChildAddedConnection(false)
	secondaryUpdateChildAddedConnection(false)
	additionalUpdateInstanceProperties(nil, false)
	updateDescendantAddedConnection(false, true)
	createPart(false)
	sendOpenFortuneWheelRemote(false)
	updateAutoClaimChests(false)
	updateRemovePortals(false)
	updateFastSpeed(false)
	nestedUpdateInstanceProperties(false)
	pState.setAntiKnockback(false)
	updateSteppedConnection(false)
	secondaryUpdateSpin(false)
	updateSpy(false)
	pState.stopKills()
	pState.autoPet = false
	pState.autoAura = false
	handleValue("autoPet")
	handleValue("autoAura")
end)
do
	local condition = parent:FindFirstChild("RawExploitFG100Hub")
	if condition then
		condition:Destroy()
	end
end
local function isNumberValid(...)
	local currentCamera = workspace.CurrentCamera
	return currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)
end
local function handleNumber(...)
	local vector = isNumberValid()
	local numberCondition = vector.X < 760 or userInputService.TouchEnabled and vector.X < 1100
	if numberCondition then
		return math.floor(
			math.clamp(vector.X * public.Size.MobileWidthScale, public.Size.MinWidth, public.Size.MaxMobileWidth)
		),
			math.floor(
				math.clamp(vector.Y * public.Size.MobileHeightScale, public.Size.MinHeight, public.Size.MaxMobileHeight)
			)
	end
	return public.Size.DesktopWidth, public.Size.DesktopHeight
end
local setMinimizedNumber, sizeNumber = handleNumber()
local positionNumber = 46
local createScrollingFrameNumber = 38
local capturedSizeNumber = positionNumber
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RawExploitFG100Hub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 1000
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function(...)
	screenGui.AutoLocalize = false
end)
screenGui.Parent = parent
local canvasGroup = Instance.new("CanvasGroup")
canvasGroup.Name = "AnimationRoot"
canvasGroup.AnchorPoint = Vector2.new(0.5, 0.5)
canvasGroup.Size = UDim2.fromOffset(setMinimizedNumber, sizeNumber)
canvasGroup.Position = UDim2.fromScale(0.5, 0.5)
canvasGroup.BackgroundTransparency = 1
canvasGroup.BorderSizePixel = 0
canvasGroup.GroupTransparency = 1
canvasGroup.Parent = screenGui
local secondaryParent = Instance.new("Frame")
secondaryParent.AnchorPoint = Vector2.new(0.5, 0.5)
secondaryParent.Size = UDim2.fromOffset(setMinimizedNumber, sizeNumber)
secondaryParent.Position = UDim2.fromScale(0.5, 0.5)
secondaryParent.BackgroundColor3 = colors.panel
secondaryParent.BackgroundTransparency = 1
secondaryParent.BorderSizePixel = 0
secondaryParent.ZIndex = 1
secondaryParent.Parent = canvasGroup;
(Instance.new("UICorner", secondaryParent)).CornerRadius = UDim.new(0, 15)
local alternateParent = Instance.new("CanvasGroup")
alternateParent.AnchorPoint = Vector2.new(0.5, 0.5)
alternateParent.Size = UDim2.fromOffset(setMinimizedNumber, sizeNumber)
alternateParent.Position = UDim2.fromScale(0.5, 0.5)
alternateParent.BackgroundColor3 = colors.base
alternateParent.BackgroundTransparency = 0.42
alternateParent.BorderSizePixel = 0
alternateParent.ClipsDescendants = true
alternateParent.ZIndex = 2
alternateParent.Parent = canvasGroup;
(Instance.new("UICorner", alternateParent)).CornerRadius = UDim.new(0, 13)
do
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = colors.panel
	frame.BackgroundTransparency = 0.64
	frame.BorderSizePixel = 0
	frame.ZIndex = 4
	frame.Parent = alternateParent
end
local additionalParent = Instance.new("Frame")
additionalParent.AnchorPoint = Vector2.new(0.5, 0.5)
additionalParent.Size = UDim2.fromOffset(setMinimizedNumber, sizeNumber)
additionalParent.Position = UDim2.fromScale(0.5, 0.5)
additionalParent.BackgroundTransparency = 1
additionalParent.BorderSizePixel = 0
additionalParent.ZIndex = 80
additionalParent.Parent = canvasGroup;
(Instance.new("UICorner", additionalParent)).CornerRadius = UDim.new(0, 13)
do
	local parent = Instance.new("UIStroke", additionalParent)
	parent.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	parent.Color = colors.cyan
	parent.Thickness = 2
	parent.Transparency = 0.03
	parent.LineJoinMode = Enum.LineJoinMode.Round
	local uiGradient = Instance.new("UIGradient")
	uiGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, colors.cyan),
		ColorSequenceKeypoint.new(0.5, colors.blue),
		ColorSequenceKeypoint.new(1, colors.cyan),
	})
	uiGradient.Parent = parent
end
local textButton
do
	local parent = Instance.new("Frame")
	parent.Size = UDim2.new(1, 0, 0, positionNumber)
	parent.BackgroundColor3 = Color3.fromRGB(10, 73, 94)
	parent.BackgroundTransparency = 0.48
	parent.BorderSizePixel = 0
	parent.ZIndex = 10
	parent.Parent = alternateParent
	local uiGradient = Instance.new("UIGradient")
	uiGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(13, 88, 109)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 60, 82)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 88, 109)),
	})
	uiGradient.Parent = parent
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -18, 1, 0)
	textLabel.Position = UDim2.fromOffset(10, 1)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = public.Title
	textLabel.TextColor3 = colors.blue
	textLabel.TextTransparency = 0.58
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 16
	textLabel.TextWrapped = true
	textLabel.ZIndex = 11
	textLabel.Parent = parent
	local secondaryTextLabel = Instance.new("TextLabel")
	secondaryTextLabel.Size = UDim2.new(1, -18, 1, 0)
	secondaryTextLabel.Position = UDim2.fromOffset(9, 0)
	secondaryTextLabel.BackgroundTransparency = 1
	secondaryTextLabel.Text = public.Title
	secondaryTextLabel.TextColor3 = colors.cyan
	secondaryTextLabel.TextStrokeColor3 = colors.panel
	secondaryTextLabel.TextStrokeTransparency = 0.42
	secondaryTextLabel.Font = Enum.Font.FredokaOne
	secondaryTextLabel.TextSize = 16
	secondaryTextLabel.TextWrapped = true
	secondaryTextLabel.ZIndex = 12
	secondaryTextLabel.Parent = parent
	textButton = Instance.new("TextButton")
	textButton.Size = UDim2.fromScale(1, 1)
	textButton.BackgroundTransparency = 1
	textButton.Text = ""
	textButton.AutoButtonColor = false
	textButton.ZIndex = 60
	textButton.Parent = parent
end
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 0, createScrollingFrameNumber)
scrollingFrame.Position = UDim2.new(0, 0, 0, positionNumber)
scrollingFrame.BackgroundColor3 = colors.panel
scrollingFrame.BackgroundTransparency = 0.18
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 0
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
scrollingFrame.CanvasSize = UDim2.new()
scrollingFrame.ZIndex = 10
scrollingFrame.Parent = alternateParent
local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 4)
do
	local uiPadding = Instance.new("UIPadding", scrollingFrame)
	uiPadding.PaddingLeft = UDim.new(0, 6)
	uiPadding.PaddingRight = UDim.new(0, 6)
	uiPadding.PaddingTop = UDim.new(0, 4)
	uiPadding.PaddingBottom = UDim.new(0, 4)
end
local fallbackParent = Instance.new("Frame")
fallbackParent.Size = UDim2.new(1, 0, 1, -(positionNumber + createScrollingFrameNumber))
fallbackParent.Position = UDim2.new(0, 0, 0, positionNumber + createScrollingFrameNumber)
fallbackParent.BackgroundTransparency = 1
fallbackParent.ClipsDescendants = true
fallbackParent.ZIndex = 8
fallbackParent.Parent = alternateParent
local pages = {}
local tabs = {}
local layoutOrderData = {}
local function handleLayoutOrder(parent, ...)
	layoutOrderData[parent] = (layoutOrderData[parent] or 0) + 1
	return layoutOrderData[parent]
end
local function updateScrollingFrame(updateScrollingFrameText, ...)
	for key, activeLineContainer in pairs(tabs) do
		local updateScrollingFrameFlag = key == updateScrollingFrameText
		activeLineContainer:SetAttribute("Selected", updateScrollingFrameFlag);
		(tweenService:Create(
			activeLineContainer,
			TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				["BackgroundTransparency"] = updateScrollingFrameFlag and 0.02 or 0.34,
				["BackgroundColor3"] = updateScrollingFrameFlag and colors.tabOn or colors.tab,
				["TextColor3"] = updateScrollingFrameFlag and colors.white or colors.dim,
			}
		)):Play()
		local uiStroke = activeLineContainer:FindFirstChildOfClass("UIStroke")
		if uiStroke then
			(tweenService:Create(
				uiStroke,
				TweenInfo.new(0.14),
				{
					["Color"] = updateScrollingFrameFlag and colors.cyan or colors.blue,
					["Transparency"] = updateScrollingFrameFlag and 0.05 or 0.52,
				}
			)):Play()
		end
		local activeLine = activeLineContainer:FindFirstChild("ActiveLine")
		if activeLine then
			(tweenService:Create(
				activeLine,
				TweenInfo.new(0.16, Enum.EasingStyle.Quad),
				{
					["Size"] = updateScrollingFrameFlag and UDim2.new(1, -14, 0, 2) or UDim2.fromOffset(0, 2),
					["BackgroundTransparency"] = updateScrollingFrameFlag and 0 or 1,
				}
			)):Play()
		end
	end
	for key, item in pairs(pages) do
		if key == updateScrollingFrameText then
			item.Position = UDim2.fromOffset(7, 0)
			item.Visible = true
			(tweenService:Create(
				item,
				TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ ["Position"] = UDim2.fromOffset(0, 0) }
			)):Play()
		else
			item.Visible = false
		end
	end
end
local function createScrollingFrame(name, secondaryArgument, layoutOrder, ...)
	local parent = Instance.new("ScrollingFrame")
	parent.Name = name
	parent.Size = UDim2.fromScale(1, 1)
	parent.BackgroundTransparency = 1
	parent.BorderSizePixel = 0
	parent.ScrollBarThickness = 3
	parent.ScrollBarImageColor3 = colors.cyan
	parent.ScrollBarImageTransparency = 0.08
	parent.CanvasSize = UDim2.new()
	parent.Visible = false
	parent.ZIndex = 9
	parent.Parent = fallbackParent
	pages[name] = parent
	local uiListLayout = Instance.new("UIListLayout", parent)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 3)
	local uiPadding = Instance.new("UIPadding", parent)
	uiPadding.PaddingLeft = UDim.new(0, 8)
	uiPadding.PaddingRight = UDim.new(0, 8)
	uiPadding.PaddingTop = UDim.new(0, 7)
	uiPadding.PaddingBottom = UDim.new(0, 8)
	handleFrame((uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize")):Connect(function(...)
		parent.CanvasSize =
			UDim2.fromOffset(0, uiListLayout.AbsoluteContentSize.Y + (parent:GetAttribute("TightCanvas") and 4 or 15))
	end))
	local textButton = Instance.new("TextButton")
	textButton.Name = name
	textButton.Size = UDim2.fromOffset(secondaryArgument, createScrollingFrameNumber - 8)
	textButton.BackgroundColor3 = colors.tab
	textButton.BackgroundTransparency = 0.28
	textButton.BorderSizePixel = 0
	textButton.Text = name
	textButton.TextColor3 = colors.soft
	textButton.Font = Enum.Font.FredokaOne
	textButton.TextSize = 11
	textButton.TextWrapped = true
	textButton.AutoButtonColor = false
	textButton.LayoutOrder = layoutOrder
	textButton.ZIndex = 12
	textButton.Parent = scrollingFrame;
	(Instance.new("UICorner", textButton)).CornerRadius = UDim.new(0, 7)
	local uiStroke = Instance.new("UIStroke", textButton)
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Color = colors.blue
	uiStroke.Thickness = 1
	uiStroke.Transparency = 0.52
	local frame = Instance.new("Frame")
	frame.Name = "ActiveLine"
	frame.AnchorPoint = Vector2.new(0.5, 1)
	frame.Size = UDim2.fromOffset(0, 2)
	frame.Position = UDim2.new(0.5, 0, 1, -2)
	frame.BackgroundColor3 = colors.cyan
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ZIndex = 13
	frame.Parent = textButton;
	(Instance.new("UICorner", frame)).CornerRadius = UDim.new(1, 0)
	handleFrame(textButton.Activated:Connect(function(...)
		updateScrollingFrame(name)
	end))
	handleFrame(textButton.MouseEnter:Connect(function(...)
		if not textButton:GetAttribute("Selected") then
			(tweenService:Create(
				textButton,
				TweenInfo.new(0.1),
				{ ["BackgroundColor3"] = colors.rowHover, ["BackgroundTransparency"] = 0.18 }
			)):Play()
		end
	end))
	handleFrame(textButton.MouseLeave:Connect(function(...)
		if not textButton:GetAttribute("Selected") then
			(tweenService:Create(
				textButton,
				TweenInfo.new(0.1),
				{ ["BackgroundColor3"] = colors.tab, ["BackgroundTransparency"] = 0.34 }
			)):Play()
		end
	end))
	tabs[name] = textButton
	return parent
end
for layoutOrder, item in ipairs(public.Tabs) do
	createScrollingFrame(item[1], item[2], layoutOrder)
end
handleFrame((uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize")):Connect(function(...)
	scrollingFrame.CanvasSize = UDim2.fromOffset(uiListLayout.AbsoluteContentSize.X + 14, 0)
end))
do
	local parent = Instance.new("Frame")
	parent.Size = UDim2.fromOffset(34, createScrollingFrameNumber)
	parent.Position = UDim2.new(1, -34, 0, positionNumber)
	parent.BackgroundColor3 = colors.panel
	parent.BackgroundTransparency = 0.04
	parent.BorderSizePixel = 0
	parent.Active = false
	parent.Selectable = false
	parent.ZIndex = 24
	parent.Visible = false
	parent.Parent = alternateParent
	local uiGradient = Instance.new("UIGradient")
	uiGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.46, 0.24),
		NumberSequenceKeypoint.new(1, 0),
	})
	uiGradient.Parent = parent
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0, 18, 1, 0)
	textLabel.Position = UDim2.new(1, -20, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "\226\128\186"
	textLabel.TextColor3 = colors.cyan
	textLabel.TextStrokeColor3 = colors.panel
	textLabel.TextStrokeTransparency = 0.35
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 22
	textLabel.Active = false
	textLabel.Selectable = false
	textLabel.ZIndex = 25
	textLabel.Parent = parent
	local function updateVisible(...)
		local updateVisibleNumber =
			math.max(0, (uiListLayout.AbsoluteContentSize.X + 14) - scrollingFrame.AbsoluteSize.X)
		parent.Visible = updateVisibleNumber > 5 and scrollingFrame.CanvasPosition.X < updateVisibleNumber - 4
	end
	handleFrame((scrollingFrame:GetPropertyChangedSignal("CanvasPosition")):Connect(updateVisible))
	handleFrame((scrollingFrame:GetPropertyChangedSignal("AbsoluteSize")):Connect(updateVisible))
	handleFrame((uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize")):Connect(function(...)
		task.defer(updateVisible)
	end))
	task.defer(updateVisible)
end
local function createFrame(secondaryParent, createFrameText, ...)
	local parent = Instance.new("Frame")
	parent.Size = UDim2.new(1, 0, 0, 22)
	parent.BackgroundTransparency = 1
	parent.BorderSizePixel = 0
	parent.LayoutOrder = handleLayoutOrder(secondaryParent)
	parent.ZIndex = 11
	parent.Parent = secondaryParent
	local textLabel = Instance.new("TextLabel")
	textLabel.AutomaticSize = Enum.AutomaticSize.X
	textLabel.Size = UDim2.fromOffset(0, 22)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = createFrameText
	textLabel.TextColor3 = colors.cyan
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 13
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.ZIndex = 11
	textLabel.Parent = parent
	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0, 0.5)
	frame.BackgroundColor3 = colors.cyan
	frame.BackgroundTransparency = 0.46
	frame.BorderSizePixel = 0
	frame.ZIndex = 11
	frame.Parent = parent
	local uiGradient = Instance.new("UIGradient")
	uiGradient.Transparency =
		NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.12), NumberSequenceKeypoint.new(1, 1) })
	uiGradient.Parent = frame
	task.defer(function(...)
		if parent.Parent and textLabel.Parent then
			local createFrameNumber = math.ceil(textLabel.TextBounds.X) + 10
			frame.Position = UDim2.fromOffset(createFrameNumber, 11)
			frame.Size = UDim2.new(1, -createFrameNumber - 2, 0, 1)
		end
	end)
	return textLabel
end
local function createUiCorner(parent, createUiCornerFlag, ...)
	parent.Size = UDim2.new(1, 0, 0, createUiCornerFlag or 38)
	parent.BackgroundColor3 = colors.row
	parent.BackgroundTransparency = 0.1
	parent.BorderSizePixel = 0
	parent.ZIndex = 11
	(Instance.new("UICorner", parent)).CornerRadius = UDim.new(0, 8)
	local uiStroke = Instance.new("UIStroke", parent)
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Color = colors.blue
	uiStroke.Thickness = 1
	uiStroke.Transparency = 0.4
	return uiStroke
end
local function createStatusDot(
	secondaryParent,
	createStatusDotText,
	flag,
	createStatusDotFlag,
	condition,
	createStatusDotCondition,
	...
)
	local parent = Instance.new("Frame")
	parent.LayoutOrder = handleLayoutOrder(secondaryParent)
	parent.Parent = secondaryParent
	createUiCorner(parent, 34)
	if createStatusDotCondition then
		local frame = Instance.new("Frame")
		frame.Size = UDim2.fromOffset(3, 20)
		frame.Position = UDim2.new(0, 8, 0.5, -10)
		frame.BackgroundColor3 = colors.cyan
		frame.BackgroundTransparency = 0.1
		frame.BorderSizePixel = 0
		frame.ZIndex = 12
		frame.Parent = parent;
		(Instance.new("UICorner", frame)).CornerRadius = UDim.new(1, 0)
	end
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0.42, -10, 1, 0)
	textLabel.Position = UDim2.fromOffset(createStatusDotCondition and 20 or 11, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = createStatusDotText
	textLabel.TextColor3 = colors.dim
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 11
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.ZIndex = 12
	textLabel.Parent = parent
	local secondaryTextLabel = Instance.new("TextLabel")
	secondaryTextLabel.Size = UDim2.new(0.58, -12, 1, 0)
	secondaryTextLabel.Position = UDim2.new(0.42, 0, 0, 0)
	if condition then
		secondaryTextLabel.Size = UDim2.new(0.58, -30, 1, 0)
	end
	secondaryTextLabel.BackgroundTransparency = 1
	secondaryTextLabel.Text = tostring(flag or "-")
	secondaryTextLabel.TextColor3 = createStatusDotFlag or colors.white
	secondaryTextLabel.Font = Enum.Font.FredokaOne
	secondaryTextLabel.TextSize = 11
	secondaryTextLabel.TextWrapped = true
	secondaryTextLabel.TextXAlignment = Enum.TextXAlignment.Right
	secondaryTextLabel.ZIndex = 12
	secondaryTextLabel.Parent = parent
	local frame
	if condition then
		frame = Instance.new("Frame")
		frame.Name = "StatusDot"
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Size = UDim2.fromOffset(7, 7)
		frame.Position = UDim2.new(1, -13, 0.5, 0)
		frame.BackgroundColor3 = createStatusDotFlag or colors.green
		frame.BorderSizePixel = 0
		frame.ZIndex = 13
		frame.Parent = parent;
		(Instance.new("UICorner", frame)).CornerRadius = UDim.new(1, 0)
		local uiStroke = Instance.new("UIStroke", frame)
		uiStroke.Color = createStatusDotFlag or colors.green
		uiStroke.Thickness = 2
		uiStroke.Transparency = 0.58
	end
	return secondaryTextLabel, parent, textLabel, frame
end
local function handleInstance(parent, createStatusDotFlag, ...)
	local instanceResult = createStatusDot(parent, "Estado", createStatusDotFlag, colors.green)
	return instanceResult
end
local function createTextButton(
	secondaryParent,
	createTextButton,
	tertiaryArgument,
	createTextButtonFlag,
	backgroundColor3,
	...
)
	local parent = Instance.new("TextButton")
	parent.LayoutOrder = handleLayoutOrder(secondaryParent)
	parent.Text = createTextButton
	parent.TextColor3 = colors.white
	parent.Font = Enum.Font.FredokaOne
	parent.TextSize = 12
	parent.AutoButtonColor = false
	parent.Parent = secondaryParent
	local createTextButtonResult = createUiCorner(parent, 38)
	parent.BackgroundColor3 = createTextButtonFlag or colors.row
	handleFrame(parent.Activated:Connect(function(...)
		if backgroundColor3 then
			parent.BackgroundColor3 = backgroundColor3
		end
		pcall(tertiaryArgument, parent)
	end))
	handleFrame(parent.MouseEnter:Connect(function(...)
		(
			tweenService:Create(
				parent,
				TweenInfo.new(0.1),
				{ ["BackgroundColor3"] = backgroundColor3 or colors.rowHover }
			)
		):Play();
		(tweenService:Create(
			createTextButtonResult,
			TweenInfo.new(0.1),
			{ ["Transparency"] = 0.18, ["Color"] = colors.cyan }
		)):Play()
	end))
	handleFrame(parent.MouseLeave:Connect(function(...)
		(tweenService:Create(parent, TweenInfo.new(0.1), { ["BackgroundColor3"] = createTextButtonFlag or colors.row })):Play();
		(tweenService:Create(
			createTextButtonResult,
			TweenInfo.new(0.1),
			{ ["Transparency"] = 0.4, ["Color"] = colors.blue }
		)):Play()
	end))
	return parent
end
local function secondaryCreateTextButton(additionalParent, createTextButton, tertiaryArgument, ...)
	local parent = Instance.new("TextButton")
	parent.LayoutOrder = handleLayoutOrder(additionalParent)
	parent.Text = ""
	parent.AutoButtonColor = false
	parent.Parent = additionalParent
	local createTextButtonResult = createUiCorner(parent, 40)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(3, 24)
	frame.Position = UDim2.new(0, 8, 0.5, -12)
	frame.BackgroundColor3 = colors.cyan
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.ZIndex = 12
	frame.Parent = parent;
	(Instance.new("UICorner", frame)).CornerRadius = UDim.new(1, 0)
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -72, 1, 0)
	textLabel.Position = UDim2.fromOffset(20, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = createTextButton
	textLabel.TextColor3 = colors.white
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 12
	textLabel.TextWrapped = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.ZIndex = 12
	textLabel.Parent = parent
	local secondaryParent = Instance.new("Frame")
	secondaryParent.Size = UDim2.fromOffset(40, 20)
	secondaryParent.Position = UDim2.new(1, -50, 0.5, -10)
	secondaryParent.BackgroundColor3 = Color3.fromRGB(14, 51, 78)
	secondaryParent.BackgroundTransparency = 0.12
	secondaryParent.BorderSizePixel = 0
	secondaryParent.ZIndex = 12
	secondaryParent.Parent = parent;
	(Instance.new("UICorner", secondaryParent)).CornerRadius = UDim.new(1, 0)
	local alternateParent = Instance.new("Frame")
	alternateParent.Size = UDim2.fromOffset(14, 14)
	alternateParent.Position = UDim2.fromOffset(3, 3)
	alternateParent.BackgroundColor3 = colors.soft
	alternateParent.BorderSizePixel = 0
	alternateParent.ZIndex = 13
	alternateParent.Parent = secondaryParent;
	(Instance.new("UICorner", alternateParent)).CornerRadius = UDim.new(1, 0)
	local createTextButtonFlag = false
	local textButtonFlag = false
	local createTextButtonData = {}
	createTextButtonData.Button = parent
	local function handleTextButton(...)
		(tweenService:Create(
			secondaryParent,
			TweenInfo.new(0.14, Enum.EasingStyle.Quad),
			{
				["BackgroundColor3"] = textButtonFlag and Color3.fromRGB(28, 42, 55)
					or createTextButtonFlag and colors.blue
					or Color3.fromRGB(14, 51, 78),
			}
		)):Play();
		(tweenService:Create(
			alternateParent,
			TweenInfo.new(0.14, Enum.EasingStyle.Quad),
			{
				["Position"] = createTextButtonFlag and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
				["BackgroundColor3"] = createTextButtonFlag and colors.white or colors.soft,
				["BackgroundTransparency"] = textButtonFlag and 0.48 or 0,
			}
		)):Play();
		(tweenService:Create(
			createTextButtonResult,
			TweenInfo.new(0.14),
			{
				["Color"] = textButtonFlag and colors.dim or createTextButtonFlag and colors.cyan or colors.blue,
				["Transparency"] = textButtonFlag and 0.82 or createTextButtonFlag and 0.08 or 0.4,
			}
		)):Play();
		(tweenService:Create(
			textLabel,
			TweenInfo.new(0.14),
			{
				["TextColor3"] = textButtonFlag and colors.dim or colors.white,
				["TextTransparency"] = textButtonFlag and 0.42 or 0,
			}
		)):Play();
		(tweenService:Create(
			frame,
			TweenInfo.new(0.14),
			{ ["BackgroundTransparency"] = textButtonFlag and 0.72 or 0.1 }
		)):Play();
		(tweenService:Create(
			parent,
			TweenInfo.new(0.14),
			{ ["BackgroundTransparency"] = textButtonFlag and 0.48 or 0.1 }
		)):Play()
	end
	function createTextButtonData.Set(createTextButtonArgument, flag, secondaryCreateTextButtonFlag, ...)
		flag = flag == true
		if textButtonFlag and flag then
			return false
		end
		if createTextButtonFlag == flag then
			return createTextButtonFlag
		end
		createTextButtonFlag = flag
		if not secondaryCreateTextButtonFlag then
			local success, result = pcall(tertiaryArgument, createTextButtonFlag)
			if not success or result == false then
				createTextButtonFlag = not createTextButtonFlag
			end
		end
		handleTextButton()
		return createTextButtonFlag
	end
	function createTextButtonData.Get(createTextButtonArgument, ...)
		return createTextButtonFlag
	end
	function createTextButtonData.SetLocked(createTextButtonArgument, secondaryArgument, ...)
		textButtonFlag = secondaryArgument == true
		if textButtonFlag and createTextButtonFlag then
			createTextButtonFlag = false
			pcall(tertiaryArgument, false)
		end
		handleTextButton()
	end
	function createTextButtonData.IsLocked(createTextButtonArgument, ...)
		return textButtonFlag
	end
	handleFrame(parent.Activated:Connect(function(...)
		if not textButtonFlag then
			createTextButtonData:Set(not createTextButtonFlag)
		end
	end))
	handleFrame(parent.MouseEnter:Connect(function(...)
		if not textButtonFlag then
			(tweenService:Create(parent, TweenInfo.new(0.1), { ["BackgroundColor3"] = colors.rowHover })):Play()
		end
	end))
	handleFrame(parent.MouseLeave:Connect(function(...)
		(tweenService:Create(parent, TweenInfo.new(0.1), { ["BackgroundColor3"] = colors.row })):Play()
	end))
	handleTextButton()
	return createTextButtonData, parent
end
local function secondaryCreateFrame(
	secondaryParent,
	createFrameText,
	createFrameData,
	updateTextFlag,
	createFrameFlag,
	...
)
	local parent = Instance.new("Frame")
	parent.LayoutOrder = handleLayoutOrder(secondaryParent)
	parent.Parent = secondaryParent
	parent.ClipsDescendants = true
	createUiCorner(parent, 46)
	local textButton = Instance.new("TextButton")
	textButton.Size = UDim2.new(1, 0, 0, 46)
	textButton.BackgroundTransparency = 1
	textButton.BorderSizePixel = 0
	textButton.Text = ""
	textButton.AutoButtonColor = false
	textButton.ZIndex = 13
	textButton.Parent = parent
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0.42, -12, 1, 0)
	textLabel.Position = UDim2.fromOffset(11, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = createFrameText
	textLabel.TextColor3 = colors.soft
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 11
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.ZIndex = 14
	textLabel.Parent = textButton
	local secondaryTextLabel = Instance.new("TextLabel")
	secondaryTextLabel.Size = UDim2.new(0.58, -34, 1, 0)
	secondaryTextLabel.Position = UDim2.new(0.42, 0, 0, 0)
	secondaryTextLabel.BackgroundTransparency = 1
	secondaryTextLabel.TextColor3 = colors.white
	secondaryTextLabel.Font = Enum.Font.FredokaOne
	secondaryTextLabel.TextSize = 11
	secondaryTextLabel.TextWrapped = true
	secondaryTextLabel.TextXAlignment = Enum.TextXAlignment.Right
	secondaryTextLabel.ZIndex = 14
	secondaryTextLabel.Parent = textButton
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.fromOffset(24, 46)
	valueLabel.Position = UDim2.new(1, -28, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = "\226\140\132"
	valueLabel.TextColor3 = colors.cyan
	valueLabel.Font = Enum.Font.FredokaOne
	valueLabel.TextSize = 16
	valueLabel.ZIndex = 14
	valueLabel.Parent = textButton
	local scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Size = UDim2.new(1, -12, 0, 0)
	scrollingFrame.Position = UDim2.fromOffset(6, 46)
	scrollingFrame.BackgroundColor3 = colors.base
	scrollingFrame.BackgroundTransparency = 0.12
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.ScrollBarThickness = 2
	scrollingFrame.ScrollBarImageColor3 = colors.cyan
	scrollingFrame.CanvasSize = UDim2.new()
	scrollingFrame.Visible = false
	scrollingFrame.ZIndex = 14
	scrollingFrame.Parent = parent;
	(Instance.new("UICorner", scrollingFrame)).CornerRadius = UDim.new(0, 6)
	local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 2)
	local uiPadding = Instance.new("UIPadding", scrollingFrame)
	uiPadding.PaddingTop = UDim.new(0, 3)
	uiPadding.PaddingBottom = UDim.new(0, 3)
	uiPadding.PaddingLeft = UDim.new(0, 3)
	uiPadding.PaddingRight = UDim.new(0, 3)
	local openData = { ["values"] = createFrameData or {}, ["index"] = 1, ["open"] = false }
	local function isCreateFrameValid(item, ...)
		return item and tostring(type(item) == "table" and (item.label or item.name or item[1]) or item)
			or "Sin opciones"
	end
	local function getTextIndex(...)
		return openData.values[openData.index]
	end
	local function updateFrame(createFrameFlag, ...)
		local item = getTextIndex()
		secondaryTextLabel.Text = isCreateFrameValid(item)
		if createFrameFlag and updateTextFlag then
			pcall(updateTextFlag, item)
		end
	end
	local function updateTextButton(createFrameArgument, ...)
		openData.open = createFrameArgument == true and #openData.values > 0
		local createFrameNumber = math.min(#openData.values, 5) * 30 + 6
		scrollingFrame.Visible = openData.open
		scrollingFrame.Size = UDim2.new(1, -12, 0, openData.open and createFrameNumber or 0)
		parent.Size = UDim2.new(1, 0, 0, 46 + (openData.open and createFrameNumber or 0))
		if openData.open and createFrameFlag then
			task.defer(createFrameFlag, parent)
		end
		valueLabel.Text = openData.open and "\226\140\131" or "\226\140\132"
	end
	local function createTextButton(...)
		for index, item in ipairs(scrollingFrame:GetChildren()) do
			if item:IsA("TextButton") then
				item:Destroy()
			end
		end
		for index, item in ipairs(openData.values) do
			local parent = Instance.new("TextButton")
			parent.Size = UDim2.new(1, -6, 0, 28)
			parent.BackgroundColor3 = index == openData.index and colors.tabOn or colors.row
			parent.BackgroundTransparency = index == openData.index and 0.08 or 0.22
			parent.BorderSizePixel = 0
			parent.Text = isCreateFrameValid(item)
			parent.TextColor3 = colors.white
			parent.Font = Enum.Font.FredokaOne
			parent.TextSize = 11
			parent.TextWrapped = true
			parent.AutoButtonColor = false
			parent.LayoutOrder = index
			parent.ZIndex = 15
			parent.Parent = scrollingFrame;
			(Instance.new("UICorner", parent)).CornerRadius = UDim.new(0, 5)
			handleFrame(parent.Activated:Connect(function(...)
				openData.index = index
				updateFrame(true)
				updateTextButton(false)
				createTextButton()
			end))
			handleFrame(parent.MouseEnter:Connect(function(...)
				(tweenService:Create(
					parent,
					TweenInfo.new(0.08),
					{
						["BackgroundColor3"] = index == openData.index and colors.tabOn or colors.rowHover,
						["BackgroundTransparency"] = 0.06,
					}
				)):Play()
			end))
			handleFrame(parent.MouseLeave:Connect(function(...)
				(tweenService:Create(
					parent,
					TweenInfo.new(0.08),
					{
						["BackgroundColor3"] = index == openData.index and colors.tabOn or colors.row,
						["BackgroundTransparency"] = index == openData.index and 0.08 or 0.22,
					}
				)):Play()
			end))
		end
		scrollingFrame.CanvasSize = UDim2.fromOffset(0, #openData.values * 30 + 6)
	end
	function openData.Get(createFrameArgument, ...)
		return getTextIndex()
	end
	function openData.SetValues(createFrameArgument, valuesFlag, createFrameFlag, ...)
		local createFrameCondition = createFrameFlag and getTextIndex() or nil
		openData.values = valuesFlag or {}
		openData.index = 1
		if createFrameCondition then
			for index, item in ipairs(openData.values) do
				local createFrameFlag = item == createFrameCondition
				if type(item) == "table" and type(createFrameCondition) == "table" then
					createFrameFlag = item.userId and item.userId == createFrameCondition.userId
						or item.name and item.name == createFrameCondition.name
				end
				if createFrameFlag then
					openData.index = index
					break
				end
			end
		end
		createTextButton()
		updateTextButton(false)
		updateFrame(true)
	end
	function openData.SetIndex(createFrameArgument, createFrameNumber, ...)
		if #openData.values == 0 then
			openData.index = 1
		else
			openData.index = (createFrameNumber - 1) % #openData.values + 1
		end
		createTextButton()
		updateTextButton(false)
		updateFrame(true)
	end
	handleFrame(textButton.Activated:Connect(function(...)
		updateTextButton(not openData.open)
	end))
	handleFrame(textButton.MouseEnter:Connect(function(...)
		(tweenService:Create(parent, TweenInfo.new(0.1), { ["BackgroundColor3"] = colors.rowHover })):Play()
	end))
	handleFrame(textButton.MouseLeave:Connect(function(...)
		(tweenService:Create(parent, TweenInfo.new(0.1), { ["BackgroundColor3"] = colors.row })):Play()
	end))
	createTextButton()
	updateFrame(true)
	return openData, secondaryTextLabel
end
local function alternateCreateFrame(secondaryParent, createFrameText, placeholderText, quaternaryArgument, ...)
	local parent = Instance.new("Frame")
	parent.LayoutOrder = handleLayoutOrder(secondaryParent)
	parent.Parent = secondaryParent
	createUiCorner(parent, 48)
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0.42, -12, 1, 0)
	textLabel.Position = UDim2.fromOffset(11, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = createFrameText
	textLabel.TextColor3 = colors.soft
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 11
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.ZIndex = 12
	textLabel.Parent = parent
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0.58, -12, 0, 30)
	textBox.Position = UDim2.new(0.42, 0, 0.5, -15)
	textBox.BackgroundColor3 = colors.panel
	textBox.BackgroundTransparency = 0.08
	textBox.BorderSizePixel = 0
	textBox.PlaceholderText = placeholderText
	textBox.PlaceholderColor3 = colors.dim
	textBox.Text = ""
	textBox.TextColor3 = colors.white
	textBox.Font = Enum.Font.FredokaOne
	textBox.TextSize = 11
	textBox.ClearTextOnFocus = false
	textBox.ZIndex = 12
	textBox.Parent = parent;
	(Instance.new("UICorner", textBox)).CornerRadius = UDim.new(0, 6)
	handleFrame(textBox.FocusLost:Connect(function(...)
		pcall(quaternaryArgument, textBox.Text)
	end))
	return textBox
end
local function updatePositionFromInput(
	secondaryParent,
	text,
	secondaryUpdateTextNumber,
	number,
	secondaryNumber,
	additionalArgument,
	...
)
	local parent = Instance.new("Frame")
	parent.LayoutOrder = handleLayoutOrder(secondaryParent)
	parent.Parent = secondaryParent
	createUiCorner(parent, 50)
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -20, 0, 20)
	textLabel.Position = UDim2.fromOffset(10, 2)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = colors.white
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 11
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.ZIndex = 12
	textLabel.Parent = parent
	local textButton = Instance.new("TextButton")
	textButton.Size = UDim2.new(1, -20, 0, 10)
	textButton.Position = UDim2.fromOffset(10, 31)
	textButton.BackgroundColor3 = Color3.fromRGB(8, 53, 84)
	textButton.BorderSizePixel = 0
	textButton.Text = ""
	textButton.AutoButtonColor = false
	textButton.ZIndex = 12
	textButton.Parent = parent;
	(Instance.new("UICorner", textButton)).CornerRadius = UDim.new(1, 0)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(0, 1)
	frame.BackgroundColor3 = colors.cyan
	frame.BorderSizePixel = 0
	frame.ZIndex = 13
	frame.Parent = textButton;
	(Instance.new("UICorner", frame)).CornerRadius = UDim.new(1, 0)
	local clampedValue = math.clamp(math.floor(secondaryNumber), secondaryUpdateTextNumber, number)
	local flag = false
	local function updateText(updateText, ...)
		clampedValue = math.clamp(math.floor(updateText + 0.5), secondaryUpdateTextNumber, number)
		local updateTextNumber = (clampedValue - secondaryUpdateTextNumber) / (number - secondaryUpdateTextNumber)
		textLabel.Text = text .. (": " .. (clampedValue .. ("/" .. number)));
		(tweenService:Create(frame, TweenInfo.new(0.08), { ["Size"] = UDim2.fromScale(updateTextNumber, 1) })):Play()
		pcall(additionalArgument, clampedValue)
	end
	local function handler(secondaryNumber, ...)
		local clampedValue =
			math.clamp((secondaryNumber - textButton.AbsolutePosition.X) / math.max(textButton.AbsoluteSize.X, 1), 0, 1)
		updateText(secondaryUpdateTextNumber + (number - secondaryUpdateTextNumber) * clampedValue)
	end
	handleFrame(textButton.InputBegan:Connect(function(input, ...)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			flag = true
			handler(input.Position.X)
		end
	end))
	handleFrame(userInputService.InputChanged:Connect(function(input, ...)
		if
			flag
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			handler(input.Position.X)
		end
	end))
	handleFrame(userInputService.InputEnded:Connect(function(input, ...)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			flag = false
		end
	end))
	updateText(clampedValue)
	return {
		["Get"] = function(...)
			return clampedValue
		end,
		["Set"] = updateText,
	}
end
do
	local parent = pages.Info
	createFrame(parent, "\240\159\145\164 Info Player \240\159\145\164")
	createStatusDot(parent, "User:", backpackContainer.DisplayName, colors.white)
	local textResult, statusDotContainer = createStatusDot(parent, "FPS:", "0", colors.green, true)
	local statusDot = statusDotContainer:FindFirstChild("StatusDot")
	local displayValue = isSendGiftRemoteCachedPingValid()
	local option = displayValue <= 70 and colors.green or displayValue <= 160 and colors.orange or colors.red
	local secondaryTextResult, secondaryStatusDotContainer =
		createStatusDot(parent, "Ping:", tostring(displayValue) .. " ms", option, true)
	local secondaryStatusDot = secondaryStatusDotContainer:FindFirstChild("StatusDot")
	createFrame(parent, "\240\159\140\144 Info Server \240\159\140\144")
	createStatusDot(parent, "Game:", "Muscle Legends", colors.cyan)
	local alternateTextResult = createStatusDot(parent, "Server Players:", "0/0", colors.white)
	createFrame(parent, "\226\154\161 Info RawExploits Muscle Legends Menu & 2zvh \226\154\161")
	createStatusDot(parent, "Script:", "Fast Glitch 100%", colors.cyan)
	createStatusDot(parent, "Autor:", "RawExploit", colors.white)
    createStatusDot(parent, "Cracker:", "2zvh", colors.white)
	createTextButton(parent, "2zvh's Socials!!", function(instance, ...)
		local text = instance.Text
		instance.Text = additionalHandler(public.Discord) and "Link copiado" or text
		task.delay(1.1, function(...)
			if instance and instance.Parent then
				instance.Text = text
			end
		end)
	end)
	createTextButton(parent, "YouTube", function(instance, ...)
		local text = instance.Text
		instance.Text = additionalHandler(public.YouTube) and "Link copiado" or text
		task.delay(1.1, function(...)
			if instance and instance.Parent then
				instance.Text = text
			end
		end)
	end)
	local sum = 0
	handleFrame(runService.RenderStepped:Connect(function(...)
		sum = sum + 1
	end))
	handleSendGiftRemote("infoUpdater", function(...)
		local number = tick()
		while pState.running do
			task.wait(1)
			local tickResult = tick()
			local secondarySum = sum
			sum = 0
			local secondaryNumber = math.floor(secondarySum / math.max(tickResult - number, 0.001) + 0.5)
			local backgroundColor3 = secondaryNumber >= 55 and colors.green
				or secondaryNumber >= 30 and colors.orange
				or colors.red
			textResult.Text = tostring(secondaryNumber)
			textResult.TextColor3 = backgroundColor3
			if statusDot then
				statusDot.BackgroundColor3 = backgroundColor3
				local uiStroke = statusDot:FindFirstChildOfClass("UIStroke")
				if uiStroke then
					uiStroke.Color = backgroundColor3
				end
			end
			number = tickResult
			local displayValue = isSendGiftRemoteCachedPingValid()
			local color = displayValue <= 70 and colors.green or displayValue <= 160 and colors.orange or colors.red
			secondaryTextResult.Text = tostring(displayValue) .. " ms"
			secondaryTextResult.TextColor3 = color
			if secondaryStatusDot then
				secondaryStatusDot.BackgroundColor3 = color
				local uiStroke = secondaryStatusDot:FindFirstChildOfClass("UIStroke")
				if uiStroke then
					uiStroke.Color = color
				end
			end
			alternateTextResult.Text = tostring(#players:GetPlayers()) .. ("/" .. tostring(players.MaxPlayers))
		end
	end)
end
do
	local parent = pages.Main
	createFrame(parent, "MAIN")
	local updateInstancePropertiesCondition
	local updateInstancePropertiesFlag
	local flag = false
	local sum = 0
	local function updateInstanceProperties(...)
		local numberText = (tostring(
			updateInstancePropertiesCondition and updateInstancePropertiesCondition.Text or pState.mainSize
		)):gsub(",", ".")
		local updateInstancePropertiesNumber = tonumber(numberText)
		local mainSize = math.clamp(math.floor((updateInstancePropertiesNumber or pState.mainSize or 1) + 0.5), 1, 100)
		pState.mainSize = mainSize
		if updateInstancePropertiesCondition then
			updateInstancePropertiesCondition.Text = tostring(mainSize)
		end
		return mainSize
	end
	local function secondaryHandler(...)
		local rEvents = replicatedStorage:FindFirstChild("rEvents")
		local option = rEvents and rEvents:FindFirstChild("changeSpeedSizeRemote")
		if not option or flag then
			return
		end
		local result = updateInstanceProperties()
		flag = true
		sum = sum + 1
		local capturedSum = sum
		task.spawn(function(...)
			if option:IsA("RemoteEvent") then
				pcall(option.FireServer, option, "changeSize", result)
			else
				pcall(option.InvokeServer, option, "changeSize", result)
			end
			if sum == capturedSum then
				flag = false
			end
		end)
		task.delay(0.8, function(...)
			if sum == capturedSum then
				flag = false
			end
		end)
	end
	updateInstancePropertiesCondition = alternateCreateFrame(
		parent,
		"Set Size (Maximum 100)",
		"Example: 2",
		function(...)
			updateInstanceProperties()
			if pState.mainAutoSize then
				secondaryHandler()
			end
		end
	)
	updateInstancePropertiesCondition.Text = "2"
	secondaryCreateTextButton(parent, "Auto Set Size", function(argument, ...)
		updateInstanceProperties()
		pState.mainAutoSize = argument == true
		handleValue("mainAutoSize")
		if pState.mainAutoSize then
			secondaryHandler()
			handleSendGiftRemote("mainAutoSize", function(...)
				while pState.running and pState.mainAutoSize do
					secondaryHandler()
					task.wait(0.1)
				end
			end)
		else
			sum = sum + 1
			flag = false
		end
		return true
	end)
	local updateWalkSpeedData = setmetatable({}, { ["__mode"] = "k" })
	local capturedInstance = nil
	local connection = nil
	local secondaryFlag = false
	local function secondaryUpdateInstanceProperties(...)
		local numberText = (tostring(
			updateInstancePropertiesFlag and updateInstancePropertiesFlag.Text or pState.mainSpeed
		)):gsub(",", ".")
		local updateInstancePropertiesNumber = tonumber(numberText)
		local mainSpeed = math.max(0, math.floor((updateInstancePropertiesNumber or pState.mainSpeed or 125) + 0.5))
		pState.mainSpeed = mainSpeed
		if updateInstancePropertiesFlag then
			updateInstancePropertiesFlag.Text = tostring(mainSpeed)
		end
		return mainSpeed
	end
	local function updateWalkSpeedConnection(...)
		local instance = isUseToolValid()
		if not instance then
			return
		end
		if updateWalkSpeedData[instance] == nil then
			updateWalkSpeedData[instance] = instance.WalkSpeed
		end
		if capturedInstance ~= instance then
			if connection then
				connection:Disconnect()
				connection = nil
			end
			capturedInstance = instance
			connection = (instance:GetPropertyChangedSignal("WalkSpeed")):Connect(function(...)
				if
					pState.mainAutoSpeed
					and (not secondaryFlag and (instance.Parent and instance.WalkSpeed ~= pState.mainSpeed))
				then
					secondaryFlag = true
					instance.WalkSpeed = pState.mainSpeed
					secondaryFlag = false
				end
			end)
		end
		if instance.WalkSpeed ~= pState.mainSpeed then
			secondaryFlag = true
			instance.WalkSpeed = pState.mainSpeed
			secondaryFlag = false
		end
	end
	local function updateWalkSpeed(...)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		capturedInstance = nil
		for key, walkSpeed in pairs(updateWalkSpeedData) do
			if key and (key.Parent and not pState.fastSpeed) then
				key.WalkSpeed = walkSpeed
			end
		end
	end
	updateInstancePropertiesFlag = alternateCreateFrame(parent, "Set Speed", "Ejemplo: 125", function(...)
		secondaryUpdateInstanceProperties()
		if pState.mainAutoSpeed then
			updateWalkSpeedConnection()
		end
	end)
	updateInstancePropertiesFlag.Text = "125"
	secondaryCreateTextButton(parent, "Auto Set Speed", function(argument, ...)
		secondaryUpdateInstanceProperties()
		pState.mainAutoSpeed = argument == true
		handleValue("mainAutoSpeed")
		if pState.mainAutoSpeed then
			updateWalkSpeedConnection()
			handleSendGiftRemote("mainAutoSpeed", function(...)
				while pState.running and pState.mainAutoSpeed do
					updateWalkSpeedConnection()
					runService.Stepped:Wait()
					updateWalkSpeedConnection()
					runService.RenderStepped:Wait()
				end
			end)
		else
			updateWalkSpeed()
		end
		return true
	end)
	secondaryCreateFrame(parent, "Set Time", { "Day", "Night" }, function(argument, ...)
		lighting.ClockTime = argument == "Night" and 0 or 14
	end, function(instance, ...)
		runService.Heartbeat:Wait()
		runService.Heartbeat:Wait()
		local number = math.max(0, parent.AbsoluteCanvasSize.Y - parent.AbsoluteSize.Y)
		local difference = ((instance.AbsolutePosition.Y - parent.AbsolutePosition.Y) + parent.CanvasPosition.Y) - 3
		(tweenService:Create(
			parent,
			TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{ ["CanvasPosition"] = Vector2.new(0, math.clamp(difference, 0, number)) }
		)):Play()
	end)
	secondaryCreateTextButton(parent, "Infinite Jump", function(argument, ...)
		pState.infiniteJump = argument == true
		return true
	end)
	handleFrame(userInputService.JumpRequest:Connect(function(...)
		if pState.infiniteJump then
			local condition = isUseToolValid()
			if condition then
				condition:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end))
	handler(function(...)
		pState.mainAutoSize = false
		pState.mainAutoSpeed = false
		pState.infiniteJump = false
		sum = sum + 1
		flag = false
		handleValue("mainAutoSize")
		handleValue("mainAutoSpeed")
		updateWalkSpeed()
	end)
end
do
	local parent = pages["Fast Glitch 100%"]
	createFrame(parent, "FAST GLITCH 100%")
	local data = {}
	local flag = false
	secondaryCreateTextButton(parent, "Fast Punch ", function(updateInstancePropertiesFlag, ...)
		alternateUpdateInstanceProperties(updateInstancePropertiesFlag)
		flag = true
		for index, item in ipairs(data) do
			if not updateInstancePropertiesFlag then
				item:Set(false, true)
			end
			item:SetLocked(not updateInstancePropertiesFlag)
		end
		flag = false
		if not updateInstancePropertiesFlag then
			updateInstanceProperties()
		end
	end)
	local textResult, result, textSizeResult = createStatusDot(parent, "Glitch Time:", "0d 0h 0m 0s", colors.cyan)
	textSizeResult.TextColor3 = colors.white
	textSizeResult.TextSize = 12
	textResult.TextSize = 12
	handleSendGiftRemote("rockSessionTimer", function(...)
		while pState.running do
			local rockSessionStartedAt = pState.rockSessionStartedAt
			local condition = pState.fastPunch and (pState.selectedRock ~= nil and rockSessionStartedAt ~= nil)
			if condition then
				local number = math.max(0, math.floor(clock() - rockSessionStartedAt))
				local secondaryNumber = math.floor(number / 86400)
				local alternateNumber = math.floor((number % 86400) / 3600)
				local additionalNumber = math.floor((number % 3600) / 60)
				local remainder = number % 60
				textResult.Text =
					string.format("%dd %dh %dm %ds", secondaryNumber, alternateNumber, additionalNumber, remainder)
			else
				textResult.Text = "0d 0h 0m 0s"
			end
			task.wait(0.2)
		end
	end)
	secondaryCreateTextButton(parent, "Hide Durability", function(argument, ...)
		updateChildAddedConnection(argument)
	end)
	createFrame(parent, "Rocks")
	for index, item in ipairs(public.Rocks) do
		local selectedRock = item
		local result
		result = secondaryCreateTextButton(parent, selectedRock.name, function(condition, ...)
			if flag then
				return
			end
			if condition and not pState.fastPunch then
				return false
			end
			if condition then
				updateInstanceProperties()
				flag = true
				for index, item in ipairs(data) do
					if item ~= result then
						item:Set(false, true)
					end
				end
				flag = false
				pState.selectedRock = selectedRock
				pState.rockSessionStartedAt = clock()
			elseif pState.selectedRock == selectedRock then
				updateInstanceProperties()
			end
		end)
		result:SetLocked(true)
		data[#data + 1] = result
	end
end
do
	local parent = pages["Auto Farm"]
	createFrame(parent, "AUTO FARM")
	createTextButton(
		parent,
		"\240\159\145\189 Enable Auto Lift Gamepass for Free \240\159\145\189",
		function(textArgument, ...)
			if createNameFlag then
				return
			end
			if createName() then
				textArgument.Text = "\226\156\133 AutoLift Gamepass ACTIVADO \226\156\133"
				textArgument.TextColor3 = colors.green
			end
		end
	)
	local repToggles = {}
	local function handler(createTextButton, sendMuscleEventText, useToolData, sendMuscleEventFlag, ...)
		local result
		result = secondaryCreateTextButton(parent, createTextButton, function(condition, ...)
			if condition then
				for index, item in ipairs(repToggles) do
					if item ~= result then
						item:Set(false)
					end
				end
			end
			sendMuscleEvent(sendMuscleEventText, condition, useToolData, sendMuscleEventFlag)
		end)
		repToggles[#repToggles + 1] = result
	end
	handler("\240\159\143\139\239\184\143 Auto Weight \240\159\143\139\239\184\143", "autoWeight", { "Weight" }, 0.01)
	handler("\240\159\164\184 Auto Handstands \240\159\164\184", "autoHandstands", { "Handstands", "Handstand" }, 0.01)
	handler("\226\154\161 Auto Lift \226\154\161", "autoLift", { "Pushup", "Pushups" }, 0.01)
	handler("\240\159\167\152 Auto Situps \240\159\167\152", "autoSitups", { "Situps", "Situp" }, 0.01)
	modeData.RepToggles = repToggles
	secondaryCreateTextButton(parent, "\240\159\165\154 Auto Egg (30mins) \240\159\165\154", function(argument, ...)
		pState.setAutoEgg(argument)
	end)
	modeData.HideFramesToggle = secondaryCreateTextButton(
		parent,
		"\240\159\153\136 Ocultar Frames \240\159\153\136",
		function(argument, ...)
			secondaryUpdateChildAddedConnection(argument)
		end
	)
	createFrame(parent, "Machines")
	local machineToggles = {}
	local flag = false
	for index, item in ipairs(public.Machines) do
		local machine = item
		local result
		result = secondaryCreateTextButton(parent, machine.label, function(condition, ...)
			if flag then
				return
			end
			if condition then
				flag = true
				for key, item in pairs(machineToggles) do
					if item ~= result then
						item:Set(false)
					end
				end
				flag = false
				additionalUpdateInstanceProperties(machine, true)
			elseif pState.machine == machine then
				additionalUpdateInstanceProperties(machine, false)
			end
		end)
		machineToggles[#machineToggles + 1] = result
	end
	modeData.MachineToggles = machineToggles
end
do
	local parent = pages["Fast Farm"]
	local instance = createFrame(parent, "FAST FARM")
	instance.Parent.Size = UDim2.new(1, 0, 0, 16)
	instance.Size = UDim2.fromOffset(0, 16)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = colors.black
	frame.BackgroundTransparency = 0.22
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.ZIndex = 120
	frame.Parent = alternateParent
	local secondaryParent = Instance.new("Frame")
	secondaryParent.AnchorPoint = Vector2.new(0.5, 0.5)
	secondaryParent.Size = UDim2.new(1, -54, 0, 188)
	secondaryParent.Position = UDim2.fromScale(0.5, 0.5)
	secondaryParent.BackgroundColor3 = colors.panel
	secondaryParent.BackgroundTransparency = 0.02
	secondaryParent.BorderSizePixel = 0
	secondaryParent.ZIndex = 121
	secondaryParent.Parent = frame;
	(Instance.new("UICorner", secondaryParent)).CornerRadius = UDim.new(0, 12)
	local uiSizeConstraint = Instance.new("UISizeConstraint", secondaryParent)
	uiSizeConstraint.MaxSize = Vector2.new(390, 188)
	local uiStroke = Instance.new("UIStroke", secondaryParent)
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Color = colors.cyan
	uiStroke.Thickness = 2
	uiStroke.Transparency = 0.04
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -24, 0, 42)
	textLabel.Position = UDim2.fromOffset(12, 10)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "FAST FARM"
	textLabel.TextColor3 = colors.cyan
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 18
	textLabel.ZIndex = 122
	textLabel.Parent = secondaryParent
	local secondaryTextLabel = Instance.new("TextLabel")
	secondaryTextLabel.Size = UDim2.new(1, -34, 0, 70)
	secondaryTextLabel.Position = UDim2.fromOffset(17, 48)
	secondaryTextLabel.BackgroundTransparency = 1
	secondaryTextLabel.Text =
		"You need 7 or 8 packs are needed for this.\n\if you dont have them, dont enable them."
	secondaryTextLabel.TextColor3 = colors.white
	secondaryTextLabel.Font = Enum.Font.FredokaOne
	secondaryTextLabel.TextSize = 13
	secondaryTextLabel.TextWrapped = true
	secondaryTextLabel.ZIndex = 122
	secondaryTextLabel.Parent = secondaryParent
	local uiScale = Instance.new("UIScale", secondaryParent)
	uiScale.Scale = 0.94
	local continuarButton = Instance.new("TextButton")
	continuarButton.Size = UDim2.new(0.5, -20, 0, 42)
	continuarButton.Position = UDim2.new(0, 14, 1, -54)
	continuarButton.BackgroundColor3 = colors.tabOn
	continuarButton.BorderSizePixel = 0
	continuarButton.Text = "Continuar"
	continuarButton.TextColor3 = colors.white
	continuarButton.Font = Enum.Font.FredokaOne
	continuarButton.TextSize = 13
	continuarButton.AutoButtonColor = false
	continuarButton.ZIndex = 123
	continuarButton.Parent = secondaryParent;
	(Instance.new("UICorner", continuarButton)).CornerRadius = UDim.new(0, 8)
	local secondaryUiStroke = Instance.new("UIStroke", continuarButton)
	secondaryUiStroke.Color = colors.cyan
	secondaryUiStroke.Transparency = 0.15
	local salirButton = Instance.new("TextButton")
	salirButton.Size = UDim2.new(0.5, -20, 0, 42)
	salirButton.Position = UDim2.new(0.5, 6, 1, -54)
	salirButton.BackgroundColor3 = colors.row
	salirButton.BorderSizePixel = 0
	salirButton.Text = "Salir"
	salirButton.TextColor3 = colors.white
	salirButton.Font = Enum.Font.FredokaOne
	salirButton.TextSize = 13
	salirButton.AutoButtonColor = false
	salirButton.ZIndex = 123
	salirButton.Parent = secondaryParent;
	(Instance.new("UICorner", salirButton)).CornerRadius = UDim.new(0, 8)
	local alternateUiStroke = Instance.new("UIStroke", salirButton)
	alternateUiStroke.Color = colors.blue
	alternateUiStroke.Transparency = 0.35
	local updateInstancePropertiesFlag = nil
	local function onActivated(...)
		updateInstancePropertiesFlag = nil
		(tweenService:Create(
			uiScale,
			TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ ["Scale"] = 0.94 }
		)):Play()
		task.delay(0.12, function(...)
			if not updateInstancePropertiesFlag then
				frame.Visible = false
			end
		end)
	end
	local function updateStart(updateStartFlag, ...)
		updateInstancePropertiesFlag = updateStartFlag
		frame.Visible = true
		uiScale.Scale = 0.94
		(tweenService:Create(
			uiScale,
			TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			{ ["Scale"] = 1 }
		)):Play()
	end
	handleFrame(continuarButton.Activated:Connect(function(...)
		local flag = updateInstancePropertiesFlag
		if not flag then
			return
		end
		modeData.warningAccepted = true
		onActivated()
		task.defer(flag)
	end))
	handleFrame(salirButton.Activated:Connect(onActivated))
	handleFrame(continuarButton.MouseEnter:Connect(function(...)
		(tweenService:Create(continuarButton, TweenInfo.new(0.1), { ["BackgroundColor3"] = colors.blue })):Play()
	end))
	handleFrame(continuarButton.MouseLeave:Connect(function(...)
		(tweenService:Create(continuarButton, TweenInfo.new(0.1), { ["BackgroundColor3"] = colors.tabOn })):Play()
	end))
	handleFrame(salirButton.MouseEnter:Connect(function(...)
		(tweenService:Create(salirButton, TweenInfo.new(0.1), { ["BackgroundColor3"] = colors.rowHover })):Play()
	end))
	handleFrame(salirButton.MouseLeave:Connect(function(...)
		(tweenService:Create(salirButton, TweenInfo.new(0.1), { ["BackgroundColor3"] = colors.row })):Play()
	end))
	local startCondition
	local condition
	local function start(startFlag, startCondition, tertiaryArgument, ...)
		if not modeData.warningAccepted then
			updateStart(function(...)
				if startFlag and startFlag:Get() == false then
					startFlag:Set(true)
				end
			end)
			return false
		end
		if startCondition then
			startCondition:Set(false)
		end
		return modeData:Start(tertiaryArgument)
	end
	startCondition = secondaryCreateTextButton(parent, "Fast Rebirth", function(secondaryCondition, ...)
		if secondaryCondition then
			return start(startCondition, condition, "rebirth")
		elseif modeData.mode == "rebirth" then
			modeData:Stop(true)
		end
	end)
	startCondition.Button.Size = UDim2.new(1, 0, 0, 40)
	condition = secondaryCreateTextButton(parent, "Fast Strenght", function(secondaryCondition, ...)
		if secondaryCondition then
			return start(condition, startCondition, "strength")
		elseif modeData.mode == "strength" then
			modeData:Stop(true)
		end
	end)
	condition.Button.Size = UDim2.new(1, 0, 0, 40)
	local textResult, secondaryInstance, textSizeResult =
		createStatusDot(parent, "Time:", "0d 0h 0m 0s", colors.white)
	secondaryInstance.Size = UDim2.new(1, 0, 0, 34)
	textSizeResult.TextColor3 = colors.white
	textSizeResult.TextSize = 12
	textResult.TextSize = 12
	local textStrokeTransparencyResult, alternateInstance, secondaryTextSizeResult =
		createStatusDot(parent, "Calculator:", "0/h  \226\128\162  0/d  \226\128\162  0/w", colors.white)
	alternateInstance.Size = UDim2.new(1, 0, 0, 34)
	alternateInstance.BackgroundTransparency = 0.02
	secondaryTextSizeResult.TextColor3 = colors.white
	secondaryTextSizeResult.TextSize = 13
	textStrokeTransparencyResult.TextSize = 13
	textStrokeTransparencyResult.TextColor3 = colors.white
	textStrokeTransparencyResult.TextStrokeColor3 = colors.panel
	textStrokeTransparencyResult.TextStrokeTransparency = 0.28
	local additionalUiStroke = alternateInstance:FindFirstChildOfClass("UIStroke")
	if additionalUiStroke then
		additionalUiStroke.Color = colors.cyan
		additionalUiStroke.Transparency = 0.28
	end
	local additionalParent = Instance.new("Frame")
	additionalParent.LayoutOrder = handleLayoutOrder(parent)
	additionalParent.Parent = parent
	createUiCorner(additionalParent, 70)
	local alternateTextLabel = Instance.new("TextLabel")
	alternateTextLabel.Size = UDim2.new(1, -20, 0, 22)
	alternateTextLabel.Position = UDim2.fromOffset(10, 3)
	alternateTextLabel.BackgroundTransparency = 1
	alternateTextLabel.Text = "Rebirths"
	alternateTextLabel.TextColor3 = colors.cyan
	alternateTextLabel.Font = Enum.Font.FredokaOne
	alternateTextLabel.TextSize = 12
	alternateTextLabel.ZIndex = 12
	alternateTextLabel.Parent = additionalParent
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(1, -20, 1, -25)
	valueLabel.Position = UDim2.fromOffset(10, 23)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = "0  (+0)"
	valueLabel.TextColor3 = colors.white
	valueLabel.Font = Enum.Font.FredokaOne
	valueLabel.TextScaled = true
	valueLabel.TextWrapped = true
	valueLabel.ZIndex = 12
	valueLabel.Parent = additionalParent
	local uiTextSizeConstraint = Instance.new("UITextSizeConstraint", valueLabel)
	uiTextSizeConstraint.MinTextSize = 14
	uiTextSizeConstraint.MaxTextSize = 32
	local function format(formatNumber, ...)
		formatNumber = math.max(0, math.floor(formatNumber or 0))
		local number = math.floor(formatNumber / 86400)
		local secondaryFormatNumber = math.floor((formatNumber % 86400) / 3600)
		local alternateFormatNumber = math.floor((formatNumber % 3600) / 60)
		local remainder = formatNumber % 60
		return string.format("%dd %dh %dm %ds", number, secondaryFormatNumber, alternateFormatNumber, remainder)
	end
	handleSendGiftRemote("fastFarmStatsUI", function(...)
		while pState.running do
			local readStats = modeData:ReadStats()
			local option = modeData.startStats or readStats
			local number = math.max(0, readStats.rebirths - (option.rebirths or readStats.rebirths))
			valueLabel.Text = handleValueLabelText(readStats.rebirths)
				.. ("  (+" .. (handleValueLabelText(number) .. ")"))
			if modeData.mode == "strength" and not modeData.startedAt then
				textResult.Text = "0d 0h 0m 0s"
				textStrokeTransparencyResult.Text = "0/h  \226\128\162  0/d  \226\128\162  0/w"
			elseif modeData.mode and modeData.startedAt then
				local number = math.max(clock() - modeData.startedAt, 0)
				local text
				if modeData.pingPaused then
					text = " Pausado por ping"
				else
					text = modeData.mode == "rebirth" and "" or " Training"
				end
				textResult.Text = format(number) .. text
				local product
				if modeData.mode == "rebirth" then
					product = (math.clamp(tonumber(modeData.packCount) or 0, 0, 8) * 2) * 600
				else
					local secondaryNumber = math.max(0, readStats.strength - (option.strength or readStats.strength))
					product = number >= 0.5 and (secondaryNumber * 3600) / number or 0
				end
				textStrokeTransparencyResult.Text = modeData:FormatCompact(product)
					.. (
						"/h  \226\128\162  "
						.. (
							modeData:FormatCompact(product * 24)
							.. ("/d  \226\128\162  " .. (modeData:FormatCompact(product * 168) .. "/w"))
						)
					)
			else
				textResult.Text = "0d 0h 0m 0s"
				textStrokeTransparencyResult.Text = "0/h  \226\128\162  0/d  \226\128\162  0/w"
			end
			task.wait(0.25)
		end
	end)
end
do
	local parent = pages.Teleports
	createFrame(parent, "Teleports")
	for index, item in ipairs(public.Teleports) do
		local capturedItem = item
		createTextButton(parent, capturedItem[1], function(...)
			local cFrameCondition = isSendHitEventValid()
			if cFrameCondition then
				cFrameCondition.CFrame = CFrame.new(capturedItem[2])
			end
		end)
	end
end
local function previousHandler(...)
	local data = {}
	for index, item in ipairs(players:GetPlayers()) do
		if item ~= backpackContainer then
			data[#data + 1] = { ["label"] = item.DisplayName, ["name"] = item.Name, ["userId"] = item.UserId }
		end
	end
	table.sort(data, function(labelArgument, secondaryArgument, ...)
		return labelArgument.label:lower() < secondaryArgument.label:lower()
	end)
	return data
end
do
	local parent = pages.Rebirths
	local vector = Vector3.new(-8646, 13.25, -5738)
	local number = 42
	local data = {
		{ ["name"] = "+1 Daily Spin", ["max"] = 5 },
		{ ["name"] = "+1 Pet Slot", ["max"] = 3 },
		{ ["name"] = "+10 Item Capacity", ["max"] = 6 },
		{ ["name"] = "+5% Rep Speed", ["max"] = 10 },
		{ ["name"] = "Demon Damage", ["max"] = 5 },
		{ ["name"] = "Galaxy Gains", ["max"] = 5 },
		{ ["name"] = "Golden Rebirth", ["max"] = 5 },
		{ ["name"] = "Jungle Swift", ["max"] = 5 },
		{ ["name"] = "Muscle Mind", ["max"] = 5 },
		{ ["name"] = "Infernal Health", ["remote"] = "InfernalHealth", ["max"] = 5 },
		{ ["name"] = "x2 Chest Rewards", ["max"] = 5 },
		{ ["name"] = "x2 Quest Rewards", ["max"] = 3 },
	}
	local function isValid(...)
		local rEvents = replicatedStorage:FindFirstChild("rEvents")
		return rEvents and rEvents:FindFirstChild("rebirthRemote")
	end
	local function secondaryHandler(...)
		local rEvents = replicatedStorage:FindFirstChild("rEvents")
		local condition = rEvents and rEvents:FindFirstChild("changeSpeedSizeRemote")
		if condition then
			pcall(condition.InvokeServer, condition, "changeSize", 1)
		end
	end
	local function clamp(clampFlag, ...)
		local numberText = (tostring(clampFlag or "")):gsub("[^%d]", "")
		local clampNumber = tonumber(numberText)
		if not clampNumber then
			return nil
		end
		return math.clamp(math.floor(clampNumber), 0, 9.007199254741e+15)
	end
	local function format(formatNumber, ...)
		if not formatNumber or formatNumber ~= formatNumber or formatNumber == math.huge then
			return "Calculando..."
		end
		formatNumber = math.max(0, math.floor(formatNumber + 0.5))
		local number = math.floor(formatNumber / 86400)
		local secondaryFormatNumber = math.floor((formatNumber % 86400) / 3600)
		local alternateFormatNumber = math.floor((formatNumber % 3600) / 60)
		local remainder = formatNumber % 60
		if number > 0 then
			return string.format("%dd %02dh %02dm", number, secondaryFormatNumber, alternateFormatNumber)
		elseif secondaryFormatNumber > 0 then
			return string.format("%dh %02dm %02ds", secondaryFormatNumber, alternateFormatNumber, remainder)
		end
		return string.format("%dm %02ds", alternateFormatNumber, remainder)
	end
	local function alternateHandler(secondaryData, ...)
		if #secondaryData == 0 then
			return nil
		end
		local data = table.clone(secondaryData)
		table.sort(data)
		local number = math.floor((#data + 1) / 2)
		if #data % 2 == 1 then
			return data[number]
		end
		return (data[number] + data[number + 1]) / 2
	end
	createFrame(parent, "REBIRTHS")
	local frame = Instance.new("Frame")
	frame.LayoutOrder = handleLayoutOrder(parent)
	frame.Parent = parent
	createUiCorner(frame, 62)
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -20, 0, 22)
	textLabel.Position = UDim2.fromOffset(10, 3)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "RENAS COUNTDOWN"
	textLabel.TextColor3 = colors.cyan
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 12
	textLabel.ZIndex = 12
	textLabel.Parent = frame
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.5, -12, 0, 25)
	valueLabel.Position = UDim2.fromOffset(11, 27)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = "Rebirths: 0"
	valueLabel.TextColor3 = colors.white
	valueLabel.Font = Enum.Font.FredokaOne
	valueLabel.TextSize = 14
	valueLabel.TextXAlignment = Enum.TextXAlignment.Left
	valueLabel.ZIndex = 12
	valueLabel.Parent = frame
	local clone = valueLabel:Clone()
	clone.Size = UDim2.new(0.5, -12, 0, 25)
	clone.Position = UDim2.new(0.5, 1, 0, 27)
	clone.Text = ""
	clone.TextXAlignment = Enum.TextXAlignment.Right
	clone.Visible = false
	clone.Parent = frame
	local input = valueLabel:Clone()
	input.Position = UDim2.fromOffset(11, 54)
	input.Text = ""
	input.Visible = false
	input.Parent = frame
	local secondaryClone = clone:Clone()
	secondaryClone.Position = UDim2.new(0.5, 1, 0, 54)
	secondaryClone.Text = ""
	secondaryClone.Visible = false
	secondaryClone.Parent = frame
	local secondaryValueLabel = Instance.new("TextLabel")
	secondaryValueLabel.Size = UDim2.new(1, -22, 0, 22)
	secondaryValueLabel.Position = UDim2.fromOffset(11, 79)
	secondaryValueLabel.BackgroundTransparency = 1
	secondaryValueLabel.Text = ""
	secondaryValueLabel.TextColor3 = colors.dim
	secondaryValueLabel.Font = Enum.Font.FredokaOne
	secondaryValueLabel.TextSize = 12
	secondaryValueLabel.TextXAlignment = Enum.TextXAlignment.Center
	secondaryValueLabel.Visible = false
	secondaryValueLabel.ZIndex = 12
	secondaryValueLabel.Parent = frame
	local samplesData = {
		["samples"] = {},
		["lastValue"] = nil,
		["burstGain"] = 0,
		["burstStartedAt"] = nil,
		["lastPositiveAt"] = nil,
		["previousBurstAt"] = nil,
		["smoothedEta"] = nil,
		["lastEtaUpdate"] = 0,
		["rebirthSpendSerial"] = 0,
	}
	local function updateInstanceProperties(lastValue, ...)
		table.clear(samplesData.samples)
		samplesData.lastValue = lastValue
		samplesData.burstGain = 0
		samplesData.burstStartedAt = nil
		samplesData.lastPositiveAt = nil
		samplesData.previousBurstAt = nil
		samplesData.smoothedEta = nil
		samplesData.lastEtaUpdate = 0
	end
	local function secondaryUpdateInstanceProperties(...)
		if samplesData.burstGain <= 0 or not samplesData.burstStartedAt then
			return
		end
		if samplesData.previousBurstAt then
			local updateInstancePropertiesNumber = samplesData.burstStartedAt - samplesData.previousBurstAt
			if updateInstancePropertiesNumber >= 0.08 and updateInstancePropertiesNumber <= 3600 then
				samplesData.samples[#samplesData.samples + 1] =
					{ ["interval"] = updateInstancePropertiesNumber, ["gain"] = samplesData.burstGain }
				while #samplesData.samples > 20 do
					table.remove(samplesData.samples, 1)
				end
			end
		end
		samplesData.previousBurstAt = samplesData.burstStartedAt
		samplesData.burstGain = 0
		samplesData.burstStartedAt = nil
		samplesData.lastPositiveAt = nil
	end
	local function alternateUpdateInstanceProperties(lastValue, burstStartedAt, ...)
		if samplesData.lastValue == nil then
			samplesData.lastValue = lastValue
			return
		end
		local updateInstancePropertiesNumber = lastValue - samplesData.lastValue
		samplesData.lastValue = lastValue
		if updateInstancePropertiesNumber > 0 then
			if samplesData.burstGain == 0 then
				samplesData.burstStartedAt = burstStartedAt
			end
			samplesData.burstGain = samplesData.burstGain + updateInstancePropertiesNumber
			samplesData.lastPositiveAt = burstStartedAt
		elseif updateInstancePropertiesNumber < 0 then
			samplesData.rebirthSpendSerial = samplesData.rebirthSpendSerial + 1
			samplesData.burstGain = 0
			samplesData.burstStartedAt = nil
			samplesData.lastPositiveAt = nil
			samplesData.previousBurstAt = nil
		end
		if samplesData.lastPositiveAt and burstStartedAt - samplesData.lastPositiveAt >= 0.85 then
			secondaryUpdateInstanceProperties()
		end
	end
	local function additionalHandler(...)
		if #samplesData.samples < 3 then
			return nil, nil, nil
		end
		local secondaryData, data = {}, {}
		for index, item in ipairs(samplesData.samples) do
			secondaryData[#secondaryData + 1] = item.interval
			data[#data + 1] = item.gain
		end
		local number = alternateHandler(secondaryData)
		local secondaryNumber = alternateHandler(data)
		local alternateSum, sum, secondarySum = 0, 0, 0
		for index, item in ipairs(samplesData.samples) do
			local option = item.interval >= number * 0.45 and item.interval <= number * 2.2
			local flag = item.gain >= secondaryNumber * 0.4 and item.gain <= secondaryNumber * 2.5
			if option and flag then
				local number = 0.45 + index / #samplesData.samples
				alternateSum = alternateSum + item.gain * number
				sum = sum + item.interval * number
				secondarySum = secondarySum + 1
			end
		end
		if secondarySum < 3 or sum <= 0 then
			return nil, number, secondaryNumber
		end
		return alternateSum / sum, number, secondaryNumber
	end
	local textResult
	local updateInstancePropertiesCondition
	local updateInstancePropertiesFlag
	createFrame(parent, "TOOLS")
	secondaryCreateTextButton(parent, "Set Size 1", function(argument, ...)
		pState.rebirth.sizeOne = argument == true
		handleValue("rebirthSizeOne")
		if pState.rebirth.sizeOne then
			secondaryHandler()
			handleSendGiftRemote("rebirthSizeOne", function(...)
				while pState.running and pState.rebirth.sizeOne do
					secondaryHandler()
					task.wait(0.75)
				end
			end)
		end
		return true
	end)
	secondaryCreateTextButton(parent, "Fast Weight", function(argument, ...)
		pState.rebirth.fastWeight = argument == true
		sendMuscleEvent("rebirthFastWeight", pState.rebirth.fastWeight, { "Weight", "Heavy Weight" }, 0.005)
		return true
	end)
	secondaryCreateTextButton(parent, "King", function(argument, ...)
		pState.rebirth.king = argument == true
		handleValue("rebirthKing")
		if pState.rebirth.king then
			handleSendGiftRemote("rebirthKing", function(...)
				while pState.running and pState.rebirth.king do
					local input = isSendHitEventValid()
					if input and (input.Position - vector).Magnitude > number then
						local raycastParams = RaycastParams.new()
						raycastParams.FilterType = Enum.RaycastFilterType.Exclude
						local filterDescendantsInstances = {}
						for index, item in ipairs(players:GetPlayers()) do
							if item.Character then
								filterDescendantsInstances[#filterDescendantsInstances + 1] = item.Character
							end
						end
						raycastParams.FilterDescendantsInstances = filterDescendantsInstances
						raycastParams.IgnoreWater = true
						local secondaryVector = vector
						local condition =
							workspace:Raycast(vector + Vector3.new(0, 35, 0), Vector3.new(0, -80, 0), raycastParams)
						if condition then
							secondaryVector = Vector3.new(vector.X, condition.Position.Y + 3.1, vector.Z)
						end
						local cFrame = CFrame.new(secondaryVector)
						if pState.rebirth.lockPosition then
							pState.rebirth.lockCFrame = cFrame
						end
						input.CFrame = cFrame
						input.AssemblyLinearVelocity = Vector3.zero
						input.AssemblyAngularVelocity = Vector3.zero
					end
					task.wait(0.25)
				end
			end)
		end
		return true
	end)
	secondaryCreateTextButton(parent, "Lock Position", function(argument, ...)
		pState.rebirth.lockPosition = argument == true
		local instance = isSendHitEventValid()
		pState.rebirth.lockCFrame = pState.rebirth.lockPosition and (instance and instance.CFrame) or nil
		handleValue("rebirthLock")
		if pState.rebirth.lockPosition and pState.rebirth.lockCFrame then
			handleSendGiftRemote("rebirthLock", function(...)
				while pState.running and pState.rebirth.lockPosition do
					local instance = isSendHitEventValid()
					if instance and pState.rebirth.lockCFrame then
						instance.CFrame = pState.rebirth.lockCFrame
						instance.AssemblyLinearVelocity = Vector3.zero
						instance.AssemblyAngularVelocity = Vector3.zero
					end
					runService.Heartbeat:Wait()
				end
			end)
		end
		return true
	end)
	secondaryCreateTextButton(parent, "Egg every 30 mins", function(argument, ...)
		pState.setAutoEgg(argument, "rebirth")
		return true
	end)
	textResult = alternateCreateFrame(parent, "Rebirths objective", "Example: 18,980", function(flag, ...)
		local target = clamp(flag)
		if target and target > 0 then
			pState.rebirth.target = target
			textResult.Text = (handleValueLabelText(target)):gsub("%.", ",")
		elseif (tostring(flag or "")):gsub("%s+", "") == "" then
			pState.rebirth.target = nil
			textResult.Text = ""
		else
			textResult.Text = pState.rebirth.target and (handleValueLabelText(pState.rebirth.target)):gsub("%.", ",")
				or ""
		end
	end)
	textResult.Text = ""
	local function additionalUpdateInstanceProperties(updateInstancePropertiesArgument, infiniteFlag, ...)
		if updateInstancePropertiesArgument == "target" then
			if infiniteFlag and not pState.rebirth.target then
				return false
			end
			pState.rebirth.autoTarget = infiniteFlag == true
			if pState.rebirth.autoTarget then
				pState.rebirth.infinite = false
				if updateInstancePropertiesFlag and updateInstancePropertiesFlag:Get() then
					updateInstancePropertiesFlag:Set(false, true)
				end
				local flag = isUpdateInstancePropertiesValid(backpackContainer, { "Rebirths", "Rebirth" })
				updateInstanceProperties(tonumber(flag and flag.Value) or 0)
				task.defer(function(...)
					runService.Heartbeat:Wait();
					(tweenService:Create(
						parent,
						TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{ ["CanvasPosition"] = Vector2.zero }
					)):Play()
				end)
			end
		elseif updateInstancePropertiesArgument == "infinite" then
			pState.rebirth.infinite = infiniteFlag == true
			if pState.rebirth.infinite then
				pState.rebirth.autoTarget = false
				if updateInstancePropertiesCondition and updateInstancePropertiesCondition:Get() then
					updateInstancePropertiesCondition:Set(false, true)
				end
			end
		end
		handleValue("rebirthLoop")
		if not pState.rebirth.autoTarget and not pState.rebirth.infinite then
			return true
		end
		handleSendGiftRemote("rebirthLoop", function(...)
			while pState.running and (pState.rebirth.autoTarget or pState.rebirth.infinite) do
				local updateInstancePropertiesFlag =
					isUpdateInstancePropertiesValid(backpackContainer, { "Rebirths", "Rebirth" })
				local updateInstancePropertiesOption = tonumber(
					updateInstancePropertiesFlag and updateInstancePropertiesFlag.Value
				) or 0
				if
					pState.rebirth.autoTarget
					and (pState.rebirth.target and updateInstancePropertiesOption >= pState.rebirth.target)
				then
					pState.rebirth.autoTarget = false
					if updateInstancePropertiesCondition then
						updateInstancePropertiesCondition:Set(false, true)
					end
					break
				end
				local condition = isValid()
				if condition then
					pcall(condition.InvokeServer, condition, "rebirthRequest")
				end
				task.wait(0.1)
			end
		end)
		return true
	end
	updateInstancePropertiesCondition = secondaryCreateTextButton(
		parent,
		"Rebirth until the objective",
		function(infiniteFlag, ...)
			return additionalUpdateInstanceProperties("target", infiniteFlag)
		end
	)
	updateInstancePropertiesFlag = secondaryCreateTextButton(
		parent,
		"Infinite Rebirts",
		function(infiniteFlag, ...)
			return additionalUpdateInstanceProperties("infinite", infiniteFlag)
		end
	)
	createFrame(parent, "ULTIMATES")
	local createFrameData = {}
	for index, item in ipairs(data) do
		createFrameData[#createFrameData + 1] = { ["label"] = item.name, ["name"] = item.name, ["data"] = item }
	end
	local isUpdateValidFlag
	local updateTextCondition
	local condition
	local updateTextFlag
	local result
	local capturedNumberText = nil
	local updateTextNumber = 0
	local function updateText(updateText, updateTextCondition, flag, ...)
		if not updateTextFlag then
			return
		end
		updateTextNumber = updateTextNumber + 1
		local capturedUpdateTextNumber = updateTextNumber
		if updateTextFlag then
			updateTextFlag.Text = updateText
		end
		if updateTextCondition then
			task.delay(updateTextCondition, function(...)
				if
					capturedUpdateTextNumber == updateTextNumber
					and (not pState.rebirth.ultimateRunning and (updateTextFlag and updateTextFlag.Parent))
				then
					updateTextFlag.Text = flag or "Esperando selecci\195\179n"
				end
			end)
		end
	end
	local function isUpdateValid(item, ...)
		local ultimatesFolder = backpackContainer:FindFirstChild("ultimatesFolder")
		local isUpdateValidOption = ultimatesFolder and (item and ultimatesFolder:FindFirstChild(item.name))
		return tonumber(isUpdateValidOption and isUpdateValidOption.Value) or 0
	end
	local function secondaryIsUpdateValid(...)
		local isUpdateValidOption = isUpdateValidFlag and isUpdateValidFlag:Get()
		return type(isUpdateValidOption) == "table" and isUpdateValidOption.data or nil
	end
	local function handleText(item, ...)
		local textNumber = math.max(0, (item and item.max or 0) - isUpdateValid(item))
		if textNumber <= 0 then
			return { { ["label"] = "M\195\161ximo", ["amount"] = 0 } }
		end
		local textData = {}
		for index = 1, textNumber, 1 do
			textData[#textData + 1] = index
		end
		return textData
	end
	local flag = false
	local function secondaryUpdateText(...)
		local item = secondaryIsUpdateValid()
		if not item then
			return
		end
		local updateTextNumber = isUpdateValid(item)
		if condition then
			condition.Text = handleValueLabelText(updateTextNumber) .. (" / " .. handleValueLabelText(item.max))
		end
		if updateTextCondition then
			flag = true
			updateTextCondition:SetValues(handleText(item), false)
			flag = false
		end
		capturedNumberText = updateTextNumber
	end
	isUpdateValidFlag = secondaryCreateFrame(parent, "Seleccionar Ultimate", createFrameData, function(...)
		if updateTextCondition then
			secondaryUpdateText()
			if not pState.rebirth.ultimateRunning then
				local item = secondaryIsUpdateValid()
				updateText(
					item and "Seleccionado: " .. item.name or "Esperando selecci\195\179n",
					5,
					"Esperando compra"
				)
			end
		end
	end, function(instance, ...)
		runService.Heartbeat:Wait()
		local canvasPositionNumber = math.max(0, parent.AbsoluteCanvasSize.Y - parent.AbsoluteSize.Y)
		local difference = ((instance.AbsolutePosition.Y - parent.AbsolutePosition.Y) + parent.CanvasPosition.Y) - 3
		parent.CanvasPosition = Vector2.new(0, math.clamp(difference, 0, canvasPositionNumber))
	end)
	updateTextCondition = secondaryCreateFrame(
		parent,
		"Cantidad a comprar",
		{ 1, 2, 3 },
		function(secondaryNumberText, ...)
			if flag then
				return
			end
			if not pState.rebirth.ultimateRunning then
				local numberText = type(secondaryNumberText) == "table" and secondaryNumberText.amount
					or tonumber(secondaryNumberText)
				if numberText and numberText > 0 then
					updateText("Cantidad seleccionada: " .. handleValueLabelText(numberText), 5, "Esperando compra")
				end
			end
		end
	)
	condition = createStatusDot(parent, "Nivel seleccionado", "0 / 0", colors.cyan)
	updateTextFlag = handleInstance(parent, "Esperando selecci\195\179n")
	secondaryUpdateText()
	result = createTextButton(parent, "Comprar Ultimate", function(instance, ...)
		if pState.rebirth.ultimateRunning then
			pState.rebirth.ultimateRunning = false
			handleValue("ultimateBuyer")
			instance.Text = "Comprar Ultimate"
			updateText("Compra cancelada", 7, "Esperando selecci\195\179n")
			return
		end
		local item = secondaryIsUpdateValid()
		local numberText = updateTextCondition:Get()
		local number = type(numberText) == "table" and numberText.amount or tonumber(numberText)
		if not item or not number or number <= 0 then
			updateText("Ultimate al m\195\161ximo", 7, "Esperando selecci\195\179n")
			return
		end
		number = math.min(number, math.max(0, item.max - isUpdateValid(item)))
		pState.rebirth.ultimateRunning = true
		instance.Text = "Cancelar compra"
		handleSendGiftRemote("ultimateBuyer", function(...)
			local sum = 0
			local text = nil
			while pState.running and (pState.rebirth.ultimateRunning and sum < number) do
				local rEvents = replicatedStorage:FindFirstChild("rEvents")
				local option = rEvents and rEvents:FindFirstChild("ultimatesRemote")
				if not option then
					text = "Remote de Ultimates no disponible"
					break
				end
				local result = isUpdateValid(item)
				if result >= item.max then
					text = "Ultimate al m\195\161ximo"
					break
				end
				local rebirthSpendSerial = samplesData.rebirthSpendSerial
				updateText("Comprando " .. (item.name .. (" (" .. (sum + 1 .. ("/" .. (number .. ")"))))))
				pcall(option.InvokeServer, option, "upgradeUltimate", item.remote or item.name)
				local secondarySum = clock() + 8
				local flag = false
				while pState.running and (pState.rebirth.ultimateRunning and clock() < secondarySum) do
					if isUpdateValid(item) > result or samplesData.rebirthSpendSerial > rebirthSpendSerial then
						flag = true
						break
					end
					task.wait(0.15)
				end
				if flag then
					sum = sum + 1
				else
					updateText("Waiting for Enough Rebirths")
					task.wait(0.8)
				end
			end
			pState.rebirth.ultimateRunning = false
			if instance and instance.Parent then
				instance.Text = "Comprar Ultimate"
			end
			secondaryUpdateText()
			local alternateUpdateText = text or sum > 0 and "Compra completada: " .. sum or "Sin cambios"
			updateText(alternateUpdateText, 7, "Esperando selecci\195\179n")
		end)
	end, colors.row, Color3.fromRGB(16, 78, 92))
	handleSendGiftRemote("rebirthCounter", function(...)
		while pState.running and frame.Parent do
			local lastEtaUpdate = clock()
			local flag = isUpdateInstancePropertiesValid(backpackContainer, { "Rebirths", "Rebirth" })
			local lastValue = tonumber(flag and flag.Value) or 0
			if pState.rebirth.autoTarget then
				alternateUpdateInstanceProperties(lastValue, lastEtaUpdate)
				if samplesData.lastPositiveAt and lastEtaUpdate - samplesData.lastPositiveAt >= 0.85 then
					secondaryUpdateInstanceProperties()
				end
			else
				if samplesData.lastValue and lastValue < samplesData.lastValue then
					samplesData.rebirthSpendSerial = samplesData.rebirthSpendSerial + 1
				end
				samplesData.lastValue = lastValue
				samplesData.burstGain = 0
				samplesData.burstStartedAt = nil
				samplesData.lastPositiveAt = nil
			end
			valueLabel.Text = "Rebirths: " .. handleValueLabelText(lastValue)
			local visible = pState.rebirth.autoTarget and pState.rebirth.target ~= nil
			local infinite = pState.rebirth.infinite
			clone.Visible = pState.rebirth.target ~= nil and not infinite
			clone.Text = pState.rebirth.target and "Objetivo: " .. handleValueLabelText(pState.rebirth.target) or ""
			input.Visible = visible
			secondaryClone.Visible = visible
			secondaryValueLabel.Visible = visible
			frame.Size = UDim2.new(1, 0, 0, visible and 106 or 62)
			if visible then
				local number = math.max(0, pState.rebirth.target - lastValue)
				local flag, secondaryFlag, secondaryNumber = additionalHandler()
				local text = number <= 0 and "Objetivo alcanzado" or "Calculando..."
				if flag and number > 0 then
					local smoothedEta = number / flag
					if not samplesData.smoothedEta then
						samplesData.smoothedEta = smoothedEta
						samplesData.lastEtaUpdate = lastEtaUpdate
					elseif lastEtaUpdate - samplesData.lastEtaUpdate >= 2 then
						local quotient = math.abs(smoothedEta - samplesData.smoothedEta)
							/ math.max(1, samplesData.smoothedEta)
						local smoothedEtaNumber = quotient > 0.3 and 0.35 or 0.18
						samplesData.smoothedEta = samplesData.smoothedEta * (1 - smoothedEtaNumber)
							+ smoothedEta * smoothedEtaNumber
						samplesData.lastEtaUpdate = lastEtaUpdate
					end
					text = format(samplesData.smoothedEta)
				end
				input.Text = "Faltan: " .. handleValueLabelText(number)
				secondaryClone.Text = "Time: " .. text
				if secondaryFlag and secondaryNumber then
					secondaryValueLabel.Text = "Ciclo: "
						.. (
							string.format("%.2fs", secondaryFlag)
							.. (
								"   \226\128\162   +"
								.. (
									handleValueLabelText(math.floor(secondaryNumber + 0.5))
									.. ("   \226\128\162   Muestras: " .. #samplesData.samples)
								)
							)
						)
				else
					secondaryValueLabel.Text = "Calculando ciclos: " .. (#samplesData.samples .. "/3")
				end
			else
				input.Text = ""
				secondaryClone.Text = ""
				secondaryValueLabel.Text = ""
			end
			local item = secondaryIsUpdateValid()
			if item then
				local result = isUpdateValid(item)
				if result ~= capturedNumberText then
					secondaryUpdateText()
				end
			end
			task.wait(0.25)
		end
	end)
	handler(function(...)
		pState.rebirth.autoTarget = false
		pState.rebirth.infinite = false
		pState.rebirth.sizeOne = false
		pState.rebirth.king = false
		pState.rebirth.lockPosition = false
		pState.rebirth.ultimateRunning = false
		sendMuscleEvent("rebirthFastWeight", false, { "Weight", "Heavy Weight" })
		pState.setAutoEgg(false, "rebirth")
		handleValue("rebirthLoop")
		handleValue("rebirthSizeOne")
		handleValue("rebirthKing")
		handleValue("rebirthLock")
		handleValue("ultimateBuyer")
	end)
end
do
	local parent = pages["Glitch Timer"]
	local number = 1.1
	local data = {
		{
			["label"] = "White Rock",
			["name"] = "white",
			["values"] = {
				[480] = 5,
				[1480] = 10,
				[2980] = 15,
				[4980] = 20,
				[7480] = 25,
				[10480] = 30,
				[13980] = 35,
				[17980] = 40,
				[22480] = 45,
				[27480] = 50,
				[32980] = 55,
				[38980] = 60,
				[45480] = 65,
				[52480] = 70,
				[59980] = 75,
				[67980] = 80,
				[76480] = 85,
				[85480] = 90,
				[94980] = 95,
			},
		},
		{
			["label"] = "Jungle Rock",
			["name"] = "jungle",
			["values"] = {
				[52] = 5,
				[208] = 10,
				[440] = 15,
				[748] = 20,
				[1132] = 25,
				[1592] = 30,
				[2132] = 35,
				[2748] = 40,
				[3440] = 45,
				[4208] = 50,
				[5056] = 55,
				[5980] = 60,
				[6980] = 65,
				[8056] = 70,
				[9208] = 75,
				[10440] = 80,
				[11748] = 85,
				[13132] = 90,
				[14592] = 95,
			},
		},
		{
			["label"] = "Green Rock",
			["name"] = "green",
			["values"] = {
				[80] = 5,
				[280] = 10,
				[580] = 15,
				[980] = 20,
				[1480] = 25,
				[2080] = 30,
				[2780] = 35,
				[3580] = 40,
				[4480] = 45,
				[5480] = 50,
				[6580] = 55,
				[7780] = 60,
				[9080] = 65,
				[10480] = 70,
				[11980] = 75,
				[13580] = 80,
				[15280] = 85,
				[17080] = 90,
				[18980] = 95,
			},
		},
	}
	local createFrameData = {}
	for index = 1, 20, 1 do
		createFrameData[#createFrameData + 1] = { ["label"] = index .. "M", ["value"] = index * 1000000 }
	end
	local function format(formatNumber, ...)
		formatNumber = math.max(0, math.floor(formatNumber + 0.5))
		local number = math.floor(formatNumber / 86400)
		local secondaryFormatNumber = math.floor((formatNumber % 86400) / 3600)
		local alternateFormatNumber = math.floor((formatNumber % 3600) / 60)
		local remainder = formatNumber % 60
		if number > 0 then
			return string.format(
				"%dd %02dh %02dm %02ds",
				number,
				secondaryFormatNumber,
				alternateFormatNumber,
				remainder
			)
		end
		return string.format("%dh %02dm %02ds", secondaryFormatNumber, alternateFormatNumber, remainder)
	end
	local function handler(get, secondaryNumber, ...)
		local key, huge = nil, math.huge
		for secondaryKey in pairs(get.values) do
			local number = math.abs(secondaryKey - secondaryNumber)
			if number < huge then
				key, huge = secondaryKey, number
			end
		end
		return key
	end
	createFrame(parent, "BUGS CALCULATOR")
	local result = secondaryCreateFrame(parent, "Choose Rock", data, function(...) end)
	local secondaryResult = secondaryCreateFrame(
		parent,
		"Pet's Objective",
		createFrameData,
		function(...) end,
		function(...)
			runService.Heartbeat:Wait()
			runService.Heartbeat:Wait()
			local number = math.max(0, parent.AbsoluteCanvasSize.Y - parent.AbsoluteSize.Y);
			(tweenService:Create(
				parent,
				TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ ["CanvasPosition"] = Vector2.new(0, number) }
			)):Play()
		end
	)
	result:SetIndex(3)
	local textResult = createStatusDot(parent, "Time eta", "--", colors.green)
	handleSendGiftRemote("bugCalculator", function(...)
		while pState.running and parent.Parent do
			local flag = isUpdateInstancePropertiesValid(backpackContainer, { "Rebirths", "Rebirth" })
			local secondaryNumber = math.floor(tonumber(flag and flag.Value) or 0)
			local get = result:Get()
			local secondaryGet = secondaryResult:Get()
			local option = type(secondaryGet) == "table" and secondaryGet.value or 1000000
			local condition = type(get) == "table" and get.values[secondaryNumber] or nil
			if condition then
				local secondaryNumber = math.ceil(option / condition)
				local formatNumber = secondaryNumber * number
				textResult.Text = format(formatNumber)
				textResult.TextColor3 = colors.green
			else
				local numberText = type(get) == "table" and handler(get, secondaryNumber) or nil
				textResult.Text = numberText and "Valid Rena: " .. handleValueLabelText(numberText) or "--"
				textResult.TextColor3 = colors.orange
			end
			task.wait(0.5)
		end
	end)
end
do
	local parent = pages.Kills
	createFrame(parent, "KILLS")
	local instance = createStatusDot(parent, "Kills:", "0", colors.cyan)
	local killAutoToggle
	local killEvilToggle
	local killGoodToggle
	local killTargetToggle
	local killProtectToggle
	local killServerHopToggle
	local function handler(secondaryKillAutoToggle, ...)
		for index, item in ipairs({ killAutoToggle, killEvilToggle, killGoodToggle, killTargetToggle }) do
			if item and (item ~= secondaryKillAutoToggle and item:Get()) then
				item:Set(false)
			end
		end
	end
	killAutoToggle = secondaryCreateTextButton(parent, "Kill Everyone", function(condition, ...)
		if condition then
			handler(killAutoToggle)
		end
		return pState.setAutoKill(condition)
	end)
	killEvilToggle = secondaryCreateTextButton(parent, "Evil Karma", function(condition, ...)
		if condition then
			handler(killEvilToggle)
		end
		return pState.setKarmaKill("evil", condition)
	end)
	killGoodToggle = secondaryCreateTextButton(parent, "Good Karma", function(condition, ...)
		if condition then
			handler(killGoodToggle)
		end
		return pState.setKarmaKill("good", condition)
	end)
	killServerHopToggle = secondaryCreateTextButton(parent, "Server Hop (every 2 minutes)", function(flag, ...)
		if flag and (killTargetToggle and killTargetToggle:Get()) then
			return false
		end
		return pState.setServerHop(flag)
	end)
	local textResult, flag = createStatusDot(parent, "Pr\195\179ximo servidor:", "2m 00s", colors.cyan)
	flag.Visible = false
	pState.kill.updateHopStatus = function(numberText, condition, ...)
		if not flag or not flag.Parent then
			return
		end
		if numberText == nil then
			flag.Visible = false
			return
		end
		flag.Visible = true
		local serversVisited = pState.kill.serversVisited
		local text = "  \226\128\162  " .. (serversVisited .. (serversVisited == 1 and " servidor" or " servidores"))
		if condition then
			textResult.Text = condition .. text
		else
			local number = math.max(0, math.floor(tonumber(numberText) or 0))
			textResult.Text = string.format("%dm %02ds", math.floor(number / 60), number % 60) .. text
		end
	end
	killProtectToggle = secondaryCreateTextButton(parent, "Do not kill my friends", function(argument, ...)
		return pState.setProtectFriends(argument)
	end)
	local killSelector = secondaryCreateFrame(parent, "Choose Player", previousHandler(), function(item, ...)
		pState.kill.target = type(item) == "table" and item.name or item
	end, function(instance, ...)
		runService.Heartbeat:Wait()
		runService.Heartbeat:Wait()
		local number = math.max(0, parent.AbsoluteCanvasSize.Y - parent.AbsoluteSize.Y)
		local difference = ((instance.AbsolutePosition.Y - parent.AbsolutePosition.Y) + parent.CanvasPosition.Y) - 3
		(tweenService:Create(
			parent,
			TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{ ["CanvasPosition"] = Vector2.new(0, math.clamp(difference, 0, number)) }
		)):Play()
	end)
	killTargetToggle = secondaryCreateTextButton(parent, "Kill Selected Player", function(condition, ...)
		if condition then
			handler(killTargetToggle)
			if killServerHopToggle and killServerHopToggle:Get() then
				killServerHopToggle:Set(false)
			end
		end
		return pState.setTargetKill(condition)
	end)
	pState.killSelector = killSelector
	pState.killAutoToggle = killAutoToggle
	pState.killEvilToggle = killEvilToggle
	pState.killGoodToggle = killGoodToggle
	pState.killTargetToggle = killTargetToggle
	pState.killProtectToggle = killProtectToggle
	pState.killServerHopToggle = killServerHopToggle
	handleSendGiftRemote("killCounter", function(...)
		while pState.running and instance.Parent do
			local flag = isUpdateInstancePropertiesValid(backpackContainer, { "Kills" })
			instance.Text = handleValueLabelText(flag and flag.Value or 0)
			task.wait(0.5)
		end
	end)
end
if pState.resume and pState.resume.script == "fg100.lua" then
	updateScrollingFrame(
		type(pState.resume.tab) == "string" and (pages[pState.resume.tab] and pState.resume.tab) or "Info"
	)
	if pState.resume.protectFriends and pState.killProtectToggle then
		pState.killProtectToggle:Set(true)
	end
	if pState.resume.autoKill and pState.killAutoToggle then
		pState.killAutoToggle:Set(true)
	end
	if pState.resume.karmaMode == "evil" and pState.killEvilToggle then
		pState.killEvilToggle:Set(true)
	elseif pState.resume.karmaMode == "good" and pState.killGoodToggle then
		pState.killGoodToggle:Set(true)
	end
	if pState.resume.serverHop and pState.killServerHopToggle then
		pState.killServerHopToggle:Set(true)
	end
else
	updateScrollingFrame("Info")
end
do
	local secondaryParent = pages["Fast Trade"]
	secondaryParent:SetAttribute("TightCanvas", true)
	createFrame(secondaryParent, "FAST TRADE")
	local function createFrameFlag(instance, ...)
		runService.Heartbeat:Wait()
		local flagNumber = math.max(0, secondaryParent.AbsoluteCanvasSize.Y - secondaryParent.AbsoluteSize.Y)
		local difference = (
			(instance.AbsolutePosition.Y - secondaryParent.AbsolutePosition.Y) + secondaryParent.CanvasPosition.Y
		) - 3
		(tweenService:Create(
			secondaryParent,
			TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
			{ ["CanvasPosition"] = Vector2.new(0, math.clamp(difference, 0, flagNumber)) }
		)):Play()
	end
	local function secondaryHandler(...)
		local nameData = {}
		local petsFolder = backpackContainer:FindFirstChild("petsFolder")
		if petsFolder then
			for index, item in ipairs(petsFolder:GetChildren()) do
				if item:IsA("Folder") then
					for index, item in ipairs(item:GetChildren()) do
						nameData[item.Name] = (nameData[item.Name] or 0) + 1
					end
				end
			end
		end
		local data = {}
		for key in pairs(nameData) do
			data[#data + 1] = key
		end
		table.sort(data, function(argument, secondaryArgument, ...)
			return argument:lower() < secondaryArgument:lower()
		end)
		local secondaryData = {}
		for index, item in ipairs(data) do
			secondaryData[#secondaryData + 1] = {
				["label"] = item .. ("  x" .. handleValueLabelText(nameData[item])),
				["name"] = item,
				["count"] = nameData[item],
			}
		end
		return secondaryData
	end
	local function alternateHandler(activePet, secondaryArgument, ...)
		local data = {}
		local petsFolder = backpackContainer:FindFirstChild("petsFolder")
		if not petsFolder or type(activePet) ~= "string" then
			return data
		end
		for index, item in ipairs(petsFolder:GetChildren()) do
			if item:IsA("Folder") then
				for index, item in ipairs(item:GetChildren()) do
					if item.Name == activePet then
						data[#data + 1] = item
						if #data >= secondaryArgument then
							return data
						end
					end
				end
			end
		end
		return data
	end
	local function additionalHandler(activePet, ...)
		return #alternateHandler(activePet, math.huge)
	end
	local function isValid(alternateParent, ...)
		local secondaryParent = alternateParent
		while secondaryParent and secondaryParent ~= parent do
			if secondaryParent:IsA("GuiObject") and not secondaryParent.Visible then
				return false
			end
			secondaryParent = secondaryParent.Parent
		end
		return secondaryParent == parent
	end
	local function fallbackHandler(...)
		local item, number = nil, 0
		for index, secondaryItem in ipairs(parent:GetDescendants()) do
			if
				secondaryItem:IsA("GuiObject")
				and (not secondaryItem:IsDescendantOf(screenGui) and isValid(secondaryItem))
			then
				local lower = secondaryItem.Name:lower()
				if
					(lower:find("trade", 1, true) or lower:find("trading", 1, true))
					and (secondaryItem.AbsoluteSize.X >= 160 and secondaryItem.AbsoluteSize.Y >= 110)
				then
					local product = secondaryItem.AbsoluteSize.X * secondaryItem.AbsoluteSize.Y
					if product > number then
						item, number = secondaryItem, product
					end
				end
			end
		end
		return item
	end
	local function secondaryIsValid(isValidFlag, ...)
		local lower = (tostring(isValidFlag or "")):lower()
		return lower:find("accepted", 1, true)
			or lower:find("ready", 1, true)
			or lower:find("aceptado", 1, true)
			or lower:find("acept\195\179", 1, true)
			or lower:find("listo", 1, true)
			or lower:find("confirmado", 1, true)
	end
	local function nestedHandler(parent, instance, ...)
		local searchableText = instance.Name:lower()
		local secondarySearchableText = instance.DisplayName:lower()
		for index, item in ipairs(parent:GetDescendants()) do
			if item:IsA("TextLabel") or item:IsA("TextButton") then
				local lower = (tostring(item.Text or "")):lower()
				if lower:find(searchableText, 1, true) or lower:find(secondarySearchableText, 1, true) then
					return true
				end
			end
		end
		return false
	end
	local function innerHandler(parentFlag, instance, ...)
		local flag = false
		for index, item in ipairs(parentFlag:GetDescendants()) do
			if
				(item:IsA("TextLabel") or item:IsA("TextButton")) and (isValid(item) and secondaryIsValid(item.Text))
			then
				local parent = item.Parent
				for index = 1, 4, 1 do
					if not parent or parent == parentFlag.Parent then
						break
					end
					if nestedHandler(parent, instance) then
						return true
					end
					parent = parent.Parent
				end
				local lower = (item:GetFullName()):lower()
				if
					lower:find("other", 1, true)
					or lower:find("opponent", 1, true)
					or lower:find("player2", 1, true)
					or lower:find("recipient", 1, true)
				then
					return true
				end
				if item:IsA("TextLabel") then
					flag = true
				end
			end
		end
		return flag
	end
	local function alternateIsValid(...)
		local rEvents = replicatedStorage:FindFirstChild("rEvents")
		return rEvents and (rEvents:FindFirstChild("tradingEvent") or rEvents:FindFirstChild("tradeRemote"))
	end
	local function secondaryPcall(pcallFlag, secondaryArgument, item, ...)
		if not pcallFlag then
			return false
		end
		if pcallFlag:IsA("RemoteFunction") then
			return pcall(pcallFlag.InvokeServer, pcallFlag, secondaryArgument, item)
		end
		return pcall(pcallFlag.FireServer, pcallFlag, secondaryArgument, item)
	end
	local updateInstancePropertiesFlag
	local clampedValue = 6
	local updateInstancePropertiesNumber = 0
	local function updateInstanceProperties(displayValue, delivered, total, ...)
		if delivered ~= nil then
			pState.trade.delivered = delivered
		end
		if total ~= nil then
			pState.trade.total = total
		end
		if updateInstancePropertiesFlag and (updateInstancePropertiesFlag.Parent and displayValue) then
			updateInstancePropertiesNumber = updateInstancePropertiesNumber + 1
			local capturedSum = updateInstancePropertiesNumber
			updateInstancePropertiesFlag.Text = tostring(displayValue)
			if not pState.trade.busy then
				task.delay(1.4, function(...)
					if
						updateInstancePropertiesFlag
						and (
							updateInstancePropertiesFlag.Parent
							and (not pState.trade.busy and updateInstancePropertiesNumber == capturedSum)
						)
					then
						updateInstancePropertiesFlag.Text = "Iniciar Fast Trade"
					end
				end)
			end
		end
	end
	local function secondaryUpdateInstanceProperties(updateInstancePropertiesCondition, ...)
		pState.trade.requestGeneration = pState.trade.requestGeneration + 1
		pState.trade.busy = false
		pState.trade.activePlayer = nil
		pState.trade.activePet = nil
		handleValue("fastTrade")
		if updateInstancePropertiesFlag and updateInstancePropertiesFlag.Parent then
			updateInstancePropertiesFlag.Text = "Iniciar Fast Trade"
		end
		if updateInstancePropertiesCondition then
			updateInstanceProperties(updateInstancePropertiesCondition)
		end
	end
	local flag = false
	local result = secondaryCreateFrame(secondaryParent, "Choose Player", previousHandler(), function(item, ...)
		local option = type(item) == "table" and item.name or item
		if not flag and (pState.trade.busy and (pState.trade.activePlayer and option ~= pState.trade.activePlayer)) then
			secondaryUpdateInstanceProperties("Cancelling Change of user..")
		end
	end, createFrameFlag)
	local secondaryResult = secondaryCreateFrame(
		secondaryParent,
		"Choose Pet",
		secondaryHandler(),
		function(item, ...)
			local option = type(item) == "table" and item.name or item
			if not flag and (pState.trade.busy and (pState.trade.activePet and option ~= pState.trade.activePet)) then
				secondaryUpdateInstanceProperties("Cancelado: cambi\195\179 la pet")
			end
		end,
		createFrameFlag
	)
	local alternateResult = secondaryCreateFrame(
		secondaryParent,
		"Cantidad",
		{ 6, 5, 4, 3, 2, 1 },
		function(numberText, ...)
			clampedValue = math.clamp(math.floor(tonumber(numberText) or 6), 1, 6)
		end,
		createFrameFlag
	)
	local function additionalIsValid(item, ...)
		return type(item) == "table" and item.name or item
	end
	local function outerHandler(pcallFlag, item, requestGeneration, ...)
		local sum = 0
		while
			pState.running
			and (pState.trade.busy and (pState.trade.requestGeneration == requestGeneration and item.Parent))
		do
			local condition = fallbackHandler()
			if condition then
				return condition
			end
			if time() >= sum then
				secondaryPcall(pcallFlag, "sendTradeRequest", item)
				sum = time() + 1.25
				updateInstanceProperties("Enviando solicitud hasta que acepte...")
			end
			task.wait(0.1)
		end
		return nil
	end
	updateInstancePropertiesFlag = createTextButton(secondaryParent, "Iniciar Fast Trade", function(textArgument, ...)
		if pState.trade.busy then
			secondaryUpdateInstanceProperties("Cancelado por el usuario")
			return
		end
		if fallbackHandler() then
			updateInstanceProperties("Cerr\195\161 el trade actual antes de iniciar")
			return
		end
		local activePlayer = additionalIsValid(result:Get())
		local activePet = additionalIsValid(secondaryResult:Get())
		local option = activePlayer and players:FindFirstChild(activePlayer)
		local flag = alternateIsValid()
		local total = math.clamp(math.floor(tonumber(alternateResult:Get()) or clampedValue), 1, 6)
		if not option or option == backpackContainer then
			updateInstanceProperties("Choosing a Player v\195\161lido")
			return
		end
		if not activePet then
			updateInstanceProperties("Choose a Pet")
			return
		end
		if not flag then
			updateInstanceProperties("Trade Remote not found")
			return
		end
		if additionalHandler(activePet) < total then
			updateInstanceProperties("you dont have that amount of pets")
			return
		end
		pState.trade.requestGeneration = pState.trade.requestGeneration + 1
		local requestGeneration = pState.trade.requestGeneration
		pState.trade.busy = true
		pState.trade.activePlayer = activePlayer
		pState.trade.activePet = activePet
		pState.trade.delivered = 0
		pState.trade.total = total
		textArgument.Text = "Cancel Fast Trade"
		updateInstanceProperties("Preparing first shit...", 0, total)
		handleSendGiftRemote("fastTrade", function(...)
			while
				pState.running
				and (
					pState.trade.busy
					and (pState.trade.requestGeneration == requestGeneration and pState.trade.delivered < total)
				)
			do
				if not option.Parent then
					secondaryUpdateInstanceProperties("The player leaved the server.")
					return
				end
				local difference = total - pState.trade.delivered
				local data = alternateHandler(activePet, math.min(6, difference))
				if #data == 0 then
					secondaryUpdateInstanceProperties("no pets remaining..")
					return
				end
				local number = #data
				local secondaryNumber = additionalHandler(activePet)
				local instance = outerHandler(flag, option, requestGeneration)
				if not instance then
					return
				end
				updateInstanceProperties("Choosing amount: " .. (number .. " of pets..."))
				for index, item in ipairs(data) do
					if not pState.trade.busy or pState.trade.requestGeneration ~= requestGeneration then
						return
					end
					if item.Parent then
						secondaryPcall(flag, "offerItem", item)
						task.wait(0.08)
					end
				end
				updateInstanceProperties("Waiting for the other user to accept")
				local secondaryFlag = false
				while
					pState.running
					and (
						pState.trade.busy
						and (
							pState.trade.requestGeneration == requestGeneration and (
								option.Parent and not secondaryFlag
							)
						)
					)
				do
					instance = fallbackHandler()
					if not instance then
						break
					end
					secondaryFlag = innerHandler(instance, option)
					task.wait(0.12)
				end
				if not pState.trade.busy or pState.trade.requestGeneration ~= requestGeneration then
					return
				end
				if not option.Parent then
					secondaryUpdateInstanceProperties("The player leaved the server")
					return
				end
				if not secondaryFlag then
					updateInstanceProperties("Trade closed, retrying...")
					task.wait(0.8)
				else
					updateInstanceProperties("Accepting the trade")
					secondaryPcall(flag, "acceptTrade")
					local sum = time() + 30
					local clampedValue = 0
					while
						pState.running
						and (
							pState.trade.busy and (pState.trade.requestGeneration == requestGeneration and time() < sum)
						)
					do
						clampedValue = math.clamp(secondaryNumber - additionalHandler(activePet), 0, number)
						if clampedValue > 0 then
							break
						end
						task.wait(0.2)
					end
					if clampedValue > 0 then
						pState.trade.delivered = math.min(total, pState.trade.delivered + clampedValue)
						updateInstanceProperties(
							pState.trade.delivered >= total and "Completed"
								or "Completed, preparing the next one",
							pState.trade.delivered,
							total
						)
						task.wait(0.8)
					else
						updateInstanceProperties("Failed, retrying...")
						while
							pState.running
							and (
								pState.trade.busy
								and (pState.trade.requestGeneration == requestGeneration and fallbackHandler())
							)
						do
							task.wait(0.25)
						end
						task.wait(0.5)
					end
				end
			end
			if pState.trade.requestGeneration == requestGeneration and pState.trade.delivered >= total then
				pState.trade.busy = false
				pState.trade.activePlayer = nil
				pState.trade.activePet = nil
				textArgument.Text = "Start Fast Trade"
				updateInstanceProperties(
					"Completed: " .. (handleValueLabelText(total) .. " delivered pets"),
					total,
					total
				)
			end
		end)
	end, colors.row, Color3.fromRGB(16, 78, 92))
	local function onPlayerAdded(...)
		flag = true
		result:SetValues(previousHandler(), true)
		flag = false
	end
	local secondaryFlag = false
	local function currentHandler(...)
		if secondaryFlag then
			return
		end
		secondaryFlag = true
		task.delay(0.15, function(...)
			secondaryFlag = false
			if pState.running then
				flag = true
				secondaryResult:SetValues(secondaryHandler(), true)
				flag = false
			end
		end)
	end
	handleFrame(players.PlayerAdded:Connect(onPlayerAdded))
	handleFrame(players.PlayerRemoving:Connect(onPlayerAdded))
	handleFrame(backpackContainer.DescendantAdded:Connect(function(argument, ...)
		local petsFolder = backpackContainer:FindFirstChild("petsFolder")
		if petsFolder and argument:IsDescendantOf(petsFolder) then
			currentHandler()
		end
	end))
	handleFrame(backpackContainer.DescendantRemoving:Connect(function(argument, ...)
		local petsFolder = backpackContainer:FindFirstChild("petsFolder")
		if petsFolder and argument:IsDescendantOf(petsFolder) then
			currentHandler()
		end
	end))
	handler(function(...)
		secondaryUpdateInstanceProperties()
	end)
end
local gifts = pages.Gifts
createFrame(gifts, "Gifts")
local textResult = createStatusDot(gifts, "Eggs", "0", colors.cyan)
local sendGiftRemoteResult = createStatusDot(gifts, "Tropical Shakes", "0", colors.cyan)
createFrame(gifts, "Send Gifts")
local secondarySendGiftRemoteResult = secondaryCreateFrame(gifts, "Player", previousHandler(), function(...) end)
local count = 1
local clampedValue = 1
local condition = nil
local textCondition = nil
alternateCreateFrame(gifts, "Amount of  Eggs", "1", function(numberText, ...)
	count = math.clamp(math.floor(tonumber(numberText) or 1), 1, 9999)
	if condition then
		condition.Text = "\240\159\165\154 Send "
			.. (count .. (" Protein Egg" .. ((count == 1 and "" or "s") .. " \240\159\165\154")))
	end
end)
local function isValid(isValidFlag, ...)
	return type(isValidFlag) == "table" and isValidFlag or { isValidFlag }
end
local function secondaryHandleSendGiftRemote(consumablesFolder, isValidFlag, ...)
	if not consumablesFolder then
		return nil
	end
	for index, item in ipairs(isValid(isValidFlag)) do
		local firstChild = consumablesFolder:FindFirstChild(item)
		if firstChild then
			return firstChild
		end
	end
	return nil
end
local function alternateHandleSendGiftRemote(isValidFlag, ...)
	local consumablesFolder = backpackContainer:FindFirstChild("consumablesFolder")
	if not consumablesFolder then
		return 0
	end
	local data = {}
	for index, item in ipairs(isValid(isValidFlag)) do
		data[item] = true
	end
	local sum = 0
	for index, item in ipairs(consumablesFolder:GetChildren()) do
		if data[item.Name] then
			sum = sum + 1
		end
	end
	return sum
end
local function sendGiftRemote(
	isSendGiftRemoteValidFlag,
	text,
	count,
	instance,
	secondarySendGiftRemoteText,
	numberText,
	...
)
	local item = secondarySendGiftRemoteResult:Get()
	local sendGiftRemoteOption = type(item) == "table" and item.name or item
	local sendGiftRemoteFlag = sendGiftRemoteOption and players:FindFirstChild(sendGiftRemoteOption)
	local consumablesFolder = backpackContainer:FindFirstChild("consumablesFolder")
	local rEvents = replicatedStorage:FindFirstChild("rEvents")
	local remoteFunction = rEvents and rEvents:FindFirstChild("giftRemote")
	local sendGiftRemoteText = secondarySendGiftRemoteText
		.. (
			" Send "
			.. (count .. (" " .. (text .. ((count == 1 and "" or "s") .. (" " .. secondarySendGiftRemoteText)))))
		)
	if not sendGiftRemoteFlag or not consumablesFolder or not remoteFunction then
		instance.Text = "Choose a player"
		task.delay(0.9, function(...)
			if instance and instance.Parent then
				instance.Text = sendGiftRemoteText
			end
		end)
		return
	end
	handleSendGiftRemote("giftSender", function(...)
		local sendGiftRemoteNumber = 0
		local number = 0
		local secondarySendGiftRemoteNumber = math.max(tonumber(numberText) or 0.1, 0.08)
		for index = 1, count, 1 do
			if not pState.running then
				break
			end
			local flag = secondaryHandleSendGiftRemote(consumablesFolder, isSendGiftRemoteValidFlag)
			if not flag then
				break
			end
			local sendGiftRemoteResult = isSendGiftRemoteCachedPingValid()
			while pState.running and sendGiftRemoteResult >= 650 do
				task.wait(0.25)
				sendGiftRemoteResult = isSendGiftRemoteCachedPingValid()
			end
			if not pState.running then
				break
			end
			local success = pcall(function(...)
				remoteFunction:InvokeServer("giftRequest", sendGiftRemoteFlag, flag)
			end)
			if success then
				sendGiftRemoteNumber = sendGiftRemoteNumber + 1
			end
			if time() - number >= 0.25 then
				instance.Text = secondarySendGiftRemoteText
					.. (
						" Enviando "
						.. (sendGiftRemoteNumber .. ("/" .. (count .. (" " .. secondarySendGiftRemoteText))))
					)
				number = time()
			end
			local alternateSendGiftRemoteNumber = secondarySendGiftRemoteNumber
			if sendGiftRemoteResult >= 400 then
				alternateSendGiftRemoteNumber = math.max(alternateSendGiftRemoteNumber, 0.4)
			elseif sendGiftRemoteResult >= 250 then
				alternateSendGiftRemoteNumber = math.max(alternateSendGiftRemoteNumber, 0.28)
			elseif sendGiftRemoteResult >= 150 then
				alternateSendGiftRemoteNumber = math.max(alternateSendGiftRemoteNumber, 0.2)
			end
			task.wait(alternateSendGiftRemoteNumber)
		end
		if instance and instance.Parent then
			instance.Text = sendGiftRemoteText
		end
		textResult.Text = handleValueLabelText(alternateHandleSendGiftRemote(public.AutoEgg.Names))
		sendGiftRemoteResult.Text = handleValueLabelText(alternateHandleSendGiftRemote("Tropical Shake"))
	end)
end
condition = createTextButton(
	gifts,
	"\240\159\165\154 Send 1 Protein Egg \240\159\165\154",
	function(sendGiftRemoteFlag, ...)
		sendGiftRemote(public.AutoEgg.Names, "Protein Egg", count, sendGiftRemoteFlag, "\240\159\165\154", 0.16)
	end
)
alternateCreateFrame(gifts, "Cantidad de Shakes", "1", function(numberText, ...)
	clampedValue = math.clamp(math.floor(tonumber(numberText) or 1), 1, 9999)
	if textCondition then
		textCondition.Text = "\240\159\165\164 Send "
			.. (clampedValue .. (" Tropical Shake" .. ((clampedValue == 1 and "" or "s") .. " \240\159\165\164")))
	end
end)
textCondition = createTextButton(
	gifts,
	"\240\159\165\164 Send 1 Tropical Shake \240\159\165\164",
	function(sendGiftRemoteFlag, ...)
		sendGiftRemote("Tropical Shake", "Tropical Shake", clampedValue, sendGiftRemoteFlag, "\240\159\165\164", 0.16)
	end
)
handleSendGiftRemote("giftUpdater", function(...)
	while pState.running do
		if not valueData.giftSender then
			textResult.Text = handleValueLabelText(alternateHandleSendGiftRemote(public.AutoEgg.Names))
			sendGiftRemoteResult.Text = handleValueLabelText(alternateHandleSendGiftRemote("Tropical Shake"))
		end
		task.wait(2)
	end
end)
local function currentHandler(...)
	local data = {}
	local secondaryData = {}
	local cPetShopFolder = replicatedStorage:FindFirstChild("cPetShopFolder")
	if cPetShopFolder then
		for index, item in ipairs(public.UniquePets) do
			if cPetShopFolder:FindFirstChild(item) then
				data[#data + 1] = item
			end
		end
		for index, item in ipairs(public.UniqueAuras) do
			if cPetShopFolder:FindFirstChild(item) then
				secondaryData[#secondaryData + 1] = item
			end
		end
	else
		for index, item in ipairs(public.UniquePets) do
			data[#data + 1] = item
		end
		for index, item in ipairs(public.UniqueAuras) do
			secondaryData[#secondaryData + 1] = item
		end
	end
	return data, secondaryData
end
local createFrameFlag, createFrameData = currentHandler()
local nestedParent = pages["Pet Shop"]
createFrame(nestedParent, "\240\159\144\190 Pets \240\159\144\190")
local result = secondaryCreateFrame(nestedParent, "Choose Pet", createFrameFlag, function(...) end)
local function sendCPetShopRemote(flag, ...)
	local cPetShopFolder = replicatedStorage:FindFirstChild("cPetShopFolder")
	local cPetShopRemote = replicatedStorage:FindFirstChild("cPetShopRemote")
	local option = cPetShopFolder and (flag and cPetShopFolder:FindFirstChild(flag))
	if not option or not cPetShopRemote then
		return false
	end
	local success = pcall(function(...)
		cPetShopRemote:InvokeServer(option)
	end)
	return success
end
createTextButton(nestedParent, "\240\159\144\190 Buy Pets \240\159\144\190", function(...)
	sendCPetShopRemote(result:Get())
end)
secondaryCreateTextButton(nestedParent, "\240\159\148\129 Auto Buy Pet \240\159\148\129", function(autoPet, ...)
	pState.autoPet = autoPet
	if not autoPet then
		handleValue("autoPet")
		return
	end
	handleSendGiftRemote("autoPet", function(...)
		while pState.running and pState.autoPet do
			sendCPetShopRemote(result:Get())
			task.wait(0.18)
		end
	end)
end)
createFrame(nestedParent, "\240\159\140\140 Auras \240\159\140\140")
local secondaryResult = secondaryCreateFrame(nestedParent, "Choose Aura", createFrameData, function(...) end)
createTextButton(nestedParent, "\240\159\140\140 Buy Aura \240\159\140\140", function(...)
	sendCPetShopRemote(secondaryResult:Get())
end)
secondaryCreateTextButton(nestedParent, "\240\159\148\129 Auto Buy Aura \240\159\148\129", function(autoAura, ...)
	pState.autoAura = autoAura
	if not autoAura then
		handleValue("autoAura")
		return
	end
	handleSendGiftRemote("autoAura", function(...)
		while pState.running and pState.autoAura do
			sendCPetShopRemote(secondaryResult:Get())
			task.wait(0.18)
		end
	end)
end)
local function secondaryTaskCallback(...)
	local additionalResult, alternateResult = currentHandler()
	result:SetValues(additionalResult, true)
	secondaryResult:SetValues(alternateResult, true)
end
local cPetShopFolder = replicatedStorage:FindFirstChild("cPetShopFolder")
if cPetShopFolder then
	handleFrame(cPetShopFolder.ChildAdded:Connect(function(...)
		task.defer(secondaryTaskCallback)
	end))
	handleFrame(cPetShopFolder.ChildRemoved:Connect(function(...)
		task.defer(secondaryTaskCallback)
	end))
else
	handleFrame(replicatedStorage.ChildAdded:Connect(function(instance, ...)
		if instance.Name == "cPetShopFolder" then
			task.defer(secondaryTaskCallback)
		end
	end))
end
local innerParent = pages.Stats
createFrame(innerParent, "\226\143\177\239\184\143 Sesi\195\179n \226\143\177\239\184\143")
local secondaryTextResult = createStatusDot(innerParent, "Executed since:", "0d 0h 0m 0s", colors.cyan)
createFrame(innerParent, "\240\159\147\138 STATS \240\159\147\138")
local fallbackData = {
	{ ["label"] = "\240\159\146\170 Strenght \240\159\146\170", ["names"] = { "Strength", "Fuerza" } },
	{
		["label"] = "\240\159\155\161\239\184\143 Durability \240\159\155\161\239\184\143",
		["names"] = { "Durability", "Durabilidad" },
	},
	{ ["label"] = "\240\159\148\132 Rebirths \240\159\148\132", ["names"] = { "Rebirths", "Rebirths" } },
	{ ["label"] = "\226\154\148\239\184\143 Kills \226\154\148\239\184\143", ["names"] = { "Kills" } },
	{ ["label"] = "\240\159\152\136 Evil Karma \240\159\152\136", ["names"] = { "evilKarma", "Evil Karma" } },
	{ ["label"] = "\240\159\152\135 Good Karma \240\159\152\135", ["names"] = { "goodKarma", "Good Karma" } },
}
local nestedData = {}
for index, item in ipairs(fallbackData) do
	item.valueLabel = createStatusDot(innerParent, item.label, "0 (+0)", colors.white)
	local flag = isUpdateInstancePropertiesValid(backpackContainer, item.names)
	nestedData[item] = flag and tonumber(flag.Value) or 0
end
local timeResult = os.time()
handleSendGiftRemote("statsUpdater", function(...)
	while pState.running do
		local difference = os.time() - timeResult
		secondaryTextResult.Text = math.floor(difference / 86400)
			.. (
				"d "
				.. (
					math.floor((difference % 86400) / 3600)
					.. ("h " .. (math.floor((difference % 3600) / 60) .. ("m " .. (difference % 60 .. "s"))))
				)
			)
		for index, item in ipairs(fallbackData) do
			local flag = isUpdateInstancePropertiesValid(backpackContainer, item.names)
			local valueLabelTextNumber = flag and tonumber(flag.Value) or 0
			local difference = valueLabelTextNumber - (nestedData[item] or 0)
			item.valueLabel.Text = handleValueLabelText(valueLabelTextNumber)
				.. (" (" .. (secondaryHandleValueLabelText(difference) .. ")"))
		end
		task.wait(0.5)
	end
end)
local shutdown = nil
local misc = pages.Misc
createFrame(misc, "\240\159\150\165\239\184\143 idk sum shit \240\159\150\165\239\184\143")
secondaryCreateTextButton(misc, "Anti Lag 100%", function(argument, ...)
	updateDescendantAddedConnection(argument)
end)
local instance = handleInstance(misc, "Disabled")
handleInstanceProperties = function(text, ...)
	if instance and instance.Parent then
		instance.Text = text
	end
end
createFrame(misc, "\240\159\154\128 FLY \240\159\154\128")
secondaryCreateTextButton(misc, " Fly ", function(argument, ...)
	nestedUpdateInstanceProperties(argument)
end)
updatePositionFromInput(misc, "Fly Speed", 1, 30, pState.flyLevel, function(flyLevel, ...)
	pState.flyLevel = flyLevel
end)
createFrame(misc, "\226\154\153\239\184\143 MISC \226\154\153\239\184\143")
secondaryCreateTextButton(misc, "\240\159\140\128 Spin \240\159\140\128", function(argument, ...)
	secondaryUpdateSpin(argument)
end)
secondaryCreateTextButton(misc, "\226\154\161 Fast Speed \226\154\161", function(fastSpeedFlag, ...)
	updateFastSpeed(fastSpeedFlag)
end)
secondaryCreateTextButton(misc, "\240\159\140\138 Walk on Water \240\159\140\138", function(argument, ...)
	handleSendGiftRemote("walkWater", function(...)
		createPart(argument)
	end)
end)
secondaryCreateTextButton(misc, "\240\159\145\187 No Clip \240\159\145\187", function(argument, ...)
	updateSteppedConnection(argument)
end)
secondaryCreateTextButton(
	misc,
	"\240\159\155\161\239\184\143 Anti Knockback \240\159\155\161\239\184\143",
	function(argument, ...)
		pState.setAntiKnockback(argument)
	end
)
secondaryCreateTextButton(misc, "\240\159\142\161 Auto Spin Fortune Wheel \240\159\142\161", function(argument, ...)
	sendOpenFortuneWheelRemote(argument)
end)
secondaryCreateTextButton(misc, "\240\159\142\129 Auto Claim Chests \240\159\142\129", function(argument, ...)
	updateAutoClaimChests(argument)
end)
secondaryCreateTextButton(misc, "\240\159\154\171 Remove AD Portal \240\159\154\171", function(argument, ...)
	updateRemovePortals(argument)
end)
createFrame(misc, "\240\159\147\185 SPY \240\159\147\185")
local alternateResult = secondaryCreateFrame(misc, "Choose Player", previousHandler(), function(item, ...)
	pState.spyTarget = type(item) == "table" and item.name or item
end)
secondaryCreateTextButton(misc, "Spy", function(flag, ...)
	if flag and not pState.spyTarget then
		return false
	end
	updateSpy(flag)
end)
createTextButton(misc, "\226\157\140 Close Script \226\157\140", function(...)
	if shutdown then
		shutdown(false)
	end
end, colors.row, Color3.fromRGB(72, 34, 52))
local function alternateTaskCallback(...)
	local result = previousHandler()
	local target = pState.kill.target
	secondarySendGiftRemoteResult:SetValues(result, true)
	alternateResult:SetValues(result, true)
	if pState.killSelector then
		pState.killSelector:SetValues(result, true)
	end
	if pState.spy and (pState.spyTarget and not players:FindFirstChild(pState.spyTarget)) then
		updateSpy(false)
	end
	if pState.kill.targetMode and (target and not players:FindFirstChild(target)) then
		pState.setTargetKill(false)
		if pState.killTargetToggle then
			pState.killTargetToggle:Set(false, true)
		end
	end
end
handleFrame(players.PlayerAdded:Connect(function(argument, ...)
	pState.clearKillFriend(argument)
	alternateTaskCallback()
end))
handleFrame(players.PlayerRemoving:Connect(function(argument, ...)
	pState.clearKillFriend(argument)
	task.defer(alternateTaskCallback)
end))
frame = Instance.new("Frame")
frame.Name = "FlyControls"
frame.Size = UDim2.fromOffset(106, 48)
frame.Position = UDim2.new(1, -120, 1, -70)
frame.BackgroundTransparency = 1
frame.Visible = false
frame.ZIndex = 100
frame.Parent = screenGui
local function alternateCreateTextButton(createTextButton, secondaryArgument, ...)
	local parent = Instance.new("TextButton")
	parent.Size = UDim2.fromOffset(48, 48)
	parent.Position = UDim2.fromOffset(secondaryArgument, 0)
	parent.BackgroundColor3 = colors.tabOn
	parent.BackgroundTransparency = 0.18
	parent.BorderSizePixel = 0
	parent.Text = createTextButton
	parent.TextColor3 = colors.white
	parent.Font = Enum.Font.FredokaOne
	parent.TextSize = 20
	parent.AutoButtonColor = false
	parent.ZIndex = 101
	parent.Parent = frame;
	(Instance.new("UICorner", parent)).CornerRadius = UDim.new(0, 10)
	local uiStroke = Instance.new("UIStroke", parent)
	uiStroke.Color = colors.cyan
	uiStroke.Thickness = 1
	uiStroke.Transparency = 0.2
	return parent
end
local guiObject = alternateCreateTextButton("\226\150\178", 0)
local secondaryGuiObject = alternateCreateTextButton("\226\150\188", 58)
handleFrame(guiObject.InputBegan:Connect(function(input, ...)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		flag = true
	end
end))
handleFrame(guiObject.InputEnded:Connect(function(input, ...)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		flag = false
	end
end))
handleFrame(secondaryGuiObject.InputBegan:Connect(function(input, ...)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		secondaryFlag = true
	end
end))
handleFrame(secondaryGuiObject.InputEnded:Connect(function(input, ...)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		secondaryFlag = false
	end
end))
handleFrame(runService.Heartbeat:Connect(function(...)
	if not pState.running then
		return
	end
	local filterDescendantsInstancesFlag = getValueCharacter()
	local instanceFlag = isUseToolValid()
	local parent = isSendHitEventValid()
	if pState.fastSpeed and instanceFlag then
		instanceFlag.WalkSpeed = 1000
	end
	if pState.fly and (instanceFlag and (parent and workspace.CurrentCamera)) then
		if not bodyGyro or bodyGyro.Parent ~= parent then
			updatePlatformStand()
			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.Name = "RawExploitFlyGyro"
			bodyGyro.P = 12000
			bodyGyro.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
			bodyGyro.Parent = parent
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Name = "RawExploitFlyVelocity"
			bodyVelocity.P = 15000
			bodyVelocity.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
			bodyVelocity.Parent = parent
		end
		local currentCamera = workspace.CurrentCamera
		local sum = 160 + (math.clamp(pState.flyLevel, 1, 30) - 1) * 24
		local number = sum + (pState.fastSpeed and 1000 or 0)
		local unit = Vector3.zero
		if userInputService:IsKeyDown(Enum.KeyCode.W) then
			unit = unit + currentCamera.CFrame.LookVector
		end
		if userInputService:IsKeyDown(Enum.KeyCode.S) then
			unit = unit - currentCamera.CFrame.LookVector
		end
		if userInputService:IsKeyDown(Enum.KeyCode.D) then
			unit = unit + currentCamera.CFrame.RightVector
		end
		if userInputService:IsKeyDown(Enum.KeyCode.A) then
			unit = unit - currentCamera.CFrame.RightVector
		end
		if unit.Magnitude < 0.05 and instanceFlag.MoveDirection.Magnitude > 0.05 then
			unit = instanceFlag.MoveDirection
		end
		if unit.Magnitude > 0 then
			unit = unit.Unit
		end
		local secondaryNumber = 0
		if userInputService:IsKeyDown(Enum.KeyCode.Space) or instanceFlag.Jump or flag then
			secondaryNumber = 1
		elseif userInputService:IsKeyDown(Enum.KeyCode.LeftControl) or secondaryFlag then
			secondaryNumber = -1
		end
		instanceFlag.PlatformStand = true
		bodyGyro.MaxTorque = pState.spin and Vector3.new(9000000000, 0, 9000000000)
			or Vector3.new(9000000000, 9000000000, 9000000000)
		bodyGyro.CFrame = currentCamera.CFrame
		local product = secondaryNumber * number
		local velocity = unit * number + Vector3.new(0, product, 0)
		bodyVelocity.Velocity = velocity
	elseif not pState.fly and (bodyGyro or bodyVelocity) then
		updatePlatformStand()
	end
	if pState.antiKnockback and (parent and (instanceFlag and not pState.fly)) then
		if not pState.antiKnockbackVelocity or pState.antiKnockbackVelocity.Parent ~= parent then
			pState.clearAntiKnockback()
			pState.antiKnockbackVelocity = Instance.new("BodyVelocity")
			pState.antiKnockbackVelocity.Name = "RawExploitAntiKnockback"
			pState.antiKnockbackVelocity.P = 25000
			pState.antiKnockbackVelocity.MaxForce = Vector3.new(1000000000, 0, 1000000000)
			pState.antiKnockbackVelocity.Parent = parent
		end
		local moveDirection = instanceFlag.MoveDirection
		local velocityNumber = pState.fastSpeed and 1000 or math.max(instanceFlag.WalkSpeed, 16)
		pState.antiKnockbackVelocity.Velocity =
			Vector3.new(moveDirection.X * velocityNumber, 0, moveDirection.Z * velocityNumber)
		parent.AssemblyLinearVelocity = Vector3.new(
			moveDirection.X * velocityNumber,
			math.clamp(parent.AssemblyLinearVelocity.Y, -90, 90),
			moveDirection.Z * velocityNumber
		)
		parent.AssemblyAngularVelocity = Vector3.zero
	elseif pState.antiKnockbackVelocity then
		pState.clearAntiKnockback()
	end
	if pState.noclip and (filterDescendantsInstancesFlag and parent) then
		if not pState.fly then
			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.FilterDescendantsInstances = { filterDescendantsInstancesFlag }
			pcall(function(...)
				raycastParams.RespectCanCollide = true
			end)
			local input = workspace:Raycast(parent.Position, Vector3.new(0, -18, 0), raycastParams)
			if input and input.Normal.Y >= 0.55 then
				local sum = (instanceFlag and instanceFlag.HipHeight or 2) + parent.Size.Y * 0.5
				local number = input.Position.Y + sum
				if parent.Position.Y < number + 0.08 then
					parent.CFrame = CFrame.new(parent.Position.X, number, parent.Position.Z) * parent.CFrame.Rotation
					parent.AssemblyLinearVelocity =
						Vector3.new(parent.AssemblyLinearVelocity.X, 0, parent.AssemblyLinearVelocity.Z)
				end
			end
		end
	end
	if pState.spin and (parent and instanceFlag) then
		if not bodyAngularVelocity or bodyAngularVelocity.Parent ~= parent then
			updateSpin()
			capturedInstanceFlag = instanceFlag
			autoRotate = instanceFlag.AutoRotate
			instanceFlag.AutoRotate = false
			bodyAngularVelocity = Instance.new("BodyAngularVelocity")
			bodyAngularVelocity.Name = "RawExploitSpin"
			bodyAngularVelocity.AngularVelocity = Vector3.new(0, 7, 0)
			bodyAngularVelocity.MaxTorque = Vector3.new(0, 9000000000, 0)
			bodyAngularVelocity.P = 6000
			bodyAngularVelocity.Parent = parent
		end
	elseif bodyAngularVelocity then
		updateSpin()
	end
	if pState.spy and workspace.CurrentCamera then
		local player = pState.spyTarget and players:FindFirstChild(pState.spyTarget)
		local cameraSubject = player and (player.Character and player.Character:FindFirstChildWhichIsA("Humanoid"))
		if cameraSubject then
			workspace.CurrentCamera.CameraSubject = cameraSubject
		end
	end
end))
handleFrame(backpackContainer.CharacterAdded:Connect(function(...)
	task.wait(0.6)
	if pState.fastSpeed then
		updateWalkSpeed()
	end
	if pState.fastPunch then
		alternateUpdateInstanceProperties(true)
	end
	if not pState.spy then
		updateCameraSubject()
	end
end))
local draggingData = {
	["minimized"] = false,
	["dragging"] = false,
	["dragStart"] = nil,
	["startPosition"] = nil,
	["dragDistance"] = 0,
	["entranceRootTween"] = nil,
	["entranceFrameTweens"] = {},
	["minimizeTweens"] = {},
	["shuttingDown"] = false,
}
local function handleMinimized(minimizedData, ...)
	for index, item in ipairs(minimizedData) do
		pcall(item.Cancel, item)
		minimizedData[index] = nil
	end
end
local function updatePosition(position, ...)
	canvasGroup.Position = position
end
local function setMinimized(minimized, ...)
	if draggingData.minimized == minimized then
		return
	end
	draggingData.minimized = minimized
	if not minimized then
		scrollingFrame.Visible = true
		fallbackParent.Visible = true
	end
	handleMinimized(draggingData.entranceFrameTweens)
	handleMinimized(draggingData.minimizeTweens)
	local setMinimizedOption = minimized and capturedSizeNumber or sizeNumber
	local quotient = (sizeNumber - capturedSizeNumber) / 2
	local minimizeTweensOption = minimized and UDim2.new(0.5, 0, 0.5, -quotient) or UDim2.fromScale(0.5, 0.5)
	local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	draggingData.minimizeTweens = {
		tweenService:Create(
			alternateParent,
			tweenInfo,
			{ ["Size"] = UDim2.fromOffset(setMinimizedNumber, setMinimizedOption), ["Position"] = minimizeTweensOption }
		),
		tweenService:Create(
			additionalParent,
			tweenInfo,
			{ ["Size"] = UDim2.fromOffset(setMinimizedNumber, setMinimizedOption), ["Position"] = minimizeTweensOption }
		),
		tweenService:Create(
			secondaryParent,
			tweenInfo,
			{
				["Size"] = UDim2.fromOffset(setMinimizedNumber, setMinimizedOption),
				["Position"] = minimizeTweensOption,
				["BackgroundTransparency"] = 1,
			}
		),
	}
	for index, item in ipairs(draggingData.minimizeTweens) do
		item:Play()
	end
	if minimized then
		task.delay(0.18, function(...)
			if draggingData.minimized then
				scrollingFrame.Visible = false
				fallbackParent.Visible = false
			end
		end)
	end
end
handleFrame(textButton.InputBegan:Connect(function(input, ...)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingData.dragging = true
		draggingData.dragStart = input.Position
		draggingData.startPosition = canvasGroup.Position
		draggingData.dragDistance = 0
	end
end))
handleFrame(userInputService.InputChanged:Connect(function(input, ...)
	if not draggingData.dragging or not draggingData.dragStart or not draggingData.startPosition then
		return
	end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end
	local difference = input.Position - draggingData.dragStart
	draggingData.dragDistance = difference.Magnitude
	local vector = isNumberValid()
	local sum = (vector.X * draggingData.startPosition.X.Scale + draggingData.startPosition.X.Offset) + difference.X
	local number = (vector.Y * draggingData.startPosition.Y.Scale + draggingData.startPosition.Y.Offset) + difference.Y
	updatePosition(UDim2.fromOffset(sum, number))
end))
handleFrame(userInputService.InputEnded:Connect(function(input, ...)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingData.dragging = false
	end
end))
handleFrame(textButton.Activated:Connect(function(...)
	if draggingData.dragDistance < 8 then
		setMinimized(not draggingData.minimized)
	end
end))
shutdown = function(condition, ...)
	if draggingData.shuttingDown then
		return
	end
	draggingData.shuttingDown = true
	if draggingData.entranceRootTween then
		pcall(draggingData.entranceRootTween.Cancel, draggingData.entranceRootTween)
		draggingData.entranceRootTween = nil
	end
	handleMinimized(draggingData.entranceFrameTweens)
	handleMinimized(draggingData.minimizeTweens)
	pState.running = false
	for index, item in ipairs(data) do
		pcall(item)
	end
	secondaryHandler()
	if option.RawExploitFG100 == tabsData then
		option.RawExploitFG100 = nil
	end
	if condition then
		if screenGui and screenGui.Parent then
			screenGui:Destroy()
		end
		return
	end
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
	local x = alternateParent.AbsoluteSize.X
	local y = alternateParent.AbsoluteSize.Y
	local number = math.floor(x * 0.9)
	local secondaryNumber = math.floor(y * 0.9)
	local position = canvasGroup.Position
	local dimensions = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + 14);
	(tweenService:Create(canvasGroup, tweenInfo, { ["Position"] = dimensions, ["GroupTransparency"] = 1 })):Play();
	(tweenService:Create(alternateParent, tweenInfo, { ["Size"] = UDim2.fromOffset(number, secondaryNumber) })):Play();
	(tweenService:Create(additionalParent, tweenInfo, { ["Size"] = UDim2.fromOffset(number, secondaryNumber) })):Play();
	(tweenService:Create(secondaryParent, tweenInfo, { ["Size"] = UDim2.fromOffset(number, secondaryNumber) })):Play()
	task.delay(0.32, function(...)
		if screenGui and screenGui.Parent then
			screenGui:Destroy()
		end
	end)
end
tabsData.Shutdown = shutdown
tabsData.State = pState
tabsData.Config = public
tabsData.Pages = pages
tabsData.Tabs = tabs
tabsData.SetMinimized = setMinimized
option.RawExploitFG100 = tabsData
canvasGroup.Position = UDim2.new(0.5, 0, 0.5, 18)
alternateParent.Size = UDim2.fromOffset(math.floor(setMinimizedNumber * 0.9), math.floor(sizeNumber * 0.9))
additionalParent.Size = UDim2.fromOffset(math.floor(setMinimizedNumber * 0.9), math.floor(sizeNumber * 0.9))
secondaryParent.Size = UDim2.fromOffset(math.floor(setMinimizedNumber * 0.9), math.floor(sizeNumber * 0.9))
runService.Heartbeat:Wait()
scrollingFrame.CanvasSize = UDim2.fromOffset(uiListLayout.AbsoluteContentSize.X + 14, 0)
if pState.resume and pState.resume.script == "fg100.lua" then
	updateScrollingFrame(
		type(pState.resume.tab) == "string" and (pages[pState.resume.tab] and pState.resume.tab) or "Info"
	)
	if pState.resume.protectFriends and pState.killProtectToggle then
		pState.killProtectToggle:Set(true)
	end
	if pState.resume.autoKill and pState.killAutoToggle then
		pState.killAutoToggle:Set(true)
	end
	if pState.resume.karmaMode == "evil" and pState.killEvilToggle then
		pState.killEvilToggle:Set(true)
	elseif pState.resume.karmaMode == "good" and pState.killGoodToggle then
		pState.killGoodToggle:Set(true)
	end
	if pState.resume.serverHop and pState.killServerHopToggle then
		pState.killServerHopToggle:Set(true)
	end
else
	updateScrollingFrame("Info")
end
pState.resume = nil
draggingData.entranceRootTween = tweenService:Create(
	canvasGroup,
	TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
	{ ["Position"] = UDim2.fromScale(0.5, 0.5), ["GroupTransparency"] = 0 }
)
draggingData.entranceFrameTweens = {
	tweenService:Create(
		alternateParent,
		TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ ["Size"] = UDim2.fromOffset(setMinimizedNumber, sizeNumber) }
	),
	tweenService:Create(
		additionalParent,
		TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ ["Size"] = UDim2.fromOffset(setMinimizedNumber, sizeNumber) }
	),
	tweenService:Create(
		secondaryParent,
		TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ ["Size"] = UDim2.fromOffset(setMinimizedNumber, sizeNumber) }
	),
}
draggingData.entranceRootTween:Play()
draggingData.entranceFrameTweens[1]:Play()
draggingData.entranceFrameTweens[2]:Play()
draggingData.entranceFrameTweens[3]:Play()
