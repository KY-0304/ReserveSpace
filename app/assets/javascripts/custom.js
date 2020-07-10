// room住所自動補完
$(window).ready(function () {
  $('#room_postcode').jpostal({
    postcode: [
      '#room_postcode',
    ],
    address: {
      '#room_prefecture_code': '%3',
      '#room_address_city': '%4',
      '#room_address_street': '%5%6%7'
    }
  });
});
