# Cashlens Development Roadmap

**See your money clearly**

## Project Structure
- ✅ Reorganize repository into monorepo structure
- ✅ Move backend code into `backend/` folder
- ✅ Update configuration files for new structure
- ✅ Create `flutter/` folder for Flutter UI

---

## Backend API Development

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

### Core Features

#### 1. Dashboard/Home Screen
- [ ] Display current month summary (income, expense, balance)
- [ ] Show recent transactions list
- [ ] Quick action buttons (add income/expense)
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
- [ ] Currency selection
- [ ] Date format preference
- [ ] About screen

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
