# Cashlens

**See your money clearly**

A personal finance management tool for tracking daily cash flow with CLI, REST API, and cross-platform UI.

## Overview

Cashlens helps you manage personal finances by recording income and expenses, categorizing transactions, and generating summaries. Built with Go backend and Flutter frontend, it supports both MongoDB and MySQL databases.

**Key Features**:
- 💰 Track income and expenses
- 📊 Category-based organization
- 📅 Date range queries and summaries
- 📤 Excel import/export
- 🗄️ Multi-database support (MongoDB/MySQL)
- 🚀 High performance (825x faster after optimization)
- 🖥️ Cross-platform UI (Web, Android, iOS, Windows, Linux, macOS)

## Project Structure

```
cashlens/
├── backend/          # Go CLI and REST API
├── flutter/          # Flutter cross-platform UI
├── docs/             # Project documentation
├── docker/           # Docker configurations
└── session.md        # Ona collaboration notes (gitignored)
```

## Quick Start

### 1. Setup Database

Start MongoDB with Docker:
```bash
docker-compose up -d mongodb
```

Or use MySQL:
```bash
docker-compose --profile mysql up -d mysql
```

See [docs/DOCKER.md](docs/DOCKER.md) for detailed setup and demo data.

### 2. Configure Environment

```bash
cp .env.sample .env
# Edit .env with your database credentials
export $(cat .env | xargs)
```

See [docs/ENVIRONMENT.md](docs/ENVIRONMENT.md) for configuration options.

### 3. Run Backend

**CLI Mode**:
```bash
cd backend
go run main.go cash income -a 5000 -b 2024-01-01 -c Salary -d "Monthly salary"
go run main.go cash outcome -a 50 -b 2024-01-02 -c "Food & Dining" -d "Lunch"
go run main.go cash summary -f 2024-01-01 -t 2024-01-31
```

**API Server**:
```bash
cd backend
go run main.go server start -p 8080
```

See [backend/docs/CLI.md](backend/docs/CLI.md) for all CLI commands.

### 4. Run Flutter UI

```bash
cd flutter
flutter run -d chrome
```

See [flutter/docs/SETUP.md](flutter/docs/SETUP.md) for platform-specific setup.

## Documentation

### Getting Started
- [Environment Setup](docs/ENVIRONMENT.md) - Database and configuration
- [Docker Setup](docs/DOCKER.md) - Quick start with Docker
- [Development Roadmap](docs/TODO.md) - Features and tasks

### Backend
- [Backend README](backend/README.md) - Backend overview
- [CLI Reference](backend/docs/CLI.md) - All CLI commands
- [API Reference](backend/docs/API.md) - REST API endpoints
- [Testing Guide](backend/docs/TESTING.md) - Backend testing

### Flutter
- [Flutter README](flutter/README.md) - Flutter overview
- [Platform Setup](flutter/docs/SETUP.md) - Platform-specific guides
- [Testing Guide](flutter/docs/TESTING.md) - Flutter testing

### Technical
- [Refactoring Roadmap](docs/REFACTORING_ROADMAP.md) - Performance improvements and architecture

## Recent Achievements (Dec 2024)

✅ **Backend Refactoring Complete**:
- 825x performance improvement (date range queries)
- Connection pooling and category caching
- 87%+ test coverage
- Thread-safe operations
- Graceful shutdown
- 100% service validation

See [docs/REFACTORING_ROADMAP.md](docs/REFACTORING_ROADMAP.md) for details.

## Architecture

```
┌─────────────────┐
│   Flutter UI    │  (Web, Mobile, Desktop)
└────────┬────────┘
         │ HTTP
┌────────▼────────┐
│   REST API      │  (Go/Gorilla Mux)
└────────┬────────┘
         │
┌────────▼────────┐
│  Service Layer  │  (Business Logic)
└────────┬────────┘
         │
┌────────▼────────┐
│  Mapper Layer   │  (Database Abstraction)
└────────┬────────┘
         │
    ┌────▼────┐
    │ MongoDB │  or  │ MySQL │
    └─────────┘      └───────┘
```

## Development Status

**Backend** (Go):
- ✅ 23 CLI commands (15 fully functional)
- ✅ 6 REST API endpoints operational
- ✅ Connection pooling and caching
- ✅ Validation layer complete
- ✅ 87%+ test coverage

**Frontend** (Flutter):
- ✅ Basic structure and navigation
- ✅ Landing page and dashboard
- ✅ Settings and currency support
- ⏳ Transaction management (in progress)
- ⏳ Category management (planned)
- ⏳ Statistics and reports (planned)

See [docs/TODO.md](docs/TODO.md) for complete roadmap.

## Technology Stack

**Backend**:
- Go 1.21+
- [Cobra](https://github.com/spf13/cobra) - CLI framework
- [Gorilla Mux](https://github.com/gorilla/mux) - HTTP router
- [Zap](https://github.com/uber-go/zap) - Structured logging
- [Excelize](https://github.com/qax-os/excelize) - Excel operations
- MongoDB & MySQL drivers

**Frontend**:
- Flutter 3.x
- Riverpod - State management
- Go Router - Navigation
- Dio - HTTP client
- Material 3 - UI design

## Contributing

When contributing:
1. Read [docs/TODO.md](docs/TODO.md) for current priorities
2. Follow existing code style and patterns
3. Add tests for new features
4. Update documentation as needed
5. Run tests before committing

## License

See [LICENSE](LICENSE) file for details.

## Support

For questions or issues:
- Check documentation in `/docs`
- Review [docs/TODO.md](docs/TODO.md) for known issues
- See [session.md](session.md) for Ona collaboration notes (if working with Ona)
