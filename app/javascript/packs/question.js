$(document).on('turbolinks:load', function(){
    $('.question').on('click', '.edit-question-link', editQuestion )
                  .on('click', '.cancel-question-link', cancelQuestion )
})

function editQuestion(event){
    event.preventDefault()

    $(this).hide()
    $('#question_reward_attributes_title').val('');

    $('.question .delete-file').each(function(){
        $(this).removeClass('d-none')
    })
    $('.question .delete-link').each(function(){
        $(this).removeClass('d-none')
    })
    $('.reward a').removeClass('d-none')
    $('form#edit-question').removeClass('d-none')
    $('.cancel-question-link').show()

    $('.question').on('click', '.delete-link', function(){
        hideForm()
    })
        .on('click', '.delete-file', function(){
            hideForm()
        })
        .on('click', '.delete-reward', function(){
            hideForm()
        })
}

function cancelQuestion(event){
    event.preventDefault()

    $(this).hide()

    hideForm()
}

function hideForm(){
    $('form#edit-question').addClass('d-none')
    $('.edit-question-link').show()
    $('.question .delete-file').each(function(){
        $(this).addClass('d-none')
    })
    $('.question .delete-link').each(function(){
        $(this).addClass('d-none')
    })
    $('.reward a').addClass('d-none')
    $('.question-errors').html('')
}