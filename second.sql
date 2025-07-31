-- 建立 `students` 表
CREATE TABLE IF NOT EXISTS `students` (
    `student_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    `class_id` INT
);

-- 建立 `classes` 表
CREATE TABLE IF NOT EXISTS `classes` (
    `class_id` INT AUTO_INCREMENT PRIMARY KEY,
    `class_name` VARCHAR(50) NOT NULL
);

-- 插入測試資料到 `students`
INSERT INTO `students` (`name`, `class_id`)
VALUES
('Alice', 1),
('Bob', 2),
('Charlie', 3),
('David', NULL);

-- 插入測試資料到 `classes`
INSERT INTO `classes` (`class_name`)
VALUES
('Math'),
('Science'),
('History');