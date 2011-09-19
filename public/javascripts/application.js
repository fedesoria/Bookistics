// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function () {
    $('a[rel=twipsy]').twipsy({
        live: true,
        placement: 'below'
    });
    $('a[rel=popover]').popover({
        offset: 10,
        placement: 'below'
    });
});