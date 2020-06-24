import Foundation
import FoundationNetworking
import SwiftJWT
struct MyClaims: Claims {
                 var iss: String
                 var  aud: String
                 var  exp: Date  
                 var iat: Date 
                 var scope: String}

enum MyError: Error {case runtimeError(String)}
func getAccessToken(privateKey: Data, emailName: String, signedJWT: String)->Data
{
let semaphore = DispatchSemaphore(value: 0)
let parameters: [String: String] = [
    "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
    "assertion":  signedJWT]

let url = URL(string: "https://oauth2.googleapis.com/token")

var request = URLRequest(url: url!)
request.httpMethod = "POST"

request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type: text/html; charset=utf-8") 



request.httpBody = parameters
    .map { (key, value) in
        return "\(key)=\(value)"
    }
    .joined(separator: "&")
    .data(using: .utf8)

print("\(request.httpMethod ?? "") \(String(describing:request.url))")
        let str = String(decoding: request.httpBody!, as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing:request.allHTTPHeaderFields))")


var dataReturned:Data = Data()

let task = URLSession.shared.dataTask(with: request) { 

  data, response, error in
    // Do something
      if let data = data, let dataString = String(data: data, encoding: .utf8) {
      print(dataString)
      dataReturned = data}   
                                                                   
    if let httpResponse = response as? HTTPURLResponse {
    print(httpResponse.statusCode)
    }
    semaphore.signal()
  
} // URL
task.resume()
 semaphore.wait()
 return dataReturned
}

func printCurrentDirectory()->String
{
let path = FileManager.default.currentDirectoryPath
let enumerator = FileManager.default.enumerator(atPath: path)
while let element = enumerator?.nextObject() as? String {print(element)}
return path
}

