CSV.generate do |csv|
  columns = %w(利用日 利用時間 料金 利用者名 連絡先 性別)
  csv << columns
  @reservations.each do |reservation|
    values = [
      l(reservation.start_time, format: :semi_long),
      reservation.reservation_time,
      number_to_currency(reservation.total_price),
      reservation.user.name,
      reservation.user.phone_number,
      reservation.user.gender_i18n,
    ]
    csv << values
  end
end
