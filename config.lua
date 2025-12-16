Config = {}

Config.Debug = false

-- Time in seconds the player has to submit the form after opening it.
Config.ApplicationTimeout = 600

Config.Locale = {
    interact_prompt = "[E] - Open Police Application",

    form_title = "Police Job Application",
    submit_button = "Submit Application",
    cancel_button = "Cancel",

    success_notification = "Application submitted successfully!",
    failure_notification = "There was an error submitting your application.",
    failure_not_in_zone = "Submission failed: You are not at an application terminal.",
    
    -- Discord Embed
    discord_embed_title = "New Police Application",
    discord_embed_footer = "Submitted by: %s %s | Citizen ID: %s", -- %s will be replaced with firstname, lastname, citizenid
}

Config.Locations = {
    {x = 441.4, y = -983.1, z = 30.7},
}

Config.Questions = {
    {label = "What is your full name?", type = "text", required = true},
    {label = "What is your date of birth?", type = "date", required = true},
    {label = "What is your phone number?", type = "tel", required = true},
    {label = "Why do you want to become a police officer?", type = "textarea", required = true},
    {label = "Do you have any prior experience in law enforcement?", type = "textarea", required = false},
    {label = "Please describe your character's personality and background.", type = "textarea", required = true},
}
