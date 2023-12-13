CREATE VIEW IF NOT EXISTS vista_clientes (id, nombre, apellido, dni, edad, numero_sucursal) AS
SELECT
    customer_id,
    customer_name,
    customer_surname,
    customer_dni,
    CASE
        WHEN STRFTIME('%m-%d', DATE()) < STRFTIME('%m-%d', customer_dob) then DATE() - customer_dob - 1
        else DATE() - customer_dob
    END,
    branch_id
FROM
    cliente;

SELECT
    *
FROM
    vista_clientes
WHERE
    edad > 40
ORDER BY
    dni ASC;

SELECT
    customer_id,
    customer_name,
    customer_surname,
    customer_dni,
    STRFTIME('%Y', 'now') - STRFTIME('%Y', customer_dob) - (
        STRFTIME('%m-%d', 'now') < STRFTIME('%m-%d', customer_dob)
    ) AS edad
FROM
    cliente
WHERE
    customer_name IN ('Anne', 'Tyler')
ORDER BY
    edad;

INSERT INTO
    cliente (
        customer_name,
        customer_surname,
        customer_dni,
        branch_id,
        customer_dob
    )
SELECT
    json_extract(json_data, '$.customer_name'),
    json_extract(json_data, '$.customer_surname'),
    json_extract(json_data, '$.customer_dni'),
    json_extract(json_data, '$.branch_id'),
    json_extract(json_data, '$.customer_dob')
FROM
    (
        SELECT
            '[
    {
        "customer_name": "Lois",
        "customer_surname": "Stout",
        "customer_dni": 47730534,
        "branch_id": 80,
        "customer_dob": "1984-07-07"
    },
    {
        "customer_name": "Hall",
        "customer_surname": "Mcconnell",
        "customer_dni": 52055464,
        "branch_id": 45,
        "customer_dob": "1968-04-30"
    },
    {
        "customer_name": "Hilel",
        "customer_surname": "Mclean",
        "customer_dni": 43625213,
        "branch_id": 77,
        "customer_dob": "1993-03-28"
    },
    {
        "customer_name": "Jin",
        "customer_surname": "Cooley",
        "customer_dni": 21207908,
        "branch_id": 96,
        "customer_dob": "1959-08-24"
    },
    {
        "customer_name": "Gabriel",
        "customer_surname": "Harmon",
        "customer_dni": 57063950,
        "branch_id": 27,
        "customer_dob": "1976-04-01"
    }
]' AS json_data
    );

SELECT
    *
FROM
    cliente
ORDER BY
    customer_id DESC
LIMIT
    10;

UPDATE
    cliente
SET
    branch_id = 10
WHERE
    customer_id BETWEEN 501
    AND 505;

SELECT
    *
FROM
    cliente
ORDER BY
    customer_id DESC
LIMIT
    10;

DELETE FROM
    cliente
WHERE
    customer_name = 'Noel'
    AND customer_surname = 'David';

SELECT
    *
FROM
    cliente;

SELECT
    loan_type
FROM
    prestamo
ORDER BY
    loan_type DESC
LIMIT
    1;