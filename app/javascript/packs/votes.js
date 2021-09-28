$(document).on('turbolinks:load', function(){
    $('.cancel-vote-link, .vote-up-link, .vote-down-link').on('ajax:success', function(e) {
        var vote = e.detail[0];

        // var resource = $('.' + vote.resource + '-id-' + vote.id)
        // console.log(vote)
        if(vote.resource === 'question'){
            var resource = $('.question')
        } else {
            var resource = $('.answer-id-' + vote.id)
        }
        // console.log(e.detail)
        // console.log(resource)
        // console.log(resource.find('.rating .value'))
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