SELECT
    branch_name,
    COUNT(customer_id) AS cant_clientes
FROM
    sucursal s
    LEFT JOIN cliente c ON s.branch_id = c.branch_id
GROUP BY
    s.branch_name
ORDER BY
    cant_clientes DESC;

SELECT
    s.branch_name AS sucursal,
    COUNT(DISTINCT e.employee_id) AS empleados_por_sucursal,
    COUNT(DISTINCT c.customer_id) AS clientes_por_sucursal,
    COUNT(DISTINCT e.employee_id) / COUNT(DISTINCT c.customer_id) AS cantidad_clientes_dividido_por_empleados_por_sucursal
FROM
    sucursal s
    LEFT JOIN cliente c ON s.branch_id = c.branch_id
    LEFT JOIN empleado e ON s.branch_id = e.branch_id
GROUP BY
    s.branch_name;

SELECT
    branch_name AS sucursal,
    t.tipo_tarjeta AS tipo_tarjeta,
    COUNT(t.numero) AS cantidad_tarjetas
FROM
    sucursal s
    INNER JOIN cliente c ON s.branch_id = c.branch_id
    LEFT JOIN tarjeta t ON c.customer_id = t.customer_id
WHERE
    t.tipo_tarjeta IN ('MASTER', 'VISA', 'AMERICAN EXPRESS')
GROUP BY
    sucursal,
    tipo_tarjeta;

SELECT
    s.branch_name AS sucursal,
    AVG(p.loan_total) AS promedio_credito
FROM
    sucursal s
    INNER JOIN cliente c ON s.branch_id = c.branch_id
    LEFT JOIN prestamo p ON c.customer_id = p.customer_id
GROUP BY
    sucursal;

CREATE TABLE auditoria_cuenta (
    auditoria_cuenta_id INTEGER PRIMARY KEY,
    old_id INTEGER,
    new_id INTEGER,
    old_balance REAL,
    new_balance REAL,
    old_iban TEXT,
    new_iban TEXT,
    old_type TEXT,
    new_type TEXT,
    user_action TEXT,
    created_at TIMESTAMP DEFAULT(DATETIME())
);

CREATE TRIGGER IF NOT EXISTS auditoria_cuenta_trigger_after_update
AFTER
UPDATE
    ON cuenta BEGIN
INSERT INTO
    auditoria_cuenta (
        old_id,
        new_id,
        old_balance,
        new_balance,
        old_iban,
        new_iban,
        old_type,
        new_type,
        user_action,
        created_at
    )
VALUES
    (
        OLD.account_id,
        NEW.account_id,
        OLD.balance,
        NEW.balance,
        OLD.iban,
        NEW.iban,
        OLD.type,
        NEW.type,
        'Update',
        DATETIME('now')
    );

END;

SELECT
    *
FROM
    cuenta;

UPDATE
    cuenta
SET
    balance = balance - 10000
WHERE
    account_id IN (10, 11, 12, 13, 14);

SELECT
    *
FROM
    cuenta;

SELECT
    customer_dni,
    customer_name,
    customer_surname
from
    cliente
ORDER BY
    customer_dni ASC;

CREATE INDEX idx_cliente_dni ON cliente (customer_dni);

CREATE INDEX idx_cliente_dni ON cliente (customer_dni);

CREATE TABLE movimientos (
    movimiento_id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero_cuenta INTEGER,
    monto REAL,
    tipo_operacion VARCHAR(50),
    hora TIMESTAMP DEFAULT (DATETIME())
);

BEGIN TRANSACTION;

INSERT INTO
    movimientos (numero_cuenta, monto, tipo_operacion, hora)
VALUES
    (200, -100000, 'Transferencia', DATETIME('now'));

SELECT
    *
FROM
    cuenta
WHERE
    account_id = 200
    OR account_id = 400;

UPDATE
    cuenta
SET
    balance = balance - 100000
WHERE
    account_id = 200;

INSERT INTO
    movimientos (numero_cuenta, monto, tipo_operacion, hora)
VALUES
    (400, 100000, 'Transferencia', DATETIME('now'));

UPDATE
    cuenta
SET
    balance = balance + 100000
WHERE
    account_id = 400;

SELECT
    *
FROM
    cuenta
WHERE
    account_id = 200
    OR account_id = 400;

COMMIT;