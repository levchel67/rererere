--[[
	Noob Hack — Admin Panel for Roblox
	===================================
	
	Возможности:
		- Infinite Jump
		- Infinite Animation
		- Hitbox ESP (красные рамки)
		- Speed (ручной ввод до 1000)
		- Jump Power (ручной ввод до 1000)
	
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
local Camera = workspace.CurrentCamera

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
	
	-- АНИМАЦИЯ
	ANIMATION_ID = "rbxassetid://129127921298715",
	
	-- UI
	TITLE_TEXT       = "Noob hack",
	STROKE_COLOR     = Color3.fromRGB(90, 130, 255),
	STROKE_THICKNESS = 2,
	ESP_COLOR        = Color3.fromRGB(255, 40, 40),
	
	PANEL_SIZE = UDim2.new(0, 400, 0, 520),
	
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
screenGui.Parent = playerGui

-- ========================================================
--  КРУГЛАЯ КНОПКА
-- ========================================================
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 70, 0, 70)
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
panel.Position = UDim2.new(0.5, -200, 0.5, -260)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
panel.BorderSizePixel = 0
panel.Image = CONFIG.PANEL_IMAGE
panel.ScaleType = Enum.ScaleType.Crop
panel.Visible = false
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
titleLabel.Size = UDim2.new(1, -90, 0, 42)
titleLabel.Position = UDim2.new(0, 15, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = CONFIG.TITLE_TEXT
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 26
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
closeBtn.Size = UDim2.new(0, 36, 0, 36)
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
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		Size = UDim2.new(0, 40, 0, 40)
	}):Play()
end)

closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		Size = UDim2.new(0, 36, 0, 36)
	}):Play()
end)

local function updateClosePos()
	closeBtn.Position = UDim2.new(
		panel.Position.X.Scale, panel.Position.X.Offset + panel.AbsoluteSize.X - 46,
		panel.Position.Y.Scale, panel.Position.Y.Offset + 10
	)
	titleLabel.Position = UDim2.new(
		panel.Position.X.Scale, panel.Position.X.Offset + 15,
		panel.Position.Y.Scale, panel.Position.Y.Offset + 6
	)
end

-- ========================================================
--  ХЕЛПЕР: КНОПКА-ПЕРЕКЛЮЧАТЕЛЬ
-- ========================================================
local function createPanelButton(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -40, 0, 60)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Visible = false
	btn.ZIndex = 3
	btn.LayoutOrder = order
	btn.Parent = panel

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = btn

	local bg = Instance.new("ImageLabel")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundTransparency = 1
	bg.Image = CONFIG.TOGGLE_IMG
	bg.ScaleType = Enum.ScaleType.Crop
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
	label.TextSize = 14
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
	row.Size = UDim2.new(1, -40, 0, 55)
	row.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Visible = false
	row.ZIndex = 3
	row.Parent = panel

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = row

	local bg = Instance.new("ImageLabel")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundTransparency = 1
	bg.Image = CONFIG.TOGGLE_IMG
	bg.ScaleType = Enum.ScaleType.Crop
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
	nameLabel.Size = UDim2.new(1, -20, 0, 16)
	nameLabel.Position = UDim2.new(0, 10, 0, 3)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 12
	nameLabel.TextTransparency = 0
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.ZIndex = 6
	nameLabel.Parent = row

	local minusBtn = Instance.new("TextButton")
	minusBtn.Size = UDim2.new(0, 36, 0, 28)
	minusBtn.Position = UDim2.new(0, 6, 1, -34)
	minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	minusBtn.BackgroundTransparency = 0.3
	minusBtn.BorderSizePixel = 0
	minusBtn.Text = "−"
	minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	minusBtn.Font = Enum.Font.GothamBold
	minusBtn.TextSize = 20
	minusBtn.AutoButtonColor = false
	minusBtn.ZIndex = 6
	minusBtn.Parent = row

	local minusCorner = Instance.new("UICorner")
	minusCorner.CornerRadius = UDim.new(0, 8)
	minusCorner.Parent = minusBtn

	local plusBtn = Instance.new("TextButton")
	plusBtn.Size = UDim2.new(0, 36, 0, 28)
	plusBtn.Position = UDim2.new(1, -42, 1, -34)
	plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
	plusBtn.BackgroundTransparency = 0.3
	plusBtn.BorderSizePixel = 0
	plusBtn.Text = "+"
	plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	plusBtn.Font = Enum.Font.GothamBold
	plusBtn.TextSize = 20
	plusBtn.AutoButtonColor = false
	plusBtn.ZIndex = 6
	plusBtn.Parent = row

	local plusCorner = Instance.new("UICorner")
	plusCorner.CornerRadius = UDim.new(0, 8)
	plusCorner.Parent = plusBtn

	local inputBox = Instance.new("TextBox")
	inputBox.Size = UDim2.new(1, -100, 0, 28)
	inputBox.Position = UDim2.new(0, 48, 1, -34)
	inputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	inputBox.BackgroundTransparency = 0.15
	inputBox.BorderSizePixel = 0
	inputBox.Text = tostring(defaultVal)
	inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputBox.Font = Enum.Font.GothamBold
	inputBox.TextSize = 15
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
local infAnimBtn, infAnimText = createPanelButton("Infinite Animation: OFF", 2)
local espBtn, espText = createPanelButton("Hitbox ESP: OFF", 3)

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
	"Speed", 4, CONFIG.DEFAULT_SPEED, 4,
	CONFIG.MIN_SPEED, CONFIG.MAX_SPEED, applySpeed
)
local jumpRow = createValueRow(
	"Jump Power", 5, CONFIG.DEFAULT_JUMP_POWER, 10,
	CONFIG.MIN_JUMP_POWER, CONFIG.MAX_JUMP_POWER, applyJump
)

