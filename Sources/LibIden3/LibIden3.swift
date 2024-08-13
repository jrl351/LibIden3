import Foundation
import os

import CPolygonID

fileprivate typealias GoFunc0 = (UnsafeMutablePointer<UnsafeMutablePointer<PLGNStatus>?>) -> GoUint8

fileprivate typealias GoFunc1 = (UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>,
                                 UnsafeMutablePointer<CChar>,
                                 UnsafeMutablePointer<UnsafeMutablePointer<PLGNStatus>?>) -> GoUint8

fileprivate typealias GoFunc2 = (UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>,
                                 UnsafeMutablePointer<CChar>,
                                 UnsafeMutablePointer<CChar>,
                                 UnsafeMutablePointer<UnsafeMutablePointer<PLGNStatus>?>) -> GoUint8

/// Swift wrapper for the Golang PolygonID library
public enum LibIden3 {
    static func cleanCache() -> String {
        callWithStatus(functionName: #function,
                       goFunction: PLGNCleanCache)
    }
    
    public static func createClaim(input: String) -> String {
        callWithStatus(input: input,
                       functionName: #function,
                       goFunction: PLGNCreateClaim)
    }
    
    static func calculateGenesisID(input: String, config: String) -> String {
        callWithStatus(input1: input,
                       input2: config,
                       functionName: #function,
                       goFunction: PLGNNewGenesisID)
    }
    
    static func calculateGenesisIdFromEth(input: String, config: String) -> String {
        callWithStatus(input1: input,
                       input2: config,
                       functionName: #function,
                       goFunction: PLGNNewGenesisIDFromEth)
    }
    
    static func calculateProfileID(input: String) -> String {
        callWithStatus(input: input,
                       functionName: #function,
                       goFunction: PLGNProfileID)
    }
    
    static func convertIdToBigInt(input: String) -> String {
        callWithStatus(input: input,
                       functionName: #function,
                       goFunction: PLGNIDToInt)
    }
    
    static func getWitnessInputs(input: String) -> String {
        callWithStatus(input: input,
                       functionName: #function,
                       goFunction: PLGNAuthV2InputsMarshal)
    }
    
    static func getSigProofInputs(input: String, config: String) -> String {
        callWithStatus(input1: input,
                       input2: config,
                       functionName: #function,
                       goFunction: PLGNAtomicQuerySigV2Inputs)
    }
    
    static func getMtpProofInputs(input: String, config: String) -> String {
        callWithStatus(input1: input,
                       input2: config,
                       functionName: #function,
                       goFunction: PLGNAtomicQueryMtpV2Inputs)
    }
    
    static func getSigOnChainProofInputs(input: String, config: String) -> String {
        callWithStatus(input1: input,
                       input2: config,
                       functionName: #function,
                       goFunction: PLGNAtomicQuerySigV2OnChainInputs)
    }
    
    static func getV3Inputs(input: String, config: String) -> String {
        callWithStatus(input1: input,
                       input2: config,
                       functionName: #function,
                       goFunction: PLGNAtomicQueryV3Inputs)
    }
    
    static func getV3OnChainInputs(input: String, config: String) -> String {
        callWithStatus(input1: input,
                       input2: config,
                       functionName: #function,
                       goFunction: PLGNAtomicQueryV3OnChainInputs)
    }
    
    static func getMtpOnChainProofInputs(input: String, config: String) -> String {
        callWithStatus(input1: input,
                       input2: config,
                       functionName: #function,
                       goFunction: PLGNAtomicQueryMtpV2OnChainInputs)
    }
    
    static func proofFromSmartContract(input: String) -> String {
        callWithStatus(input: input,
                       functionName: #function,
                       goFunction: PLGNProofFromSmartContract)
    }
    
