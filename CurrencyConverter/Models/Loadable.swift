//
//  Loadable.swift
//  CurrencyConverter
//
//  Created by Guowei Mo on 21/09/2018.
//  Copyright © 2018 Guowei Mo. All rights reserved.
//

import Foundation

enum Loadable<Data> {
  case loading
  case loaded(Data)
  case failed(Error?)
}
