BASE_TITLE = "ReserveSpace"

VALID_PHONE_NUMBER_REGEX = /\A0(\d{1}[-]\d{4}|\d{2}[-]\d{3}|\d{3}[-]\d{2}|\d{4}[-]\d{1})[-]\d{4}\z|\A0[5789]0[-]\d{4}[-]\d{4}\z/

VALID_HOURLY_PRICE_REGEX = /00\z/

MINIMUM_UNIT_SPACE_PRICE = 100

CHECK_MINUTES = %w(00 15 30 45)

GOOGLEMAP_API_JS_URL = "https://maps.googleapis.com/maps/api/js?key=#{ENV['GOOGLE_MAPS_APIKEY']}&callback=initMap"

MAX_COMPANY_NAME_LENGTH = 140

MAX_EMAIL_LENGTH = 255

MAX_COMMENT_LENGTH = 1000

MAX_USER_NAME_LENGTH = 30

MAX_SPACE_NAME_LENGTH = 100

MAX_ADDRESS_CITY_LENGTH = 20

MAX_ADDRESS_STREET_LENGTH = 30

MAX_SPACE_DESCRIPTION_LENGTH = 3000

MAX_ADDRESS_BUILDING_LENGTH = 50

RESERVE_SPACE_FEE = 10
