RegisterCommand("review", function()
    local input = lib.inputDialog('Submit a Review', {
        { type = 'select', label = 'Rating', options = {
            { value = 1, label = '⭐' },
            { value = 2, label = '⭐⭐' },
            { value = 3, label = '⭐⭐⭐' },
            { value = 4, label = '⭐⭐⭐⭐' },
            { value = 5, label = '⭐⭐⭐⭐⭐' },
        }, required = true },
        { type = 'textarea', label = 'Your Review', placeholder = 'Write your feedback here...', required = true }
    })

    if not input then return end

    local stars = input[1]
    local review = input[2]

    TriggerServerEvent("review:submit", stars, review)
end)

RegisterNetEvent("review:thankyou", function()
    lib.notify({ title = 'Review System', description = Config.ThankYouMessage, type = 'success' })
end)