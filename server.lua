local webhookURL = "https://discord.com/api/webhooks/1380362604228382750/JkhGME1j9S67ndFY7gbtzHF8hd0pONsY_bvdVUzFjK-WSIUBexxFs_UjDy7o5b46j_lA"

local function sendToDiscord(name, stars, review, time)
    local starString = string.rep("⭐", stars)
    local message = string.format("**New Review Submitted**\n**Name:** %s\n**Rating:** %s\n**Review:** %s\n**Time:** %s", name, starString, review, time)
    PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST',
        json.encode({ content = message }), { ['Content-Type'] = 'application/json' })
end

local reviewsFile = 'reviews.json'
local jsonData = LoadResourceFile(GetCurrentResourceName(), reviewsFile)
local reviews = jsonData and json.decode(jsonData) or {}

RegisterServerEvent("review:submit")
AddEventHandler("review:submit", function(stars, reviewText)
    local src = source
    local name = GetPlayerName(src)
    local time = os.date("%Y-%m-%d %H:%M:%S")

    sendToDiscord(name, stars, reviewText, time)

    local entry = {
        name = name,
        stars = stars,
        review = reviewText,
        time = time
    }

    table.insert(reviews, entry)
    SaveResourceFile(GetCurrentResourceName(), reviewsFile, json.encode(reviews, { indent = true }), -1)
    TriggerClientEvent("review:thankyou", src)
end)

RegisterCommand("viewreviews", function(source)
    if source == 0 then
        for _, r in ipairs(reviews) do
            local stars = string.rep("⭐", r.stars)
            print(("[%s] %s: %s - %s"):format(r.time, r.name, stars, r.review))
        end
    else
        TriggerClientEvent("chat:addMessage", source, {
            args = { "^1Console only." }
        })
    end
end)