-- im-cw1/sql/roles-schema/create_roles_schema.sql

-- Create roles
CREATE ROLE admin;

CREATE ROLE manager;

CREATE ROLE player;

CREATE ROLE employee;

-- Assign permissions to roles
GRANT ALL PRIVILEGES ON SCHEMA public TO admin;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Employee TO manager;

GRANT
SELECT (
        manager_id,
        employee_id,
        name,
        date_of_birth,
        address
    ) ON
TABLE Manager TO manager;

GRANT
UPDATE (
        employee_id,
        name,
        date_of_birth,
        address
    ) ON
TABLE Manager TO manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Transaction TO manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Player TO manager;

GRANT
SELECT (
        player_id,
        name,
        date_of_birth,
        email,
        address,
        username
    ) ON
TABLE Player TO player;

GRANT
UPDATE (
        name,
        date_of_birth,
        email,
        address,
        username
    ) ON
TABLE Player TO player;

GRANT SELECT (player_id, status) ON TABLE Account TO player;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Player TO employee;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Game TO employee;

-- Create schemas
CREATE SCHEMA game_schema AUTHORIZATION manager;

CREATE SCHEMA player_schema AUTHORIZATION player;

CREATE SCHEMA employee_schema AUTHORIZATION employee;

-- Object ownership
ALTER TABLE game_schema.Game OWNER TO manager;

ALTER TABLE player_schema.Player OWNER TO player;

ALTER TABLE employee_schema.Employee OWNER TO employee;

-- Default privileges
ALTER DEFAULT PRIVILEGES IN SCHEMA game_schema
GRANT
SELECT,
INSERT,
UPDATE,
DELETE ON TABLES TO manager;

ALTER DEFAULT PRIVILEGES IN SCHEMA player_schema
GRANT
SELECT,
INSERT,
UPDATE,
DELETE ON TABLES TO player;