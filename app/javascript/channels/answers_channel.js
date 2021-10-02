import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    received(data) {
        if(data.answer.user_id !== gon.current_user_id){
            this.appendLine(data)
        }
    },

    appendLine(data) {
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
        result += `</tr>`

        return result
    }
})
