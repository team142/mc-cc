--[[
 
Created by: Just1689
 
]] --

local INVENTORY_SIZE = 16
local xLen = 0
local yLen = 0
local zLen = 0
local REFUEL_MIN = 100

if #arg == 3 then
    xLen = tonumber(arg[1])
    yLen = tonumber(arg[2])
    zLen = tonumber(arg[3])
else
    print("Please enter the x y z")
    return
end

local ACCEPTED_FUELS = {
    "minecraft:coal_block",
    "minecraft:coal",
    "minecraft:dried_kelp_block",
    "minecraft:charcoal"
}

function turnAround()
    turtle.turnLeft()
    turtle.turnLeft()
end

-- Better fuel check
turtle.refuel()
if turtle.getFuelLevel() < REFUEL_MIN then
    print("Not enough fuel")
    return
end

--[[
    APPLICATION STARS HERE
]] --


-- Enter maze
for i = 1, 6 do
    turtle.forward()
end
turtle.up()

-- Chop down grid

-- Collect

-- Return home

-- Deposit
