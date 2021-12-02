import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    received(data) {
        if(data.answer.user_id !== gon.current_user_id){
            this.appendLine(data)
        }
    },

    appendLine(data) {
        let table = $('.answers').find('table tr')
        if(data.event === 'destroy'){
            if(table.length === 2){
                $('.answers').html('<h5>Be the first to leave an answer</h5>')
            } else {
                $('.answers tr.answer-id-' + data.answer.id).remove()
            }
        } else {
            const html = this.createLine(data)
            if(data.event === 'add'){
                if(table.length === 0){
                    $('.answers').html('<table class="table text-center"><thead class="thead"><tr>' +
                        '<th>Rating</th><th>Answer</th><th>Files and links</th><th colspan=4>Actions</th>' +
                        '</tr><thead><tbody></tbody></table>')
                }
                $('.answers tbody').append(html)
            }
            if(data.event === 'update'){
                $('.answers tr.answer-id-' + data.answer.id).replaceWith(html)
            }
        }
    },
    createLine(data) {
        var result = `
          <tr class="answer-id-${data.answer.id}">
            <td class='rating'>0</td>
            <td>${data.answer.body}</td>
        `
        if(data.links) {
            result += `<td><ul>`
            $.each(data.links, function(index, value) {
                result += `<li><a href="${value.url}">${value.name}</a></li>`
            })
            result += `</ul></td>`
        } else {
            result += `<td></td>`
        }
        result += `<td colspan=3></td><td class="answer-${data.answer.id}-comments"><div class="list"></div></td></tr>`

        return result
    }
})
