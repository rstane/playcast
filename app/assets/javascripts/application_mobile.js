//= require jquery
//= require jquery_ujs
//= require_directory ./mobile

// お気に入り登録／解除
function toggle_favorite( plan_id, klass, kind, authenticity_token ) {
  if(kind == "delete"){
    if(!(window.confirm('お気に入りを解除してよろしいですか？'))){
      return
    }
  }

  $.post(
    // 送信先
    "/plans/" + plan_id + "/favorite",
    // 送信データ
    {
      "klass": klass,
      "authenticity_token": authenticity_token
    },
    // コールバック処理
    function(data, status) {
      $("#favorite" + plan_id).html(data)
    },
    // 応答データ形式
    "html"
  );
};

// オートページャー
$(function() {
  $.autopager({
    start: function(current, next) { $("#loading").show() },
    load: function(current, next) { $("#loading").hide() },
    content: '#paging', // コンテンツ要素部分のセレクタを指定
    link: 'a[rel=next]'  // 次ページのリンク部分のセレクタを指定
  });
});
