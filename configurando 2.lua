
    configurarAP = "<form method='POST'> <input name='SSID' type='text' placeholder='nombre Wifi'> <br> <input name='PASSWORD' type='text' placeholder='clave wifi'><br> <input type='submit' value='enviar'>" 
    ssid1,password1,posSSID,posPASSWORD = nil
    wifi.setmode(wifi.SOFTAP)
    cfg = {}
    cfg.ssid="FlatPIR"
    cfg.pwd = "11111111"
    wifi.ap.config(cfg)
    servidor = net.createServer(net.TCP,1)
    servidor:listen(80,function(c) 
            c:on("receive",function (c,pl)
            c:send("<html>")
             posSSID={string.find(pl,"SSID=")}
             posPASSWORD={string.find(pl,"&PASSWORD=")}
                if(posSSID[2]~= nil and posPASSWORD ~= nil) then
             --       print ("la posicion del ssid es = " .. posSSID[2])
             --       print ("la posicion del password es = " .. posPASSWORD[2])
                      ssid1 = string.sub(pl,posSSID[2]+1,posPASSWORD[2]-10)
                      password1=string.sub(pl,posPASSWORD[2]+1)
                    print ("el ssid es = "..ssid1)
                   print ("el passwprd es = "..password1)
                    c:send ("el ssid es = "..ssid1)
                    c:send ("<br>  el passwprd es = "..password1)
                    c:close()
                    collectgarbage();
                    ssid1=string.gsub(ssid1,"+"," ")
                    wifi.setmode(wifi.STATION)
                    wifi.sta.config(ssid1,password1)
                    wifi.sta.connect()
                end
           
            if(ssid1 == nil and password1==nil) then
                print "SSID Y PASWORD VACIAS"
                c:send(configurarAP)
                c:close();
                collectgarbage();
                end
        print(pl)   
            c:send("</html>")
            end)
         
    end)

 tmr.alarm(1, 1000, 1, function()
 if wifi.getmode() == 1 then
    print ("el ssid es = "..ssid1)
    print ("el passwprd es = "..password1)
  if wifi.sta.getip()== nil then
  print("IP unavaiable, Waiting...")
 else
  tmr.stop(1)
 print("ESP8266 mode is: " .. wifi.getmode())
 print("The module MAC address is: " .. wifi.ap.getmac())
 print("Config done, IP is "..wifi.sta.getip())
 end
 end
 end)
