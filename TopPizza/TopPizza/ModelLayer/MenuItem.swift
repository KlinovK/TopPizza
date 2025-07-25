//
//  MenuItem.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import SwiftData

@Model
class MenuItem: Identifiable, Decodable {
    var id: String
    var name: String
    var price: Double
    var category: String
    var extra: String?
    var img: String?
    var rate: Double?
    
    // Coding keys to map JSON to our model
    enum CodingKeys: String, CodingKey {
        case id, name, price, category = "country", extra = "dsc", img, rate
    }

    init(id: String, name: String, price: Double, category: String, extra: String? = nil, img: String? = nil, rate: Double? = nil) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.extra = extra
        self.img = img
        self.rate = rate
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let price = try container.decode(Double.self, forKey: .price)
        let category = try container.decode(String.self, forKey: .category)
        let extra = try container.decodeIfPresent(String.self, forKey: .extra)
        let img = try container.decodeIfPresent(String.self, forKey: .img)
        let rate = try container.decodeIfPresent(Double.self, forKey: .rate)

        self.init(id: id, name: name, price: price, category: category, extra: extra, img: img, rate: rate)
    }
}
