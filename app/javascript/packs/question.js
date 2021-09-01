$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', editQuestion )
})

function editQuestion(event){
    event.preventDefault()

    $(this).hide()
    $('form#edit-question').removeClass('hidden')
}