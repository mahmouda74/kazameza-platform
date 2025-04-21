-- users table (تجار - مسوقين - مندوبين)
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  role VARCHAR(20) CHECK (role IN ('merchant', 'marketer', 'delivery')),
  wallet_balance DECIMAL(10, 2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- المنتجات (يضيفها التاجر)
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  merchant_id INTEGER REFERENCES users(id),
  name VARCHAR(255),
  description TEXT,
  quantity INTEGER,
  price DECIMAL(10, 2),
  shipping_cost DECIMAL(10, 2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- الطلبات (ينشئها المسوق، والتاجر بيجهزها، والمندوب بيوصلها)
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  product_id INTEGER REFERENCES products(id),
  merchant_id INTEGER REFERENCES users(id),
  marketer_id INTEGER REFERENCES users(id),
  delivery_id INTEGER REFERENCES users(id),
  selling_price DECIMAL(10, 2), -- السعر اللي حطّه المسوق للعميل
  status VARCHAR(20) CHECK (status IN ('pending', 'approved', 'shipped', 'delivered', 'cancelled')) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- معاملات المحفظة (للأرباح والسحب والإيداع والتأمين)
CREATE TABLE wallet_transactions (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  amount DECIMAL(10, 2),
  type VARCHAR(30) CHECK (type IN ('earning', 'withdrawal', 'deposit', 'insurance_deduction', 'insurance_return', 'commission')),
  reference_id INTEGER, -- ممكن يبقى رقم الطلب
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول تأمين المندوب (مبلغ بيتخصم مؤقت لحد ما يتم التوصيل)
CREATE TABLE delivery_insurance (
  id SERIAL PRIMARY KEY,
  delivery_id INTEGER REFERENCES users(id),
  order_id INTEGER REFERENCES orders(id),
  insurance_amount DECIMAL(10, 2),
  status VARCHAR(20) CHECK (status IN ('held', 'returned', 'lost')) DEFAULT 'held',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
