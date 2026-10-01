--[[
	Noob Hack — Admin Panel for Roblox
	====================================
	
	Возможности:
		- Infinite Jump
		- Noclip
		- Player ESP (красные боксы)
		- NPC ESP (зелёные боксы)
		- Custom Sky (только для тебя)
		- Speed (до 1000)
		- Jump Power (до 1000)
	
	Установка:
		1. LocalScript в StarterPlayer > StarterPlayerScripts
		2. Вставить этот код
		3. Запустить игру
	
	Автор: Твой Ник
	Лицензия: MIT
--]]

-- ========================================================
--  СЕРВИСЫ
-- ========================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================================
--  НАСТРОЙКИ
-- ========================================================
local CONFIG = {
	-- КАРТИНКИ (Texture ID)
	BUTTON_IMAGE = "rbxassetid://6877509129",
	PANEL_IMAGE  = "rbxassetid://15262574528",
	TOGGLE_IMG   = "rbxassetid://5288894332",
	CLOSE_IMG    = "rbxassetid://103764922902217",
	
	-- UI
	TITLE_TEXT       = "Noob hack",
	STROKE_COLOR     = Color3.fromRGB(90, 130, 255),
	STROKE_THICKNESS = 2,
	
	-- ESP
	ESP_PLAYER_COLOR = Color3.fromRGB(255, 48, 48),
	ESP_NPC_COLOR    = Color3.fromRGB(50, 255, 50),
	
	-- SKY
	SKY_TEXTURE = "rbxassetid://5026510308",
	
	-- РАЗМЕРЫ
	PANEL_SIZE   = UDim2.new(0, 320, 0, 400),
	BTN_HEIGHT   = 55,
	ROW_HEIGHT   = 60,
	BOTTOM_SPACE = 250,
	
	-- ЗНАЧЕНИЯ ПО УМОЛЧАНИЮ
	DEFAULT_SPEED      = 16,
	DEFAULT_JUMP_POWER = 50,
	MAX_SPEED          = 1000,
	MAX_JUMP_POWER     = 1000,
	MIN_SPEED          = 8,
	MIN_JUMP_POWER     = 50,
}

-- ========================================================
--  ROOT GUI
-- ========================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoobHack"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ========================================================
--  КРУГЛАЯ КНОПКА
-- ========================================================
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 60, 0, 60)
button.Position = UDim2.new(0, 100, 0, 100)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
button.BorderSizePixel = 0
button.Text = ""
button.AutoButtonColor = false
button.Parent = screenGui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = button

local buttonImage = Instance.new("ImageLabel")
buttonImage.Size = UDim2.new(1, -6, 1, -6)
buttonImage.Position = UDim2.new(0, 3, 0, 3)
buttonImage.BackgroundTransparency = 1
buttonImage.Image = CONFIG.BUTTON_IMAGE
buttonImage.ScaleType = Enum.ScaleType.Crop
buttonImage.Parent = button

local buttonImageCorner = Instance.new("UICorner")
buttonImageCorner.CornerRadius = UDim.new(1, 0)
buttonImageCorner.Parent = buttonImage

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = CONFIG.STROKE_COLOR
buttonStroke.Thickness = CONFIG.STROKE_THICKNESS
buttonStroke.Parent = button

-- ========================================================
--  ПАНЕЛЬ
-- ========================================================
local panel = Instance.new("ImageLabel")
panel.Size = CONFIG.PANEL_SIZE
panel.Position = UDim2.new(0.5, -160, 0.5, -200)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
panel.BorderSizePixel = 0
panel.Image = CONFIG.PANEL_IMAGE
panel.ScaleType = Enum.ScaleType.Stretch
panel.Visible = false
panel.ClipsDescendants = true
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 14)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = CONFIG.STROKE_COLOR
panelStroke.Thickness = CONFIG.STROKE_THICKNESS
panelStroke.Parent = panel

