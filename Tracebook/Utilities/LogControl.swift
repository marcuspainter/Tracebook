//
//  Utility.swift
//  SoundAnalyzer
//
//  Created by Marcus Painter on 27/11/2023.
//

import Foundation

func disableUIConstraintBasedLayoutLogUnsatisfiable() {
    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
}
