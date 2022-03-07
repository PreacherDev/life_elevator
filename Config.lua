PREVIEW

Config = {}

Config.Locale = 'de'
Config.ElevatorKey = 38 -- [E]

Config.Elevators = {
    {
        elevator_name = 'Medical Center',
        UseElevatorSound = true,
        openMenu = 'Press ~INPUT_PICKUP~ to use the Elevator',
        markerID = 1,
        RequiredJob = '',
        RequiredJob_label = '',
        stagelabel = {
            'First Stage', -- stagelabels
            'Second Stage',
            'Third Stage' 
        },
        ['First Stage'] = {x = 180.0, y = 180.0, z = 80.0, heading = 1000.0, distance = 1.2}, -- you can choose how you want to call the stage but needs to be the same as on stagelabel!
        ['Second Stage'] = {x = 1000.0, y = 100.0, z = 80.0, heading = 1000.0, distance = 1.2},
        ['Third Stage'] = {x = 120.0, y = 100.0, z = 80.0, heading = 1000.0, distance = 1.2},
    },
    {
        elevator_name = 'Police Station',
        UseElevatorSound = true,
        openMenu = 'Press ~INPUT_PICKUP~ to use the Elevator',
        markerID = 1,
        RequiredJob = 'police',
        RequiredJob_label = 'Police',
        stagelabel = {
            'First Stage', 
            'Second Stage', 
            'Third Stage' 
        },
        ['First Stage'] = {x = 8.43, y = 266.80, z = 108.40, heading = 100.0, distance = 1.2},
        ['Second Stage'] = {x = 1000.43, y = 266.80, z = 108.40, heading = 100.0, distance = 1.2},
        ['Third Stage'] = {x = 80.43, y = 266.80, z = 108.40, heading = 100.0, distance = 1.2},
    },
}

Translation = {
    ['de'] = {
        ['teleported'] = 'Teleportiert zu',
        ['wrong_job'] = 'Du hast den falschen Job. Du benötigst:',
        
    },

    ['en'] = {
        ['teleported'] = 'Teleported to',
        ['wrong_job'] = 'You got the wrong job for this. You need to have:',
    }
}
