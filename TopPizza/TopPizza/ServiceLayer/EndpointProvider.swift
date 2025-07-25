//
//  EndpointProvider.swift
//  TopPizza
//
//  Created by Константин Клинов on 25/07/25.
//

import Foundation

protocol EndpointProvider {
    var endpoints: [URL] { get }
}

class DefaultEndpointProvider: EndpointProvider {
    private let baseURL = "https://free-food-menus-api-two.vercel.app"
    private let paths = [
        "/bbqs", "/best-foods", "/breads", "/burgers",
        "/chocolates", "/desserts", "/drinks", "/fried-chicken",
        "/ice-cream", "/pizzas", "/porks", "/sandwiches",
        "/sausages", "/steaks"
    ]
    
    var endpoints: [URL] {
        paths.compactMap { URL(string: baseURL + $0) }
    }
}
