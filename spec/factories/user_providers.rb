FactoryBot.define do
  factory :user_provider do
    association :user
    provider { "keycloak_openid" }
    uid { "123456" }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
