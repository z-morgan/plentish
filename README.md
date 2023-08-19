Visit the live app here: https://plentish.app/

# Technical Summary

Plentish is a simple web app which I built in order to practice the fundamentals of full stack developement. The frontend was created from scratch using plain HTML, CSS and vanilla JavaScript. Handlebars is used to make frontend HTML templating cleaner. The backend is written in Ruby, and uses Sinatra--a lightweight backend framework which receives parsed HTTP requests from the application server, and provides a DSL for defining routes and handling session information. The backend uses a PostgreSQL database to persist the application's data.

# Project Goals

My intention was to develop a full-stack app using mainly fundamental technologies of web development, while avoiding frameworks and libraries that raise the level of abstraction. This choice resulted in a longer developement process (the project took me around 80 hours) and a less polished UI. These trade offs were worthwhile because they allowed me to implement the core functionalities at a low level. For example, all DOM manipulation, event handling, and AJAX requests are implemented using vanilla JavaScript and APIs built in to the browser's runtime environment. These technologies don't change as rapidly as frontend frameworks and libraries, so although I don't expect to write many apps in this manner, the skills will be applicable regardless of which technologies are popular at a given time.

# About the Demo account

One feature I particularly enjoyed building was the demo account. I wanted visiters to be able to check out the app's functionality without having to create an account first. I implemented this by creating three demo accounts, which rotate each time someone tries to use one. Each time a demo account is logged in, that account's data is reset so that any changes made by a previous visitor are erased. In addition to this, demo account sessions are limited to 15 minutes. If a request is made to the backend for a demo account which has not been reset in the last 15 minutes, the user is automatically logged out and redirected to the home page.

# Security

Plentish implements a handlful of features which contribute to the integrity of the app. First, access to any user data requires authentication, and passwords are hashed using the bcrypt algorithm before being stored in the database. Active sessions are identified by a username stored in a cookie. Before the cookie is send to the client, it is encrypted by Sinatra using HMAC-SHA1. The client is send a 64 bit key which it presents back to Sinatra with subsequent HTTP requests, and these keys are used to decode the session cookie. 

SQL injection attacks are prevented by using an adapter method provided by the `pg` gem, which ensures all SQL statements are properly quoted before executing them against the database. Cross-Site Scripting (XSS) attacks are prevented by automatically escaping any HTML which is interpolated into the view templates when they are rendered.

Lastely, any user input validation which occurs on the frontend also occurs on the backend to promote the integrity of the database.

# Testing

Another trade-off I made was to forego a comprehensive test suite. The app only includes unit tests for user registration and authentication on the backend. I made this decision becuase of my time constraints and becuase I wanted to focus on the app's implementation. In the future, it would be nice to add regression tests to make it easier and quicker to implement additional features.
