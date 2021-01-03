--[[

ORIGINAL CODE 

Script Created by CEEBS
YouTube: https://www.youtube.com/channel/UCQvB8QBknoS1jYgwpYGQrQg
Twitter: https://twitter.com/OnlyCeebs
 
Really appreciate all the support you have given me, so thank you!

CHANGES
Modified by Squire 2021


]]--

local INVENTORY_SIZE = 16
local MAIN_LOOP_INTERVAL = 300
local FUEL_CROP_CHEST_INTERVAL = 5
local length = 0
local rows = 0

-- Receive arguments and validate user input
if #arg == 2 then
    length = tonumber(arg[1])
    rows = tonumber(arg[2])

    if length <= 1 or rows <= 1 then
        print("Please enter values bigger than 1")
        return
    end
else
    print("Please enter both the length and with of the farm area. (e.g. scriptName 10 10)")
    return
end

-- List of accepted fuels
local ACCEPTED_FUELS = {
    "minecraft:coal_block",
    "minecraft:coal",
	"minecraft:dried_kelp_block",
	"minecraft:charcoal"
}

-- List of accepted seeds
local SEEDS = {
    "minecraft:carrot",
    "minecraft:potato",
    "minecraft:wheat_seeds"
}

-- List of mature crops
local CROPS = {
    "minecraft:carrots",
    "minecraft:potatoes",
    "minecraft:wheat"
}

-- Refuel using the found fuel
function refuel(slot_number)
    turtle.select(slot_number)
    turtle.refuel()
end

-- Check the current fuel level
function checkFuelLevel()
    
    local currentFuelLevel = turtle.getFuelLevel()

    if currentFuelLevel <= 0 then
        print("Out of fuel, waiting for fuel to be added. Checking for fuel every ".. FUEL_CROP_CHEST_INTERVAL .." seconds.")
        while currentFuelLevel <= 0 do
            for i = 1, INVENTORY_SIZE do
                local currentItem = turtle.getItemDetail(i)
                if currentItem ~= nil then
                    for x = 1, #ACCEPTED_FUELS do
                        if currentItem.name == ACCEPTED_FUELS[x] then
                            refuel(i)
                        end
                    end
                end
            end
            sleep(FUEL_CROP_CHEST_INTERVAL)
			currentFuelLevel = turtle.getFuelLevel()
        end
        print("Fuel added successfully, continuing...")
    end
end

-- Get the amount of seeds
function getSeedsCount()
    local seedsCount = 0

    for i = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil then
            for x = 1, #SEEDS do
                if currentItem.name == SEEDS[x] then
                    seedsCount = seedsCount + turtle.getItemCount(i)
                end
            end
        end
    end

    return seedsCount
end

-- Checking for seeds
function checkSeedsCount()
    
    local seedsCount = getSeedsCount()

    if seedsCount <= 0 then
        print("Out of seeds, waiting for seeds to be added. Checking for seeds every ".. FUEL_CROP_CHEST_INTERVAL .." seconds.")
        while seedsCount <= 0 do
            seedsCount = getSeedsCount()
            sleep(FUEL_CROP_CHEST_INTERVAL)
        end
        print("Seeds added successfully, continuing...")
    end

end

-- Movement helper functions
function moveForward(times)

    checkFuelLevel()
    checkSeedsCount()
    
    if times then
        for i = 1, times do
            turtle.forward()
        end
    else
        turtle.forward()
    end
end

function turnLeft(times)
    if times then
        for i = 1, times do
            turtle.turnLeft()
        end
    else
        turtle.turnLeft()
    end
end

function turnRight(times)
    if times then
        for i = 1, times do
            turtle.turnRight()
        end
    else
        turtle.turnRight()
    end
end

-- Plant our crops!
function plantCrops()
    for i = 1, INVENTORY_SIZE do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil then
            for x = 1, #SEEDS do
                if currentItem.name == SEEDS[x] then
                    turtle.select(i)
                    turtle.placeDown()
                    break
                end
            end
        end
    end
end

-- Harvest our crops!
function harvestCrops()
    local isBlock, block = turtle.inspectDown()

    if isBlock ~= false then
        local isCrop = false

        for x = 1, #CROPS do
            if block.name == CROPS[x] then
                isCrop = true
            end
        end

        if isCrop then
            if block.state.age == 7 then
                turtle.digDown()
                plantCrops()
            end
        end
    else
        turtle.digDown()
        plantCrops()
    end
end

-- Inventory sorting
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

    local cropCount = 0
    local requiredSeedsCount = math.ceil(length * rows)

    for i = 1, INVENTORY_SIZE do

        local currentItem = turtle.getItemDetail(i)

        if currentItem ~= nil then

            local isFuel = false
            local isCrop = false

            for x = 1, #ACCEPTED_FUELS do
                if currentItem.name == ACCEPTED_FUELS[x] then
                    isFuel = true
                    break
                end
            end

            if not isFuel then
                for x = 1, #SEEDS do
                    if currentItem.name == SEEDS[x] then
                        if cropCount < requiredSeedsCount then
                            cropCount = cropCount + currentItem.count
                            isCrop = true
                        else
                            isCrop = false
                        end
                    end
                end
            end

            if not isCrop then
                turtle.select(i)
                while turtle.dropDown() == false do
                    print("No room in target inventory, please clear some space. Checking target inventory every ".. FUEL_CROP_CHEST_INTERVAL .." seconds.")
                    sleep(FUEL_CROP_CHEST_INTERVAL)
                end
            end
        end
    end

    inventorySort()
end

-- Farming loop
function farm()

    print("Starting farm loop.")

    for i = 1, rows do

        if i ~= 1 then
            for j = 1, length - 1 do
                moveForward()
                harvestCrops()
            end  
        else
            for j = 1, length do
                moveForward()
                harvestCrops()
            end  
        end   

        if i % 2 == 0 then
            if i ~= rows then
                turnLeft()
                moveForward()
                harvestCrops()
                turnLeft()
            end
        else
            turnRight()
            moveForward()
            harvestCrops()
            turnRight()
        end

        if i == rows then 
            if i % 2 == 0 then
                moveForward()
                turnRight()
                moveForward(rows - 1)
                turnRight()
            else
                moveForward(length)
                turnRight()
                moveForward(rows)
                turnRight()
            end
        end
        
    end

    dumpInventory()
end

while true do
    farm()
    print("Completed loop, waiting " .. MAIN_LOOP_INTERVAL .. " seconds to start next loop.")
    sleep(MAIN_LOOP_INTERVAL)
end