func  listFiles(authorizationTokenValue: String)->[String:Any]
{
let urllist = URL(string: "https://www.googleapis.com/drive/v3/files?fields=kind,incompleteSearch,files(kind,id,name,mimeType)")

var request = URLRequest(url: urllist!)
request.httpMethod = "GET"
let authorizationTokenWithBearerString = "Bearer " +  authorizationTokenValue
request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type: text/html; charset=utf-8")
request.setValue(authorizationTokenWithBearerString, forHTTPHeaderField: "Authorization") 
print("\(request.httpMethod ?? "") \(String(describing:request.url))")
        print("HEADERS \n \(String(describing:request.allHTTPHeaderFields))")

let semaphorel = DispatchSemaphore(value: 0)
var filelistDictionary : [String:Any] = [:]
//var filelistArray: [Any] = []
var filelistArrayDictionary: [[String:String]] = []

let taskl = URLSession.shared.dataTask(with: request) {
  data, response, error in
    // Do something
      if let data = data, let dataString = String(data: data, encoding: .utf8) {
      print(dataString)
if let filelistDictionaryint = try? JSONSerialization.jsonObject(with: 
 data, options: []) as? [String: Any   ] {
    filelistDictionary = filelistDictionaryint
for (key,value) in filelistDictionary {
    print("key=  \(key) value = \(value)")
    print("type \(type(of: value))")
    if value is Array<Any> {print("Array key = \(key)")
                            if let filelistArray = filelistDictionary[key]{
                            print("Type \(type(of: filelistArray))")
                            print(filelistArray)
                            filelistArrayDictionary = filelistArray as!  [[String:String]]
                             print(filelistArrayDictionary)
                             for item in filelistArrayDictionary 
                              { print(" ")
                                for (indexa,valuea) in item {print(" key = \(indexa) value \(valuea)")}                         
                              }
                           }
}
       }
//
    } 
    if let httpResponse = response as? HTTPURLResponse {
    print(httpResponse.statusCode)
    }
    semaphorel.signal()
  }}
taskl.resume()
 semaphorel.wait()
    return  filelistDictionary 
}
func test()->String {
print(printCurrentDirectory())

let myjson=[
  "type": "service_account",
  "project_id": "swift3-257813",
  "private_key_id": "815810cfa138faf6161176f31e5d50fa440032e9",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCjCOSJFs5cvnNe\nnzoxjYkVbY2fsttjRDe4x4Mn48E7MtwpNsMRGlalXwe631Rv17KeDF/goB3S8K/8\nVoQ+ZgQ9D2QaLhRZmk8WI7bN4JFe9Iq5ZLc+jnCSVOqzagzk0WCAiKomZURakb96\nuTL+tby4H0xtQSchY7BlGweAyfMPHFdAxs8yxZG3to20zzr2XmVFm8sCal8TBOm0\n63hFbRDy55nVbnMxqS73qz7+sR8KRaNFaiVVH1Z+PjXQ5aZg4+fhJvpb0XuzI8xQ\nyqSSHwo6IrLXgLxoNCK+8mmmMuKMo87p+GNzaAF4+7RaWIrjo0sir4+WYmGLjXks\nfyBaL1jRAgMBAAECggEACK5FCN2bgEmtt+iPfyrzlR3/r/SkhM0RkHejDqEsXTwQ\nh+tACK2X1ndQYI1aoBfijVLIWhv8aophPHTY1r+00xF6OYChmcHDG0Esjxq5cs5f\ngo6PyTdpXAlEc+geJqLVWhKsyJ2UvaPMB7tLsU847K7R8XFKJZd6wW9mf1+BXxkD\n21fG20eeKINNOnya2AgiNlsscydAVwgMSOg0Rk1yPFvB2MEKf1X9NZd/os48HBHY\nrM5bVTuB8/kE6+8cIL9onBV7xhowYM3TW8bGz7KH+6qvhP2Tb69/ttltYGz3uTqT\nfKTaemYYkVtwtZ0Lj235Yl3UWZsgd+R23acXqO1e6QKBgQDgzx9ND+6UKfbOakP1\nx0swgHuYK8uZuiS23YmFwr7iiAs/6wXL8QFTp8LNQkXyzv+rFD+2lLEFtQU0suYh\n9qEfBSQzKMUXhMj6aZyAnZq8sdKs1pPKAcRh8wSd2ajI8mkN3gND4xkKZUen7NMK\nDTD48icX2R3+qj6NakggDUTkjQKBgQC5p6PAkFX8eviV93kD6uLEyECHeaeTLs9y\n2pMfs5jnO6b28r5laxjedffVc1vPOL7aitAc1d1WN2ERewUf/d1MJJi+Dzac9uoD\nMgmGoVW0Q0QD05SMxfW4oLUuFFYl6bujD9Iexl8bgU6VLCLtaqyC83FXrzhGokth\nbJp1WX7OVQKBgQDK1pcrdQCS9voVbJQ9IsCY1pStzHY8ElQmGuWGpxyMUKu11Fy6\nko3b6TY+9Vkfp93Pgsmp96dxus8jqXczlc/yqTTsZBDRE6IzLy9ibNG9B8VK5aEb\nV1TV++ticY11IiPfuz2+9x0U4CUzQt935kcVl4fmYKRLr1gZSJgjM1XB0QKBgBpG\n/Ap5Y3JFBYJUcLB5QneP0HJcabePXJVpEoHeLbos20kAuqooKnDySY3QsiH2ai0M\nkMBEFPvrArYyr1sD15q7Y1MjXBuDZ0PkhSylEThefPX9sHzsWAc11+8ZucfL+V7v\nElKAyV1fQ/whLyBjhN9UDarXhiOZPQohEQujCyuxAoGAUSPvAjCe63/7CLASHoAq\nx7szA6c/3dQvukQ94DouQtWc/IQYmX1fOPIXGxG/uu9w9Ty5E4CfM47VNkpyztNt\noO0gMObKcz0tSqlr6zTsRgyMr/WOLtkl1kcU+j7w5czq/VtV7CL6/13C7+R+9Hou\nptGdoD+ykditJ5A5CiAOxyI=\n-----END PRIVATE KEY-----\n",
  "client_email": "owner-194@swift3-257813.iam.gserviceaccount.com",
  "client_id": "101520951546003168716",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/owner-194%40swift3-257813.iam.gserviceaccount.com"
] as [String:String]


//
let ce = myjson["client_email"]!


let myClaims =  MyClaims(iss: ce,
                 aud: "https://oauth2.googleapis.com/token",
                 exp: Date(timeIntervalSinceNow:3600),
                 iat: Date(timeIntervalSinceNow:0),
                 scope: "https://www.googleapis.com/auth/drive")

var myheader = Header(typ:"JWT")

var jwt = JWT(header: myheader, 
claims: myClaims)

let secret:Data=myjson["private_key"]!.data(using: .utf8)!


let signedJWT:String = try! jwt.sign(using: .rs256(privateKey: secret))

var dataReturned = getAccessToken(privateKey: secret,emailName: ce, signedJWT: signedJWT)

var myjsonToken: [String: String] = [:]
if let jsonToken1 = try? JSONSerialization.jsonObject(with: 
 dataReturned, options: []) as? [String: Any   ] {
for (key,value) in jsonToken1 {
    print("key=  \(key) value = \(value)")
    print("type \(type(of: value))")
    if (value is String) {myjsonToken[key] = (value as! String)}
    if (value           is NSNumber) {myjsonToken[key] = String((value as! Int     ))}
}
}

let authorizationTokenValue:String=myjsonToken["access_token"]! 
var dictionaryOfFiles = listFiles(authorizationTokenValue: authorizationTokenValue)

 print(dictionaryOfFiles)
print ("print out dictionary")
for (key,value) in dictionaryOfFiles {
    print("key=  \(key) value = \(value) type \(type(of: value))")
    if (value is String) {dictionaryOfFiles[key] = (value as! String)}
    if (value           is NSNumber) {myjsonToken[key] = String((value as! Int     ))}
}
for (key,value) in dictionaryOfFiles {
    print("key=  \(key) value = \(value)")
    print("type \(type(of: value))")
    if value is Array<Any> {print("Array key = \(key)")
                            if let filelistArray = dictionaryOfFiles[key]{
                            print("Type \(type(of: filelistArray))")
                            print(filelistArray)
                            var filelistArrayDictionary = filelistArray as!  [[String:String]]
                             print(filelistArrayDictionary)
                             for item in filelistArrayDictionary 
                              { print(" ")
                                for (indexa,valuea) in item {print(" key = \(indexa) value \(valuea)")}                         
                              }
                           }
}
       }
return "YES"
}