-- ========================================================
--  ЗАГОЛОВОК
-- ========================================================
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 0, 36)
titleLabel.Position = UDim2.new(0, 12, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = CONFIG.TITLE_TEXT
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 6
titleLabel.Visible = false
titleLabel.Parent = screenGui

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = CONFIG.STROKE_COLOR
titleStroke.Thickness = 2
titleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
titleStroke.Parent = titleLabel

-- ========================================================
--  КНОПКА ЗАКРЫТИЯ
-- ========================================================
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = ""
closeBtn.AutoButtonColor = false
closeBtn.Visible = false
closeBtn.ZIndex = 10
closeBtn.Parent = screenGui

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

local closeImage = Instance.new("ImageLabel")
closeImage.Size = UDim2.new(1, -4, 1, -4)
closeImage.Position = UDim2.new(0, 2, 0, 2)
closeImage.BackgroundTransparency = 1
closeImage.Image = CONFIG.CLOSE_IMG
closeImage.ScaleType = Enum.ScaleType.Crop
closeImage.ZIndex = 11
closeImage.Parent = closeBtn

local closeImageCorner = Instance.new("UICorner")
closeImageCorner.CornerRadius = UDim.new(1, 0)
closeImageCorner.Parent = closeImage

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = CONFIG.STROKE_COLOR
closeStroke.Thickness = CONFIG.STROKE_THICKNESS
closeStroke.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), { Size = UDim2.new(0, 34, 0, 34) }):Play()
end)

closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), { Size = UDim2.new(0, 30, 0, 30) }):Play()
end)

-- ========================================================
--  SCROLLING FRAME
-- ========================================================
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -70)
scroll.Position = UDim2.new(0, 8, 0, 50)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = CONFIG.STROKE_COLOR
scroll.ScrollBarImageTransparency = 0.3
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
scroll.Parent = panel

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 8)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
scrollLayout.Parent = scroll

local scrollPadding = Instance.new("UIPadding")
scrollPadding.PaddingTop = UDim.new(0, 6)
scrollPadding.PaddingBottom = UDim.new(0, CONFIG.BOTTOM_SPACE)
scrollPadding.Parent = scroll

local function updateClosePos()
	closeBtn.Position = UDim2.new(
		panel.Position.X.Scale, panel.Position.X.Offset + panel.AbsoluteSize.X - 38,
		panel.Position.Y.Scale, panel.Position.Y.Offset + 8
	)
	titleLabel.Position = UDim2.new(
		panel.Position.X.Scale, panel.Position.X.Offset + 12,
		panel.Position.Y.Scale, panel.Position.Y.Offset + 4
	)
end

-- ========================================================
--  ХЕЛПЕР: КНОПКА-ПЕРЕКЛЮЧАТЕЛЬ
-- ========================================================
local function createPanelButton(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -8, 0, CONFIG.BTN_HEIGHT)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Visible = false
	btn.ZIndex = 3
	btn.LayoutOrder = order
	btn.Parent = scroll

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = btn

	local bg = Instance.new("ImageLabel")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundTransparency = 1
	bg.Image = CONFIG.TOGGLE_IMG
	bg.ScaleType = Enum.ScaleType.Stretch
	bg.ZIndex = 2
	bg.Parent = btn

	local bgCorner = Instance.new("UICorner")
	bgCorner.CornerRadius = UDim.new(0, 10)
	bgCorner.Parent = bg

	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.45
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 3
	overlay.Parent = btn

	local overlayCorner = Instance.new("UICorner")
	overlayCorner.CornerRadius = UDim.new(0, 10)
	overlayCorner.Parent = overlay

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.TextTransparency = 0
	label.TextStrokeTransparency = 0.5
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.ZIndex = 6
	label.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = CONFIG.STROKE_COLOR
	stroke.Thickness = CONFIG.STROKE_THICKNESS
	stroke.Parent = btn

	return btn, label
end

