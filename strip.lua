--[[
 
Created by: Just1689, Squire, Earv1
Lots of snippets take from farmer.lua (see notes)
 
]]--

-- TODO
-- ~~NOW~~
-- Go left or right
-- ~~LATER~~
--   refuel from fuel chest
--   refuel torches
-- ~~MUCH LATER~~
--   go get diamons if found

local INVENTORY_SIZE = 16
local length = 0
local deep = 0
local SLEEP_NO_TORCHES = 3
local REFUEL_MIN = 1000
local tileCount = 0
local tileColCount = 0
local tilesWalked = 0

if #arg == 2 then
    length = tonumber(arg[1])
    deep = tonumber(arg[2])
else
    print("Please enter the length")
    return
end

local TORCHES = {
    "minecraft:torch"
}

local ACCEPTED_FUELS = {
    "minecraft:coal_block",
    "minecraft:coal",
	"minecraft:dried_kelp_block",
	"minecraft:charcoal"	
}

function getTorchesCount()
    local torchesCount = 0
    for i = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil then
            for x = 1, #TORCHES do
                if currentItem.name == TORCHES[x] then
                    torchesCount = torchesCount + turtle.getItemCount(i)
                end
            end
        end
    end

    return torchesCount
end

function checkTorchesCount()
    local torchesCount = getTorchesCount()
    if torchesCount <= 0 then
        print("Out of torches, waiting for torches to be added. Checking for seeds every ".. SLEEP_NO_TORCHES .." seconds.")
        return false
    end
    return true
end

function plantTorches()
    for i = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil then
            for x = 1, #TORCHES do
                if currentItem.name == TORCHES[x] then
                    turtle.turnLeft()
                    turtle.select(i)
                    turtle.placeUp()
                    turtle.select(1)
                    turtle.turnRight()
                    break
                end
            end
        end
    end
end

function goHomeRow()

    print("Going home...")
    turtle.turnLeft()
    turtle.turnLeft()
    for i = 0, tilesWalked - 1 do
        turtle.forward()
    end
    turtle.turnLeft()
    turtle.turnLeft()
    print("I am home...")
    tilesWalked = 0
end



function dumpInventory()
    for i = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil then
            local isFuel = false
            local isTorch = false
            for x = 1, #TORCHES do
                if currentItem.name == TORCHES[x] then
                    isTorch = true
                    break
                end
            end
            for x = 1, #ACCEPTED_FUELS do
                if currentItem.name == ACCEPTED_FUELS[x] then
                    isFuel = true
                    break
                end
            end

            if not isTorch and not isFuel then
                turtle.select(i)
                while turtle.dropDown() == false do
                    print("No room in target inventory, please clear some space. Checking target inventory every ".. SLEEP_NO_TORCHES .." seconds.")
                    sleep(SLEEP_NO_TORCHES)
                end
                turtle.select(1)
            end
        end
    end
end

function isLava()
    local isBlock, block = turtle.inspect()
    if isBlock ~= false then
        if block.name == "minecraft:lava" then
            return true
        end
    end
    isBlock, block = turtle.inspectUp()
    if isBlock ~= false then
        if block.name == "minecraft:lava" then
            return true
        end
    end
end

function isGravel()
    local isBlock, block = turtle.inspect()
    if isBlock ~= false then
        if block.name == "minecraft:gravel" then
            return true
        end
    end
    isBlock, block = turtle.inspectUp()
    if isBlock ~= false then
        if block.name == "minecraft:gravel" then
            return true
        end
    end
end


function doColumn()
    turtle.select(1)
    print("Total fuel ".. turtle.getFuelLevel())
    for c = 1, deep do
        -- 3n -2
        next = (3 * c) - 2
        print("next row is at ".. next)
        for spaces = 1, next do
            turtle.dig()
            turtle.digUp()
            turtle.forward()
            tileColCount = tileColCount + 1
        end
        turtle.turnRight()
        print("now showing row "..c)
        --- do that rows
        doRow()
        goHomeRow()

        -- go to home
        turtle.turnRight()
        for spaces = 1, tileColCount do
            turtle.forward()
        end
        turtle.turnLeft()
        turtle.turnLeft()
        tileColCount = 0
        print("now at home position "..c)
        dumpInventory()
        -- sleep(5)

    end
end

function doRow()
    tilesWalked = 0
    tileCount = 0
    for i = 0, length do
        tilesWalked = tilesWalked + 1
        local okTorches = checkTorchesCount()
    
        if not okTorches then
            print("no torches.. going home")
            tilesWalked = tilesWalked - 1
            break
        end
    
        if isLava() then
            print("found lava.. going home")
            tilesWalked = tilesWalked - 1
            break
        end

        if isGravel() then
            print("found gravel.. going home")
            tilesWalked = tilesWalked - 1
            break
        end
    
        turtle.dig()
        turtle.digUp()
        turtle.digDown()
        tileCount = tileCount + 1
        if tileCount == 6 then
            tileCount = 0
            plantTorches()        
        end
        turtle.forward()
    
    
    end
end


if turtle.getFuelLevel() < REFUEL_MIN then
    print("trying to refuel")
    turtle.refuel()
else
    print("not going to refuel")
end
doColumn()
