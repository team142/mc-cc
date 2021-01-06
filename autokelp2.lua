local minuteCount = 20
while true do
    for y = 1, minuteCount do
        print("Minute: " .. y .. " of " .. minuteCount)
        os.sleep(60)
    end
    print("Fuel level: " .. turtle.getFuelLevel())
    shell.execute("kelp2")
end