-- ========================================================
--  ХЕЛПЕР: ROW С [−] [TextBox] [+]
-- ========================================================
local function createValueRow(name, order, defaultVal, step, minVal, maxVal, applyFunc)
	local currentValue = defaultVal

	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -8, 0, CONFIG.ROW_HEIGHT)
	row.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Visible = false
	row.ZIndex = 3
	row.Parent = scroll

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = row

	local bg = Instance.new("ImageLabel")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundTransparency = 1
	bg.Image = CONFIG.TOGGLE_IMG
	bg.ScaleType = Enum.ScaleType.Stretch
	bg.ZIndex = 2
	bg.Parent = row

	local bgCorner = Instance.new("UICorner")
	bgCorner.CornerRadius = UDim.new(0, 10)
	bgCorner.Parent = bg

	local overlay = Instance.new("Frame")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.45
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 3
	overlay.Parent = row

	local overlayCorner = Instance.new("UICorner")
	overlayCorner.CornerRadius = UDim.new(0, 10)
	overlayCorner.Parent = overlay

	local stroke = Instance.new("UIStroke")
	stroke.Color = CONFIG.STROKE_COLOR
	stroke.Thickness = CONFIG.STROKE_THICKNESS
	stroke.Parent = row

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -20, 0, 14)
	nameLabel.Position = UDim2.new(0, 10, 0, 4)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 11
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.ZIndex = 6
	nameLabel.Parent = row

	local minusBtn = Instance.new("TextButton")
	minusBtn.Size = UDim2.new(0, 30, 0, 26)
	minusBtn.Position = UDim2.new(0, 6, 1, -32)
	minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	minusBtn.BackgroundTransparency = 0.3
	minusBtn.BorderSizePixel = 0
	minusBtn.Text = "−"
	minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	minusBtn.Font = Enum.Font.GothamBold
	minusBtn.TextSize = 18
	minusBtn.AutoButtonColor = false
	minusBtn.ZIndex = 6
	minusBtn.Parent = row

	local minusCorner = Instance.new("UICorner")
	minusCorner.CornerRadius = UDim.new(0, 8)
	minusCorner.Parent = minusBtn

	local plusBtn = Instance.new("TextButton")
	plusBtn.Size = UDim2.new(0, 30, 0, 26)
	plusBtn.Position = UDim2.new(1, -36, 1, -32)
	plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	plusBtn.BackgroundTransparency = 0.3
	plusBtn.BorderSizePixel = 0
	plusBtn.Text = "+"
	plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	plusBtn.Font = Enum.Font.GothamBold
	plusBtn.TextSize = 18
	plusBtn.AutoButtonColor = false
	plusBtn.ZIndex = 6
	plusBtn.Parent = row

	local plusCorner = Instance.new("UICorner")
	plusCorner.CornerRadius = UDim.new(0, 8)
	plusCorner.Parent = plusBtn

	local inputBox = Instance.new("TextBox")
	inputBox.Size = UDim2.new(1, -80, 0, 26)
	inputBox.Position = UDim2.new(0, 40, 1, -32)
	inputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	inputBox.BackgroundTransparency = 0.15
	inputBox.BorderSizePixel = 0
	inputBox.Text = tostring(defaultVal)
	inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputBox.Font = Enum.Font.GothamBold
	inputBox.TextSize = 14
	inputBox.PlaceholderText = "0 - " .. maxVal
	inputBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 160)
	inputBox.ClearTextOnFocus = false
	inputBox.ZIndex = 6
	inputBox.Parent = row

	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 8)
	inputCorner.Parent = inputBox

	local inputStroke = Instance.new("UIStroke")
	inputStroke.Color = CONFIG.STROKE_COLOR
	inputStroke.Thickness = 1
	inputStroke.Parent = inputBox

	local function apply()
		if applyFunc then applyFunc(currentValue) end
	end

	local function setValue(newVal, updateText)
		currentValue = math.clamp(math.floor(newVal + 0.5), minVal, maxVal)
		if updateText then
			inputBox.Text = tostring(currentValue)
		end
		apply()
	end

	minusBtn.MouseButton1Click:Connect(function() setValue(currentValue - step, true) end)
	plusBtn.MouseButton1Click:Connect(function() setValue(currentValue + step, true) end)

	inputBox.FocusLost:Connect(function()
		local num = tonumber(inputBox.Text)
		if num then
			setValue(num, true)
		else
			inputBox.Text = tostring(currentValue)
		end
	end)

	inputBox:GetPropertyChangedSignal("Text"):Connect(function()
		local cleaned = inputBox.Text:gsub("%D", "")
		if cleaned ~= inputBox.Text then
			inputBox.Text = cleaned
		end
	end)

	return row, inputBox, setValue
end

