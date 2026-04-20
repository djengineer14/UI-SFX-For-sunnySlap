-- ╔══════════════════════════════════════════════════════╗
-- ║              ElectricUI.lua                          ║
-- ║  LocalScript → place directly inside your Frame     ║
-- ╚══════════════════════════════════════════════════════╝

local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local frame     = script.Parent
local screenGui = frame:FindFirstAncestorOfClass("ScreenGui")

--------------------------------------------------------------------------------
--  CONFIGURATION — edit this block freely, no need to touch anything below
--------------------------------------------------------------------------------
local CFG = {
	-- Font
	Font              = Font.fromId(12187368843),

	-- Electric glow colours (flickers between A and B)
	GlowColorA        = Color3.fromRGB(0,   255,  70),   -- deep green
	GlowColorB        = Color3.fromRGB(100, 255, 180),   -- bright mint flash
	GlowThicknessMin  = 2,
	GlowThicknessMax  = 5,
	GlowFlickerHz     = 20,   -- how many times per second the stroke flickers

	-- Particles that fly off the electric edges
	ParticleImage     = "rbxassetid://3442350641",
	ParticleLifetime  = 0.05,  -- seconds (keep at 0.05 as requested)
	ParticleSize      = 8,     -- pixels
	ParticleSpeed     = 22,    -- pixels per second drift outward
	PerObjPerCycle    = 2,     -- particles spawned per glowing object per cycle
	SpawnHz           = 25,    -- spawn cycles per second
	PoolSize          = 100,   -- pre-created particle pool (avoids runtime alloc)

	-- Sounds
	ClickSoundId      = "rbxassetid://126578743933885",
	HoverSoundId      = "rbxassetid://139403951941162",
	SoundVolume       = 0.6,

	-- Hover button effect
	HoverScale        = 1.06,
	HoverTweenTime    = 0.10,

	-- Levitation + rotation
	LevitatePixels    = 6,
	LevitateSpeed     = 0.6,
	RotateDegrees     = 1.2,
	RotateSpeed       = 0.4,
}
--------------------------------------------------------------------------------

-- ─────────────────────────────────────────────────────────
--  SOUNDS
-- ─────────────────────────────────────────────────────────
local soundFolder = Instance.new("Folder")
soundFolder.Name   = "UISounds"
soundFolder.Parent = frame

local clickSound = Instance.new("Sound")
clickSound.SoundId = CFG.ClickSoundId
clickSound.Volume  = CFG.SoundVolume
clickSound.Parent  = soundFolder

local hoverSound = Instance.new("Sound")
hoverSound.SoundId = CFG.HoverSoundId
hoverSound.Volume  = CFG.SoundVolume
hoverSound.Parent  = soundFolder

-- ─────────────────────────────────────────────────────────
--  FONT — applied to all text objects now and in future
-- ─────────────────────────────────────────────────────────
local function applyFont(obj)
	if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
		obj.FontFace = CFG.Font
	end
end

applyFont(frame)
for _, d in ipairs(frame:GetDescendants()) do applyFont(d) end
frame.DescendantAdded:Connect(applyFont)

-- ─────────────────────────────────────────────────────────
--  GLOW REGISTRY — Frames & TextButtons only
-- ─────────────────────────────────────────────────────────
local glowObjects = {}  -- array of { obj = GuiObject, stroke = UIStroke }

local function addGlow(obj)
	if not (obj:IsA("Frame") or obj:IsA("TextButton")) then return end
	if obj:FindFirstChildOfClass("UIStroke") then return end

	local stroke = Instance.new("UIStroke")
	stroke.Color           = CFG.GlowColorA
	stroke.Thickness       = CFG.GlowThicknessMax
	stroke.Transparency    = 0.1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent          = obj

	table.insert(glowObjects, { obj = obj, stroke = stroke })
end

addGlow(frame)
for _, d in ipairs(frame:GetDescendants()) do addGlow(d) end
frame.DescendantAdded:Connect(addGlow)

