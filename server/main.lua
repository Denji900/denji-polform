local QBCore = exports['qb-core']:GetCoreObject()
local webhook = GetConvar('police_app_webhook', 'not_set')
local playersInZone = {}

local function DebugLog(message)
    if Config.Debug then
        print("^3[denji-polform]^7: " .. tostring(message))
    end
end

if webhook == 'not_set' or webhook == '' then
    print("^1[ERROR] Police Application: Discord webhook is not configured! Check server.cfg^7")
end

RegisterNetEvent('police:playerEnteredZone', function()
    local src = source
    local timeoutDuration = Config.ApplicationTimeout or 600 
    playersInZone[src] = os.time() + timeoutDuration
    DebugLog("Player " .. src .. " opened application. Timeout set for: " .. os.date('%X', playersInZone[src]))
end)

RegisterNetEvent('police:submitApplication', function(data)
    local src = source
    local user = QBCore.Functions.GetPlayer(src)

    if not playersInZone[src] or os.time() > playersInZone[src] then
        DebugLog("Submission rejected for Player " .. src .. ". Reason: Timed out or not in zone session.")
        TriggerClientEvent('police:applicationResult', src, false, Config.Locale.failure_not_in_zone)
        return
    end
    
    playersInZone[src] = nil
    
    if not user then 
        DebugLog("Submission rejected. User object not found for Source " .. src)
        return 
    end

    DebugLog("Building Discord Embed for Player " .. src)

    local embed = {
        {
            title = Config.Locale.discord_embed_title,
            color = 3447003,
            fields = {},
            footer = {
                text = string.format(Config.Locale.discord_embed_footer, user.PlayerData.charinfo.firstname, user.PlayerData.charinfo.lastname, user.PlayerData.citizenid),
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S.000Z"),
        }
    }

    for i, question in ipairs(Config.Questions) do
        local answer = data['question-' .. (i - 1)] or "N/A"
        
        if answer == "" or answer == nil then answer = "No Answer Provided" end

        table.insert(embed[1].fields, {
            name = question.label,
            value = "```\n" .. tostring(answer) .. "\n```",
            inline = false
        })
    end
    
    DebugLog("Sending to Discord Webhook...")

    PerformHttpRequest(webhook, function(err, text, headers)
        if err == 204 or err == 200 then
            DebugLog("Discord Webhook Success. Status Code: " .. tostring(err))
            TriggerClientEvent('police:applicationResult', src, true)
        else
            print("^1[denji-polform] Discord Webhook Failed!^7")
            print("Status Code: " .. tostring(err))
            print("Response: " .. tostring(text))
            
            TriggerClientEvent('police:applicationResult', src, false)
        end
    end, 'POST', json.encode({ embeds = embed }), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('playerDropped', function()
    if playersInZone[source] then
        playersInZone[source] = nil
    end
end)