-- ========================================================
--  СОЗДАНИЕ ЭЛЕМЕНТОВ ПАНЕЛИ
-- ========================================================
local infJumpBtn, infJumpText = createPanelButton("Infinite Jump: OFF", 1)
local noclipBtn, noclipText = createPanelButton("Noclip: OFF", 2)
local espPlayerBtn, espPlayerText = createPanelButton("Player ESP: OFF", 3)
local espNpcBtn, espNpcText = createPanelButton("NPC ESP: OFF", 4)
local skyBtn, skyText = createPanelButton("Custom Sky: OFF", 5)

local currentSpeed = CONFIG.DEFAULT_SPEED
local currentJumpPower = CONFIG.DEFAULT_JUMP_POWER

local function applySpeed(v)
	currentSpeed = v
	if player.Character then
		local h = player.Character:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = v end
	end
end

local function applyJump(v)
	currentJumpPower = v
	if player.Character then
		local h = player.Character:FindFirstChildOfClass("Humanoid")
		if h then h.JumpPower = v end
	end
end

local speedRow = createValueRow(
	"Speed", 6, CONFIG.DEFAULT_SPEED, 4,
	CONFIG.MIN_SPEED, CONFIG.MAX_SPEED, applySpeed
)
local jumpRow = createValueRow(
	"Jump Power", 7, CONFIG.DEFAULT_JUMP_POWER, 10,
	CONFIG.MIN_JUMP_POWER, CONFIG.MAX_JUMP_POWER, applyJump
)

-- ========================================================
--  ПРИМЕНИТЬ ПРИ РЕСПАВНЕ
-- ========================================================
player.CharacterAdded:Connect(function()
	task.wait(0.4)
	applySpeed(currentSpeed)
	applyJump(currentJumpPower)
end)

-- ========================================================
--  INFINITE JUMP
-- ========================================================
local infJumpEnabled = false
local infJumpConn

infJumpBtn.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled

	if infJumpEnabled then
		infJumpConn = UserInputService.JumpRequest:Connect(function()
			if infJumpEnabled and player.Character then
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end
		end)
		infJumpText.Text = "Infinite Jump: ON"
	else
		if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
		infJumpText.Text = "Infinite Jump: OFF"
	end
end)

-- ========================================================
--  NOCLIP
-- ========================================================
local noclipEnabled = false
local noclipConn

local function applyNoclip()
	if not noclipEnabled then return end
	local char = player.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") and part.CanCollide then
			part.CanCollide = false
		end
	end
end

noclipBtn.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled

	if noclipEnabled then
		applyNoclip()
		noclipConn = RunService.Stepped:Connect(function()
			if noclipEnabled then applyNoclip() end
		end)
		noclipText.Text = "Noclip: ON"
	else
		if noclipConn then noclipConn:Disconnect() noclipConn = nil end
		local char = player.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
		end
		noclipText.Text = "Noclip: OFF"
	end
end)

player.CharacterAdded:Connect(function()
	if noclipEnabled then
		task.wait(0.4)
		applyNoclip()
	end
end)

-- ========================================================
--  PLAYER ESP
-- ========================================================
local playerEspEnabled = false

local function playerEspLoop()
	while playerEspEnabled do
		for _, childrik in ipairs(workspace:GetDescendants()) do
			if childrik:FindFirstChild("Humanoid") then
				if not childrik:FindFirstChild("EspBoxPlayer") then
					if childrik ~= player.Character then
						if Players:GetPlayerFromCharacter(childrik) then
							local esp = Instance.new("BoxHandleAdornment", childrik)
							esp.Adornee = childrik
							esp.ZIndex = 0
							esp.Size = Vector3.new(4, 5, 1)
							esp.Transparency = 0.65
							esp.Color3 = CONFIG.ESP_PLAYER_COLOR
							esp.AlwaysOnTop = true
							esp.Name = "EspBoxPlayer"
						end
					end
				end
			end
		end
		task.wait(0.5)
	end
end

local function startPlayerESP() playerEspEnabled = true task.spawn(playerEspLoop) end
local function stopPlayerESP()
	playerEspEnabled = false
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "EspBoxPlayer" then obj:Destroy() end
	end
end

