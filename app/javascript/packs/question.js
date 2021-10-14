$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', editQuestion )
    $('.question').on('click', '.cancel-question-link', cancelQuestion )
})

function editQuestion(event){
    event.preventDefault()

    $(this).hide()
    $('#question_reward_attributes_title').val('');

    $('.question .delete-file-link').each(function(){
        $(this).removeClass('hidden')
    })
    $('.question .delete-link').each(function(){
        $(this).removeClass('hidden')
    })
    $('.reward a').removeClass('hidden')
    $('form#edit-question').removeClass('hidden')
    $('.cancel-question-link').show()
}

function cancelQuestion(event){
    event.preventDefault()

    $(this).hide()

    $('form#edit-question').addClass('hidden')
    $('.edit-question-link').show()
    $('.question .delete-file-link').each(function(){
        $(this).addClass('hidden')
    })
    $('.question .delete-link').each(function(){
        $(this).addClass('hidden')
    })
    $('.reward a').addClass('hidden')
    $('.question-errors').html('')
}