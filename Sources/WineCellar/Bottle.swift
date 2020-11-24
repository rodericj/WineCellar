//
//  File.swift
//  
//
//  Created by Roderic Campbell on 11/23/20.
//

import Foundation

public enum WineType: String, Decodable {
    case red = "Red"
    case white = "White"
    case whiteSweetDessert = "White - Sweet/Dessert"
}


public struct Bottle: Decodable {
    public init(bottleTitle: String) {
        self.title = bottleTitle
    }
    public var wineID: String = ""
    public var title: String = "Test"
    public var location: String = ""
    public var price: Float = 0
    public var vintage: String = ""
    public var quantity: Int = 0
    public var wineBarcode: String = ""
    public var size: String = ""
    public var valuation: Float = 0
    public var currency: String = ""
    public var locale: String = ""
    public var country: String = ""
    public var region: String = ""
    public var subRegion: String = ""
    public var appellation: String = ""
    public var producer: String = ""
    public var sortProducer: String = ""
    public var type: WineType = .red

    public var varietal: String = ""
    public var masterVarietal: String = ""
    public var designation: String = ""
    public var vineyard: String = ""
    public var ct: String?
    public var upc: String?
    public var beginConsume: Int?
    public var endConsume: Int?

    enum CodingKeys: String, CodingKey {
        case wineID = "iWine"
        case title = "Wine"
        case location = "Location"
        case price = "Price"
        case vintage = "Vintage"
        case quantity = "Quantity"
        case wineBarcode = "WineBarcode"
        case size = "Size"
        case valuation = "Valuation"
        case currency = "Currency"
        case locale = "Locale"
        case country = "Country"
        case region = "Region"
        case subRegion = "SubRegion"
        case appellation = "Appellation"
        case producer = "Producer"
        case sortProducer = "SortProducer"
        case type = "Type"
        case varietal = "Varietal"
        case masterVarietal = "MasterVarietal"
        case designation = "Designation"
        case vineyard = "Vineyard"
        case ct = "CT"
        case upc = "UPC"
        case beginConsume = "BeginConsume"
        case endConsume = "EndConsume"
    }
}

extension Bottle: CustomStringConvertible {
    public var description: String {
        return "\n\(title) \(price) \(valuation) \(quantity), \(wineBarcode) \(size)"
    }
}
