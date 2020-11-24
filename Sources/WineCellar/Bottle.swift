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

    public init(wineID: String, title: String, location: String, price: Float, vintage: String, quantity: Int, wineBarcode: String, size: String, valuation: Float, currency: String, locale: String, country: String, region: String, subRegion: String, appellation: String, producer: String, sortProducer: String, type: WineType, varietal: String, masterVarietal: String, designation: String, vineyard: String) {
        self.wineID = wineID
        self.title = title
        self.location = location
        self.price = price
        self.vintage = vintage
        self.quantity = quantity
        self.wineBarcode = wineBarcode
        self.size = size
        self.valuation = valuation
        self.currency = currency
        self.varietal = varietal
        self.locale = locale
        self.appellation = appellation
        self.subRegion = subRegion
        self.region = region
        self.vineyard = vineyard
        self.designation = designation
        self.country = country
        self.producer = producer
        self.sortProducer = sortProducer
        self.type = type
        self.masterVarietal = masterVarietal
    }
    public var wineID: String
    public var title: String
    public var location: String
    public var price: Float
    public var vintage: String
    public var quantity: Int
    public var wineBarcode: String
    public var size: String
    public var valuation: Float
    public var currency: String
    public var locale: String
    public var country: String
    public var region: String
    public var subRegion: String
    public var appellation: String
    public var producer: String
    public var sortProducer: String
    public var type: WineType

    public var varietal: String
    public var masterVarietal: String
    public var designation: String
    public var vineyard: String
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
