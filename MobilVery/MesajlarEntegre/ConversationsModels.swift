//
//  KonusmalarModeli.swift
//  MobilVery
//
//  Created by veysel on 8.10.2023.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