-- ========================================================
--  LAYOUT
-- ========================================================
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = panel

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 60)
padding.Parent = panel

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
--  INFINITE ANIMATION
-- ========================================================
local infAnimEnabled = false
local currentAnimator
local currentTrack
local animConnection

local function loadAnimator()
	local char = player.Character
	if not char then return nil end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return nil end
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end
	return animator
end

local function playInfiniteAnimation()
	currentAnimator = loadAnimator()
	if not currentAnimator then return end

	local anim = Instance.new("Animation")
	anim.AnimationId = CONFIG.ANIMATION_ID

	local success, track = pcall(function()
		return currentAnimator:LoadAnimation(anim)
	end)

	if not success or not track then
		warn("❌ Не удалось загрузить анимацию")
		return
	end

	currentTrack = track
	currentTrack.Looped = true
	currentTrack.Priority = Enum.AnimationPriority.Action4
	currentTrack:Play()
end

local function stopInfiniteAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack = nil
	end
end

infAnimBtn.MouseButton1Click:Connect(function()
	infAnimEnabled = not infAnimEnabled

	if infAnimEnabled then
		playInfiniteAnimation()

		animConnection = player.CharacterAdded:Connect(function()
			task.wait(0.5)
			if infAnimEnabled then
				playInfiniteAnimation()
			end
		end)

		infAnimText.Text = "Infinite Animation: ON"
	else
		stopInfiniteAnimation()
		if animConnection then animConnection:Disconnect() animConnection = nil end
		infAnimText.Text = "Infinite Animation: OFF"
	end
end)

-- ========================================================
--  HITBOX ESP
-- ========================================================
local espEnabled = false
local espRenderConn
local espBoxes = {}

local espGui = Instance.new("ScreenGui")
espGui.Name = "HitboxESP"
espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true
espGui.Parent = playerGui

local function createBox()
	local box = {}
	for i = 1, 4 do
		local line = Instance.new("Frame")
		line.BackgroundColor3 = CONFIG.ESP_COLOR
		line.BorderSizePixel = 0
		line.Visible = false
		line.ZIndex = 1
		line.Parent = espGui
		box[i] = line
	end
	return box
end

local function destroyBox(box)
	for _, line in ipairs(box) do
		line:Destroy()
	end
end

local function hideBox(box)
	for _, line in ipairs(box) do
		line.Visible = false
	end
end

local function updateBox(box, topLeft, topRight, bottomLeft, bottomRight, thickness)
	box[1].Position = UDim2.new(0, topLeft.X, 0, topLeft.Y)
	box[1].Size = UDim2.new(0, math.max(topRight.X - topLeft.X, 1), 0, thickness)
	box[1].Visible = true

	box[2].Position = UDim2.new(0, bottomLeft.X, 0, bottomLeft.Y)
	box[2].Size = UDim2.new(0, math.max(bottomRight.X - bottomLeft.X, 1), 0, thickness)
	box[2].Visible = true

	box[3].Position = UDim2.new(0, topLeft.X, 0, topLeft.Y)
	box[3].Size = UDim2.new(0, thickness, 0, math.max(bottomLeft.Y - topLeft.Y, 1))
	box[3].Visible = true

	box[4].Position = UDim2.new(0, topRight.X, 0, topRight.Y)
	box[4].Size = UDim2.new(0, thickness, 0, math.max(bottomRight.Y - topRight.Y, 1))
	box[4].Visible = true
end

