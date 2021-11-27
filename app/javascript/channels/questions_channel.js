import consumer from "./consumer"

// 1. подписка на QuestionsChannel
consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
    received(data) {
        this.appendLine(data)
    },

    appendLine(data) {
        if(data.event === 'destroy'){
            $('.questions tr#' + data.question.id).remove()
        } else {
            const html = this.createLine(data.question, data.reward, data.url)
            if(data.event === 'add'){
                $('.questions tbody').append(html)
            }
            if(data.event === 'update'){
                $('.questions tr#' + data.question.id).replaceWith(html)
            }
        }
    },
    createLine(question, reward, url) {
        var result = `
          <tr id="${question.id}">
            <td>${question.title}</td>
            <td>${question.body}</td>
        `
        if(reward) {
            result += `<td><img alt="${reward.title}" src="${url}" width="50" height="50"></td>`
        } else {
            result += `<td></td>`
        }
        result += `<td><a href="/questions/${question.id}" class="btn btn-warning btn-sm">Show answers</a></td>
                </tr>`

        return result
    }
})
