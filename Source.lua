-- version 0.1.0
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService('UserInputService')
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Library = {
	Colors = {
		Background = {
			base = Color3.fromRGB(30, 30, 30),
			main = Color3.fromRGB(35, 35, 35),
		}
	}
}

type WindowArgs = {
	title: string,
	description: string,
	serverCode: string,
	supportLabel: string?,
	onStartup: () -> boolean,
	onCheck: (key: string) -> boolean,
	onCopy: () -> any,
}

local dragger = {};
local mouse = Players.LocalPlayer:GetMouse();
local heartbeat = RunService.Heartbeat;
-- credits to Ririchi / Inori
function dragger.new(frame)
	local s, event = pcall(function()
		return frame.MouseEnter
	end)

	if s then
		frame.Active = true;

		event:connect(function()
			local input = frame.InputBegan:connect(function(key)
				if key.UserInputType == Enum.UserInputType.MouseButton1 then
					local objectPosition = Vector2.new(mouse.X - frame.AbsolutePosition.X, mouse.Y - frame.AbsolutePosition.Y);
					while heartbeat:wait() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						pcall(function()
							frame:TweenPosition(UDim2.new(0, mouse.X - objectPosition.X, 0, mouse.Y - objectPosition.Y), 'Out', 'Linear', 0.05, true);
						end)
					end
				end
			end)

			local leave;
			leave = frame.MouseLeave:connect(function()
				input:disconnect();
				leave:disconnect();
			end)
		end)
	end
end

function Library:new(className: string, args: table)
	local temp = Instance.new(className)

	for name, v in pairs(args) do
		if name ~= "Parent" then
			if typeof(v) == "Instance" then
				v.Parent = temp
			else
				temp[name] = v
			end
		end
	end

	temp.Parent = args.Parent

	return temp
end

function Library:CreateWindow(args: WindowArgs)
	if args and args.onStartup then
		if not args.onStartup() then return end
	end

	local ScreenGui = self:new("ScreenGui", {Parent = CoreGui})
	local Frame = self:new("Frame", {
		self:new("UICorner", {
			CornerRadius = UDim.new(0, 6)
		}),

		Parent = ScreenGui,
		BackgroundColor3 = self.Colors.Background.base,
		Position = UDim2.new(0.5, -157, 0.5, -117),
		Size = UDim2.new(0, 315, 0, 235),
	})

	dragger.new(Frame)

	local Top = self:new("Frame", {
		self:new("UICorner", {
			CornerRadius = UDim.new(0, 6)
		});

		Parent = Frame,
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = self.Colors.Background.main,
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(1, 0, 0.15, 0),
	})

	self:new("TextLabel", {
		Parent = Top,
		Text = args and args.title or "Base",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.GothamBold,
		TextColor3 = Color3.fromRGB(245, 245, 245),
		TextSize = 18,
	})

	local Content = self:new("Frame", {
		Parent = Frame,
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0.85, 0),
	})

	self:new("TextLabel", {
		Parent = Content,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(.5, 0),
		Position = UDim2.new(.5, 0, 0, 0),
		Size = UDim2.new(.9, 0, 0.35, 0),
		Font = Enum.Font.GothamMedium,
		Text = args and args.description or "Description",
		TextColor3 = Color3.fromRGB(215, 215, 215),
		TextSize = 14,
		TextWrapped = true,
	})

	local Field = self:new("Frame", {
		Parent = Content,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0.35, 0),
		Size = UDim2.new(1, 0, 0.25, 0),
	})

	local Enter = self:new("TextBox", {
		self:new("UICorner", {
			CornerRadius = UDim.new(0, 3)
		});

		Parent = Field,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = self.Colors.Background.main,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0.95, 0, 0.85, 0),
		Font = Enum.Font.GothamMedium,
		PlaceholderText = "Paste your key...",
		Text = "",
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextSize = 14,
	})

	local Actions = self:new("Frame", {
		Parent = Content,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0.6, 0),
		Size = UDim2.new(1, 0, 0.2, 0),
	})

	local Check = self:new("TextButton", {
		self:new("UICorner", {
			CornerRadius = UDim.new(0, 3)
		}),

		TextColor3 = Color3.fromRGB(235, 235, 235),
		Font = Enum.Font.GothamMedium,
		Parent = Actions,
		BackgroundColor3 = self.Colors.Background.main,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0.025, 0, 0.5, 0),
		Size = UDim2.new(0.465, 0, 0.9, 0),
		Text = "Check Key",
		TextSize = 14,
	})

	local Copy = self:new("TextButton", {
		self:new("UICorner", {
			CornerRadius = UDim.new(0, 3)
		}),

		TextColor3 = Color3.fromRGB(235, 235, 235),
		Font = Enum.Font.GothamMedium,
		Parent = Actions,
		BackgroundColor3 = self.Colors.Background.main,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0.515, 0, 0.5, 0),
		Size = UDim2.new(0.465, 0, 0.9, 0),
		Text = "Copy Key Link",
		TextSize = 14,
	})

	local Discord = self:new("Frame", {
		Parent = Content,
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0.2, 0),
	})

	local Invite = self:new("TextButton", {
		self:new("UICorner", {
			CornerRadius = UDim.new(0, 3)
		}),

		TextColor3 = Color3.fromRGB(235, 235, 235),
		Font = Enum.Font.GothamMedium,
		Parent = Discord,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(114, 137, 218),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0.95, 0, 0.75, 0),
		Text = args and "discord.gg/" .. args.serverCode or "discord.gg",
		TextSize = 14,
	})

	if args.supportLabel then
		self:new("TextLabel", {
			Parent = Discord,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1.15, 0),
			Size = UDim2.new(1, 0, 0.35, 0),
			Font = Enum.Font.GothamBold,
			Text = args.supportLabel,
			TextColor3 = Color3.fromRGB(195, 195, 195),
			TextScaled = true,
			TextWrapped = true,
		})
	end

	local function onCheck()
		if args and args.onCheck then
			if args.onCheck(Enter.Text) then
				Check.Text = "Correct"
				Check.TextColor3 = Color3.fromRGB(0, 235, 0)

				task.delay(.1, function()
					ScreenGui:Destroy()
				end)
			else
				Check.Text = "Incorrect"
				Check.TextColor3 = Color3.fromRGB(235, 0, 0)

				task.delay(1, function()
					Check.Text = "Check Again"
					Check.TextColor3 = Color3.fromRGB(235, 235, 235)
				end)
			end
		end
	end

	local function onCopy()
		if args and args.onCopy then
			args.onCopy()

			Copy.Text = "Copied"
			Copy.TextColor3 = Color3.fromRGB(0, 235, 0)

			task.delay(1, function()
				Copy.TextColor3 = Color3.fromRGB(235, 235, 235)
				Copy.Text = "Copy Link Again"
			end)
		end
	end

	Check.MouseButton1Click:Connect(onCheck)
	Copy.MouseButton1Click:Connect(onCopy)

	Invite.MouseButton1Click:Connect(function()
		if setclipboard then setclipboard(args.serverCode) end

		if request then
			request({
				Url = 'http://127.0.0.1:6463/rpc?v=1',
				Method = 'POST',
				Headers = {
					['Content-Type'] = 'application/json',
					Origin = 'https://discord.com'
				},
				Body = HttpService:JSONEncode({
					cmd = 'INVITE_BROWSER',
					nonce = HttpService:GenerateGUID(false),
					args = {code = args.serverCode}
				})
			})
		end
	end)
end

return Library
