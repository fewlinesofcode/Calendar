//
//  Protocols.swift
//  Organizer
//
//  Created by Oleksandr Glagoliev on 14/10/2017.
//  Copyright © 2017 io.limlab. All rights reserved.
//

import UIKit

protocol CalendarLayoutDataSource: class {
    var numberOfColumns: Int { get }
    func contentTypeForCell(at indexPath: IndexPath) -> CalendarContent?
}

