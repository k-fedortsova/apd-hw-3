import UIKit
import SnapKit

final class StudentFormViewController: UIViewController {
    private let store: StudentStore
    private let studentID: UUID?
    private let nameField = UITextField()
    private let ageField = UITextField()

    init(store: StudentStore, studentID: UUID?) {
        self.store = store
        self.studentID = studentID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("Use init(store:studentID:)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = studentID == nil ? "Add Student" : "Edit Student"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done,
                                                              target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "saveStudentButton"

        nameField.placeholder = "Full name"
        nameField.borderStyle = .roundedRect
        nameField.textContentType = .name
        nameField.accessibilityIdentifier = "studentNameField"
        ageField.placeholder = "Age"
        ageField.borderStyle = .roundedRect
        ageField.keyboardType = .numberPad
        ageField.accessibilityIdentifier = "studentAgeField"

        let fields = UIStackView(arrangedSubviews: [nameField, ageField])
        fields.axis = .vertical
        fields.spacing = 16
        view.addSubview(fields)
        fields.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        if let studentID, let student = store.student(id: studentID) {
            nameField.text = student.name
            ageField.text = String(student.age)
        }
    }

    @objc private func saveTapped() {
        guard let ageText = ageField.text, let age = Int(ageText) else {
            showValidation("Please enter a valid age.")
            return
        }
        do {
            if let studentID {
                try store.updateStudent(id: studentID, name: nameField.text ?? "", age: age)
            } else {
                try store.addStudent(name: nameField.text ?? "", age: age)
            }
            navigationController?.popViewController(animated: true)
        } catch {
            showValidation("Enter a non-empty name and a positive age.")
        }
    }

    private func showValidation(_ message: String) {
        let alert = UIAlertController(title: "Invalid student", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
