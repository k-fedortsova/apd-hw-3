import UIKit
import SnapKit

final class StudentDetailViewController: UIViewController {
    private let store: StudentStore
    private let studentID: UUID
    private let scrollView = UIScrollView()
    private let content = UIStackView()

    init(store: StudentStore, studentID: UUID) {
        self.store = store
        self.studentID = studentID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("Use init(store:studentID:)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Student Details"
        scrollView.accessibilityIdentifier = "studentDetails"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain,
                                                              target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "editStudentButton"
        view.addSubview(scrollView)
        scrollView.addSubview(content)
        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        content.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide).inset(20)
            make.width.equalTo(scrollView.frameLayoutGuide).offset(-40)
        }
        content.axis = .vertical
        content.spacing = 14
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        render()
    }

    private func render() {
        content.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let student = store.student(id: studentID) else { return }
        let avatar = UIImageView(image: UIImage(named: student.avatarName) ?? UIImage(systemName: "person.crop.circle"))
        avatar.contentMode = .scaleAspectFit
        content.addArrangedSubview(avatar)
        avatar.snp.makeConstraints { $0.height.equalTo(110) }
        addText(student.name, style: .title1)
        addText("Age: \(student.age)")
        addText("Average grade: \(student.averageGrade)")
        addText("Scholarship: \(student.isScholarshipHolder ? "Yes" : "No")")
        addText("ID: \(student.id.uuidString)", style: .footnote)
        addText("Avatar: \(student.avatarName)", style: .footnote)
        addText("Subjects", style: .headline)
        if student.subjects.isEmpty { addText("No subjects yet") }
        for subject in student.subjects {
            let button = UIButton(type: .system)
            button.setTitle(subject + "  ›", for: .normal)
            button.contentHorizontalAlignment = .leading
            button.titleLabel?.font = .preferredFont(forTextStyle: .body)
            button.accessibilityIdentifier = "subjectButton.\(subject)"
            button.addAction(UIAction { [weak self] _ in
                guard let self else { return }
                self.navigationController?.pushViewController(
                    StudentListViewController(store: self.store, subject: subject), animated: true)
            }, for: .touchUpInside)
            content.addArrangedSubview(button)
        }
    }

    private func addText(_ value: String, style: UIFont.TextStyle = .body) {
        let label = UILabel()
        label.text = value
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        content.addArrangedSubview(label)
    }

    @objc private func editTapped() {
        navigationController?.pushViewController(
            StudentFormViewController(store: store, studentID: studentID), animated: true)
    }
}
