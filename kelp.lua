--[[
 
Created by: Just1689
 
]] --

local INVENTORY_SIZE = 16
local xLen = 0
local yLen = 0
local zLen = 0
local REFUEL_MIN = 100

if #arg == 2 then
    xLen = tonumber(arg[1])
    yLen = tonumber(arg[2])
else
    print("Please enter the x y")
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

function marchForward()
    ok, err = turtle.forward()
    if not ok then
        turtle.dig()
        marchForward()
    end
end

--[[
    APPLICATION STARS HERE
]] --


-- Better fuel check
turtle.refuel()
if turtle.getFuelLevel() < REFUEL_MIN then
    print("Not enough fuel")
    return
end

-- Enter maze
turtle.forward()
turtle.turnRight()
turtle.forward()
turtle.down()
turtle.forward()
turtle.forward()
turtle.up()
turtle.turnRight()
turtle.forward()
turtle.turnLeft()
turtle.forward()
turtle.forward()
turtle.up()

local toggleDir = true
local xOffSet = 0
-- Chop down grid
for y = 1, yLen do
    for x = 1, xLen - xOffSet do
        marchForward()
    end
    if toggleDir then
        turtle.turnLeft()
        marchForward()
        turtle.turnLeft()
    else
        turtle.turnRight()
        marchForward()
        turtle.turnRight()
    end
    xOffSet = 1
    toggleDir = not toggleDir
end
-- Collect

-- Return home

-- Deposit
