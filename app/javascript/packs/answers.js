$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', editAnswer )
    $('.answers').on('click', '.cancel-answer-link', cancelAnswer )
})

function editAnswer(event){
    event.preventDefault()

    $(this).hide()
    var answerId = $(this).data('answerId')

    $('.answer-id-' + answerId + ' .delete-file-link').each(function(){
        $(this).removeClass('d-none')
    })
    $('.answer-id-' + answerId + ' .delete-link').each(function(){
        $(this).removeClass('d-none')
    })
    $('form#edit-answer-' + answerId).removeClass('d-none')
    $('.cancel-answer-link').show()
    $('.answer-id-' + answerId).on('click', '.delete-link', function(){
        hideForm(answerId)
    })
    $('.answer-id-' + answerId).on('click','.delete-file-link', function(){
        hideForm(answerId)
    })
}

function cancelAnswer(event){
    event.preventDefault()

    $(this).hide()
    var answerId = $(this).data('answerId')

    hideForm(answerId)
}

function hideForm(answerId){
    $('.answer-id-' + answerId + ' .delete-file-link').each(function(){
        $(this).addClass('d-none')
    })
    $('.answer-id-' + answerId + ' .delete-link').each(function(){
        $(this).addClass('d-none')
    })
    $('form#edit-answer-' + answerId).addClass('d-none')
    $('.edit-answer-link').show()
    $('.answer-errors').html('')
}