DROP TABLE IF EXISTS burrito;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  id int PRIMARY KEY,
  name VARCHAR(32),
  supervisor_id int,
  FOREIGN KEY(supervisor_id) REFERENCES employees(id)
);

CREATE TABLE burrito (
  weight float,
  cooked_by_employee_id int,
  FOREIGN KEY(cooked_by_employee_id) REFERENCES employees(id)
);

INSERT INTO
  employees
VALUES
  (0, 'sally', 2),
  (1, 'mark', 3),
  (2, 'dave', 4),
  (3, 'richard', 5),
  (4, 'sue', 6),
  (5, 'dale', 7),
  (6, 'gary', NULL),
  (7, 'jill', NULL);

INSERT INTO
  burrito
VALUES
  (125.6, 0),
  (81.7, 1),
  (227.6, 1),
  (223.1, 0);

WITH RECURSIVE supervisors AS (
  SELECT id, name, supervisor_id, id AS root_supervisor_id
    FROM employees
   WHERE supervisor_id is NULL
	 
   UNION ALL
	 
  SELECT e.id, e.name, e.supervisor_id, s.root_supervisor_id
    FROM employees e, supervisors s
   WHERE e.supervisor_id = s.id
)
SELECT AVG(b.weight), b.cooked_by_employee_id, s.root_supervisor_id
  FROM burrito b
	 INNER JOIN supervisors s
	     ON b.cooked_by_employee_id = s.id
 GROUP BY cooked_by_employee_id, root_supervisor_id;
