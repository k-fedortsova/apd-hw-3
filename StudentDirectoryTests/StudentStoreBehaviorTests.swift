import XCTest
@testable import StudentDirectory

final class StudentStoreBehaviorTests: XCTestCase {
    func testInitialStudentsHaveTenEntries() {
        XCTAssertEqual(StudentStore().students.count, 10)
    }

    func testSubjectFilterKeepsOriginalOrder() {
        let store = StudentStore()
        let expected = store.students.filter { $0.subjects.contains("Math") }
        XCTAssertEqual(store.students(for: "Math"), expected)
    }

    func testSubjectFilterIsCaseSensitive() {
        XCTAssertTrue(StudentStore().students(for: "math").isEmpty)
    }

    func testAddStudentUsesBonusDefaults() throws {
        let store = StudentStore(students: [])
        try store.addStudent(name: "  New Student  ", age: 19)
        XCTAssertEqual(store.students.first?.name, "New Student")
        XCTAssertEqual(store.students.first?.averageGrade, 0)
        XCTAssertEqual(store.students.first?.subjects, [])
    }

    func testEmptyNameDoesNotMutateStore() {
        let store = StudentStore()
        XCTAssertThrowsError(try store.addStudent(name: "  ", age: 20))
        XCTAssertEqual(store.students.count, 10)
    }

    func testInvalidAgeDoesNotMutateStore() {
        let store = StudentStore()
        XCTAssertThrowsError(try store.addStudent(name: "Someone", age: 0))
        XCTAssertEqual(store.students.count, 10)
    }

    func testEditingPreservesUnchangedFields() throws {
        let store = StudentStore()
        let before = try XCTUnwrap(store.students.first)
        try store.updateStudent(id: before.id, name: "Edited", age: 30)
        let after = try XCTUnwrap(store.student(id: before.id))
        XCTAssertEqual(after.subjects, before.subjects)
        XCTAssertEqual(after.averageGrade, before.averageGrade)
        XCTAssertEqual(after.name, "Edited")
    }

    func testDeleteRemovesOnlySelectedStudent() throws {
        let store = StudentStore()
        let id = try XCTUnwrap(store.students.first?.id)
        try store.deleteStudent(id: id)
        XCTAssertNil(store.student(id: id))
        XCTAssertEqual(store.students.count, 9)
    }

    func testUnknownIDThrowsWithoutChangingStore() {
        let store = StudentStore()
        XCTAssertThrowsError(try store.deleteStudent(id: UUID()))
        XCTAssertEqual(store.students.count, 10)
    }

    func testAddStudentUsesDefaultAvatarAndScholarshipStatus() throws {
        let store = StudentStore(students: [])
        try store.addStudent(name: "New Student", age: 18)

        let added = try XCTUnwrap(store.students.first)
        XCTAssertEqual(added.avatarName, "avatar-default")
        XCTAssertFalse(added.isScholarshipHolder)
        XCTAssertEqual(added.subjects, [])
        XCTAssertEqual(added.averageGrade, 0)
    }

    func testEditingRejectsBlankNameWithoutMutation() throws {
        let store = StudentStore()
        let original = try XCTUnwrap(store.students.first)

        XCTAssertThrowsError(
            try store.updateStudent(id: original.id, name: "   ", age: 25)
        )
        XCTAssertEqual(store.student(id: original.id), original)
    }

    func testEditingRejectsNonPositiveAgeWithoutMutation() throws {
        let store = StudentStore()
        let original = try XCTUnwrap(store.students.first)

        XCTAssertThrowsError(
            try store.updateStudent(id: original.id, name: "Changed", age: 0)
        )
        XCTAssertEqual(store.student(id: original.id), original)
    }

    func testUpdatingUnknownIDDoesNotChangeStore() {
        let store = StudentStore()
        let originalStudents = store.students

        XCTAssertThrowsError(
            try store.updateStudent(id: UUID(), name: "Unknown", age: 20)
        )
        XCTAssertEqual(store.students, originalStudents)
    }
}
