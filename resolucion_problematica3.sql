SELECT
    *
FROM
    cuenta
WHERE
    balance < 0;

SELECT
    customer_name,
    customer_surname,
    customer_dob
FROM
    cliente
WHERE
    customer_surname LIKE "%Z%";

SELECT
    customer_name,
    customer_surname,
    customer_dob,
    branch_name
FROM
    cliente,
    sucursal
WHERE
    customer_name = "Brendan";

SELECT
    c.customer_name,
    c.customer_surname,
    c.customer_dob,
    s.branch_name
FROM
    cliente c
    JOIN sucursal s ON c.branch_id = s.branch_id
WHERE
    c.customer_name = 'Brendan'
ORDER BY
    s.branch_name;

SELECT
    *
FROM
    prestamo
WHERE
    loan_total > 8000000
UNION
SELECT
    *
FROM
    prestamo
WHERE
    loan_type = 'prendario';

SELECT
    *
FROM
    prestamo
WHERE
    loan_total > (
        SELECT
            AVG(loan_total)
        FROM
            prestamo
    );

SELECT
    COUNT(*) AS cantidad_clientes_menores_50
FROM
    cliente
WHERE
    STRFTIME('%Y', 'now') - STRFTIME('%Y', customer_dob) - (
        STRFTIME('%m-%d', 'now') < STRFTIME('%m-%d', customer_dob)
    ) < 50;

SELECT
    customer_id,
    balance
FROM
    cuenta
WHERE
    balance > 8000
LIMIT
    5;

SELECT
    *
FROM
    prestamo
WHERE
    loan_date LIKE '%-04-%'
    OR loan_date LIKE '%-06-%'
    OR loan_date LIKE '%-08-%'
ORDER BY
    loan_total;

SELECT
    loan_type,
    SUM(loan_total) AS loan_total_accu
FROM
    prestamo
GROUP BY
    loan_type;