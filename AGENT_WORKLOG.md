# HW3 Agent Worklog

ChatGPT (GPT-6) was used as an assistant for requirement analysis, implementation drafts, debugging explanations, test drafts and documentation. Xcode, the iOS Simulator, XCTest and Terminal were used for local development and verification.

| Date | Tool/task | Student review | Evidence |
| --- | --- | --- | --- |
| 2026-11-10 | ChatGPT: discussed the HW3 requirements, inspected the task checklist | | |
| 2026-11-11 | ChatGPT: help to write `PLAN.md` | I asked for meaningful example how to make my existing version better. | `PLAN.md` |
| 2026-11-11 | ChatGPT: drafted the initial project structure and Swift files for the student model/store, seed data, reusable cell, list controller, detail controller, subject filtering, form and app startup | I reviewed the generated files in Xcode and reported compiler/runtime problems rather than assuming that generated code worked. I treated the code as a draft that needed local verification | `StudentDirectory/`; Xcode build diagnostics |
| 2026-11-11 | ChatGPT: explained the `override` compiler error in the table-view editing callback and suggested how the base controller should expose the method | I used the compiler diagnostic to identify the exact method that was not declared by the superclass. The inheritance/protocol setup needed to be checked in the actual project before accepting the change | Xcode error in `StudentListViewController.swift` |
| 2026-11-11 | ChatGPT: reviewed the test log | I supplied the full test output, app also showed an empty screen when launched manually, so the issue was not limited to UI-test automation | Test log: starter tests and store tests passed; `StudentDirectoryFeatureUITests` failed |
| 2026-11-11 | ChatGPT: diagnosed the empty screen by checking the app lifecycle path (`StudentDirectoryApp` → `SceneDelegate` → navigation controller → list controller) || |
| 2026-11-11 | ChatGPT: inspected the LLDB `bt` output and identified UIKit's `UIApplicationEvaluateRuntimeIssueForNoSceneLifecycleAdoption` frame as evidence of a scene-lifecycle problem | I provided the full backtrace. This changed the debugging direction from table layout to application scene configuration | LLDB `bt` output; Xcode screenshot showing `EXC_BREAKPOINT` |
| 2026-11-11 | ChatGPT: restored a SceneDelegate-based startup configuration in `StudentDirectoryApp.swift` and `SceneDelegate.swift` | I tried the suggested code and reported the fixed next compiler error. This exposed a mismatch between the suggested singleton access and the actual store API | Xcode compiler error |
| 2026-11-11 | ChatGPT: corrected the store initialization to create `let store = StudentStore()` and pass it into `StudentListViewController` | I applied the initializer-based version. This matches the store API in the project and ensures the list receives the store instance created for the app | `SceneDelegate.swift` |
| 2026-11-12 | ChatGPT: compared the project with the assignment requirements and reviewed base and optional bonus features | I asked for a requirement-by-requirement review, including list, details, subject navigation, accessibility, tests and add/edit/delete. I kept final verification separate from code being present | |
| 2026-11-12 | ChatGPT: help to edit `PLAN.md` and an AI-use workload document with prompt history | I asked for meaningful documentation in the style of the supplied example. I requested that the history reflect my actual work and not invent successful test or CI results | `PLAN.md`; `AGENTIC_WORKLOAD.md` |

## Final review

- **Agent/tool disclosure:** ChatGPT (GPT-6) was used for requirement analysis, implementation and test drafts, debugging explanations and documentation. Xcode, iOS Simulator, XCTest and Terminal were used for local development. No separate coding agent such as Claude Code, Cursor or GitHub Copilot was used in this recorded workflow.
- **Material tasks:** The table records the main prompts and work stages: understanding the assignment, drafting the project, resolving the table-view callback issue, analyzing test failures, diagnosing the blank screen, correcting scene startup, fixing store initialization, reviewing bonus scope and preparing the documentation.
- **Test status:** ** TEST SUCCEEDED **

