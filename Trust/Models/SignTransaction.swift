// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import BigInt
import TrustCore
import TrustKeystore

public struct SignTransaction {
    let value: BigInt
    let account: Account
    let to: EthereumAddress?
    let nonce: BigInt
    let data: Data //no data
    let gasPrice: BigInt
    let gasLimit: BigInt
    let chainID: Int

    //hart:extra field:
    let token : EthereumAddress?
    let exchanger : EthereumAddress?
    let exchangeRate : BigInt

    // additinalData
    let localizedObject: LocalizedOperationObject?
}
