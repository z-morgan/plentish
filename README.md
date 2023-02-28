# Technical Summary

Plentish is a simple web app which I built in order to practice the fundamentals of full stack developement. The front-end was created from scratch using plain HTML, CSS and vanilla JavaScript. The back-end is written in Ruby, and uses Sinatra--a lightweight back-end framework which provides a DSL for parsing HTTP requests, defining routes, and handling session information. The backend communicates with a PostgreSQL database to persist the application's data.

# Security

Plentish implements a handlful of features which contribute to the integrity of the app. First, access to any user data requires authentication, and passwords are hashed using the bcrypt algorithm before being stored in the database. Active sessions are identified by a username stored in a cookie. Before the cookie is send to the client, it is encrypted by Sinatra using HMAC-SHA1. The client is send a 64 bit key which it presents back to sinatra with subsequent HTTP requests, and sinatra uses the key to decode the session cookie. 

SQL injection attacks are prevented by using an adapter method provided by the `pg` gem, which ensures all SQL statements are property quoted before executing them against the database. Cross-site Scripting attacks are prevented by automatically escaping any HTML which is interpolated into the view templates when they are rendered.

Lastely, any user input validation which occurs on the front-end also occurs on the back-end to protect the integrity of the data in the database.