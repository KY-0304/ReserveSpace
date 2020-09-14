// space住所自動補完
$(window).ready(function () {
  $('#space_postcode').jpostal({
    postcode: [
      '#space_postcode',
    ],
    address: {
      '#space_prefecture_code': '%3',
      '#space_address_city': '%4',
      '#space_address_street': '%5%6%7'
    }
  });
});

// 無限スクロール
$(window).ready(function () {
  $('.jscroll').jscroll({
    contentSelector: '.jscroll',
    nextSelector: 'a.next',
    loadingHtml: '<p class="text-center">読み込み中...</p>'
  });
});
