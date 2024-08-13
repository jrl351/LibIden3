import Foundation
import os

extension String {
    init?(cString data: Data) {
        let value = data.withUnsafeBytes { ptr in
            ptr.bindMemory(to: UInt8.self).baseAddress.flatMap(String.init(cString:))
        }
        
        guard let value else {
            return nil
        }
        self = value
    }
    
    var removingHexFormatters: String {
        return self.replacingOccurrences(of: "Fr(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "0x", with: "")
    }
    
    var asCStringPointer: UnsafePointer<CChar> {
        self.withCString { $0 }
    }
    
    var asUnsafeCStringPointer: UnsafeMutablePointer<CChar> {
        return UnsafeMutablePointer<CChar>(mutating: self.asCStringPointer)
    }
}
