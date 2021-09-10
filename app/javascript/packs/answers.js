$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', editAnswer )
    $('.answers').on('click', '.cancel-answer-link', cancelAnswer )
})

function editAnswer(event){
    event.preventDefault()

    $(this).hide()
    var answerId = $(this).data('answerId')

    $('.answer-id-' + answerId + ' .delete-file-link').each(function(){
        $(this).removeClass('hidden')
    })
    $('form#edit-answer-' + answerId).removeClass('hidden')
    $('.cancel-answer-link').show()
}

function cancelAnswer(event){
    event.preventDefault()

    $(this).hide()
    var answerId = $(this).data('answerId')

    $('.answer-id-' + answerId + ' .delete-file-link').each(function(){
        $(this).addClass('hidden')
    })
    $('form#edit-answer-' + answerId).addClass('hidden')
    $('.edit-answer-link').show()
}