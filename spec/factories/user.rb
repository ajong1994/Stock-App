FactoryBot.define do
    factory :user do
      email {"test@user.com"}
      password {"qwerty12345"}
      full_name {"Request Test Admin"}
      # Add additional fields as required via your User model
    end
end