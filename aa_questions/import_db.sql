DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_id INTEGER,
  body TEXT,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
users (fname, lname)
VALUES
('Chao', 'Cao'),
('Tan Loc', 'Phan'),
('Kush', 'Patel');

INSERT INTO
questions (title, body, author_id)
VALUES
('SQL Question', 'No REALLY, how do you use SQL???!', 2),
('TA Question', 'Who is your favorite TA?', 1);

INSERT INTO
question_follows (user_id, question_id)
VALUES
(2, 2),
(3, 1),
(3, 2);

INSERT INTO
replies (question_id, parent_id, user_id, body)
VALUES
(2, null, 2, 'Anastassia Bobokolanova'),
(2, 1, 3, 'cool');

INSERT INTO
question_likes (user_id, question_id)
VALUES
(1, 2),
(2, 1);

-- replies
-- ID |  PARENT_ID |
-- 1
-- 2  |  1
-- 3  |  1

-- question_likes
-- user_id   |   question_id
-- 3         |     2
-- 4         |     2
