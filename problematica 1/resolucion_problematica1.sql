CREATE TABLE tipo_cliente (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_type TEXT UNIQUE NOT NULL,
    limite_caja_ahorro INTEGER,
    limite_caja_ahorro_pesos INTEGER,
    limite_caja_ahorro_dolares INTEGER,
    limite_caja_ahorro_pesos_extra INTEGER,
    limite_caja_ahorro_dolares_extra INTEGER,
    limite_cuenta_corriente INTEGER,
    limite_cuenta_inversion INTEGER,
    limite_tarjetas_debito INTEGER,
    limite_tarjetas_credito INTEGER,
    limite_credito REAL,
    limite_cuota_credito REAL,
    limite_retiro_mensual INTEGER,
    limite_retiro_diario REAL,
    comisision_saliente REAL,
    comision_entrante REAL,
    limite_chequera INTEGER
);

INSERT INTO
    tipo_cliente (
        customer_type,
        limite_caja_ahorro,
        limite_caja_ahorro_pesos,
        limite_caja_ahorro_dolares,
        limite_caja_ahorro_pesos_extra,
        limite_caja_ahorro_dolares_extra,
        limite_cuenta_corriente,
        limite_cuenta_inversion,
        limite_tarjetas_debito,
        limite_tarjetas_credito,
        limite_credito,
        limite_cuota_credito,
        limite_retiro_mensual,
        limite_retiro_diario,
        comisision_saliente,
        comision_entrante,
        limite_chequera
    )
VALUES
    (
        'Classic',
        1,
        0,
        0,
        1,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        5,
        10000,
        0.1,
        0.005,
        0
    ),
    (
        'Gold',
        2,
        2,
        0,
        NULL,
        1,
        1,
        1,
        NULL,
        5,
        150000,
        100000,
        NULL,
        20000,
        0.005,
        0.001,
        1
    ),
    (
        'Black',
        5,
        5,
        NULL,
        NULL,
        3,
        1,
        5,
        NULL,
        10,
        500000,
        600000,
        NULL,
        100000,
        0,
        0,
        2
    );

CREATE TABLE tipo_cuenta (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    account_type TEXT UNIQUE NOT NULL
);

INSERT INTO
    tipo_cuenta (account_type)
VALUES
    ('Caja de ahorro en pesos'),
    ('Caja de ahorro en dólares'),
    ('Cuenta Corriente en pesos'),
    ('Cuenta Corriente en dólares'),
    ('Cuenta Inversión');

CREATE TABLE marca_tarjeta (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    card_type TEXT UNIQUE NOT NULL
);

INSERT INTO
    marca_tarjeta (card_type)
VALUES
    ('VISA'),
    ('MASTERCARD'),
    ('AMERICAN EXPRESS');

CREATE TABLE tarjeta (
    tarjeta_id INTEGER PRIMARY KEY AUTOINCREMENT,
    numero TEXT NOT NULL UNIQUE CHECK (LENGTH(numero) <= 20),
    cvv INTEGER,
    fecha_otorgamiento DATE,
    fecha_expiracion DATE,
    tipo_tarjeta TEXT
);

ALTER TABLE
    tarjeta
ADD
    COLUMN marca_tarjeta INTEGER;

PRAGMA random_seed = 123;

UPDATE
    tarjeta
SET
    marca_tarjeta = CASE
        WHEN LENGTH(numero) = 13 THEN (
            SELECT
                id
            FROM
                marca_tarjeta
            WHERE
                card_type = 'AMERICAN EXPRESS'
        )
        WHEN LENGTH(numero) >= 13
        AND LENGTH(numero) <= 16
        AND RANDOM() % 2 = 0 THEN (
            SELECT
                id
            FROM
                marca_tarjeta
            WHERE
                card_type = 'VISA'
        )
        ELSE (
            SELECT
                id
            FROM
                marca_tarjeta
            WHERE
                card_type = 'MASTERCARD'
        )
    END;

ALTER TABLE
    tarjeta
ADD
    COLUMN owner INTEGER;

UPDATE
    tarjeta
SET
    owner = (
        SELECT
            cliente.customer_id
        FROM
            cliente
        WHERE
            tarjeta.tarjeta_id = cliente.customer_id
        LIMIT
            1
    );

SELECT
    *
FROM
    tarjeta CREATE TABLE direcciones (
        adress_id INTEGER PRIMARY KEY AUTOINCREMENT,
        adress TEXT NOT NULL,
        country TEXT NOT NULL,
        region TEXT NOT NULL,
        city TEXT NOT NULL,
        postal TEXT NOT NULL
    );

/ CREATE TABLE direccion_cliente (
    adress_id INTEGER,
    customer_id INTEGER,
    FOREIGN KEY (adress_id) REFERENCES direcciones(adress_id) ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES cliente(customer_id) ON UPDATE CASCADE,
    PRIMARY KEY (adress_id, customer_id)
);

PRAGMA random_seed = 0;

INSERT INTO
    direccion_cliente (adress_id, customer_id)
SELECT
    ABS(RANDOM()) % 500 + 1,
    customer_id
FROM
    cliente;

ALTER TABLE
    direccion_cliente
ADD
    COLUMN customer_name TEXT;

ALTER TABLE
    direccion_cliente
ADD
    COLUMN customer_surname TEXT;

UPDATE
    direccion_cliente
SET
    customer_name = (
        SELECT
            customer_name
        FROM
            cliente
        WHERE
            cliente.customer_id = direccion_cliente.customer_id
    );

UPDATE
    direccion_cliente
SET
    customer_surname = (
        SELECT
            customer_surname
        FROM
            cliente
        WHERE
            cliente.customer_id = direccion_cliente.customer_id
    );

CREATE TABLE direccion_empleado (
    adress_id INTEGER,
    employee_id INTEGER,
    FOREIGN KEY (adress_id) REFERENCES direcciones(adress_id) ON UPDATE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES empleado(employee_id) ON UPDATE CASCADE,
    PRIMARY KEY (adress_id, employee_id)
);

INSERT INTO
    direccion_empleado (adress_id, employee_id)
SELECT
    ABS(RANDOM()) % 500 + 1,
    employee_id
FROM
    empleado;

ALTER TABLE
    direccion_empleado
ADD
    COLUMN employee_name TEXT;

ALTER TABLE
    direccion_empleado
ADD
    COLUMN employee_surname TEXT;

UPDATE
    direccion_empleado
SET
    employee_name = (
        SELECT
            employee_name
        FROM
            empleado
        WHERE
            empleado.employee_id = direccion_empleado.employee_id
    );

UPDATE
    direccion_empleado
SET
    employee_surname = (
        SELECT
            employee_surname
        FROM
            empleado
        WHERE
            empleado.employee_id = direccion_empleado.employee_id
    );

UPDATE
    sucursal
SET
    branch_adress_id = ABS(RANDOM()) % 500 + 1;

ALTER TABLE
    cuenta
ADD
    COLUMN account_type;

UPDATE
    cuenta
SET
    account_type = ABS(RANDOM()) % 5 + 1;

UPDATE
    empleado
SET
    employee_hire_date = substr (employee_hire_date, 7, 4) || '-' || substr (employee_hire_date, 4, 2) || '-' || substr (employee_hire_date, 1, 2);