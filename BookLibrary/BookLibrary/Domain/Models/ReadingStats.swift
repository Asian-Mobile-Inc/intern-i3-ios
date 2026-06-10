//
//  ReadingStats.swift
//  BookLibrary
//
//  Created by Văn Tiến on 05/06/2026.
//

import Foundation

struct ReadingStats {
    let readingCount : Int
    let wantToReadCount  : Int
    let finishedCount  : Int
    
    var total : Int {
        finishedCount  + readingCount  + wantToReadCount
    }
}

extension ReadingStats {
    var wantToReadRatio: CGFloat {
       guard total > 0 else { return 0 }
       return CGFloat(wantToReadCount) / CGFloat(total)
    }

    var readingRatio: CGFloat {
       guard total > 0 else { return 0 }
       return CGFloat(readingCount) / CGFloat(total)
    }

    var finishedRatio: CGFloat {
       guard total > 0 else { return 0 }
       return CGFloat(finishedCount) / CGFloat(total)
    }
}
