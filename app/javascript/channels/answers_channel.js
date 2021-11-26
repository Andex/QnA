import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    received(data) {
        console.log("gon.question_id", gon.question_id)
        console.log("gon.current_user_id = ", gon.current_user_id)
        console.log("data.answer.user_id = ", data.answer.user_id)
        if(data.answer.user_id !== gon.current_user_id){
            this.appendLine(data)
        }
    },

    appendLine(data) {
        let table = $('.answers').find('table')
        if(table.length == 0){
            $('.answers').html('<table class="table text-center"><thead class="thead"><tr>' +
                                   '<th>Rating</th><th>Answer</th><th>Files and links</th><th colspan=5>Actions</th>' +
                               '</tr><thead><tbody></tbody></table>')
        }
        const html = this.createLine(data)
        $('.answers tbody').append(html)
    },
    createLine(data) {
        var result = `
          <tr class="answer-id-${data.answer.id}">
            <td class='rating'>0</td>
            <td>${data.answer.body}</td>
        `
        if(data.links || data.files) {
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
