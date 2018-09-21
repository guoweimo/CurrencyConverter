//
//  Worker.swift
//  CurrencyConverter
//
//  Created by Guowei Mo on 21/09/2018.
//  Copyright © 2018 Guowei Mo. All rights reserved.
//

import Foundation
import RxSwift

protocol Worker {
  associatedtype Result
  
  //work request to be executed in dispatcher
  var request: Request { get }
  
  //execute work request in dispatcher
  func doWork(in dispatcher: Dispatcher) -> Observable<Loadable<Result>>
}
