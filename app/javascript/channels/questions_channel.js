import consumer from "./consumer"

// 1. подписка на QuestionsChannel
consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
    connected() {
        this.perform('subscribed')
    },
    received(data) {
        this.appendLine(data)
    },

    appendLine(data) {
        const html = this.createLine(data.question)
        $('.questions tbody').append(html)
    },
    createLine(question) {
        return `
          <tr>
            <td>${question.title}</td>
            <td>${question.body}</td>
            <td></td>
            <td>
                <a href="/questions/${question.id}">Show answers</a>
            </td>
          </tr>
        `
    }
})
