### katana_notify

Simple notifications with positions

---

### Usage Example

```lua
-- Client
exports.katana_notify:Notify('Title', 'Example text', 'success', 4000)

-- It also accepts a table
exports.katana_notify:Notify({ title = 'Bank', text = 'Payment received', type = 'success', length = 3000, sound = 'money.ogg' })

-- Server
TriggerClientEvent('katana_notify:Notify', source, 'Title', 'Text', 'warning', 4000)
```

Parameters: `title` (optional), `text`, `type` (`info` | `success` | `warning` | `error`; `primary` is treated as `info`), `length` in ms (optional), `icon` (ignored; kept for compatibility), `sound` (optional, file from `web/sounds`).

---

### QBCore

```lua
function QBCore.Functions.Notify(text, texttype, length)
    exports.katana_notify:Notify(text, texttype, length)
end
```

---

### License

This project is distributed under the terms of the **GNU General Public License v3.0**.

```text
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

Copyright (C) 2026 katanadesk
Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see [https://www.gnu.org/licenses/](https://www.gnu.org/licenses/).
```

---
