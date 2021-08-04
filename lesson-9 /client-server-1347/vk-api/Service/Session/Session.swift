//
//  Session.swift
//  client-server-1347
//
//  Created by Artur Igberdin on 12.07.2021.
//

import Foundation

final class Session {
    
    static let shared = Session()
    
    private init() {}
    
    var token = ""
    var userId = ""
}
