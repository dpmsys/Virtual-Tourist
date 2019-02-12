//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by David Mulvihill on 2/8/19.
//  Copyright © 2019 David Mulvihill. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
