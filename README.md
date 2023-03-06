# Technical Summary

Plentish is a simple web app which I built in order to practice the fundamentals of full stack developement. The front-end was created from scratch using plain HTML, CSS and vanilla JavaScript. Handlebars is used to make front-end HTML generation cleaner, but doesn't raise the level of abstaction in any significant way. The back-end is written in Ruby, and uses Sinatra--a lightweight back-end framework which recieves parsed HTTP requests from the application server, and provides a DSL for defining routes and handling session information. The back-end uses a PostgreSQL database to persist the application's data.

# Project Goals

My intention was to develop a full-stack app using only fundamental technologies of web development, while avoiding modern frameworks and libraries. This choice resulted in a longer developement process (the project took me around 80 hours) and a less polished UI. These trade-offs were worthwhile because they allowed me to implement the core functionalities at a low level. For example, all DOM manipulation, event handling, and Ajax requests are implemented using vanilla JavaScript and APIs built in to the browser's runtime environment. These technologies don't change as rapidly as modern frameworks do, so although I don't expect to write many apps in this manner, the skills will be applicable regardless of which technologies are popular at a given time.

# Security

Plentish implements a handlful of features which contribute to the integrity of the app. First, access to any user data requires authentication, and passwords are hashed using the bcrypt algorithm before being stored in the database. Active sessions are identified by a username stored in a cookie. Before the cookie is send to the client, it is encrypted by Sinatra using HMAC-SHA1. The client is send a 64 bit key which it presents back to Sinatra with subsequent HTTP requests, and these keys are used to decode the session cookie. 

SQL injection attacks are prevented by using an adapter method provided by the `pg` gem, which ensures all SQL statements are property quoted before executing them against the database. Cross-Site Scripting attacks are prevented by automatically escaping any HTML which is interpolated into the view templates when they are rendered.

Lastely, any user input validation which occurs on the front-end also occurs on the back-end to protect the integrity of the data in the database.

# Testing

Another trade-off I made was to forego a comprehensive test suite. As it is, the tests only cover some core features like account registration and user authentication. I made this decision because the application is a practice project, and will not be used in production by consumers. Given my time constraints, I wanted to focus more on the app's implementation rather than writing regression tests. If the app was going to be used in production, a comprehensive test-suite would be necessary to ensure the app's integrity and robustness.