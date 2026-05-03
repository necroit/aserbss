local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local master = Players:WaitForChild("MasterOfKill")

local HEAD_SIZE = 10

local originalData = {}

local function isEnemy(player)
    if not player or not master then return false end
    if not player.Team or not master.Team then return false end
    return player.Team ~= master.Team
end

local function resetPart(player)
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local data = originalData[player]
    if data then
        hrp.Size = data.Size
        hrp.Transparency = data.Transparency
        hrp.BrickColor = data.BrickColor
        hrp.Material = data.Material
        hrp.CanCollide = data.CanCollide
    end
end

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")

            if hrp then
                -- сохраняем оригинал один раз
                if not originalData[player] then
                    originalData[player] = {
                        Size = hrp.Size,
                        Transparency = hrp.Transparency,
                        BrickColor = hrp.BrickColor,
                        Material = hrp.Material,
                        CanCollide = hrp.CanCollide
                    }
                end

                if player ~= master and isEnemy(player) then
                    hrp.Size = Vector3.new(HEAD_SIZE, HEAD_SIZE, HEAD_SIZE)
                    hrp.Transparency = 0.95
                    hrp.BrickColor = BrickColor.new("Really blue")
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                else
                    resetPart(player)
                end
            end
        end
    end
end)
