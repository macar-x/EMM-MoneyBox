# Cashlens Backend

Go-based backend with CLI and REST API for personal finance management.

## Quick Start

### Prerequisites
- Go 1.21+
- MongoDB or MySQL database

### Setup

1. Set environment variables:
```bash
export DB_TYPE=mongodb
export MONGO_DB_URI="mongodb://cashlens:cashlens123@localhost:27017/cashlens?authSource=admin"
export DB_NAME=cashlens
```

2. Build:
```bash
go build -o cashlens main.go
```

3. Run:
```bash
./cashlens --help
```

## Documentation

- **[CLI Reference](docs/CLI.md)** - Complete CLI command reference with quick start
- **[API Reference](docs/API.md)** - API endpoints and implementation tasks
- **[Testing Guide](docs/TESTING.md)** - Backend testing guide

## CLI Commands

### Server
```bash
# Start API server
cashlens server start -p 8080
```

### Cash Flow
```bash
# Add expense
cashlens cash outcome -c "Food" -a 45.50 -d "Lunch"

# Add income
cashlens cash income -c "Salary" -a 5000

# Query transactions
cashlens cash query -b 2024-01-15
```

### Categories
```bash
# Create category
cashlens category create -n "Food & Dining"

# List categories
cashlens category list
```

### Data Management
```bash
# Export to Excel
cashlens manage export -o data.xlsx

# Import from Excel
cashlens manage import -i data.xlsx

# Show statistics
cashlens manage stats
```

See [CLI Reference](docs/CLI.md) for complete documentation.

## REST API

Start the server:
```bash
cashlens server start -p 8080
```

### Available Endpoints

**Cash Flow**:
- `POST /api/cash/outcome` - Create expense
- `POST /api/cash/income` - Create income
- `GET /api/cash/{id}` - Query by ID
- `GET /api/cash/date/{date}` - Query by date
- `DELETE /api/cash/{id}` - Delete by ID
- `DELETE /api/cash/date/{date}` - Delete by date

**Health**:
- `GET /api/health` - Health check
- `GET /api/version` - Version info

See [API Reference](docs/API.md) for planned endpoints.

## Project Structure

```
backend/
├── cmd/                    # CLI commands (Cobra)
│   ├── cash_flow_cmd/     # Cash flow commands
│   ├── category_cmd/      # Category commands
│   ├── manage_cmd/        # Data management commands
│   ├── server_cmd/        # Server commands
│   ├── db_cmd/            # Database commands
│   └── root.go            # Root command
├── controller/            # HTTP controllers
├── service/               # Business logic
├── mapper/                # Data mappers
├── model/                 # Data models
├── middleware/            # HTTP middleware
├── util/                  # Utilities
└── main.go               # Entry point
```

## Development

### Build
```bash
go build -o cashlens main.go
```

### Build with version info
```bash
go build -ldflags "\
  -X github.com/macar-x/cashlens/cmd.Version=1.0.0 \
  -X github.com/macar-x/cashlens/cmd.BuildTime=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
  -X github.com/macar-x/cashlens/cmd.GitCommit=$(git rev-parse --short HEAD)" \
  -o cashlens main.go
```

### Run tests
```bash
go test ./...
```

## Configuration

See [Environment Configuration](../docs/ENVIRONMENT.md) for detailed setup.

## Testing

See [Testing Guide](docs/TESTING.md) for complete testing instructions.

## Dependencies

- [cobra](https://github.com/spf13/cobra) - CLI framework
- [gorilla/mux](https://github.com/gorilla/mux) - HTTP router
- [zap](https://github.com/uber-go/zap) - Structured logging
- [excelize](https://github.com/qax-os/excelize) - Excel import/export
- [decimal](https://github.com/shopspring/decimal) - Precise decimal calculations
- [mongo-go-driver](https://github.com/mongodb/mongo-go-driver) - MongoDB driver
- [go-sql-driver](https://github.com/go-sql-driver/mysql) - MySQL driver

## License

See [LICENSE](../LICENSE) file for details.
