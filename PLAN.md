# HW3 Student Plan

## Approach

### MVC boundary

- **Model:** `Student`, `StudentSeedData` and the store-related error type. The supplied student properties and seed data should remain consistent with the starter requirements.
- **Store:** `StudentStore` owns the in-memory `[Student]` collection and all data operations. 
- **View:** `StudentCell` and the UI elements used by the list, detail and form screens. SnapKit is used for programmatic layout.
- **Controller:** `StudentListViewController`, `StudentDetailViewController` and `StudentFormViewController` coordinate display, navigation and user actions. Business validation belongs in the store rather than in the cell or view.

### Shared store and initialization

`SceneDelegate` creates one `StudentStore` instance and passes it to the root list controller. The same instance is passed onward when opening details, subject-filtered lists and the add/edit form.

I use initializer injection instead of a global singleton. Lists reload from the store when they appear again, so changes made in a form are visible after navigation returns.

The application uses the scene-based UIKit lifecycle:

1. `StudentDirectoryApp` supplies a scene configuration.
2. The scene configuration registers `SceneDelegate`.
3. `SceneDelegate` creates a `UIWindow` for the `UIWindowScene`.
4. It creates one `StudentStore`.
5. It installs a `UINavigationController` whose root is `StudentListViewController`.
6. The window is made key and visible.

### Student list

The main screen uses a `UITableView` and a reusable `StudentCell`.

Each row should show:
- Student avatar.
- Student name.
- Age.
- Average grade.
- Scholarship status.

### Student details and navigation

Selecting a row pushes `StudentDetailViewController`.

The detail screen displays the student's available model information, including name, age, average grade, scholarship status, ID and subjects. Subject names are presented as buttons. Tapping a subject opens a filtered student list whose navigation title is the selected subject.

The detail controller should identify the student by ID and read the latest value from the store when the screen appears. This avoids relying on a stale copy after editing.

### Subject filtering

The store's `students(matchingSubject:)` method is the single filtering path.

- Matching is exact and case-sensitive.
- The result preserves the original store order.
- A student appears only if their `subjects` array contains the selected subject.
- An unknown subject should produce an empty result rather than a crash.

The filtered screen reuses `StudentListViewController` in subject mode.

### Accessibility and UI

The UI should expose stable accessibility identifiers for the main elements used by UI tests. The expected identifiers include:

- `studentList` — the table view.
- `studentCell.<student-id>` — a student row.
- `studentDetails` — the detail screen.
- `subjectButton.<subject>` — a subject button.
- `addStudentButton` — the add action.
- `editStudentButton` — the edit action.

The form should also expose identifiers for the name field, age field and save action. Labels should remain understandable to VoiceOver. Text should use preferred UIKit text styles and support Dynamic Type where practical.

### Bonus: add, edit and delete

**Add**
- The main list has an Add button.
- The form accepts a name and age.
- The store trims the name and rejects an empty name or age less than or equal to zero.
- A successful add creates a new UUID and uses the required default values: average grade `0`, scholarship `false`, empty subjects and the default avatar.
- The list reloads from the store after returning from the form.

**Edit**
- The detail screen has an Edit button.
- The form is pre-filled with the student's current name and age.
- Only name and age are updated. The student's ID, grade, scholarship status, subjects and avatar must remain unchanged.
- The detail screen reloads the student by ID after the form closes.

**Delete**
- A user can swipe a row to delete a student.
- The controller calls the store using the selected student's ID.
- The table removes the row after the store operation succeeds.

Invalid form input should show a useful validation message and must not mutate the store.

## Milestones

- [x]  Student list and reusable cell
- [x] Detail screen and navigation
- [x] Subject-filtered list
- [x] Unit and UI tests
- [x] Optional add/edit/delete bonus, if attempted
- [x] Local verification and CI review
- [x] Final diff and evidence review

## Verification plan

### Store tests

1. The initial store contains the expected ten students.
2. Filtering returns only students with the selected subject.
3. Filtering preserves store order.
4. Subject matching is case-sensitive.
5. Adding a student assigns the required default values.
6. A blank or whitespace-only name is rejected without changing the store.
7. A non-positive age is rejected without changing the store.
8. Updating a student changes only name and age.
9. Updating an unknown ID reports an error and leaves the store unchanged.
10. Deleting a student removes only the selected student.
11. Deleting an unknown ID reports an error and leaves the store unchanged.

### UI tests

1. The application launches and displays the student list.
2. Selecting a student opens the details screen.
3. Selecting a subject opens a list containing matching students.
4. Adding a valid student makes the new student visible in the list.

Additional bonus checks to perform or add:
- Edit a student and confirm the changed name and age appear.
- Delete a student and confirm the row disappears.
- Submit invalid form values and confirm an error is shown and the data remains unchanged.


The simulator available in my Xcode setup was iPhone Air; iPhone 17 was not available in the destination list. Therefore, the final local test command should use a simulator installed on the machine.

Example:

```bash
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone Air' test
```
The complete test suite was rerun on that final version, all passed.
