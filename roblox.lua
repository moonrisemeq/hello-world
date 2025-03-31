local Players = game:GetService("Players")  -- Players servisini alıyoruz

-- Oyuncuyu vurgulamak için fonksiyon
local function highlightPlayer(player)
    -- Karakterinin olmasını bekliyoruz
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Eğer karakter yoksa fonksiyonu sonlandırıyoruz
    if not character then
        return
    end

    -- Highlight nesnesi oluşturuyoruz
    local highlight = Instance.new("Highlight")
    highlight.Parent = character  -- Highlight'ı karakterin altına yerleştiriyoruz

    -- Highlight renklerini ayarlıyoruz
    highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Kırmızı iç renk
    highlight.OutlineColor = Color3.fromRGB(0, 0, 255)  -- Mavi dış hat renk

    -- Highlight'ın şeffaflık oranını ayarlıyoruz (isteğe bağlı)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.5

    -- Ekstra: Highlight sadece oyuncu görünürken aktif olsun
    character:WaitForChild("HumanoidRootPart") -- Karakterin RootPart'ı gelene kadar bekliyoruz
    highlight.Adornee = character  -- Highlight'ı karakterin üzerine bağlıyoruz
end

-- Bütün oyunculara vurguyu ekliyoruz
local function highlightAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        highlightPlayer(player)  -- Her bir oyuncu için highlight fonksiyonunu çağırıyoruz
    end
end

-- Oyuncular karakterlerini oluşturduğunda vurguyu ekliyoruz
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        highlightPlayer(player)
    end)
end)

-- Tüm oyuncuları başlangıçta vurgulamak için
highlightAllPlayers()

-- Eğer bir oyuncu çıkarsa, Highlight'ı kaldırmak için
Players.PlayerRemoving:Connect(function(player)
    local character = player.Character
    if character then
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Highlight") then
                child:Destroy()  -- Highlight'ı siliyoruz
            end
        end
    end
end)
local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local isAiming = false -- Track if the player is holding Z
local closestTarget = nil
local defaultCameraPosition = camera.CFrame -- Store the default camera position

-- Function to find the closest target (exclude teammates)
local function findClosestTarget()
    local closestDistance = math.huge
    local targetPlayer = nil

    -- Loop through all players and find the closest target (exclude teammates)
    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character then
            -- Exclude teammates
            if target.Team ~= player.Team then
                local targetRootPart = target.Character:FindFirstChild("HumanoidRootPart")
                if targetRootPart then
                    local distance = (targetRootPart.Position - camera.CFrame.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        targetPlayer = target
                    end
                end
            end
        end
    end
    return targetPlayer
end

-- Function to aim at the target
local function aimAtTarget(target)
    if target and target.Character then
        local targetRootPart = target.Character:FindFirstChild("HumanoidRootPart")
        if targetRootPart then
            local direction = (targetRootPart.Position - camera.CFrame.Position).unit
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetRootPart.Position)
        end
    end
end

-- Detect when the Z key is pressed and held
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    -- Ensure the input is not processed by other UI elements
    if gameProcessed then return end

    -- Check if the Z key is pressed (start aiming)
    if input.KeyCode == Enum.KeyCode.Z then
        isAiming = true
    end
end)

-- Detect when the Z key is released (stop aiming)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    -- Check if the Z key is released
    if input.KeyCode == Enum.KeyCode.Z then
        isAiming = false
    end
end)

-- Continuously update the target while Z is held down
game:GetService("RunService").Heartbeat:Connect(function()
    if isAiming then
        -- Find the closest target when aiming
        closestTarget = findClosestTarget()
        if closestTarget then
            aimAtTarget(closestTarget) -- Lock the camera to the target
        end
    else
        -- Detach the camera when Z is not held down (stop aiming)
        if closestTarget then
            -- Reset the camera to its default position when Z is released
            camera.CFrame = defaultCameraPosition
            closestTarget = nil -- Clear the target
        end
    end
end)
