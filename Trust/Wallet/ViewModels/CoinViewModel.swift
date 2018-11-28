// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore

/**
 * all case of default are test
 */
struct CoinViewModel {

    let coin: Coin

    var displayName: String {
        return "\(name) (\(symbol))"
    }

    var name: String {
        switch coin {
        case .bitcoin: return "Bitcoin"
        case .ethereum: return "Ethereum(NAKA)"
        case .ethereumClassic: return "Ethereum Classic"
        case .poa: return "POA Network"
        case .callisto: return "Callisto"
        case .gochain: return "GoChain"
        default: return "TestCoin"
        }
    }

    var symbol: String {
        switch coin {
        case .ethereum: return "ETH"
        case .ethereumClassic: return "ETC"
        case .callisto: return "CLO"
        case .poa: return "POA"
        case .gochain: return "GO"
        case .bitcoin: return "Bitcoin"
        default: return "TestSymb"
        }
    }

    var image: UIImage? {
        switch coin {
        case .bitcoin: return .none
        case .ethereum: return R.image.ethereum_1()
        case .ethereumClassic: return R.image.ethereum61()
        case .poa: return R.image.ethereum99()
        case .callisto: return R.image.ethereum820()
        case .gochain: return R.image.ethereum60()
        default: return R.image.ethereum820()//test
        }
    }

    var walletName: String {
        return name + " " + R.string.localizable.wallet()
    }
}
