$(document).ready(function () {
    // This code controls the tabs in the user profiles.
    $('ul.tabs li a').live('click', function (event) {
        $('div.' + $('ul.tabs li.active a').attr('id')).addClass('hidden');
        $('ul.tabs li.active').removeClass('active');

        $(event.target).parent().addClass('active');
        $('div.' + $(event.target).attr('id')).removeClass('hidden');
    });
});