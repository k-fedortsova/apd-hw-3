import UIKit
import SnapKit

final class StudentCell: UITableViewCell {
    static let reuseID = "StudentCell"

    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let scholarshipLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }

    required init?(coder: NSCoder) { fatalError("Use init(style:reuseIdentifier:)") }

    private func buildLayout() {
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 25
        avatar.backgroundColor = .tertiarySystemFill

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.textColor = .secondaryLabel
        scholarshipLabel.font = .preferredFont(forTextStyle: .caption1)
        scholarshipLabel.adjustsFontForContentSizeCategory = true
        scholarshipLabel.textColor = .secondaryLabel

        let labels = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel, scholarshipLabel])
        labels.axis = .vertical
        labels.spacing = 3
        contentView.addSubview(avatar)
        contentView.addSubview(labels)

        avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }
        labels.snp.makeConstraints { make in
            make.leading.equalTo(avatar.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
        }
        contentView.snp.makeConstraints { make in make.height.greaterThanOrEqualTo(76) }
        accessoryType = .disclosureIndicator
    }

    func configure(with student: Student) {
        avatar.image = UIImage(named: student.avatarName) ?? UIImage(systemName: "person.crop.circle.fill")
        nameLabel.text = student.name
        subtitleLabel.text = "Age: \(student.age)  •  Grade: \(student.averageGrade.formatted(.number.precision(.fractionLength(1))))"
        scholarshipLabel.text = student.isScholarshipHolder ? "Scholarship holder" : "No scholarship"
        accessibilityIdentifier = "studentCell.\(student.id.uuidString)"
        accessibilityLabel = "\(student.name), age \(student.age), average grade \(student.averageGrade), \(student.isScholarshipHolder ? "scholarship holder" : "no scholarship")"
    }
}
