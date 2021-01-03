--[[
 
Created by: Just1689
 
]]--

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

function suckForward()
    turtle.suck()
    turtle.suckUp()
    turtle.suckDown()
    ok, err = turtle.forward()
    if not ok then
        turtle.dig()
        suckForward()
    end
end

function isEvenRow()
    if yLen % 2 == 1 then
        return false
    end
    return true
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
-- move back to first tile of maze
if not isEvenRow() then
    for x = 1, xLen - xOffSet do
        marchForward()
    end
    turtle.turnLeft()
    for y = 1, yLen do
        marchForward()
    end
else
    turtle.turnRight()
    for y = 1, yLen do
        marchForward()
    end
end
-- move the extra off the map
local extra = 3
for n = 1, extra do
    marchForward()
end
turtle.turnRight()
for n = 1, extra do
    marchForward()
end
--move up to the right level
local moreHeight = 13
for n = 1, moreHeight do
    turtle.up()
end
turnAround()



-- Collect
xOffSet = 0
toggleDir = true
for y = 1, yLen + (2 * extra) do
    for x = 1, xLen - xOffSet + (2 * extra) do
        suckForward()
    end
    if toggleDir then
        turtle.turnLeft()
        suckForward()
        turtle.turnLeft()
    else
        turtle.turnRight()
        suckForward()
        turtle.turnRight()
    end
    xOffSet = 1
    toggleDir = not toggleDir
end

-- move back to first tile of maze FROM the extra location
if not isEvenRow() then
    for x = 1, xLen + extra do
        marchForward()
    end
    turtle.turnLeft()
    for y = 1, yLen + extra - 1 do
        marchForward()
    end
else
    turtle.turnRight()
    for y = 1, yLen + extra do
        marchForward()
    end
end
for n = 1, moreHeight do
    turtle.down()
end

-- return to base
turtle.turnRight()
turtle.forward()
turtle.forward()
turtle.down()
turtle.down()
turtle.forward()
turtle.forward()
turtle.up()
turtle.forward()
turtle.turnLeft()
turnAround()


-- Deposit

-- refuel

-- return to start spot
