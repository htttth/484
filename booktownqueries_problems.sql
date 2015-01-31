-- Homework #2: EECS 484.
-- fanzy
-- Baier

-- Your answer should work for any instance of the database, not just the one given.

-- EXAMPLE
-- Q0: "list titles of all books". Answer given below.

SELECT title FROM books;

-- Q1: List the ISBN of all books written by "Frank Herbert"
SELECT E.ISBN 
From editions E, books B, authors A
WHERE E.book_id = B.book_id AND B.author_id = A.author_id AND A.first_name = 'Frank' AND A.last_name = 'Herbert';


-- Q2: List last name and first name of authors who have written both
-- Short Story and Horror books. In general, there could be two different authors
-- with the same name, one who has written a horror book and another
-- who has written short stories. 
SELECT A.last_name, A.first_name
FROM books B, authors A, subjects S
WHERE A.book_id = B.book_id AND B.book_id = S.book_id AND S.subject = 'Short Story'
INTERSECT 
SELECT A.last_name, A.first_name
FROM books B, authors A, subjects S
WHERE A.book_id = B.book_id AND B.book_id = S.book_id AND S.subject = 'Horror';


-- Q3: List titles, subjects, author's id, author's last name, and author's first name of all books 
-- by authors who have written Short Story book(s). Note: that this may
-- require a nested query. The answer can include non-Short Story books. You
-- can also use views. But DROP any views at the end of your query. Using
-- a single query is likely to be more efficient in practice.

CREATE VIEW story_author AS 
SELECT A.author_id, A.last_name, A.first_name
FROM authors A, books B, subjects S
WHERE A.author_id = B.author_id AND B.book_id = S.book_id AND S.subject = 'Short Story';

SELECT B.title, S.subject, A.author_id, A.last_name, A.author_id
FROM story_author A, books B, subjects S
WHERE A.author_id = B.author_id AND B.book_id = S.book_id;

DROP VIEW story_author;

-- Q4: Find id, first name, and last name of authors who wrote books for all the 
-- subjects of books written by Edgar Allen Poe.
CREATE VIEW E_subject AS
SELECT DISTINCT S.subject_id
FROM subject S, authors A, books B
WHERE B.subject_id = S.subject_id AND B.author_id = A.author_id AND A.last_name = 'Poe' AND A.first_name = 'Edgar Allen';

SELECT DISTINCT A.author_id, A.last_name, A.first_name
FROM books B, authors A, E_subject S
WHERE B.author_id = A.author_id AND B.subject_id = S.subject_id;

DROP VIEW E_subject;


-- Q5: Find the name of all publishers whos have published books for authors
-- who have written more than one book, order by ascending publisher id;
CREATE VIEW more_author AS
SELECT B.author_id
FROM books B
GROUP BY B.author_id
HAVING COUNT(*) > 1;

SELECT DISTINCT P.name
FROM publishers P, editions E, more_author A
WHERE A.author_id = E.author_id AND E.publisher_id = P.publisher_id;
ORDER BY P.publisher_id ASC;

DROP VIEW more_author;


-- Q6: Find the last name and first name of authors who haven't written any book
SELECT A.last_name, A.first_name
FROM authors A, books B
WHERE NOT EXIST(
				SELECT * FROM books B, authors A WHERE A.author_id = B.author_id);


-- Q7: Find id of authors who have written exactly 1 book. Name the column as id. 
-- Order the id in ascending order

SELECT DISTINCT B.author_id AS id
FROM books B
GROUP BY B.author_id
HAVING COUNT (*) = 1
