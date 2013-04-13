load = (q) ->
    src = "bbc-#{q}.mp4"
    source = $("<source/>")
    source.attr 'src', src
    $("#video").html source
    Popcorn "#video"

$(document).ready ->
    for i in [0..23]
        option = $("<option/>")
        option.text "#{i}:00 hr"
        option.attr 'value', i
        $("#time").append option

    for q in ['q1', 'q10', 'q20', 'q30', 'q40']
        option = $("<option/>")
        option.text "CRF #{q}"
        option.attr 'value', q
        $("#quality").append option       

    video = load('q1')

    $("#time").change ->
        video.currentTime $(this).val()

    $("#quality").change ->
        video = load $(this).val()
        video.on 'canplay', ->
            video.currentTime $("#time").val()