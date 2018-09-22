//
//  State.swift
//  CurrencyConverter
//
//  Created by Guowei Mo on 22/09/2018.
//  Copyright © 2018 Guowei Mo. All rights reserved.
//

import Foundation

enum RatesState {
  case initial(rates: [DisplayRate])
  case refresh(rates: [DisplayRate])
  case failToLoad(Error?)
  case loading
}
