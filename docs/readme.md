# Cashlens Documentation

**Project-level documentation for Cashlens - See your money clearly**

---

## 📁 Documentation Structure

```
docs/
├── readme.md              # This file - documentation index
├── roadmap.md             # Version-based development roadmap
├── environment.md         # Environment configuration guide
└── docker.md              # Docker setup and usage

backend/docs/
├── cli.md                 # Complete CLI reference
├── api.md                 # API reference
├── api_test_guide.md      # API testing manual
├── test_validation_report.md  # Code validation report
├── cli_testing_guide.md   # CLI testing guide
└── testing.md             # Backend testing overview

flutter/docs/
├── setup.md               # Platform setup guide
└── testing.md             # Flutter testing guide
```

---

## 🗺️ Development Roadmap

### [roadmap.md](roadmap.md)
**Complete version-based development plan**

- **Version 1.0** ✅ - Initial CLI implementation
- **Version 1.5** ✅ - Performance refactoring (825x faster)
- **Version 2.0** ✅ - Complete REST API (21 endpoints)
- **Version 2.1** 🚧 - Mapper enhancements
- **Version 3.0** 🎯 - Flutter application
- **Version 3.5** 📋 - Testing & quality
- **Version 4.0** 🚀 - Modern patterns & resilience
- **Version 5.0** 🌟 - Advanced features

---

## ⚙️ Setup & Configuration

### [environment.md](environment.md)
**Environment configuration guide**

Topics covered:
- Environment variables
- Database setup (MongoDB/MySQL)
- API server configuration
- Flutter environment setup
- Connection strings and credentials

### [docker.md](docker.md)
**Docker setup and usage**

Topics covered:
- Docker Compose configuration
- MongoDB and MySQL containers
- Demo data initialization
- Container management
- Development workflow

---

## 🔧 Backend Documentation

### [backend/docs/cli.md](../backend/docs/cli.md)
**Complete CLI reference**

Topics covered:
- Quick start guide
- All 23 commands and flags
- Examples and workflows
- Cash flow operations
- Category management
- Data import/export
- Database utilities

### [backend/docs/api.md](../backend/docs/api.md)
**REST API reference**

Topics covered:
- 21 API endpoints
- Request/response formats
- Authentication (future)
- Error handling
- Implementation status

### [backend/docs/api_test_guide.md](../backend/docs/api_test_guide.md)
**Complete API testing manual** (New in v2.0)

Topics covered:
- Phase-by-phase testing strategy
- Curl commands for all 21 endpoints
- Expected request/response examples
- Test results checklist
- Common issues and solutions
- Performance testing

### [backend/docs/test_validation_report.md](../backend/docs/test_validation_report.md)
**Code validation report** (New in v2.0)

Topics covered:
- Mapper layer validation (100%)
- Service layer validation (100%)
- Controller layer validation (100%)
- Route registration verification
- Feature completeness matrix
- Implementation statistics

### [backend/docs/testing.md](../backend/docs/testing.md)
**Backend testing overview**

Topics covered:
- CLI testing
- API testing
- Database testing
- Integration testing
- Test coverage

### [backend/docs/cli_testing_guide.md](../backend/docs/cli_testing_guide.md)
**CLI testing guide**

Topics covered:
- Command-by-command testing
- Expected outputs
- Error cases
- Edge cases

---

## 📱 Flutter Documentation

### [flutter/docs/setup.md](../flutter/docs/setup.md)
**Platform setup guide**

Topics covered:
- Web, Android, iOS platforms
- Windows, Linux, macOS platforms
- Platform-specific requirements
- Build and run instructions
- Troubleshooting

### [flutter/docs/testing.md](../flutter/docs/testing.md)
**Flutter testing guide**

Topics covered:
- Unit testing
- Widget testing
- Integration testing
- Golden tests
- Test coverage

---

## 📝 Internal Documentation


**Recent highlights**:
- December 5, 2024: Performance refactoring complete (825x faster)
- December 12, 2025: Complete REST API implementation

---

## 🚀 Quick Start Guide

### 1. Environment Setup
```bash
# Read environment guide
cat docs/environment.md

# Set up database
docker-compose up -d mongodb

# Configure environment variables
export DB_TYPE=mongodb
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
```

### 2. Backend Development
```bash
# Build backend
cd backend
go build -o cashlens .

# Test CLI
./cashlens version
./cashlens db connect

# Start API server
./cashlens server start -p 8080

# Test API
curl http://localhost:8080/api/health
```

### 3. API Testing
```bash
# Follow comprehensive guide
cat backend/docs/api_test_guide.md

# Quick test
curl http://localhost:8080/api/version
```

### 4. Flutter Development
```bash
# Read setup guide
cat flutter/docs/setup.md

# Run Flutter app
cd flutter
flutter run -d web
```

---

## 📚 Documentation Guidelines

### When Adding New Documentation

**Project-level docs** → `docs/`
- Configuration, setup, roadmap
- Affects entire project
- Keep filenames lowercase

**Backend docs** → `backend/docs/`
- CLI, API, testing guides
- Backend-specific information
- Keep filenames lowercase

**Flutter docs** → `flutter/docs/`
- Setup, testing, platform guides
- Flutter-specific information
- Keep filenames lowercase


### File Naming Convention
- All documentation filenames must be lowercase
- Use underscores for spaces: `api_test_guide.md`
- Use descriptive names: `environment.md` not `env.md`

### Cross-References
- Use relative paths: `../backend/docs/api.md`
- Keep links updated when moving files
- Test links after reorganization

---

## 🔗 External Resources

### Backend
- [Backend README](../backend/README.md)
- [Go Documentation](https://golang.org/doc/)
- [MongoDB Manual](https://docs.mongodb.com/manual/)
- [MySQL Documentation](https://dev.mysql.com/doc/)

### Flutter
- [Flutter README](../flutter/README.md)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language](https://dart.dev/guides)
- [Material Design](https://material.io/design)

### Project
- [Main README](../README.md)
- [License](../LICENSE)
- [Contributing Guide](../CONTRIBUTING.md) (future)

---

## 📊 Current Status (v2.0)

**Backend**: ✅ Complete
- 21 API endpoints functional
- 100% feature parity with CLI
- Both MongoDB & MySQL supported
- Pagination & filtering
- 95% code correctness validated

**Flutter**: 🚧 In Progress
- Project structure complete
- Demo UI implemented
- API integration pending
- 6 platforms configured

**Documentation**: ✅ Complete
- All docs reorganized
- Lowercase filenames
- Unified roadmap
- Comprehensive test guides

---

## 🎯 Next Steps

1. **Test the API** → Follow [api_test_guide.md](../backend/docs/api_test_guide.md)
2. **Integrate Flutter** → Start with dashboard API calls
3. **Implement Version 2.1** → Mapper enhancements
4. **Complete Version 3.0** → Full Flutter app

---

**Last Updated**: December 12, 2025
**Version**: 2.0 (Backend API Complete)
