FactoryBot.define do
    factory :admin do
      email {"test@user.com"}
      password {"qwerty12345"}
      full_name {"Request Test Admin"}
      # Add additional fields as required via your User model
    end

    # Not used in this tutorial, but left to show an example of different user types
    # factory :admin do
    #   id {2}
    #   email {"test@admin.com"}
    #   password {"qwerty"}
    #   admin {true}
    # end
end