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
