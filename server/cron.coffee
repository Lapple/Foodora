# Veeeeeeery simple cron job singleton
# ticks every 1 minute, set a job to go every X ticks.
class Cron
  # by default tick every 1 minute
  constructor: (interval = 60 * 1000) ->
    @jobs = []
    Meteor.setInterval (=> @tick()), interval

  addJob: (everyXTicks, fn) ->
    @jobs.push {fn: fn, every: everyXTicks, count: 0}

  tick: () ->
    for job in @jobs
      job.count += 1
      if job.count == job.every
        job.fn()
        job.count = 0

Cron.instance = new Cron()
