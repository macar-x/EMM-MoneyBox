# Cashlens Development Roadmap

**See your money clearly**

---

## 🎉 Recent Completion (December 5, 2024)

### ✅ Backend Refactoring Complete (Phase 1, 2, 3)
- ✅ **Performance**: 825x faster (date range queries, connection pooling, caching)
- ✅ **Quality**: 100% service validation, 87%+ test coverage
- ✅ **Architecture**: Graceful shutdown, batch operations
- ✅ **Database**: MySQL & MongoDB parity verified

**See**: `docs/REFACTORING_ROADMAP.md` for details

---

## Priority Legend

- **[HIGH]** - Critical for production, should be done soon
- **[MEDIUM]** - Important but not blocking, can be done incrementally
- **[LOW]** - Nice to have, can be deferred based on needs
- **No tag** - Standard priority, do when relevant

---

## Project Structure
- ✅ Reorganize repository into monorepo structure
- ✅ Move backend code into `backend/` folder
- ✅ Update configuration files for new structure
- ✅ Create `flutter/` folder for Flutter UI

---

## Backend Development

### CLI Infrastructure (Completed ✅)
- ✅ Rebrand from EMM-MoneyBox to Cashlens
- ✅ Version command
- ✅ Cash flow commands (income, outcome, query, delete, update, list, range, summary)
- ✅ Category commands (create, query, delete, update, list)
- ✅ Data management commands (export, import, backup, restore, init, reset, stats)
- ✅ Database commands (connect, seed)
- ✅ Improved help text and command structure
- ✅ CLI documentation (backend/docs/CLI.md)

**Note**: Most new commands have CLI structure in place but need database service implementation.

### Mapper Layer Enhancements (High Priority)

**Update Methods** - Accept entity parameter instead of just ID:
- [ ] Enhance `CashFlowMapper.UpdateCashFlowByEntity(plainId, entity)` in MongoDB mapper
- [ ] Enhance `CashFlowMapper.UpdateCashFlowByEntity(plainId, entity)` in MySQL mapper
- [ ] Enhance `CategoryMapper.UpdateCategoryByEntity(plainId, entity)` in MongoDB mapper
- [ ] Enhance `CategoryMapper.UpdateCategoryByEntity(plainId, entity)` in MySQL mapper

**List/Query Methods** - Add pagination support:
- [ ] Add `CashFlowMapper.GetAllCashFlows(flowType, limit, offset)` to interface
- [ ] Implement GetAllCashFlows in MongoDB mapper
- [ ] Implement GetAllCashFlows in MySQL mapper
- [ ] Add `CategoryMapper.GetAllCategories()` to interface
- [ ] Implement GetAllCategories in MongoDB mapper
- [ ] Implement GetAllCategories in MySQL mapper

**Bulk Operations** - For backup/restore/reset:
- [ ] Add `CashFlowMapper.DeleteAllCashFlows()` to interface
- [ ] Add `CategoryMapper.DeleteAllCategories()` to interface
- ✅ Add `CashFlowMapper.BulkInsertCashFlows(entities)` for import performance
- ✅ Implement bulk operations in both MongoDB and MySQL mappers

**Aggregation Methods** - For statistics:
- [ ] Add `CashFlowMapper.CountCashFlowsByType(flowType)` to interface
- [ ] Add `CashFlowMapper.GetEarliestCashFlowDate()` to interface
- [ ] Add `CashFlowMapper.GetLatestCashFlowDate()` to interface
- [ ] Add `CategoryMapper.CountAllCategories()` to interface
- [ ] Implement aggregation methods in both mappers

**Security & Performance**:
- [ ] Fix SQL injection vulnerability in MySQL mapper (use parameterized queries)
- [ ] Add transaction support for rollback on errors
- [ ] Consider Redis caching for category lookups
- [ ] Add database indexes for performance

### Architecture Refactoring (Medium Priority)

**Code Quality & Maintainability**:
- ✅ Add constants for magic strings (FlowType, DateFormat, TableNames)
- ✅ Add validation layer before service calls (100% coverage)
- ✅ Implement error wrapping with context (standardized error types)
- [ ] **[LOW]** Add structured logging standards across all layers
- ✅ Create common response/error types
- [ ] **[LOW]** Add metrics/monitoring hooks

**Performance Optimizations**:
- ✅ Optimize date range queries (single query instead of N queries per day)
- ✅ Implement connection pooling for database
- ✅ Add batch operations for bulk inserts
- ✅ Implement category caching (in-memory, thread-safe)
- ✅ Add database indexes:
  - ✅ `cash_flow.belongs_date` (for date queries)
  - ✅ `cash_flow.flow_type` (for type filtering)
  - ✅ `category.name` (for name lookups)
  - ✅ Compound index `cash_flow(belongs_date, flow_type)`
