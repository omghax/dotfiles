require 'irb/completion'

IRB.conf[:EVAL_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irbhistory')
IRB.conf[:SAVE_HISTORY] = 1000
