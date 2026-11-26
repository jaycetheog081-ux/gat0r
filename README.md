# 🐊 gat0r

**An experimental rootful jailbreak project for iOS 11.**

gat0r is an independent iOS jailbreak development project targeting iOS 11.0–11.4.1 and supported 64-bit Apple devices.

The goal is to build an alternative to the classic CoolStar jailbreak experience, with an original architecture, interface, and jailbreak implementation.

## Target compatibility

| Component      | Target                   |
| -------------- | ------------------------ |
| Minimum iOS    | 11.0                     |
| Maximum iOS    | 11.4.1                   |
| Architecture   | ARM64                    |
| Devices        | Supported 64-bit devices |
| Jailbreak type | Rootful                  |
| Interface      | UIKit                    |
| Language       | Swift                    |
| Build system   | XcodeGen                 |
| CI             | GitHub Actions           |

Device compatibility must be individually verified. ARM64 support alone does not guarantee exploit compatibility.

## Features and development roadmap

- [x] Swift application foundation
- [x] Device information detection
- [x] Compatibility checks
- [x] Diagnostic logging
- [x] Jailbreak coordinator
- [x] Modular exploit backend interface
- [ ] Working kernel exploit
- [ ] Privileged system integration
- [ ] Rootful bootstrap installation
- [ ] Package manager integration
- [ ] Tweak injection
- [ ] Respring functionality
- [ ] Jailbreak removal

## Project structure

```text
gat0r/
├── project.yml
├── README.md
├── .github/
│   └── workflows/
│       └── build.yml
└── gat0r/
    ├── AppDelegate.swift
    ├── ViewController.swift
    ├── Jailbreak.swift
    ├── DeviceInfo.swift
    └── Logger.swift
```

## Building

The project uses XcodeGen.

### Requirements

- macOS
- Xcode
- XcodeGen
- iOS SDK

### Generate project

```bash
xcodegen generate --spec project.yml
```

### Build

```bash
xcodebuild \
  -project gat0r.xcodeproj \
  -scheme gat0r \
  -configuration Release \
  -sdk iphoneos \
  CODE_SIGNING_ALLOWED=NO \
  build
```

GitHub Actions also provides an automated unsigned IPA build.

## Architecture

gat0r separates its application interface from its jailbreak implementation.

| File                   | Responsibility          |
| ---------------------- | ----------------------- |
| `AppDelegate.swift`    | Application lifecycle   |
| `ViewController.swift` | User interface          |
| `Jailbreak.swift`      | Jailbreak orchestration |
| `DeviceInfo.swift`     | Device compatibility    |
| `Logger.swift`         | Diagnostic logging      |

## Important

gat0r is currently experimental.

The application scaffold does not contain a working kernel exploit or privilege-escalation implementation. The jailbreak interface must not be interpreted as evidence of a successful jailbreak.

Do not use experimental exploit implementations on devices containing important data without appropriate backups.

## Philosophy

gat0r aims to provide an independent, modular, and maintainable alternative to legacy jailbreak projects.

**Independent development. Original implementation. Legacy iOS support.**

## License

License: GPL-3.0
