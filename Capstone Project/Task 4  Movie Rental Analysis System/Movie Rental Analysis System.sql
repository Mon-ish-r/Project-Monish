
-- Task 4: Movie Rental Analysis System
-- PostgreSQL

-- Step 1: Create table
CREATE TABLE rental_data (
    MOVIE_ID INT,
    CUSTOMER_ID INT,
    GENRE VARCHAR(50),
    RENTAL_DATE DATE,
    RETURN_DATE DATE,
    RENTAL_FEE NUMERIC(10,2)
);

-- Step 2: Insert sample data
INSERT INTO rental_data(MOVIE_ID, CUSTOMER_ID, GENRE, RENTAL_DATE, RETURN_DATE, RENTAL_FEE) VALUES
(101, 1, 'Action', '2025-05-01', '2025-05-03', 4.50),
(102, 2, 'Drama', '2025-05-02', '2025-05-05', 3.75),
(103, 3, 'Comedy', '2025-05-03', '2025-05-04', 2.50),
(104, 1, 'Action', '2025-06-01', '2025-06-03', 5.00),
(105, 4, 'Horror', '2025-06-05', '2025-06-08', 3.00),
(106, 2, 'Drama', '2025-07-01', '2025-07-04', 4.00),
(107, 5, 'Action', '2025-07-10', '2025-07-12', 4.75),
(108, 3, 'Comedy', '2025-07-15', '2025-07-17', 2.75),
(109, 1, 'Action', '2025-08-01', '2025-08-03', 5.25),
(110, 4, 'Drama', '2025-08-05', '2025-08-07', 3.50),
(111, 5, 'Horror', '2025-08-10', '2025-08-12', 4.00),
(112, 2, 'Comedy', '2025-08-15', '2025-08-17', 3.25);

-- ============================================
-- OLAP QUERIES
-- ============================================

-- Subquestion a: Drill Down (Genre → Movie)
SELECT GENRE, MOVIE_ID, COUNT(*) AS rental_count, SUM(RENTAL_FEE) AS total_fee
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, MOVIE_ID;

-- Subquestion b: Rollup (Total rental fees by Genre → Overall)
SELECT GENRE, SUM(RENTAL_FEE) AS total_fee
FROM rental_data
GROUP BY ROLLUP(GENRE)
ORDER BY GENRE;

-- Subquestion c: Cube (Total rental fees across Genre, Rental Date, Customer)
SELECT GENRE, RENTAL_DATE, CUSTOMER_ID, SUM(RENTAL_FEE) AS total_fee
FROM rental_data
GROUP BY CUBE(GENRE, RENTAL_DATE, CUSTOMER_ID)
ORDER BY GENRE, RENTAL_DATE, CUSTOMER_ID;

-- Subquestion d: Slice (Rentals only from 'Action' genre)
SELECT *
FROM rental_data
WHERE GENRE = 'Action';

-- Subquestion e: Dice (Genre = 'Action' or 'Drama' AND last 3 months)
SELECT *
FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
  AND RENTAL_DATE >= (CURRENT_DATE - INTERVAL '3 months');
