class QuestionsChannel < ApplicationCable::Channel
  # 1. подписка на QuestionsChannel
  def subscribed
    stream_from "questions"
  end
end