-- ─────────────────────────────────────────────────────────
--  PARTICLE SYSTEM
--  Particles live in a full-screen overlay so they can fly
--  outside the bounds of individual frames without clipping.
-- ─────────────────────────────────────────────────────────
local particleContainer = Instance.new("Frame")
particleContainer.Name                 = "ElectricParticles"
particleContainer.Size                 = UDim2.fromScale(1, 1)
particleContainer.BackgroundTransparency = 1
particleContainer.ZIndex               = 100
particleContainer.ClipsDescendants     = false
particleContainer.Parent               = screenGui

-- Pre-create pool to avoid allocation every frame
local pool      = {}
local poolIndex = 0

for i = 1, CFG.PoolSize do
	local p = Instance.new("ImageLabel")
	p.Size               = UDim2.fromOffset(CFG.ParticleSize, CFG.ParticleSize)
	p.BackgroundTransparency = 1
	p.Image              = CFG.ParticleImage
	p.ImageTransparency  = 1
	p.ZIndex             = 101
	p.Visible            = false
	p.Parent             = particleContainer
	pool[i] = p
end

local function getParticle()
	poolIndex = (poolIndex % CFG.PoolSize) + 1
	return pool[poolIndex]
end

-- Returns a random point on any of the four edges plus the outward normal
local function randomBorderPoint(obj)
	local pos  = obj.AbsolutePosition
	local size = obj.AbsoluteSize
	local edge = math.random(1, 4)
	local t    = math.random()
	local x, y, nx, ny

	if edge == 1 then       -- top
		x, y   = pos.X + t * size.X, pos.Y
		nx, ny = 0, -1
	elseif edge == 2 then   -- bottom
		x, y   = pos.X + t * size.X, pos.Y + size.Y
		nx, ny = 0,  1
	elseif edge == 3 then   -- left
		x, y   = pos.X, pos.Y + t * size.Y
		nx, ny = -1, 0
	else                    -- right
		x, y   = pos.X + size.X, pos.Y + t * size.Y
		nx, ny =  1, 0
	end

	return x, y, nx, ny
end

local function spawnParticle(bx, by, nx, ny)
	local p    = getParticle()
	local half = CFG.ParticleSize / 2

	p.Position        = UDim2.fromOffset(bx - half, by - half)
	p.ImageTransparency = 0.05
	p.Rotation        = math.random(0, 360)
	p.Visible         = true

	local dist = CFG.ParticleSpeed * CFG.ParticleLifetime
	local jx   = math.random(-5, 5)
	local jy   = math.random(-5, 5)

	TweenService:Create(p, TweenInfo.new(CFG.ParticleLifetime, Enum.EasingStyle.Linear), {
		Position          = UDim2.fromOffset(bx + nx * dist + jx - half, by + ny * dist + jy - half),
		ImageTransparency = 1,
	}):Play()

	task.delay(CFG.ParticleLifetime, function()
		p.Visible = false
	end)
end

