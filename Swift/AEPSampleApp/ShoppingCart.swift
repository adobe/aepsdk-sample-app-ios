/*
 Copyright 2020 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it.
 */

class ShoppingCart {
    private(set) var items: [ProductListItemsItem] = []

    func clearCart() {
        items.removeAll()
    }

    func add(product: ProductListItemsItem) {

        let item = items.filter { $0.sKU == product.sKU && product.sKU != nil }
        if var unwrappedItem = item.first {
            if let unwrappedQuantity = unwrappedItem.quantity {
                unwrappedItem.quantity = unwrappedQuantity + product.quantity!
            } else {
                unwrappedItem.quantity = product.quantity!
            }
        } else {
            items.append(product)
        }
    }
    
    func remove(colorWithName: String) -> Bool {
        guard let index = items.firstIndex(where: { $0.name?.lowercased() == colorWithName.lowercased() }) else { return false }
        items.remove(at: index)
        return true
    }

    var totalQuantity: Double {
        return items.reduce(0) { value, item in
            value + Double(item.quantity!)
        }
    }

    var total: Double {
        return items.reduce(0.0) { value, item in
            value + Double(item.quantity!) * Double(item.priceTotal!)
        }
    }
}
