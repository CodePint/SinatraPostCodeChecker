module PostcodesHelper
  delegate :api_client, :service_checker, to: :settings
end
