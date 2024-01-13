-- im-cw1/sql/roles-schema/create_roles_schema.sql

-- Create roles
CREATE ROLE admin;

CREATE ROLE manager;

CREATE ROLE player;

CREATE ROLE employee;

-- Assign permissions to roles
GRANT ALL PRIVILEGES ON SCHEMA public TO admin;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE employee TO manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE manager TO manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE transaction TO manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE player TO manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE player TO player;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE transaction TO player;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE account TO player;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE player TO employee;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE game TO employee;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE employee TO employee;