-- ========================================================
--  NPC ESP
-- ========================================================
local npcEspEnabled = false

local function npcEspLoop()
	while npcEspEnabled do
		for _, childrik in ipairs(workspace:GetDescendants()) do
			if childrik:FindFirstChild("Humanoid") then
				if not childrik:FindFirstChild("EspBoxNPC") then
					if not Players:GetPlayerFromCharacter(childrik) then
						if childrik ~= player.Character then
							local esp = Instance.new("BoxHandleAdornment", childrik)
							esp.Adornee = childrik
							esp.ZIndex = 0
							esp.Size = Vector3.new(4, 5, 1)
							esp.Transparency = 0.65
							esp.Color3 = CONFIG.ESP_NPC_COLOR
							esp.AlwaysOnTop = true
							esp.Name = "EspBoxNPC"
						end
					end
				end
			end
		end
		task.wait(0.5)
	end
end

local function startNPCESP() npcEspEnabled = true task.spawn(npcEspLoop) end
local function stopNPCESP()
	npcEspEnabled = false
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "EspBoxNPC" then obj:Destroy() end
	end
end

-- ========================================================
--  CUSTOM SKY
-- ========================================================
local skyEnabled = false
local customSky = nil
local hiddenSkies = {}

local function findAllSkies()
	local skies = {}
	for _, obj in ipairs(Lighting:GetChildren()) do
		if obj:IsA("Sky") then
			table.insert(skies, obj)
		end
	end
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Sky") then
			table.insert(skies, obj)
		end
	end
	return skies
end

local function enableCustomSky()
	hiddenSkies = {}
	local allSkies = findAllSkies()
	
	for _, sky in ipairs(allSkies) do
		table.insert(hiddenSkies, {obj = sky, parent = sky.Parent})
		sky.Parent = nil
	end
	
	if customSky then customSky:Destroy() end
	
	customSky = Instance.new("Sky")
	customSky.Name = "NoobHackSky"
	customSky.SkyboxUp    = CONFIG.SKY_TEXTURE
	customSky.SkyboxDown  = CONFIG.SKY_TEXTURE
	customSky.SkyboxLeft  = CONFIG.SKY_TEXTURE
	customSky.SkyboxRight = CONFIG.SKY_TEXTURE
	customSky.SkyboxFront = CONFIG.SKY_TEXTURE
	customSky.SkyboxBack  = CONFIG.SKY_TEXTURE
	customSky.Parent = Lighting
	
	skyEnabled = true
end

local function disableCustomSky()
	if customSky then
		customSky:Destroy()
		customSky = nil
	end
	
	for _, data in ipairs(hiddenSkies) do
		if data.obj and data.parent then
			data.obj.Parent = data.parent
		end
	end
	hiddenSkies = {}
	
	skyEnabled = false
end

skyBtn.MouseButton1Click:Connect(function()
	if skyEnabled then
		disableCustomSky()
		skyText.Text = "Custom Sky: OFF"
	else
		enableCustomSky()
		skyText.Text = "Custom Sky: ON"
	end
end)

-- ===== КНОПКИ ESP =====
espPlayerBtn.MouseButton1Click:Connect(function()
	if playerEspEnabled then
		stopPlayerESP()
		espPlayerText.Text = "Player ESP: OFF"
	else
		startPlayerESP()
		espPlayerText.Text = "Player ESP: ON"
	end
end)

espNpcBtn.MouseButton1Click:Connect(function()
	if npcEspEnabled then
		stopNPCESP()
		espNpcText.Text = "NPC ESP: OFF"
	else
		startNPCESP()
		espNpcText.Text = "NPC ESP: ON"
	end
end)

-- ========================================================
--  ПЕРЕТАСКИВАНИЕ
-- ========================================================
local function makeDraggable(frame, dragArea)
	local dragging = false
	local dragStart, startPos

	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
			if frame == panel then updateClosePos() end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(button, button)
makeDraggable(panel, panel)

-- ========================================================
--  OPEN / CLOSE
-- ========================================================
local movedDistance = 0
local dragStartPos
local isOpen = false

