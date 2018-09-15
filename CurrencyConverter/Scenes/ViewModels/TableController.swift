import Foundation
import UIKit

class TableController {
  private let conformance = TableControllerConformance()
  
  var tableView: UITableView? {
    didSet {
      if let oldValue = oldValue {
        conformance.disassociate(with: oldValue)
      }
      if let tableView = tableView {
        conformance.associate(with: tableView)
      }
    }
  }
  
  var rows: [CellHandler] {
    get {
      return conformance.cellHandlers
    }
    set {
      conformance.cellHandlers = newValue
    }
  }
}

private class TableControllerConformance: NSObject {
  private var tableView: UITableView?
  
  var cellHandlers: [CellHandler] = [] {
    didSet {
      guard let tableView = tableView else {
        return
      }
      cellHandlers.forEach {
        $0.registerCell(on: tableView)
      }
      tableView.reloadData()
    }
  }
  
  func disassociate(with tableView: UITableView) {
    if tableView.delegate === self {
      tableView.delegate = nil
    }
    if tableView.dataSource === self {
      tableView.dataSource = nil
    }
  }
  
  func associate(with tableView: UITableView) {
    self.tableView = tableView
    tableView.delegate = self
    tableView.dataSource = self
    prepare(tableView)
    tableView.reloadData()
  }
  
  private func prepare(_ tableView: UITableView) {
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    tableView.keyboardDismissMode = .onDrag
    tableView.backgroundColor = .clear
  }
}

extension TableControllerConformance: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellHandlers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return cellHandlers[indexPath.row].cell(for: indexPath, in: tableView)
  }
}

extension TableControllerConformance: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    cellHandlers[indexPath.row].select?()
  }
}
