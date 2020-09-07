BASE_TITLE = "ReserveSpace"

VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}[-]\d{4}|\d{2}[-]\d{3}|\d{3}[-]\d{2}|\d{4}[-]\d{1})[-]\d{4}\z|\A0[5789]0[-]\d{4}[-]\d{4}\z/

VALID_HOURLY_PRICE_REGEX = /00\z/

MINIMUM_UNIT_ROOM_PRICE = 100

CHECK_MINUTES = %w(00 15 30 45)

GOOGLEMAP_API_JS_URL = "https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_MAPS_APIKEY']}&callback=initMap"

MAX_COMPANY_NAME_LENGTH = 140

MAX_EMAIL_LENGTH = 255

MAX_COMMENT_LENGTH = 1000
