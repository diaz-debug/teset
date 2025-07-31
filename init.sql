-- 設定資料庫編碼
ALTER DATABASE practice_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 設定連線編碼
SET NAMES utf8mb4;
SET character_set_client = utf8mb4;
SET character_set_connection = utf8mb4;
SET character_set_database = utf8mb4;
SET character_set_results = utf8mb4;
SET character_set_server = utf8mb4;

-- 創建資料庫
CREATE DATABASE IF NOT EXISTS practice_db;
USE practice_db;

-- 創建用戶表
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100) NOT NULL,
    age INT,
    country VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 創建文章表
CREATE TABLE IF NOT EXISTS articles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    author_id INT,
    views INT DEFAULT 0,
    status ENUM('draft', 'published', 'archived') DEFAULT 'draft',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id)
);

-- 創建評論表
CREATE TABLE IF NOT EXISTS comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    article_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 創建訂單表
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    total_amount DECIMAL(10,2),
    status ENUM('pending', 'paid', 'shipped', 'completed', 'cancelled') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 創建訂單明細表
CREATE TABLE IF NOT EXISTS order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_name VARCHAR(100),
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- 插入用戶數據
INSERT INTO users (username, email, password, age, country) VALUES
('john_doe', 'john@example.com', 'password123', 25, 'Taiwan'),
('jane_smith', 'jane@example.com', 'password456', 30, 'Japan'),
('mike_wilson', 'mike@example.com', 'password789', 35, 'Korea'),
('sarah_lee', 'sarah@example.com', 'password321', 28, 'Taiwan'),
('david_wang', 'david@example.com', 'password654', 22, 'Taiwan'),
('emma_chen', 'emma@example.com', 'password987', 27, 'Japan'),
('alex_lin', 'alex@example.com', 'passwordabc', 32, 'Korea'),
('lily_zhang', 'lily@example.com', 'passworddef', 29, 'Taiwan'),
('tom_liu', 'tom@example.com', 'passwordxyz', 31, 'Japan'),
('amy_wu', 'amy@example.com', 'password111', 26, 'Korea');

-- 插入文章數據
INSERT INTO articles (title, content, author_id, views, status) VALUES
('MySQL入門指南', '這是一篇關於MySQL基礎的文章...', 1, 150, 'published'),
('程式設計技巧', '分享一些實用的程式設計技巧...', 2, 320, 'published'),
('資料庫優化方法', '如何優化您的資料庫性能...', 3, 280, 'published'),
('網站開發心得', '分享網站開發的經驗與心得...', 4, 200, 'published'),
('JavaScript教學', 'JavaScript基礎教學內容...', 1, 180, 'published'),
('Python程式設計', 'Python入門教學課程...', 2, 250, 'published'),
('資料結構概述', '介紹基本的資料結構概念...', 3, 190, 'published'),
('演算法分析', '常見演算法的分析與應用...', 4, 220, 'published'),
('網頁設計技巧', '響應式網頁設計技巧分享...', 5, 170, 'published'),
('資安防護指南', '基本的網站資安防護措施...', 6, 290, 'published');

-- 插入評論數據
INSERT INTO comments (article_id, user_id, content) VALUES
(1, 2, '非常實用的入門教學！'),
(1, 3, '內容清晰易懂'),
(2, 1, '學到很多技巧'),
(2, 4, '期待更多相關文章'),
(3, 5, '這些優化方法很有幫助'),
(4, 6, '感謝分享經驗'),
(5, 7, '對初學者很有幫助'),
(6, 8, '解釋得很清楚'),
(7, 9, '概念講解得很好'),
(8, 10, '很實用的文章');

-- 插入訂單數據
INSERT INTO orders (user_id, total_amount, status) VALUES
(1, 1500.00, 'completed'),
(2, 2300.50, 'paid'),
(3, 1800.75, 'shipped'),
(4, 950.25, 'pending'),
(5, 2100.00, 'completed'),
(1, 1650.50, 'completed'),
(2, 1950.75, 'shipped'),
(3, 2450.25, 'paid'),
(4, 1750.00, 'pending'),
(5, 2250.50, 'completed');

-- 插入訂單明細數據
INSERT INTO order_items (order_id, product_name, quantity, price) VALUES
(1, '筆記型電腦', 1, 1500.00),
(2, '智慧手機', 2, 1150.25),
(2, '藍牙耳機', 1, 199.99),
(3, '平板電腦', 1, 1800.75),
(4, '智慧手錶', 1, 950.25),
(5, '桌上型電腦', 1, 2100.00),
(6, '顯示器', 2, 825.25),
(7, '機械鍵盤', 3, 650.25),
(8, '電競滑鼠', 5, 490.05),
(9, '繪圖板', 1, 1750.00),
(10, '外接硬碟', 3, 750.17);

-- 創建一些有用的索引
CREATE INDEX idx_users_country ON users(country);
CREATE INDEX idx_articles_status ON articles(status);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_comments_created ON comments(created_at);

-- 創建一個用於統計的視圖
CREATE VIEW article_stats AS
SELECT 
    a.id,
    a.title,
    u.username as author,
    a.views,
    COUNT(c.id) as comment_count
FROM articles a
LEFT JOIN users u ON a.author_id = u.id
LEFT JOIN comments c ON a.id = c.article_id
GROUP BY a.id, a.title, u.username, a.views;