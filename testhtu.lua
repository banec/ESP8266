-- Declare I2C interface pins
sda = 5
scl = 6

print("")

tmr.alarm(6, 5000, 1, function ()
  
  htu = require('htu21d')
  if (htu ~= nil) then
    if (htu.init(sda, scl) ~= nil) then
      temperature = htu.readTemperature()
      humidity = htu.readHumidity()
      print("Temperature = "..temperature.."`C\tRelative humidity = "..humidity.."%RH")
    else
      print("Init failed!")
    end
    package.loaded["htu21d"] = nil
    htu = nil
  else
    print("Package failed to load!")
  end

end)


