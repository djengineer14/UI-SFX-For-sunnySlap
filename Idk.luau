print("🔘 Remote Hijacker button clicked!")

	-- Advanced Remote Scanner for Xeno (with arguments & player targeting)
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	-- Check if already exists
	local existing = playerGui:FindFirstChild("RemoteScanner")
	if existing then
		existing.Enabled = not existing.Enabled
		return
	end

	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "RemoteScanner"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Main Frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 450, 0, 550)
	mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = mainFrame

	-- Header
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 40)
	header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	header.BorderSizePixel = 0
	header.Parent = mainFrame

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 8)
	headerCorner.Parent = header

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -50, 1, 0)
	title.BackgroundTransparency = 1
	title.Text = "🔧 Remote Hijacker"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 15)
	padding.Parent = title

	-- Close Button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 40, 0, 40)
	closeBtn.Position = UDim2.new(1, -40, 0, 0)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
	closeBtn.TextSize = 20
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = header

	closeBtn.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)

	-- Scan Button
	local scanBtn = Instance.new("TextButton")
	scanBtn.Size = UDim2.new(0.48, -5, 0, 35)
	scanBtn.Position = UDim2.new(0, 10, 0, 50)
	scanBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	scanBtn.Text = "🔍 Scan"
	scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	scanBtn.TextSize = 14
	scanBtn.Font = Enum.Font.GothamBold
	scanBtn.BorderSizePixel = 0
	scanBtn.Parent = mainFrame

	local scanCorner = Instance.new("UICorner")
	scanCorner.CornerRadius = UDim.new(0, 6)
	scanCorner.Parent = scanBtn

	-- Copy All Button
	local copyAllBtn = Instance.new("TextButton")
	copyAllBtn.Size = UDim2.new(0.48, -5, 0, 35)
	copyAllBtn.Position = UDim2.new(0.52, 5, 0, 50)
	copyAllBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
	copyAllBtn.Text = "📋 Copy All"
	copyAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	copyAllBtn.TextSize = 14
	copyAllBtn.Font = Enum.Font.GothamBold
	copyAllBtn.BorderSizePixel = 0
	copyAllBtn.Parent = mainFrame

	local copyAllCorner = Instance.new("UICorner")
	copyAllCorner.CornerRadius = UDim.new(0, 6)
	copyAllCorner.Parent = copyAllBtn

	-- Argument Input Section
	local argLabel = Instance.new("TextLabel")
	argLabel.Size = UDim2.new(1, -20, 0, 15)
	argLabel.Position = UDim2.new(0, 10, 0, 95)
	argLabel.BackgroundTransparency = 1
	argLabel.Text = "Arguments (comma-separated, e.g: 'hello', 123, true)"
	argLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	argLabel.TextSize = 10
	argLabel.Font = Enum.Font.Gotham
	argLabel.TextXAlignment = Enum.TextXAlignment.Left
	argLabel.Parent = mainFrame

	local argInput = Instance.new("TextBox")
	argInput.Size = UDim2.new(1, -20, 0, 30)
	argInput.Position = UDim2.new(0, 10, 0, 112)
	argInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	argInput.Text = ""
	argInput.PlaceholderText = "Enter arguments here..."
	argInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	argInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
	argInput.TextSize = 12
	argInput.Font = Enum.Font.Gotham
	argInput.ClearTextOnFocus = false
	argInput.BorderSizePixel = 0
	argInput.Parent = mainFrame

	local argCorner = Instance.new("UICorner")
	argCorner.CornerRadius = UDim.new(0, 6)
	argCorner.Parent = argInput

	local argPadding = Instance.new("UIPadding")
	argPadding.PaddingLeft = UDim.new(0, 8)
	argPadding.Parent = argInput

	-- Target Player Section
	local targetLabel = Instance.new("TextLabel")
	targetLabel.Size = UDim2.new(0.5, -15, 0, 15)
	targetLabel.Position = UDim2.new(0, 10, 0, 150)
	targetLabel.BackgroundTransparency = 1
	targetLabel.Text = "Target Player (optional)"
	targetLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	targetLabel.TextSize = 10
	targetLabel.Font = Enum.Font.Gotham
	targetLabel.TextXAlignment = Enum.TextXAlignment.Left
	targetLabel.Parent = mainFrame

	-- Player Dropdown
	local playerDropdown = Instance.new("TextButton")
	playerDropdown.Size = UDim2.new(0.5, -15, 0, 30)
	playerDropdown.Position = UDim2.new(0, 10, 0, 167)
	playerDropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	playerDropdown.Text = "None (All)"
	playerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
	playerDropdown.TextSize = 12
	playerDropdown.Font = Enum.Font.Gotham
	playerDropdown.BorderSizePixel = 0
	playerDropdown.Parent = mainFrame

	local dropCorner = Instance.new("UICorner")
	dropCorner.CornerRadius = UDim.new(0, 6)
	dropCorner.Parent = playerDropdown

	-- Dropdown menu
	local dropdownMenu = Instance.new("Frame")
	dropdownMenu.Size = UDim2.new(0.5, -15, 0, 150)
	dropdownMenu.Position = UDim2.new(0, 10, 0, 200)
	dropdownMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	dropdownMenu.BorderSizePixel = 0
	dropdownMenu.Visible = false
	dropdownMenu.ZIndex = 10
	dropdownMenu.Parent = mainFrame

	local dropMenuCorner = Instance.new("UICorner")
	dropMenuCorner.CornerRadius = UDim.new(0, 6)
	dropMenuCorner.Parent = dropdownMenu

	local dropScroll = Instance.new("ScrollingFrame")
	dropScroll.Size = UDim2.new(1, 0, 1, 0)
	dropScroll.BackgroundTransparency = 1
	dropScroll.ScrollBarThickness = 4
	dropScroll.Parent = dropdownMenu

	local dropLayout = Instance.new("UIListLayout")
	dropLayout.Parent = dropScroll

	local selectedPlayer = nil

	-- Update player list
	local function updatePlayerList()
		for _, child in pairs(dropScroll:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		-- Add "None" option
		local noneBtn = Instance.new("TextButton")
		noneBtn.Size = UDim2.new(1, 0, 0, 30)
		noneBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		noneBtn.Text = "None (All Players)"
		noneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		noneBtn.TextSize = 11
		noneBtn.Font = Enum.Font.Gotham
		noneBtn.BorderSizePixel = 0
		noneBtn.Parent = dropScroll

		noneBtn.MouseButton1Click:Connect(function()
			selectedPlayer = nil
			playerDropdown.Text = "None (All)"
			dropdownMenu.Visible = false
		end)

		-- Add all players
		for _, plr in pairs(Players:GetPlayers()) do
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
			btn.Text = plr.Name
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextSize = 11
			btn.Font = Enum.Font.Gotham
			btn.BorderSizePixel = 0
			btn.Parent = dropScroll

			btn.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				playerDropdown.Text = plr.Name
				dropdownMenu.Visible = false
			end)
		end

		dropScroll.CanvasSize = UDim2.new(0, 0, 0, dropLayout.AbsoluteContentSize.Y)
	end

	playerDropdown.MouseButton1Click:Connect(function()
		dropdownMenu.Visible = not dropdownMenu.Visible
		if dropdownMenu.Visible then
			updatePlayerList()
		end
	end)

	-- Results Label
	local resultsLabel = Instance.new("TextLabel")
	resultsLabel.Size = UDim2.new(1, -20, 0, 20)
	resultsLabel.Position = UDim2.new(0, 10, 0, 205)
	resultsLabel.BackgroundTransparency = 1
	resultsLabel.Text = "Click scan to find remotes..."
	resultsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	resultsLabel.TextSize = 12
	resultsLabel.Font = Enum.Font.Gotham
	resultsLabel.TextXAlignment = Enum.TextXAlignment.Left
	resultsLabel.Parent = mainFrame

	-- Scrolling Frame
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -20, 1, -240)
	scrollFrame.Position = UDim2.new(0, 10, 0, 230)
	scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.Parent = mainFrame

	local scrollCorner = Instance.new("UICorner")
	scrollCorner.CornerRadius = UDim.new(0, 6)
	scrollCorner.Parent = scrollFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = scrollFrame

	local listPadding = Instance.new("UIPadding")
	listPadding.PaddingTop = UDim.new(0, 5)
	listPadding.PaddingLeft = UDim.new(0, 5)
	listPadding.PaddingRight = UDim.new(0, 5)
	listPadding.PaddingBottom = UDim.new(0, 5)
	listPadding.Parent = scrollFrame

	-- Store found remotes
	local foundRemotes = {}

	-- Parse arguments from text
	local function parseArguments(text)
		if text == "" then return {} end

		local args = {}
		local current = ""
		local inString = false
		local stringChar = nil

		for i = 1, #text do
			local char = text:sub(i, i)

			if char == '"' or char == "'" then
				if not inString then
					inString = true
					stringChar = char
				elseif char == stringChar then
					inString = false
					table.insert(args, current)
					current = ""
					stringChar = nil
				else
					current = current .. char
				end
			elseif char == "," and not inString then
				if current ~= "" then
					-- Try to convert to number or boolean
					local trimmed = current:match("^%s*(.-)%s*$")
					if trimmed == "true" then
						table.insert(args, true)
					elseif trimmed == "false" then
						table.insert(args, false)
					elseif tonumber(trimmed) then
						table.insert(args, tonumber(trimmed))
					else
						table.insert(args, trimmed)
					end
					current = ""
				end
			else
				if not (char == " " and current == "" and not inString) then
					current = current .. char
				end
			end
		end

		-- Add last argument
		if current ~= "" then
			local trimmed = current:match("^%s*(.-)%s*$")
			if trimmed == "true" then
				table.insert(args, true)
			elseif trimmed == "false" then
				table.insert(args, false)
			elseif tonumber(trimmed) then
				table.insert(args, tonumber(trimmed))
			else
				table.insert(args, trimmed)
			end
		end

		return args
	end

	-- Function to create remote entry
	local function createRemoteEntry(remotePath, remoteType, remoteInstance)
		local entry = Instance.new("Frame")
		entry.Size = UDim2.new(1, -10, 0, 85)
		entry.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		entry.BorderSizePixel = 0
		entry.Parent = scrollFrame

		local entryCorner = Instance.new("UICorner")
		entryCorner.CornerRadius = UDim.new(0, 6)
		entryCorner.Parent = entry

		-- Type Label
		local typeLabel = Instance.new("TextLabel")
		typeLabel.Size = UDim2.new(0, 120, 0, 20)
		typeLabel.Position = UDim2.new(0, 8, 0, 5)
		typeLabel.BackgroundTransparency = 1
		typeLabel.Text = remoteType
		typeLabel.TextColor3 = remoteType == "RemoteEvent" and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(255, 200, 100)
		typeLabel.TextSize = 11
		typeLabel.Font = Enum.Font.GothamBold
		typeLabel.TextXAlignment = Enum.TextXAlignment.Left
		typeLabel.Parent = entry

		-- Path Label
		local pathLabel = Instance.new("TextLabel")
		pathLabel.Size = UDim2.new(1, -16, 0, 35)
		pathLabel.Position = UDim2.new(0, 8, 0, 22)
		pathLabel.BackgroundTransparency = 1
		pathLabel.Text = remotePath
		pathLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		pathLabel.TextSize = 10
		pathLabel.Font = Enum.Font.Gotham
		pathLabel.TextXAlignment = Enum.TextXAlignment.Left
		pathLabel.TextWrapped = true
		pathLabel.TextTruncate = Enum.TextTruncate.AtEnd
		pathLabel.Parent = entry

		-- Copy Button
		local copyBtn = Instance.new("TextButton")
		copyBtn.Size = UDim2.new(0, 60, 0, 20)
		copyBtn.Position = UDim2.new(0, 8, 1, -25)
		copyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
		copyBtn.Text = "Copy"
		copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		copyBtn.TextSize = 10
		copyBtn.Font = Enum.Font.GothamBold
		copyBtn.BorderSizePixel = 0
		copyBtn.Parent = entry

		local copyCorner = Instance.new("UICorner")
		copyCorner.CornerRadius = UDim.new(0, 4)
		copyCorner.Parent = copyBtn

		copyBtn.MouseButton1Click:Connect(function()
			setclipboard(remotePath)
			copyBtn.Text = "✓ Copied"
			copyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
			task.wait(1)
			copyBtn.Text = "Copy"
			copyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
		end)

		-- Fire Button (RemoteEvents only)
		if remoteType == "RemoteEvent" then
			local fireBtn = Instance.new("TextButton")
			fireBtn.Size = UDim2.new(0, 100, 0, 20)
			fireBtn.Position = UDim2.new(0, 75, 1, -25)
			fireBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
			fireBtn.Text = "🔥 Fire Remote"
			fireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			fireBtn.TextSize = 10
			fireBtn.Font = Enum.Font.GothamBold
			fireBtn.BorderSizePixel = 0
			fireBtn.Parent = entry

			local fireCorner = Instance.new("UICorner")
			fireCorner.CornerRadius = UDim.new(0, 4)
			fireCorner.Parent = fireBtn

			fireBtn.MouseButton1Click:Connect(function()
				local success, err = pcall(function()
					local args = parseArguments(argInput.Text)

					-- If a player is selected, add them to arguments
					if selectedPlayer then
						table.insert(args, 1, selectedPlayer)
						print("🎯 Targeting player:", selectedPlayer.Name)
					end

					print("🔥 Firing remote:", remotePath)
					print("📦 Arguments:", table.unpack(args))

					remoteInstance:FireServer(table.unpack(args))

					fireBtn.Text = "✓ Fired!"
					fireBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
					task.wait(1)
					fireBtn.Text = "🔥 Fire Remote"
					fireBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
				end)

				if not success then
					warn("❌ Fire failed:", err)
					fireBtn.Text = "❌ Failed"
					task.wait(1)
					fireBtn.Text = "🔥 Fire Remote"
				end
			end)
		end

		-- Invoke Button (RemoteFunctions only)
		if remoteType == "RemoteFunction" then
			local invokeBtn = Instance.new("TextButton")
			invokeBtn.Size = UDim2.new(0, 100, 0, 20)
			invokeBtn.Position = UDim2.new(0, 75, 1, -25)
			invokeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
			invokeBtn.Text = "📞 Invoke"
			invokeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			invokeBtn.TextSize = 10
			invokeBtn.Font = Enum.Font.GothamBold
			invokeBtn.BorderSizePixel = 0
			invokeBtn.Parent = entry

			local invokeCorner = Instance.new("UICorner")
			invokeCorner.CornerRadius = UDim.new(0, 4)
			invokeCorner.Parent = invokeBtn

			invokeBtn.MouseButton1Click:Connect(function()
				local success, result = pcall(function()
					local args = parseArguments(argInput.Text)

					if selectedPlayer then
						table.insert(args, 1, selectedPlayer)
					end

					return remoteInstance:InvokeServer(table.unpack(args))
				end)

				if success then
					print("✓ Invoke result:", result)
					invokeBtn.Text = "✓ Done"
					invokeBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
					task.wait(1)
					invokeBtn.Text = "📞 Invoke"
					invokeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
				else
					warn("❌ Invoke failed:", result)
					invokeBtn.Text = "❌ Failed"
					task.wait(1)
					invokeBtn.Text = "📞 Invoke"
				end
			end)
		end
	end

	-- Scan Function
	local function scanRemotes()
		-- Clear existing entries
		for _, child in pairs(scrollFrame:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end

		foundRemotes = {}
		resultsLabel.Text = "🔍 Scanning..."
		local count = 0

		-- Scan ReplicatedStorage
		for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
			if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
				local path = remote:GetFullName()
				createRemoteEntry(path, remote.ClassName, remote)
				table.insert(foundRemotes, {path = path, type = remote.ClassName})
				count = count + 1
			end
		end

		-- Scan Workspace
		for _, remote in pairs(workspace:GetDescendants()) do
			if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
				local path = remote:GetFullName()
				createRemoteEntry(path, remote.ClassName, remote)
				table.insert(foundRemotes, {path = path, type = remote.ClassName})
				count = count + 1
			end
		end

		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
		resultsLabel.Text = string.format("✅ Found %d remotes", count)

		print("✓ Scan complete! Found", count, "remotes")
	end

	-- Copy All Function
	local function copyAllRemotes()
		if #foundRemotes == 0 then
			resultsLabel.Text = "⚠️ Scan first before copying!"
			task.wait(2)
			resultsLabel.Text = "Click scan to find remotes..."
			return
		end

		local output = "=== REMOTE EVENTS & FUNCTIONS ===\n\n"

		-- Separate by type
		local events = {}
		local functions = {}

		for _, remote in ipairs(foundRemotes) do
			if remote.type == "RemoteEvent" then
				table.insert(events, remote.path)
			else
				table.insert(functions, remote.path)
			end
		end

		-- Format output
		if #events > 0 then
			output = output .. "REMOTE EVENTS (" .. #events .. "):\n"
			for _, path in ipairs(events) do
				output = output .. path .. "\n"
			end
			output = output .. "\n"
		end

		if #functions > 0 then
			output = output .. "REMOTE FUNCTIONS (" .. #functions .. "):\n"
			for _, path in ipairs(functions) do
				output = output .. path .. "\n"
			end
		end

		output = output .. "\n=== Total: " .. #foundRemotes .. " remotes ==="

		setclipboard(output)

		copyAllBtn.Text = "✓ Copied All!"
		copyAllBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		resultsLabel.Text = string.format("✓ Copied %d remotes to clipboard!", #foundRemotes)

		task.wait(2)
		copyAllBtn.Text = "📋 Copy All"
		copyAllBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
		resultsLabel.Text = string.format("Found %d remotes", #foundRemotes)
	end

	scanBtn.MouseButton1Click:Connect(scanRemotes)
	copyAllBtn.MouseButton1Click:Connect(copyAllRemotes)

	print("✓ Remote Hijacker loaded!")
	print("💡 Enter arguments like: 'text', 123, true")
	print("💡 Select a player to target them specifically")
