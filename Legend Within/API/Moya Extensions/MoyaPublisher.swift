//
//  MoyaPublisher.swift
//  Legend Within
//
//  This was copied from Moya's github page where they started implementing combine publishers.
//  As this functionality is not yet officially out, I took it and used it in my own implementation.
//

import Foundation
import Combine
import Moya

internal class MoyaPublisher<Output>: Publisher {
    internal typealias Failure = MoyaError

    private class Subscription: Combine.Subscription {

        private let cancellable: Moya.Cancellable?

        init(subscriber: AnySubscriber<Output, MoyaError>, callback: @escaping (AnySubscriber<Output, MoyaError>) -> Moya.Cancellable?) {
            self.cancellable = callback(subscriber)
        }

        func request(_ demand: Subscribers.Demand) {
            // We don't care for the demand right now
        }

        func cancel() {
            cancellable?.cancel()
        }
    }

    private let callback: (AnySubscriber<Output, MoyaError>) -> Moya.Cancellable?

    init(callback: @escaping (AnySubscriber<Output, MoyaError>) -> Moya.Cancellable?) {
        self.callback = callback
    }

    internal func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(subscriber: AnySubscriber(subscriber), callback: callback)
        subscriber.receive(subscription: subscription)
    }
}
