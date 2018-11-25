// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import JSONRPCKit

struct NKGetRateRequest: JSONRPCKit.Request {
    typealias Response = String

    var method: String {
        return "getRate"
    }

    var parameters: Any? {
        return ["token":"0xf5f3bc1b51815785cdc5e4252aeb7083fc640a59",
                "exchanger":"0xf5f3bc1b51815785cdc5e4252aeb7083fc640a59"]
    }

    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
