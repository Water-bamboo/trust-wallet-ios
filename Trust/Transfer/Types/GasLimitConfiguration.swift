// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import BigInt

public struct GasLimitConfiguration {
    static let `default` = BigInt(100_000)//90_000) harted
    static let min = BigInt(100_000)//21_000) harted
    static let max = BigInt(600_000)
    static let tokenTransfer = BigInt(144_000)
    static let dappTransfer = BigInt(600_000)
}
