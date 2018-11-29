// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore
import BigInt
import JSONRPCKit
import APIKit
import PromiseKit

enum SendViewType {
    case address//Receiver
    case amount
    case exchangeRate
}

struct SendViewModel {
    /// stringFormatter of a `SendViewModel` to represent string values with respect of the curent locale.
    lazy var stringFormatter: StringFormatter = {
        return StringFormatter()
    }()
    /// Pair of a `SendViewModel` to represent pair of trade ETH-USD or USD-ETH.
    lazy var currentPair: Pair = {
        return Pair(left: symbol, right: config.currency.rawValue)
    }()
    /// decimals of a `SendViewModel` to represent amount of digits after coma.
    lazy var decimals: Int = {
        switch self.transfer.type {
        case .ether, .dapp:
            return transfer.server.decimals
        case .token(let token):
            return token.decimals
        }
    }()
    /// pairRate of a `SendViewModel` to represent rate of the fiat value to cryptocurrency and vise versa.
    var pairRate: Decimal = 0.0
    /// rate of a `SendViewModel` to represent rate of the fiat value to cryptocurrency and vise versa in string foramt.
    var rate = "0.0"
    /// amount of a `SendViewModel` to represent current amount to send.
    var amount = "0.0"
    /// gasPrice of a `SendViewModel` to represent gas price for send transaction.
    var gasPrice: BigInt? {
        return chainState.gasPrice
    }
    /// transferType of a `SendViewModel` to know if it is token or ETH.
    let transfer: Transfer
    /// config of a `SendViewModel` to know configuration of the current account.
    let config: Config
    let chainState: ChainState
    let storage: TokensDataStore
    /// current wallet balance
    let balance: Balance?
    init(
        transfer: Transfer,
        config: Config,
        chainState: ChainState,
        storage: TokensDataStore,
        balance: Balance?
    ) {
        self.transfer = transfer
        self.config = config
        self.chainState = chainState
        self.storage = storage
        self.balance = balance
    }

    var title: String {
        return "Send \(symbol)"
    }
    var symbol: String {
        return transfer.type.token.symbol
    }
    var backgroundColor: UIColor {
        return .white
    }

    var exchangeRate: String {
        return ""
    }

    var views: [SendViewType] {
        switch transfer.type {
        case .ether, .dapp, .token:
            return [.address, .amount, .exchangeRate]
        }
    }

    /// Convert `pairRate` to localized human readebale string with respect of the current locale.
    ///
    /// - Returns: `String` that represent `pairRate` in curent locale.
    mutating func pairRateRepresantetion() -> String {
        var formattedString = ""
        if currentPair.left == symbol {
            formattedString = stringFormatter.currency(with: pairRate, and: config.currency.rawValue)
        } else {
            formattedString = stringFormatter.token(with: pairRate, and: decimals)
        }
        rate = formattedString
        return  "~ \(formattedString) " + "\(currentPair.right)"
    }
    /// Amount to send.
    ///
    /// - Returns: `String` that represent amount to send.
    mutating func sendAmount() -> String {
        return amount
    }
    /// Maximum amount to send.
    ///
    /// - Returns: `String` that represent amount to send.
    mutating func sendMaxAmount() -> String {
        var max: Decimal? = 0
        switch transfer.type {
        case .ether, .dapp: max = EtherNumberFormatter.full.decimal(from: balance?.value ?? 0, decimals: decimals)
        case .token(let token): max = EtherNumberFormatter.full.decimal(from: token.valueBigInt, decimals: decimals)
        }
        guard let maxAmount = max else {
            return ""
        }
        amount = stringFormatter.token(with: maxAmount, and: decimals)
        updatePairPrice(with: maxAmount)
        return amount
    }
    /// Update of the current pair rate.
    ///
    /// - Parameters:
    ///   - price: Decimal cuurent price of the token.
    ///   - amount: Decimal current amount to send.
    mutating func updatePairRate(with price: Decimal, and amount: Decimal) {
        if currentPair.left == symbol {
            pairRate = amount * price
        } else {
            pairRate = amount / price
        }
    }
    /// Update of the amount to send.
    ///
    /// - Parameters:
    ///   - stringAmount: String fiat string amount.
    mutating func updateAmount(with stringAmount: String) {
        if currentPair.left == symbol {
            amount  = stringAmount.isEmpty ? "0" : stringAmount
        } else {
            //In case of the fiat value we should take pair rate.
            amount  = rate
        }
    }
    /// Update of the pair price with ticker.
    ///
    /// - Parameters:
    ///   - amount: Decimal amount to calculate price.
    mutating func updatePairPrice(with amount: Decimal) {
        guard let price = self.currentPairPrice() else {
            return
        }
        updatePairRate(with: price, and: amount)
    }
    /// Get pair price with ticker
    func currentPairPrice() -> Decimal? {
        guard let currentTokenInfo = storage.coinTicker(by: transfer.type.address), let price = Decimal(string: currentTokenInfo.price) else {
            return nil
        }
        return price
    }
    /// If ther is ticker for this pair show fiat view.
    func isFiatViewHidden() -> Bool {
        guard let currentTokenInfo = storage.coinTicker(by: transfer.type.address), let price = Decimal(string: currentTokenInfo.price), price > 0 else {
            return true
        }
        return false
    }
    /// Convert of the String to Decimal.
    ///
    /// - Parameters:
    ///   - stringAmount: String amount to convert.
    /// - Returns: `Decimal` that represent amount.
    mutating func decimalAmount(with stringAmount: String) -> Decimal {
        return stringFormatter.decimal(with: stringAmount) ?? 0
    }
    /// If ther is need to show max button.
    mutating func isMaxButtonHidden() -> Bool {
        return currentPair.left != symbol
    }

    /// fetch exchange rate:
    func fetchExchangeRate(server: RPCServer) {//}-> Promise<String> {
//        return Promise { seal in
//            let contract = EthereumAddress(string: "0xc891d581be98880cce6a10f26af2e4cf4e730bbb");
//            let encoded = ERC20Encoder.encodeExchangeRate(
//                token: contract!,
//                exchanger: EthereumAddress(string: "0x8102c0ecece895b8fefbddf42b95b7a20925b0c8")!)
//            print("SendViewModel::exchangeRate():encodeBalanceOf=\(encoded)")
//            let request = EtherServiceRequest(
//                for: server,
//                batch: BatchFactory().create(CallRequest(to: contract!.description, data: encoded.hexEncoded))
//            )
//            print("SendViewModel::exchangeRate():request=\(request),contract.desc=\(contract!.description)")
//            Session.send(request) { result in
//                switch result {
//                case .success(let rate):
////                    guard let value = BigInt(balance.drop0x, radix: 16) else {
////                        print("SendViewModel::exchangeRate():seal.reject.00");
////                        return seal.reject(CookiesStoreError.empty)
////                    }
//                    print("SendViewModel::exchangeRate():seal.fulfill=\(rate)");
//                    seal.fulfill(rate)
//                case .failure(let error):
//                    print("SendViewModel::exchangeRate():seal.reject.11");
//                    seal.reject(error)
//                }
//            }
//        }
    }
}
