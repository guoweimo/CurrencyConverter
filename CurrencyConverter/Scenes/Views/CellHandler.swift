import Foundation
import UIKit

protocol CellHandler {
  var select: Action? { get }
  func registerCell(on tableView: UITableView)
  func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
}

protocol TypedCellHandler: CellHandler {
  associatedtype Cell: UITableViewCell
  func prepare(_ cell: Cell)
}

extension TypedCellHandler {
  private var reuseIdentifier: String {
    return NSStringFromClass(Cell.self)
  }
  
  func registerCell(on tableView: UITableView) {
    tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
  }
  
  func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Cell else {
      fatalError("Unexpected cell type")
    }
    return cell
  }
}
