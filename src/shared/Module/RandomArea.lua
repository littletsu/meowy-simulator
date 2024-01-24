local function RandomInt(min, max)
	return Random.new():NextInteger(min, max)
end

return function(SpawnArea: BasePart)
    local MinX = SpawnArea.Position.X + (SpawnArea.Size.X / 2)
    local MaxX = SpawnArea.Position.X - (SpawnArea.Size.X / 2)
    local MinZ = SpawnArea.Position.Z + (SpawnArea.Size.Z / 2)
    local MaxZ = SpawnArea.Position.Z - (SpawnArea.Size.Z / 2)
    return Vector3.new(RandomInt(MinX, MaxX), SpawnArea.Position.Y, RandomInt(MinZ, MaxZ))
end