# shit thing made by piss boxer in 2 minutes
import requests
import os

assetid = int(input("enter asset id: "))
extension = input("enter file extension: ")
#extension = "lua" # override

status = 200
ver = 1

if not os.path.exists(str(assetid)):
    os.makedirs(str(assetid))

print("now scraping asset "+str(assetid))

while status != 404:
    url = "http://www.roblox.com/asset/?version="+str(ver)+"&id="+str(assetid)
    r = requests.get(url)
    status = r.status_code
        
    if status != 404:
        open(str(assetid)+"/version_"+str(ver)+"."+extension, "wb").write(r.content)
        open(str(assetid)+"/index.txt", "a").write("version_"+str(ver)+"."+extension+" ["+r.headers['Last-Modified']+"] \r\n")
            
        print("saving "+str(assetid)+" version "+str(ver)+" @ "+str(r.headers['Last-Modified']))

    ver += 1

print("finished scraping asset "+str(assetid))
