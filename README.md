# Windchill
This is a simple uptime monitor that I wrote for myself. It runs on heroku and sends an email using sendgrid if it detects any problems.

It will need a redis provider, and some environment variables if you want to start using it.

To get started, clone the repo, and create a new heroku app.

Edit the job in app/jobs
