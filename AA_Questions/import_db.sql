PRAGMA foreign_keys = ON;

-- USERS

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL  
);

INSERT INTO
users (fname, lname)
VALUES
("Ned", "Ruggeri"), ("Kush", "Patel"), ("Earl", "Cat");

INSERT INTO
  users (fname, lname)
VALUES
  ('Stephen', 'Li'), ('Wade', 'Coufal');

  
  
-- QUESTIONS

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY(author_id) REFERENCES users(id)
);

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('AA Project', 'I don''t know what I''m doing?', (SELECT id FROM users WHERE fname = 'Stephen')),
  ('SQLZoo', 'This is too hard??', (SELECT id FROM users WHERE lname = 'Coufal'));
  
INSERT INTO
  questions (title, body, author_id)
SELECT
  "Ned Question", "NED NED NED", 1
FROM
  users
WHERE
  users.fname = "Ned" AND users.lname = "Ruggeri";

INSERT INTO
  questions (title, body, author_id)
SELECT
  "Kush Question", "KUSH KUSH KUSH", users.id
FROM
  users
WHERE
  users.fname = "Kush" AND users.lname = "Patel";

INSERT INTO
  questions (title, body, author_id)
SELECT
  "Earl Question", "MEOW MEOW MEOW", users.id
FROM
  users
WHERE
  users.fname = "Earl" AND users.lname = "Cat";
  
  
  
  
-- QUESTIONS FOLLOWS

CREATE TABLE question_follows(
  questions_id INTEGER NOT NULL,
  users_id INTEGER NOT NULL,

  
  FOREIGN KEY(questions_id) REFERENCES questions(id),
  FOREIGN KEY(users_id) REFERENCES users(id)
);

INSERT INTO
  question_follows (users_id, questions_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Ned" AND lname = "Ruggeri"),
  (SELECT id FROM questions WHERE title = "Earl Question")),

  ((SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
  (SELECT id FROM questions WHERE title = "Earl Question")
);


-- REPLIES

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  subject_id INTEGER NOT NULL,
  parent_reply_id INTEGER, 
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  
  FOREIGN KEY(subject_id) REFERENCES questions(id),
  FOREIGN KEY(parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

INSERT INTO
  replies (subject_id, parent_reply_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "Earl Question"),
  NULL,
  (SELECT id FROM users WHERE fname = "Ned" AND lname = "Ruggeri"),
  "Did you say NOW NOW NOW?"
);

INSERT INTO
  replies (subject_id, parent_reply_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = "Earl Question"),
  (SELECT id FROM replies WHERE body = "Did you say NOW NOW NOW?"),
  (SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
  "I think he said MEOW MEOW MEOW."
);

-- QUESTIONS LIKES

CREATE TABLE question_likes(
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Kush" AND lname = "Patel"),
  (SELECT id FROM questions WHERE title = "Earl Question")
);

-- and here is the lazy way to add some seed data:
INSERT INTO question_likes (user_id, question_id) VALUES (1, 1);
INSERT INTO question_likes (user_id, question_id) VALUES (1, 2);

  


