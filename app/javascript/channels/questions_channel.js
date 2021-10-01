import consumer from "./consumer"

// 1. подписка на QuestionsChannel
consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
    received(data) {
        this.appendLine(data)
    },

    appendLine(data) {
        const html = this.createLine(data.question, data.reward, data.url)
        $('.questions tbody').append(html)
    },
    createLine(question, reward, url) {
        var result = `
          <tr>
            <td>${question.title}</td>
            <td>${question.body}</td>
        `
        if(reward) {
            result += `<td><img alt="${reward.title}" src="${url}" width="50" height="50"></td>`
        } else {
            result += `<td></td>`
        }
        result += `<td><a href="/questions/${question.id}">Show answers</a></td>
                </tr>`

        return result
    }
})