- [ ] **[MEDIUM]** Optimize summary calculations (database aggregation instead of in-memory)

**Modern Patterns**:
- [ ] **[LOW]** Implement dependency injection pattern
- [ ] **[MEDIUM]** Add context propagation for cancellation/timeout
- ✅ Implement graceful shutdown for server
- [ ] **[LOW]** Add retry logic with exponential backoff
- [ ] **[LOW]** Implement circuit breaker for database calls
- [ ] **[LOW]** Add request tracing/correlation IDs

**Testing Infrastructure**:
- ✅ Add unit tests for validation, errors, cache (87%+ coverage)
- [ ] **[MEDIUM]** Add integration tests for mappers
- [ ] **[MEDIUM]** Add end-to-end CLI tests
- [ ] **[LOW]** Add benchmark tests for performance
- [ ] **[MEDIUM]** Set up CI/CD pipeline
- ✅ Add test coverage reporting (achieved: 87%+)

**Database Layer**:
- [ ] Standardize collection names (singular vs plural)
- [ ] Add migration system for schema changes
- [ ] Implement database health checks
- [ ] Add query timeout configuration
- [ ] Implement read replicas support (future)

### Cash Flow API (In Progress)
- ✅ POST `/api/cash/outcome` - Create expense
- ✅ POST `/api/cash/income` - Create income
- ✅ GET `/api/cash/{id}` - Query by ID
- ✅ GET `/api/cash/date/{date}` - Query by date
- ✅ DELETE `/api/cash/{id}` - Delete by ID
- ✅ DELETE `/api/cash/date/{date}` - Delete by date
- [ ] PUT `/api/cash/{id}` - Update cash flow record
- [ ] GET `/api/cash/range` - Query by date range (from/to)
- [ ] GET `/api/cash/summary/daily` - Daily summary with totals
- [ ] GET `/api/cash/summary/monthly` - Monthly summary with totals
- [ ] GET `/api/cash/summary/yearly` - Yearly summary with totals

### Category API (Not Started)
- [ ] POST `/api/category` - Create category
- [ ] GET `/api/category` - List all categories
- [ ] GET `/api/category/{id}` - Get category by ID
- [ ] PUT `/api/category/{id}` - Update category
- [ ] DELETE `/api/category/{id}` - Delete category
- [ ] GET `/api/category/{id}/stats` - Category spending statistics

### Statistics & Analytics API (New)
- [ ] GET `/api/stats/overview` - Overall financial overview
- [ ] GET `/api/stats/trends` - Spending trends over time
- [ ] GET `/api/stats/category-breakdown` - Breakdown by category
- [ ] GET `/api/stats/income-vs-expense` - Income vs expense comparison
- [ ] GET `/api/stats/top-expenses` - Top N expenses in period

### Import/Export API (Partial)
- ✅ CLI: Export to Excel (from/to date)
- ✅ CLI: Import from Excel
- [ ] POST `/api/export` - Export data to Excel via API
- [ ] POST `/api/import` - Import data from Excel via API
- [ ] GET `/api/export/csv` - Export to CSV format
- [ ] POST `/api/backup` - Create backup of all data
- [ ] POST `/api/restore` - Restore from backup

### Health & Utility API (New)
- [ ] GET `/api/health` - Health check endpoint
- [ ] GET `/api/version` - API version info
- [ ] GET `/api/config` - Get supported currencies, date formats

### CORS & Middleware
- [ ] Add CORS middleware for Flutter web app
- [ ] Add request logging middleware
- [ ] Add error handling middleware
- [ ] Add rate limiting (optional, for production)

---

## Flutter UI Development

### Project Setup
- ✅ Initialize Flutter project in `flutter/`
- ✅ Setup project structure (features, core, shared)
- ✅ Configure API client (Dio/http)
- ✅ Setup state management (Riverpod)
- ✅ Configure routing (go_router)
- ✅ Setup theme (Material 3, dark mode)
- ✅ Landing page with welcome screen
- ✅ Dashboard with demo data and statistics
- ✅ Currency settings with localStorage
- ✅ Drawer navigation menu
- ✅ Settings dialog with logout
- ✅ Platform configurations (Android, iOS, Windows, Linux, macOS, Web)

### Core Features

#### 1. Dashboard/Home Screen
- ✅ Display current month summary (income, expense, balance)
- ✅ Show recent transactions list
- ✅ Quick action buttons (add income/expense)
- ✅ Category breakdown (top 5 spending)
- [ ] Category breakdown chart (pie/donut)
- [ ] Spending trend chart (line/bar)

