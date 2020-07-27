Geocoder.configure(
  # Geocoding options
  timeout: 10,                 # geocoding service timeout (secs)
  lookup: :google,         # name of geocoding service (symbol)
  # ip_lookup: :ipinfo_io,      # name of IP address geocoding service (symbol)
  language: :ja,              # ISO-639 language code
  use_https: true,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  api_key: ENV['GOOGLE_MAPS_APIKEY'],               # API key for geocoding service
  # tmp/geocoderに30日間検索結果をキャッシュする設定
  cache: ActiveSupport::Cache::FileStore.new([Rails.root, 'tmp', 'geocoder'].join('/'), { expires_in: 30.days }),
  cache_prefix: 'geocoder:',
  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear
)
