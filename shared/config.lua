Config = {
    -- Top: 'top-left' | 'top-center' | 'top-right' | 'center-left' | 'center-right'
    -- Bottom: 'bottom-left' | 'bottom-center' | 'bottom-right'
    Position = 'top-right',

    DefaultType = 'info',   -- Use: 'info' | 'success' | 'warning' | 'error'
    DefaultDuration = 5000, -- ms
    MinDuration = 1000,     -- ms
    MaxDuration = 30000,    -- ms
    MaxVisible = 5,         -- Maximum number of on-screen notifications

    -- Test command (false to disable it)
    TestCommand = 'testnotify',

    -- Default titles when no title is provided
    Titles = {
        info = 'Information',
        success = 'Success',
        warning = 'Warning',
        error = 'Error',
    },

    -- Default colors for notification types
    Colors = {
        info = '#4da3ff',
        success = '#36ff9f',
        warning = '#ffb73a',
        error = '#ff4d6a',
    },

    -- Sounds (files in web/sounds).
    -- You can replace the sounds with your own custom ones. (Default: 'click.ogg')
    -- Volume: 1.0 - 0.0 (Default: 0.5)
    Volume = 0.5,
    Sounds = {
        info = 'click.ogg',
        success = 'click.ogg',
        warning = 'click.ogg',
        error = 'click.ogg',
    },
}
