ENV["KEMAL_ENV"] = "test"
require "spec"
require "mocks"
require "mocks/spec"
require "webmock"
require "timecop"
require "../src/bot"

Spec.before_each do
  WebMock.reset
end
