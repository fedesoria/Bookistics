$(document).ready(function () {
    $('#search_form').submit(function () {
        $('#search_results').html('');

        if ($('#search_results').hasClass('loading') != true) {
            $('#search_results').addClass('loading');
        }
    });
});