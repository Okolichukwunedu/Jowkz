//
//  APIResponses.swift
//  Jowkz
//
//  Created by Okoli-Chinedu on 16/11/2022.
//  Copyright © 2022 Okoli-Chinedu. All rights reserved.
//

import Foundation
import UIKit

struct Joke: Codable {
    let id: String
    let joke: String
    let status: Int
}
