import Foundation

struct CurrencyRowCellMapping {
  typealias Row = CurrencyRow
  func handler(for row: Row) -> CellHandler {
    switch row.content {
    case .input(let value, let controller):
      return CurrencyTableViewCell.Model(currencyName: row.title, currencyDetail: row.detail, value: value, controller: controller)
    }
  }
}
