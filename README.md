Visit the live app here: https://plentish.app/

# Technical Summary

Plentish is a simple web app that I built in order to practice the fundamentals of full stack development. The frontend was created from scratch using plain HTML, CSS, and vanilla JavaScript. Handlebars was used to make frontend HTML templating cleaner. The backend is written in Ruby, and uses Sinatra--a lightweight backend framework that receives parsed HTTP requests from the application server and provides a DSL for defining routes and handling session information. The backend uses a PostgreSQL database to persist the application's data.

# Project Goals

My intention was to develop a full-stack app using mainly fundamental technologies of web development while avoiding frameworks and libraries that raise the level of abstraction. This choice resulted in a longer development process (the project took me around 80 hours) and a less polished UI. These trade-offs were worthwhile because they allowed me to implement the core functionalities at a low level. For example, all DOM manipulation, event handling, and AJAX requests are implemented using vanilla JavaScript and APIs built into the browser's runtime environment. These technologies don't change as rapidly as frontend frameworks and libraries, so although I don't expect to write many apps in this manner, the skills will be applicable regardless of which technologies are popular at a given time.

# About the Demo account

One feature I particularly enjoyed building was the demo account. I wanted visitors to be able to check out the app's functionality without having to create an account first. I implemented this by creating three demo accounts, which rotate each time someone tries to use one. Each time a demo account is logged in, that account's data is reset so that any changes made by a previous visitor are erased. In addition to this, demo account sessions are limited to 15 minutes. If a request is made to the backend for a demo account that has not been reset in the last 15 minutes, the user is automatically logged out and redirected to the home page.

# Security

Plentish implements a handful of features that contribute to the integrity of the app. First, access to any user data requires authentication, and passwords are hashed using the bcrypt algorithm before being stored in the database. Active sessions are identified by a username stored in a cookie. Before the cookie is sent to the client, it is encrypted by Sinatra using HMAC-SHA1. The client is sent a 64-bit key which it presents back to Sinatra with subsequent HTTP requests, and these keys are used to decode the session cookie.

SQL injection attacks are prevented by using an adapter method provided by the pg gem, which ensures all SQL statements are properly quoted before executing them against the database. Cross-site scripting (XSS) attacks are prevented by automatically escaping any HTML that is interpolated into the view templates when they are rendered.

Lastly, any user input validation that occurs on the frontend also occurs on the backend to promote the integrity of the database.

