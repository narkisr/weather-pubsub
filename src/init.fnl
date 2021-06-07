(var sda 3)
(var scl 4)

(var client nil)

(var interval 5)

(var minute (* 60 1000000))

(fn setup-i2c []
  (i2c.setup 0 sda scl i2c.SLOW)
  (bme280.setup))

(fn take-sleep []
  (print "deep sleeping")
  (node.dsleep (* minute interval)))

(fn read-temp [sleep t]
  (let [(T P H) (bme280.read)
        {: hostname} (. configuration :wifi)
        {: location} (. configuration :instance)]
     (when client
       (let [payload {:temp T :humidity H :preasure P :type "bme280" :hostname hostname :location location}
             (ok enc) (pcall sjson.encode payload)]
         (if ok
           (if (client:publish "temp/reading" enc 0 0 (fn [client] (when sleep (take-sleep))))
              (print "publish successful")
              (print "publish failed"))
           (print "failed to encode payload"))))))

(fn create-timer []
  (let [timer (tmr.create)]
    (timer:register (* interval 60000) tmr.ALARM_AUTO (partial read-temp false))
    (timer:start)))

(fn mqtt-connect []
  (print "mqtt connection")
  (when configuration
    (let [{: password : user : client-id : port : server} (. configuration :mqtt)
        m (mqtt.Client client-id 60 user password)]
    (m:connect server port false
      (fn [c]
        (print "mqtt connected")
        (set client c)
        (let [{: sleep} (. configuration :instance)]
            (if (not sleep)
               (create-timer)
               (read-temp true nil))))
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



