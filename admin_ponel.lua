--[[
	Admin Panel for Roblox
	======================
	Простая админ-панель с Infinite Jump и кастомными текстурами.
	
	Установка:
		1. LocalScript в StarterPlayer > StarterPlayerScripts
		2. Вставить этот код
		3. Запустить игру
	
	Управление:
		- Клик по круглой кнопке → открыть панель
		- Кнопка ✕ → закрыть панель
		- Infinite Jump ON/OFF → включить бесконечный прыжок
		- Перетаскивание: зажать ЛКМ и двигать
	
	Автор: Твой Ник
	Лицензия: MIT
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================================
--  НАСТРОЙКИ (замени ID на свои)
-- ========================================================
local CONFIG = {
	BUTTON_IMAGE = "rbxassetid://6877509129",   -- фото круглой кнопки
	PANEL_IMAGE  = "rbxassetid://15262574528",  -- фон панели
	INFJUMP_IMG  = "rbxassetid://7192763523",   -- фон кнопки InfJump
	
	BUTTON_SIZE   = UDim2.new(0, 70, 0, 70),
	BUTTON_POS    = UDim2.new(0, 100, 0, 100),
	
	PANEL_SIZE    = UDim2.new(0, 400, 0, 300),
	PANEL_POS     = UDim2.new(0.5, -200, 0.5, -150),
	
	INFJUMP_SIZE  = UDim2.new(0, 180, 0, 55),
	
	COLOR_ACCENT  = Color3.fromRGB(90, 130, 255),
	COLOR_SUCCESS = Color3.fromRGB(60, 220, 120),
	COLOR_DANGER  = Color3.fromRGB(200, 50, 60),
}

-- ========================================================
--  ROOT GUI
-- ========================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ========================================================
--  КРУГЛАЯ КНОПКА
-- ========================================================
local button = Instance.new("TextButton")
button.Size = CONFIG.BUTTON_SIZE
button.Position = CONFIG.BUTTON_POS
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
buttonStroke.Color = CONFIG.COLOR_ACCENT
buttonStroke.Thickness = 3
buttonStroke.Parent = button

-- ========================================================
--  ПАНЕЛЬ
-- ========================================================
local panel = Instance.new("ImageLabel")
panel.Size = CONFIG.PANEL_SIZE
panel.Position = CONFIG.PANEL_POS
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
panelStroke.Color = CONFIG.COLOR_ACCENT
panelStroke.Thickness = 2
panelStroke.Parent = panel

-- ========================================================
--  КНОПКА ЗАКРЫТИЯ
-- ========================================================
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(0, 0, 0, 0)
closeBtn.BackgroundColor3 = CONFIG.COLOR_DANGER
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false
closeBtn.Visible = false
closeBtn.ZIndex = 5
closeBtn.Parent = screenGui

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

local function updateClosePos()
	closeBtn.Position = UDim2.new(
		panel.Position.X.Scale, panel.Position.X.Offset + panel.AbsoluteSize.X - 40,
		panel.Position.Y.Scale, panel.Position.Y.Offset + 8
	)
end

-- ========================================================
--  КНОПКА INFINITE JUMP
-- ========================================================
local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Size = CONFIG.INFJUMP_SIZE
infJumpBtn.Position = UDim2.new(0, 20, 0, 20)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
infJumpBtn.BorderSizePixel = 0
infJumpBtn.Text = ""
infJumpBtn.AutoButtonColor = false
infJumpBtn.Visible = false
infJumpBtn.ZIndex = 3
infJumpBtn.Parent = screenGui

local infJumpCorner = Instance.new("UICorner")
infJumpCorner.CornerRadius = UDim.new(0, 10)
infJumpCorner.Parent = infJumpBtn

local infJumpBg = Instance.new("ImageLabel")
infJumpBg.Size = UDim2.new(1, 0, 1, 0)
infJumpBg.BackgroundTransparency = 1
infJumpBg.Image = CONFIG.INFJUMP_IMG
infJumpBg.ScaleType = Enum.ScaleType.Crop
infJumpBg.ZIndex = 2
infJumpBg.Parent = infJumpBtn

local infJumpBgCorner = Instance.new("UICorner")
infJumpBgCorner.CornerRadius = UDim.new(0, 10)
infJumpBgCorner.Parent = infJumpBg

local infJumpOverlay = Instance.new("Frame")
infJumpOverlay.Size = UDim2.new(1, 0, 1, 0)
infJumpOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
infJumpOverlay.BackgroundTransparency = 0.4
infJumpOverlay.BorderSizePixel = 0
infJumpOverlay.ZIndex = 3
infJumpOverlay.Parent = infJumpBtn

local infJumpOverlayCorner = Instance.new("UICorner")
infJumpOverlayCorner.CornerRadius = UDim.new(0, 10)
infJumpOverlayCorner.Parent = infJumpOverlay

local infJumpText = Instance.new("TextLabel")
infJumpText.Size = UDim2.new(1, 0, 1, 0)
infJumpText.BackgroundTransparency = 1
infJumpText.Text = "Infinite Jump: OFF"
infJumpText.TextColor3 = Color3.fromRGB(255, 255, 255)
infJumpText.Font = Enum.Font.GothamBold
infJumpText.TextSize = 14
infJumpText.ZIndex = 5
infJumpText.Parent = infJumpBtn

local infJumpStroke = Instance.new("UIStroke")
infJumpStroke.Color = CONFIG.COLOR_ACCENT
infJumpStroke.Thickness = 2
infJumpStroke.Parent = infJumpBtn

-- ========================================================
--  ЛОГИКА INFINITE JUMP
-- ========================================================
local infJumpEnabled = false
local infJumpConn

local function toggleInfJump()
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
		infJumpStroke.Color = CONFIG.COLOR_SUCCESS
	else
		if infJumpConn then
			infJumpConn:Disconnect()
			infJumpConn = nil
		end
		infJumpText.Text = "Infinite Jump: OFF"
		infJumpStroke.Color = CONFIG.COLOR_ACCENT
	end
end

infJumpBtn.MouseButton1Click:Connect(toggleInfJump)

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
				infJumpBtn.Position = UDim2.new(
					panel.Position.X.Scale, panel.Position.X.Offset + 20,
					panel.Position.Y.Scale, panel.Position.Y.Offset + 60
				)
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
--  ОТКРЫТИЕ / ЗАКРЫТИЕ ПАНЕЛИ
-- ========================================================
local movedDistance = 0
local dragStartPos

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
			Size = CONFIG.BUTTON_SIZE
		}):Play()
	end
end)

button.MouseButton1Click:Connect(function()
	if movedDistance < 10 then
		panel.Visible = true
		closeBtn.Visible = true
		infJumpBtn.Visible = true
		
		updateClosePos()
		infJumpBtn.Position = UDim2.new(
			panel.Position.X.Scale, panel.Position.X.Offset + 20,
			panel.Position.Y.Scale, panel.Position.Y.Offset + 60
		)
		
		panel.Size = UDim2.new(0, 0, 0, 0)
		TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = CONFIG.PANEL_SIZE
		}):Play()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	local tween = TweenService:Create(panel, TweenInfo.new(0.2), {
		Size = UDim2.new(0, 0, 0, 0)
	})
	tween:Play()
	tween.Completed:Connect(function()
		panel.Visible = false
		closeBtn.Visible = false
		infJumpBtn.Visible = false
	end)
end)

print("✅ Admin Panel загружена! Нажми на круглую кнопку")
