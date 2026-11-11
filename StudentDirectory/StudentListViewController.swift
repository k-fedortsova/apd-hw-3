import UIKit
import SnapKit

final class StudentListViewController: UIViewController {
    private let store: StudentStore
    private let selectedSubject: String?
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private var visibleStudents: [Student] {
        guard let selectedSubject else { return store.students }
        return store.students(for: selectedSubject)
    }

    init(store: StudentStore, subject: String? = nil) {
        self.store = store
        self.selectedSubject = subject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("Use init(store:subject:)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedSubject ?? "Students"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTable()
        if selectedSubject == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add, target: self, action: #selector(addTapped))
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = "addStudentButton"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func configureTable() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.accessibilityIdentifier = "studentList"
    }

    @objc private func addTapped() {
        let form = StudentFormViewController(store: store, studentID: nil)
        navigationController?.pushViewController(form, animated: true)
    }
}

extension StudentListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleStudents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.reuseID,
                                                        for: indexPath) as? StudentCell else {
            return UITableViewCell()
        }
        cell.configure(with: visibleStudents[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = visibleStudents[indexPath.row]
        let details = StudentDetailViewController(store: store, studentID: student.id)
        navigationController?.pushViewController(details, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let student = visibleStudents[indexPath.row]
        do {
            try store.deleteStudent(id: student.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            tableView.reloadData()
        }
    }
}
