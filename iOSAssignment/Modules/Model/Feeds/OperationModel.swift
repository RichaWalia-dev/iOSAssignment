//
//  OperationModel.swift
//  iOSAssignment
//
//  Created by Richa Walia on 10/10/19.
//  Copyright © 2019 Richa Walia. All rights reserved.
//

import Foundation

class OperationModel  {
    var item: Int
    var operation:Operation
    
    init(item:Int , operation: Operation) {
        self.item = item
        self.operation = operation
    }
}
