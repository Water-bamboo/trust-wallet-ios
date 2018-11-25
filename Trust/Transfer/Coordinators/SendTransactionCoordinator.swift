// Copyright DApps Platform Inc. All rights reserved.

import BigInt
import Foundation
import APIKit
import JSONRPCKit
import Result

final class SendTransactionCoordinator {

    private let keystore: Keystore
    let session: WalletSession
    let formatter = EtherNumberFormatter.full
    let confirmType: ConfirmType
    let server: RPCServer

    init(
        session: WalletSession,
        keystore: Keystore,
        confirmType: ConfirmType,
        server: RPCServer
    ) {
        print("SendTransactionCoordinator::init")
        self.session = session
        self.keystore = keystore
        self.confirmType = confirmType
        self.server = server
    }

    func send(
        transaction: SignTransaction,
        completion: @escaping (Result<ConfirmResult, AnyError>) -> Void
    ) {
        print("SendTransactionCoordinator::send")
        if transaction.nonce >= 0 {
            signAndSend(transaction: transaction, completion: completion)
        } else {
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(GetTransactionCountRequest(
                address: transaction.account.address.description,
                state: "latest"
            )))
            Session.send(request) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let count):
                    let transaction = self.appendNonce(to: transaction, currentNonce: count)
                    self.signAndSend(transaction: transaction, completion: completion)
                case .failure(let error):
                    completion(.failure(AnyError(error)))
                }
            }
        }
    }

    private func appendNonce(to: SignTransaction, currentNonce: BigInt) -> SignTransaction {
        print("SendTransactionCoordinator::appendNonce")
        return SignTransaction(
            value: to.value,
            account: to.account,
            to: to.to,
            nonce: currentNonce,
            data: to.data,
            gasPrice: to.gasPrice,
            gasLimit: to.gasLimit,
            chainID: to.chainID,
            localizedObject: to.localizedObject
        )
    }

    private func signAndSend(
        transaction: SignTransaction,
        completion: @escaping (Result<ConfirmResult, AnyError>) -> Void
    ) {
        print("SendTransactionCoordinator::signAndSend:before>>tx=\(transaction)")
        let signedTransaction = keystore.signTransaction(transaction)
        print("SendTransactionCoordinator::signAndSend:after sign tx=\(signedTransaction)")
        switch signedTransaction {
        case .success(let data):
            print("111succeed=\(data)")
            approve(confirmType: confirmType, transaction: transaction, data: data, completion: completion)
        case .failure(let error):
            print("222error=\(error)")
            completion(.failure(AnyError(error)))
        }
    }

    private func approve(confirmType: ConfirmType, transaction: SignTransaction, data: Data, completion: @escaping (Result<ConfirmResult, AnyError>) -> Void) {
        print("SendTransactionCoordinator::approve:data=\(data)")
        let id = data.sha3(.keccak256).hexEncoded
        let sentTransaction = SentTransaction(
            id: id,
            original: transaction,
            data: data
        )
        let dataHex = data.hexEncoded
        switch confirmType {
        case .sign:
            completion(.success(.sentTransaction(sentTransaction)))
        case .signThenSend:
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(SendRawTransactionRequest(signedTransaction: dataHex)))
            print("SendTransactionCoordinator>>request=\(request)")
            Session.send(request) { result in
                switch result {
                case .success:
                    print("SendTransactionCoordinator>>success!!")
                    completion(.success(.sentTransaction(sentTransaction)))
                case .failure(let error):
                    print("SendTransactionCoordinator>>error=\(error)")
                    completion(.failure(AnyError(error)))
                }
            }
        }
    }

    private func approve3(confirmType: ConfirmType, transaction: SignTransaction, data: Data, completion: @escaping (Result<ConfirmResult, AnyError>) -> Void) {
        print("SendTransactionCoordinator::approve:data=\(data)")
        let id = data.sha3(.keccak256).hexEncoded
        let sentTransaction = SentTransaction(
            id: id,
            original: transaction,
            data: data
        )
        let dataHex = data.hexEncoded
        switch confirmType {
        case .sign:
            completion(.success(.sentTransaction(sentTransaction)))
        case .signThenSend:
            let request = EtherServiceRequest(for: server, batch: BatchFactory().create(SendRawTransactionRequest(signedTransaction: dataHex)))
            print("SendTransactionCoordinator>>request=\(request)")
            Session.send(request) { result in
                switch result {
                case .success:
                    print("SendTransactionCoordinator>>success!!")
                    completion(.success(.sentTransaction(sentTransaction)))
                case .failure(let error):
                    print("SendTransactionCoordinator>>error=\(error)")
                    completion(.failure(AnyError(error)))
                }
            }
        }
    }
}
