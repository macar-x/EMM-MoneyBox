// MongoDB initialization script for Cashlens
// This script creates the database, collections, and inserts demo data

print('Starting MongoDB initialization for Cashlens...');

// Switch to cashlens database
db = db.getSiblingDB('cashlens');

// Create collections
db.createCollection('cash_flows');
db.createCollection('categories');

print('Collections created successfully');

// Insert demo categories
const categories = [
  {
    _id: ObjectId(),
    name: 'Food & Dining',
    icon: '🍔',
    color: '#FF6B6B',
    type: 'expense',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Transportation',
    icon: '🚗',
    color: '#4ECDC4',
    type: 'expense',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Shopping',
    icon: '🛍️',
    color: '#FFE66D',
    type: 'expense',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Entertainment',
    icon: '🎬',
    color: '#95E1D3',
    type: 'expense',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Bills & Utilities',
    icon: '💡',
    color: '#F38181',
    type: 'expense',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Healthcare',
    icon: '🏥',
    color: '#AA96DA',
    type: 'expense',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Salary',
    icon: '💰',
    color: '#4CAF50',
    type: 'income',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    name: 'Investment',
    icon: '📈',
    color: '#2196F3',
    type: 'income',
    created_at: new Date()
  }
];

db.categories.insertMany(categories);
print(`Inserted ${categories.length} categories`);

// Helper function to get date string
function getDateString(daysAgo) {
  const date = new Date();
  date.setDate(date.getDate() - daysAgo);
  return date.toISOString().split('T')[0];
}

// Insert demo cash flows
const cashFlows = [
  // Today's transactions
  {
    _id: ObjectId(),
    amount: 45.50,
    date: getDateString(0),
    category: 'Food & Dining',
    type: 'outcome',
    description: 'Lunch at Italian restaurant',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 12.00,
    date: getDateString(0),
    category: 'Transportation',
    type: 'outcome',
    description: 'Uber to office',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 3500.00,
    date: getDateString(0),
    category: 'Salary',
    type: 'income',
    description: 'Monthly salary',
    created_at: new Date()
  },
  
  // Yesterday
  {
    _id: ObjectId(),
    amount: 89.99,
    date: getDateString(1),
    category: 'Shopping',
    type: 'outcome',
    description: 'New shoes',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 25.00,
    date: getDateString(1),
    category: 'Entertainment',
    type: 'outcome',
    description: 'Movie tickets',
    created_at: new Date()
  },
  
  // This week
  {
    _id: ObjectId(),
    amount: 150.00,
    date: getDateString(3),
    category: 'Bills & Utilities',
    type: 'outcome',
    description: 'Electricity bill',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 65.00,
    date: getDateString(4),
    category: 'Healthcare',
    type: 'outcome',
    description: 'Pharmacy',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 200.00,
    date: getDateString(5),
    category: 'Investment',
    type: 'income',
    description: 'Dividend payment',
    created_at: new Date()
  },
  
  // Earlier this month
  {
    _id: ObjectId(),
    amount: 120.00,
    date: getDateString(10),
    category: 'Food & Dining',
    type: 'outcome',
    description: 'Grocery shopping',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 45.00,
    date: getDateString(12),
    category: 'Transportation',
    type: 'outcome',
    description: 'Gas station',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 75.50,
    date: getDateString(15),
    category: 'Food & Dining',
    type: 'outcome',
    description: 'Dinner with friends',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 30.00,
    date: getDateString(18),
    category: 'Entertainment',
    type: 'outcome',
    description: 'Concert tickets',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 250.00,
    date: getDateString(20),
    category: 'Shopping',
    type: 'outcome',
    description: 'Clothing',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 500.00,
    date: getDateString(22),
    category: 'Investment',
    type: 'income',
    description: 'Freelance project',
    created_at: new Date()
  },
  {
    _id: ObjectId(),
    amount: 80.00,
    date: getDateString(25),
    category: 'Bills & Utilities',
    type: 'outcome',
    description: 'Internet bill',
    created_at: new Date()
  }
];

db.cash_flows.insertMany(cashFlows);
print(`Inserted ${cashFlows.length} cash flow records`);

// Create indexes for better query performance
db.cash_flows.createIndex({ date: -1 });
db.cash_flows.createIndex({ category: 1 });
db.cash_flows.createIndex({ type: 1 });
db.cash_flows.createIndex({ date: -1, type: 1 });

print('Indexes created successfully');

// Print summary
const totalIncome = db.cash_flows.aggregate([
  { $match: { type: 'income' } },
  { $group: { _id: null, total: { $sum: '$amount' } } }
]).toArray()[0]?.total || 0;

const totalExpense = db.cash_flows.aggregate([
  { $match: { type: 'outcome' } },
  { $group: { _id: null, total: { $sum: '$amount' } } }
]).toArray()[0]?.total || 0;

print('\n=== Cashlens Database Initialized ===');
print(`Categories: ${db.categories.countDocuments()}`);
print(`Cash Flows: ${db.cash_flows.countDocuments()}`);
print(`Total Income: $${totalIncome.toFixed(2)}`);
print(`Total Expense: $${totalExpense.toFixed(2)}`);
print(`Balance: $${(totalIncome - totalExpense).toFixed(2)}`);
print('=====================================\n');

print('MongoDB initialization completed successfully!');
