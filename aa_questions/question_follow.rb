require_relative 'question_database'
require_relative 'user'

class QuestionFollow
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollow.new(datum) }
  end

  def self.find_by_id(id)
    question_follow = QuestionDBConnection.instance.execute(<<-SQL, id)

      SELECT
      *
      FROM
      question_follows
      WHERE
      id = ?

    SQL

    return nil if question_follow.empty?

    QuestionFollow.new(question_follow.first)
  end

  def self.followers_for_question_id(question_id)
    followers = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.fname, users.lname
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL

    return nil if followers.empty?

    followers.map {|datum| User.new(datum)}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        title, body, author_id
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?
    SQL

    return nil if questions.empty?

    questions.map {|datum| Question.new(datum)}
  end

  def self.most_followed_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
    SELECT
      title, body, author_id
    FROM
      question_follows
    JOIN
      questions ON question_follows.question_id = questions.id
    GROUP BY
      question_id
    ORDER BY COUNT(question_id) DESC
    LIMIT ?
    SQL

    return nil if questions.empty?

    questions
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
