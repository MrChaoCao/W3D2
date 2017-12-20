require_relative 'question_database'
require_relative 'user'
require_relative 'question'

class Reply
  attr_accessor :user_id, :question_id, :parent_id, :body

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_id(id)
    reply = QuestionDBConnection.instance.execute(<<-SQL, id)

      SELECT
      *
      FROM
      replies
      WHERE
      id = ?

    SQL

    return nil if reply.empty?

    Reply.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    user_reply = QuestionDBConnection.instance.execute(<<-SQL, user_id)

      SELECT
      *
      FROM
      replies
      WHERE
      user_id = ?

    SQL

    return nil if user_reply.empty?

    Reply.new(user_reply.first)
  end

  def self.find_by_question_id(question_id)
    question_reply = QuestionDBConnection.instance.execute(<<-SQL, question_id)

    SELECT
    *
    FROM
    replies
    WHERE
    question_id = ?

    SQL

    return nil if question_reply.empty?

    question_reply.map {|datum| Reply.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_id = options['parent_id']
    @body = options['body']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    children = []

    relative_replies = Reply.find_by_question_id(@question_id)

    relative_replies.each do |rep|
      children << rep if rep.parent_id == @id
    end

    children
  end

end