-- ─────────────────────────────────────────────────────────
--  HOVER + CLICK EFFECTS
-- ─────────────────────────────────────────────────────────
local function setupHover(btn)
	if not btn:IsA("TextButton") then return end

	-- Each button gets its own UIScale for hover zoom
	local uiScale = btn:FindFirstChildOfClass("UIScale")
	if not uiScale then
		uiScale        = Instance.new("UIScale")
		uiScale.Scale  = 1
		uiScale.Parent = btn
	end

	local hoverTI = TweenInfo.new(CFG.HoverTweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	btn.MouseEnter:Connect(function()
		hoverSound:Play()
		TweenService:Create(uiScale, hoverTI, { Scale = CFG.HoverScale }):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(uiScale, hoverTI, { Scale = 1 }):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		-- Tiny squish then spring back
		TweenService:Create(uiScale, TweenInfo.new(0.05, Enum.EasingStyle.Quad), { Scale = 0.94 }):Play()
		task.delay(0.05, function()
			TweenService:Create(uiScale, hoverTI, { Scale = 1 }):Play()
		end)
	end)
end

for _, d in ipairs(frame:GetDescendants()) do setupHover(d) end
frame.DescendantAdded:Connect(setupHover)

-- ─────────────────────────────────────────────────────────
--  MINIMIZE → toggles ButtonSection visibility only
-- ─────────────────────────────────────────────────────────
local buttonSection = frame:FindFirstChild("ButtonSection")
local minimize      = frame:FindFirstChild("Minimize")

if minimize and buttonSection then
	minimize.MouseButton1Click:Connect(function()
		buttonSection.Visible = not buttonSection.Visible
	end)
else
	if not minimize      then warn("[ElectricUI] 'Minimize' button not found inside frame") end
	if not buttonSection then warn("[ElectricUI] 'ButtonSection' not found inside frame") end
end

-- ─────────────────────────────────────────────────────────
--  DRAG — updates basePosition on release so levitation
--          resumes smoothly from the new resting position
-- ─────────────────────────────────────────────────────────
local basePosition = frame.Position
local baseRotation = frame.Rotation
local isDragging   = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or
		input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
		dragStart  = input.Position
		startPos   = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				isDragging   = false
				basePosition = UDim2.new(
					frame.Position.X.Scale,  frame.Position.X.Offset,
					frame.Position.Y.Scale,  frame.Position.Y.Offset
				)
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if isDragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement or
			input.UserInputType == Enum.UserInputType.Touch
		) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,  startPos.X.Offset + delta.X,
			startPos.Y.Scale,  startPos.Y.Offset + delta.Y
		)
	end
end)

-- ─────────────────────────────────────────────────────────
--  HEARTBEAT — electric flicker + particles + levitation
-- ─────────────────────────────────────────────────────────
local clock         = 0
local flickerTimer  = 0
local spawnTimer    = 0
local flickerInterval = 1 / CFG.GlowFlickerHz
local spawnInterval   = 1 / CFG.SpawnHz

RunService.Heartbeat:Connect(function(dt)
	clock        += dt
	flickerTimer += dt
	spawnTimer   += dt

	-- ── Electric stroke flicker ──────────────────────────
	if flickerTimer >= flickerInterval then
		flickerTimer = 0
		for _, entry in ipairs(glowObjects) do
			if entry.stroke and entry.stroke.Parent then
				local t = math.random()
				entry.stroke.Thickness    = CFG.GlowThicknessMin
					+ t * (CFG.GlowThicknessMax - CFG.GlowThicknessMin)
				entry.stroke.Transparency = math.random() * 0.45
				entry.stroke.Color        = (t > 0.65) and CFG.GlowColorB or CFG.GlowColorA
			end
		end
	end

	-- ── Particle spawning ────────────────────────────────
	if spawnTimer >= spawnInterval then
		spawnTimer = 0
		for _, entry in ipairs(glowObjects) do
			if entry.obj and entry.obj.Parent
				and entry.obj.Visible
				and entry.obj.AbsoluteSize.X > 0 then
				for _ = 1, CFG.PerObjPerCycle do
					local bx, by, nx, ny = randomBorderPoint(entry.obj)
					spawnParticle(bx, by, nx, ny)
				end
			end
		end
	end

	-- ── Levitate + rotate (skipped while dragging) ───────
	if not isDragging then
		local levitate = math.sin(clock * CFG.LevitateSpeed * math.pi * 2) * CFG.LevitatePixels
		local rotate   = math.sin(clock * CFG.RotateSpeed   * math.pi * 2) * CFG.RotateDegrees

		frame.Position = UDim2.new(
			basePosition.X.Scale,  basePosition.X.Offset,
			basePosition.Y.Scale,  basePosition.Y.Offset + levitate
		)
		frame.Rotation = baseRotation + rotate
	end
end)
