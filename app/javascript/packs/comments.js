$(document).on('turbolinks:load', function(){
    $('.question, .answers').on('click', '.comment-link', commentResource )
})

function commentResource(event){
    event.preventDefault()

    $(this).toggle()

    var resourceForm = '.' + $(this).data('form')
    $(resourceForm).toggle()
}