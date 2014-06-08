
FactoryGirl.define do
  factory :user do
    name                  'Mikhail Gorbachev'
    email                 'mikhail@example.com'
    password              'foobar'
    password_confirmation 'foobar'
  end
end
