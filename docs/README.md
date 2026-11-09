# Global structure
First, please note that ``.env`` files are versioned, but the contains example / dev variables. 
Real variables must be configured in new ``.env`` files, or make those variables accessible in your host environment.
For example, if you deploy using a CI, you may configure CI environment variables instead of creating a .env file.

Environment variable for each project is provided in its associated documentation.

## References

- [Vote app migration / architecture documentation](VOTE.md)
- [Worker app migration / architecture documentation](WORKER.md)