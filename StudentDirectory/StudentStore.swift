import Foundation

final class StudentStore {
    private(set) var students: [Student]

    init(students: [Student] = StudentSeedData.students) {
        self.students = students
    }

    func student(id: UUID) -> Student? {
        students.first { $0.id == id }
    }

    func students(for subject: String) -> [Student] {
        students.filter { $0.subjects.contains(subject) }
    }

    // Keep the original API convenient for tests and other callers.
    func students(matchingSubject subject: String) -> [Student] {
        students(for: subject)
    }

    func addStudent(name: String, age: Int) throws {
        let cleanName = try validatedName(name, age: age)
        students.append(Student(id: UUID(), name: cleanName, age: age,
                                averageGrade: 0, isScholarshipHolder: false,
                                subjects: [], avatarName: "avatar-default"))
    }

    func updateStudent(id: UUID, name: String, age: Int) throws {
        let cleanName = try validatedName(name, age: age)
        guard let index = students.firstIndex(where: { $0.id == id }) else {
            throw StudentStoreError.unknownID(id)
        }
        students[index].name = cleanName
        students[index].age = age
    }

    func deleteStudent(id: UUID) throws {
        guard let index = students.firstIndex(where: { $0.id == id }) else {
            throw StudentStoreError.unknownID(id)
        }
        students.remove(at: index)
    }

    private func validatedName(_ name: String, age: Int) throws -> String {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { throw StudentStoreError.blankName }
        guard age > 0 else { throw StudentStoreError.nonPositiveAge }
        return cleanName
    }
}