local function updateESP()
	if not espEnabled then return end

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= player and otherPlayer.Character then
			if not espBoxes[otherPlayer] then
				espBoxes[otherPlayer] = createBox()
			end

			local box = espBoxes[otherPlayer]
			local hrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = otherPlayer.Character:FindFirstChildOfClass("Humanoid")

			if hrp and humanoid and humanoid.Health > 0 then
				local center = hrp.Position
				local size = Vector3.new(2, 6, 1)

				local corners = {
					center + Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
					center + Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
					center + Vector3.new(-size.X/2,  size.Y/2,  size.Z/2),
					center + Vector3.new( size.X/2,  size.Y/2,  size.Z/2),
					center + Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
					center + Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
					center + Vector3.new(-size.X/2, -size.Y/2,  size.Z/2),
					center + Vector3.new( size.X/2, -size.Y/2,  size.Z/2),
				}

				local screenPoints = {}
				local anyOnScreen = false
				local allInFront = true

				for i, corner in ipairs(corners) do
					local screenPos, onScreen = Camera:WorldToViewportPoint(corner)
					screenPoints[i] = Vector2.new(screenPos.X, screenPos.Y)
					if onScreen then anyOnScreen = true end
					if screenPos.Z <= 0 then allInFront = false end
				end

				if anyOnScreen and allInFront then
					local minX, minY = math.huge, math.huge
					local maxX, maxY = -math.huge, -math.huge

					for _, pt in ipairs(screenPoints) do
						minX = math.min(minX, pt.X)
						minY = math.min(minY, pt.Y)
						maxX = math.max(maxX, pt.X)
						maxY = math.max(maxY, pt.Y)
					end

					updateBox(
						box,
						Vector2.new(minX, minY),
						Vector2.new(maxX, minY),
						Vector2.new(minX, maxY),
						Vector2.new(maxX, maxY),
						2
					)
				else
					hideBox(box)
				end
			else
				hideBox(box)
			end
		end
	end

	for p, box in pairs(espBoxes) do
		if not p.Parent then
			destroyBox(box)
			espBoxes[p] = nil
		end
	end
end

local function startESP()
	espEnabled = true
	espRenderConn = RunService.RenderStepped:Connect(updateESP)
end

local function stopESP()
	espEnabled = false
	if espRenderConn then
		espRenderConn:Disconnect()
		espRenderConn = nil
	end
	for _, box in pairs(espBoxes) do
		hideBox(box)
	end
end

espBtn.MouseButton1Click:Connect(function()
	if espEnabled then
		stopESP()
		espText.Text = "Hitbox ESP: OFF"
	else
		startESP()
		espText.Text = "Hitbox ESP: ON"
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
			if frame == panel then
				updateClosePos()
			end
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
	TweenService:Create(infAnimText, TweenInfo.new(0.12), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
	TweenService:Create(espText, TweenInfo.new(0.12), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
end

local function fadeInTexts()
	TweenService:Create(titleLabel, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
	TweenService:Create(titleStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
	TweenService:Create(infJumpText, TweenInfo.new(0.2), { TextTransparency = 0, TextStrokeTransparency = 0.5 }):Play()
	TweenService:Create(infAnimText, TweenInfo.new(0.2), { TextTransparency = 0, TextStrokeTransparency = 0.5 }):Play()
	TweenService:Create(espText, TweenInfo.new(0.2), { TextTransparency = 0, TextStrokeTransparency = 0.5 }):Play()
end

local function openPanel()
	isOpen = true
	panel.Visible = true
	closeBtn.Visible = true
	titleLabel.Visible = true
	infJumpBtn.Visible = true
	infAnimBtn.Visible = true
	espBtn.Visible = true
	speedRow.Visible = true
	jumpRow.Visible = true

	updateClosePos()

	titleLabel.TextTransparency = 1
	titleStroke.Transparency = 1
	infJumpText.TextTransparency = 1
	infAnimText.TextTransparency = 1
	espText.TextTransparency = 1

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
			infAnimBtn.Visible = false
			espBtn.Visible = false
			speedRow.Visible = false
			jumpRow.Visible = false

			titleLabel.TextTransparency = 0
			titleStroke.Transparency = 0
			infJumpText.TextTransparency = 0
			infJumpText.TextStrokeTransparency = 0.5
			infAnimText.TextTransparency = 0
			infAnimText.TextStrokeTransparency = 0.5
			espText.TextTransparency = 0
			espText.TextStrokeTransparency = 0.5
		end)
	end)
end

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		movedDistance = 0
		dragStartPos = input.Position
		TweenService:Create(button, TweenInfo.new(0.1), {
			Size = UDim2.new(0, 62, 0, 62)
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
			Size = UDim2.new(0, 70, 0, 70)
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

print("✅ Noob Hack загружен! Клик по кнопке = open/close")
