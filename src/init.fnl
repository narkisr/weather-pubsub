(var sda 3)
(var scl 4)

(var client nil)

(var minute (* 60 1000000))

(fn setup-i2c []
  (i2c.setup 0 sda scl i2c.SLOW)
  (bme280.setup))

(fn sleep []
  (print "sleeping for one minute")
  (node.dsleep (* minute 30)))

(fn read-temp [t]
  (let [(T P H) (bme280.read)
        {: hostname} (. configuration :wifi)]
     (when client
       (let [payload {:temp T :humidity H :preasure P :type "bme280" :hostname hostname}
             (ok enc) (pcall sjson.encode payload)]
         (if ok
           (if (client:publish "temp/reading" enc 0 0 (fn [client] (sleep)))
              (print "publish successful")
              (print "publish failed"))
           (print "failed to encode payload"))
         ))))

(fn create-timer []
  (let [timer (tmr.create)]
    (timer:register 10000 tmr.ALARM_AUTO read-temp)
    (timer:start)))

(fn mqtt-connect []
  (print "mqtt connection")
  (when configuration
    (let [{: password : user : client-id : port : server} (. configuration :mqtt)
        m (mqtt.Client client-id 60 user password)]
    (m:connect server port false
      (fn [c]
        (print "mqtt connected")
        (set client c))
      (fn [client reason]
        (print (.. "failed to connect to mqtt due to " reason)))))))

(fn wifi-events []
  (wifi.eventmon.register wifi.eventmon.STA_GOT_IP
    (fn [e]
       (print "Wifi connected")
       (mqtt-connect))))

(fn setup-wifi []
   (let [{: ssid : password : hostname} (. configuration :wifi)
         cfg {:ssid ssid :pwd password :save false}]
     (wifi.setmode wifi.STATION)
     (wifi.sta.sethostname hostname)
     (wifi.sta.config cfg)))

(setup-i2c)
(wifi-events)
(setup-wifi)
(create-timer)
