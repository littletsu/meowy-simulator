type DefaultOptions = {
    Value: any,
    -- Defaults to true
    Replicated: boolean?
}
local function Default(value: any, options: DefaultOptions | nil)
    options = options or {}
    options.Value = value
    options.Replicated = options.Replicated or true
    return options :: DefaultOptions
end
return Default