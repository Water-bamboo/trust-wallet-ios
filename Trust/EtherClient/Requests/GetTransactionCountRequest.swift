// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation
import JSONRPCKit

struct GetTransactionCountRequest: JSONRPCKit.Request {
    typealias Response = BigInt

    let address: String
    let state: String

    var method: String {
        return "eth_getTransactionCount"
    }

    var parameters: Any? {
        print("GetTransactionCountRequest>>parameters=\([address,state,])")
        return [
            address,
            state,
        ]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? String {
            print("GetTransactionCountRequest>>response=\(response)")
            return BigInt(response.drop0x, radix: 16) ?? BigInt()
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
