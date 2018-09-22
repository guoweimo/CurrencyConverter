
import XCTest

class CurrencyConverterUITests: XCTestCase {
  let app = XCUIApplication()

  override func setUp() {
    app.launch()
  }
  
  func testRateScreen() {
    verifyCells()
    verifyTypingValue()
    verifyMoveCells()
  }
  
  func verifyCells() {
    let euroCell = app.cells["EUR"]
    XCTAssertTrue(euroCell.waitForExistence(timeout: 3))
  }
  
  func verifyTypingValue() {
    let euroCell = app.cells["EUR"]
    let textfield = euroCell.textFields["rateField"]
    textfield.tap()
    textfield.typeText("0")
    textfield.typeText("X")
    textfield.typeText(".")
    textfield.typeText("5")

    textfield.typeText(XCUIKeyboardKey.return.rawValue)
    XCTAssertEqual(textfield.value as! String, "10.5")
  }
  
  func verifyMoveCells() {
    let cell = app.cells["CNY"]
    cell.tap()
    sleep(2)
    let firstCell = app.cells.element(boundBy: 0)
    XCTAssertEqual(firstCell.label, "CNY")
  }
}
