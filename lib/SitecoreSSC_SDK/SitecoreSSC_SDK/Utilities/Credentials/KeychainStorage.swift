
import Foundation

let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

#warning("@igk refactor!!! return type should be 'Result', implement via protocol")

public class KeychainStorage: NSObject
{
    class func updatePassword(service: String, account:String, data: String)
    {
        if let dataFromString: Data = data.data(using: String.Encoding.utf8, allowLossyConversion: false)
        {
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
            
            let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)
            
            if (status != errSecSuccess)
            {
                if let err = SecCopyErrorMessageString(status, nil)
                {
                    print("Read failed: \(err)")
                }
            }
        }
    }
    
    class func removePassword(service: String, account:String)
    {
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue as Any], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue])
        
        let status = SecItemDelete(keychainQuery as CFDictionary)
        if (status != errSecSuccess)
        {
            if let err = SecCopyErrorMessageString(status, nil)
            {
                print("Remove failed: \(err)")
            }
        }
        
    }
    
    class func savePassword(service: String, account:String, data: String)
    {
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false)
        {
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            
            if (status != errSecSuccess) {
                if let err = SecCopyErrorMessageString(status, nil)
                {
                    print("Write failed: \(err)")
                }
            }
        }
    }
    
    class func loadPassword(service: String, account:String) -> String?
    {
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue as Any, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        
        if status == errSecSuccess
        {
            if let retrievedData = dataTypeRef as? Data
            {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        }
        else
        {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
    
}
