CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Books (
    BOOK_ID INT AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(100) NOT NULL,
    AUTHOR VARCHAR(100) NOT NULL,
    GENRE VARCHAR(50),
    YEAR_PUBLISHED YEAR,
    AVAILABLE_COPIES INT DEFAULT 0
);

CREATE TABLE Members (
    MEMBER_ID INT AUTO_INCREMENT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE,
    PHONE_NO VARCHAR(15),
    ADDRESS VARCHAR(200),
    MEMBERSHIP_DATE DATE DEFAULT (CURDATE())
);

CREATE TABLE BorrowingRecords (
    BORROW_ID INT AUTO_INCREMENT PRIMARY KEY,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE DATE DEFAULT (CURDATE()),
    RETURN_DATE DATE,
    FOREIGN KEY (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID)
);

INSERT INTO Books (TITLE, AUTHOR, GENRE, YEAR_PUBLISHED, AVAILABLE_COPIES)
VALUES
('The Alchemist', 'Paulo Coelho', 'Fiction', 1988, 5),
('Clean Code', 'Robert C. Martin', 'Programming', 2008, 3),
('Harry Potter', 'J.K. Rowling', 'Fantasy', 1997, 10),
('The Pragmatic Programmer', 'Andrew Hunt', 'Programming', 1999, 4),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 2);

INSERT INTO Members (NAME, EMAIL, PHONE_NO, ADDRESS)
VALUES
('Monish R', 'monish@example.com', '9876543210', '123 Street, City'),
('Alice Smith', 'alice@example.com', '9123456780', '456 Avenue, City'),
('Bob Johnson', 'bob@example.com', '9988776655', '789 Road, City'),
('Carol Davis', 'carol@example.com', '9012345678', '321 Lane, City');

INSERT INTO BorrowingRecords (MEMBER_ID, BOOK_ID, BORROW_DATE, RETURN_DATE)
VALUES
(1, 1, '2025-07-01', '2025-07-10'),
(1, 2, '2025-07-15', NULL),
(2, 3, '2025-08-01', '2025-08-15'),
(2, 4, '2025-08-05', NULL),
(3, 5, '2025-06-20', '2025-07-05'),
(4, 1, '2025-08-10', NULL);

SELECT b.TITLE, b.AUTHOR, br.BORROW_DATE
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
WHERE br.MEMBER_ID = 1 AND br.RETURN_DATE IS NULL;

SELECT m.NAME, m.EMAIL, b.TITLE, br.BORROW_DATE
FROM BorrowingRecords br
JOIN Members m ON br.MEMBER_ID = m.MEMBER_ID
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
WHERE br.RETURN_DATE IS NULL
  AND br.BORROW_DATE < CURDATE() - INTERVAL 30 DAY;
  
  SELECT GENRE, COUNT(*) AS Total_Books, SUM(AVAILABLE_COPIES) AS Total_Available
FROM Books
GROUP BY GENRE;

SELECT b.TITLE, b.AUTHOR, COUNT(*) AS Borrow_Count
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
GROUP BY br.BOOK_ID
ORDER BY Borrow_Count DESC
LIMIT 1;

SELECT m.NAME, COUNT(DISTINCT b.GENRE) AS Genre_Count
FROM BorrowingRecords br
JOIN Members m ON br.MEMBER_ID = m.MEMBER_ID
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
GROUP BY br.MEMBER_ID
HAVING Genre_Count >= 3;

SELECT DATE_FORMAT(BORROW_DATE, '%Y-%m') AS Borrow_Month, COUNT(*) AS Total_Borrowed
FROM BorrowingRecords
GROUP BY Borrow_Month
ORDER BY Borrow_Month;

SELECT m.NAME, COUNT(*) AS Books_Borrowed
FROM BorrowingRecords br
JOIN Members m ON br.MEMBER_ID = m.MEMBER_ID
GROUP BY br.MEMBER_ID
ORDER BY Books_Borrowed DESC
LIMIT 3;

SELECT b.AUTHOR, COUNT(*) AS Borrow_Count
FROM BorrowingRecords br
JOIN Books b ON br.BOOK_ID = b.BOOK_ID
GROUP BY b.AUTHOR
HAVING Borrow_Count >= 10;

SELECT m.NAME, m.EMAIL
FROM Members m
LEFT JOIN BorrowingRecords br ON m.MEMBER_ID = br.MEMBER_ID
WHERE br.MEMBER_ID IS NULL;

SELECT * FROM Books
SELECT * FROM Members;
SELECT * FROM BorrowingRecords;