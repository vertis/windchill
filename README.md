# Windchill
This is a simple uptime monitor that I wrote for myself. It runs on heroku and sends an email using sendgrid if it detects any problems.

It will need a redis provider, and some environment variables if you want to start using it.

To get started:
  - Clone the repo
  - Create a new heroku app `heroku create <your-app-name>`
  - Edit the job in app/jobs/check_job.rb
  - Use `heroku config:add` to set the required environment variables
