/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

import Foundation

class ProductDataLoader {

    private var productData = [ProductListItemsItem]()

    init() {
        loadProducts()
    }

    func loadProducts() {

        if let jsonFileLocation = Bundle.main.url(forResource: Constants.AEP.COMMERCE_PRODUCTS_FILE, withExtension: "json") {
            let data = try? Data(contentsOf: jsonFileLocation)
            let jsonDecoder = JSONDecoder()
            if let unwrappedData = data {
                if let unwrappedProductDataFromJson = try? jsonDecoder.decode([ProductListItemsItem].self, from: unwrappedData) {
                    self.productData = unwrappedProductDataFromJson
                }
            }
        } else {
            print("Unable to read this file: \(Constants.AEP.COMMERCE_PRODUCTS_FILE)")
        }
    }
    
    func findItem(withName: String) -> ProductListItemsItem? {
        let item = productData.filter { $0.name?.lowercased() == withName.lowercased() }
        return item.first
    }
}
