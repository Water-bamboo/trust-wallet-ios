// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import BigInt
import TrustCore

struct UnconfirmedTransaction {
    let transfer: Transfer
    let value: BigInt
    let to: EthereumAddress?
    let data: Data?//hart:用户自由定义的内容

    let gasLimit: BigInt?
    let gasPrice: BigInt?
    let nonce: BigInt?
}
