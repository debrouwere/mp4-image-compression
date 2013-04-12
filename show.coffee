$(document).ready ->
    for i in [0..23]
        option = $("<option/>")
        option.text "#{i}:00 hr"
        option.attr 'value', i
        $("select").append option

    video = Popcorn "#video"

    $("select").change ->
        video.currentTime $(this).val()