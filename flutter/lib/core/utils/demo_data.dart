import 'package:cashlens/core/models/cash_flow.dart';
import 'package:cashlens/core/models/category.dart';

class DemoData {
  static final List<Category> categories = [
    const Category(id: '1', name: 'Food & Dining', icon: '🍔', color: '#FF6B6B'),
    const Category(id: '2', name: 'Transportation', icon: '🚗', color: '#4ECDC4'),
    const Category(id: '3', name: 'Shopping', icon: '🛍️', color: '#FFE66D'),
    const Category(id: '4', name: 'Entertainment', icon: '🎬', color: '#95E1D3'),
    const Category(id: '5', name: 'Bills & Utilities', icon: '💡', color: '#F38181'),
    const Category(id: '6', name: 'Healthcare', icon: '🏥', color: '#AA96DA'),
    const Category(id: '7', name: 'Salary', icon: '💰', color: '#4CAF50'),
    const Category(id: '8', name: 'Investment', icon: '📈', color: '#2196F3'),
  ];

  static final List<CashFlow> transactions = [
    // Today's transactions
    CashFlow(
      id: '1',
      amount: 45.50,
      date: DateTime.now().toIso8601String().split('T')[0],
      category: 'Food & Dining',
      type: 'outcome',
      description: 'Lunch at Italian restaurant',
    ),
    CashFlow(
      id: '2',
      amount: 12.00,
      date: DateTime.now().toIso8601String().split('T')[0],
      category: 'Transportation',
      type: 'outcome',
      description: 'Uber to office',
    ),
    CashFlow(
      id: '3',
      amount: 3500.00,
      date: DateTime.now().toIso8601String().split('T')[0],
      category: 'Salary',
      type: 'income',
      description: 'Monthly salary',
    ),

    // Yesterday
    CashFlow(
      id: '4',
      amount: 89.99,
      date: DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0],
      category: 'Shopping',
      type: 'outcome',
      description: 'New shoes',
    ),
    CashFlow(
      id: '5',
      amount: 25.00,
      date: DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0],
      category: 'Entertainment',
      type: 'outcome',
      description: 'Movie tickets',
    ),

    // This week
    CashFlow(
      id: '6',
      amount: 150.00,
      date: DateTime.now().subtract(const Duration(days: 3)).toIso8601String().split('T')[0],
      category: 'Bills & Utilities',
      type: 'outcome',
      description: 'Electricity bill',
    ),
    CashFlow(
      id: '7',
      amount: 65.00,
      date: DateTime.now().subtract(const Duration(days: 4)).toIso8601String().split('T')[0],
      category: 'Healthcare',
      type: 'outcome',
      description: 'Pharmacy',
    ),
    CashFlow(
      id: '8',
      amount: 200.00,
      date: DateTime.now().subtract(const Duration(days: 5)).toIso8601String().split('T')[0],
      category: 'Investment',
      type: 'income',
      description: 'Dividend payment',
    ),

    // Earlier this month
    CashFlow(
      id: '9',
      amount: 120.00,
      date: DateTime.now().subtract(const Duration(days: 10)).toIso8601String().split('T')[0],
      category: 'Food & Dining',
      type: 'outcome',
      description: 'Grocery shopping',
    ),
    CashFlow(
      id: '10',
      amount: 45.00,
      date: DateTime.now().subtract(const Duration(days: 12)).toIso8601String().split('T')[0],
      category: 'Transportation',
      type: 'outcome',
      description: 'Gas station',
    ),
  ];

  static Map<String, double> getCategorySpending() {
    final Map<String, double> spending = {};
    for (var transaction in transactions) {
      if (transaction.type == 'outcome') {
        spending[transaction.category] = 
            (spending[transaction.category] ?? 0) + transaction.amount;
      }
    }
    return spending;
  }

  static double getTodayIncome() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return transactions
        .where((t) => t.date == today && t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double getTodayExpense() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return transactions
        .where((t) => t.date == today && t.type == 'outcome')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double getMonthIncome() {
    final now = DateTime.now();
    return transactions
        .where((t) {
          final date = DateTime.parse(t.date);
          return date.year == now.year &&
              date.month == now.month &&
              t.type == 'income';
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double getMonthExpense() {
    final now = DateTime.now();
    return transactions
        .where((t) {
          final date = DateTime.parse(t.date);
          return date.year == now.year &&
              date.month == now.month &&
              t.type == 'outcome';
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static List<CashFlow> getRecentTransactions({int limit = 5}) {
    final sorted = List<CashFlow>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }
}
