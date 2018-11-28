// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import JSONRPCKit

struct SendRawTransactionRequest: JSONRPCKit.Request {
    typealias Response = String

    let signedTransaction: String

    var method: String {
        return "eth_sendRawTransaction"
    }

    var parameters: Any? {
        print("SendRawTransactionRequest::signedTransaction=\(signedTransaction)")
        return [
            signedTransaction,
        ]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
