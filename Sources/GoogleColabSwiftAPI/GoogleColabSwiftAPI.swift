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
public func test()->String {
print(printCurrentDirectory())



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
