-- Replace "YOUR_DISCORD_WEBHOOK_URL_HERE" with your actual Discord webhook URL
local Webhook_URL = "https://discord.com/api/webhooks/1219018263682486292/wJtHMY9uhiOOkgzjrTPQW6pAdbMsOoXk6bprnLokXLXR5AOGaZf1gpxCMgSME-lPut35"

-- Function to send data to Discord webhook
local function sendToWebhook(data)
    local httpService = game:GetService("HttpService")
    local jsonData = httpService:JSONEncode(data)

    -- Send HTTP request to Discord webhook
    local success, response = pcall(function()
        return httpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    -- Check if the request was successful
    if success then
        print("Webhook sent successfully:", response)
    else
        warn("Failed to send webhook:", response)
    end
end

-- Function to get player's account age
local function getAccountAge(joinDate)
    local joinDateTime = joinDate:gsub("T", " "):gsub("-", "/"):gsub("Z", "")
    local joinTime = os.time({ year = tonumber(joinDateTime:sub(1,4)), month = tonumber(joinDateTime:sub(6,7)), day = tonumber(joinDateTime:sub(9,10)) })
    local currentTime = os.time()
    return os.difftime(currentTime, joinTime) / (60 * 60 * 24) -- Account age in days
end

-- Function to handle player execution
local function handleExecution(player)
    local mapName = game.Workspace.Name -- Get the name of the current map
    local playerName = player.Name -- Get the player's Roblox username
    local playerNickname = player.DisplayName -- Get the player's nickname (if set)
    local playerId = player.UserId -- Get the player's Roblox user ID
    local joinDate = player.AccountAge -- Get the player's join date
    local accountAge = getAccountAge(joinDate) -- Calculate the player's account age

    -- Construct data to send to webhook
    local data = {
        content = "Player Information:\n" ..
                  "Map Name: " .. mapName .. "\n" ..
                  "Username: " .. playerName .. "\n" ..
                  "Nickname: " .. (playerNickname or "N/A") .. "\n" ..
                  "User ID: " .. playerId .. "\n" ..
                  "Account Age (Days): " .. accountAge
    }

    -- Send data to Discord webhook
    sendToWebhook(data)
end

-- Connect the function to the PlayerAdded event to detect when a player joins the game
game.Players.PlayerAdded:Connect(handleExecution)
