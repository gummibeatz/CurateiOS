//
//  StackStruct.swift
//  Curate
//
//  Created by Kenneth Kuo on 4/4/15.
//  Copyright (c) 2015 Kenneth Kuo. All rights reserved.
//

import Foundation


struct Stack<T> {
    var items = [T]()
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
}
