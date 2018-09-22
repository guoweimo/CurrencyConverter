//
//  RateEvents.swift
//  CurrencyConverter
//
//  Created by Guowei Mo on 22/09/2018.
//  Copyright © 2018 Guowei Mo. All rights reserved.
//

import Foundation

enum RatesEvent {
  case baseRateChanged(to: String, text: String)
  case baseValueChanged(newValue: String)
}
