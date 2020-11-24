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
    public let wineID: String
    public let title: String
    public let location: String
    public let price: Float
    public let vintage: String
    public let quantity: Int
    public let wineBarcode: String
    public let size: String
    public let valuation: Float
    public let currency: String
    public let locale: String
    public let country: String
    public let region: String
    public let subRegion: String
    public let appellation: String
    public let producer: String
    public let sortProducer: String
    public let type: WineType

    public let varietal: String
    public let masterVarietal: String
    public let designation: String
    public let vineyard: String
    public let ct: String?
    public let upc: String?
    public let beginConsume: Int?
    public let endConsume: Int?

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
