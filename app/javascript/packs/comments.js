$(document).on('turbolinks:load', function(){
    $('.question, .answers').on('click', '.comment-link', commentResource )
        .on('click', '.cancel-link', cancelComment )
})

function commentResource(event){
    event.preventDefault()

    $(this).toggle()

    var resource = $(this).data('form')
    $('form#' + resource).removeClass('d-none')
    $('.' + resource + '-comments .cancel-link').show();
}

function cancelComment(event){
    event.preventDefault()

    $(this).toggle()
    var resource = $(this).data('form')

    $('form#' + resource).addClass('d-none')
    $('.' + resource + '-comments .comment-link').show();
    $('form#' + resource + ' #comment_body').val('')
}