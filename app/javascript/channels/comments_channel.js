import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    received(data) {
        if(data.comment.user_id !== gon.current_user_id){
            let header = $('.' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments .list')
                .find('.fs-6')
            if(header.length == 0) {
                $('.' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments .list')
                    .append('<div class="fs-6">Comments:</div>');
            }
            $('.' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id + '-comments .list')
                .append('<p>' + data.comment.body + ' ©' + data.user_email + '</p>')
        }
    }
})
