# PostgreSQL Configuration Files

This folder contains configuration files related to PostgreSQL.

## Files

- **`master.sql`**: Executable SQL file
- **`postgresql.conf`**: Main configuration file for PostgreSQL.

## Installation

Follow the steps below to use and install the PostgreSQL configuration files:

1. **Install PostgreSQL-13:**

- Update the Linux system

```bash
sudo apt update
```

- Install PostgreSQL 13

```bash
sudo apt install postgresql-13
```

- The server should start automatically. Check status with:

```bash
sudo systemctl status postgresql
```

2. **Review Default PostgreSQL Configurations:**

- Before making any changes, review the default configurations in the `postgresql.conf` file to understand the initial setup
- Replace the default `postgresql.conf` with the version included here:

```bash
mv /etc/postgresql/13/main/postgresql.conf /etc/postgresql/13/main/postgresql.conf.bak
cp config/postgresql.conf /etc/postgresql/13/main/
```

- Apply changes by restarting server

```bash
systemctl restart postgresql
```

3. To enable SSL connections, PostgreSQL needs an SSL certificate file, key file, and CA file. For this configuration:

- `ssl_cert_file` points to a server certificate file at `/path/to/server.crt`
- `ssl_key_file` points to the private key file at `/path/to/server.key`
- `ssl_ca_file` points to a Certificate Authority file at `/path/to/ca.crt`

These certificate files are not included in this submission. To generate self-signed certificates for testing:

```bash
openssl req -new -text -out server.req
openssl rsa -in privkey.pem -out server.key
rm privkey.pem
openssl x509 -in server.req -text -key server.key -out server.crt
```

- Configure `ssl_cert_file`, `ssl_key_file`, and `ssl_ca_file` to point to these generated files

4. **Load SQL executable:**

- To load the sample data and database objects:

```bash
psql -U postgres -a -f master.sql
```

- This will execute the SQL statements in master.sql and create the database
