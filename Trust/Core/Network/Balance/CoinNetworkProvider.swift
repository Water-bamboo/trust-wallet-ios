// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore
import PromiseKit
import BigInt
import APIKit
import JSONRPCKit

final class CoinNetworkProvider: BalanceNetworkProvider {

    let server: RPCServer
    let address: Address
    let addressUpdate: EthereumAddress

    init(
        server: RPCServer,
        address: Address,
        addressUpdate: EthereumAddress
    ) {
        self.server = server
        self.address = address
        self.addressUpdate = addressUpdate
        print("CoinNetwork-->init():\(server),address=\(address), addressUpdate=\(addressUpdate)")
    }

    func balance() -> Promise<BigInt> {
        return Promise { seal in
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(BalanceRequest(address: address.description)))

            print("CoinNetwork原生-->balance():\(request)")
            Session.send(request) { result in
                switch result {
                case .success(let balance):
                    print("CoinNetwork-->balance()--->success:\(balance)")
                    seal.fulfill(balance.value)
                case .failure(let error):
                    print("CoinNetwork-->balance()--->failure:\(error)")
                    seal.reject(error)
                }
            }
        }
    }
}
