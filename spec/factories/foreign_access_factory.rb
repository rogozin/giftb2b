Factory.sequence :token_seq do |n|
  "token #{n}"
end

Factory.define :foreign_access do |f|
  f.name          "test"
  f.ip_addr       "127.0.0.1"
  f.param_key         { Factory.next(:token_seq) }
  f.accepted_from Time.now.yesterday
  f.accepted_to   Time.now.tomorrow
end