local function fadeOutTexts()
	TweenService:Create(titleLabel, TweenInfo.new(0.12), { TextTransparency = 1 }):Play()
	TweenService:Create(titleStroke, TweenInfo.new(0.12), { Transparency = 1 }):Play()
	TweenService:Create(infJumpText, TweenInfo.new(0.12), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
	TweenService:Create(noclipText, TweenInfo.new(0.12), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
	TweenService:Create(espPlayerText, TweenInfo.new(0.12), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
	TweenService:Create(espNpcText, TweenInfo.new(0.12), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
	TweenService:Create(skyText, TweenInfo.new(0.12), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
end

local function fadeInTexts()
	TweenService:Create(titleLabel, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
	TweenService:Create(titleStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
	TweenService:Create(infJumpText, TweenInfo.new(0.2), { TextTransparency = 0, TextStrokeTransparency = 0.5 }):Play()
	TweenService:Create(noclipText, TweenInfo.new(0.2), { TextTransparency = 0, TextStrokeTransparency = 0.5 }):Play()
	TweenService:Create(espPlayerText, TweenInfo.new(0.2), { TextTransparency = 0, TextStrokeTransparency = 0.5 }):Play()
	TweenService:Create(espNpcText, TweenInfo.new(0.2), { TextTransparency = 0, TextStrokeTransparency = 0.5 }):Play()
	TweenService:Create(skyText, TweenInfo.new(0.2), { TextTransparency = 0, TextStrokeTransparency = 0.5 }):Play()
end

local function openPanel()
	isOpen = true
	panel.Visible = true
	closeBtn.Visible = true
	titleLabel.Visible = true
	infJumpBtn.Visible = true
	noclipBtn.Visible = true
	espPlayerBtn.Visible = true
	espNpcBtn.Visible = true
	skyBtn.Visible = true
	speedRow.Visible = true
	jumpRow.Visible = true

	updateClosePos()

	titleLabel.TextTransparency = 1
	titleStroke.Transparency = 1
	infJumpText.TextTransparency = 1
	noclipText.TextTransparency = 1
	espPlayerText.TextTransparency = 1
	espNpcText.TextTransparency = 1
	skyText.TextTransparency = 1

	panel.Size = UDim2.new(0, 0, 0, 0)
	TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = CONFIG.PANEL_SIZE
	}):Play()

	task.delay(0.12, fadeInTexts)
end

local function closePanel()
	isOpen = false
	fadeOutTexts()

	task.delay(0.15, function()
		local tween = TweenService:Create(panel, TweenInfo.new(0.2), {
			Size = UDim2.new(0, 0, 0, 0)
		})
		tween:Play()
		tween.Completed:Connect(function()
			panel.Visible = false
			closeBtn.Visible = false
			titleLabel.Visible = false
			infJumpBtn.Visible = false
			noclipBtn.Visible = false
			espPlayerBtn.Visible = false
			espNpcBtn.Visible = false
			skyBtn.Visible = false
			speedRow.Visible = false
			jumpRow.Visible = false

			titleLabel.TextTransparency = 0
			titleStroke.Transparency = 0
			infJumpText.TextTransparency = 0
			infJumpText.TextStrokeTransparency = 0.5
			noclipText.TextTransparency = 0
			noclipText.TextStrokeTransparency = 0.5
			espPlayerText.TextTransparency = 0
			espPlayerText.TextStrokeTransparency = 0.5
			espNpcText.TextTransparency = 0
			espNpcText.TextStrokeTransparency = 0.5
			skyText.TextTransparency = 0
			skyText.TextStrokeTransparency = 0.5
		end)
	end)
end

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		movedDistance = 0
		dragStartPos = input.Position
		TweenService:Create(button, TweenInfo.new(0.1), {
			Size = UDim2.new(0, 54, 0, 54)
		}):Play()
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragStartPos and (input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStartPos
		movedDistance = math.abs(delta.X) + math.abs(delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		TweenService:Create(button, TweenInfo.new(0.1), {
			Size = UDim2.new(0, 60, 0, 60)
		}):Play()
	end
end)

button.MouseButton1Click:Connect(function()
	if movedDistance < 10 then
		if isOpen then closePanel() else openPanel() end
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	if isOpen then closePanel() end
end)

print("✅ Noob Hack загружен!")
