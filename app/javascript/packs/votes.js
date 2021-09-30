$(document).on('turbolinks:load', function(){
    $('.cancel-vote-link, .vote-up-link, .vote-down-link').on('ajax:success', function(e) {
        var vote = e.detail[0];

        if(vote.resource === 'question'){
            var resource = $('.question')
        } else {
            var resource = $('.answer-id-' + vote.id)
        }
        resource.find('.rating .value').html(vote.rating);

        resource.find('.vote-up-link, .vote-down-link').toggle();
        resource.find('.cancel-vote-link').toggle();
    })
        .on('ajax:error', function(e) {
            var errors = e.detail[0];
            var resource = errors.resource

            $.each(errors, function(index, value) {
                $('.' + resource + '-errors').append('<p>' + value + '</p>');
            })
        })
})