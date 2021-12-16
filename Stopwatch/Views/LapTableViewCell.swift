//
//  LapTableViewCell.swift
//  Stopwatch
//
//  Created by Pedro Fernandez on 12/15/21.
//

import UIKit

class LapTableViewCell: UITableViewCell, StopwatchDelegate {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopwatchFired(_ stopwatch: Stopwatch, elapsedTime: String) {
        self.detailTextLabel?.text = elapsedTime
    }
}
