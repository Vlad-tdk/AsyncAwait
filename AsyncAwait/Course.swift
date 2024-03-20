//
//  Course.swift
//  AsyncAwait
//
//  Created by Vlad on 20.3.24..
//

import Foundation

struct Course: Decodable {
    let name: String
    let imageUrl: String
    let numberOfLessons: Int
    let numberOfTests: Int
}
