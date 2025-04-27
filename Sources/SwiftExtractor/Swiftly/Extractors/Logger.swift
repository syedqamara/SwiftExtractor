//
//  File.swift
//  SwiftExtractor
//
//  Created by Qammar Abbas on 27/04/2025.
//

import Foundation

private let isLoggingEnabled: Bool = false

public func logs(_ string: String, _ string2: String) {
    guard isLoggingEnabled, string.isNotEmpty || string2.isNotEmpty else { return }
    print("|🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻🔻|")
    if string.isNotEmpty {
        print("| \(string) ||")
    }
    if string2.isNotEmpty {
        print("| \(string2) ||")
    }
    print("|🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺🔺|")
}

