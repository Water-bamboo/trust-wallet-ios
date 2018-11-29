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
    let token = EthereumAddress(string: "0xc891d581be98880cce6a10f26af2e4cf4e730bbb");
    let exchanger = EthereumAddress(string: "0x8102c0ecece895b8fefbddf42b95b7a20925b0c8");
    let exchangeRate = String("0xDE0B6B3A7640000");

    // additinalData
    let localizedObject: LocalizedOperationObject?
}
