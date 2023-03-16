# Technical Summary

Plentish is a simple web app which I built in order to practice the fundamentals of full stack developement. The front-end was created from scratch using plain HTML, CSS and vanilla JavaScript. Handlebars is used to make front-end HTML generation cleaner, but doesn't raise the level of abstaction in any significant way. The back-end is written in Ruby, and uses Sinatra--a lightweight back-end framework which recieves parsed HTTP requests from the application server, and provides a DSL for defining routes and handling session information. The back-end uses a PostgreSQL database to persist the application's data.

# Project Goals

My intention was to develop a full-stack app using only fundamental technologies of web development, while avoiding modern frameworks and libraries. This choice resulted in a longer developement process (the project took me around 80 hours) and a less polished UI. These trade offs were worthwhile because they allowed me to implement the core functionalities at a low level. For example, all DOM manipulation, event handling, and Ajax requests are implemented using vanilla JavaScript and APIs built in to the browser's runtime environment. These technologies don't come and go as rapidly as modern frameworks do, so although I don't expect to write many apps in this manner, the skills will be applicable regardless of which technologies are popular at a given time.

# Security

Plentish implements a handlful of features which contribute to the integrity of the app. First, access to any user data requires authentication, and passwords are hashed using the bcrypt algorithm before being stored in the database. Active sessions are identified by a username stored in a cookie. Before the cookie is send to the client, it is encrypted by Sinatra using HMAC-SHA1. The client is send a 64 bit key which it presents back to Sinatra with subsequent HTTP requests, and these keys are used to decode the session cookie. 

SQL injection attacks are prevented by using an adapter method provided by the `pg` gem, which ensures all SQL statements are properly quoted before executing them against the database. Cross-Site Scripting (XSS) attacks are prevented by automatically escaping any HTML which is interpolated into the view templates when they are rendered.

Lastely, any user input validation which occurs on the front-end also occurs on the back-end to protect the integrity of the data in the database.

# Testing

Another trade-off I made was to forego a comprehensive test suite. The app only includes unit tests for user registration and authentication on the back-end. I made this decision becuase of my time constraints and becuase this app is just a practice project. I wanted to focus more on the app's implementation rather than writing regression tests. If the app was going to be used in production, a comprehensive test-suite would be necessary to ensure the app's integrity and robustness. Regression tests would also make it easier and quicker to implement additional features.

# About the Demo account

One feature I particularly enjoyed building was the demo account. I wanted visiters to be able to check out the app's functionality without having to create an account first. I implemented this by creating three demo accounts, which rotate each time someone tries to use one. Each time a demo account is logged in, that accounts data is reset so that any changes made by a previous visitor are erased. In addition to this, demo account sessions are limited to 15 minutes. If a request is made to the backend for a demo account which has not been reset in the last 15 minutes, the user is automatically logged out and redirected to the home page.
