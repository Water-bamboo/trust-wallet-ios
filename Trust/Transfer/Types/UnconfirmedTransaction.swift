// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import BigInt
import TrustCore

struct UnconfirmedTransaction {
    var transfer: Transfer
    var value: BigInt
    var to: EthereumAddress?
    var data: Data?

    var gasLimit: BigInt?
    var gasPrice: BigInt?
    var nonce: BigInt?
    //sz:
    var chainId: Int
}
