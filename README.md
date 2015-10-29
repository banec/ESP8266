# HTU21D library for ESP8266
This is lua library for MEAS HTU21D humidity and temperature sensor for use with NodeMCU environment on ESP8266.

## Functions
### init(sda, scl)  
Initialize module. You must initialize module first, before being able to read anything.

**Parameters:**

* sda - SDA pin  
* scl - SCL pin

### readTemperature()
Return temperature in °C. Range: Min -40°C; Max 125°C

### readHumidity()
Return ambient humidity in %RH. Range: Min -6%; Max 118%

## Example usage  
```lua
-- I2C interface pins
sda = 5
scl = 6

htu = require('htu21d')
htu.init(sda, scl)
temperature = htu.readTemperature()
humidity = htu.readHumidity()
print("Temperature = "..temperature.."`C Humidity = "..humidity.."%RH")
package.loaded["htu21d"] = nil
htu = nil
```
