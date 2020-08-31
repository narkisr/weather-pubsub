
(local sda 3)
(local scl 4)

(fn setup-i2c []
  (i2c.setup 0 sda scl i2c.SLOW)
  (bme280.setup))

(fn read-temp [t]
  (print "reading temp")
  (let [(T r) (bme280.temp)]
    (print T)))

(fn create-timer []
  (let [timer (tmr.create)]
    (timer:register 5000 tmr.ALARM_AUTO read-temp)
    (timer:start)))

(setup-i2c)
(create-timer)
