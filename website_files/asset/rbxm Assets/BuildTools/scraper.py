# shit thing made by piss boxer in 2 minutes
import requests
import os

assetid = int(input("enter asset id: "))
#extension = input("enter file extension: ")
extension = "rbxm" # override

status = 200
ver = 1

if not os.path.exists(str(assetid)):
    os.makedirs(str(assetid))

print("now scraping asset "+str(assetid))

while status != 404:
    url = "https://assetdelivery.roblox.com/v1/asset/?id="+str(assetid)+"&version="+str(ver)
    r = requests.get(url, verify=False, headers={"Cookie":".ROBLOSECURITY=_|WARNING:-DO-NOT-SHARE-THIS.--Sharing-this-will-allow-someone-to-log-in-as-you-and-to-steal-your-ROBUX-and-items.|_7BAAC396165881FA03D9AEDDA2E4CDA635E5DE93248DD9F02FB497BD43D7E1F3A33D8EFBDFF17138ED3F94CF1662C127FC2390EF3870C385065E4A577441DDB3A87C1E183590A3ECDF2B000A21156D0C5DD91ED8F0D0A84B6CC8680A5CB4D40DB31F920E098DF09803CE4822332A377C57FF50DCD09AEA9147119B4BD61D493159A7988906A606FA58D732D2EF1FD6033C162CEFA38E0087E55E6F3F2F9325B075EE2F85F4034B968461D14510731A75DE467AF9D72A29C809A897C1B4BE2608553AF2127E8D527E6FA1181F10863101E29F28A44CA6C0919F80A80CDF4C8D863E5136604C91B1149DD208825336202304BF922FC5875272640318058FE4BFA454328357FE91A6AFDA1893DACAB690942E1ADB04C3538D452449D0F58A167904831A82470DC1E294F4DA300EECAE31D5CFF7775A00978D19547C5A476FF296341B1CF47F;"})
    status = r.status_code
    
    if status != 404:
        open(str(assetid)+"/version_"+str(ver)+"."+extension, "wb").write(r.content)
        open(str(assetid)+"/index.txt", "a").write("version_"+str(ver)+"."+extension+" ["+r.headers['Last-Modified']+"] \r\n")
            
        print("saving "+str(assetid)+" version "+str(ver)+" @ "+str(r.headers['Last-Modified']))

    ver += 1

print("finished scraping asset "+str(assetid))
