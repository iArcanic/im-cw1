# PostgreSQL Configuration Files

This folder contains configuration files related to PostgreSQL.

## Files

- **postgresql.conf**: Main configuration file for PostgreSQL.

## Installation

Follow the steps below to use and install the PostgreSQL configuration files:

1. **Review Default Configurations:**
    - Before making any changes, review the default configurations in the `postgresql.conf` file to understand the initial setup.

2. **Adjust Listen Addresses and Port (Optional):**
    - Open the `postgresql.conf` file in a text editor.
    - Modify the `listen_addresses` and `port` configurations if the PostgreSQL server needs to listen on specific IP addresses or hostnames.

   Example:
   ```plaintext
   listen_addresses = 'localhost'
   port = 5432