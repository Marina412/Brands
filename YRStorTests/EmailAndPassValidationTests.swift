//
//  EmailAndPassValidationTests.swift
//  YRStorTests
//
//  Created by Huda kamal  on 22/06/2023.
//

import XCTest
@testable import YRStor
final class EmailAndPassValidationTests: XCTestCase {
    let validation = RegisterViewController()
    
    func testValidPassword() {
        XCTAssertTrue(validation.isValidPassword("Abc12345"))
       }

       func testInvalidPassword() {
           XCTAssertFalse(validation.isValidEmail("test@example."))
       }
    
    func testInvalidPhoneNumber() {
        XCTAssertTrue(validation.isValidPhoneNumber("1234567891"))
        }

}
