require "spec"
require "mocks"
require "mocks/spec"
require "webmock"
require "../src/bot"

Spec.before_each do
  WebMock.reset
end