#### 2. Transaction Management
- [ ] Add transaction screen (income/expense)
  - [ ] Amount input with calculator
  - [ ] Category selection
  - [ ] Date picker
  - [ ] Description field
  - [ ] Form validation
- [ ] Transaction list screen
  - [ ] Filter by date range
  - [ ] Filter by category
  - [ ] Filter by type (income/expense)
  - [ ] Search functionality
  - [ ] Pull to refresh
- [ ] Transaction detail screen
  - [ ] View full details
  - [ ] Edit transaction
  - [ ] Delete transaction (with confirmation)

#### 3. Category Management
- [ ] Category list screen
- [ ] Add/edit category screen
  - [ ] Name input
  - [ ] Icon selection
  - [ ] Color picker
- [ ] Delete category (with warning if in use)
- [ ] Category statistics view

#### 4. Statistics & Reports
- [ ] Overview screen
  - [ ] Total income/expense/balance
  - [ ] Period selector (daily/weekly/monthly/yearly)
- [ ] Trends screen
  - [ ] Line chart for spending over time
  - [ ] Bar chart for category comparison
- [ ] Category breakdown screen
  - [ ] Pie chart with percentages
  - [ ] List view with amounts
- [ ] Export reports (share as PDF/image)

#### 5. Settings
- [ ] Database selection (MongoDB/MySQL)
- [ ] Connection settings
- [ ] Theme toggle (light/dark)
- ✅ Currency selection (15 currencies with localStorage)
- [ ] Date format preference
- ✅ About screen
- ✅ Logout functionality

#### 6. Data Management
- [ ] Import from Excel
- [ ] Export to Excel
- [ ] Backup data
- [ ] Restore from backup
- [ ] Clear all data (with confirmation)

### UI/UX Enhancements
- [ ] Splash screen
- [ ] Onboarding flow (first launch)
- [ ] Empty states with illustrations
- [ ] Loading states and skeletons
- [ ] Error handling with retry
- [ ] Success/error snackbars
- [ ] Smooth animations and transitions
- [ ] Haptic feedback (mobile)
- [ ] Swipe actions (delete, edit)

### Offline & Sync
- [ ] Local database (SQLite/Hive)
- [ ] Offline mode support
- [ ] Sync with backend when online
- [ ] Conflict resolution strategy
- [ ] Sync status indicator

### PWA Features
- [ ] Service worker for offline support
- [ ] App manifest for installability
- [ ] Push notifications (optional)
- [ ] Background sync

### Mobile-Specific Features
- [ ] Biometric authentication (fingerprint/face)
- [ ] Camera for receipt scanning (future)
- [ ] Share functionality
- [ ] App shortcuts
- [ ] Widget support (future)

---

## Testing

### Backend
- [ ] Unit tests for services
- [ ] Integration tests for API endpoints
- [ ] Database mock tests
- [ ] API documentation (Swagger/OpenAPI)

### Flutter
- [ ] Unit tests for business logic
- [ ] Widget tests for UI components
- [ ] Integration tests for user flows
- [ ] Golden tests for visual regression

---

## DevOps & Deployment

### Backend
- [ ] Docker compose for local development
- [ ] CI/CD pipeline setup
- [ ] API deployment guide
- [ ] Environment configuration

### Flutter
- [ ] Web build configuration
- [ ] Android build configuration
- [ ] iOS build configuration (future)
- [ ] PWA deployment guide
- [ ] App store preparation (future)

---

## Future Enhancements (Nice to Have)

### User Management (Future)
- [ ] User registration/login
- [ ] Multi-user support
- [ ] User profiles
- [ ] Data isolation per user
- [ ] JWT authentication
- [ ] Password reset flow

### Advanced Features
- [ ] Recurring transactions
- [ ] Budget planning and tracking
- [ ] Bill reminders
- [ ] Multiple accounts/wallets
- [ ] Multi-currency support
- [ ] Receipt photo attachment
- [ ] Tags for transactions
- [ ] Custom reports builder
- [ ] Data visualization dashboard
- [ ] Export to PDF reports
- [ ] Scheduled backups
- [ ] Cloud sync (Google Drive, Dropbox)

### Integrations
- [ ] Bank account integration (future)
- [ ] Payment gateway integration (future)
- [ ] Calendar integration for reminders
- [ ] Email notifications

---

## Documentation
- [ ] Update README with new structure
- [ ] API documentation
- [ ] Flutter app setup guide
- [ ] User manual
- [ ] Developer contribution guide
- [ ] Architecture decision records

---

## Notes
- Keep the app simple and focused on core functionality first
- Prioritize mobile-first design
- Ensure offline capability for mobile users
- Consider adding user management only when needed
- Focus on data privacy and security
