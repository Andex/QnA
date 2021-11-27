import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    received(data) {
        if(data.comment.user_id !== gon.current_user_id){
            let header = $('.' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments .list')
            if(header.find('.fs-6').length === 0) {
                header.append('<div class="fs-6">Comments:</div>');
            }
            header.append('<li>' + data.comment.body + ' ©' + data.user_email + '</li>')
        }
    }
})
