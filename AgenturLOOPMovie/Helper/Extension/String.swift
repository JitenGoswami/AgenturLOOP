//
//  String.swift
//  AgenturLOOPMovie
//
//  Created by Jitengiri Goswami on 26/02/23.
//

import UIKit

extension String {
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func strReversedWithSeparate(string: String, every stride: Int = 4, with separator: Character = " ") -> String{
        let strReversed = String(string.description.reversed())
        return String(strReversed.separate(every: stride, with: separator).reversed())
    }
}
