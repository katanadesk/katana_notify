local maxTitle = 60
local maxText = 300

local typeAliases = {
    info = 'info',
    primary = 'info',
    inform = 'info',
    success = 'success',
    warning = 'warning',
    warn = 'warning',
    error = 'error',
}

local defaultTitles = {
    info = 'Information',
    success = 'Success',
    warning = 'Warning',
    error = 'Error',
}

local ready = false
local queue = {}

local function cleanString(value, max)
    if value == nil then
        return nil
    end
    local str = tostring(value)
    if str == '' then
        return nil
    end
    return str:sub(1, max)
end

local function resolveType(value)
    if type(value) == 'string' then
        local resolved = typeAliases[value:lower()]
        if resolved then
            return resolved
        end
    end
    return Config.DefaultType
end

local function resolveTitle(title, notifyType)
    local custom = cleanString(title, maxTitle)
    if custom then
        return custom
    end
    local fromConfig = type(Config.Titles) == 'table' and Config.Titles[notifyType]
    return cleanString(fromConfig, maxTitle) or defaultTitles[notifyType]
end

local function resolveDuration(length)
    length = tonumber(length) or Config.DefaultDuration
    return math.floor(math.max(Config.MinDuration, math.min(Config.MaxDuration, length)))
end

local function dispatchNotify(payload)
    if ready then
        SendNUIMessage({
            action = 'notify',
            data = payload,
        })
        return
    end
    if #queue < 20 then
        queue[#queue + 1] = payload
    end
end

function Notify(title, text, notifyType, length, icon, sound)
    if type(title) == 'table' then
        local data = title
        title = data.title
        text = data.text or data.description
        notifyType = data.type
        length = data.length or data.duration
        icon = data.icon
        sound = data.sound
    end

    if text == nil and title ~= nil then
        title, text = nil, title
    elseif type(text) == 'string' and typeAliases[text:lower()]
        and (notifyType == nil or type(notifyType) == 'number') then
        title, text, notifyType, length = nil, title, text, notifyType or length
    end

    text = cleanString(text, maxText)
    if not text then return end

    local resolvedType = resolveType(notifyType)

    dispatchNotify({
        title = resolveTitle(title, resolvedType),
        text = text,
        type = resolvedType,
        length = resolveDuration(length),
        icon = cleanString(icon, 32),
        sound = cleanString(sound, 64),
    })
end

exports('Notify', Notify)

RegisterNetEvent('katana_notify:Notify', Notify)

RegisterNUICallback('ready', function(_, cb)
    ready = true
    SendNUIMessage({
        action = 'config',
        data = {
            position = Config.Position,
            maxVisible = Config.MaxVisible,
            volume = Config.Volume,
            colors = Config.Colors,
            sounds = Config.Sounds,
            titles = Config.Titles,
        },
    })

    for i = 1, #queue do
        SendNUIMessage({
            action = 'notify',
            data = queue[i],
        })
    end
    queue = {}
    cb('ok')
end)

if Config.TestCommand then
    RegisterCommand(Config.TestCommand, function()
        Notify('', 'This is an informational notification.', 'info')
        Notify('', 'Action completed successfully', 'success')
        Notify('', 'Be careful what you do.', 'warning')
        Notify('Failed', 'Something has gone wrong', 'error')
    end, false)
end
