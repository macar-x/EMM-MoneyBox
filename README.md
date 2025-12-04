# Cashlens

**See your money clearly**

A personal finance management tool for recording daily cash flow with both CLI and REST API interfaces.

## Project Structure

This is a monorepo containing:
- **`backend/`** - Go/Cobra CLI and REST API server
- **`flutter/`** - Flutter cross-platform UI

## Backend

### Prerequisites
- Go 1.21+
- MongoDB or MySQL database

### Configuration

1. Copy the environment template:
```bash
cp .env.sample .env
```

2. Edit `.env` with your database credentials:
```bash
# For MongoDB
DB_TYPE=mongodb
MONGO_DB_URI=mongodb+srv://username:password@cluster.mongodb.net/cashlens

# For MySQL
DB_TYPE=mysql
MYSQL_DB_URI=username:password@tcp(localhost:3306)/cashlens
```

3. Load environment variables:
```bash
export $(cat .env | xargs)
```

See [ENVIRONMENT.md](ENVIRONMENT.md) for detailed configuration guide.

### CLI Commands

Navigate to `backend/` directory first:
```bash
cd backend
```

#### Cash Flow
```bash
# Record expense
go run main.go cash outcome -a {amount} -b {date} -c {category} -d {description}

# Record income
go run main.go cash income -a {amount} -b {date} -c {category} -d {description}

# Query transactions
go run main.go cash query -h

# Delete transactions
go run main.go cash delete -h
```

#### Data Management
```bash
# Export to Excel
go run main.go manage export -f {from_date} -t {to_date}

# Import from Excel
go run main.go manage import -i {file_path}
```

### REST API

Start the API server:
```bash
cd backend
go run main.go server start -p 8080
```

#### Available Endpoints
- `POST /api/cash/outcome` - Create expense record
- `POST /api/cash/income` - Create income record
- `GET /api/cash/{id}` - Query by ID
- `GET /api/cash/date/{date}` - Query by date
- `DELETE /api/cash/{id}` - Delete by ID
- `DELETE /api/cash/date/{date}` - Delete by date

See [TODO.md](TODO.md) for planned API endpoints.

### Docker

Build and run with Docker Compose:
```bash
cd backend
docker-compose up --build
```

## Flutter UI (Coming Soon)

A cross-platform UI built with Flutter supporting:
- Web (PWA)
- Android
- iOS

See [TODO.md](TODO.md) for the complete development roadmap.

## Development Roadmap

Check [TODO.md](TODO.md) for:
- Planned backend API endpoints
- Flutter UI features
- Future enhancements
- User management plans

## Dependencies

### Backend
- [cobra](https://github.com/spf13/cobra) - CLI framework
- [gorilla/mux](https://github.com/gorilla/mux) - HTTP router
- [zap](https://github.com/uber-go/zap) - Structured logging
- [excelize](https://github.com/qax-os/excelize) - Excel import/export
- [decimal](https://github.com/shopspring/decimal) - Precise decimal calculations
- [go-sql-driver](https://github.com/go-sql-driver/mysql) - MySQL driver
- [mongo-go-driver](https://github.com/mongodb/mongo-go-driver) - MongoDB driver

## License

See [LICENSE](LICENSE) file for details.
