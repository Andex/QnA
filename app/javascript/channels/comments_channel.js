import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    received(data) {
        if(data.comment.user_id !== gon.current_user_id){
            var header = $('.' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments .list')
            if(data.event === 'create'){
                if(header.find('.fs-6').length === 0) {
                    header.append('<div class="fs-6">Comments:</div>');
                }
                var line = `<li class="${data.comment.commentable_type.toLowerCase()}-comment-${data.comment.id}">
                                ${data.comment.body} ©${data.user_email}
                            </li>`
                header.append(line)
            } else {
                if(header.find('li').length === 1 ){
                    header.find('.fs-6').remove()
                }
                $('.' + data.comment.commentable_type.toLowerCase() + '-comment-' + data.comment.id).remove()
            }
        }
    }
})
