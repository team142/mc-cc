--[[
 
Created by: Just1689
 
]]--

local INVENTORY_SIZE = 16
local xLen = 13
local yLen = 11
local REFUEL_MIN = 800

if #arg == 2 then
    xLen = tonumber(arg[1])
    yLen = tonumber(arg[2])
end
print("Using x,y:" .. xLen .. ", " .. yLen)

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

function inventorySort()
    for j = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(j)

        if currentItem ~= nil then
            turtle.select(j)
            for k = j, INVENTORY_SIZE do
                if turtle.compareTo(k) then
                    turtle.select(k)
                    turtle.transferTo(j)
                    turtle.select(j)
                end
            end
        end
    end
end


-- Dump inventory
function dumpInventory()
    for i = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil then
            turtle.select(i)
            if turtle.dropDown() == false then
                print("Error: no room in left ")
                return
            end
        end
    end
    inventorySort()
    turtle.select(1)
end

--[[
    APPLICATION STARS HERE
]] --


-- Better fuel check
turtle.refuel()
if turtle.getFuelLevel() < REFUEL_MIN then
    print("Error: Not enough fuel. Need at least ".. REFUEL_MIN)
    return
end

-- Enter maze
turtle.forward()
turtle.forward()
turtle.forward()
turtle.turnRight()
turtle.forward()
turtle.forward()
turtle.down()
turtle.down()
turtle.down()
turtle.forward()
turtle.forward()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.up()
turtle.back()
turtle.turnRight()
for j = 1, 25 do
    marchForward()
end
turtle.turnLeft()
turtle.down()
turtle.down()
turtle.down()
turtle.down()


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

-- -- return to base
-- turtle.turnRight()
-- turtle.forward()
-- turtle.forward()
-- turtle.forward()
-- turtle.down()
-- turtle.down()
-- turtle.down()
-- turtle.down()
-- turtle.down()
-- turtle.forward()
-- turtle.forward()
-- turtle.up()
-- turtle.forward()
-- turtle.turnLeft()
-- turtle.forward()
-- turnAround()


-- -- Deposit
-- dumpInventory()

-- refuel
-- TODO: if more than 10,000 then Skip
-- TODO: go to fuel chest
-- TODO: pickup, refuel

-- return to start spot

-- TODO: put in for loop