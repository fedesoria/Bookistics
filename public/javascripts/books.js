$(document).ready(function () {
    // This code controls the show/hide editorial review link in the books listings.
    $('div.editorial_review span.control a').live('click', function (event) {
        if ($(event.target).parent().siblings('.content').hasClass('hidden')) {
            $(event.target).parent().siblings('.content').removeClass('hidden');
            $(event.target).html('Hide editorial review');
        }
        else {
            $(event.target).parent().siblings('.content').addClass('hidden');
            $(event.target).html('Show editorial review');
        }
    });
});