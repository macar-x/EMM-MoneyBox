class ApiEndpoints {
  static const String cashOutcome = '/api/cash/outcome';
  static const String cashIncome = '/api/cash/income';
  static const String cashById = '/api/cash';
  static const String cashByDate = '/api/cash/date';
  
  // Future endpoints
  static const String cashUpdate = '/api/cash';
  static const String cashRange = '/api/cash/range';
  static const String cashSummaryDaily = '/api/cash/summary/daily';
  static const String cashSummaryMonthly = '/api/cash/summary/monthly';
  static const String cashSummaryYearly = '/api/cash/summary/yearly';
  
  static const String category = '/api/category';
  static const String categoryStats = '/api/category';
  
  static const String statsOverview = '/api/stats/overview';
  static const String statsTrends = '/api/stats/trends';
  static const String statsCategoryBreakdown = '/api/stats/category-breakdown';
  static const String statsIncomeVsExpense = '/api/stats/income-vs-expense';
  static const String statsTopExpenses = '/api/stats/top-expenses';
  
  static const String export = '/api/export';
  static const String import = '/api/import';
  static const String exportCsv = '/api/export/csv';
  static const String backup = '/api/backup';
  static const String restore = '/api/restore';
  
  static const String health = '/api/health';
  static const String version = '/api/version';
  static const String config = '/api/config';
}
