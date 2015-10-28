-- MEAS HTU21D http://www.meas-spec.com/downloads/HTU21D.pdf
-- Measurement Specialities digital humidity sensor with temperature output
-- * Requires floating point support *
--

local moduleName = ...
local M = {}
_G[moduleName] = M

-- Default value for I2C communication
local id = 0

local HTDU21D_ADDRESS = 0x40

local TRIGGER_TEMP_MEASURE_HOLD = 0xE3
local TRIGGER_HUMD_MEASURE_HOLD = 0xE5
local TRIGGER_TEMP_MEASURE_NOHOLD = 0xF3
local TRIGGER_HUMD_MEASURE_NOHOLD = 0xF5
local WRITE_USER_REG = 0xE6
local READ_USER_REG = 0xE7
local SOFT_RESET = 0xFE

-- Read 3 bytes from I2C
local function read_reg(dev_addr, reg_addr)
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.TRANSMITTER)
  i2c.write(id, reg_addr)
  i2c.stop(id)
  -- TODO: implement proper waiting for ACK
  tmr.delay(55000); -- Max wait time per datasheet 50 mS
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.RECEIVER)
  local c = i2c.read(id, 3)
  i2c.stop(id)
  return c
end

-- Initialize I2C bus
-- parameters:
-- d: SDA
-- l: SCL
function M.init(d, l)
  if (d ~= nil) and (l ~= nil) and (d >= 0) and (d <= 11) and (l >= 0) and ( l <= 11) and (d ~= l) then
    local sda = d
    local scl = l 
  else 
    print("HTDU21D init failed!") 
    return nil
  end
    i2c.setup(id, sda, scl, i2c.SLOW)
    return 1
end

-- Read temperature in 'C
-- Min -40'C; Max 125'C 
function M.readTemperature()
  -- TODO: CRC Checking
  local h, l, c = string.byte(read_reg(HTDU21D_ADDRESS, TRIGGER_TEMP_MEASURE_NOHOLD), 1, 3)
  local h1 = bit.lshift(h, 8)
  
  local signaltemp = bit.band(bit.bor(h1, l), 0xfffc)
  local temp = ((signaltemp / 65536.0) * 175.72) - 46.85
  return temp
end

-- Read ambient humidity in %RH
-- Min -6%; Max 118%
function M.readHumidity()
  -- TODO: CRC Checking
  local h, l, c = string.byte(read_reg(HTDU21D_ADDRESS, TRIGGER_HUMD_MEASURE_NOHOLD), 1, 3)
  local h1 = bit.lshift(h, 8)
  
  local signalhum = bit.band(bit.bor(h1, 1), 0xfffc)
  local hum = ((signalhum / 65536.0) * 125.0) - 6.0
  return hum
end

return M
