local Players = game:GetService("Players")  -- Players servisini alıyoruz

-- Highlight işlemi, her oyuncu için yapılacak
local function highlightPlayer(player)
    -- Eğer oyuncunun karakteri yoksa, bekliyoruz
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Eğer karakter yoksa, fonksiyonu sonlandırıyoruz
    if not character then
        return
    end

    -- Highlight nesnesini oluşturuyoruz
    local highlight = Instance.new("Highlight")
    highlight.Parent = character  -- Highlight'ı karakterin altına yerleştiriyoruz

    -- Renk ayarlarını yapıyoruz
    highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Kırmızı iç renk
    highlight.OutlineColor = Color3.fromRGB(0, 0, 255)  -- Mavi dış hat renk

    -- Şeffaflık ayarları (isteğe bağlı)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.5
    
    -- Highlight'ı karaktere bağlayalım
    highlight.Adornee = character
end

-- Bir oyuncunun karakterini takip etmek için fonksiyon
local function trackPlayer(player)
    -- Ekranda gösterecek bir UI elemanı oluşturuyoruz
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")  -- Oyuncunun PlayerGui'sine ekliyoruz

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 50)  -- Boyut
    label.Position = UDim2.new(0.5, -100, 0.1, 0)  -- Ekranın üst kısmında ortalanmış
    label.Text = "Takip Ediliyor: " .. player.Name  -- Oyuncu ismini gösteriyoruz
    label.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Arka planı yeşil yapıyoruz
    label.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Yazı rengi beyaz
    label.Parent = screenGui
end

-- Tüm oyuncuları vurgulayıp izlemeye başlamak
local function highlightAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        highlightPlayer(player)  -- Her oyuncu için highlight ekliyoruz
        trackPlayer(player)  -- Her oyuncu için izleme UI ekliyoruz
    end
end

-- Yeni bir oyuncu eklenirse
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        highlightPlayer(player)  -- Yeni oyuncuya highlight ekliyoruz
        trackPlayer(player)  -- Yeni oyuncu için izleme ekliyoruz
    end)
end)

-- Oyun başladığında tüm oyuncuları vurgulayıp izlemeye başlıyoruz
highlightAllPlayers()

-- Oyuncu oyundan ayrıldığında, highlight ve izlemeyi kaldırmak
Players.PlayerRemoving:Connect(function(player)
    local character = player.Character
    if character then
        -- Highlight'ı yok ediyoruz
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Highlight") then
                child:Destroy()
            end
        end
    end
end)

