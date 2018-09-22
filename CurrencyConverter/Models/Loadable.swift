
import Foundation

//fundamental type for response from HTTP request
enum Loadable<Data> {
  case loading
  case loaded(Data)
  case failed(Error?)
}
