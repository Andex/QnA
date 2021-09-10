$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', editQuestion )
    $('.question').on('click', '.cancel-question-link', cancelQuestion )
})

function editQuestion(event){
    event.preventDefault()

    $(this).hide()
    $('form#edit-question').removeClass('hidden')
    $('.cancel-question-link').show()
}

function cancelQuestion(event){
    event.preventDefault()

    $(this).hide()

    $('form#edit-question').addClass('hidden')
    $('.edit-question-link').show()
}