# Cashlens Documentation

Project-level documentation for Cashlens.

## Structure

```
docs/
├── README.md              # This file
├── TODO.md                # Development roadmap
├── ENVIRONMENT.md         # Environment configuration
├── DOCKER.md              # Docker setup
└── ona/                   # Internal session summaries

backend/docs/
├── CLI.md                 # CLI reference
├── API.md                 # API reference
└── TESTING.md             # Backend testing

flutter/docs/
├── SETUP.md               # Platform setup
└── TESTING.md             # Flutter testing
```

## Project Documentation

### [TODO.md](TODO.md)
Development roadmap and task tracking:
- Backend API endpoints (planned and implemented)
- Flutter UI features
- Testing tasks
- Future enhancements

### [ENVIRONMENT.md](ENVIRONMENT.md)
Environment configuration guide:
- Environment variables
- Database setup (MongoDB/MySQL)
- API server configuration
- Flutter environment setup

### [DOCKER.md](DOCKER.md)
Docker setup and usage:
- Docker Compose configuration
- MongoDB/MySQL containers
- Demo data initialization
- Container management

## Component Documentation

### Backend (`backend/docs/`)

- **[CLI.md](../backend/docs/CLI.md)** - Complete CLI reference
  - Quick start guide
  - All commands and flags
  - Examples and workflows
  
- **[API.md](../backend/docs/API.md)** - API reference
  - Implemented endpoints
  - Planned endpoints
  - Implementation guide
  
- **[TESTING.md](../backend/docs/TESTING.md)** - Backend testing
  - CLI testing
  - API testing
  - Database testing
  - Integration testing

### Flutter (`flutter/docs/`)

- **[SETUP.md](../flutter/docs/SETUP.md)** - Platform setup
  - Web, Android, iOS, Windows, Linux, macOS
  - Platform-specific requirements
  - Build and run instructions
  - Troubleshooting
  
- **[TESTING.md](../flutter/docs/TESTING.md)** - Flutter testing
  - Unit testing
  - Widget testing
  - Integration testing
  - Golden tests

## Internal Documentation (`ona/`)

The `ona/` subdirectory contains internal session summaries and development notes created by Ona (AI assistant). These are for development reference and not intended for end users.

See [ona/README.md](ona/README.md) for details.

## Quick Links

### Getting Started
1. [Environment Setup](ENVIRONMENT.md)
2. [Docker Setup](DOCKER.md)
3. [Development Roadmap](TODO.md)

### Backend Development
- [Backend README](../backend/README.md)
- [CLI Reference](../backend/docs/CLI.md)
- [API Reference](../backend/docs/API.md)
- [Backend Testing](../backend/docs/TESTING.md)

### Flutter Development
- [Flutter README](../flutter/README.md)
- [Platform Setup](../flutter/docs/SETUP.md)
- [Flutter Testing](../flutter/docs/TESTING.md)

### Project Root
- [Main README](../README.md)
- [License](../LICENSE)

## Contributing

When adding new documentation:

**Project-level docs** → `docs/`
- Configuration, setup, roadmap
- Affects entire project

**Backend docs** → `backend/docs/`
- CLI, API, backend testing
- Backend-specific

**Flutter docs** → `flutter/docs/`
- Setup, testing, platform guides
- Flutter-specific

**Internal notes** → `docs/ona/`
- Session summaries
- Development notes
- Naming: `YYYYMMDD_SESSION_{TOPIC}.md` or `YYYYMMDD_{TOPIC}.md`