    private static func callWithStatus(functionName: String, goFunction: GoFunc0) -> String {
        Logger().debug("Calling function \(functionName)")
        
        var status: UnsafeMutablePointer<PLGNStatus>? = nil
        defer {
            status?.deallocate()
        }
        
        let res = goFunction(&status)
        
        if (res == 0) {
            consumeStatus(status: status)
        }
        return ""
    }
    
    private static func callWithStatus(input: String, functionName: String, goFunction: GoFunc1) -> String {
        Logger().debug("Calling function \(functionName)")
        Logger().debug("Input: \(input)")
        
        var response: UnsafeMutablePointer<CChar>? = nil
        defer {
            response?.deallocate()
        }
        
        let inputCString = input.asUnsafeCStringPointer
        
        var status: UnsafeMutablePointer<PLGNStatus>? = nil
        defer {
            status?.deallocate()
        }
        
        let res = goFunction(&response, inputCString, &status)
        
        return processResult(res: res, response: response, status: status, functionName: functionName)
    }
    
    private static func callWithStatus(input1: String,
                                       input2: String,
                                       functionName: String,
                                       goFunction: GoFunc2) -> String {
        Logger().debug("Calling function \(functionName)")
        Logger().debug("Input1: \(input1)")
        Logger().debug("Input2: \(input2)")
        
        var response: UnsafeMutablePointer<CChar>? = nil
        defer {
            response?.deallocate()
        }
        
        let input1CString = input1.asUnsafeCStringPointer
        let input2CString = input2.asUnsafeCStringPointer
        
        var status: UnsafeMutablePointer<PLGNStatus>? = nil
        defer {
            status?.deallocate()
        }
        
        let res = goFunction(&response, input1CString, input2CString, &status)
        
        return processResult(res: res, response: response, status: status, functionName: functionName)
    }
    
    private static func processResult(res: GoUint8,
                                      response: UnsafeMutablePointer<CChar>?,
                                      status: UnsafeMutablePointer<PLGNStatus>?,
                                      functionName: String) -> String {
        if (res == 0) {
            consumeStatus(status: status)
        }
        guard let response = response else {
            Logger().log("Unexpected null response from \(functionName)")
            return ""
        }
        
        guard let responseString = String(validatingUTF8: response) else {
            Logger().log("Unparsable response from \(functionName)")
            return ""
        }
        
        return responseString
    }
    
    private static func consumeStatus(status: UnsafeMutablePointer<PLGNStatus>?,
                                      message: String = "") {
        guard let status else {
            Logger().log("Unable to allocate status!")
            return
        }
        
        let statusValue = status.pointee.status.rawValue
        if statusValue >= 0 {
            let msg: String
            if (message.isEmpty) {
                msg = "status is not OK with code \(statusValue)"
            } else {
                msg = message
            }
            
            let json = String(validatingUTF8:  status.pointee.error_msg) ?? ""
            
            let errorMsg = "\(msg): \(json)"
            Logger().log("\(statusValue): \(errorMsg)")
            
        }
    }
}

extension LibIden3 {
    public static func callLibIden3<T: Codable>(request: Codable,
                                                name: String,
                                                function: (String) -> String) -> T? {
        guard let requestString = request.toJson() else {
            Logger().log("Error creating request string for \(name)")
            return nil
        }
        
        let responseString = function(requestString)
        guard let response = T(json: responseString) else {
            Logger().log("Error parsing the response for \(name): \(responseString)")
            return nil
        }
        return response
    }
    
    public static func callLibIden3<T: Codable>(request: Codable,
                                                config: Codable,
                                                name: String,
                                                function: (String, String) -> String) -> T? {
        guard let requestString = request.toJson() else {
            Logger().log("Error creating request string for \(name)")
            return nil
        }
        guard let configString = config.toJson() else {
            Logger().log("Error creating config string for \(name)")
            return nil
        }
        
        let responseString = function(requestString, configString)
        guard let response = T(json: responseString) else {
            Logger().log("Error parsing the response for \(name): \(responseString)")
            return nil
        }
        return response
    }
}
