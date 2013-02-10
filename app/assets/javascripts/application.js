// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require vendor
//= require_tree .

// ツールチップ
/*
$(function(){
  $('a[rel=tooltip]').tooltip();
});
*/

// お気に入り登録／解除
function toggle_favorite( plan_id, klass, kind ) {
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
      "klass": klass
    },
    // コールバック処理
    function(data, status) {
      $("#favorite" + plan_id).html(data)

      if (kind == "delete") {
        window.alert('お気に入りを解除しました。');
      } else {
        window.alert('お気に入りに登録しました。');
      };
    },
    // 応答データ形式
    "html"
  );
};
