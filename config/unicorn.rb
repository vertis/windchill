worker_processes 4
timeout 30

@resque_pid = nil
@scheduler_pid = nil

before_fork do |server, worker|
  @resque_pid ||= spawn("bundle exec rake resque:work QUEUES=*")
  @scheduler_pid ||= spawn("bundle execrake resque:scheduler")
end