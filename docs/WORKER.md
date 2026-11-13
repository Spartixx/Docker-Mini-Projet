# Worker App

## Changes explanation 
- We now use the version of .NET 10.0 ( the latest ). 
- We removed the IP address workaround permitting to connect redis using IP address to use the redis container name 
directly: That's how containers talk when they are in the same network.
- We use environment variables to connect to the database. Code is versionned and should not contain credentials.
