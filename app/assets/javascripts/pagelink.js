$(function(){
    $('a[href^=#]').click(function() {
        var speed = 300;//スピード(値が小さいほど早い)
        var href= $(this).attr("href");
        var target = $(href == "#" || href == "" ? 'html' : href);
        var position = target.offset().top;
        $($.browser.safari ? 'body' : 'html').animate({scrollTop:position}, speed, 'swing');
        return false;
    });
});