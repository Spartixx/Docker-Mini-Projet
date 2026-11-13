# RESULT APP

## Changes explanation: 
- Updated the database URL by replacing ``localhost`` with the PostgreSQL container name and specifying port ``5432``: 
    
    Before : ``postgres://postgres:postgres@localhost/postgres``

    Now : ``postgres://postgres:postgres@postgres:5432/postgres``
- Updated package dependencies by checking the versions listed in package.json and upgrading them to their latest available versions.
- Secured the database configuration by moving the database URL into an environment file (.env). 