
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

(fn mqtt-connect []
  (let [m (mqtt.Client "clientid" 60)]
    (m:connect "" 1883 false
      (fn [client]
        (print "mqtt connected"))
      (fn [client reason]
        (print reason)))))

(fn wifi-events []
  (wifi.eventmon.register wifi.eventmon.STA_GOT_IP
    (fn [e]
       (print "Wifi connected")
       (mqtt-connect))))

(fn setup-wifi []
   (let [cfg {:ssid "" :pwd "" :save false}]
     (wifi.setmode wifi.STATION)
     (wifi.sta.config cfg)))

(setup-i2c)
(wifi-events)
(setup-wifi)
(create-timer)
