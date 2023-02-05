//
//  Constant.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import UIKit

// MARK: - Screen
public let SCREEN_SIZE = UIScreen.main.bounds.size
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
public let STATUS_BAR_HEIGHT = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0


let apiKey = "0e7274f05c36db12cbe71d9ab0393d47"
let baseUrl = "https://api.themoviedb.org/3/"
let baseImageUrl = "https://image.tmdb.org/t/p/original"
