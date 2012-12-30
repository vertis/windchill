web: bundle exec unicorn -p $PORT
resque: rake jobs:work
scheduler: rake resque:scheduler