//
//  StringExtension.swift
//

import Foundation

// roughly equal to
func ~= (lhs: String?, rhs: String?) -> Bool {
    guard var l = lhs,
        var r = rhs else { return false } // false if either one is nil
    
    l = l.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    r = r.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return l.lowercased() == r.lowercased()
}

// convenience
extension String {
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func index(ofSubstr substr: String) -> Int? {
        guard let r = self.range(of: substr) else {
            return nil
        }
        
        let range: Range<String.Index> = r
        let index: Int = self.distance(from: self.startIndex, to: range.lowerBound)
        return index
    }
}

// content type
extension String {
    func containsNumber() -> Bool {
        let regEx = ".*[0-9]+.*"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    func isNumeric() -> Bool {
        let regEx = "[0-9]+"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
}

// base 64
extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
