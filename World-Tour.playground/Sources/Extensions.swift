//
//  Extensions.swift
//  GeneticAlgorithm
//
//  Created by Joel Rorseth on 2018-03-29.
//  Copyright © 2018 Joel Rorseth. All rights reserved.
//

import Foundation

extension MutableCollection {
    
    // Perform an in-place shuffle on the mutable collection
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Double {
    
    /// Rounds to number of decimal places
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
